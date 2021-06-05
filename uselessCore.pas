{
  Here should be a description
}
unit UselessCore;

interface

var
  patchFile: IInterface;
  files:TStringList;
  
/// copy e with its required masters
function copyWithMasters(e: IInterface): IInterface;

/// returns a record by it's hex formid
function recordByHex(id: string): IInterface;

/// return true if name is in the files
function shouldI(name: string):boolean;

/// checks if rec in one of the group(s)
function isInGroup(rec:IInterface; group:string):boolean;

/// returns record's prefix by it's formid
function getPrefixByFormID(name:string):string;

/// returns file prefix by it's name
function getPrefixByFileName(name:string):string;

/// copy e with parent, grandparent and their masters
function normCopy(r:IInterface): IInterface;  // (no)

/// a prefix-version of normCopy
function normCopyWithPrefix(r:IInterface; aPrefixRemove, aPrefix, aSuffix: string): IInterface;  // (no)

/// add kwd to e if it is not present yet
function addKeyword(e: IInterface; kwdID: string): integer;

/// write warning
procedure warn(msg:string);

/// gebug info
procedure dbg(msg:string);

/// adds essect to spel with given params
procedure addEffect(spel:IInterface; id:string; mag:float; area, dur:integer);

/// returns effect from fiven spell by given id
function findEffect(spel:IInterface; id:string):IInterface;

/// finds record by filename and FormID and returns winning copy
function copyFindCustom(file, id:string):IInterface;

/// finds record by FormID (Skyrim.esm) and returns winning copy
function copyFind(id:string):IInterface;

/// finds record by filename and record's short FormID
function findRecord(filename, shortID:string):IInterface;

/// adds condition with possibly fixing OR after it
function addCond(r:IInterface; withfix:boolean):IInterface;


implementation

uses mteFunctions;


procedure WalkCellGroup(g:IInterface);
var i:integer;
    e:IInterface;
begin
  for i:=0 to elementcount(g)-1 do begin
    e := elementbyindex(g, i);
    if not sametext(signature(e), 'REFR') then continue;
    if not IsMaster(e) then continue;
    e := WinningOverride(e);
    
    if not needopen(e) then continue;
    
    // todo
  end;
end;

procedure WalkWorldSpace(f: IInterface);
var
  i,j,k,l,m: integer;
  wrld, block, subblock, cell, group: IInterface;
  x, y, x1, y1: real;
begin
  f := GroupBySignature(f, 'WRLD');
  for i := 0 to elementcount(f)-1 do begin
    wrld := ElementByIndex(f, i);
    if sametext(signature(wrld), 'WRLD') then continue;
    for j := 0 to ElementCount(wrld)-1 do begin
      block := ElementByIndex(wrld, j);
      if sametext(signature(block), 'CELL') then continue;
      for k := 0 to ElementCount(block)-1 do begin
        subblock := ElementByIndex(block, k);
        if sametext(signature(ChildrenOf(subblock)), 'CELL') then begin
          WalkCellGroup(subblock);
          continue;
        end;
        for l := 0 to ElementCount(subblock)-1 do begin
          cell := ElementByIndex(subblock, l);
          if sametext(signature(cell), 'CELL') then continue;
          for m := 0 to elementcount(cell)-1 do begin
            group := ElementByIndex(cell, m);
            WalkCellGroup(group);
          end;
        end;
      end;
    end;
  end;
end;

procedure WalkCell(f: IInterface);
var
  i,j,k,l,m: integer;
  block, subblock, cell, group: IInterface;
  x, y, x1, y1: real;
begin
  f := GroupBySignature(f, 'CELL');
  for i := 0 to elementcount(f)-1 do begin
    block := ElementByIndex(f, i);
    for j := 0 to ElementCount(block)-1 do begin
      subblock := ElementByIndex(block, j);
      for k := 0 to ElementCount(subblock)-1 do begin
        cell := ElementByIndex(subblock, k);
        if sametext(signature(cell), 'CELL') then continue;
        for l := 0 to ElementCount(cell)-1 do begin
          group := ElementByIndex(cell, l);
          WalkCellGroup(group);
        end;
      end;
    end;
  end;
end;

