{
  Here should be a description
  ----
  
}
unit UnLvLIT;
uses mteFunctions, uselessCore;

const PATCH_FILE_NAME = '0_UnLvL.esp';
      REC_PATH = 'Edit Scripts/';

var zoneTypesByEDID, zoneTypesByKeyword, customFollowers, NPCsByEDID, NPCsByFaction, raceLevelModifiers: TJsonObject;
    followerFactions: TStringList;

procedure initDatabase();
begin
  followerFactions := TStringList.create;
  followerFactions.Add('PotentialFollowerFaction');
  followerFactions.Add('PotentialHirelingFaction');
  
  zoneTypesByEDID := TJsonObject.Create;
  zoneTypesByEDID.LoadFromFile(REC_PATH + 'UnLvL/zoneTypesByEDID.json');
  
  zoneTypesByKeyword := TJsonObject.Create;
  zoneTypesByKeyword.LoadFromFile(REC_PATH + 'UnLvL/zoneTypesByKeyword.json');
  
  customFollowers := TJsonObject.Create;
  customFollowers.LoadFromFile(REC_PATH + 'UnLvL/customFollowers.json');
  
  NPCsByEDID := TJsonObject.Create;
  NPCsByEDID.LoadFromFile(REC_PATH + 'UnLvL/NPCsByEDID.json');
  
  NPCsByFaction := TJsonObject.Create;
  NPCsByFaction.LoadFromFile(REC_PATH + 'UnLvL/NPCsByFaction.json');
  
  raceLevelModifiers := TJsonObject.Create;
  raceLevelModifiers.LoadFromFile(REC_PATH + 'UnLvL/raceLevelModifiers.json');
end;

function find(Obj: TJsonObject; key, what:string):TJsonObject;
var i, j:integer;
    keys: TJsonArray;
begin
  for i := 0 to Obj.A['data'].Count - 1 do begin
    keys := Obj.A['data'].O[i].A[what];
    for j := 0 to keys.Count - 1 do begin
      if ContainsText(key, keys.S[j]) then begin
        result := Obj.A['data'].O[i];
        exit;
      end;
    end;
  end;
end;

function findKeys(loc: IInterface):TJsonObject;
begin
  result := find(zoneTypesByEDID, EditorID(loc), 'Keys');
end;

function findKeywords(loc:IInterface):TJsonObject;
var keywords: TJsonArray;
    i, j: integer;
begin
  for i := 0 to zoneTypesByKeyword.A['data'].Count - 1 do begin
    keywords := zoneTypesByKeyword.A['data'].O[i].A['Keywords'];
    for j := 0 to keywords.Count - 1 do begin
      if HasKeyword(loc, keywords.S[j]) then begin
        if (not Assigned(result)) then
          result := zoneTypesByKeyword.A['data'].O[i]
        else if (result.I['MinLevel'] < zoneTypesByKeyword.A['data'].O[i].I['MinLevel']) then
          result := zoneTypesByKeyword.A['data'].O[i];
      end;
    end;
  end;
end;

function initDefault(e:IInterface):TJsonObject;
var minV, maxV: integer;
begin
  minV := genv(e, 'Min Level');
  maxV := genv(e, 'Max Level');
  
  if minV < 10 then minV := 10;
  if maxV <= 0 or maxV > 100 then maxV := minV * 3;
  
  result := TJsonObject.Create;
  result['MinLevel'] := minV;
  result['MaxLevel'] := maxV;
  result['Range'] := maxV - minV;
end;

function Initialize: integer;
begin
  initDatabase();

  ScriptProcessElements := [etFile];
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
end;

function process(f:IInterface):integer;
var group, cur:IInterface;
    i:integer;
begin
  tryProcess(f, 'NPC_');
  tryProcess(f, 'ECZN');
end;

procedure tryProcess(f:IInterface; sign: string);
var group, cur:IInterface;
    i: integer;
begin
  group := GroupBySignature(f, sign);
  if not assigned(group) then exit;
  
  for i := 0 to ElementCount(group) - 1 do begin
    cur := ElementByIndex(group, i);
    if not IsWinningOverride(cur) then continue;
    if GetIsDeleted(cur) then continue;
    
    if SameText(sign, 'NPC_') then unLVL_NPC_(cur);
    if SameText(sign, 'ECZN') then unLVL_ECZN(cur);
  end;
end;

procedure unLVL_ECZN(win:IInterface);
var e, loc:IInterface;
    min, max, minLvl, maxLvl: integer;
    zoneData: TJsonObject;
    keywords: TJsonArray;
begin
  if not Assigned(LinksTo(ebp(win, 'DATA\Location'))) then exit;

  e := ebp(copyWithMasters(win), 'DATA');
  loc := LinksTo(ebp(e, 'Location'));
  if not Assigned(loc) then exit;
  loc := WinningOverride(loc);
  
  zoneData := findKeys(loc);
  if not Assigned(zoneData) then begin
    zoneData := findKeywords(loc);
  end;
  if not Assigned(zoneData) then begin
    zoneData := initDefault(e);
  end;
  
  // clear 0x02 = Match PC Below Minimum Level and set 0x04 = Disable Combat Boundary
  senv(e, 'Flags', (genv(e, 'Flags') and $FFFFFFFD) or $04);
  
  min := zoneData.I['MinLevel'];
  max := zoneData.I['MaxLevel'] - zoneData.I['Range'];
  minLvl := RandomRange(min, max + 1);
  maxLvl := minLvl + zoneData.I['Range'];
  
  senv(e, 'Min Level', minLvl);
  senv(e, 'Max Level', maxLvl);
end;

