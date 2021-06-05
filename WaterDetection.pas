{
  Here should be a description
  -----
  
}

unit WaterDetection;
uses mteFunctions, uselesscore;

const PATCH_FILE_NAME = 'Dirt and Blood - Water detection.esp';

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
  
  ScriptProcessElements := [etFile];
end;

function process(e:IInterface):integer;
var item, script, aliases:IInterface;
    i, j, k:integer;
begin
  e := GroupBySignature(e, 'WATR');
  if not assigned(e) then exit;
  for i:=0 to ElementCount(e)-1 do begin
    item := WinningOverride(ElementByIndex(e, i));
    
    if (genv(item, 'FNAM') and $1 = 0) then
      senv(copywithmasters(item), 'FNAM', genv(item, 'FNAM') or $1);
    
  end;
end;

function Finalize: Integer;
begin
  CleanMasters(patchFile);
end;

end.
