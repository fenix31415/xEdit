{
  Here should be a description
  -----
  
}

unit ArmorSexism;
uses mteFunctions, uselesscore;

const PATCH_FILE_NAME  = 'ArmorSexism_Patch.esp';

var ignoringMaleEdids:TStringList;

procedure init();
begin
  ignoringMaleEdids := TStringList.create;
  
  ignoringMaleEdids.Add('whose edids are ok');
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
  
  init();
  
  ScriptProcessElements := [etFile];
end;

/// 0 = both, 1 = male, 2 = female, 3 = pokemon
function getSexType(armo:IInterface):integer;
var male, female:boolean;
    flags:IInterface;
begin
  result := 0;
  armo := linksto(ebp(armo, 'Armature\MODL'));
  if not assigned(armo) then exit;
  male := assigned(elementbysignature(armo, 'MOD2'));
  female := assigned(elementbysignature(armo, 'MOD3'));
  
  if male and female then result := 0;
  if not male and female then result := 2;
  if male and not female then result := 1;
  if not male and not female then result := 3;
  
  flags := ebp(armo, 'BODT');
  if not assigned(flags) then flags := ebp(armo, 'BOD2');
  
  // amulet ring shield ears
  if (result <> 0) and ((genv(flags, 'First Person Flags') and ($20 + $40 + $200 + $2000)) > 0) then begin
    result := 0;
    exit;
  end;
  
end;

procedure addSexCondition(cobj:IInterface; male:string);
var conditions, element:IInterface;
begin
  conditions := ElementByPath(cobj, 'Conditions');
  if not assigned(conditions) then begin
    conditions := Add(cobj, 'Conditions', True);
    element := ElementByIndex(conditions, 0);
  end else begin
    element := ElementAssign(conditions, HighInteger, nil, False);
  end;
  seev(element, 'CTDA\Type', '10000000'); // ==
  seev(element, 'CTDA\Comparison Value - Float', 1);
  seev(element, 'CTDA\Function', 'GetPCIsSex');
  seev(element, 'CTDA\Sex', male);
end;

procedure addGlobalCondition(cobj: IInterface; gvar:string);
var conditions, element:IInterface;
begin
  conditions := ElementByPath(cobj, 'Conditions');
  if not assigned(conditions) then begin
    conditions := Add(cobj, 'Conditions', True);
    element := ElementByIndex(conditions, 0);
  end else begin
    element := ElementAssign(conditions, HighInteger, nil, False);
  end;
  seev(element, 'CTDA\Type', '10010000'); // ==, or
  seev(element, 'CTDA\Comparison Value', 1);
  seev(element, 'CTDA\Function', 'GetGlobalValue');
  seev(element, 'CTDA\Global', gvar);
end;

procedure onlyOneMaleInfo(armo:IInterface; male:string);
begin
  //if not ignoringMaleEdids.find(EditorID(armo), 0) then
  //  dbg('Setting only ' + male + ' for ' + name(armo));
end;

procedure patch(armo:IInterface);
var bnam, male: string;
    i, armoType:integer;
    cobj, cnam, conditions, element:IInterface;
begin
  armoType := getSexType(armo);
  if armoType = 3 then begin
    dbg('unknown pokemon: ' + name(armo));
    exit;
  end;
  if armoType = 0 then exit;  // both
  // if armoType = 1 then exit;  // male
  
  for i := ReferencedByCount(armo)-1 downto 0 do begin  // backwards because we add new refs..
    cobj := ReferencedByIndex(armo, i);
    if not SameText(signature(cobj), 'COBJ') then continue;
    cobj := winningoverride(cobj);
    if GetIsDeleted(cobj) then continue;
    cnam := ElementBySignature(cobj, 'CNAM');
    if not assigned(cnam) then continue;
    if EditorID(LinksTo(cnam)) <> EditorID(armo) then continue;  // armo is not a result
    
    bnam := geev(cobj, 'BNAM');
    // filter by workbench
    if not containstext(bnam, 'CraftingSmithingForge') and
       not containstext(bnam, 'CraftingSmithingSkyforge') and
       not containstext(bnam, 'DLC1LD_CraftingForgeAetherium') and
       not containstext(bnam, 'DLC1CraftingDawnguard') then continue;  // craft not in forge
    
    cobj := CopyWithMasters(cobj);
    male := 'Male';
    if armoType = 2 then male := 'Female';
    
    onlyOneMaleInfo(armo, male);
    addGlobalCondition(cobj, 'CCO_ArmorOnlyMALE [GLOB:01CC0261]');
    addSexCondition(cobj, male);
    addGlobalCondition(cobj, 'CCO_ArmorOnlyFEMALE [GLOB:01CC0260]');
    addSexCondition(cobj, male);
  end;
end;

procedure processFile(e:IInterface);
var item, script, aliases:IInterface;
    i, j, k:integer;
begin
  e := GroupBySignature(e, 'ARMO');
  if not assigned(e) then exit;
  for i:=0 to ElementCount(e)-1 do begin
    item := ElementByIndex(e, i);
    if not IsMaster(item) then continue;
    item := WinningOverride(item);
    if GetIsDeleted(item) then continue;
    patch(item);
  end;
end;

function process(e:IInterface):integer;
begin
  processFile(e);
end;

function Finalize: Integer;
begin
  ignoringMaleEdids.free;
  CleanMasters(patchFile);
end;

end.
