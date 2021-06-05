{
  Here should be a description
  ----
  
}
unit SubEngarde;
uses mteFunctions, uselessCore;

const PATCH_FILE_NAME = '00_SubEngarde.esp';
      MOD_FILE_NAME   = 'SubEngarde.esp';
      weaponCritDamageMult = 1;

var kwd, SubEngarde:IInterface;
    shortIDs, names, staggeringAttacks, isPowerstaggeringAttack, racesToIgnore:TStringList;

function edidByFileAndFormID(filename, id:string):string;
begin
  result := name(RecordByFormID(filebyname(filename), strtoint('$' + id), false));
end;

function edidByFormID(id:string):string;
begin
  result := edidByFileAndFormID(MOD_FILE_NAME, id);
end;

procedure init_f314();
var prefix:string;
    i:integer;
begin
  shortIDs := TStringList.Create;
  
  shortIDs.values['f314_Knock']           := '01EE64';
  shortIDs.values['f314_Stagger']         := '01EE59';
  shortIDs.values['f314_GiantRace']       := '01EE54';
  shortIDs.values['f314_AttackCrit']      := '01EE4E';
  shortIDs.values['f314_AttackBash']      := '01EE53';
  shortIDs.values['f314_PowerAttack']     := '01EE40';
  shortIDs.values['f314_StompAttack']     := '01EE55';
  shortIDs.values['f314_StaggerPower']    := '01EE5C';
  shortIDs.values['f314_NormalAttack']    := '01EE0B';
  shortIDs.values['f314_KnockFromAir']    := '01EE0C';
  shortIDs.values['f314_StaggerImmune']   := '01EE11';
  shortIDs.values['f314_StaggerGround']   := '005901';
//  shortIDs.values['f314_StaggerAlways']   := '01EE13';
  shortIDs.values['f314_EasyKnockable']   := '01EE60';
  shortIDs.values['f314_StaggerStrong1']  := '01EE5A';
  shortIDs.values['f314_StaggerStrong2']  := '01EE5B';
  shortIDs.values['f314_StaggerStrong3']  := '01EE62';
  shortIDs.values['f314_StaggerStrong4']  := '01EE63';
  shortIDs.values['f314_PowerAttackSide'] := '01EE16';
  shortIDs.values['f314_PowerAttackBack'] := '01EE14';
  shortIDs.values['f314_PowerBashAttack'] := '01EE15';
  
  // ...
  
  names := TStringList.Create;
  
  prefix := getPrefixByFileName(MOD_FILE_NAME);
  for i := 0 to shortIDs.Count-1 do
    names.values[shortIDs.Names[i]] := edidByFormID(prefix + shortIDs.ValueFromIndex[i]);
    
  staggeringAttacks := TStringList.create;  isPowerstaggeringAttack := TStringList.create;
  
  staggeringAttacks.Add('SilentMoonsEnchantSpell');            isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('crAtronachFlameMeleeAttack');         isPowerstaggeringAttack.add('-');
  staggeringAttacks.Add('crAtronachFlameMeleePowerAttack');    isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('crAtronachStormMeleeAttack');         isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('crAtronachFrostMeleeAttack');         isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('crChaurusPoisonBite01');              isPowerstaggeringAttack.add('-');
  staggeringAttacks.Add('crChaurusPoisonBite02');              isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('DLC1crChaurusPoisonBite03');          isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('crSpider02PoisonBite');               isPowerstaggeringAttack.add('-');
  staggeringAttacks.Add('crSpider03PoisonBite');               isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('crSpider01PoisonBite');               isPowerstaggeringAttack.add('-');

  staggeringAttacks.Add('DiseaseAtaxia');                      isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('DiseaseBoneBreakFever');              isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('DiseaseBrainRot');                    isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('DiseaseRattles');                     isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('DiseaseRockjoint');                   isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('DiseaseWitbane');                     isPowerstaggeringAttack.add('+');

  staggeringAttacks.Add('crFalmerPoisonedWeapon01');           isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('crFalmerPoisonedWeapon02');           isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('crFalmerPoisonedWeapon03');           isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('crFalmerPoisonedWeapon04');           isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('crFalmerPoisonedWeapon05');           isPowerstaggeringAttack.add('+');

  staggeringAttacks.Add('DLC1crGargoyleSmallAbsorbHealth');    isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('DLC1crGargoyleAbsorbHealth');         isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('DLC1VampirePoisonTalons');            isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('DLC1crDeathHoundMeleeAttack');        isPowerstaggeringAttack.add('+');

  staggeringAttacks.Add('DLC2crAshGuadianMeleeAttack');        isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('DLC2DiseaseDroops');                  isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('DLC2ExpSpiderAlbinoPoisonBite');      isPowerstaggeringAttack.add('+');
  staggeringAttacks.Add('DLC2crFireWyrmMeleeAttack');          isPowerstaggeringAttack.add('+');

  staggeringAttacks.Add('AAAFrostTouch');                      isPowerstaggeringAttack.add('+');
  

  racesToIgnore := TStringList.create;
  racesToIgnore.Delimiter := ' ';
  racesToIgnore.DelimitedText := 
  'dunMiddenEmptyRace DefaultRace ManakinRace ElderRace InvisibleRace TestRace DLC2MiraakRace DLC2FakeCoffinRace '  // technical
  'MagicAnomalyRace Slaughterfish SwarmRace Netch Scrib mihailimprace Rigmor_ChildRaceSorella AKHumanDwarvenCommander 000FCArbiterRace ' // known useless races
  'Dremora SnowElf Breton Nord Orc WoodElf Redguard Khajiit Imperial HighElf DarkElf Argonian HPGToadRace'  // mens
  ;
end;

procedure patchStaggeringSpells();
var i:integer;
    spel, grSK, grDLC1, grDLC2:IInterface;
    tmp:string;
begin
  grSK := GroupBySignature(filebyname('Skyrim.esm'), 'SPEL');
  grDLC1 := GroupBySignature(filebyname('Dawnguard.esm'), 'SPEL');
  grDLC2 := GroupBySignature(filebyname('Dragonborn.esm'), 'SPEL');
  for i:=0 to staggeringAttacks.count-1 do begin
    tmp := staggeringAttacks[i];
    if ContainsStr(tmp, 'DLC1') then spel := MainRecordByEditorID(grDLC1, tmp)
    else if ContainsStr(tmp, 'DLC2') then spel := MainRecordByEditorID(grDLC2, tmp)
    else spel := MainRecordByEditorID(grSK, tmp);
    spel := copywithmasters(WinningOverride(spel));
    addEffect(spel, names.values['f314_KnockFromAir'], 1, 1, 2);
    if sametext(isPowerstaggeringAttack[i], '+') then
      addEffect(spel, names.values['f314_StaggerPower'], 1, 1, 1)
    else 
      addEffect(spel, names.values['f314_Stagger'], 1, 1, 1);
  end;
end;

// hardcoded stuff
procedure patch();
var spel, mgef:IInterface;
begin

/// -----------------        MOVEMENT           -------------
  
// NPC_1HM_MT
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$00069CD8'), false);
  spel := copywithmasters(WinningOverride(spel));
  seev(spel, 'SPED\Left Run', 270.0);
  seev(spel, 'SPED\Right Run', 270.0);
  seev(spel, 'SPED\Forward Run', 340.0);
  seev(spel, 'SPED\Back Run', 270);

// NPC_2HM_MT
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$00069CD9'), false);
  spel := copywithmasters(WinningOverride(spel));
  seev(spel, 'SPED\Left Run', 220);
  seev(spel, 'SPED\Right Run', 220);
  seev(spel, 'SPED\Forward Run', 320);
  seev(spel, 'SPED\Back Run', 220);

// NPC_Bow_MT
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$00069CDA'), false);
  spel := copywithmasters(WinningOverride(spel));
  seev(spel, 'SPED\Left Run', 240);
  seev(spel, 'SPED\Right Run', 240);
  seev(spel, 'SPED\Forward Run', 290);
  seev(spel, 'SPED\Back Run', 240);

