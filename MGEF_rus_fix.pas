{
  Here should be a description
  -----
  
}

unit TestUserScript;
uses mteFunctions, uselesscore;

const PATCH_FILE_NAME = 'magic_fix.esp';

function Initialize: integer;
begin
  ScriptProcessElements := [etFile];
  if not initNewOrExistingFile(PATCH_FILE_NAME) then begin
    addmessage('no file selected, exiting..');
    result := 1;
    exit;
  end;
end;

procedure dosmth(e:IInterface);
begin
  if containstext(geev(e, 'DNAM'), '<маг>') then begin
    e := copywithmasters(e);
    seev(e, 'DNAM', StringReplace(geev(e, 'DNAM'), '<маг>', '<mag>', [rfReplaceAll, rfIgnoreCase]));
    dbg('fixed stupid translators error at: ' + name(e));
  end else
  
  if (assigned(ebp(e, 'DNAM')) <> assigned(ebp(masterorself(e), 'DNAM')))
      or sametext(trim(geev(e, 'DNAM')), '')
      and not sametext(trim(geev(masterorself(e), 'DNAM')), '') then
    copywithmasters(e);  // empty description
end;

procedure processFile(e:IInterface; sig: string);
var item:IInterface;
    i:integer;
begin
  e := GroupBySignature(e, sig);
  if not assigned(e) then exit;
  for i:=0 to ElementCount(e)-1 do begin
    item := ElementByIndex(e, i);
    if not IsMaster(item) then continue;
    item := WinningOverride(item);
    if GetIsDeleted(item) then continue;
    
    dosmth(item);
  end;
end;

function process(e:IInterface):integer;
begin
  processFile(e, 'MGEF');
end;

function Finalize(): Integer;
begin
  CleanMasters(patchFile);
end;

end.