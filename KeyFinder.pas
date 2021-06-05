{
  Here should be a description
  -----
  
}

unit TestUserScript;
uses mteFunctions, uselesscore;

const SOME_LVL_NPC_NAME = 'some lvl npc';
      ONE_OF_NPC_SUFFIX = ' (one of)';
      
      FORMAT_REFR = 'Somewhere in %s';
      FORMAT_NPC_ = 'Character: "%s"';
      FORMAT_CONT = 'Inside "%s" at %s';

function isInPocket(key, e:IInterface):boolean;
var i:integer;
    item:IInterface;
begin
  e := ebp(e, 'Items');
  if assigned(e) then begin
    for i:=0 to elementcount(e)-1 do begin
      item := elementbyindex(e, i);
      if equals(WinningOverride(linksto(ebp(item, 'CNTO\Item'))), key) then result := true;
    end;
  end;
end;

function isGivenbyScript(key, e:IInterface):boolean;
var i, j:integer;
    script, prop:IInterface;
begin
  e := ebp(e, 'VMAD\Scripts');
  if assigned(e) then begin
    for i:=0 to elementcount(e)-1 do begin
      script := elementbyindex(e, i);
      if sametext(geev(script, 'ScriptName'), 'defaultAddItemKeyScript') then begin
        script := ebp(script, 'Properties');
        for j:=0 to elementcount(script)-1 do begin
          prop := elementbyindex(script, j);
          if sametext(geev(prop, 'propertyName'), '_KeyToAdd')
            and equals(WinningOverride(linksto(ebp(prop, 'Value\Object Union\Object v2\FormID'))), key) then result := true;
        end;
      end;
    end;
  end;
end;

function isPlayerHouseKey(key, e:IInterface):boolean;
var i, j:integer;
    script, prop:IInterface;
begin
  e := ebp(e, 'VMAD\Scripts');
  if assigned(e) then begin
    for i:=0 to elementcount(e)-1 do begin
      script := elementbyindex(e, i);
      if sametext(geev(script, 'ScriptName'), 'QF_HousePurchase_000A7B33') then begin
        script := ebp(script, 'Properties');
        for j:=0 to elementcount(script)-1 do begin
          prop := elementbyindex(script, j);
          if containstext(geev(prop, 'propertyName'), 'key')
            and equals(WinningOverride(linksto(ebp(prop, 'Value\Object Union\Object v2\FormID'))), key) then result := true;
        end;
      end;
    end;
  end;
end;

function isInLVLI(key, e:IInterface):boolean;
var i:integer;
    item:IInterface;
begin
  e := ebp(e, 'Leveled List Entries');
  if assigned(e) then begin
    for i:=0 to elementcount(e)-1 do begin
      item := elementbyindex(e, i);
      if equals(WinningOverride(linksto(ebp(item, 'LVLO\Reference'))), key) then result := true;
    end;
  end;
end;

function getNPC_Name(e:IInterface; oneof:boolean):string;
begin
  if sametext(signature(e), 'NPC_') then begin
    result := geev(e, 'FULL');
    if sametext(result, '') then begin
      e := WinningOverride(linksto(ebp(e, 'TPLT')));
      if sametext(signature(e), 'LVLN') then result := SOME_LVL_NPC_NAME
      else begin
        if oneof then
          result := getNPC_Name(e, true)
        else
          result := getNPC_Name(e, true) + ONE_OF_NPC_SUFFIX;
      end;
    end;
    
    if sametext(result, '') then
      warn(name(e) + ' hasnt name');
  end else if sametext(signature(e), 'ACHR') then begin
    result := getNPC_Name(WinningOverride(linksto(ebp(e, 'NAME'))), oneof);
  end else warn('unknown signature ' + name(e));
end;

function getWorldSpace(e:IInterface):IInterface;
begin
  if not assigned(e) then exit;
  if sametext(signature(e), 'WRLD') then result := WinningOverride(e)
  else result := getWorldSpace(ChildrenOf(GetContainer(e)));
end;