// NPC_Attacking_MT
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000A0BC2'), false);
  spel := copywithmasters(WinningOverride(spel));
  seev(spel, 'SPED\Left Walk', 30);
  seev(spel, 'SPED\Left Run', 30);
  seev(spel, 'SPED\Right Walk', 30);
  seev(spel, 'SPED\Right Run', 30);
  seev(spel, 'SPED\Forward Walk', 30);
  seev(spel, 'SPED\Forward Run', 235);
  seev(spel, 'SPED\Back Walk', 30);
  seev(spel, 'SPED\Back Run', 30);
  seev(spel, 'SPED\Rotate in Place Walk', 60);
  seev(spel, 'SPED\Rotate in Place Run', 60);
  seev(spel, 'SPED\Rotate while Moving Run', 60);

// NPC_Attacking2H_MT
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000CEDFC'), false);
  spel := copywithmasters(WinningOverride(spel));
  seev(spel, 'SPED\Left Walk', 10);
  seev(spel, 'SPED\Left Run', 10);
  seev(spel, 'SPED\Right Walk', 10);
  seev(spel, 'SPED\Right Run', 10);
  seev(spel, 'SPED\Forward Walk', 10);
  seev(spel, 'SPED\Forward Run', 235);
  seev(spel, 'SPED\Back Walk', 10);
  seev(spel, 'SPED\Back Run', 10);
  seev(spel, 'SPED\Rotate in Place Walk', 30);
  seev(spel, 'SPED\Rotate in Place Run', 30);
  seev(spel, 'SPED\Rotate while Moving Run', 30);


/// -----------------        SPELLS            -------------

  patchStaggeringSpells();

// crGiantClubSlam
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$00104D43'), false);
  spel := copywithmasters(WinningOverride(spel));
  mgef := findEffect(spel, '00104D45');
  if assigned(mgef) then RemoveElement(ebp(spel, 'Effects'), mgef);
  addEffect(spel, names.values['f314_Knock'], 1, 10, 10);
  addEffect(spel, names.values['f314_StaggerGround'], 0.5, 14, 5);
  addEffect(spel, names.values['f314_StaggerGround'], 0.25, 28, 5);
  
// crGiantStomp
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$0002FFD2'), false);
  spel := copywithmasters(WinningOverride(spel));
  mgef := findEffect(spel, '00104D44');
  if assigned(mgef) then RemoveElement(ebp(spel, 'Effects'), mgef);
  addEffect(spel, names.values['f314_StaggerGround'], 0.5, 14, 5);
  addEffect(spel, names.values['f314_StaggerGround'], 0.25, 28, 5);
  
// crGiantMagicResistance
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000F2595'), false);
  spel := copywithmasters(WinningOverride(spel));
  seev(spel, 'Effects\[0]\EFIT\Magnitude', '66.0');
  
// L_VoiceDragonFire01
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$0010FE1D'), false);
  spel := copywithmasters(WinningOverride(spel));
  senv(spel, 'SPIT\Flags', genv(spel, 'SPIT\Flags') or $00100000);  // ignore resist
  seev(spel, 'Effects\[0]\EFIT\Magnitude', 20.0);
  seev(spel, 'Effects\[0]\EFIT\Duration', 1);
  seev(spel, 'Effects\[1]\EFIT\Magnitude', 25.0);
  seev(spel, 'Effects\[1]\EFIT\Duration', 1);
  seev(spel, 'Effects\[2]\EFIT\Magnitude', 30.0);
  seev(spel, 'Effects\[2]\EFIT\Duration', 1);
  seev(spel, 'Effects\[3]\EFIT\Magnitude', 35.0);
  seev(spel, 'Effects\[3]\EFIT\Duration', 1);
  seev(spel, 'Effects\[4]\EFIT\Magnitude', 40.0);
  seev(spel, 'Effects\[4]\EFIT\Duration', 1);
  addEffect(spel, names.values['f314_Stagger'], 1, 1, 1);
  
// VoiceDragonFire01
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000252C2'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 20, false);
  
// VoiceDragonFire02
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000F80F3'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 25, false);
  
// VoiceDragonFire03
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000FEA9E'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 30, false);
  
// VoiceDragonFire04
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000F8104'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 35, true);
  
// VoiceDragonFire05
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$0010C4DB'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 40, true);
  
