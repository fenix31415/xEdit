{
  Here should be a description
  -----
  
}

unit WeapGrep;
uses mteFunctions, uselesscore;

var files:Tstringlist;

function Initialize: integer;
begin
  ScriptProcessElements := [etFile];
  files:=Tstringlist.create;
end;

function isnormweap(e:IInterface):boolean;
var s:string;
begin
  s := editorid(e);
  result := not containstext(s, 'bound')
            and not containstext(s, 'ghost')
            and not containstext(s, 'Phantom')
            and not containstext(s, 'Dummy')
            and not containstext(name(e), 'Призванн')
            ;
end;

function getAnimType(e:IInterface):string;
var s:string;
begin
  s := geev(e, 'DNAM\Animation Type');
  result := 'unk';
  if sametext(s, 'OneHandSword')  then result := 'OSwo';
  if sametext(s, 'OneHandDagger') then result := 'ODag';
  if sametext(s, 'OneHandAxe')    then result := 'OAxe';
  if sametext(s, 'OneHandMace')   then result := 'OMac';
  if sametext(s, 'TwoHandSword')  then result := 'TSwo';
  if sametext(s, 'TwoHandAxe')    then result := 'TAxe';
end;

procedure dosmth(e:IInterface);
var t:string;
    wei:integer;
    i:integer;
begin
  t := getAnimType(e);
  if (sametext(t, 'OSwo') or sametext(t, 'ODag') or sametext(t, 'OAxe') or sametext(t, 'OMac')
      or sametext(t, 'TSwo') or sametext(t, 'TAxe')) and isnormweap(e) then
    addmessage(t + ' ' + inttohex(fixedformid(e), 8) + ' ' + geev(e, 'DATA\Weight'));
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
  files.add(getfilename(e));
end;

procedure processfiles();
var i:integer;
begin
  for i := 0 to files.count-1 do
    processFile(filebyname(files[i]), 'WEAP');
end;

function Finalize(): Integer;
var i:integer;
begin
  processfiles();

  files.free;
end;

end.
