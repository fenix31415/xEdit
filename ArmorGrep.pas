{
  Here should be a description
  -----
  
}

unit ArmorGrep;
uses mteFunctions, uselesscore;

var files:Tstringlist;
    countClothBoot, countClothHelm, countClothArms, countClothCuri:integer;
    countLightBoot, countLightHelm, countLightArms, countLightCuri:integer;
    countHeavyBoot, countHeavyHelm, countHeavyArms, countHeavyCuri:integer;
    
    weightClothBoot, weightClothHelm, weightClothArms, weightClothCuri:float;
    weightLightBoot, weightLightHelm, weightLightArms, weightLightCuri:float;
    weightHeavyBoot, weightHeavyHelm, weightHeavyArms, weightHeavyCuri:float;
    
    weightClothBootMin, weightClothHelmMin, weightClothArmsMin, weightClothCuriMin:float;
    weightLightBootMin, weightLightHelmMin, weightLightArmsMin, weightLightCuriMin:float;
    weightHeavyBootMin, weightHeavyHelmMin, weightHeavyArmsMin, weightHeavyCuriMin:float;
    
    weightClothBootMax, weightClothHelmMax, weightClothArmsMax, weightClothCuriMax:float;
    weightLightBootMax, weightLightHelmMax, weightLightArmsMax, weightLightCuriMax:float;
    weightHeavyBootMax, weightHeavyHelmMax, weightHeavyArmsMax, weightHeavyCuriMax:float;
    
    weightClothBootMid, weightClothHelmMid, weightClothArmsMid, weightClothCuriMid:float;
    weightLightBootMid, weightLightHelmMid, weightLightArmsMid, weightLightCuriMid:float;
    weightHeavyBootMid, weightHeavyHelmMid, weightHeavyArmsMid, weightHeavyCuriMid:float;

function Initialize: integer;
var tmp, efile:IInterface;
    s:string;
    i:integer;
    rec: ZoneInfo;
begin
  ScriptProcessElements := [etFile];
  files:=Tstringlist.create;
  
  weightClothBootMin:=500.0;weightClothHelmMin:=500.0;weightClothArmsMin:=500.0;weightClothCuriMin:=500.0;;
  weightLightBootMin:=500.0;weightLightHelmMin:=500.0;weightLightArmsMin:=500.0;weightLightCuriMin:=500.0;;
  weightHeavyBootMin:=500.0;weightHeavyHelmMin:=500.0;weightHeavyArmsMin:=500.0;weightHeavyCuriMin:=500.0;;
  weightClothBootMax:=0.0;weightClothHelmMax:=0.0;weightClothArmsMax:=0.0;weightClothCuriMax:=0.0;;
  weightLightBootMax:=0.0;weightLightHelmMax:=0.0;weightLightArmsMax:=0.0;weightLightCuriMax:=0.0;;
  weightHeavyBootMax:=0.0;weightHeavyHelmMax:=0.0;weightHeavyArmsMax:=0.0;weightHeavyCuriMax:=0.0;;
  weightClothBoot:=0.0;weightClothHelm:=0.0;weightClothArms:=0.0;weightClothCuri:=0.0;
  weightLightBoot:=0.0;weightLightHelm:=0.0;weightLightArms:=0.0;weightLightCuri:=0.0;
  weightHeavyBoot:=0.0;weightHeavyHelm:=0.0;weightHeavyArms:=0.0;weightHeavyCuri:=0.0;
end;

function isBoots(e:IInterface):boolean;
begin
  result := (genv(e, 'BOD2\First Person Flags') and $80 > 0) and (genv(e, 'BOD2\First Person Flags') and $4 = 0);
end;

function isHelmet(e:IInterface):boolean;
begin
  result := (genv(e, 'BOD2\First Person Flags') and $1002 > 0) and (genv(e, 'BOD2\First Person Flags') and $4 = 0);
end;

function isArms(e:IInterface):boolean;
begin
  result := (genv(e, 'BOD2\First Person Flags') and $8 > 0) and (genv(e, 'BOD2\First Person Flags') and $4 = 0);
end;

function isCuriass(e:IInterface):boolean;
begin
  result := (genv(e, 'BOD2\First Person Flags') and $4 > 0);
end;

function getArmorType(e:IInterface):string;
begin
  if isCuriass(e) then result := 'CURI';
  if isBoots(e)   then result := 'BOOT';
  if isHelmet(e)  then result := 'HELM';
  if isArms(e)    then result := 'ARMS';
end;