// DLC2VoiceDragonFire06
  spel := RecordByFormID(filebyname('Dragonborn.esm'), strtoint('$0403612F'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 45, true);
  
// L_VoiceDragonFireBall01
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$0010FE1E'), false);
  spel := copywithmasters(WinningOverride(spel));
  senv(spel, 'SPIT\Flags', genv(spel, 'SPIT\Flags') or $00100000);  // ignore resist
  seev(spel, 'Effects\[0]\EFIT\Magnitude', 20.0);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
  seev(spel, 'Effects\[1]\EFIT\Magnitude', 30.0);
  seev(spel, 'Effects\[1]\EFIT\Duration', 0);
  seev(spel, 'Effects\[2]\EFIT\Magnitude', 40.0);
  seev(spel, 'Effects\[2]\EFIT\Duration', 0);
  seev(spel, 'Effects\[3]\EFIT\Magnitude', 50.0);
  seev(spel, 'Effects\[3]\EFIT\Duration', 0);
  seev(spel, 'Effects\[4]\EFIT\Magnitude', 60.0);
  seev(spel, 'Effects\[4]\EFIT\Duration', 0);
  addEffect(spel, names.values['f314_Stagger'], 1, 1, 1);
  
// VoiceDragonFireBall01
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000742CE'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 20, false);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
  
// VoiceDragonFireBall02
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000F80F5'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 30, false);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
  
// VoiceDragonFireBall03
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000FEA9F'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 40, false);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
  
// VoiceDragonFireBall04
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000F8105'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 50, true);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
  
// VoiceDragonFireBall05
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$0010C4DD'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 60, true);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
  
// DLC2VoiceDragonFireBall06
  spel := RecordByFormID(filebyname('Dragonborn.esm'), strtoint('$04036130'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 70, true);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
  
// L_VoiceDragonFrost01
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$0010FE1F'), false);
  spel := copywithmasters(WinningOverride(spel));
  senv(spel, 'SPIT\Flags', genv(spel, 'SPIT\Flags') or $00100000);  // ignore resist
  seev(spel, 'Effects\[0]\EFIT\Magnitude', 20.0);
  seev(spel, 'Effects\[0]\EFIT\Duration', 1);
  seev(spel, 'Effects\[1]\EFIT\Magnitude', 30.0);
  seev(spel, 'Effects\[1]\EFIT\Duration', 1);
  seev(spel, 'Effects\[2]\EFIT\Magnitude', 40.0);
  seev(spel, 'Effects\[2]\EFIT\Duration', 1);
  seev(spel, 'Effects\[3]\EFIT\Magnitude', 50.0);
  seev(spel, 'Effects\[3]\EFIT\Duration', 1);
  seev(spel, 'Effects\[4]\EFIT\Magnitude', 60.0);
  seev(spel, 'Effects\[4]\EFIT\Duration', 1);
  
// VoiceDragonFrost01
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000F80F4'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 20, false);
  
// VoiceDragonFrost02
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000549B3'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 30, false);
  
// VoiceDragonFrost03
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000F80FE'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 40, false);
  
// VoiceDragonFrost04
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000F8106'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 50, true);
  
// VoiceDragonFrost05
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$0010C4DC'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 60, true);
  
// DLC2VoiceDragonFrost06
  spel := RecordByFormID(filebyname('Dragonborn.esm'), strtoint('$0403612A'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 70, true);
  
// L_VoiceDragonFrostBall01
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$0010FE20'), false);
  spel := copywithmasters(WinningOverride(spel));
  senv(spel, 'SPIT\Flags', genv(spel, 'SPIT\Flags') or $00100000);  // ignore resist
  seev(spel, 'Effects\[0]\EFIT\Magnitude', 20.0);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
  seev(spel, 'Effects\[1]\EFIT\Magnitude', 30.0);
  seev(spel, 'Effects\[1]\EFIT\Duration', 0);
  seev(spel, 'Effects\[2]\EFIT\Magnitude', 40.0);
  seev(spel, 'Effects\[2]\EFIT\Duration', 0);
  seev(spel, 'Effects\[3]\EFIT\Magnitude', 50.0);
  seev(spel, 'Effects\[3]\EFIT\Duration', 0);
  seev(spel, 'Effects\[4]\EFIT\Magnitude', 60.0);
  seev(spel, 'Effects\[4]\EFIT\Duration', 0);
  
// VoiceDragonFrostBall01
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000F80F6'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 20, false);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
  
// VoiceDragonFrostBall02
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000DD606'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 30, false);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
  
// VoiceDragonFrostBall03
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000F80FF'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 40, false);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
  
// VoiceDragonFrostBall04
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$000F8107'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 50, true);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
  
// VoiceDragonFrostBall05
  spel := RecordByFormID(filebyname('Skyrim.esm'), strtoint('$0010C4DE'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 60, true);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
  
// DLC2VoiceDragonFrostBall06
  spel := RecordByFormID(filebyname('Dragonborn.esm'), strtoint('$0403612D'), false);
  spel := copywithmasters(WinningOverride(spel));
  tuneDragonFireBreathSpells(spel, 70, true);
  seev(spel, 'Effects\[0]\EFIT\Duration', 0);
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
  AddMasterIfMissing(patchFile, MOD_FILE_NAME);
  
  init_f314();
  
  ScriptProcessElements := [etFile];
  
  patch();
end;

procedure addDmgMult(e:IInterface; x:float);
begin
  seev(e, 'ATKD\Damage Mult', strtofloat(geev(e, 'ATKD\Damage Mult')) + x);
end;

procedure setGeneralAttackData(e:IInterface);
var atke, atkd:IInterface;
    atkeID:string;
begin
  atke:=elementbypath(e, 'ATKE - Attack Event');
  atkd:=elementbypath(e, 'ATKD - Attack Data');
  
  if not assigned(atke) or not assigned(atkd) then begin
    addmessage('badadata, skippin: ' + name(e));
    exit;
  end;
  atkeID:=geteditvalue(atke);
  if ContainsStr(atkeID, 'H2H') then exit;
  
  if sametext(geev(e, 'ATKD\Attack Spell'), 'NULL - Null Reference [00000000]') then begin
    if ContainsStr(atkeID, 'PowerStartLeft') or ContainsStr(atkeID, 'PowerStartRight') then
      seev(e, 'ATKD\Attack Spell', names.values['f314_PowerAttackSide'])
    else if sametext(atkeID, 'attackPowerStartBackward') or sametext(atkeid, 'attackPowerStartBackLeftHand') then
      seev(e, 'ATKD\Attack Spell', names.values['f314_PowerAttackBack'])
    else if (genv(atkd, 'Attack Flags') and ($2 + $4)) = ($2+$4) then
      seev(e, 'ATKD\Attack Spell', names.values['f314_PowerBashAttack'])
    else if (genv(atkd, 'Attack Flags') and $2) = $2 then
      seev(e, 'ATKD\Attack Spell', names.values['f314_AttackBash'])
    else if (genv(atkd, 'Attack Flags') and $4) = $4 then
      seev(e, 'ATKD\Attack Spell', names.values['f314_PowerAttack'])
    else
      seev(e, 'ATKD\Attack Spell', names.values['f314_NormalAttack']);
  end;
  
  if ContainsStr(atkeID, 'Forward') or ContainsStr(atkeID, 'Lunge') or ContainsStr(atkeID, 'Bite') then begin
    seev(e, 'ATKD\Strike Angle', '28.0');
  end;
  
  if sametext(atkeID, 'AttackStart_LeftChop') then begin
    seev(e, 'ATKD\Strike Angle', '28.0');
    seev(e, 'ATKD\Attack Angle', '-35.0');
  end else if sametext(atkeID, 'AttackStart_RightChop') then begin
    seev(e, 'ATKD\Strike Angle', '28.0');
    seev(e, 'ATKD\Attack Angle', '35.0');
  end else if ContainsStr(atkeID, 'Chop') then begin
    seev(e, 'ATKD\Strike Angle', '25.0');
  end;
  
  if sametext(atkeID, 'attackPowerStartInPlace') or sametext(atkeID, 'attackPowerStartInPlaceLeftHand') then begin
    seev(e, 'ATKD\Strike Angle', '28.0');
    seev(e, 'ATKD\Attack Chance', '1.0');
  end else if sametext(atkeID, 'attackPowerStartForward') or sametext(atkeID, 'attackPowerStartForwardLeftHand') then begin
    seev(e, 'ATKD\Attack Chance', '0.1');
    seev(e, 'ATKD\Strike Angle', '28.0');
    addDmgMult(e, 0.5);
  end else if ContainsStr(atkeID, 'PowerStartLeft') or ContainsStr(atkeID, 'PowerStartRight') then begin
    seev(e, 'ATKD\Attack Chance', '0.0');
    senv(e, 'ATKD\Attack Flags', genv(e, 'ATKD\Attack Flags') or $10);
    seev(e, 'ATKD\Strike Angle', '65.0');
    addDmgMult(e, -1.0);
  end else if sametext(atkeID, 'attackPowerStartBackward') then begin
    seev(e, 'ATKD\Attack Chance', '0.0');
    senv(e, 'ATKD\Attack Flags', genv(e, 'ATKD\Attack Flags') or $10);
    seev(e, 'ATKD\Strike Angle', '65.0');
  end else if ContainsStr(atkeID, 'attack') and ContainsStr(atkeID, 'Start') and ContainsStr(atkeID, 'Sprint') then begin
    seev(e, 'ATKD\Attack Chance', '2.0');
    seev(e, 'ATKD\Strike Angle', '28.0');
  end;
  
  if sametext(atkeID, 'attackPowerStartDualWield') then begin
    seev(e, 'ATKD\Attack Chance', '1.0');
    if not assigned(elementbypath(e, 'ATKD\Attack Type')) then add(e, 'ATKD\Attack Type', true);
    senv(e, 'ATKD\Attack Type', $000914E7);
    seev(e, 'ATKD\Strike Angle', '50.0');
    addDmgMult(e, -0.5);
  end else if sametext(atkeID, 'attackStartDualWield') then begin
    seev(e, 'ATKD\Strike Angle', '50.0');
    addDmgMult(e, -0.25);
  end else if sametext(atkeID, 'attackStart') then begin
    seev(e, 'ATKD\Strike Angle', '65.0');
  end else if sametext(atkeID, 'attackStartLeftHand') then begin
    seev(e, 'ATKD\Strike Angle', '50.0');
  end else if sametext(atkeID, 'bashPowerStart') then begin
    seev(e, 'ATKD\Strike Angle', '80.0');
  end;
end;

procedure setAtronachFrostAttackData(e:IInterface);
var atke, atkd:IInterface;
    atkeID:string;
begin
  atke:=elementbypath(e, 'ATKE - Attack Event');
  atkd:=elementbypath(e, 'ATKD - Attack Data');
  
  if not assigned(atke) or not assigned(atkd) then begin
    addmessage('badadata, skippin: ' + name(e));
    exit;
  end;
  atkeID:=geteditvalue(atke);
  
  if sametext(atkeID, 'attackPowerStart_ForwardPowerAttack_R1') then begin
    seev(e, 'ATKD\Attack Chance', '5.0');
    addDmgMult(e, 0.5);
  end else if sametext(atkeID, 'attackPowerStart_PowerAttack_L1') then begin
    seev(e, 'ATKD\Attack Angle', '-15.0');
    seev(e, 'ATKD\Attack Chance', '0.7');
    addDmgMult(e, 1);
  end else if sametext(atkeID, 'attackStart_Attack_L1') then begin
    senv(e, 'ATKD\Attack Flags', genv(e, 'ATKD\Attack Flags') or $4);
    seev(e, 'ATKD\Attack Angle', '-25.0');
    seev(e, 'ATKD\Attack Chance', '1.0');
    addDmgMult(e, 0.5);
  end else if sametext(atkeID, 'attackStart_Attack_R1') then begin
    senv(e, 'ATKD\Attack Flags', genv(e, 'ATKD\Attack Flags') or $4);
    seev(e, 'ATKD\Attack Angle', '5.0');
    seev(e, 'ATKD\Strike Angle', '25.0');
    seev(e, 'ATKD\Attack Chance', '1.0');
    addDmgMult(e, 0.5);
  end else if sametext(atkeID, 'bashPowerStart') then begin
    seev(e, 'ATKD\Strike Angle', '65.0');
  end;
end;

procedure setBearAttackData(e:IInterface);
var atke, atkd:IInterface;
    atkeID:string;
begin
  atke:=elementbypath(e, 'ATKE - Attack Event');
  atkd:=elementbypath(e, 'ATKD - Attack Data');
  
  if not assigned(atke) or not assigned(atkd) then begin
    addmessage('badadata, skippin: ' + name(e));
    exit;
  end;
  atkeID:=geteditvalue(atke);
  
  if sametext(atkeID, 'attackStart_Attack1') or sametext(atkeID, 'attackStart_AttackLeft1') then begin
    seev(e, 'ATKD\Attack Angle', '-45.0');
  end else if sametext(atkeID, 'attackStart_Attack2') or sametext(atkeID, 'attackStart_AttackRight1') then begin
    seev(e, 'ATKD\Attack Angle', '45.0');
  end;
  
  if ContainsStr(atkeID, 'ForwardPower') then begin
    seev(e, 'ATKD\Strike Angle', '58.0');
  end;
  
  if ContainsStr(atkeID, 'attackStart_StandingPower') then begin
    seev(e, 'ATKD\Strike Angle', '65.0');
    addDmgMult(e, 1);
  end;
end;

procedure setDwarvenSphereAttackData(e:IInterface);
var atke, atkd:IInterface;
    atkeID:string;
begin
  atke:=elementbypath(e, 'ATKE - Attack Event');
  atkd:=elementbypath(e, 'ATKD - Attack Data');
  
  if not assigned(atke) or not assigned(atkd) then begin
    addmessage('badadata, skippin: ' + name(e));
    exit;
  end;
  atkeID:=geteditvalue(atke);
  
  if ContainsStr(atkeID, 'Chop') then begin
    seev(e, 'ATKD\Attack Angle', '15.0');
    seev(e, 'ATKD\Strike Angle', '28.0');
  end;
  
  if ContainsStr(atkeID, 'Stab') then begin
    addDmgMult(e, 0.5);
    seev(e, 'ATKD\Strike Angle', '20.0');
  end;
  
end;

procedure setDwarvenCenturionAttackData(e:IInterface);
var atke, atkd:IInterface;
    atkeID:string;
begin
  atke:=elementbypath(e, 'ATKE - Attack Event');
  atkd:=elementbypath(e, 'ATKD - Attack Data');
  
  if not assigned(atke) or not assigned(atkd) then begin
    addmessage('badadata, skippin: ' + name(e));
    exit;
  end;
  atkeID:=geteditvalue(atke);
  seev(e, 'ATKD\Stagger', '0.0');
  seev(e, 'ATKD\Knockdown', '0.0');
  
  if ContainsStr(atkeID, 'attackStartBack') or ContainsStr(atkeID, 'attackStartRight') then begin
    seev(e, 'ATKD\Attack Angle', '150.0');
    seev(e, 'ATKD\Strike Angle', '70.0');
    senv(e, 'ATKD\Attack Type', 0);
  end;
  
  if sametext(atkeID, 'attackStartLeft') then begin
    seev(e, 'ATKD\Attack Angle', '-150.0');
    seev(e, 'ATKD\Strike Angle', '70.0');
    senv(e, 'ATKD\Attack Type', 0);
  end else if ContainsStr(atkeID, 'attackStartForwardPowerLeft') or ContainsStr(atkeID, 'attackStartForwardPowerRushLeft') then begin
    seev(e, 'ATKD\Attack Angle', '-10.0');
    seev(e, 'ATKD\Strike Angle', '60.0');
    senv(e, 'ATKD\Attack Type', 0);
  end else if sametext(atkeID, 'attackStartForwardPowerRight') then begin
    seev(e, 'ATKD\Attack Angle', '10.0');
    seev(e, 'ATKD\Strike Angle', '60.0');
    seev(e, 'ATKD\Damage Mult', '2.0');
    senv(e, 'ATKD\Attack Type', 0);
  end else if sametext(atkeID, 'attackStartSlash') then begin
    seev(e, 'ATKD\Attack Angle', '-20.0');
    seev(e, 'ATKD\Strike Angle', '70.0');
    seev(e, 'ATKD\Damage Mult', '0.75');
    senv(e, 'ATKD\Attack Type', 0);
  end else if sametext(atkeID, 'bashStart') then begin
    seev(e, 'ATKD\Attack Angle', '20.0');
    seev(e, 'ATKD\Strike Angle', '70.0');
    seev(e, 'ATKD\Damage Mult', '0.50');
    senv(e, 'ATKD\Attack Type', 0);
  end else if sametext(atkeID, 'attackStartStab') or sametext(atkeID, 'attackStartChop') then begin
    seev(e, 'ATKD\Attack Angle', '20.0');
    seev(e, 'ATKD\Strike Angle', '25.0');
    seev(e, 'ATKD\Damage Mult', '1.25');
  end;
end;

procedure setDragonAttackData(e:IInterface);
var atke, atkd:IInterface;
    atkeID:string;
begin
  atke:=elementbypath(e, 'ATKE - Attack Event');
  atkd:=elementbypath(e, 'ATKD - Attack Data');
  
  if not assigned(atke) or not assigned(atkd) then begin
    addmessage('badadata, skippin: ' + name(e));
    exit;
  end;
  atkeID:=geteditvalue(atke);
  
  if sametext(atkeID, 'attackStartBite') then begin
    seev(e, 'ATKD\Strike Angle', '20.0');
  end else if sametext(atkeID, 'attackStartBiteLeft') then begin
    seev(e, 'ATKD\Strike Angle', '20.0');
    seev(e, 'ATKD\Attack Angle', '-40.0');
  end else if sametext(atkeID, 'attackStartBiteRight') then begin
    seev(e, 'ATKD\Strike Angle', '20.0');
    seev(e, 'ATKD\Attack Angle', '40.0');
  end else if sametext(atkeID, 'attackStartTail') then begin
    seev(e, 'ATKD\Damage Mult', '0.0');
    seev(e, 'ATKD\Attack Chance', '2.0');
//    senv(e, 'ATKD\Attack Spell', 0);
    seev(e, 'ATKD\Strike Angle', '15.0');
  end else if sametext(atkeID, 'attackStartTailLeft') then begin
    seev(e, 'ATKD\Damage Mult', '0.0');
//    senv(e, 'ATKD\Attack Spell', 0);
    seev(e, 'ATKD\Attack Angle', '110.0');
    seev(e, 'ATKD\Strike Angle', '40.0');
    senv(e, 'ATKD\Attack Flags', genv(e, 'ATKD\Attack Flags') or $10);
  end else if sametext(atkeID, 'attackStartTailRight') then begin
    seev(e, 'ATKD\Damage Mult', '0.0');
//    senv(e, 'ATKD\Attack Spell', 0);
    seev(e, 'ATKD\Attack Angle', '-110.0');
    seev(e, 'ATKD\Strike Angle', '40.0');
    senv(e, 'ATKD\Attack Flags', genv(e, 'ATKD\Attack Flags') or $10);
  end else if sametext(atkeID, 'attackStartWingLeft') then begin
    seev(e, 'ATKD\Damage Mult', '0.5');
    if sametext(geev(e, 'ATKD\Attack Spell'), 'NULL - Null Reference [00000000]') then
      seev(e, 'ATKD\Attack Spell', names.values['f314_PowerAttack']);
    seev(e, 'ATKD\Attack Angle', '-80.0');
    seev(e, 'ATKD\Strike Angle', '20.0');
    senv(e, 'ATKD\Attack Flags', genv(e, 'ATKD\Attack Flags') or $10);
  end else if sametext(atkeID, 'attackStartWingRight') then begin
    seev(e, 'ATKD\Damage Mult', '0.5');
    if sametext(geev(e, 'ATKD\Attack Spell'), 'NULL - Null Reference [00000000]') then
      seev(e, 'ATKD\Attack Spell', names.values['f314_PowerAttack']);
    seev(e, 'ATKD\Attack Angle', '80.0');
    seev(e, 'ATKD\Strike Angle', '20.0');
    senv(e, 'ATKD\Attack Flags', genv(e, 'ATKD\Attack Flags') or $10);
  end;
  
end;

procedure setFalmerAttackData(e:IInterface);
var atke, atkd:IInterface;
    atkeID:string;
begin
  atke:=elementbypath(e, 'ATKE - Attack Event');
  atkd:=elementbypath(e, 'ATKD - Attack Data');
  
  if not assigned(atke) or not assigned(atkd) then begin
    addmessage('badadata, skippin: ' + name(e));
    exit;
  end;
  atkeID:=geteditvalue(atke);
  
  if sametext(atkeID, 'attackPowerStartForward1') then begin
    seev(e, 'ATKD\Attack Angle', '10.0');
  end else if sametext(atkeID, 'attackStartAttack4') then begin
    seev(e, 'ATKD\Strike Angle', '28.0');
  end;
  
end;

procedure setSpiderAttackData(e:IInterface);
var atke, atkd:IInterface;
    atkeID:string;
begin
  atke:=elementbypath(e, 'ATKE - Attack Event');
  atkd:=elementbypath(e, 'ATKD - Attack Data');
  
  if not assigned(atke) or not assigned(atkd) then begin
    addmessage('badadata, skippin: ' + name(e));
    exit;
  end;
  atkeID:=geteditvalue(atke);
  
  if sametext(atkeID, 'AttackStartLungeBite') then begin
    seev(e, 'ATKD\Strike Angle', '45.0');
  end else if sametext(atkeID, 'AttackStart_ComboChop') then begin
    seev(e, 'ATKD\Strike Angle', '20.0');
  end;
  
end;

procedure setGiantAttackData(e:IInterface; isGiant:boolean);
var atke, atkd:IInterface;
    atkeID:string;
begin
  atke:=elementbypath(e, 'ATKE - Attack Event');
  atkd:=elementbypath(e, 'ATKD - Attack Data');
  
  if not assigned(atke) or not assigned(atkd) then begin
    addmessage('badadata, skippin: ' + name(e));
    exit;
  end;
  atkeID:=geteditvalue(atke);
  
  if sametext(atkeID, 'attackPowerStart_ForwardPowerAttack') then begin
    seev(e, 'ATKD\Attack Chance', '2.0');
    seev(e, 'ATKD\Strike Angle', '15.0');
    seev(e, 'ATKD\Attack Angle', '10.0');
  end else if sametext(atkeID, 'attackPowerStart_Stomp') then begin
    seev(e, 'ATKD\Attack Chance', '0.3');
    seev(e, 'ATKD\Strike Angle', '30.0');
    seev(e, 'ATKD\Attack Type', names.values['f314_StompAttack']);
  end else if sametext(atkeID, 'attackStart_ClubAttack1') then begin
    seev(e, 'ATKD\Attack Angle', '35.0');
    seev(e, 'ATKD\Strike Angle', '50.0');
    if isGiant then begin
      senv(e, 'ATKD\Attack Flags', genv(e, 'ATKD\Attack Flags') or $4);
      seev(e, 'ATKD\Attack Spell', names.values['f314_PowerAttack']);
    end;
  end else if sametext(atkeID, 'attackStart_HandSwipeAttack') then begin
    seev(e, 'ATKD\Attack Angle', '-35.0');
    seev(e, 'ATKD\Strike Angle', '50.0');
    if isGiant then begin
      senv(e, 'ATKD\Attack Flags', genv(e, 'ATKD\Attack Flags') or $4);
      seev(e, 'ATKD\Attack Spell', names.values['f314_PowerAttack']);
    end;
  end else if sametext(atkeID, 'bashStart') then begin
    addDmgMult(e, -0.5);
    seev(e, 'ATKD\Attack Spell', names.values['f314_NormalAttack']);
  end;
end;

procedure setTrollAttackData(e:IInterface);
var atke, atkd:IInterface;
    atkeID:string;
begin
  atke:=elementbypath(e, 'ATKE - Attack Event');
  atkd:=elementbypath(e, 'ATKD - Attack Data');
  
  if not assigned(atke) or not assigned(atkd) then begin
    addmessage('badadata, skippin: ' + name(e));
    exit;
  end;
  atkeID:=geteditvalue(atke);
  
  if ContainsStr(atkeID, 'attackStartLeft') then begin
    seev(e, 'ATKD\Strike Angle', '45.0');
    seev(e, 'ATKD\Attack Angle', '-45.0');
    exit;
  end;
  
  if ContainsStr(atkeID, 'attackStartRight') then begin
    seev(e, 'ATKD\Strike Angle', '45.0');
    seev(e, 'ATKD\Attack Angle', '45.0');
    exit;
  end;
  
  if ContainsStr(atkeID, 'attackStartPower') then begin
    seev(e, 'ATKD\Strike Angle', '45.0');
    exit;
  end;
  
end;

procedure setWerewolfAttackData(e:IInterface);
var atke, atkd:IInterface;
    atkeID:string;
begin
  atke:=elementbypath(e, 'ATKE - Attack Event');
  atkd:=elementbypath(e, 'ATKD - Attack Data');
  
  if not assigned(atke) or not assigned(atkd) then begin
    addmessage('badadata, skippin: ' + name(e));
    exit;
  end;
  atkeID:=geteditvalue(atke);
  
  if sametext(atkeID, 'AttackStartDual') or sametext(atkeID, 'AttackStartDualRunning') then begin
    seev(e, 'ATKD\Strike Angle', '35.0');
  end else if sametext(atkeID, 'AttackStartDualSprinting') or sametext(atkeID, 'AttackStartLeftSprinting') or sametext(atkeID, 'AttackStartRightSprinting') then begin
    seev(e, 'ATKD\Strike Angle', '35.0');
  end else if sametext(atkeID, 'attackStartLeft') then begin
    seev(e, 'ATKD\Attack Angle', '-20.0');
  end else if sametext(atkeID, 'attackStartRight') then begin
    seev(e, 'ATKD\Attack Angle', '20.0');
  end else if sametext(atkeID, 'AttackStartLeftPower') or sametext(atkeID, 'attackStartRightPower') then begin
    seev(e, 'ATKD\Strike Angle', '45.0');
  end else if sametext(atkeID, 'AttackStartLeftRunningPower') or sametext(atkeID, 'attackStartRightPower') then begin
    seev(e, 'ATKD\Attack Angle', '-15.0');
    seev(e, 'ATKD\Strike Angle', '30.0');
  end else if sametext(atkeID, 'AttackStartRightRunningPower') then begin
    seev(e, 'ATKD\Attack Angle', '15.0');
    seev(e, 'ATKD\Strike Angle', '30.0');
  end else if sametext(atkeID, 'AttackStartLeftSide') or sametext(atkeID, 'AttackStartRightSide') then begin
    addDmgMult(e, -0.5);
    seev(e, 'ATKD\Strike Angle', '20.0');
  end;
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
    addKeyword(race, names.values['f314_StaggerStrong1']);
    result := true;
    exit;
  end;

  if ContainsStr(edid, 'Seeker') then begin
    addKeyword(race, names.values['f314_StaggerStrong4']);
    result := true;
    exit;
  end;

  if ContainsStr(edid, 'Gargoyle') then begin
    addKeyword(race, names.values['f314_StaggerStrong3']);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Atronach') or sametext(edid, 'mihailclannfearrace') then begin
    seev(race, 'DATA\Base Mass', '2.0');
    
    if ContainsStr(edid, 'Frost') then begin
      seev(race, 'DATA\Base Mass', '6.0');
      addKeyword(race, names.values['f314_StaggerStrong3']);
      
      x := strtofloat(geev(race, 'DATA - DATA\Angular Acceleration Rate'));
      seev(race, 'DATA - DATA\Angular Acceleration Rate', x * 2);
      x := strtofloat(geev(race, 'DATA - DATA\Unarmed Damage'));
      seev(race, 'DATA - DATA\Unarmed Damage', x * 2);
      
      tmp := ElementByPath(race, 'Attacks');
      if assigned(tmp) then
        for i:=0 to ElementCount(tmp)-1 do
          setAtronachFrostAttackData(ElementByIndex(tmp, i));
      result := true;
      exit;
    end;
    
    if ContainsStr(edid, 'Flame') or sametext(edid, 'mihailclannfearrace') then begin
      addKeyword(race, names.values['f314_StaggerStrong1']);
      result := true;
      exit;
    end;
    
    if ContainsStr(edid, 'Storm') then begin
      addKeyword(race, names.values['f314_StaggerStrong2']);
      result := true;
      exit;
    end;
    
    // warn('unknown Atronach: ' + name(race));
    exit;
  end;
  
  if ContainsStr(edid, 'Bear') then begin
    addKeyword(race, names.values['f314_StaggerStrong2']);
    seev(race, 'DATA\Base Mass', '3.5');
    
    x := strtofloat(geev(race, 'DATA - DATA\Unarmed Damage'));
    seev(race, 'DATA - DATA\Unarmed Damage', x * 1.5);
    x := strtofloat(geev(race, 'DATA - DATA\Unarmed Reach'));
    seev(race, 'DATA - DATA\Unarmed Reach', x * 0.8);
    
    tmp := ElementByPath(race, 'Attacks');
    if assigned(tmp) then
      for i:=0 to ElementCount(tmp)-1 do
        setBearAttackData(ElementByIndex(tmp, i));
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Cow') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Chaurus') or ContainsStr(edid, 'Siligonder') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    addKeyword(race, names.values['f314_EasyKnockable']);
    seev(race, 'DATA\Base Mass', '2.5');
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Deer') or ContainsStr(edid, 'Stag') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    result := true;
    exit;
  end;

  if ContainsStr(edid, 'Dog') or ContainsStr(edid, 'Husky') then begin
    // f314_StaggerStrong0 = none
    addKeyword(race, names.values['f314_EasyKnockable']);
    result := true;
    exit;
  end;
  
  if (ContainsStr(edid, 'Dragon') or ContainsStr(edid, 'AlduinRace')) and not ContainsStr(edid, 'Priest') then begin
    addKeyword(race, names.values['f314_StaggerStrong4']);
    seev(race, 'DATA\Angular Acceleration Rate', '10.0');
    // starting health skip
    seev(race, 'DATA\Unarmed Reach', '180.0');
    seev(race, 'DATA\Stamina Regen', '1.0');
    seev(race, 'DATA\Base Mass', '10.0');
    
    if sametext(edid, 'AlduinRace') then
      seev(race, 'DATA\Unarmed Damage', '150.0')
    else
      seev(race, 'DATA\Unarmed Damage', '100.0');
      
    tmp := ElementByPath(race, 'Attacks');
    if assigned(tmp) then
      for i:=0 to ElementCount(tmp)-1 do
        setDragonAttackData(ElementByIndex(tmp, i));
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'DragonPriest') or ContainsStr(edid, 'LichRace') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Draugr') or ContainsStr(edid, 'Zombie') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    seev(race, 'DATA\Base Mass', '2.0');
    result := true;
    exit;
  end;
  
  if sametext(edid, 'ElkRace') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Falmer') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    seev(race, 'DATA\Base Mass', '1.5');
    tmp := ElementByPath(race, 'Attacks');
    if assigned(tmp) then
      for i:=0 to ElementCount(tmp)-1 do
        setFalmerAttackData(ElementByIndex(tmp, i));
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'FrostbiteSpider') then begin
    if ContainsStr(edid, 'Giant') then begin
      addKeyword(race, names.values['f314_StaggerStrong2']);
      seev(race, 'DATA\Base Mass', '3.0');
    end else if ContainsStr(edid, 'Large') then begin
      addKeyword(race, names.values['f314_StaggerStrong1']);
      seev(race, 'DATA\Base Mass', '1.0');
    end else begin
      // f314_StaggerStrong0 = none
      addKeyword(race, names.values['f314_EasyKnockable']);
      seev(race, 'DATA\Base Mass', '0.2');
    end;
    tmp := ElementByPath(race, 'Attacks');
    if assigned(tmp) then
      for i:=0 to ElementCount(tmp)-1 do
        setSpiderAttackData(ElementByIndex(tmp, i));
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Goat') or ContainsStr(edid, 'Chicken') or ContainsStr(edid, 'Hare') or ContainsStr(edid, 'FoxRace') then begin
    // f314_StaggerStrong0
    addKeyword(race, names.values['f314_EasyKnockable']);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'GoblinRace') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    addKeyword(race, names.values['f314_EasyKnockable']);
    seev(race, 'DATA\Base Mass', '1.5');
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Hagraven') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Horker') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Horse') then begin
    addKeyword(race, names.values['f314_StaggerStrong2']);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'IceWraith') then begin
    // f314_StaggerStrong0
    seev(race, 'DATA\Base Mass', '0.7');
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Giant') or ContainsStr(edid, 'Lurker') or ContainsStr(edid, 'Ogre') then begin
    if ContainsStr(edid, 'Giant') then begin
      addKeyword(race, names.values['f314_StaggerStrong4']);
      seev(race, 'DATA\Base Mass', '8.0');
      // skiping health += 500
      x := strtofloat(geev(race, 'DATA - DATA\Unarmed Damage'));
      seev(race, 'DATA - DATA\Unarmed Damage', x * 2);
      seev(race, 'DATA - DATA\Unarmed Reach', '250.0');
      isGiant := true;
      result := true;
    end else if ContainsStr(edid, 'LurkerRace') or ContainsStr(edid, 'OgreRace') then begin
      addKeyword(race, names.values['f314_StaggerStrong3']);
      seev(race, 'DATA\Base Mass', '6.0');
      result := true;
    end else begin
      // warn('unknown giant, setting default: ' + name(race));
      result := false;
    end;
    
    seev(race, 'DATA\Angular Acceleration Rate', '5.0');
    addKeyword(race, names.values['f314_GiantRace']);
    tmp := ElementByPath(race, 'Attacks');
    if assigned(tmp) then
      for i:=0 to ElementCount(tmp)-1 do
        setGiantAttackData(ElementByIndex(tmp, i), isGiant);
        
    // result defined above
    exit;
  end;
  
  if ContainsStr(edid, 'Mammoth') then begin
    addKeyword(race, names.values['f314_StaggerStrong4']);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'MountainLion') then begin
    addKeyword(race, names.values['f314_StaggerStrong2']);
    seev(race, 'DATA\Base Mass', '2.0');
    x := strtofloat(geev(race, 'DATA - DATA\Unarmed Damage'));
    seev(race, 'DATA - DATA\Unarmed Damage', x * 1.2);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Mudcrab') then begin
    // f314_StaggerStrong0
    addKeyword(race, names.values['f314_EasyKnockable']);
    x := strtofloat(geev(race, 'DATA - DATA\Unarmed Reach'));
    seev(race, 'DATA - DATA\Unarmed Reach', x * 0.7);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Riekling') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    addKeyword(race, names.values['f314_EasyKnockable']);
    seev(race, 'DATA\Base Mass', '1.0');
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'SabreCat') or ContainsStr(edid, 'Boar') or ContainsStr(edid, 'Durzog') then begin
    addKeyword(race, names.values['f314_StaggerStrong2']);
    seev(race, 'DATA\Base Mass', '3.0');
    x := strtofloat(geev(race, 'DATA - DATA\Unarmed Damage'));
    seev(race, 'DATA - DATA\Unarmed Damage', x * 1.2);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Skeleton') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    seev(race, 'DATA\Base Mass', '1.5');
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Skeever') then begin
    // f314_StaggerStrong0 = none
    addKeyword(race, names.values['f314_EasyKnockable']);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Spriggan') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Troll') then begin
    addKeyword(race, names.values['f314_StaggerStrong2']);
    seev(race, 'DATA\Base Mass', '3.0');
    tmp := ElementByPath(race, 'Attacks');
    if assigned(tmp) then
      for i:=0 to ElementCount(tmp)-1 do
        setTrollAttackData(ElementByIndex(tmp, i));
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'VampireBeast') then begin
    addKeyword(race, names.values['f314_StaggerImmune']);
    addKeyword(race, names.values['f314_StaggerStrong3']);
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Werewolf') or sametext(edid, 'DLC2WerebearBeastRace') then begin
    addKeyword(race, names.values['f314_StaggerImmune']);
    addKeyword(race, names.values['f314_StaggerStrong3']);
    seev(race, 'DATA\Base Mass', '3.0');
    seev(race, 'DATA - DATA\Unarmed Reach', '127.0');
    tmp := ElementByPath(race, 'Attacks');
      if assigned(tmp) then
        for i:=0 to ElementCount(tmp)-1 do
          setWerewolfAttackData(ElementByIndex(tmp, i));
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Wisp') then begin
    // f314_StaggerStrong0
    seev(race, 'DATA\Base Mass', '0.2');
    result := true;
    exit;
  end;
  
  if ContainsStr(edid, 'Witchlight') then begin
    // f314_StaggerStrong0
    seev(race, 'DATA\Base Mass', '0.2');
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
      seev(race, 'DATA\Base Mass', '1.0');
      // f314_StaggerStrong0 = none
      addKeyword(race, names.values['f314_EasyKnockable']);
      result := true;
      exit;
    end;
    if ContainsStr(edid, 'Sphere') or ContainsStr(edid, 'DLC2DwarvenBallistaRace') then begin
      addKeyword(race, names.values['f314_StaggerStrong1']);
      addKeyword(race, names.values['f314_EasyKnockable']);
      seev(race, 'DATA\Base Mass', '2.5');
      tmp := ElementByPath(race, 'Attacks');
      if assigned(tmp) then
        for i:=0 to ElementCount(tmp)-1 do
          setDwarvenSphereAttackData(ElementByIndex(tmp, i));
      result := true;
      exit;
    end;
    if ContainsStr(edid, 'Centurion') then begin
      addKeyword(race, names.values['f314_StaggerStrong3']);
      seev(race, 'DATA\Base Mass', '8.0');
      tmp := ElementByPath(race, 'Attacks');
      if assigned(tmp) then
        for i:=0 to ElementCount(tmp)-1 do
          setDwarvenCenturionAttackData(ElementByIndex(tmp, i));
      result := true;
      exit;
    end;
    
    // warn('unknown Dwarven: ' + name(race));
    exit;
  end;
  
  if shouldIgnoreRace(edid) then begin
    result := true;
    addKeyword(race, names.values['f314_StaggerStrong1']);
    exit;
  end;

  //warn('unknown race: ' + name(race));
  // addKeyword(race, names.values['f314_StaggerStrong1']);
