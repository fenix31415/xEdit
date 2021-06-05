{
  Here should be a description
  -----
  
}

unit FireExporter;
uses mteFunctions, uselesscore;

const OUT_FILE  = 'fire_test.esp';
      FIRE_FILE = 'abotFiresHurt.esp';
      z = 8960.0;
      x0 = -3500.0;
      y0 = -3500.0;
      delta = 400.0;
      maxY = 4;

var testcell, tempGroup:IInterface;

procedure removeOld();
begin
  
end;

procedure putAtGrid(x, y:integer; baseID:string);
var e:IInterface;
begin
  e := add(tempGroup,'REFR', true);
  seev(e, 'NAME', baseID);
  add(e, 'EDID', true);
  seev(e, 'EDID', 'f314_' + inttostr(x) + '_' + inttostr(y));
  
  seev(e, 'DATA\Position\X', floattostr(delta * x + x0));
  seev(e, 'DATA\Position\Y', floattostr(delta * y + y0));
  seev(e, 'DATA\Position\Z', floattostr(z));
end;

procedure addStuffImpl(startX, startY:integer; list:IInterface);
var i, x, y:integer;
begin
  x := startX;
  y := startY;
  list := ebp(list, 'FormIDs');
  for i := 0 to elementcount(list)-1 do begin
    putAtGrid(x, y, name(linksto(elementbyindex(list, i))));
    y := y + 1;
    if y > maxY then begin
      x := x + 1;
      y := 0;
    end;
  end;
end;

procedure addStuff();
begin
  addStuffImpl(0, 0, RecordByFormID(filebyname(FIRE_FILE), $0E0022EE, false));
end;

procedure genCodeImpl(coll:IInterface);
var e:IInterface;
    scale:float;
begin
  e := linksto(ebp(coll, 'XATR'));
  if not assigned(ebp(e, 'XSCL')) then scale := 1.0
  else scale := strtofloat(geev(e, 'XSCL'));
  
  addmessage(Format('register_data_entry(0x%x, %.6ff, { %sf, %sf, %sf }, { %sf, %sf, %sf }, { %sf, %sf, %sf });',
    [integer(formid(linksto(ebp(e, 'NAME')))), scale,
      geev(e,    'DATA\Position\X'), geev(e,    'DATA\Position\Y'), geev(e, 'DATA\Position\Z'),
      geev(coll, 'DATA\Position\X'), geev(coll, 'DATA\Position\Y'), geev(coll, 'DATA\Position\Z'),
      geev(coll, 'XPRM\Bounds\X'),   geev(coll, 'XPRM\Bounds\Y'),   geev(coll, 'XPRM\Bounds\Z')]));
end;

procedure genCode();
var i:integer;
    e:IInterface;
begin
  for i := 0 to elementcount(tempGroup)-1 do begin
    e := elementbyindex(tempGroup, i);
    if not sametext(geev(e, 'NAME'), 'CollisionMarker [STAT:00000021]') then continue;
    
    genCodeImpl(e);
  end;
end;

function Finalize(): Integer;
begin
  testcell := RecordByFormID(filebyname(OUT_FILE), $1000334A, false);
  tempGroup := FindChildGroup(ChildGroup(testcell), 9, testcell);

  //removeOld();
  //addStuff();
  gencode();
end;

end.
