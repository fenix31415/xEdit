{
  Here should be a description
  -----
  
}
unit DoubleIT;
uses mteFunctions, uselessCore;

const SOURCE_FILE_NAME = 'CBOS.esp';
      PATCH_FILE_NAME = '00_CBOS.esp';
var
  sourcePrefix:string;

function Initialize: integer;
begin
  ScriptProcessElements := [etFile];
  files := TStringList.Create;
  sourcePrefix := getPrefixByFileName(SOURCE_FILE_NAME);
end;

function process(e:IInterface):integer;
begin
  files.AddObject(GetFileName(e), TObject(e));
end;

function Finalize: Integer;
begin
  files.Sort;
  if not initNewOrExistingFile(PATCH_FILE_NAME) then begin
    addmessage('no file selected, exiting..');
    result := 1;
    exit;
  end;
  
  AddMasterIfMissing(patchFile, 'Skyrim.esm');
  AddMasterIfMissing(patchFile, 'Update.esm');
  AddMasterIfMissing(patchFile, 'Dawnguard.esm');
  AddMasterIfMissing(patchFile, 'HearthFires.esm');
  AddMasterIfMissing(patchFile, 'Dragonborn.esm');
  
  main();
  
  CleanMasters(patchFile);
  files.Free;
end;

procedure main();
var fromRecord, cur, win: IInterface;
    i:integer;
begin
  fromRecord := RecordByHex('0001E715');
  for i := ReferencedByCount(fromRecord)- 1 downto 0 do begin
    cur := ReferencedByIndex(fromRecord, i);
    if not isInGroup(cur, 'WEAP') then continue; // if record is not WEAP
    
    if not shouldI(GetFileName(getfile(cur))) then continue;  // if record is not in dedicated file
    
    win := WinningOverride(cur);
    if checkETIM(win) then continue; // has enchants
    
    // is already modified
    if StrEndsWith(GetEditValue(ElementBySignature(win, 'FULL')), 'Ë¸ãêèé)') then continue;
    if StrEndsWith(GetEditValue(ElementBySignature(win, 'FULL')), 'Ëåãêèé)') then continue;
    if StrEndsWith(GetEditValue(ElementBySignature(win, 'FULL')), 'Òÿæåëûé)') then continue;
    if StrEndsWith(GetEditValue(ElementBySignature(win, 'FULL')), 'Òÿæ¸ëûé)') then continue;
    
    dodoubleIt(win);
  end;
end;

function checkETIM(e:IInterface): boolean;
begin
  result:=assigned(ElementBySignature(e, 'EITM'));
end;

procedure addSuffixToName(el:IInterface; suff:string);
var toStr:string;
begin
  toStr:=GetEditValue(el) + suff;
  SetEditValue(el, toStr);
end;

procedure changeIntValueBy(el:IInterface; delta:integer);
var val:integer;
begin
  val:=strtoint(GetEditValue(el)) + delta;
  SetEditValue(el, inttostr(val));
end;

procedure changeFloatValueBy(el:IInterface; delta:float);
var val:float;
begin
  val:=strtofloat(GetEditValue(el)) + delta;
  SetEditValue(el, floattostr(val));
end;

function decreaseAndNormalize(val, x:float):float;
begin
  val := val - x * val;
  val := roundto(val, -3);
  val := val * 100;
  val := floor(val);
  val := val / 100;
  result := val;
end;

procedure changeScaled(el:IInterface; x:float);
var val:float;
begin
  val := strtofloat(GetEditValue(el));
  val := decreaseAndNormalize(val, x);
  SetEditValue(el, floattostr(val));
end;

procedure changeData(e:IInterface);
begin
  addSuffixToName(ElementBySignature(e, 'FULL'), ' (Ë¸ãêèé)');
  changeIntValueBy(ElementByIndex(ElementBySignature(e, 'DATA'), 2), -2);
  changeScaled(ElementByIndex(ElementBySignature(e, 'DNAM'), 2), RandomRange(0, 100 + 1) / 1000); // speed
  SetEditValue(ElementByIndex(ElementBySignature(e, 'DNAM'), 26), floattostr(0.1)); // stagger
end;

function pickRandomEnchant():integer;
begin
  result := RandomRange($DAAA50,$DAAA56+1+1);
  if result = $DAAA56+1 then result := $DAAA4D;
end;

procedure addEnchant(e:IInterface);
var element, enchs:IInterface;
    enchId:string;
begin
  if not assigned(ElementBySignature(e, 'EITM')) then
    enchs := Add(e, 'EITM', true) // we know that it always adds but why not
  else enchs := ElementByPath(e, 'EITM');
  enchId := sourcePrefix + inttohex(pickRandomEnchant(),6);
  SetEditValue(enchs, name(RecordByHex(enchId)));
end;

