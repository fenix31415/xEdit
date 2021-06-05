{
  Here should be a description
  -----
  
}

unit ConfigureImtired;
uses mteFunctions, uselesscore;

const SOURCE_FILE_NAME = 'imtired2.esp';

      SHIELD_L_LOW_ATTACK_DAMAGE   = 10.0;  // -n% lower attack damage
      SHIELD_L_LOW_SPEED           = 10.0;  // -n% lower speed

      SHIELD_H_LOW_ATTACK_DAMAGE   = 20.0;  // -n% lower attack damage
      SHIELD_H_LOW_SPEED           = 15.0;  // -n% lower speed
      
      BOW_L_LOW_SPEED = 5.0;
      BOW_H_LOW_SPEED = 10.0;
      
      ARMOR_LIGHT =  1.0;    // cloth
      ARMOR_MID   = -8.0;    // light
      ARMOR_HIGHT = -15.0;   // heavy
      
      BOW_LH_BORDER = 10.0;
      BOW_L_DMG = 10.0;
      BOW_H_DMG = 20.0;
      
      STAMINARATE_A = 0.646248;
      STAMINARATE_B = 9.920867;
      STAMINARATE_COMBATMULT = 0.5;

function Initialize: integer;
begin
  ScriptProcessElements := [etFile];
end;

function findrec(id:string):IInterface;
begin
  result := findRecord(SOURCE_FILE_NAME, id);
end;

function Finalize(): Integer;
var e, f:IInterface;
begin
  f := filebyname(SOURCE_FILE_NAME);
  
  // f314IM_ShieldPerk_H
  e := findrec('01A277');
  seev(e, 'Effects\[1]\Function Parameters\EPFD\Float', (100.0 - SHIELD_H_LOW_ATTACK_DAMAGE) / 100.0);
  
  // f314IM_ShieldPerk_L
  e := findrec('02E694');
  seev(e, 'Effects\[1]\Function Parameters\EPFD\Float', (100.0 - SHIELD_L_LOW_ATTACK_DAMAGE) / 100.0);
  
  // f314IM_Shield_SpeedSpell_H
  e := findrec('02447C');
  seev(e, 'Effects\[0]\EFIT\Magnitude', -SHIELD_H_LOW_SPEED);
  
  // f314IM_Shield_SpeedSpell_L
  e := findrec('02E693');
  seev(e, 'Effects\[0]\EFIT\Magnitude', -SHIELD_L_LOW_SPEED);
  
  // f314IM_ArmorSpeedSpell[1, 2, 3]
  seev(findrec('02E680'), 'Effects\[0]\EFIT\Magnitude', ARMOR_LIGHT);
  seev(findrec('02E681'), 'Effects\[0]\EFIT\Magnitude', ARMOR_MID);
  seev(findrec('02E682'), 'Effects\[0]\EFIT\Magnitude', ARMOR_HIGHT);
  
  // f314IM_BowStamina
  e := findrec('02E68F');
  seev(e, 'Effects\[0]\EFIT\Magnitude', BOW_L_DMG);
  seev(e, 'Effects\[1]\EFIT\Magnitude', BOW_H_DMG);
  seev(e, 'Effects\[0]\Conditions\[2]\CTDA\Comparison Value - Float', BOW_LH_BORDER);
  seev(e, 'Effects\[1]\Conditions\[2]\CTDA\Comparison Value - Float', BOW_LH_BORDER);
  
  // f314IM_NPControl
  e := findrec('000D69');
  seev(e, 'Effects\[0]\EFIT\Magnitude', (BOW_L_DMG + BOW_H_DMG) / 2.0);
  
  // f314IM_PlayerStaminaRegenControl
  e := findrec('02E68E');
  seev(e, 'VMAD\Scripts\[0]\Properties\[0]\Float', STAMINARATE_A);
  seev(e, 'VMAD\Scripts\[0]\Properties\[1]\Float', STAMINARATE_B);
  
  // fCombatStaminaRegenRateMult
  e := RecordByFormID(f, strtoint('$0002DD34'), false);
  seev(e, 'DATA\Float', STAMINARATE_COMBATMULT);
  
  // f314IM_Bow_SpeedSpell_H
  e := findrec('02E6B2');
  seev(e, 'Effects\[0]\EFIT\Magnitude', -BOW_H_LOW_SPEED);
  
  // f314IM_Bow_SpeedSpell_L
  e := findrec('02E6B1');
  seev(e, 'Effects\[0]\EFIT\Magnitude', -BOW_L_LOW_SPEED);
end;

end.
