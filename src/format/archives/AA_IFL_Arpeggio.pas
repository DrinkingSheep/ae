{
  AE - VN Tools
© 2007-2013 WinKiller Studio and The Contributors
  This software is free. Please see License for details.

  Arpeggio (Nikutai Ten'i) archive format & functions
  
  Written by dsp2003.
}

unit AA_IFL_Arpeggio;

interface

uses AA_RFA,
     AnimED_Console,
     AnimED_Math,
     AnimED_Misc,
     AnimED_Translation,
     AnimED_Progress,
     AnimED_Directories,
     Classes, Windows, Forms, Sysutils, StringsW,
     FileStreamJ, JUtils, JReconvertor;

 { Supported archives implementation }
 procedure IA_IFL_Arpeggio(var ArcFormat : TArcFormats; index : integer);

  function OA_IFL_Arpeggio : boolean;
  function SA_IFL_Arpeggio(Mode : integer) : boolean;

type
 TIFLSHdr = packed record
  Magic      : array[1..4] of char; // 'IFLS'
  HeaderSize : longword;             // size of Hdr+Dir[1..n]
  FileCount  : longword;
 end;
 
 TIFLSDir = packed record
  FileName   : array[1..16] of char; // SJIS filename
  Offset     : longword;
  FileSize   : longword;
 end;

implementation

uses AnimED_Archives;

procedure IA_IFL_Arpeggio;
begin
 with ArcFormat do begin
  ID   := index;
  IDS  := 'Arpeggio';
  Ext  := '.ifl';
  Stat := $0;
  Open := OA_IFL_Arpeggio;
  Save := SA_IFL_Arpeggio;
  Extr := EA_RAW;
  FLen := 16;
  SArg := 0;
  Ver  := $20101210;
 end;
end;

function OA_IFL_Arpeggio;
var i,j : integer;
    Hdr : TIFLSHdr;
    Dir : TIFLSDir;
begin
 Result := False;

 with ArchiveStream do begin
  Seek(0,soBeginning);
  Read(Hdr,SizeOf(Hdr));
  with Hdr do begin
   if Magic <> 'IFLS' then Exit;
   RecordsCount := FileCount;
  end;

// Reading file table...
  for i := 1 to RecordsCount do begin    
   with Dir do begin
    Read(Dir,SizeOf(Dir));
    RFA[i].RFA_1 := Offset;
    RFA[i].RFA_2 := FileSize;
    RFA[i].RFA_C := FileSize;
    for j := 1 to length(FileName) do if FileName[j] <> #0 then RFA[i].RFA_3 := RFA[i].RFA_3 + FileName[j] else break;
   end;
  end;

  Result := True;
 end;

end;

function SA_IFL_Arpeggio;
var i,j : integer;
    Hdr : TIFLSHdr;
    Dir : TIFLSDir;
begin
 Result := False;

 with ArchiveStream do begin

  RecordsCount := AddedFilesW.Count;

  with Hdr do begin
   Magic      := 'IFLS';
   FileCount  := RecordsCount;
   HeaderSize := SizeOf(Hdr)+SizeOf(Dir)*RecordsCount;
   UpOffset   := HeaderSize;
  end;

  Write(Hdr,SizeOf(Hdr));

{*}Progress_Max(RecordsCount);

  for i := 1 to RecordsCount do begin

{*}Progress_Pos(i);

   OpenFileStream(FileDataStream,RootDir+AddedFilesW.Strings[i-1],fmOpenRead,False);

   RFA[i].RFA_3 := ExtractFileName(AddedFiles.Strings[i-1]);
   
   RFA[i].RFA_1 := UpOffset;
   RFA[i].RFA_2 := FileDataStream.Size;
   
   FreeAndNil(FileDataStream);

   UpOffset := UpOffset + RFA[i].RFA_2;
  
   with Dir do begin
    Offset   := RFA[i].RFA_1;
    FileSize := RFA[i].RFA_2;
    FillChar(FileName,SizeOf(FileName),0);
    for j := 1 to Length(FileName) do if j <= length(RFA[i].RFA_3) then FileName[j] := RFA[i].RFA_3[j] else break;
   end;

   // ����� ����� �������
   ArchiveStream.Write(Dir,SizeOf(Dir));
   
  end;

  for i := 1 to RecordsCount do begin
{*}Progress_Pos(i);
   // ����� ���� � �����
   OpenFileStream(FileDataStream,RootDir+AddedFilesW.Strings[i-1],fmOpenRead);
   CopyFrom(FileDataStream,FileDataStream.Size);
   // ������������ ����� �����
   FreeAndNil(FileDataStream);
  end;
  
 end; // with ArchiveStream

 Result := True;

end;

end.