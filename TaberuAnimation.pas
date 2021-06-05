{
  Adds min stamina requiments for some actions
  ----
  
}
unit IHateAnimations;
uses mteFunctions, uselessCore;

const SOURCE_FILE_NAME = 'TaberuAnimation.esp';
      PATCH_FILE_NAME  = 'TaberuAnimation_Patch.esp';
      
var aaa_cooltimeTaberenai_ME:IInterface;
    knownModels:TStringList;

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
  AddMasterIfMissing(patchFile, 'HearthFires.esm');
  AddMasterIfMissing(patchFile, 'Dragonborn.esm');
  AddMasterIfMissing(patchFile, SOURCE_FILE_NAME);
  
  aaa_cooltimeTaberenai_ME := findrecord('TaberuAnimation.esp', '006398');
  
  knownModels := TStringList.create;
  
knownModels.Values['Clutter\Ingredients\Mead01.nif tsDragonsBreath'] := '000802';
knownModels.Values['Clutter\Ingredients\Mead01.nif tsNordMead'] := '000805';
knownModels.Values['Clutter\Wine\WineBottle01A.nif tsHolyWaterJessicasWine'] := '000808';
knownModels.Values['Clutter\Ingredients\Mead01.nif tsAshfireMead'] := '00080B';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupTastyChicken_quilb'] := '005903';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStStewTripe_RWS'] := '005906';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupSnowberry_quilb'] := '00590C';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupBeefEgg_quilb'] := '00590F';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupEggCabbageStew_quilb'] := '005912';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupBeefNutStew_quilb'] := '005915';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupBeefPotatoStew_quilb'] := '005918';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupBoarVegStew_quilb'] := '00591B';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupChickenStew_quilb'] := '00591E';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupShreddedChicken_quilb'] := '005921';
knownModels.Values['Clutter\DeadAnimals\PheasantMeatCooked01.nif CACO_TxStGoatMeatCooked_KRY'] := '005924';
knownModels.Values['Clutter\Food\CookedChickenMeat01.nif CACO_TxStGoatMeatCooked_KRY'] := '005924';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupCreamyVeg_quilb'] := '005927';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStStew01_CookingExpanded'] := '00592A';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupBaconPotato_quilb'] := '00592D';
knownModels.Values['Clutter\Ingredients\Stew.nif'] := '005930';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupMeatBall_quilb'] := '005933';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStPotageMagnifique01_SL00'] := '005936';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupPulledPorkRagout_quilb'] := '005939';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupRabbit_Wolfs'] := '00593C';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStStewHeart_SL00'] := '00593F';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupSalmonHerb_quilb'] := '005942';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupChunkySalmon_quilb'] := '005945';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxSSoupMushroom_CookingExpanded'] := '005948';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupSpicySalmon_quilb'] := '00594B';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupSeafoodMedley_quilb'] := '00594E';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupSlaughterfish_quilb'] := '005951';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupSlowCookedPork_quilb'] := '005954';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupLeekBacon_quilb'] := '005957';
knownModels.Values['CCOR\Alchemy\food\nernies\stew.nif CACO_TxStSoup04_Nernie'] := '00595A';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupGourdCarrotStew_quilb'] := '00595A';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStSoupWoodmansStew_quilb'] := '00595D';
knownModels.Values['Clutter\Ingredients\Stew.nif CACO_TxStYamSoup_CookingExpanded'] := '005960';
knownModels.Values['CCOR\Alchemy\food\nernies\stew.nif CACO_TxStSoup01_Nernie'] := '005963';
knownModels.Values['CCOR\Alchemy\food\nernies\stew.nif CACO_TxStPorridge01_Nernie'] := '005966';
knownModels.Values['CCOR\Alchemy\Food\BabettesFeast\beefStroganoff.nif'] := '00596F';
knownModels.Values['CCOR\Alchemy\Food\BabettesFeast\coqAuVin.nif'] := '005972';
knownModels.Values['CCOR\Alchemy\Food\BabettesFeast\clamChowder.nif'] := '005975';
knownModels.Values['CCOR\Alchemy\Food\BabettesFeast\vichyssoise.nif'] := '005978';
knownModels.Values['CCOR\Alchemy\food\nernies\stew.nif CACO_TxStPorridge02_Nernie'] := '00597B';
knownModels.Values['CCOR\Alchemy\Food\BabettesFeast\soupeAuPistou.nif'] := '00597E';
knownModels.Values['CCOR\Alchemy\food\nernies\stew.nif CACO_TxStSoup02_Nernie'] := '005981';
knownModels.Values['CCOR\Alchemy\Food\BabettesFeast\bouillabaisse.nif'] := '005984';
knownModels.Values['Clutter\Ingredients\Mead01.nif CACO_TxStDrinkMilk'] := '005987';
knownModels.Values['CCOR\Alchemy\Food\nernies\carryjug01.nif'] := '005987';
knownModels.Values['CCOR\Alchemy\food\nernies\stew.nif CACO_TxStSoup03_Nernie'] := '00598A';
knownModels.Values['CCOR\Alchemy\Food\ale.nif'] := '00FBB0';
knownModels.Values['CCOR\Alchemy\Food\nernies\breaddark.nif'] := '00FBB3';
knownModels.Values['CCOR\Alchemy\Food\nernies\breadround01.nif'] := '00FBB8';
knownModels.Values['CCOR\Alchemy\Food\nernies\breadround02.nif'] := '00FBB9';
knownModels.Values['CCOR\Alchemy\Food\nernies\breaddark02.nif CACO_TxStBread02Light_Nernie'] := '00FBBC';
knownModels.Values['CCOR\Alchemy\Food\nernies\breaddark02.nif'] := '00FBBF';
knownModels.Values['Clutter\Food\Bread01B.nif CACO_TxStBreadRound01_Nernie'] := '00FBC2';
knownModels.Values['Clutter\Food\Bread01B.nif CACO_TxStBreadRound02_Nernie'] := '00FBC5';
knownModels.Values['Clutter\Food\Bread01B.nif CACO_TxStBread02Light_Nernie'] := '00FBC8';
knownModels.Values['Clutter\Food\Bread01B.nif CACO_TxStBread02Dark_Nernie'] := '00FBCB';
knownModels.Values['CCOR\Alchemy\Food\nernies\cheesewedge01.nif'] := '00FBCE';
knownModels.Values['CCOR\Alchemy\Food\nernies\cheesewedge02.nif'] := '00FBD1';
knownModels.Values['CCOR\Alchemy\Food\nernies\cheesewedge03.nif'] := '00FBD3';
knownModels.Values['CCOR\Alchemy\Food\PieSlice.nif'] := '00FBD7';
knownModels.Values['CCOR\Alchemy\Food\Insanity\Tart.nif'] := '00FBDA';
knownModels.Values['CCOR\Alchemy\Food\BabettesFeast\beerBatteredSpadetail.nif'] := '00FBDD';
knownModels.Values['CCOR\Alchemy\Food\BabettesFeast\snowberryPie.nif'] := '00FBE0';
knownModels.Values['CCOR\Alchemy\Food\BabettesFeast\meatPotatoPie.nif'] := '00FBE3';
knownModels.Values['CCOR\Alchemy\Food\BabettesFeast\cheeseMushroomQuiche.nif'] := '00FBE6';
knownModels.Values['CCOR\Alchemy\Food\BabettesFeast\gravlax.nif'] := '00FBE9';
knownModels.Values['CCOR\Alchemy\Food\nernies\cheesewheel01a.nif'] := '00FBEC';
knownModels.Values['CCOR\Alchemy\Food\nernies\cheesewheel01b.nif'] := '00FBEC';
knownModels.Values['CCOR\Alchemy\Food\nernies\cheesewheel02a.nif'] := '00FBED';
knownModels.Values['CCOR\Alchemy\Food\nernies\cheesewheel02b.nif'] := '00FBED';
knownModels.Values['CCOR\Alchemy\Food\nernies\cheesewheel03a.nif'] := '00FBF2';
knownModels.Values['CCOR\Alchemy\Food\nernies\cheesewheel03b.nif'] := '00FBF2';
knownModels.Values['Clutter\Food\Bread01B.nif CACO_TxStBread01Dark_Nernie'] := '00FBF5';
knownModels.Values['CCOR\Alchemy\Food\nernies\curedmeat01.nif'] := '00FBF8';
knownModels.Values['Clutter\Food\CookedChickenMeat01.nif CACO_TxStBraisedMeat3_Halk'] := '00FBFB';
knownModels.Values['CCOR\Alchemy\Food\halk\beefmeatcooked.nif CACO_TxStBraisedMeat4_Halk'] := '00FBFE';
knownModels.Values['Clutter\DeadAnimals\PheasantMeatCooked01.nif CACO_TxStBraisedMeat4_Halk'] := '00FC06';
knownModels.Values['Clutter\Food\CookedChickenMeat01.nif CACO_TxStBraisedMeat2_Halk'] := '00FC07';
knownModels.Values['CCOR\Alchemy\Food\halk\beefmeatcooked.nif CACO_TxStBraisedMeat3_Halk'] := '00FC0B';
knownModels.Values['CCOR\Alchemy\Food\halk\beefmeatcooked.nif CACO_TxStBraisedMeat2_Halk'] := '00FC0D';
knownModels.Values['Clutter\Ingredients\Stew.nif BYOHTextureSetHorkerStew'] := '01B1E8';
knownModels.Values['Clutter\Ingredients\Stew.nif BYOHTextureSetElsweyrFondue'] := '01B1E9';
knownModels.Values['Clutter\Ingredients\Stew.nif BYOHTextureSetClamChowder'] := '01B1EA';
knownModels.Values['Clutter\Ingredients\Stew.nif BYOHTextureSetCabbagePotatoSoup'] := '01B1EB';
knownModels.Values['Clutter\Ingredients\Stew.nif BYOHTextureSetBeefStew'] := '01B1EC';
knownModels.Values['Clutter\Ingredients\Stew.nif BYOHTextureSetAppleCabbageStew'] := '01B1ED';
knownModels.Values['Clutter\Potions\MeadBlackBriar.nif tsMead tsMeadLabel01'] := '01B75C';
knownModels.Values['Clutter\Potions\BlackBriarPrivateReserve.nif tsMeadLight tsMeadLabel02'] := '01B75D';
knownModels.Values['Clutter\Potions\MeadHonningBrew01.nif tsMead tsMeadLabel01'] := '01B75E';
knownModels.Values['CCOR\Alchemy\Food\TF_MWClutter\brandybottle.nif'] := '01BCCF';
knownModels.Values['Clutter\Wine\WineBottle01A.nif tsWine'] := '01BCCF';
knownModels.Values['CCOR\Alchemy\Food\nernies\winebottle.nif'] := '01BCCF';
knownModels.Values['Clutter\Wine\WineBottle01B.nif tsWine tsWine tsWine'] := '01BCD0';
knownModels.Values['Clutter\Wine\WineBottle02A.nif tsWine'] := '01BCD1';
knownModels.Values['Clutter\Wine\WineBottle02A.nif'] := '01BCD1';
knownModels.Values['Clutter\Wine\WineBottle02B.nif tsWine tsWine tsWine'] := '01BCD2';
knownModels.Values['Clutter\Wine\WineBottle02B.nif'] := '01BCD2';
knownModels.Values['Clutter\Wine\WineSanSpicedwine.nif'] := '01BCD3';
knownModels.Values['Clutter\Quest\FirebrandWine01.nif'] := '01C23A';
knownModels.Values['_BYOH\Clutter\Wine\WineBottle03.nif'] := '01C7A1';
knownModels.Values['_BYOH\Clutter\Wine\WineBottle04.nif'] := '01CD08';
knownModels.Values['Clutter\Ingredients\Stew.nif DLC2TextureSetCabbageSoup'] := '01FBD4';
knownModels.Values['_BYOH\Clutter\Food\BraidedBread01.nif'] := '04D85C';
knownModels.Values['Clutter\Food\Apple01.nif'] := '001D8A';
knownModels.Values['_BYOH\Clutter\Food\MudcrabLegsCooked01.nif'] := '052963';
knownModels.Values['Clutter\Food\Apple02.nif'] := '001D8B';
knownModels.Values['Clutter\Ingredients\Tomato.nif'] := '004E07';
knownModels.Values['_BYOH\Clutter\Food\Dumpling01.nif'] := '05CB6C';
knownModels.Values['Clutter\Food\Bread01A.nif BYOHTextureSetPotatoBread'] := '05CB70';
knownModels.Values['_BYOH\Clutter\Food\Tart01.nif BYOHTextureSetJuniperBerryTart'] := '061C7A';
knownModels.Values['_BYOH\Clutter\Food\Tart01.nif BYOHTextureSetJazBayTart'] := '061C79';
knownModels.Values['Clutter\Food\CheeseWedge01.nif'] := '0058D0';
knownModels.Values['_BYOH\Clutter\Food\Tart01.nif'] := '061C7B';
knownModels.Values['_BYOH\Clutter\Food\GarlicBread01.nif'] := '066D81';
knownModels.Values['Clutter\Food\CheeseWedge02.nif'] := '005E35';
knownModels.Values['Clutter\DeadAnimals\SalmonMeat01.nif BYOHTextureSetSalmonSteak02'] := '070F8A';
knownModels.Values['Clutter\Ingredients\GoatMeatCooked.nif'] := '006E5E';
knownModels.Values['DLC02\Clutter\DLC02BoarMeatCooked.nif'] := '080294';
knownModels.Values['Clutter\Ingredients\MammothMeatCooked.nif'] := '007925';
knownModels.Values['Clutter\Ingredients\VenisonCooked.nif'] := '0083EE';
knownModels.Values['Clutter\Ingredients\Venison.nif CACO_VenisonMeatCookedTexture'] := '0083EE';
knownModels.Values['DLC02\Clutter\DLC02CyrodilacWine.nif'] := '08A498';
knownModels.Values['DLC02\Clutter\DLC02LocalLiquor.nif'] := '0946A2';
knownModels.Values['Clutter\Ingredients\HorseMeatCooked.nif'] := '008953';
knownModels.Values['DLC02\Clutter\DLC2Shein.nif'] := '09E8AC';
knownModels.Values['Clutter\Ingredients\HorkerMeatCooked.nif'] := '008EB8';
knownModels.Values['Clutter\Ingredients\BeefMeatCooked.nif'] := '00941D';
knownModels.Values['DLC02\Clutter\DLC2Matze1.nif'] := '0A39B4';
knownModels.Values['DLC01\Plants\SoulHuskIngredient01.nif'] := '0A8AB8';
knownModels.Values['Clutter\Food\CookedChickenMeat01.nif'] := '00A449';
knownModels.Values['Clutter\Ingredients\MammothCheeseBowl.nif'] := '0ADBBD';
knownModels.Values['Clutter\DeadAnimals\PheasantMeatCooked01.nif'] := '00AF11';
knownModels.Values['Clutter\DeadAnimals\RabbitMeatCooked01.nif'] := '00B476';
knownModels.Values['Clutter\Ingredients\Stew.nif BYOHTextureSetButter'] := '0BCEC6';
knownModels.Values['Clutter\Ingredients\Stew.nif DLC2TextureSetHorkerAshYamStew'] := '0D12CE';
knownModels.Values['Clutter\Food\CheeseWheel02A.nif'] := '00B9DB';
knownModels.Values['Plants\Cabbage01.nif'] := '0D63D4';
knownModels.Values['Plants\Potato01.nif'] := '0DB4DA';
knownModels.Values['Clutter\Food\CheeseWheel02B.nif'] := '00BF40';
knownModels.Values['Clutter\Food\CheeseWheel01A.nif'] := '00C4A7';
knownModels.Values['DLC02\Plants\DLC2AshYam01.nif'] := '0E05E0';
knownModels.Values['Clutter\Food\CheeseWheel01B.nif'] := '00C4A8';
knownModels.Values['Clutter\Ingredients\Carrot01.nif'] := '0E56E7';
knownModels.Values['Plants\Leek01.nif'] := '0EA7EC';
knownModels.Values['Clutter\Ingredients\SweetRoll01.nif'] := '00CF70';
knownModels.Values['Plants\Gourd01.nif'] := '0EF8F1';
knownModels.Values['Clutter\Food\CookedSalmonSteak01.nif'] := '00DF9C';
knownModels.Values['Clutter\Ingredients\Clam\ClamMeat.nif'] := '0F9AF8';
knownModels.Values['Clutter\Food\CookedSlaughterfishSteak01.nif'] := '00DF9D';
knownModels.Values['Clutter\Food\CharredSkeeverMeat01.nif'] := '00FA8D';
knownModels.Values['Clutter\Ingredients\HorkerMeat.nif'] := '0FEC00';
knownModels.Values['Clutter\Food\Bread01A.nif'] := '010AB7';
knownModels.Values['Clutter\Ingredients\BeefMeat.nif'] := '108E06';
knownModels.Values['Clutter\Food\Bread01B.nif'] := '011580';
knownModels.Values['DLC02\Clutter\DLC02AshHopperMeat.nif'] := '11300C';
knownModels.Values['Clutter\Food\GrilledPotatoes01.nif'] := '011AE5';
knownModels.Values['Clutter\Ingredients\DogMeat.nif'] := '11D213';
knownModels.Values['Clutter\Food\GrilledLeeks01.nif'] := '0135DD';
knownModels.Values['DLC02\Clutter\DLC02ScribMeat.nif'] := '122318';
knownModels.Values['Clutter\Food\LongTaffy01.nif'] := '013B43';
knownModels.Values['_BYOH\Clutter\Food\FlourSack01.nif'] := '127421';
knownModels.Values['Clutter\Ingredients\Pie01.nif'] := '0140AA';
knownModels.Values['DLC02\Clutter\DLC02BoarMeat.nif'] := '14AB2D';
knownModels.Values['Clutter\Food\ButterscotchCreams01.nif'] := '014B73';
knownModels.Values['Clutter\DeadAnimals\PheasantMeat01.nif'] := '14FC31';
knownModels.Values['Clutter\DeadAnimals\PheasantMeat01.nif TextureSetChickenMeat'] := '14FC36';
knownModels.Values['Clutter\Food\NuttyBread01.nif'] := '0150DA';
knownModels.Values['Clutter\Ingredients\HorseMeat.nif'] := '154D3D';
knownModels.Values['CCOR\Alchemy\Food\ale.nif CACO_TxStDrinkArgonianAle'] := '01610A';
knownModels.Values['Clutter\Ingredients\Mead01.nif CACO_TxStMeadJuniper_KRY'] := '01610A';
knownModels.Values['Clutter\Ingredients\GoatMeat.nif'] := '159E42';
knownModels.Values['Clutter\Ingredients\Stew.nif BYOHTextureSetVenisonStew'] := '01B1E4';
knownModels.Values['Clutter\Ingredients\MammothMeat.nif'] := '15EF47';
knownModels.Values['_BYOH\Clutter\Food\MudcrabLegs01.nif'] := '16914E';
knownModels.Values['Clutter\Ingredients\Stew.nif BYOHTextureSetVegetableSoup'] := '01B1E5';
knownModels.Values['Clutter\DeadAnimals\RabbitMeat01.nif'] := '16E253';
knownModels.Values['Clutter\Ingredients\Stew.nif BYOHTextureSetTomatoSoup'] := '01B1E6';
knownModels.Values['Clutter\DeadAnimals\SalmonMeat01.nif'] := '178459';
knownModels.Values['Clutter\Ingredients\Stew.nif BYOHTextureSetPotatoSoup'] := '01B1E7';
knownModels.Values['Clutter\Ingredients\Venison.nif'] := '17D55E';
knownModels.Values['Clutter\HoneyPot01.nif'] := '182662';
end;

