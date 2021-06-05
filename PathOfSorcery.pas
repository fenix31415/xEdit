{
  Here should be a description
  -----
  
}

unit TestUserScript;
uses mteFunctions, uselesscore;

const SOURCE_FILE_NAME = 'PathOfSorcery.esp';
      PATCH_FILE_NAME  = 'PathOfSorcery_Patch.esp';
      
      UpdateInterval = 1.0;
      
var IMP_AllSpells_Novice, IMP_AllSpells_Apprentice, IMP_AllSpells_Adept, IMP_AllSpells_Expert, IMP_AllSpells_Master:IInterface;

function Initialize: integer;
var tmp, efile:IInterface;
    s:string;
    i:integer;
    rec: ZoneInfo;
begin
  ScriptProcessElements := [etFile];
  
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
  
  IMP_AllSpells_Adept      := copyFind(SOURCE_FILE_NAME, '000B8B');
  IMP_AllSpells_Novice     := copyFind(SOURCE_FILE_NAME, '000B89');
  IMP_AllSpells_Expert     := copyFind(SOURCE_FILE_NAME, '000B8C');
  IMP_AllSpells_Master     := copyFind(SOURCE_FILE_NAME, '000B8D');
  IMP_AllSpells_Apprentice := copyFind(SOURCE_FILE_NAME, '000B8A');
end;

function getSpellLevel(e:IInterface):string;
begin
  e := linksto(ebp(e, 'SPIT\Half-cost Perk'));
  if not assigned(e) then result := 'f314_None'
  else result := editorid(WinningOverride(e));
end;

function getSpellType(e:IInterface):string;
begin
  e := linksto(ebp(e, 'SPIT\Half-cost Perk'));
  if not assigned(e) then result := 'f314_None'
  else result := editorid(WinningOverride(e));
end;

function isAlterationOrSo(spel:IInterface):boolean;
var s:string;
begin
  s:= getSpellType(spel);
  result := containstext(s, 'Alteration') or containstext(s, 'Conjuration') or containstext(s, 'Destruction') or
    containstext(s, 'Illusion') or containstext(s, 'Restoration');
end;

function isFireOrSo(spel:IInterface):boolean;
var s:string;
begin
  result := HasKeyword(spel, 'MagicDamageShock') or HasKeyword(spel, 'MagicDamageFire') or HasKeyword(spel, 'MagicDamageFrost');
end;

function isInFormlist(e, list:IInterface):boolean;
var i:integer;
begin
  list := ebp(list, 'FormIDs');
  for i:=0 to elementcount(list)-1 do
    if equals(WinningOverride(linksto(elementbyindex(list, i))), WinningOverride(e)) then result := true;
end;

procedure addToFormList(e, list:IInterface);
begin
  if isInFormlist(e, list) then exit;

  list := ebp(list, 'FormIDs');
  list:=ElementAssign(list, HighInteger, nil, false);
  SetEditValue(list, name(e));
end;

procedure addTo_AllSpells(spel:IInterface);
var s:string;
begin
  s := getSpellLevel(spel);
  if containstext(s, 'apprentice') then addToFormList(spel, IMP_AllSpells_Apprentice);
  if containstext(s, 'master')     then addToFormList(spel, IMP_AllSpells_Master);
  if containstext(s, 'expert')     then addToFormList(spel, IMP_AllSpells_Expert);
  if containstext(s, 'novice')     then addToFormList(spel, IMP_AllSpells_Novice);
  if containstext(s, 'adept')      then addToFormList(spel, IMP_AllSpells_Adept);
end;

function addScript(e:IInterface; s:string):IInterface;
begin
  result:=ebp(e, 'VMAD');
  if not assigned(result) then begin
    result := add(e, 'VMAD', true);
  end;
  result:=ebp(e, 'VMAD\Scripts');
  result:=ElementAssign(result, HighInteger, nil, false);
  seev(result, 'ScriptName', s);
end;

function findScript(e:IInterface; s:string):IInterface;
var i:integer;
    it:IInterface;
begin
  e:=ebp(e, 'VMAD\Scripts');
  if not assigned(e) then exit;
  for i:=0 to elementcount(e)-1 do begin
    it := elementbyindex(e, i);
    if sametext(geev(it, 'ScriptName'), s) then
      result := it;
  end;
end;

