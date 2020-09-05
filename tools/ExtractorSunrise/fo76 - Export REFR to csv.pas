{
  Extractor Sunrise (part of Pip-BoyA)
  By Logue
  Based on YASSM

  Exports All location data to csv.
  * It takes about 12 minutes to extract all the data, and the output file size is about 120M.
}

Unit userscript;

Var
  sl: TStringList;

Procedure GetMarkers;

Var 
  wrld, wrldgrup, block, subblock, cell, e: IInterface;
  i,w,x,y,z,counter: integer;
  row, Name, edid: string;

Begin
  If wbGameMode = gmFNV Then
    wrld := RecordByFormID(FileByIndex(0), $000DA726, False)
  Else If wbGameMode = gmFO76 Then
    wrld := RecordByFormID(FileByIndex(0), 2480661, False)
  Else
    wrld := RecordByFormID(FileByIndex(0), $0000003C, False);

  wrldgrup := ChildGroup(wrld);
  For i := 0 To ElementCount(wrldgrup) - 1 Do
    Begin
      block := ElementByIndex(wrldgrup,i);
      // AddMessage('Block '+BaseName(Block));
      For x := 0 To ElementCount(block) -1 Do
        Begin
          subblock := ElementByIndex(block,x);
          // AddMessage('Block '+BaseName(block) +' SubBlock '+BaseName(subblock));
          For y := 0 To ElementCount(subblock) -1 Do
            Begin
              //We only want to look through Temp items
              cell := FindChildGroup(ChildGroup(ElementByIndex(subblock,y)),9,
                      ElementByIndex(subblock,y));
              For z := 0 To ElementCount(cell) -1 Do
                Begin
                  e := ElementByIndex(cell,z);
                  If (Signature(e) <> 'REFR') Then
                    Continue;
                  // Filter by Appalachia (Non instance area)
                  If (pos('Appalachia', BaseName(e))>0) Then
                    Begin
                      Name := GetEditValue(ElementByName(e,'NAME - Base'));
                      {
                        // Insert the processing to narrow down the conditions here.
                        if (pos('MtnTop', Name)>0) Then
                          continue;
                        if (pos('Ski', Name)>0) Then
                          continue;
                        if (pos('DeadShrub', Name)>0) Then
                          continue;
                        if (pos('JunkWall', Name)>0) Then
                          continue;
                        if (pos('76Nature', Name)>0) Then
                          continue;
                        if (pos('Antler', Name)>0) Then
                          continue;
                        if (pos('BLD_', Name)>0) Then
                          continue;
                        if (pos('Bld', Name)>0) Then
                          continue;
                        if (pos('GenericPoster', Name)>0) Then
                          continue;
                        if (pos('Wall', Name)>0) Then
                          continue;
                        if (pos('RockBoulder', Name)>0) Then
                          continue;
                        if (pos('HollyShrub', Name)>0) Then
                          continue;
                        if (pos('RaiderCamp', Name)>0) Then
                          continue;
                      }

                      // Output line
                      Row := '"' + IntToHex(FixedFormID(e), 8) + '",';
                      Row := Row + Name + ',';
                      Row := Row + GetEditValue(ElementByName(
                             ElementByName(ElementByName(e,
                             'DATA - Position/Rotation'),'Position'),'X'))+
                             ',';
                      Row := Row + GetEditValue(ElementByName(
                             ElementByName(ElementByName(e,
                             'DATA - Position/Rotation'),'Position'),'Y'));
                      sl.Add(row);
                    End;
                End;
            End;
        End;
    End;
End;

// Called before processing
// You can remove it if script doesn't require initialization code
Function Initialize: integer;
Begin
  sl := TStringList.Create;
  sl.Add('id,name,x,y');
  GetMarkers;
  Result := 0;
End;

Function Finalize: integer;

Var 
  fname: string;
Begin
  fname := ProgramPath + 'RFER.csv';
  //Dummy record for trailing comma
  sl.SaveToFile(fname);
  sl.Free;
  Result := 1;
End;


End.
