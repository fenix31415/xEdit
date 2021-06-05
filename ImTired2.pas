{
  Adds min stamina requiments for some actions
  ----
  
}
unit ImTired2;
uses mteFunctions, uselessCore;

const SOURCE_FILE_NAME = 'imtired2.esp';
      PATCH_FILE_NAME  = 'ImTired2_Patch.esp';
      
      ALL_ADDITIONAL_STAMINA = 60.0;
      
var f314IM_Penalty, f314SE_Strong1, f314SE_Strong2, f314SE_Strong3:IInterface;
    racesToIgnore:TStringList;

procedure patch_(r:IInterface; checkweapon, canLight:boolean);
var hand, mask, val:string;
    e:IInterface;
begin
  if     checkweapon and     canLight then mask := '00110000';
  if not checkweapon and     canLight then mask := '00100000';
  if     checkweapon and not canLight then mask := '10010000';
  if not checkweapon and not canLight then mask := '10000000';
  
  if canLight then val := '2' else val := '0';
  
  e := addCond(r, true);
  seev(e, 'CTDA\Type', mask);
  seev(e, 'CTDA\Function', 'GetGlobalValue');
  seev(e, 'CTDA\Global', name(f314IM_Penalty));
  seev(e, 'CTDA\Comparison Value - Float', val);
  
  if not checkweapon then exit;
  hand := 'Right';
  if containstext(editorid(r), 'Left') then hand := 'Left';
  e := addCond(r, false);
  seev(e, 'CTDA\Type', '01000000');
  seev(e, 'CTDA\Function', 'GetEquippedItemType');
  seev(e, 'CTDA\Casting Type', hand);
  seev(e, 'CTDA\Comparison Value - Float', '8');
end;

procedure patch_anim();
var r, cond:IInterface;
    i:integer;
begin
  f314IM_Penalty := findRecord(SOURCE_FILE_NAME, '02E683');
  
  patch_(copyFind('Skyrim.esm', '088302'), false, false);  // JumpRoot
  patch_(copyFind('Skyrim.esm', '1050F3'), false, false);  // SprintStart
  patch_(copyFind('Skyrim.esm', '02F3F7'), false, false);  // SneakRoot
  patch_(copyFind('Skyrim.esm', '013217'), false, false);  // BlockingStart
  patch_(copyFind('Skyrim.esm', '0193D0'), false, false);  // BlockAnticipate
  patch_(copyFind('Skyrim.esm', '01B417'), false, false);  // bashStart
  patch_(copyFind('Skyrim.esm', '05177C'), false, false);  // BowAttack
  patch_(copyFind('Skyrim.esm', '09753B'), false, false);  // BowLeftAttack
  patch_(copyFind('Skyrim.esm', '0A7032'), false, false);  // BowBash
  patch_(copyFind('Skyrim.esm', '0A7033'), false, false);  // BowZoom
  patch_(copyFind('Skyrim.esm', '0E8452'), false, false);  // PowerBash
  patch_(copyFind('Update.esm', '000982'), false, false);  // BowAttackRight
  patch_(copyFind('Update.esm', '000986'), false, false);  // MountedBowZoom
  
  patch_(copyFind('Skyrim.esm', '013215'), true, true);   // NormalAttack
  patch_(copyFind('Skyrim.esm', '013384'), true, false);  // PowerAttackRoot
  patch_(copyFind('Skyrim.esm', '02E2F8'), true, false);  // DualPowerAttackRoot
  patch_(copyFind('Skyrim.esm', '02E2F9'), true, false);  // LeftPowerAttackRoot
  patch_(copyFind('Skyrim.esm', '050CA5'), true, true);   // DualAttackRoot
  patch_(copyFind('Skyrim.esm', '0870D5'), true, true);   // AttackLeftH2H
  patch_(copyFind('Skyrim.esm', '0EC3CC'), true, false);  // AttackRightPowerForwardSprinting
  patch_(copyFind('Skyrim.esm', '0EC3CD'), true, false);  // AttackPowerLeftHandForwardSprinting
  patch_(copyFind('Skyrim.esm', '0EC3CE'), true, false);  // AttackRightPower2HWForwardSprinting
  patch_(copyFind('Skyrim.esm', '0EC3CF'), true, false);  // AttackRightPower2HMForwardSprinting
  patch_(copyFind('Skyrim.esm', '0F0A3D'), true, true);   // AttackLeftHandForwardSprinting
  patch_(copyFind('Skyrim.esm', '0F0A3E'), true, true);   // AttackRightForwardSprinting_1hand
  patch_(copyFind('Skyrim.esm', '1038BF'), true, true);   // AttackRightForwardSprinting_2hand
  patch_(copyFind('Update.esm', '000987'), true, true);   // MountedCombatLeft
  patch_(copyFind('Update.esm', '000989'), true, true);   // MountedCombatRight
  patch_(copyFind('Update.esm', '00098E'), true, true);   // NonMountedCombatLeft
  patch_(copyFind('Update.esm', '000990'), true, true);   // NonMountedCombatRight