function addPropertyNoAuto(script:IInterface; propname:string; val:IInterface):IInterface;
begin
  script := ebp(script, 'Properties');
  result:=ElementAssign(script, HighInteger, nil, false);
  seev(result, 'propertyName', propname);
  seev(result, 'Type', 'Object');
  seev(result, 'Value\Object Union\Object v2\FormID', name(val));
end;

function addProperty(script, val:IInterface):IInterface;
begin
  addPropertyNoAuto(script, editorid(val), val);
end;

function addPropertyFloat(script:IInterface; name:string; val:float):IInterface;
begin
  script := ebp(script, 'Properties');
  result:=ElementAssign(script, HighInteger, nil, false);
  seev(result, 'propertyName', name);
  seev(result, 'Type', 'Float');
  seev(result, 'Float', val);
end;

function addPropertyBool(script:IInterface; name:string; val:boolean):IInterface;
begin
  script := ebp(script, 'Properties');
  result:=ElementAssign(script, HighInteger, nil, false);
  seev(result, 'propertyName', name);
  seev(result, 'Type', 'Bool');
  seev(result, 'Bool', val);
end;

procedure grep(e:IInterface; name:string);
var i:integer;
    it:IInterface;
begin
  e := findScript(e, name);
  e := ebp(e, 'Properties');
  for i:=0 to elementcount(e)-1 do begin
    it := elementbyindex(e, i);
    it := linksto(ebp(it, 'Value\Object Union\Object v2\FormID'));
    addmessage(Format('addProperty(script, findRecord(''%s'', ''%s''));  // %s',
    [getfilename(getfile(it)), copy(inttohex(formid(it), 8), 3, 6), editorid(it)]));
  end;
end;

function isConcentration(mgef:IInterface):boolean;
begin
  result := sametext(geev(mgef, 'Magic Effect Data\DATA\Casting Type'), 'Concentration');
end;

procedure patchShockMgef(mgef:IInterface);
var script:IInterface;
begin
  if assigned(findScript(mgef, 'IMP_DES__Shock')) then exit;
  mgef := copyWithMasters(mgef);
  
  if strtofloat(geev(mgef, 'Magic Effect Data\DATA\Taper Duration')) < 0.1 then
    seev(mgef, 'Magic Effect Data\DATA\Taper Duration', 0.1);
    
  script := addScript(mgef, 'IMP_DES__Shock');
  addProperty(script, findRecord('Skyrim.esm', '01397A'));  // ActorTypeDwarven
  addProperty(script, findRecord('Skyrim.esm', '013794'));  // ActorTypeNPC
  addProperty(script, findRecord('Skyrim.esm', '06BBD7'));  // ArmorMaterialDwarven
  addProperty(script, findRecord('Skyrim.esm', '06BBE2'));  // ArmorMaterialImperialHeavy
  addProperty(script, findRecord('Skyrim.esm', '06BBE3'));  // ArmorMaterialIron
  addProperty(script, findRecord('Skyrim.esm', '06BBE4'));  // ArmorMaterialIronBanded
  addProperty(script, findRecord('Skyrim.esm', '06BBE6'));  // ArmorMaterialSteel
  addProperty(script, findRecord('Skyrim.esm', '06BBE7'));  // ArmorMaterialSteelPlate
  addProperty(script, findRecord('PathOfSorcery.esp', '00082C'));  // IMP_K_Seizure_cooldown
  addProperty(script, findRecord('PathOfSorcery.esp', '00080B'));  // IMP_K_SpellChainingFrost
  addProperty(script, findRecord('PathOfSorcery.esp', '00080C'));  // IMP_K_SpellChaining_Fire
  addProperty(script, findRecord('PathOfSorcery.esp', '000824'));  // IMP_K_SpellChaining_FrostElectric_cool
  addProperty(script, findRecord('PathOfSorcery.esp', '000823'));  // IMP_K_SpellChaining_ShockFire_cool
  addProperty(script, findRecord('PathOfSorcery.esp', '000C1B'));  // IMP_PERK_DES_Conductivity1
  addProperty(script, findRecord('PathOfSorcery.esp', '000C1C'));  // IMP_PERK_DES_Conductivity2
  addProperty(script, findRecord('PathOfSorcery.esp', '000BFD'));  // IMP_PERK_DES_ForceOfNature
  addProperty(script, findRecord('PathOfSorcery.esp', '000C1A'));  // IMP_PERK_DES_Seizure
  addProperty(script, findRecord('PathOfSorcery.esp', '000C13'));  // IMP_PERK_DES_StaticDrain
  addProperty(script, findRecord('PathOfSorcery.esp', '000A21'));  // IMP_SPELL_DES_Seizure
  addProperty(script, findRecord('PathOfSorcery.esp', '0009F2'));  // IMP_SPELL_DES_SpellChaining_IceShock
  addProperty(script, findRecord('PathOfSorcery.esp', '000A12'));  // IMP_SPELL_DES_SpellChaining_ShockFire
  addProperty(script, findRecord('PathOfSorcery.esp', '000A25'));  // IMP_SPELL_DES_SpellChaining_ShockTimer
  addProperty(script, findRecord('PathOfSorcery.esp', '000A11'));  // IMP_SPELL_DES_staticDrain
  if isConcentration(mgef) then
    addPropertyFloat(script, 'UpdateInterval', UpdateInterval);