function addCond(r:IInterface; withfix:boolean):IInterface;
var last:IInterface;
    s:string;
begin
  result:=ebp(r, 'Conditions');
  if not assigned(result) then begin
    result := add(r, 'Conditions', true);
  end;
  last:= elementbyindex(result, elementcount(result)-1);
  s:=geev(last, 'CTDA\Type');
  if assigned(last) then
    if withfix and sametext(s[4], '1') then begin
      s:=copy(s, 1, 3) + '0' + copy(s, 5, 4);
      dbg('fixed stupid bethesda bug at ' + name(r));
      seev(last, 'CTDA\Type', s);
    end;
  result:=ElementAssign(result, HighInteger, nil, false);
end;

function findRecord(filename, shortID:string):IInterface;
var prefix, fullFilename:string;
    f:IInterface;
begin
  f := filebyname(filename);
  fullFilename := name(f);
  prefix := '$' + copy(fullFilename, 2, 2);
  if sametext(prefix, 'FE') then prefix := prefix + copy(fullFilename, 5, 3);
  result := RecordByFormID(f, strtoint(prefix+shortID), false);
end;

function copyFindCustom(file, id:string):IInterface;
begin
  result := RecordByFormID(filebyname(file), strtoint('$' + id), false);
  result := copywithmasters(WinningOverride(result));
end;

function copyFind(filename, id:string):IInterface;
begin
  //result := copyFindCustom('Skyrim.esm', id);
  result := copywithmasters(WinningOverride(findRecord(filename, id)));
end;

procedure dbg(msg:string);
begin
  addmessage('[== dbg ==]  ' + msg);
end;

procedure warn(msg:string);
begin
  addmessage('[$#!%#  WARNING  %^#!@$]  ' + msg);
end;

function findEffect(spel:IInterface; edid:string):IInterface;
var effs:IInterface;
    i:integer;
begin
  effs := ebp(spel, 'Effects');
  if not assigned(effs) then exit;
  for i:= 0 to elementcount(effs) - 1 do
    if sametext(editorid(linksto(ebp(elementbyindex(effs, i), 'EFID'))), edid) then begin
      result := elementbyindex(effs, i);
      exit;
    end;
end;

function addEffect(spel:IInterface; id:string; mag:float; area, dur:integer):IInterface;
begin
  result:=ebp(spel, 'Effects');
  if not assigned(result) then begin
    dbg('no effs, adding: ' + name(spel));
    result := add(spel, 'Effects', true);
  end;
  result:=ElementAssign(result, HighInteger, nil, false);
  seev(result, 'EFID', id);
  seev(result, 'EFIT\Magnitude', mag);
  seev(result, 'EFIT\Area', area);
  seev(result, 'EFIT\Duration', dur);
end;

{function hasKeyword(e, kwd: IInterface): boolean;
var
  kwda, k: IInterface;
  i, j: integer;
  edid:string;
begin
  result := false;
  dbg(name(e) + ' ' + name(kwd));
  kwda := ElementBySignature(e, 'KWDA');
  if not Assigned(kwda) then exit;
  edid := editorid(kwd);
  for j := 0 to ElementCount(kwda) - 1 do begin
    if sametext(GeteditValue(ElementByIndex(kwda, j)), name(kwd)) then begin
      result := true;
      exit;
    end;
  end;
end;}

function addKeyword(e, kwd: IInterface): boolean;
var
  kwda, k: IInterface;
  i, j: integer;
begin
  result := false;

  kwda := ElementBySignature(e, 'KWDA');
  if not Assigned(kwda) then kwda := Add(e, 'KWDA', True);

  // check if kwd already here
  for j := 0 to ElementCount(kwda) - 1 do begin
    if sametext(GeteditValue(ElementByIndex(kwda, j)), name(kwd)) then exit;
  end;
  
  if (ElementCount(kwda) = 1) and (GetNativeValue(ElementByIndex(kwda, 0)) = 0) then
    SetEditValue(ElementByIndex(kwda, 0), name(kwd))
  else begin
    k := ElementAssign(kwda, HighInteger, nil, False);
    SetEditValue(k, name(kwd));
  end;
  
  // update KSIZ keywords count
  if not ElementExists(e, 'KSIZ') then
    Add(e, 'KSIZ', True);
  SetElementNativeValues(e, 'KSIZ', ElementCount(kwda));