procedure changeData_heavy(e:IInterface);
var newKywd:IInterface;
begin
  addSuffixToName(ElementBySignature(e, 'FULL'), ' (Òÿæ¸ëûé)');
  addEnchant(e);
  newKywd := ElementAssign(ElementByPath(e, 'KWDA'), HighInteger, Nil, false);
  SetEditValue(newKywd, 'MagicDisallowEnchanting [KYWD:000C27BD]'); // without check
  changeIntValueBy(ElementByIndex(ElementBySignature(e, 'DATA'), 0), 10);
  changeFloatValueBy(ElementByIndex(ElementBySignature(e, 'DATA'), 1), 1);  // weight
  changeScaled(ElementByIndex(ElementBySignature(e, 'DNAM'), 2), RandomRange(400, 600 + 1) / 1000); // speed
end;

function findCraft(e:IInterface):IInterface;
var i:integer;
    cur, craft:IInterface;
begin
  for i := ReferencedByCount(e)-1 downto 0 do begin
    cur := ReferencedByIndex(e, i);
    if not SameText(signature(cur), 'COBJ') then continue;
    cur := winningoverride(cur);
    craft := ElementBySignature(cur, 'CNAM');
    if not assigned(craft) then begin
      addmessage('no CNAM, skipin: '+name(cur)+' ,___ workbench:'+GetEditValue(ElementBySignature(cur, 'BNAM')));
      exit;
    end;
    if EditorID(LinksTo(craft)) <> EditorID(e) then continue;
    // now seems we found it
    
    if SameText (GetEditValue(ElementBySignature(cur, 'BNAM')), 'CraftingSmithingSharpeningWheel [KYWD:00088108]') then begin
      result:=cur;
      exit;
    end;
  end;
end;

function addItemToCraft(craftItems: IInterface; whatToAddId: string; amount: integer): IInterface;
var newItem:IInterface;
begin
  newItem := ElementAssign(craftItems, HighInteger, nil, false);
  result:=addItemToCraft_(craftItems, newItem, whatToAddId, amount);
end;

function addItemToCraft_(craftItems, newItem: IInterface; whatToAddId: string; amount: integer): IInterface;
begin
  SetElementEditValues(newItem, 'CNTO - Item\Item', whatToAddId);
  SetElementEditValues(newItem, 'CNTO - Item\Count', amount);
  Result := newItem;
end;

procedure changeCraft_heavy(craft, bow, bow_heavy:IInterface);
var craftItems,item, conditions, element:IInterface;
    i:integer;
begin
  Remove(ElementByPath(craft, 'Items'));
  craftItems := Add(craft, 'Items', true);
  addItemToCraft_(craftItems, ElementByIndex(craftItems, 0), '0000000F', randomrange(500,2500+1));
  addItemToCraft(craftItems, inttohex(GetLoadOrderFormID(bow),8), 1);
  addItemToCraft(craftItems, sourcePrefix + 'DA072E', 1);
  
  conditions := ElementByPath(craft, 'Conditions');
  if not assigned(conditions) then begin
    conditions := Add(craft, 'Conditions', True);
    element := ElementByIndex(conditions, 0);
  end else begin
    element := ElementAssign(conditions, HighInteger, nil, False);
  end;
  seev(element, 'CTDA - CTDA\Type', '10000000'); // ==
  seev(element, 'CTDA - CTDA\Comparison Value - Float', floattostr(1));
  seev(element, 'CTDA - CTDA\Function', 'HasPerk');
  seev(element, 'CTDA - CTDA\Perk', name(RecordByHex(sourcePrefix+'DAFBC1')));
  
  element := ElementAssign(conditions, HighInteger, nil, False);
  seev(element, 'CTDA - CTDA\Type', '11000000'); // >=
  seev(element, 'CTDA - CTDA\Comparison Value - Float', floattostr(1));
  seev(element, 'CTDA - CTDA\Function', 'GetItemCount');
  seev(element, 'CTDA - CTDA\Inventory Object', name(bow));
  seev(craft, 'CNAM', name(bow_heavy));
  seev(craft, 'BNAM', name(RecordByHex(sourcePrefix+'000D66')));
end;

procedure changeCraft_crossbow_heavy(craft, crossbow, bow_heavy:IInterface);
var craftItems,item, conditions, element:IInterface;
    i:integer;
