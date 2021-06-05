{
  Here should be a description
}
unit CheckIt;
uses mteFunctions, uselessCore;

const PATCH_FILE_NAME = '0_Erros.esp';

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
end;

function process(e:IInterface):integer;
begin
  findCraftErrors(e);
end;

procedure findCraftErrors(e:IInterface);
var group, cur:IInterface;
    i:integer;
begin
  group := GroupBySignature(e, 'COBJ');
  if not assigned(group) then exit;
  
  for i:=0 to ElementCount(group)-1 do begin
    cur:=winningoverride(ElementByIndex(group, i));
    if not (assigned(ElementBySignature(cur, 'CNAM')) and assigned(ElementBySignature(cur, 'CNAM'))) then begin
      copyWithMasters(cur);
    end;
  end;
end;

function Finalize: Integer;
begin
  CleanMasters(patchFile);
end;

end.