procedure addEntry(w:float; atype, wtype:string; e:IInterface);
begin
  if sametext(atype, '') then exit;
  //if w = 0.0 then exit;

  if sametext(wtype, 'Clothing') and sametext(atype, 'CURI') then begin inc(countClothCuri); weightClothCuri := weightClothCuri + w; if weightClothCuriMin > w then weightClothCuriMin := w; if weightClothCuriMax < w then weightClothCuriMax := w; end;
  if sametext(wtype, 'Clothing') and sametext(atype, 'BOOT') then begin inc(countClothBoot); weightClothBoot := weightClothBoot + w; if weightClothBootMin > w then weightClothBootMin := w; if weightClothBootMax < w then weightClothBootMax := w; end;
  if sametext(wtype, 'Clothing') and sametext(atype, 'HELM') then begin inc(countClothHelm); weightClothHelm := weightClothHelm + w; if weightClothHelmMin > w then weightClothHelmMin := w; if weightClothHelmMax < w then weightClothHelmMax := w; end;
  if sametext(wtype, 'Clothing') and sametext(atype, 'ARMS') then begin inc(countClothArms); weightClothArms := weightClothArms + w; if weightClothArmsMin > w then weightClothArmsMin := w; if weightClothArmsMax < w then weightClothArmsMax := w; end;
  
  if sametext(wtype, 'Light Armor') and sametext(atype, 'CURI') then begin inc(countLightCuri); weightLightCuri := weightLightCuri + w; if weightLightCuriMin > w then weightLightCuriMin := w; if weightLightCuriMax < w then weightLightCuriMax := w;end;
  if sametext(wtype, 'Light Armor') and sametext(atype, 'BOOT') then begin inc(countLightBoot); weightLightBoot := weightLightBoot + w; if weightLightBootMin > w then weightLightBootMin := w; if weightLightBootMax < w then weightLightBootMax := w;end;
  if sametext(wtype, 'Light Armor') and sametext(atype, 'HELM') then begin inc(countLightHelm); weightLightHelm := weightLightHelm + w; if weightLightHelmMin > w then weightLightHelmMin := w; if weightLightHelmMax < w then weightLightHelmMax := w;end;
  if sametext(wtype, 'Light Armor') and sametext(atype, 'ARMS') then begin inc(countLightArms); weightLightArms := weightLightArms + w; if weightLightArmsMin > w then weightLightArmsMin := w; if weightLightArmsMax < w then weightLightArmsMax := w;end;
  
  if sametext(wtype, 'Heavy Armor') and sametext(atype, 'CURI') then begin inc(countHeavyCuri); weightHeavyCuri := weightHeavyCuri + w; if weightHeavyCuriMin > w then weightHeavyCuriMin := w; if weightHeavyCuriMax < w then weightHeavyCuriMax := w;end;
  if sametext(wtype, 'Heavy Armor') and sametext(atype, 'BOOT') then begin inc(countHeavyBoot); weightHeavyBoot := weightHeavyBoot + w; if weightHeavyBootMin > w then weightHeavyBootMin := w; if weightHeavyBootMax < w then weightHeavyBootMax := w;end;
  if sametext(wtype, 'Heavy Armor') and sametext(atype, 'HELM') then begin inc(countHeavyHelm); weightHeavyHelm := weightHeavyHelm + w; if weightHeavyHelmMin > w then weightHeavyHelmMin := w; if weightHeavyHelmMax < w then weightHeavyHelmMax := w;end;
  if sametext(wtype, 'Heavy Armor') and sametext(atype, 'ARMS') then begin inc(countHeavyArms); weightHeavyArms := weightHeavyArms + w; if weightHeavyArmsMin > w then weightHeavyArmsMin := w; if weightHeavyArmsMax < w then weightHeavyArmsMax := w;end;
  
  if sametext(wtype, 'Clothing')    then wtype := 'Cloth';
  if sametext(wtype, 'Light Armor') then wtype := 'Light';
  if sametext(wtype, 'Heavy Armor') then wtype := 'Heavy';
  addmessage(wtype + ' ' + atype + ' ' + inttohex(fixedformid(e), 8) + ' ' + floattostr(w));
end;

procedure dosmth(e:IInterface);
var t:string;
    wei:integer;
    i:integer;
begin
  t := geev(e, 'BOD2\Armor Type');
  if (sametext(t, 'Clothing') or sametext(t, 'Light Armor') or sametext(t, 'Heavy Armor'))
      and assigned(ebp(e, 'BOD2')) and assigned(ebp(e, 'FULL')) then
    if not containstext(editorid(e), 'skin') then
      addEntry(strtofloat(geev(e, 'DATA\Weight')), getArmorType(e), t, e);
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

function process(e:IInterface):integer;
begin
  files.add(getfilename(e));
end;

procedure processfiles();
var i:integer;
begin
  for i := 0 to files.count-1 do
    processFile(filebyname(files[i]), 'ARMO');