end;

function getMgefMagnitude(mgef:IInterface):float;
var spel, e:IInterface;
    i:integer;
begin
  result := 0.0;
  spel := getParentSpell(mgef);
  if assigned(spel) then begin
    spel := ebp(spel, 'Effects');
    for i:=0 to elementcount(spel)-1 do begin
      e := elementbyindex(spel, i);
      if equals(WinningOverride(linksto(ebp(e, 'EFID'))), WinningOverride(mgef)) then begin
        result := strtofloat(geev(e, 'EFIT\Magnitude'));
        exit;
      end;
    end;
  end else warn('cant find parent spell for ' + name(mgef));
end;

procedure patchFrostMgef(mgef:IInterface);
var script:IInterface;
begin
  if assigned(findScript(mgef, 'IMP_DES__Frost')) then exit;
  mgef := copyWithMasters(mgef);
  
  if strtofloat(geev(mgef, 'Magic Effect Data\DATA\Taper Duration')) < 0.1 then
    seev(mgef, 'Magic Effect Data\DATA\Taper Duration', 0.1);
    
  script := addScript(mgef, 'IMP_DES__Frost');
  addProperty(script, findRecord('PathOfSorcery.esp', '000B74'));  // IMP_EXP_Frostborn
  addProperty(script, findRecord('PathOfSorcery.esp', '00086B'));  // IMP_FrostbornFaction
  addProperty(script, findRecord('PathOfSorcery.esp', '000A77'));  // IMP_Frostborn_IceWraith
  addProperty(script, findRecord('PathOfSorcery.esp', '000811'));  // IMP_K_ChilledToTheBone
  addProperty(script, findRecord('PathOfSorcery.esp', '00080C'));  // IMP_K_SpellChaining_Fire
  addProperty(script, findRecord('PathOfSorcery.esp', '000825'));  // IMP_K_SpellChaining_FireFrost_cool
  addProperty(script, findRecord('PathOfSorcery.esp', '000824'));  // IMP_K_SpellChaining_FrostElectric_cool
  addProperty(script, findRecord('PathOfSorcery.esp', '00080D'));  // IMP_K_SpellChaining_Shock
  addProperty(script, findRecord('PathOfSorcery.esp', '000C03'));  // IMP_PERK_DES_ChilledToTheBone
  addProperty(script, findRecord('PathOfSorcery.esp', '000BFD'));  // IMP_PERK_DES_ForceOfNature
  addProperty(script, findRecord('PathOfSorcery.esp', '000C07'));  // IMP_PERK_DES_Frostborn
  addProperty(script, findRecord('PathOfSorcery.esp', '000C18'));  // IMP_PERK_DES_PiercingCold1
  addProperty(script, findRecord('PathOfSorcery.esp', '000C19'));  // IMP_PERK_DES_PiercingCold2
  addProperty(script, findRecord('PathOfSorcery.esp', '000A1E'));  // IMP_SPELL_DES_ChilledToTheBone
  addProperty(script, findRecord('PathOfSorcery.esp', '0009F1'));  // IMP_SPELL_DES_SpellChaining_FireIce
  addProperty(script, findRecord('PathOfSorcery.esp', '000A24'));  // IMP_SPELL_DES_SpellChaining_FrostTimer
  addProperty(script, findRecord('PathOfSorcery.esp', '0009F2'));  // IMP_SPELL_DES_SpellChaining_IceShock
  addPropertyFloat(script, 'spellMagnitude', getMgefMagnitude(mgef));
  if isConcentration(mgef) then
    addPropertyFloat(script, 'UpdateInterval', UpdateInterval);
