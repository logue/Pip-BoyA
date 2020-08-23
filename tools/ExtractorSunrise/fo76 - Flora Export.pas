{
  Extractor Sunrise (part of Pip-BoyA)
  By Logue
  Based on YASSM

  Exports Flora data to JSON
}

Unit userscript;

Var
  sl: TStringList;

Procedure GetEncounters;

Var
  wrlds, wrld, wrldgrup, block, subblock, cell, e: IInterface;
  i,x,counter,blockidx,subblockidx,cellidx: integer;
  row: string;

Begin

//Let's try to filter to the specific worldspace so we don't have to search through more stuff...
  If wbGameMode = gmFNV Then
    wrld := RecordByFormID(FileByIndex(0), $000DA726, False)
  Else If wbGameMode = gmFO76 Then
         wrld := RecordByFormID(FileByIndex(0), $00050B2C, False)
  Else
    wrld := RecordByFormID(FileByIndex(0), $0000003C, False);

  wrldgrup := ChildGroup(wrld);
  For i := 0 To ElementCount(wrldgrup) - 1 Do
    Begin
      cell := ElementByIndex(wrldgrup,i);
      //Only do Persistent items
      If GroupType(cell) = 8 Then
        Begin
          AddMessage('Total items in world:'+ IntToStr(ElementCount(cell)));
          counter := 0;
          For x := 0 To ElementCount(cell) - 1 Do
            Begin
              e := ElementByIndex(cell,x);
              If Signature(e) = 'ACHR' Then
                Begin
                  AddMessage(IntToStr(FixedFormID(e))+' '+EditorID(e));
                  counter := counter + 1;
                End;
            End;
          AddMessage('Exported records:'+ IntToStr(counter));
        End;
    End;
End;


// Called before processing
// You can remove it if script doesn't require initialization code
Function Initialize: integer;
Begin
  //Let's override the workshop locations w/the workshop icon
  sl := TStringList.Create;
  sl.Add('[');
  sl.Sorted := True;
  Result := 0;
End;

Function Process(e: IInterface): integer;

Var
  edid,row: string;