end;

function Finalize(): Integer;
var i:integer;
begin
  processfiles();

  if countClothBoot = 0 then countClothBoot := 1;
  if countLightBoot = 0 then countLightBoot := 1;
  if countHeavyBoot = 0 then countHeavyBoot := 1;
  if countClothHelm = 0 then countClothHelm := 1;
  if countLightHelm = 0 then countLightHelm := 1;
  if countHeavyHelm = 0 then countHeavyHelm := 1;
  if countClothArms = 0 then countClothArms := 1;
  if countLightArms = 0 then countLightArms := 1;
  if countHeavyArms = 0 then countHeavyArms := 1;
  if countClothCuri = 0 then countClothCuri := 1;
  if countLightCuri = 0 then countLightCuri := 1;
  if countHeavyCuri = 0 then countHeavyCuri := 1;

  weightClothBootMid:=weightClothBoot/countClothBoot; weightClothHelmMid:=weightClothHelm/countClothHelm; weightClothArmsMid:=weightClothArms/countClothArms; weightClothCuriMid:=weightClothCuri/countClothCuri;
  weightLightBootMid:=weightLightBoot/countLightBoot; weightLightHelmMid:=weightLightHelm/countLightHelm; weightLightArmsMid:=weightLightArms/countLightArms; weightLightCuriMid:=weightLightCuri/countLightCuri;
  weightHeavyBootMid:=weightHeavyBoot/countHeavyBoot; weightHeavyHelmMid:=weightHeavyHelm/countHeavyHelm; weightHeavyArmsMid:=weightHeavyArms/countHeavyArms; weightHeavyCuriMid:=weightHeavyCuri/countHeavyCuri;

  addmessage(Format('weightClothBootMid=%s, weightClothHelmMid=%s, weightClothArmsMid=%s, weightClothCuriMid=%s', [floattostr(weightClothBootMid), floattostr(weightClothHelmMid), floattostr(weightClothArmsMid), floattostr(weightClothCuriMid)]));
  addmessage(Format('weightLightBootMid=%s, weightLightHelmMid=%s, weightLightArmsMid=%s, weightLightCuriMid=%s', [floattostr(weightLightBootMid), floattostr(weightLightHelmMid), floattostr(weightLightArmsMid), floattostr(weightLightCuriMid)]));
  addmessage(Format('weightHeavyBootMid=%s, weightHeavyHelmMid=%s, weightHeavyArmsMid=%s, weightHeavyCuriMid=%s', [floattostr(weightHeavyBootMid), floattostr(weightHeavyHelmMid), floattostr(weightHeavyArmsMid), floattostr(weightHeavyCuriMid)]));

  addmessage(Format('weightClothBootMin=%s, weightClothHelmMin=%s, weightClothArmsMin=%s, weightClothCuriMin=%s', [floattostr(weightClothBootMin), floattostr(weightClothHelmMin), floattostr(weightClothArmsMin), floattostr(weightClothCuriMin)]));
  addmessage(Format('weightLightBootMin=%s, weightLightHelmMin=%s, weightLightArmsMin=%s, weightLightCuriMin=%s', [floattostr(weightLightBootMin), floattostr(weightLightHelmMin), floattostr(weightLightArmsMin), floattostr(weightLightCuriMin)]));
  addmessage(Format('weightHeavyBootMin=%s, weightHeavyHelmMin=%s, weightHeavyArmsMin=%s, weightHeavyCuriMin=%s', [floattostr(weightHeavyBootMin), floattostr(weightHeavyHelmMin), floattostr(weightHeavyArmsMin), floattostr(weightHeavyCuriMin)]));
  addmessage(Format('weightClothBootMax=%s, weightClothHelmMax=%s, weightClothArmsMax=%s, weightClothCuriMax=%s', [floattostr(weightClothBootMax), floattostr(weightClothHelmMax), floattostr(weightClothArmsMax), floattostr(weightClothCuriMax)]));
  addmessage(Format('weightLightBootMax=%s, weightLightHelmMax=%s, weightLightArmsMax=%s, weightLightCuriMax=%s', [floattostr(weightLightBootMax), floattostr(weightLightHelmMax), floattostr(weightLightArmsMax), floattostr(weightLightCuriMax)]));
  addmessage(Format('weightHeavyBootMax=%s, weightHeavyHelmMax=%s, weightHeavyArmsMax=%s, weightHeavyCuriMax=%s', [floattostr(weightHeavyBootMax), floattostr(weightHeavyHelmMax), floattostr(weightHeavyArmsMax), floattostr(weightHeavyCuriMax)]));
  files.free;
end;

end.