end;

function trialRace(race:IInterface; edid:string):boolean;
begin
  if not sametext(edid, '') then begin
    if patchRace_(race, edid) then begin
      // dbg('"' + edid + '" helped, setting it: ' + name(race));
      result := true;
      exit;
    end else begin
      // warn('nam8="' + edid+'" didnt help: ' + name(race));
    end;
  end;
  result := false;
end;

procedure patchRace(race:IInterface);
var x:float;
    tmp: IInterface;
    edid:string;
    i:integer;
    isGiant, isNPC:boolean;
begin
  x := strtofloat(geev(race, 'DATA - DATA\Angular Acceleration Rate'));
  seev(race, 'DATA - DATA\Angular Acceleration Rate', x * 7);  // settings.angularAccelerationMult = 7
  
  x := strtofloat(geev(race, 'DATA - DATA\Unarmed Reach'));
  seev(race, 'DATA - DATA\Unarmed Reach', x * 0.8);  // settings.unarmedReachMult = 7
  
  if HasKeyword(race, 'ActorTypeNPC') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    isNPC := true;
  end else begin
    x := strtofloat(geev(race, 'DATA - DATA\Unarmed Damage'));
    seev(race, 'DATA - DATA\Unarmed Damage', x * 2);  // settings.unarmedDamageMult = 2
  end;
  
  tmp := ElementByPath(race, 'Attacks');
  if assigned(tmp) and not sametext(edid, 'WerewolfBeastRace') and not sametext(edid, 'DLC2WerebearBeastRace') then begin
    for i:=0 to ElementCount(tmp)-1 do
      setGeneralAttackData(ElementByIndex(tmp, i));
  end;
  
  if trialRace(race, EditorID(race)) then exit;
  if trialRace(race, geev(race, 'NAM8')) then exit;
  if trialRace(race, geev(race, 'WKMV')) then exit;
  if trialRace(race, geev(race, 'VTCK\[0]')) then exit;
  if trialRace(race, geev(race, 'VTCK\[1]')) then exit;
  
  if sametext(geev(race, 'VTCK\[0]'), 'MaleEvenToned [VTYP:00013AD2]') then begin
    addKeyword(race, names.values['f314_StaggerStrong1']);
    exit;
  end;
  
  warn('race='+name(race));
  
  {
  if ContainsStr(edid, 'SphereDefault') then edid := 'DwarvenSphere';
  if ContainsStr(edid, 'SteamDefault') then edid := 'DwarvenCenturion';
  if ContainsStr(edid, 'SpiderDefault') then edid := 'FrostbiteSpider';
  if ContainsStr(edid, 'DaedraDefault') then edid := 'Dremora';
  if ContainsStr(edid, 'SphereDefault') then edid := 'DwarvenSphere';
  if ContainsStr(edid, 'SphereDefault') then edid := 'DwarvenSphere';
  if ContainsStr(edid, 'SphereDefault') then edid := 'DwarvenSphere';
  if ContainsStr(edid, 'SphereDefault') then edid := 'DwarvenSphere';
  if ContainsStr(edid, 'SphereDefault') then edid := 'DwarvenSphere';
  if ContainsStr(edid, 'SphereDefault') then edid := 'DwarvenSphere';
  if ContainsStr(edid, 'SphereDefault') then edid := 'DwarvenSphere';
  if ContainsStr(edid, 'SphereDefault') then edid := 'DwarvenSphere';
  if ContainsStr(edid, 'SphereDefault') then edid := 'DwarvenSphere';
  if ContainsStr(edid, 'SphereDefault') then edid := 'DwarvenSphere';
  
  }