end;

procedure patchFireMgef(mgef:IInterface);
var script:IInterface;
begin
  if assigned(findScript(mgef, 'IMP_DES__Fire')) then exit;
  mgef := copyWithMasters(mgef);
  
  if strtofloat(geev(mgef, 'Magic Effect Data\DATA\Taper Duration')) < 0.1 then
    seev(mgef, 'Magic Effect Data\DATA\Taper Duration', 0.1);
  
  script := addScript(mgef, 'IMP_DES__Fire');
  addProperty(script, findRecord('PathOfSorcery.esp', '000B79'));  // IMP_EXP_Immolate
  addProperty(script, findRecord('PathOfSorcery.esp', '00084C'));  // IMP_GLO_DES_ChanceImmolate
  addProperty(script, findRecord('PathOfSorcery.esp', '000862'));  // IMP_ImmolateFaction
  addProperty(script, findRecord('PathOfSorcery.esp', '000810'));  // IMP_K_SearingPain
  addProperty(script, findRecord('PathOfSorcery.esp', '00080B'));  // IMP_K_SpellChainingFrost
  addProperty(script, findRecord('PathOfSorcery.esp', '00080C'));  // IMP_K_SpellChaining_Fire
  addProperty(script, findRecord('PathOfSorcery.esp', '000825'));  // IMP_K_SpellChaining_FireFrost_cool
  addProperty(script, findRecord('PathOfSorcery.esp', '00080D'));  // IMP_K_SpellChaining_Shock
  addProperty(script, findRecord('PathOfSorcery.esp', '000823'));  // IMP_K_SpellChaining_ShockFire_cool
  addProperty(script, findRecord('PathOfSorcery.esp', '000C15'));  // IMP_PERK_DES_CatchFire1
  addProperty(script, findRecord('PathOfSorcery.esp', '000BFD'));  // IMP_PERK_DES_ForceOfNature
  addProperty(script, findRecord('PathOfSorcery.esp', '000C17'));  // IMP_PERK_DES_Immolate
  addProperty(script, findRecord('PathOfSorcery.esp', '000C02'));  // IMP_PERK_DES_SearingPain
  addProperty(script, findRecord('PathOfSorcery.esp', '000C01'));  // IMP_PERK_DES_Wildfire
  addProperty(script, findRecord('PathOfSorcery.esp', '000A1D'));  // IMP_SPELL_DES_CatchFire
  addProperty(script, findRecord('PathOfSorcery.esp', '000A22'));  // IMP_SPELL_DES_Immolate
  addProperty(script, findRecord('PathOfSorcery.esp', '0009F3'));  // IMP_SPELL_DES_SearingPain
  addProperty(script, findRecord('PathOfSorcery.esp', '0009F1'));  // IMP_SPELL_DES_SpellChaining_FireIce
  addProperty(script, findRecord('PathOfSorcery.esp', '000A23'));  // IMP_SPELL_DES_SpellChaining_FireTimer
  addProperty(script, findRecord('PathOfSorcery.esp', '000A12'));  // IMP_SPELL_DES_SpellChaining_ShockFire
  addProperty(script, findRecord('PathOfSorcery.esp', '0009F6'));  // IMP_SPELL_DES_Wildfire
  if isConcentration(mgef) then
    addPropertyFloat(script, 'UpdateInterval', UpdateInterval);
end;

procedure patchFireFrostShock(mgef:IInterface);
begin
  if HasKeyword(mgef, 'MagicDamageFire')  then patchFireMgef(mgef);
  if HasKeyword(mgef, 'MagicDamageShock') then patchShockMgef(mgef);
  if HasKeyword(mgef, 'MagicDamageFrost') then patchFrostMgef(mgef);
end;

function equalsElements(a, b:IInterface; path:string):boolean;
begin
  result := equals(WinningOverride(linksto(ebp(a, path))), WinningOverride(linksto(ebp(b, path))));
end;