function hasFactionJson(e: IInterface; list:TJsonArray):boolean;
var factions: IInterface;
    i, j:integer;
    curFaction:string;
begin
  factions := ebp(e, 'Factions');
  if not Assigned(factions) then exit;

  for i := 0 to ElementCount(factions) - 1 do begin
    curFaction := EditorID(LinksTo(ebp(ElementByIndex(factions, i), 'Faction')));
    for j := 0 to list.Count - 1 do begin
      if SameText(curFaction, list.S[j]) then begin
        result := true;
        exit;
      end;
    end;
  end;
end;

function findFollower(e:IInterface): boolean;
var i: integer;
    edID:string;
begin
  for i := 0 to customFollowers.A['data'].Count - 1 do begin
    if SameText(edID, customFollowers.A['data'].O[i].S['Key']) then begin
      result := true;
      exit;
    end;
  end;
end;

function hasFactionList(e: IInterface; list:TStringList):boolean;
var factions: IInterface;
    i:integer;
    curFaction:string;
begin
  factions := ebp(e, 'Factions');
  if not Assigned(factions) then exit;

  for i := 0 to ElementCount(factions) - 1 do begin
    curFaction := EditorID(LinksTo(ebp(ElementByIndex(factions, i), 'Faction')));
    if (list.find(curFaction, 0)) then begin
      result := true;
      exit;
    end;
  end;
end;

function isFollower(e:IInterface):boolean;
begin
  result := hasFactionList(e, followerFactions);
  if not result then result := findFollower(e);
end;

function getRace(e:IInterface):string;
var test:TStringList;
begin
  test := TStringList.Create;
  test.Delimiter := ' ';
  test.DelimitedText := geev(e, 'RNAM');
  result := test[0];
  test.free;
end;

function getStaticLevel(e:IInterface): integer;
var entry: TJsonObject;
    i, j, min, max:integer;
    factions: TJsonArray;
    mult:float;
    acbs:IInterface;
    race:string;
begin
  entry := find(NPCsByEDID, EditorID(e), 'Keys');
  if Assigned(entry) then begin
    result := entry.I['Level'];
    exit;
  end;
  
  for i := 0 to NPCsByFaction.A['data'].Count - 1 do begin
    factions := NPCsByFaction.A['data'].O[i].A['Factions'];
    if hasFactionJson(e, factions) then begin
      entry := NPCsByFaction.A['data'].O[i];
      break;
    end;
  end;
  
  if Assigned(entry) then begin
    if Assigned(entry.I['Level']) then begin
      result := entry.I['Level'];
    end else begin
      result := RandomRange(entry.I['MinLevel'], entry.I['MaxLevel'] + 1);
    end;
  end else begin
    acbs := ebp(e, 'ACBS');
    if (genv(acbs, 'Flags') and $80 > 0) then begin
      mult := strtofloat(geev(acbs, 'Level Mult'));
      if mult <= 1 then mult := 1;
      
      min := strtoint(geev(acbs, 'Calc min level'));
      max := strtoint(geev(acbs, 'Calc max level'));
      if min <= 1 then min := 1;
      
      if (max = 0) or (max > 81) then
        if (genv(acbs, 'Flags') and $20 > 0) then max := 81
        else max := (50 + min) div 2;
        
      result := floor((min+max)*(mult)/2);
    end else result := strtoint(geev(acbs, 'Level'));
  end;
  
  entry := find(raceLevelModifiers, getRace(e), 'Keys');
  if Assigned(entry) then result := result * entry.I['LevelModifier'];
end;

function shouldCopy(acbs:IInterface; follower: boolean; staticLevel: integer):boolean;
begin
  if not follower then begin
    //addMessage('not follower');
    result := result or ((genv(acbs, 'Flags') and $80) > 0);
    result := result or not SameText(genv(acbs, 'Level'), inttostr(staticLevel));
  end else begin
    //addMessage('follower');
    result := result or ((genv(acbs, 'Flags') and $80) = 0);
    result := result or (genv(acbs, 'Calc min level') <> floor(staticLevel * 0.5));
    result := result or (genv(acbs, 'Calc max level') <> floor(staticLevel * 1.5));
  end;
  //addMessage(booltostr(result));
end;

procedure unLVL_NPC_(win:IInterface);
var e, acbs:IInterface;
    edID: string;
    staticLevel: integer;
    follower:boolean;
begin
  if ContainsText(EditorID(win), 'Player') then exit;
  
  edID := EditorID(win);
  staticLevel := getStaticLevel(win);
  follower := isFollower(win);
  
  //AddMessage('chekin:' + name(win) + ' ' + inttostr(staticLevel));
  if not shouldCopy(ebp(win, 'ACBS'), follower, inttostr(staticLevel)) then exit;
  
  e := copyWithMasters(win);
  
  acbs := ebp(e, 'ACBS');
  if not follower then begin
    senv(acbs, 'Flags', genv(acbs, 'Flags') and $FFFFFF7F);
    seev(acbs, 'Level', inttostr(staticLevel));
  end else begin
    senv(acbs, 'Flags', genv(acbs, 'Flags') or $80);
    seev(acbs, 'Calc min level', floor(staticLevel * 0.5));
    seev(acbs, 'Calc max level', floor(staticLevel * 1.5));
  end;
end;

function Finalize: Integer;
begin
  CleanMasters(patchFile);
  
  followerFactions.free;
  
  zoneTypesByEDID.Free;
  zoneTypesByKeyword.Free;
  customFollowers.Free;
  NPCsByEDID.Free;
  NPCsByFaction.Free;
  raceLevelModifiers.Free;
end;

end.
