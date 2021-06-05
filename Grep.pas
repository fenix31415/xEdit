{
  Here should be a description
  -----
  Hotkey: Ctrl+F11
}

unit Grep;
uses mteFunctions, uselesscore;

var
  patchFile: IInterface;

function Initialize: integer;
var tmp, efile:IInterface;
    s:string;
    i:integer;
    rec: ZoneInfo;
begin
  ScriptProcessElements := [etFile];
end;

procedure grepScripts(scripts:IInterface; prefix:string);
var i:integer;
begin
  if not assigned(scripts) then exit;
  for i := 0 to ElementCount(scripts)-1 do begin
    addmessage(prefix + geev(Elementbyindex(scripts, i), 'ScriptName'));
  end;
end;

procedure grepFileSubGroup(subGroup:IInterface);
var i:integer;
    cur:IInterface;
begin
  if not assigned(subGroup) then exit;
  
  for i:=0 to ElementCount(subGroup)-1 do begin
    cur := ElementByIndex(subGroup, i);
    if not IsMaster(cur) then continue;
    if not sametext(Signature(cur), 'REFR') then continue;
    cur := WinningOverride(cur);
    grepScripts(elementbypath(cur, 'VMAD\Scripts'), 
        '(' + 'REFR' + ') (' + getfilename(GetFile(cur)) + ') ' + shortname(cur) + '->' );
  end;
end;

procedure grepFileCell(e:IInterface);
var i, j, k, l:integer;
    block, sublock, cell, subGroup, cur:IInterface;
begin
  e := GroupBySignature(e, 'CELL');
  if not assigned(e) then exit;
  
  for i:=0 to ElementCount(e)-1 do begin
    block := ElementByIndex(e, i);
    for j:=0 to ElementCount(block)-1 do begin
      sublock := ElementByIndex(block, j);
      for k:=0 to ElementCount(sublock)-1 do begin
        cell := ElementByIndex(sublock, k);
        grepFileSubGroup(FindChildGroup(ChildGroup(cell), 9, cell));  // Temporary
        grepFileSubGroup(FindChildGroup(ChildGroup(cell), 8, cell));  // Persistent
      end;
    end;
  end; 
end;

procedure grepFileGroup(file:IInterface; sig:string);
var group, item, script, aliases:IInterface;
    i, j, k:integer;
begin
  group := GroupBySignature(file, sig);
  if not assigned(group) then exit;
  for i:=0 to ElementCount(group)-1 do begin
    item := ElementByIndex(group, i);
    
    grepScripts(elementbypath(item, 'VMAD\Scripts'), 
      '(' + sig + ') (' + name(file) + ') ' + name(item) + '->' );
    
    if not sametext(sig, 'QUST') then continue;
    
    // aliases
    aliases := elementbypath(item, 'VMAD\Aliases');
    if not assigned(aliases) then continue;
    
    for j := 0 to ElementCount(aliases)-1 do begin
      grepScripts(elementbypath(Elementbyindex(aliases, j), 'Alias Scripts'),
        '(' + sig + ', AL) (' + name(file) + ') ' + editorid(item) + '->' );
    end;
    
    // fragments
    aliases := ebp(item, 'VMAD\Script Fragments\Fragments');
    if not assigned(aliases) then continue;
    
    for j := 0 to ElementCount(aliases)-1 do begin
      addmessage('(FRAG) (' + name(file) + ') ' + editorid(item) + '->' + geev(elementbyindex(aliases, j), 'ScriptName'));
    end;
    
  end;
end;

procedure grepFileDial(e:IInterface);
var i, j:integer;
    cur, curr:IInterface;
begin
  e := groupbysignature(e, 'DIAL');
  for i := 0 to elementcount(e) - 1 do begin
    curr := elementbyindex(e, i);
    for j := 0 to elementcount(curr) - 1 do begin
      cur := elementbyindex(curr, j);
      grepScripts(elementbypath(cur, 'VMAD\Scripts'), 
        '(' + 'INFO' + ') (' + getfilename(GetFile(cur)) + ') ' + shortname(cur) + '->' );
    end;
  end;
end;

function process(e:IInterface):integer;
var i:integer;
begin
  grepFileDial(e);
  grepFileCell(e);
  grepFileGroup(e, 'QUST');
  grepFileGroup(e, 'ACTI');
  grepFileGroup(e, 'APPA');
  grepFileGroup(e, 'ARMO');
  grepFileGroup(e, 'BOOK');
  grepFileGroup(e, 'CONT');
  grepFileGroup(e, 'DIAL');
  grepFileGroup(e, 'DOOR');
  grepFileGroup(e, 'EXPL');
  grepFileGroup(e, 'FLOR');
  grepFileGroup(e, 'FURN');
  grepFileGroup(e, 'INFO');
  grepFileGroup(e, 'INGR');
  grepFileGroup(e, 'KEYM');
  grepFileGroup(e, 'LIGH');
  grepFileGroup(e, 'MGEF');
  grepFileGroup(e, 'MISC');
  grepFileGroup(e, 'NPC_');
  grepFileGroup(e, 'PACK');
  grepFileGroup(e, 'PERK');
  grepFileGroup(e, 'SCEN');
  grepFileGroup(e, 'TACT');
  grepFileGroup(e, 'TREE');
  grepFileGroup(e, 'WEAP');
  
end;

end.