function equalsElementsEditValues(a, b:IInterface; path:string):boolean;
begin
  result := sametext(geev(a, path), geev(b, path));
end;

function equalsConditions(a, b:IInterface):boolean;
begin
  result := true;
  result := result and equalsElementsEditValues(a, b, 'CTDA\Type');
  result := result and equalsElementsEditValues(a, b, 'CTDA\Function');
end;

function equalsConditionsLists(a, b:IInterface):boolean;
var i:integer;
begin
  result := false;
  a := ebp(a, 'Conditions');
  b := ebp(b, 'Conditions');
  if elementcount(a)<>elementcount(b) then exit;
  result := true;
  for i:= 0 to elementcount(a)-1 do begin
    result := result and equalsConditions(elementbyindex(a, i), elementbyindex(b, i));
  end;
end;

function equalsEffects(a, b:IInterface):boolean;
begin
  result := true;
  result := result and equalsElements(a, b, 'EFID');
  result := result and equalsElementsEditValues(a, b, 'EFIT\Magnitude');
  result := result and equalsConditionsLists(a, b);
end;

function equalsEffectsLists(a, b:IInterface):boolean;
var i:integer;
begin
  result := false;
  a := ebp(a, 'Effects');
  b := ebp(b, 'Effects');
  if elementcount(a)<>elementcount(b) then exit;
  result := true;
  for i:= 0 to elementcount(a)-1 do begin
    result := result and equalsEffects(elementbyindex(a, i), elementbyindex(b, i));
  end;
end;

function scrollExists(spel:IInterface):boolean;
var i:integer;
    e, mgef:IInterface;
begin
  mgef := WinningOverride(linksto(ebp(spel, 'Effects\[0]\EFID')));
  for i:=0 to ReferencedByCount(mgef)-1 do begin
    e := ReferencedByIndex(mgef, i);
    if not sametext(signature(e), 'SCRL') then continue;
    if not IsWinningOverride(e) then continue;
    
    if equalsEffectsLists(spel, e) then begin
      result := true;
      exit;
    end;
  end;
end;

procedure addScroll_nousing(spel:IInterface);
begin
  
end;

function isGamingSpell_nousing(spel:IInterface):boolean;
var i:integer;
begin
  for i:=0 to ReferencedByCount(spel)-1 do begin
    e := ReferencedByIndex(spel, i);
    if not sametext(signature(e), 'BOOK') then continue;
    if not IsWinningOverride(e) then continue;
    
    if (genv(e, 'DATA\Flags') and $4 = 0) then continue;  // Teaches Spell
    if not sametext(geev(e, 'DATA\Type'), 'Book/Tome') then continue;
    
    if equals(WinningOverride(linksto(ebp(e, 'DATA\Spell'))), WinningOverride(spel)) then result := true;
  end;
end;

procedure dosmthSPEL(spel:IInterface);
begin
  if isAlterationOrSo(spel) then addTo_AllSpells(spel);
  
  // TODO (no):
  // -Add all spells that should be compatible with Careful Preparation to IMP_LSPELL_ALT_CarefulPreparation_validSpells.
  // -Add all spells that should be compatible with Spell Mastery to IMP_LSPELL_ALT_SpellMastery_validSpells.
  // -Add all spells that should be compatible with Witch's Familiar to IMP_LSPELL_CON_WitchsFamiliar_validSpells.
  // Add keywords IMP_K_MagicDamageHoly, IMP_K_MagicDamagePoison, and IMP_K_MagicDamageDisease to sun spells, poison spells, and disease spells respectively.
  // Create scrolls for all new spells (if they don't already exist in the mod) and scroll-crafting recipes for use with Scroll Scribe.
end;

procedure patchHolyMgef(mgef:IInterface);
begin
  if assigned(findScript(mgef, 'IMP_MISC__ApplySpell')) then exit;
  addKeyword(mgef, findRecord('PathOfSorcery.esp', '000804'));
  mgef := addScript(mgef, 'IMP_MISC__ApplySpell');
  
  addPropertyNoAuto(mgef, 'IMP_Perk',  findRecord('PathOfSorcery.esp', '000BCA'));  // IMP_PERK_RES_DustToDust
  addPropertyNoAuto(mgef, 'IMP_SPELL', findRecord('PathOfSorcery.esp', '0009CD'));  // IMP_SPELL_RES_DustToDust