end;

function initNewOrExistingFile(newName:string):boolean;
begin
  patchFile := filebyname(newName);
  if not assigned(patchFile) then 
    patchFile := AddNewFileName(newName);
  result := assigned(patchFile);
end;

function recordByHex(id: string): IInterface;
var
  f: IInterface;
begin
  f := fileByFormid(id);
  Result := RecordByFormID(f, StrToInt('$' + id), true);
end;

function fileByFormid(id: string): IInterface;
var i: integer;
  n: string;
  curFile:IInterface;
begin
  n := getPrefixByFormID(id);
  for i := 0 to FileCount - 1 do begin
    curFile := FileByIndex(i);
    if getPrefixByFileName(getfilename(curFile)) = n then begin
      result := curFile;
      exit;
    end;
  end;
end;

function shouldI(name: string):boolean;
var i: integer;
begin
  result := files.Find(name, i);
end;

function isInGroup(rec:IInterface; group:string):boolean;
var groups: TStringList;
    i:integer;
begin
  groups:= TStringList.create;
  groups.Delimiter := ',';
  groups.DelimitedText:=group;
  result := false;
  for i:=0 to groups.Count-1 do
    result := result or isRecordFrom(rec, groups[i]);
end;

function isRecordFrom(rec: IInterface; from: string): boolean;
begin
  result := ContainsText(fullpath(rec), 'GRUP Top "' + from + '"');
end;

function getPrefixByFormID(id:string):string;
var f:IInterface;
begin
  result := copy(id,1,2);
  if SameText(result,'FE') then result := result + copy(id,3,3);
end;

function getPrefixByFileName(filename:string):string;
var f:IInterface;
begin
  f := filebyname(filename);
  result:=copy(name(f),2,2);
  if SameText(result, 'FE') then
    result := result + copy(name(f),5,3);
end;

procedure handleMasters(e:IInterface);
var i: integer;
    mstrs:TStringList;
begin
  mstrs := TStringList.Create;
  mstrs.Duplicates := dupIgnore;
  mstrs.Sorted := True;
  AddMasterIfMissing(patchFile, getfilename(GetFile(MasterOrSelf(e))));
  ReportRequiredMasters(e, mstrs, true, true);
  for i:=0 to mstrs.Count-1 do begin
    AddMasterIfMissing(patchFile, mstrs[i]);
  end;
end;

/// copy winning parent and grandparent of r
procedure handleParents(r:IInterface);
var parent, grandParent: IInterface;
    contName:string;
begin
  parent := ChildrenOf(GetContainer(r));
  if assigned(parent) then begin
    contName := name(GetContainer(parent));
    if ContainsText(contName,'GRUP World Children of ') or 
       ContainsText(contName,'GRUP Exterior Cell Sub-Block ') then begin
      grandParent := ChildrenOf(GetContainer(parent));
      if assigned(grandParent) then copyWithMasters(WinningOverride(grandParent));
    end;
    copyWithMasters(WinningOverride(parent));
  end;
end;

function normCopy(r:IInterface): IInterface;  // (no)
begin
  handleParents(r);
  result := copyWithMasters(r);
end;

function normCopyWithPrefix(r:IInterface; aPrefixRemove, aPrefix, aSuffix: string): IInterface;  // (no)
var parent, grandParent: IInterface;
    contName:string;
begin
  handleParents(r);
  result := copyWithMastersWithPrefix(r, aPrefixRemove, aPrefix, aSuffix);
end;

function copyWithMasters(e: IInterface): IInterface;
begin
  handleMasters(e);
  result := wbCopyElementToFile(e, patchFile, false, true);
end;

/// copy e as new (new id) with prefix with its required masters
function copyWithMastersWithPrefix(e: IInterface; aPrefixRemove, aPrefix, aSuffix: string): IInterface;
var i: integer;
    mstrs:TStringList;
begin
  handleMasters(e);
  result := wbCopyElementToFileWithPrefix(e, patchFile, true, true, aPrefixRemove, aPrefix, aSuffix);
end;

end.
