{
  Here should be a description
  -----
  
}

unit RGBArmor;
uses mteFunctions, uselesscore;

const PATCH_FILE_NAME  = 'RGBArmor.esp';
      SOURCE_FILE_NAME = 'Ursine Armour HDT SMP SE.esp';

var knownColors, knownBases, knownPossibleBases, colorToDye:TStringList;
    SourcePrefix:string;

procedure patch();
begin
  
end;

procedure initColors();
begin
  knownColors := TStringList.create;
  knownBases := TStringList.create;
  knownPossibleBases := TStringList.create;
  colorToDye := TStringList.create;
  
  
  /// --------   from `ID` to dye   ------------
  
  colorToDye.Values['red']    := '013600';
  colorToDye.Values['blue']   := '0135FA';
  colorToDye.Values['black']  := '0135F9';
  colorToDye.Values['white']  := '013601';
  colorToDye.Values['green']  := '0135FC';
  colorToDye.Values['brown']  := '0135FB';
  colorToDye.Values['yellow'] := '013602';
  colorToDye.Values['blue-red']     := '0135FA-013600';
  colorToDye.Values['blue-white']   := '0135FA-013601';
  colorToDye.Values['red-yellow']   := '013600-013602';
  colorToDye.Values['black-yellow'] := '0135F9-013602';
  colorToDye.Values['black-white']  := '0135F9-013601';
  colorToDye.Values['yellow-white'] := '013602-013601';
  colorToDye.Values['black-orange'] := '0135F9-0135FD';
  colorToDye.Values['blue-red-white'] := '0135FA-013600-013601';
  colorToDye.Values['black-white-yellow'] := '0135F9-013601-013602';
  
  
  /// --------   from COLOR to `ID`   ------------
  
  knownColors.Values['RedGold']      := 'red-yellow';
  knownColors.Values['GreyGold']     := 'black-white-yellow';
  knownColors.Values['PurpleSilver'] := 'blue-red-white';
  knownColors.Values['blueSilver']   := 'blue-white';
  knownColors.Values['Gold']         := 'yellow';
  knownColors.Values['Silver']       := 'white';
  knownColors.Values['Red']          := 'red';
  knownColors.Values['Pearl']        := 'blue-red';
  knownColors.Values['Purple']       := 'blue-red';
  knownColors.Values['Green']        := 'green';
  knownColors.Values['Grey']         := 'black-white';
  knownColors.Values['blue']         := 'blue';
  knownColors.Values['black']        := 'black';
  
  //knownColors.Values['honeyblonde'] := 'yellow';
  //knownColors.Values['LightBlonde'] := 'yellow-white';
  //knownColors.Values['DarkBrown']   := 'black-yellow';
  //knownColors.Values['BLKGLD']      := 'black';
  //knownColors.Values['olive']       := 'black-yellow';
  
  //knownColors.Values['grey']  := 'black-white';
  //knownColors.Values['auburn']   := 'black-orange';
  //knownColors.Values['chesnut']  := 'brown';
  //knownColors.Values['volcanic'] := 'brown';
  //knownColors.Values['black'] := 'black';
  //knownColors.Values['green'] := 'green';
  //knownColors.Values['EMRLD'] := 'green';
  //knownColors.Values['purple'] := 'blue-red';
  //knownColors.Values['Emerald'] := 'green';
  //knownColors.Values['white'] := 'white';
  //knownColors.Values['Frostbite'] := 'white';
  //knownColors.Values['Poison'] := 'green';
  //knownColors.Values['blue']  := 'blue';
  //knownColors.Values['WHT']   := 'white';
  //knownColors.Values['red']   := 'red';
  //knownColors.Values['ice']   := 'white';
  //knownColors.Values['BLK']   := 'black';
  //knownColors.Values['BLU']   := 'blue';
  //knownColors.Values['PUR']   := 'blue-red';
  
  //knownColors.Values['RG']   := 'yellow';
  //knownColors.Values['E']   := 'green';
  //knownColors.Values['F']   := 'white';
  //knownColors.Values['P']   := 'black';
  //knownColors.Values['W']   := 'blue-red';
  
end;

function Initialize: integer;
begin
  if not initNewOrExistingFile(PATCH_FILE_NAME) then begin
    addmessage('no file selected, exiting..');
    result := 1;
    exit;
  end;
  
  AddMasterIfMissing(patchFile, 'Skyrim.esm');
  AddMasterIfMissing(patchFile, 'Update.esm');
  AddMasterIfMissing(patchFile, 'Dawnguard.esm');
  AddMasterIfMissing(patchFile, 'Dragonborn.esm');
  AddMasterIfMissing(patchFile, SOURCE_FILE_NAME);
  
  ScriptProcessElements := [etFile];
  
  SourcePrefix := getPrefixByFileName(SOURCE_FILE_NAME);
  
  initColors();
  patch();