end;

function FearOrSo(mgef:IInterface):boolean;  // TODO (no): courage
begin
  result := HasKeyword(mgef, 'MagicInfluenceFear') or HasKeyword(mgef, 'MagicInfluenceFrenzy') or HasKeyword(mgef, 'MagicInfluenceCharm');
end;

procedure patchFearOrSo(mgef:IInterface);  // TODO (no): courage
var script:IInterface;
begin
  if HasKeyword(mgef, 'MagicInfluenceCharm') or HasKeyword(mgef, 'MagicInfluenceFear') or HasKeyword(mgef, 'MagicInfluenceFrenzy') then begin
    if not assigned(findScript(mgef, 'IMP_ILL__Influence')) then begin
      mgef := copyWithMasters(mgef);
      script := addScript(mgef, 'IMP_ILL__Influence');
    end else exit;
  end;
  if HasKeyword(mgef, 'MagicInfluenceFear') and not assigned(findScript(mgef, 'IMP_ILL__InfluenceFear')) then begin
    script := addScript(mgef, 'IMP_ILL__InfluenceFear');
    addProperty(script, findRecord('PathOfSorcery.esp', '000A70'));  // IMP_EmptyObject
    addProperty(script, findRecord('PathOfSorcery.esp', '000B7A'));  // IMP_EXP_NightmareHound
    addProperty(script, findRecord('PathOfSorcery.esp', '000841'));  // IMP_GLO_ILL_MasterOfTheMind
    addProperty(script, findRecord('PathOfSorcery.esp', '000830'));  // IMP_K_InfluenceDummy
    addProperty(script, findRecord('PathOfSorcery.esp', '000A7A'));  // IMP_NightmareHound
    addProperty(script, findRecord('PathOfSorcery.esp', '000BD7'));  // IMP_PERK_ILL_ParalyzingTerror
    addProperty(script, findRecord('PathOfSorcery.esp', '000BAB'));  // IMP_PERK_ILL_ScaredToDeath
    addProperty(script, findRecord('PathOfSorcery.esp', '000BD6'));  // IMP_PERK_ILL_WakingNightmare
    addProperty(script, findRecord('PathOfSorcery.esp', '0009D7'));  // IMP_SPELL_ILL_ParalyzingTerror
    addProperty(script, findRecord('Skyrim.esm', '0424E0'));  // MagicInfluenceFear
  end;
  if HasKeyword(mgef, 'MagicInfluenceCharm') and not assigned(findScript(mgef, 'IMP_ILL__InfluenceCalm')) then begin
    script := addScript(mgef, 'IMP_ILL__InfluenceCalm');
    addPropertyNoAuto(script, 'HypnoticGaze', findRecord('Skyrim.esm', '059B77'));  // IMP_PERK_ILL_HypnoticGaze
    addProperty(script, findRecord('PathOfSorcery.esp', '000830'));  // IMP_K_InfluenceDummy
    addProperty(script, findRecord('PathOfSorcery.esp', '000BDA'));  // IMP_PERK_ILL_LayDownArms
  end;
  if HasKeyword(mgef, 'MagicInfluenceFrenzy') and not assigned(findScript(mgef, 'IMP_ILL__InfluenceFrenzy')) then begin
    script := addScript(mgef, 'IMP_ILL__InfluenceFrenzy');
    addProperty(script, findRecord('PathOfSorcery.esp', '000A19'));  // IMP_AB_ILL_FrenzyMastery
    addProperty(script, findRecord('PathOfSorcery.esp', '000841'));  // IMP_GLO_ILL_MasterOfTheMind
    addProperty(script, findRecord('PathOfSorcery.esp', '000830'));  // IMP_K_InfluenceDummy
    addProperty(script, findRecord('PathOfSorcery.esp', '000BD8'));  // IMP_PERK_ILL_ConsumingRage
    addProperty(script, findRecord('PathOfSorcery.esp', '000BAC'));  // IMP_PERK_ILL_Fratricide
    addProperty(script, findRecord('PathOfSorcery.esp', '000BD9'));  // IMP_PERK_ILL_SpreadingWrath
    addProperty(script, findRecord('PathOfSorcery.esp', '000A3D'));  // IMP_SPELL_ILL_SpreadingRage
  end;
end;