begin
  Remove(ElementByPath(craft, 'Items'));
  craftItems := Add(craft, 'Items', true);
  addItemToCraft_(craftItems, ElementByIndex(craftItems, 0), sourcePrefix + 'DAAA9F', 1);
  addItemToCraft(craftItems, inttohex(GetLoadOrderFormID(crossbow),8), 1);
  
  conditions := ElementByPath(craft, 'Conditions');
  if not assigned(conditions) then begin
    conditions := Add(craft, 'Conditions', True);
    element := ElementByIndex(conditions, 0);
  end else begin
    element := ElementAssign(conditions, HighInteger, nil, False);
  end;
  seev(element, 'CTDA - CTDA\Type', '11000000'); // >=
  seev(element, 'CTDA - CTDA\Comparison Value - Float', floattostr(1));
  seev(element, 'CTDA - CTDA\Function', 'GetItemCount');
  seev(element, 'CTDA - CTDA\Inventory Object', name(crossbow));
  
  seev(craft, 'CNAM', name(bow_heavy));
  
  seev(craft, 'BNAM', name(RecordByHex(sourcePrefix+'04ED56')));
end;

procedure changeEdid(rec:IInterface);
var edid:string;
begin
  edid:=GetElementEditValues(rec, 'EDID');
  edid:=edid+'_heavy';
  SetElementEditValues(rec, 'EDID', edid);
end;

procedure changeCraft_crossbow(craft:IInterface);
var craftItems,item:IInterface;
    i:integer;
    s,id:string;
begin
  craftItems := ElementByPath(craft, 'Items');
  addItemToCraft(craftItems, sourcePrefix + 'DAAA9F', 1);
  addItemToCraft(craftItems, sourcePrefix + 'DA0731', 2);
  seev(craft, 'BNAM', name(recordByHex(sourcePrefix+'04ED56')));
end;

procedure changeCraft_crossbow_heavyT(craft, crossbow_heavy:IInterface);
var craftItems,item:IInterface;
    i:integer;
    s,id:string;
begin
  changeCraft_crossbow(craft);
  seev(craft, 'CNAM', name(crossbow_heavy));
end;

procedure changeCraft_(craft:IInterface);
var craftItems,item:IInterface;
    i:integer;
    s,id:string;
begin
  craftItems := ElementByPath(craft, 'Items');
  addItemToCraft(craftItems, sourcePrefix + 'DA072E', 1);
  addItemToCraft(craftItems, sourcePrefix + 'DA0731', 2);
  seev(craft, 'BNAM', name(recordByHex(sourcePrefix+'002327')));
end;

procedure changeCraft_heavyT(craft, bow_heavy:IInterface);
var craftItems,item:IInterface;
    i:integer;
    s,id:string;
begin
  changeCraft_(craft);
  seev(craft, 'CNAM', name(bow_heavy));
end;

procedure dodoubleIt_bow(e, craft:IInterface);
var bow_heavy:IInterface;
begin
  bow_heavy := normCopyWithPrefix(e, '', '', '_heavy');
  changeData_heavy(bow_heavy);
  changeData(normCopy(e));
  changeCraft_heavy(normCopyWithPrefix(craft, '', '', '_heavy'), e, bow_heavy);  // getting heavy bow
  changeCraft_heavyT(normCopyWithPrefix(craft, '', '', '_heavyT'), bow_heavy);  // upgrade heavy bow
  changeCraft_(normCopy(craft));  // upgrade
end;

procedure changeData_crossbow(e:IInterface);
begin
  addSuffixToName(ElementBySignature(e, 'FULL'), ' (Ë¸ãêèé)');
  changeIntValueBy(ElementByIndex(ElementBySignature(e, 'DATA'), 2), -4);
end;

procedure dodoubleIt_crossbow(e, craft:IInterface);
var crossbow_heavy:IInterface;
begin
  crossbow_heavy := normCopyWithPrefix(e, '', '', '_heavy');
  changeData_heavy(crossbow_heavy);
  changeData_crossbow(normCopy(e));
  changeCraft_crossbow_heavy(normCopyWithPrefix(craft, '', '', '_heavy'), e, crossbow_heavy);  // getting heavy crossbow
  changeCraft_crossbow_heavyT(normCopyWithPrefix(craft, '', '', '_heavyT'), crossbow_heavy);  // upgrade heavy crossbow
  changeCraft_crossbow(normCopy(craft));  // upgrade
end;

/// e is winning
procedure dodoubleIt(e:IInterface);
var craft, bow_heavy:IInterface;
    animType:string;
begin
  craft := findCraft(e);
  if not assigned(craft) then exit;
  
  addmessage('doublingit:' + name(e));
  
  AddMasterIfMissing(patchFile, SOURCE_FILE_NAME);
  AddMasterIfMissing(patchFile, getfilename(getfile(e)));
  AddMasterIfMissing(patchFile, getfilename(getfile(MasterOrSelf(e))));
  
  animType := GetEditValue(ElementByIndex(ElementBySignature(e, 'DNAM'),0));
  if SameText(animType, 'bow') then dodoubleIt_bow(e, craft)
  else if SameText(animType, 'crossbow') then dodoubleIt_crossbow(e, craft)
  else addmessage('unknown animType: '+ name(e));
end;

end.
