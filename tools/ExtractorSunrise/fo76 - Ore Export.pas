{
  Extractor Sunrise (part of Pip-BoyA)
  By Logue
  Based on YASSM

  Exports Ore location data to JSON
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
  id: integer;
Begin
  If Signature(e) = 'REFR' Then
    Begin

      edid := BaseName(e);
      If (pos('LPI_VeinAluminum',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Aluminum",';
          Row := Row +  '"type":"AluminumMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_VeinCoal',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Coal",';
          Row := Row +  '"type":"CoalMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_VeinCopper',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Copper",';
          Row := Row +  '"type":"CooperMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_VeinCrystal',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Crystal",';
          Row := Row +  '"type":"CrystalMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_VeinGold',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Gold",';
          Row := Row +  '"type":"GoldMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_VeinIron',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Iron",';
          Row := Row +  '"type":"IronMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_VeinLead',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Lead",';
          Row := Row +  '"type":"LeadMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_VeinSilver',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Silver",'
          ;
          Row := Row +  '"type":"SilverMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_VeinTitanium',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Titanium",';
          Row := Row +  '"type":"TitaniumMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_VeinTitaniumMTR',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"TitaniumMTR","label":"MTR",';
          Row := Row +  '"type":"TitaniumMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_VeinUltracite_FISSURESONLY',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Ultracite","label":"FISSURESONLY",';
          Row := Row +  '"type":"UltraciteMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_VeinUltracite_LowYield_FISSURESONLY',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Ultracite","label":"LowYield_FISSURESONLY",';
          Row := Row +  '"type":"UltraciteMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_VeinUltracite_LowYield_SMALLFISSURESONLY',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Ultracite","label":"LowYield_SMALLFISSURESONLY",'
          ;
          Row := Row +  '"type":"UltraciteMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('LPI_VeinUranium',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Uranium",';
          Row := Row +  '"type":"UraniumMarker",';
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
  //STAT TreasureMarkerxx or ACTI TreasureMapActivatorxx
End;

Function Finalize: integer;

Var
  fname, Last: string;
  rowcount: integer;
Begin
  Try
    fname := ProgramPath + 'Ore.json';
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