procedure patchHealing(mgef:IInterface);
var script:IInterface;
begin
  if not assigned(findScript(mgef, 'IMP_RES__restoreHealth')) then begin
    mgef := copyWithMasters(mgef);
    script := addScript(mgef, 'IMP_RES__restoreHealth');
    addProperty(script, findRecord('PathOfSorcery.esp', '000BAE'));  // IMP_PERK_RES_Healer1
    addProperty(script, findRecord('PathOfSorcery.esp', '000BB1'));  // IMP_PERK_RES_Invigorate
    addPropertyNoAuto(script, 'IMP_PERK_RES_Regeneration', findRecord('Skyrim.esm', '0581F8'));  // IMP_PERK_RES_Regeneration
    addProperty(script, findRecord('PathOfSorcery.esp', '0009C2'));  // IMP_SPELL_RES_Healer
    addProperty(script, findRecord('PathOfSorcery.esp', '0009C4'));  // IMP_SPELL_RES_Invigorate
  end;
end;

function isBounding(mgef:IInterface):boolean;
begin
  result := sametext(geev(mgef, 'Magic Effect Data\DATA\Archtype'), 'Bound Weapon');
end;

procedure patchBounding(mgef:IInterface);
var eff, kwd:IInterface;
begin
  mgef := WinningOverride(linksto(ebp(mgef, 'Magic Effect Data\DATA\Assoc. Item')));
  
  kwd := findRecord('PathOfSorcery.esp', '000807');
  if not hasKeyword(mgef, editorid(kwd)) then begin
    mgef := copyWithMasters(mgef);
    addKeyword(mgef, kwd);
  end;
  
  mgef := WinningOverride(linksto(ebp(mgef, 'EITM')));
  
  eff := findRecord('PathOfSorcery.esp', '0008B5');  // IMP_MGEF_CON_ThirstyBlade_mag
  if assigned(mgef) and not assigned(findEffect(mgef, editorid(eff))) then begin
    mgef := copyWithMasters(mgef);
    eff := addEffect(mgef, name(eff), 10.0, 0, 1);
    kwd := addCond(eff, true);
    seev(kwd, 'CTDA\Type', '10000000');
    seev(kwd, 'CTDA\Function', 'HasPerk');
    seev(kwd, 'CTDA\Perk', name(findRecord('PathOfSorcery.esp', '000BCB')));  // IMP_PERK_CON_ThirstyBlade1
    seev(kwd, 'CTDA\Comparison Value - Float', 1.0);
    
    eff := addEffect(mgef, name(findRecord('PathOfSorcery.esp', '0008B6')), 10.0, 0, 1);  // IMP_MGEF_CON_ThirstyBlade_stam
    kwd := addCond(eff, true);
    seev(kwd, 'CTDA\Type', '10000000');
    seev(kwd, 'CTDA\Function', 'HasPerk');
    seev(kwd, 'CTDA\Perk', name(findRecord('PathOfSorcery.esp', '000BCC')));  // IMP_PERK_CON_ThirstyBlade2
    seev(kwd, 'CTDA\Comparison Value - Float', 1.0);
    
    eff := addEffect(mgef, name(findRecord('PathOfSorcery.esp', '0008B7')), 10.0, 0, 1);  // IMP_MGEF_CON_ThirstyBlade_hp
    kwd := addCond(eff, true);
    seev(kwd, 'CTDA\Type', '10000000');
    seev(kwd, 'CTDA\Function', 'HasPerk');
    seev(kwd, 'CTDA\Perk', name(findRecord('PathOfSorcery.esp', '000BCD')));  // IMP_PERK_CON_ThirstyBlade3
    seev(kwd, 'CTDA\Comparison Value - Float', 1.0);
  end;
end;

function isSummonning(mgef:IInterface):boolean;
begin
  result := HasKeyword(mgef, 'MagicSummonFamiliar') or HasKeyword(mgef, 'MagicSummonFire')
    or HasKeyword(mgef, 'MagicSummonFrost') or HasKeyword(mgef, 'MagicSummonShock');
end;

function getParentSpell(mgef:IInterface):IInterface;
var i:integer;
    e:IInterface;