end;

function Initialize: integer;
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
  
  
  f314SE_Strong1 := findrecord(SOURCE_FILE_NAME, '02E6C3');
  f314SE_Strong2 := findrecord(SOURCE_FILE_NAME, '02E6C4');
  f314SE_Strong3 := findrecord(SOURCE_FILE_NAME, '02E6C5');
  
  racesToIgnore := TStringList.create;
  racesToIgnore.Delimiter := ' ';
  racesToIgnore.DelimitedText := 
  'dunMiddenEmptyRace DefaultRace ManakinRace ElderRace InvisibleRace TestRace DLC2MiraakRace DLC2FakeCoffinRace '  // technical
  'MagicAnomalyRace Slaughterfish SwarmRace Netch Scrib mihailimprace Rigmor_ChildRaceSorella AKHumanDwarvenCommander 000FCArbiterRace ' // known useless races
  'Dremora SnowElf Breton Nord Orc WoodElf Redguard Khajiit Imperial HighElf DarkElf Argonian HPGToadRace'  // mens
  ;
  
  patch_anim();
end;

function shouldIgnoreRace(edid:string):boolean;
var i:integer;
begin
  for i:=0 to racesToIgnore.count-1 do
    if ContainsStr(edid, racesToIgnore[i]) then begin
      result := true;
      exit;
    end;
end;

function patchRace_(race:IInterface; edid:string):boolean;
var x:float;
    tmp: IInterface;
    i:integer;
    isGiant, isNPC:boolean;
begin
  result := false;