end;

function isBoundWeap(weap:IInterface):boolean;
begin
  result := ContainsStr(geev(weap, 'Model\MODL - Model Filename'), 'BoundWeapons\')
       and (strtofloat(geev(weap, 'DATA\Weight')) <= 0.0);
end;

procedure setStagger(weap:IInterface; defaulWeight,mult:float);
var weight, stagger:float;
begin
  weight := strtofloat(geev(weap, 'DATA\Weight'));
  if weight <= 0 then weight := defaulWeight;
  stagger := weight * 0.01;
  seev(weap, 'DNAM\Stagger', stagger * mult);
end;

procedure setCritDamage(weap:IInterface; mult:float);
var x:integer;
begin
  x := strtoint(geev(weap, 'DATA\Damage'));
  seev(weap, 'CRDT\Damage', round(x * mult));
end;

procedure patchWeap(weap:IInterface);
var weaponType, equipsound:string;
    x:float;
begin
  weaponType := geev(weap, 'DNAM\Animation Type');
  
  x := strtofloat(geev(weap, 'DNAM\Speed'));
  seev(weap, 'DNAM\Speed', x * 0.8);  // settings.weaponSpeedMult = 0.8
  
  x := strtofloat(geev(weap, 'DNAM\Reach'));
  seev(weap, 'DNAM\Reach', x * 0.7);  // settings.weaponReachMult = 0,7
  
  x := strtofloat(geev(weap, 'DATA\Damage'));
  seev(weap, 'DATA\Damage', round(x * 2));  // settings.weaponDamageMult = 2
  
  if sametext(geev(weap, 'CRDT\Effect'), 'NULL - Null Reference [00000000]') then begin
    seev(weap, 'CRDT\Effect', names.values['f314_AttackCrit']);
    senv(weap, 'CRDT\Flags', genv(weap, 'CRDT\Flags') and $FFFFFFFE);
  end;
  
  if          sametext(weaponType, 'OneHandSword') then begin
    if isBoundWeap(weap) then begin
      seev(weap, 'DATA\Weight', '8.0')
    end;
    
    x := strtofloat(geev(weap, 'DNAM\Reach'));
    seev(weap, 'DNAM\Reach', x * 1.15);
    
    setStagger(weap, 8, 0.85);
    setCritDamage(weap, weaponCritDamageMult);
  end else if sametext(weaponType, 'OneHandDagger') then begin
    if isBoundWeap(weap) then begin
      seev(weap, 'DATA\Weight', '3.0')
    end;
    
    setStagger(weap, 3, 1);
    setCritDamage(weap, weaponCritDamageMult * 2);
  end else if sametext(weaponType, 'OneHandAxe') then begin
    if isBoundWeap(weap) then begin
      seev(weap, 'DATA\Weight', '10.0')
    end;
    
    x := strtofloat(geev(weap, 'DNAM\Speed'));
    seev(weap, 'DNAM\Speed', x * 1.1);
    x := strtofloat(geev(weap, 'DNAM\Reach'));
    seev(weap, 'DNAM\Reach', x * 0.8);
    x := strtofloat(geev(weap, 'DATA\Damage'));
    seev(weap, 'DATA\Damage', round(x * 1.1));
    
    setStagger(weap, 10, 1);
    setCritDamage(weap, weaponCritDamageMult);
  end else if sametext(weaponType, 'OneHandMace') then begin
    if isBoundWeap(weap) then begin
      seev(weap, 'DATA\Weight', '12.0')
    end;
    
    setStagger(weap, 12, 1);
    setCritDamage(weap, weaponCritDamageMult * 0.5);
  end else if sametext(weaponType, 'TwoHandSword') then begin
    if isBoundWeap(weap) then begin
      seev(weap, 'DATA\Weight', '14.0')
    end;
    
    x := strtofloat(geev(weap, 'DNAM\Reach'));
    seev(weap, 'DNAM\Reach', x * 1.15);
    x := strtofloat(geev(weap, 'DATA\Damage'));
    seev(weap, 'DATA\Damage', round(x * 0.9));
    
    setStagger(weap, 14, 1.35);
    setCritDamage(weap, weaponCritDamageMult);
  end else if sametext(weaponType, 'TwoHandAxe') then begin
    equipsound := geev(weap, 'NAM9');
    if sametext(equipsound, 'WPNBlunt2HandDraw [SNDR:000E4F10]') then begin
      if isBoundWeap(weap) then begin
        seev(weap, 'DATA\Weight', '18.0')
      end;
      x := strtofloat(geev(weap, 'DNAM\Speed'));
      seev(weap, 'DNAM\Speed', x * 0.9);
      x := strtofloat(geev(weap, 'DATA\Damage'));
      seev(weap, 'DATA\Damage', round(x * 0.9));
      setStagger(weap, 18, 1.65);
      setCritDamage(weap, weaponCritDamageMult * 0.5);
    end else begin
      if isBoundWeap(weap) then begin
        seev(weap, 'DATA\Weight', '16.0')
      end;
      x := strtofloat(geev(weap, 'DNAM\Speed'));
      seev(weap, 'DNAM\Speed', x * 1.1);
      x := strtofloat(geev(weap, 'DNAM\Reach'));
      seev(weap, 'DNAM\Reach', x * 0.8);
      setStagger(weap, 16, 1.5);
      setCritDamage(weap, weaponCritDamageMult);
    end;
  end else if sametext(weaponType, 'Bow') then begin
    equipsound := EditorID(weap);
    if ContainsStr(equipsound, 'Crossbow') or ContainsStr(equipsound, 'crossbow') then begin
      if isBoundWeap(weap) then begin
        seev(weap, 'DATA\Weight', '12.0')
      end;
      
      setStagger(weap, 12, 1.5);
      setCritDamage(weap, weaponCritDamageMult * 2);
    end else begin
      if isBoundWeap(weap) then begin
        seev(weap, 'DATA\Weight', '8.0')
      end;
      
      setStagger(weap, 8, 1);
      setCritDamage(weap, weaponCritDamageMult);
    end;
  end else if sametext(weaponType, 'Crossbow') then begin
    if isBoundWeap(weap) then begin
      seev(weap, 'DATA\Weight', '12.0')
    end;
    
    setStagger(weap, 12, 1.5);
    setCritDamage(weap, weaponCritDamageMult * 2);
  end else if sametext(weaponType, 'Staff') then begin
    if isBoundWeap(weap) then begin
      seev(weap, 'DATA\Weight', '8.0')
    end;
    
    x := strtofloat(geev(weap, 'DNAM\Reach'));
    seev(weap, 'DNAM\Reach', x * 1.15);
    
    setStagger(weap, 8, 1);
    setCritDamage(weap, weaponCritDamageMult * 0.5);
  end else begin
    // warn('unknown weap: ' + name(weap));
  end;
end;

function findEffect(spel:IInterface; id:string):IInterface;
var effs:IInterface;
    i:integer;
begin
  effs := ebp(spel, 'Effects');
  if not assigned(effs) then exit;
  for i:= 0 to elementcount(effs) - 1 do
    if sametext(inttohex(genv(elementbyindex(effs, i), 'EFID'), 8), id) then begin
      result := elementbyindex(effs, i);
      exit;
    end;
end;

procedure addEffect(spel:IInterface; id:string; mag:float; area, dur:integer);
var tmp:IInterface;
begin
  tmp:=ebp(spel, 'Effects');
  if not assigned(tmp) then begin
    addmessage('no effs, adding: ' + name(spel));
    tmp := add(spel, 'Effects', true);
  end;
  tmp:=ElementAssign(tmp, HighInteger, nil, false);
  seev(tmp, 'EFID', id);
  seev(tmp, 'EFIT\Magnitude', mag);
  seev(tmp, 'EFIT\Area', area);
  seev(tmp, 'EFIT\Duration', dur);
end;

procedure tuneDragonFireBreathSpells(spel:IInterface; mag:float; isPower:boolean);
begin
  senv(spel, 'SPIT\Flags', genv(spel, 'SPIT\Flags') or $00100000);  // ignore resist
  seev(spel, 'Effects\[0]\EFIT\Magnitude', mag);
  seev(spel, 'Effects\[0]\EFIT\Duration', 1);
  if isPower then 
    addEffect(spel, names.values['f314_StaggerPower'], 1, 1, 1)
  else
    addEffect(spel, names.values['f314_Stagger'], 1, 1, 1);
end;

function shouldProcessWeap(weap:IInterface):boolean;
begin
  if assigned(elementbysignature(weap, 'CNAM')) then begin
    // addmessage('template, has cnam, skipin: ' + name(weap));
    exit;
  end;
  if (strtofloat(geev(weap, 'DATA\Weight')) <= 0.0) and not ContainsStr(EditorID(weap), 'Bound') then begin
    // addmessage('no weight but no bound, skipin: ' + name(weap));
    exit;
  end;
  if not assigned(elementbypath(weap, 'DNAM\Animation Type')) then begin
    // addmessage('no DNAM, skipin: ' + name(weap));
    exit;
  end;
  result := true;
end;

procedure patchFileGroup(file:IInterface; sig:string);
var group, item:IInterface;
    i:integer;
begin
  group := GroupBySignature(file, sig);
  for i:=0 to ElementCount(group)-1 do begin
    item := ElementByIndex(group, i);
    if not IsMaster(item) then continue;
    item := WinningOverride(item);
    if GetIsDeleted(item) then continue;
    
    if sametext(sig, 'WEAP') then if not shouldProcessWeap(item) then continue;
    
    item := copywithmasters(item);
    
    if sametext(sig, 'WEAP') then patchWeap(item);
    if sametext(sig, 'RACE') then patchRace(item);
  end;
end;

function process(file:IInterface):integer;
begin
  patchFileGroup(file, 'WEAP');
  patchFileGroup(file, 'RACE');
end;

function Finalize: Integer;
begin
  shortIDs.free;
  names.free;
  staggeringAttacks.free;
  isPowerstaggeringAttack.free;
  racesToIgnore.free;
  CleanMasters(patchFile);
end;

end.