begin
  for i:=0 to ReferencedByCount(mgef)-1 do begin
    e := ReferencedByIndex(mgef, i);
    if not sametext(signature(e), 'SPEL') then continue;
    if not IsWinningOverride(e) then continue;
    
    if containstext(editorid(e), 'Left') or containstext(editorid(e), 'Right') then continue;
    result := e;
    exit;
  end;
end;

procedure patchSummonning(mgef:IInterface);
var script, spel:IInterface;
begin
  if not assigned(findScript(mgef, 'IMP_CON__Summon')) then begin
    mgef := copyWithMasters(mgef);
    script := addScript(mgef, 'IMP_CON__Summon');
    addProperty(script, findRecord('PathOfSorcery.esp', '000B82'));  // IMP_CON_WitchsFamiliar_storedSpell
    addProperty(script, findRecord('PathOfSorcery.esp', '00084E'));  // IMP_GLO_CON_AtromancyFire_active
    addProperty(script, findRecord('PathOfSorcery.esp', '00084F'));  // IMP_GLO_CON_AtromancyFrost_active
    addProperty(script, findRecord('PathOfSorcery.esp', '000850'));  // IMP_GLO_CON_AtromancyShock_active
    addProperty(script, findRecord('PathOfSorcery.esp', '00083A'));  // IMP_GLO_CON_WitchFamiliarActive
    addPropertyNoAuto(script, 'IMP_PERK_CON_Atromancy', findRecord('Skyrim.esm', '0CB419'));  // IMP_PERK_CON_Atromancy
    addProperty(script, findRecord('PathOfSorcery.esp', '000BEB'));  // IMP_PERK_CON_WitchsFamiliar
    if HasKeyword(mgef, 'MagicSummonShock') then
      addPropertyBool(script, 'IsStormAtronach', true);
    if HasKeyword(mgef, 'MagicSummonFrost') then
      addPropertyBool(script, 'IsFrostAtronach', true);
    if HasKeyword(mgef, 'MagicSummonFire') then
      addPropertyBool(script, 'IsFlameAtronach', true);
    spel := getParentSpell(mgef);
    AddMasterIfMissing(patchFile, getfilename(GetFile(spel)));
    AddMasterIfMissing(patchFile, getfilename(GetFile(MasterOrSelf(spel))));
    addPropertyNoAuto(script, 'thisSpell', spel);    // MAG_ConjureStormAtronach
  end;
end;

procedure dosmthMGEF(mgef:IInterface);
begin
  if not assigned(getParentSpell(mgef)) then exit;
  if isFireOrSo(mgef) then patchFireFrostShock(mgef);
  if HasKeyword(mgef, 'MagicDivine') then patchHolyMgef(copyWithMasters(mgef));  // now only for ForgottenMagic
  if FearOrSo(mgef) then patchFearOrSo(mgef);  // now only without courage
  if HasKeyword(mgef, 'MagicRestoreHealth') then patchHealing(mgef);
  if isBounding(mgef) then patchBounding(mgef);
  if isSummonning(mgef) then patchSummonning(mgef);
end;

procedure processFile(e:IInterface; sig:string);
var item:IInterface;
    i:integer;
begin
  e := GroupBySignature(e, sig);
    
  if not assigned(e) then exit;
  for i:=0 to ElementCount(e)-1 do begin
    item := ElementByIndex(e, i);
    if not isMaster(item) then continue;
    item := WinningOverride(item);
    if GetIsDeleted(item) then continue;
    
    if sametext(sig, 'MGEF') then dosmthMGEF(item);
    if sametext(sig, 'SPEL') then dosmthSPEL(item);
  end;
end;

procedure patchFileSig(e:IInterface);
begin
  AddMasterIfMissing(patchFile, getfilename(e));
  
  processFile(e, 'SPEL');
  processFile(e, 'MGEF');
  
  if MasterCount(patchFile) > 100 then
    CleanMasters(patchFile);
  if MasterCount(patchFile) > 100 then
    warn('too many masters, prepare watin');
end;

function process(e:IInterface):integer;
begin
  patchFileSig(e);
  //AddMasterIfMissing(patchFile, getfilename(GetFile(e)));
  //grep(e, 'IMP_CON__Summon');
  //dbg(booltostr(scrollExists(e)) + ' ' + name(e));
end;

function Finalize(): Integer;
var i:integer;
    e, g:IInterface;
begin
  CleanMasters(patchFile);
end;

end.
