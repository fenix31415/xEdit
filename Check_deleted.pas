{
  Here should be a description
  ----
  
}
unit Check_deleted;
uses mteFunctions, uselessCore;

const PATCH_FILE_NAME = '0_Errors_deleted.esp';

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
  AddMasterIfMissing(patchFile, 'HearthFires.esm');
  AddMasterIfMissing(patchFile, 'Dragonborn.esm');
end;

function process(e:IInterface):integer;
var group, cur:IInterface;
    i:integer;
begin
  if not IsWinningOverride(e) then exit;
  if not GetIsDeleted(e) then exit;
  
  copyWithMasters(e);
end;

function Finalize: Integer;
begin
  CleanMasters(patchFile);
end;

end.