// default stuff
  if sametext(edid, 'ArnimaFlameBodyRace') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;

  if ContainsStr(edid, 'Seeker') then begin
    addKeyword(copywithmasters(race), f314SE_Strong3);
    result := true;
    exit;
  end;

  if ContainsStr(edid, 'Gargoyle') then begin
    addKeyword(copywithmasters(race), f314SE_Strong3);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Atronach') or sametext(edid, 'mihailclannfearrace') then begin
    if ContainsStr(edid, 'Frost') then begin
      addKeyword(copywithmasters(race), f314SE_Strong3);
      result := true;
      exit;
    end;
    
    if ContainsStr(edid, 'Flame') or sametext(edid, 'mihailclannfearrace') then begin
      addKeyword(copywithmasters(race), f314SE_Strong1);
      result := true;
      exit;
    end;
    
    if ContainsStr(edid, 'Storm') then begin
      addKeyword(copywithmasters(race), f314SE_Strong2);
      result := true;
      exit;
    end;
    
    warn('unknown Atronach: ' + name(race));
    exit;
  end;
  
  if ContainsStr(edid, 'Bear') then begin
    addKeyword(copywithmasters(race), f314SE_Strong2);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Cow') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Chaurus') or ContainsStr(edid, 'Siligonder') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Deer') or ContainsStr(edid, 'Stag') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;

  if ContainsStr(edid, 'Dog') or ContainsStr(edid, 'Husky') then begin
    // f314_StaggerStrong0 = none
    result := true;
    exit;
  end;
  
  if (ContainsStr(edid, 'Dragon') or ContainsStr(edid, 'AlduinRace')) and not ContainsStr(edid, 'Priest') then begin
    addKeyword(copywithmasters(race), f314SE_Strong3);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'DragonPriest') or ContainsStr(edid, 'LichRace') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Draugr') or ContainsStr(edid, 'Zombie') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;
  
  if sametext(edid, 'ElkRace') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Falmer') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'FrostbiteSpider') then begin
    if ContainsStr(edid, 'Giant') then begin
      addKeyword(copywithmasters(race), f314SE_Strong2);
    end else if ContainsStr(edid, 'Large') then begin
      addKeyword(copywithmasters(race), f314SE_Strong1);
    end else begin
      // f314_StaggerStrong0 = none
    end;
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Goat') or ContainsStr(edid, 'Chicken') or ContainsStr(edid, 'Hare') or ContainsStr(edid, 'FoxRace') then begin
    // f314_StaggerStrong0
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'GoblinRace') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Hagraven') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Horker') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Horse') then begin
    addKeyword(copywithmasters(race), f314SE_Strong2);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'IceWraith') then begin
    // f314_StaggerStrong0
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Giant') or ContainsStr(edid, 'Lurker') or ContainsStr(edid, 'Ogre') then begin
    if ContainsStr(edid, 'Giant') then begin
      addKeyword(copywithmasters(race), f314SE_Strong3);
      isGiant := true;
      result := true;
    end else if ContainsStr(edid, 'LurkerRace') or ContainsStr(edid, 'OgreRace') then begin
      addKeyword(copywithmasters(race), f314SE_Strong3);
      result := true;
    end else begin
       warn('unknown giant, setting default: ' + name(race));
      result := false;
    end;
    // result defined above
    exit;
  end;
  
  if ContainsStr(edid, 'Mammoth') then begin
    addKeyword(copywithmasters(race), f314SE_Strong3);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'MountainLion') then begin
    addKeyword(copywithmasters(race), f314SE_Strong2);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Mudcrab') then begin
    // f314_StaggerStrong0
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Riekling') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'SabreCat') or ContainsStr(edid, 'Boar') or ContainsStr(edid, 'Durzog') then begin
    addKeyword(copywithmasters(race), f314SE_Strong2);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Skeleton') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Skeever') then begin
    // f314_StaggerStrong0 = none
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Spriggan') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Troll') then begin
    addKeyword(copywithmasters(race), f314SE_Strong2);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'VampireBeast') then begin
    addKeyword(copywithmasters(race), f314SE_Strong3);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Werewolf') or sametext(edid, 'DLC2WerebearBeastRace') then begin
    addKeyword(copywithmasters(race), f314SE_Strong3);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Wisp') then begin
    // f314_StaggerStrong0
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Witchlight') then begin
    // f314_StaggerStrong0
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Wolf') then begin
    // f314_StaggerStrong0
    result := true;
    exit;
  end;

  if ContainsStr(edid, 'Dwarven') then begin
    if ContainsStr(edid, 'Spider') then begin
      // f314_StaggerStrong0 = none
      result := true;
      exit;
    end;
    if ContainsStr(edid, 'Sphere') or ContainsStr(edid, 'DLC2DwarvenBallistaRace') then begin
      addKeyword(copywithmasters(race), f314SE_Strong1);
      result := true;
      exit;
    end;
    if ContainsStr(edid, 'Centurion') then begin
      addKeyword(copywithmasters(race), f314SE_Strong3);
      result := true;
      exit;
    end;
    
     warn('unknown Dwarven: ' + name(race));
    exit;
  end;
  
  if shouldIgnoreRace(edid) then begin
    result := true;
    addKeyword(copywithmasters(race), f314SE_Strong1);
    exit;
  end;

  warn('unknown race: ' + name(race));
end;

function trialRace(race:IInterface; edid:string):boolean;
begin
  result := false;
  if not sametext(edid, '') then begin
    if patchRace_(race, edid) then
      result := true;
  end;
end;

procedure patchRace(race:IInterface);
var x:float;
    edid:string;
    i:integer;
    isGiant, isNPC:boolean;
begin
  dbg(name(race));

  if HasKeyword(race, 'ActorTypeNPC') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    isNPC := true;
  end;
  
  if trialRace(race, EditorID(race)) then exit;
  if trialRace(race, geev(race, 'NAM8')) then exit;
  if trialRace(race, geev(race, 'WKMV')) then exit;
  if trialRace(race, geev(race, 'VTCK\[0]')) then exit;
  if trialRace(race, geev(race, 'VTCK\[1]')) then exit;
  
  if sametext(geev(race, 'VTCK\[0]'), 'MaleEvenToned [VTYP:00013AD2]') then begin
    addKeyword(copywithmasters(race), f314SE_Strong1);
    exit;
  end;
  
  warn('unknown race=' + name(race) + '. setting default 0.');
end;

procedure dosmth(e:IInterface:string);
begin
  e := copywithmasters(e);
  seev(e, 'ACBS\Stamina Offset', floattostr(ALL_ADDITIONAL_STAMINA + strtofloat(geev(e, 'ACBS\Stamina Offset'))));
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
    
    if sametext(sig, 'NPC_') then dosmth(item)
    else patchRace(item);
  end;
end;

function process(e:IInterface):integer;
begin
  processFile(e, 'RACE');
  processFile(e, 'NPC_');
end;

function Finalize: Integer;
begin
  CleanMasters(patchFile);
  racesToIgnore.free;
end;

end.