function mb_getWorldSpaceName(e:IInterface):string;
var ans:IInterface;
begin
  ans := getWorldSpace(e);
  if assigned(ans) then
    result := geev(ans, 'FULL');
end;

function getREFRName(e:IInterface):string;
var wrldname:string;
begin
  wrldname := mb_getWorldSpaceName(e);
  result := geev(ChildrenOf(GetContainer(e)), 'FULL');
  if sametext(result, '') then result := editorid(ChildrenOf(GetContainer(e)));
  if sametext(result, '') then result := '"' + wrldname + '"'
  else if not sametext(wrldname, '') then
    result := '"' + result + '"' + ' (' + wrldname + ')'
    else result := '"' + result + '"';
  
  if sametext(result, '') then warn('cant get loc name for ' + name(e));
end;

function getAnsStr(ans:IInterface; foundtype:string):string;
begin
  if          sametext(foundtype, 'REFR') then begin
    result := Format(FORMAT_REFR, [getREFRName(ans)]);
  end else if sametext(foundtype, 'NPC_') then begin
    result := Format(FORMAT_NPC_, [getNPC_Name(ans, false)]);
  end else if sametext(foundtype, 'CONT') then begin
    result := Format(FORMAT_CONT, [geev(WinningOverride(linksto(ebp(ans, 'NAME'))), 'FULL'), getREFRName(ans)]);
  end else warn('unknown type ' + foundtype + ' for ' + name(e));
end;

procedure printAns(key, ans:IInterface; foundtype:string);
begin
  key := masterorself(key);
  ans := masterorself(ans);
  addmessage(inttohex(GetLoadOrderFormID(key), 8) + ' ' + getAnsStr(ans, foundtype));
end;

procedure findKeyInWorld(key:IInterface:string);
var i, j:integer;
    e, r:IInterface;
begin
  for i:=0 to ReferencedByCount(key)-1 do begin
    e := ReferencedByIndex(key, i);
    if not IsWinningOverride(e) then continue;
    
    if sametext(signature(e), 'REFR') then begin
      if sametext(geev(e, 'NAME'), name(key)) then begin
        printAns(key, e, 'REFR');
      end;
    end;
    if sametext(signature(e), 'NPC_') then begin
      if isInPocket(key, e) then begin
        printAns(key, e, 'NPC_');
      end;
    end;
    if sametext(signature(e), 'CONT') and
        not sametext(editorid(e), 'QAKeyContainer') and
        not sametext(editorid(e), 'DLC01QAAllItems') and
        not sametext(editorid(e), 'DLC02QAKeyContainer') then begin
      if isInPocket(key, e) then begin
        for j:=0 to referencedbycount(e)-1 do begin
          r := referencedbyindex(e, j);
          if not IsWinningOverride(r) then continue;
          if not sametext(signature(r), 'REFR') then continue;
          if equals(WinningOverride(linksto(ebp(r, 'NAME'))), e) then
            printAns(key, r, 'CONT');
        end;
      end;
    end;
    if sametext(signature(e), 'ACHR') then begin
      if isGivenbyScript(key, e) then begin
        printAns(key, e, 'NPC_');
      end;
    end;
    if sametext(signature(e), 'LVLI') then begin
      if isInLVLI(key, e) then begin
        for j:=0 to referencedbycount(e)-1 do begin
          r := referencedbyindex(e, j);
          if not IsWinningOverride(r) then continue;
          if not sametext(signature(r), 'NPC_') then continue;
          if equals(WinningOverride(linksto(ebp(r, 'INAM'))), e) then
            printAns(key, r, 'NPC_');
        end;
      end;
    end;
    {if sametext(signature(e), 'QUST') then begin
      if isPlayerHouseKey(key, e) then begin
        printAns(key, e, 'NPC_');
      end;
    end;}
  end;
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
    
    findKeyInWorld(item);
  end;
end;

function Initialize: integer;
begin
  ScriptProcessElements := [etFile];
end;

function process(e:IInterface):integer;
begin
  processFile(e, 'KEYM');
  //findKeyInWorld(e);
  //dbg(name(getWorldSpace(e)));
end;

function Finalize(): Integer;
begin
end;

end.