Begin
  If Signature(e) = 'REFR' Then
    Begin

      edid := BaseName(e);
      If (pos('LPI_FloraAshRose01',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Ash Rose","annotation": 1,';
          Row := Row +  '"type":"AshRoseMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraAshRose02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Ash Rose","annotation": 2,';
          Row := Row +  '"type":"AshRoseMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_Aster01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Aster",';
          Row := Row +  '"type":"AsterMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraBlackberry01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Blackberry","annotation":1,';
          Row := Row +  '"type":"BlackberryMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraBlackberry02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Blackberry","annotation":2,';
          Row := Row +  '"type":"BlackberryMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraBleachDogwoodBark01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Bleach Dogwood Bark","annotation":1,';
          Row := Row +  '"type":"BleachDogwoodBarkMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraBleachDogwoodBark02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Bleach Dogwood Bark","annotation":2,';
          Row := Row +  '"type":"BleachDogwoodBarkMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraBleachDogwoodBark03',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Bleach Dogwood Bark","annotation":3,';
          Row := Row +  '"type":"BleachDogwoodBarkMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraBlight01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Blight",';
          Row := Row +  '"type":"BlightMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraBloodLeaf01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Blood Leaf","annotation":1,';
          Row := Row +  '"type":"BloodLeafMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraBloodLeaf02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Blood Leaf","annotation":2,';
          Row := Row +  '"type":"BloodLeafMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraCranberry01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Cranberry","annotation":1,'
          ;
          Row := Row +  '"type":"CranberryMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraCranberry02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Cranberry","annotation":2,'
          ;
          Row := Row +  '"type":"CranberryMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraCranberry03',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Cranberry",'
          ;
          Row := Row +  '"type":"CranberryMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraCranberry01Diseased',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Diseased Cranberry","annotation":1,';
          Row := Row +  '"type":"CranberryDiseasedMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraCranberry02Diseased',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Diseased Cranberry","annotation":2,';
          Row := Row +  '"type":"CranberryDiseasedMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraCranberry03Diseased',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Diseased Cranberry","annotation":3,';
          Row := Row +  '"type":"CranberryDiseasedMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFern01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Fern",';
          Row := Row +  '"type":"FernMarker","annotation":1,';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFern01_Charred01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fern (Charred)","annotation":"1-1",';
          Row := Row +  '"type":"FernCharredMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFern01_Charred02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fern (Charred)","annotation":"1-2",';
          Row := Row +  '"type":"FernCharredMarker"';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFern01_Charred03',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fern (Charred)","annotation":"1-3",';
          Row := Row +  '"type":"FernCharredMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFern01_Charred04',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fern (Charred)","annotation":"1-4",';
          Row := Row +  '"type":"FernCharredMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFern02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Fern",';
          Row := Row +  '"type":"FernMarker","annotation":2,';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFern02_Charred01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fern (Charred)","annotation":"2-1",';
          Row := Row +  '"type":"FernCharredMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFern02_Charred02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fern (Charred)","annotation":"2-2",';
          Row := Row +  '"type":"FernCharredMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFern02_Charred03',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fern (Charred)","annotation":"2-3",';
          Row := Row +  '"type":"FernCharredMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFern02_Charred04',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fern (Charred)","annotation":"2-4",';
          Row := Row +  '"type":"FernCharredMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFeverBlossom01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fever Blossom","annotation":1,';
          Row := Row +  '"type":"FeverMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFeverBlossom02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fever Blossom","annotation":2,';
          Row := Row +  '"type":"FeverMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFirecap01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Firecap",';
          Row := Row +  '"type":"FirecapMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFirecracker01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Firecracker","annotation":1,';
          Row := Row +  '"type":"FirecrackerMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFirecracker02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Firecracker","annotation":2,';
          Row := Row +  '"type":"FirecrackerMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFungusBrain01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fungus Brain","annotation":1,';
          Row := Row +  '"type":"FungusBrainMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFungusBrain02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fungus Brain","annotation":2,';
          Row := Row +  '"type":"FungusBrainMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFungusBrain03',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fungus Brain","annotation":3,';
          Row := Row +  '"type":"FungusBrainMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFungusGlowing01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fungus Glowing","annotation":1,';
          Row := Row +  '"type":"FungusGlowingMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFungusGlowing02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fungus Glowing","annotation":2,';
          Row := Row +  '"type":"FungusGlowingMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFungusGlowing03',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fungus Glowing","annotation":3,';
          Row := Row +  '"type":"FungusGlowingMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFungusGlowing04',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fungus Glowing","annotation":4,';
          Row := Row +  '"type":"FungusGlowingMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraFungusGlowing05',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Fungus Glowing","annotation":5,';
          Row := Row +  '"type":"FungusGlowingMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraGinseng01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Ginseng",';
          Row := Row +  '"type":"GinsengMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraGSWildMelonVine01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"GS Wild Melon Vine",';
          Row := Row +  '"type":"MelonVineMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraGutShroom01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Gut Shroom",';
          Row := Row +  '"type":"GutShroomMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraKaleidopore01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Kaleidopore",'
          ;
          Row := Row +  '"type":"KaleidoporeMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraMothmanEggs01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Mothman Eggs","annotation":1,';
          Row := Row +  '"type":"MothmanEggsMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraMothmanEggs02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Mothman Eggs","annotation":2,';
          Row := Row +  '"type":"MothmanEggsMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraMothmanEggs03',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Mothman Eggs","annotation":3,';
          Row := Row +  '"type":"MothmanEggsMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraPitcherPlant',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Pitcher Plant",';
          Row := Row +  '"type":"PitcherPlantMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraPumpkin01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Pumpkin",';
          Row := Row +  '"type":"PumpkinMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraPumpkinVine01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Pumpkin Vein",';
          Row := Row +  '"type":"PumpkinVeinMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraSap01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Sap","annotation":1,';
          Row := Row +  '"type":"SapMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraSap02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Sap","annotation":2,';
          Row := Row +  '"type":"SapMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraSiltBean01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Silt Bean","annotation":1,'
          ;
          Row := Row +  '"type":"SiltBeanMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraSiltBean02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Silt Bean","annotation":2,'
          ;
          Row := Row +  '"type":"SiltBeanMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraSnapTail01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Snap Tail","annotation":1,'
          ;
          Row := Row +  '"type":"SnapTailMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraSnapTail02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Snap Tail","annotation":2,'
          ;
          Row := Row +  '"type":"SnapTailMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraSootFlower01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Soot Flower","annotation":1,';
          Row := Row +  '"type":"SootFlowerMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraSootFlower02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Soot Flower","annotation":2,';
          Row := Row +  '"type":"SootFlowerMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraSwampPod01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Swamp Pod",';
          Row := Row +  '"type":"SwampPodMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraTatoPlant01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Tato Plant","annotation":1,';
          Row := Row +  '"type":"TatoPlantMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraTatoPlant02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Tato Plant","annotation":2,';
          Row := Row +  '"type":"TatoPlantMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraToxicSootFlower01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Toxic Soot Flower","annotation":1,';
          Row := Row +  '"type":"ToxicSootFlowerPlantMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraToxicSootFlower02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Toxic Soot Flower","annotation":2,';
          Row := Row +  '"type":"ToxicSootFlowerPlantMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraWildCarrotFlower',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Wild Carrot Flower",';
          Row := Row +  '"type":"WildCarrotFlowerMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraWildCornStalk01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Wild Corn Stalk",';
          Row := Row +  '"type":"WildCornStalkMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraWildGourdVine01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Wild Gourd Vine",';
          Row := Row +  '"type":"WildGourdVineMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraWildMelonVine01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Wild Melon Vine",';
          Row := Row +  '"type":"WildMelonVineMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraWildMutFruit',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Wild Mut Fruit",';
          Row := Row +  '"type":"WildMutFruitMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraWildRazorgrain01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Wild Razorgrain",';
          Row := Row +  '"type":"WildRazorgrainMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraWildTarberryFloat01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Wild Tarberry Float","annotation":1,';
          Row := Row +  '"type":"WildTarberryMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraWildTarberryFloat02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Wild Tarberry Float","annotation":2,';
          Row := Row +  '"type":"WildTarberryMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraWildTatoPlant01',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Wild Tato Plant1",';
          Row := Row +  '"type":"WildTatoPlantMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_FloraWildTatoPlant02',edid)>0) Then
        Begin
          If (pos('\[00] SeventySix.esm\[70] Cell\',PathName(e))>0) Then exit;
          //Skip Internal Cells
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Wild Tato Plant2",';
          Row := Row +  '"type":"WildTatoPlantMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
    End
  Else exit;
  Result := 0;
End;

Function Finalize: integer;

Var
  fname, Last: string;
  rowcount: integer;
Begin
  Try
    fname := ProgramPath + 'Flora.json';
    //Lets have proper JSON and remove the last record's comma
    If (sl.Count > 1) Then
      Begin
        //Let's only do if there are rows...
        rowcount := sl.count-1;
        //0 Index, so let's remove one
        Last := sl[rowcount];
        //Get the Last row
        sl.Delete(rowcount);
        //Remove last line from the list
        Delete(Last, Length(Last), Length(Last) -1);
        //Trim off last character the trailing ,
        sl.Add(Last);
        //Add the last line back
      End;
    sl.Sorted := False;
    sl.Add(']');
    sl.SaveToFile(fname);
  Finally
    sl.Free;
    //Make sure we free memory if this pukes..
End;
Result := 1;
End;

End.