end;

function getColor(e:IInterface):string;
var i:integer;
    cur:string;
begin
  if sametext(EditorID(e), 'DX_CrimsonBlood_Earrings') then exit;

  for i := 0 to knownColors.count-1 do begin
    cur := knownColors.Names[i];
    if Containstext(EditorID(e), cur) then begin
      //result := knownColors.ValueFromIndex[i];
      result := cur;
      exit;
    end;
  end;
end;

function findColoredBase(s:string):IInterface;
var searchStr:string;
    i:integer;
    cur:IInterface;
begin
  for i := 0 to knownPossibleBases.count-1 do begin
    cur := unPack(knownPossibleBases[i]);
    searchStr := StringReplace(EditorID(cur), 'white', '', [rfIgnoreCase]);
    if sametext(s, searchStr) then begin
      result := cur;
      exit;
    end;
  end;
  for i := 0 to knownPossibleBases.count-1 do begin
    cur := unPack(knownPossibleBases[i]);
    searchStr := StringReplace(EditorID(cur), 'black', '', [rfIgnoreCase]);
    if sametext(s, searchStr) then begin
      result := cur;
      exit;
    end;
  end;
end;

function findBase(s:string):IInterface;
var i:integer;
    cur:IInterface;
begin
  if containstext(s, 'AsharaPrinceWig') then begin
    result := unPack('AsharaPrinceOfTheWoods.esp$AsharaPrinceWigMediumBrown');
    exit;
  end;
  
  if containstext(s, 'DX_CrimsonBlood_Earrings') then begin
    result := unPack('Crimson_Blood_Armor.esp$DX_CrimsonBlood_EarringsR');
    exit;
  end;

  for i := 0 to knownBases.count-1 do begin
    cur := unPack(knownBases[i]);
    if sametext(s, EditorID(cur)) then begin
      result := cur;
      exit;
    end;
  end;
end;

function getDyeName(color:string):string;
var s:string;
begin
  s := colorToDye.values[knownColors.Values[color]];
  if not assigned(s) then begin
    s := colorToDye.Values['black'];
    warn('"' + color + '" unknown, returning black');
  end;
  result := s;
end;

procedure addDyes(items:IInterface; color:string);
var item:IInterface;
    dyes:TStringList;
    i:integer;
begin
  dyes := TStringList.create;
  dyes.Delimiter := '-';
  dyes.DelimitedText := getDyeName(color);
  for i := 0 to dyes.Count - 1 do begin
    item := ElementAssign(items, HighInteger, nil, False);
    seev(item, 'CNTO\Count', 1);
    seev(item, 'CNTO\Item', name(RecordByHex(sourcePrefix + dyes[i])));
  end;
end;

function findBase_(cnamEdid, color:string):IInterface;
var searchStr:string;
begin
  // attempt 1: try just cut of color from name
  searchStr := StringReplace(cnamEdid, color, '', [rfIgnoreCase]);
  result := findBase(searchStr);
  
  if assigned(result) then exit;
  
  // attempt 2: take all string before
  searchStr := copy(cnamEdid, 0, Pos(AnsiUpperCase(color), AnsiUpperCase(cnamEdid)) - 1);
  result := findBase(searchStr);
  if assigned(result) then exit;
  
  dbg('norm base not found, finding colored: ' + cnamEdid);
  
  // trying to find colored
  searchStr := StringReplace(cnamEdid, color, '', [rfIgnoreCase]);
  result := findColoredBase(searchStr);
  
  if assigned(result) then exit;
  
  // attempt 2: take all string before
  searchStr := copy(cnamEdid, 0, Pos(AnsiUpperCase(color), AnsiUpperCase(cnamEdid)) - 1);
  result := findColoredBase(searchStr);
  if assigned(result) then dbg('colored base found: ' + cnamEdid);
end;

procedure colorIt(e:IInterface);
var cnam, items, ne, rne, base, x:IInterface;
    color, searchStr, cnamEdid, cnamName:string;
