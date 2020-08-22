{
  Extractor Sunrise (part of Pip-BoyA)
  By Logue
  Based on YASSM
  
  Exports Hard Point data to JSON
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
      If (pos('HardPointJunkPile01',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Junk Pile",';
          Row := Row +  '"type":"JunkPileMarker","annotation":1,';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointJunkPile02',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Junk Pile",';
          Row := Row +  '"type":"JunkPileMarker","annotation":2,';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardpointTitanium',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Black Titan",'
          ;
          Row := Row +  '"type":"BlackTitaniumMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardpointCopper',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Copper Deposit",';
          Row := Row +  '"type":"CopperMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointWoodPile01',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Wood Deposit","annotation":1,';
          Row := Row +  '"type":"CopperMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointWoodPile02',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Wood Deposit","annotation":2,';
          Row := Row +  '"type":"CopperMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointConcrete01',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Gravel Pit",';
          Row := Row +  '"type":"ConcreteMarker","annotation":1,';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointConcrete02',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Gravel Pit",';
          Row := Row +  '"type":"ConcreteMarker","annotation":2,';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardpointAluminum',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Aluminum Deposit",';
          Row := Row +  '"type":"AluminumMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointFertilizerPile01',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Phosphate Deposit,"annotation":1,';
          Row := Row +  '"type":"PhosphateMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointFertilizerPile02',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Phosphate Deposit","annotation":2,';
          Row := Row +  '"type":"PhosphateMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointCrystal',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Crystal Outcropping",';
          Row := Row +  '"type":"CrystalMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardpointGold',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Gold Deposit",';
          Row := Row +  '"type":"GoldMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardpointSilver',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Silver Deposit",';
          Row := Row +  '"type":"SilverMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardpointCoal',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Coal Deposit",';
          Row := Row +  '"type":"CoalMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardpointLead',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Lead Deposit",';
          Row := Row +  '"type":"LeadMarker",';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointStoneSkirt01',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Stone Skirt",'
          ;
          Row := Row +  '"type":"StoneSkirtMarker","annotation":1,';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointStoneSkirt02',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Stone Skirt",'
          ;
          Row := Row +  '"type":"StoneSkirtMarker","annotation":2,';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointAcid01',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Acid",';
          Row := Row +  '"type":"AcidMarker","annotation":1,';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointAcid02',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Acid",';
          Row := Row +  '"type":"AcidMarker","annotation":2,';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointOil01',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Oil Seep",';
          Row := Row +  '"type":"OilMarker","annotation":1,';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardPointOil02',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+'","name":"Oil Seep",';
          Row := Row +  '"type":"OilMarker","annotation":2,';
          Row := Row +  '"x":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'X'))+
                 ',';
          Row := Row +  '"y":'+GetEditValue(ElementByName(ElementByName(
                 ElementByName(e,'DATA - Position/Rotation'),'Position'),'Y'))+
                 '},';
          sl.Add(row);
        End;
      If (pos('HardpointUranium',edid)>0) Then
        Begin
          Row := '{"id":"'+IntToHex(FixedFormID(e), 8)+
                 '","name":"Uranium Deposit",';
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
    fname := ProgramPath + 'HardPoint.json';
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
