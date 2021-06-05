{
  Here should be a description
  -----
  
}

unit ScriptManuallyCleaner;
uses mteFunctions, uselesscore;

function removeAliasScript_(r:IInterface; alias, script:string):integerf45;
var i, j:integer;
    alScript, curAlias, aliases:IInterface;
begin
  aliases := ebp(r, 'VMAD\Aliases');
  if not assigned(aliases) then exit;
  
  for i:=0 to ElementCount(aliases)-1 do begin
    curAlias := ElementByIndex(aliases, i);
    if sametext(geev(curAlias, 'Object Union\Object v2\Alias'), alias) then begin
      aliases := ebp(curAlias, 'Alias Scripts');
      for j:=0 to ElementCount(aliases)-1 do begin
        alScript := ElementByIndex(aliases, j);
        if sametext(geev(alScript, 'ScriptName'), script) then begin
          remove(alScript);
          result := result + 1;
        end;
      end;
      if ElementCount(aliases) = 0 then begin
        remove(curAlias);
      end;
      break;
    end;
  end;
end;

function removeScript_(r:IInterface; script:string):integer;
var i:integer;
    cur, e:IInterface;
begin
  result := 0;
  e := ebp(r, 'VMAD\Scripts');
  if not assigned(e) then exit;
  
  for i:=0 to ElementCount(e)-1 do begin
    cur := ElementByIndex(e, i);
    if sametext(geev(cur, 'ScriptName'), script) then begin
      remove(cur);
      result := result + 1;
    end;
  end;
  
  e := ebp(r, 'VMAD\Script Fragments');
  if not assigned(e) then exit;
  
  if sametext(geev(e, 'FileName'), script) then begin
    remove(e);
    result := result + 1;
  end;
end;

procedure prompt(filename, id, script:string; count:integer);
begin
  if count = 0 then
    warn('unable to remove script "' + script + '" from record ' + id + ' at file "' + filename + '"')
  else if count == 1 then
    dbg('removed script "' + script + '" from record ' + id + ' at file ' + filename)
  else
    dbg('removed ' + inttostr(count) + ' scripts "' + script + '" from record ' + id + ' at file ' + filename);
end;

procedure removeScript(filename, id, script:string);
begin
  prompt(filename, id, script, removeScript_(findRecord(filename, id), script));
end;

procedure removeAliasScript(filename, id, alias, script:string);
begin
  prompt(filename, id, script, removeAliasScript_(findRecord(filename, id), alias, script));
end;

procedure removeScriptMid(filename:string; id:integer; script:string);
begin
  prompt(filename, inttohex(id, 8), script, removeScript_(RecordByFormID(filebyname(filename), id, false), script));
end;