begin
  //if not sametext(name(LinksTo(ebp(e, 'BNAM'))), 'CraftingSmithingForge [KYWD:00088105]') then exit;
  if containstext(EditorID(e), 'temper') then exit;
  
  cnam:=LinksTo(ebp(e, 'CNAM'));
  
  if not sametext(Signature(cnam), 'ARMO') then exit;
  
  cnamName := name(cnam);
  cnamEdid := EditorID(cnam);
  
  color:=getColor(cnam);
  
  if sametext(color, '') then begin
    // base, skipin
    // dbg('base, skipin: ' + name(e));
  end else begin
  
    base := findBase_(cnamEdid, color);
    if not assigned(base) then begin
      warn('cannot find base for ' + cnamName + '. color=' + color);
      exit;
    end;
    
    ne := copywithmasters(e);
    items := ebp(ne, 'Items');
    while ElementCount(items) > 0 do
      RemoveByIndex(items, 0, false);
    
    x := ElementAssign(items, HighInteger, nil, False);
    seev(x, 'CNTO\Count', 1);
    seev(x, 'CNTO\Item', name(base));
    addDyes(items, color);
    
    seev(ne, 'BNAM', name(RecordByHex(sourcePrefix + '0140CB')));
    
    x := ElementByPath(ne, 'Conditions');
    if not assigned(x) then begin
      x := Add(ne, 'Conditions', True);
      x := ElementByIndex(x, 0);
    end else begin
      x := ElementAssign(x, HighInteger, nil, False);
    end;
    seev(x, 'CTDA\Type', '11000000'); // >=
    seev(x, 'CTDA\Comparison Value - Float', floattostr(1));
    seev(x, 'CTDA\Function', 'GetItemCount');
    seev(x, 'CTDA\Inventory Object', name(base));
    
    
    // adding removing recipe
    rne := copyWithMastersWithPrefix(e, '', 'DyeRemove_', '');
    seev(rne, 'CNAM', name(base));
    items := ebp(rne, 'Items');
    while ElementCount(items) > 0 do
      RemoveByIndex(items, 0, false);
    x := ElementAssign(items, HighInteger, nil, False);
    seev(x, 'CNTO\Item', name(cnam));
    seev(x, 'CNTO\Count', 1);
    x := ElementAssign(items, HighInteger, nil, False);
    seev(x, 'CNTO\Item', name(RecordByHex(sourcePrefix + '013605')));
    seev(x, 'CNTO\Count', 1);
    seev(rne, 'BNAM', name(RecordByHex(sourcePrefix + '0140CB')));
    x := ElementByPath(rne, 'Conditions');
    if not assigned(x) then begin
      x := Add(rne, 'Conditions', True);
      x := ElementByIndex(x, 0);
    end else begin
      x := ElementAssign(x, HighInteger, nil, False);
    end;
    seev(x, 'CTDA\Type', '11000000'); // >=
    seev(x, 'CTDA\Comparison Value - Float', floattostr(1));
    seev(x, 'CTDA\Function', 'GetItemCount');
    seev(x, 'CTDA\Inventory Object', name(cnam));
  end;
end;

procedure colorFile(e:IInterface);
var item, script, aliases:IInterface;
    i, j, k:integer;
begin
  e := GroupBySignature(e, 'COBJ');
  if not assigned(e) then exit;
  for i:=0 to ElementCount(e)-1 do begin
    item := ElementByIndex(e, i);
    colorIt(item);
  end;
end;

function pack(e:IInterface):string;
begin
  result := GetFileName(GetFile(e)) + '$' + EditorID(e);
end;

function unPack(s:string):IInterface;
var filename, edid:string;
    i:integer;
begin
  i := Pos('$', s);
  filename := Copy(s, 0, i - 1);
  edid     := Copy(s, i + 1, HighInteger);
  result := MainRecordByEditorID(GroupBySignature(filebyname(filename), 'ARMO'), edid);
end;

procedure initItem(item:IInterface);
var color:string;
begin
  color := getColor(item);
  if sametext(color, '') then begin
    // seems base
    knownBases.Add(pack(item));
    dbg('Found base: ' + name(item));
  end else begin
    if sametext(color, 'white') then begin
      knownPossibleBases.Add(pack(item));
      dbg('Found possible base (white): ' + name(item));
    end else if sametext(color, 'black') then begin
      
      //knownPossibleBases.Add(pack(item));
      //dbg('Found possible base: ' + name(item));
    end;
  end;
end;

procedure init(f:IInterface);
var item, script, aliases:IInterface;
    i, j, k:integer;
begin
  f := GroupBySignature(f, 'ARMO');
  if not assigned(f) then exit;
  for i:=0 to ElementCount(f)-1 do begin
    item := ElementByIndex(f, i);
    initItem(item);
  end;
end;

function process(e:IInterface):integer;
begin
  init(e);
  colorFile(e);
end;

function Finalize: Integer;
begin
  knownColors.free;
  knownBases.free;
  colorToDye.free;
  knownPossibleBases.free;
  //CleanMasters(patchFile);
end;

end.
