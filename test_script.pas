{
  Here should be a description
  -----
  Hotkey: Ctrl+F10
}

unit TestUserScript;
uses mteFunctions, uselesscore;

function Initialize: integer;
var tmp, efile:IInterface;
    s:string;
    i:integer;
    rec: ZoneInfo;
begin
  ScriptProcessElements := [etFile];
end;

procedure dosmth(e:IInterface);
var s:string;
    i:integer;
begin
  if containstext(name(e), 'swamp') then
    dbg(name(e));
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
  processFile(e, 'NPC_');
end;

function Finalize(): Integer;
var i:integer;
    e, g:IInterface;
begin
  
end;

end.