function findFoodAnimEffect(e:IInterface):IInterface;
var s:string;
begin
  s := geev(e, 'Model\MODL');
  s := knownModels.values[s];
  if sametext(s, '') then exit;
  
  result := findrecord('TaberuAnimation.esp', s);
end;

function genKey(e:IInterface):string;
var i:integer;
begin
  result := geev(e, 'Model\MODL');
  e := ebp(e, 'Model\MODS');
  for i:=0 to elementcount(e)-1 do
    result := result + ' ' + editorid(linksto(ebp(elementbyindex(e, i), 'New Texture')));
end;

procedure grep(e:IInterface);
var r:IInterface;
    i:integer;
begin
  if (referencedbycount(e) > 100) or (referencedbycount(e) = 0) then exit;
  
  r := referencedbyindex(e, 0);
  for i := 0 to referencedbycount(e)-1 do begin
    r := referencedbyindex(e, i);
    if not sametext(signature(r), 'ALCH') then continue;
    r := WinningOverride(r);
    addmessage(genKey(r) + ' ' + inttohex(formid(e), 8));
  end;
end;

procedure dosmth(e:IInterface);
var eff:IInterface;
begin
  if (genv(e, 'ENIT\Flags') and $2 = 0) then exit;
  if assigned(findEffect(e, editorid(aaa_cooltimeTaberenai_ME))) then exit;
  
  eff := findFoodAnimEffect(e);
  if not assigned(eff) then exit;
  
  e := copyWithmasters(e);
  
  addEffect(e, name(eff), 0.0, 0, 5);
  addEffect(e, name(aaa_cooltimeTaberenai_ME), 0.0, 0, 6);
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
    
    dosmth(item);
  end;
end;

procedure grepAll(e:IInterface);
var item:IInterface;
    i:integer;
begin
  e := GroupBySignature(e, 'MGEF');
  if not assigned(e) then exit;
  for i:=0 to ElementCount(e)-1 do begin
    item := ElementByIndex(e, i);
    if not IsMaster(item) then continue;
    item := WinningOverride(item);
    if GetIsDeleted(item) then continue;
    
    grep(item);
  end;
end;

function process(e:IInterface):integer;
begin
  processFile(e, 'ALCH');
  //grepAll(e);
  
  //dosmth(e);
end;

function Finalize: Integer;
begin
  CleanMasters(patchFile);
end;

end.