function Finalize(): Integer;
begin
  removeScriptMid('SPERG-SSE.esp', $00064D68, '');
  
  removeScript('Midwood Isle.esp', '02E69E', 'TIF__0202E69E');
  removeScript('Midwood Isle.esp', '04BBC9', 'PF_FlorinBeatteBasketPatrol7_0304BBC9');

  removeAliasScript('Recorder Follower Base.esp', '00A603', '000 RecorderFollower', 'RecorderFollowerAliasScript');
  removeAliasScript('Recorder Follower Base.esp', '00A603', '001 Animal', 'TrainedAnimalScript');
  removeScript('Recorder Follower Base.esp', '00A603', 'RecorderDialogueFollowerScript');
  
  removeScript('Palaces Castles Enhanced.esp', '4B6FF7', 'NEWSCRIPTWHResolve');
  removeScript('Palaces Castles Enhanced.esp', '15317A', 'PF_AAACWFinaleHidePackageWin_0415317A');
  removeScript('Palaces Castles Enhanced.esp', '9DF580', 'PF_111PACKDGLumberjackCarry7_049DF580');
  removeScript('Palaces Castles Enhanced.esp', 'A4EDCE', 'PF_111PACKDGCarryItem_04A4EDCE');
  removeScript('Palaces Castles Enhanced.esp', '667491', 'AAAscriptRemoveRug');
  
  
  removeScript('WZOblivionArtifacts.esp', '1A603A', 'defaultAddItemArmorScript');
  removeScript('WZOblivionArtifacts.esp', '1A603A', 'defaultAddItemWeaponScript');
  removeScript('WZOblivionArtifacts.esp', '1A6041', 'defaultAddItemArmorScript');
  removeScript('WZOblivionArtifacts.esp', '1A603D', 'defaultAddItemArmorScript');
  removeScript('WZOblivionArtifacts.esp', '1A6046', 'defaultAddItemArmorScript');
  removeScript('WZOblivionArtifacts.esp', '1A6048', 'defaultAddItemArmorScript');

  removeAliasScript('Ambriel.esp', '0053CE', '008 Tiber Septim', 'FXunsommonSCRIPT');
  removeAliasScript('Ambriel.esp', '484B8C', '009 AQNaarifin16', 'FXunsommonSCRIPT');
  removeAliasScript('Ambriel.esp', '4C68F4', '001 Tiber', 'FXunsommonSCRIPT');
  removeAliasScript('Ambriel.esp', '1BA283', '000 Ambriel07', 'FXunsommonSCRIPT');
  removeAliasScript('Ambriel.esp', '1BA283', '001 Toorsil07', 'FXunsommonSCRIPT');
  removeAliasScript('Ambriel.esp', '1BA283', '005 Katariah07', 'FXunsommonSCRIPT');
  removeScript('Ambriel.esp', '3DD8D6', 'PF_AQAmbriel25Sithis150_043DD8D6');
  removeScript('Ambriel.esp', '5F1C2A', 'PF_AQPlayerAttacks02_045F1C2A');
  removeScript('Ambriel.esp', '5ECAE7', 'PF_AQPlayerAttacks_045ECAE7');
  removeScript('Ambriel.esp', '5F1C2B', 'PF_AQPlayerAttacks03_045F1C2B');

  removeScript('arnima.esm', '001D9B', 'TourCartDriverScript');
  removeScript('arnima.esm', '07DC8D', 'TIF__0407DC8D');
  
  removeScript('RigmorCyrodiil.esm', '2FEBAE', 'RigmorRoC01');
  removeScript('MoonAndStar_MAS.esp', '00AFEF', 'MASLuckOfTheEmperorScript');
  removeScript('WZOblivionArtifacts.esp', '1A603A', 'WZOBADisableActivatetest');
  removeScript('018Auri.esp', '332027', 'PF_018AuriRidePackage02_05332027');
  removeScript('AetheriumSwordsnArmor.esp', '0383EB', 'AetherialBoltScript');
  removeScript('icebladeofthemonarch.esp', '00494A', 'FFIBBarrierScript');
  removeScript('MysticismMagic.esp', '4D8EFA', 'EnergyBindingTest');
  removeScript('Inpa Sekiro Combat.esp', '087D91', 'sekiro_activatorscript');
  removeScript('TacticalValtheim.esp', 'CCC090', 'TacValt_MCMRegister');
  removeScript('Andromeda - Unique Standing Stones of Skyrim.esp', '000A08', 'PRKF_Aur_LordStone_Perk_2_Ab_03000A08');
  removeScript('DSer360MovementBehavior.esp', '0012C5', 'DSer360MovementBehavior_EnterFP');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('Lastrium_WeaponsArmor.esp', '0050E2', 'isilStingGlow');
  removeScript('tpos_complete02_RTCWG.esp', '777B16', 'CellReturn');
  removeScript('LC_BuildYourNobleHouse.esp', '00BEAD', 'LCKOnReadDeed');
  removeScript('Coldhaven.esm', '4AB2A0', 'QF_CH_Gwyndris_Dialogue_054AB2A0');
  removeScript('Tentapalooza.esp', '371314', 'RuseCheckForTent');
  removeScript('Wind District Breezehome - Reborn.esp', '6D4337', 'WeaponRackActivateSCRIPT');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
  removeScript('MLU.esp', '05CA97', 'BloodsbaneEffect');
end;

end.
