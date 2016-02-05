{
  AE - VN Tools
  � 2007-2016 WKStudio and The Contributors.
  This software is free. Please see License for details.

  Cross-Net archive formats & functions

  Written by Nik & dsp2003.
}

unit AA_Crossnet;

interface

uses AA_RFA,

     AnimED_Console,
     AnimED_Math,
     AnimED_Misc,
     AnimED_Directories,
     AnimED_Progress,
     AnimED_Translation,
     SysUtils, Classes, Windows, Forms;

 procedure IA_BIN_Crossnet(var ArcFormat : TArcFormats; index : integer);

 function OA_BIN_Crossnet : boolean;
 function SA_BIN_Crossnet(Mode : integer) : boolean;

 procedure IA_DAT_Crossnet(var ArcFormat : TArcFormats; index : integer);

 function OA_DAT_Crossnet : boolean;
// function SA_DAT_Crossnet(Mode : integer) : boolean;

 
type
  TCrossDatHdr = packed record
   Magic     : array[1..4] of char; // 'PACK'
   Filecount : longword;
   Unknown   : array[1..6] of longword; // [1] is aligned as in [3 = 5] , [4 = 5] , [8 = 9]
  end;
  
  TCrossDatDir = packed record
   Filename  : array[1..16] of char;
   Filesize  : longword;
   Offset    : longword;
   Unknown   : int64; // possibly a hash?
  end;

  TCrossnetHdr = packed record
   FileCount : longword;
   NameTableLen : longword;
  end;
  
  TCrossnetDir = packed record
   NameOffset : longword; // ������������� �������� � ������� ����� � �������� ���������� ���
   FileOffset : longword; // ���������� ��������
   FileSize : longword; // ��� �����
  end;

  THZC1Hdr = packed record
   Magic    : array[1..4] of char; // 'hzc1'
   Filesize : longword;
   HdrSize  : longword;
   Magic2   : array[1..4] of char; // 'NVSG'
   Version  : word; //$0100
   ImgFmt   : word; //$0000 = 24 | $0001 = 32 | $0002 = 32 multipage | $0003 $0004 = 8
   Width    : word;
   Height   : word;
   X        : word;
   Y        : word;
   Dummy    : array[1..16] of byte; // zeroes
  end;

implementation

uses AnimED_Archives;

procedure IA_BIN_Crossnet;
begin
 with ArcFormat do begin
  ID   := index;
  IDS  := 'Crossnet';
  Ext  := '.bin';
  Stat := $0;
  Open := OA_BIN_Crossnet;
  Save := SA_BIN_Crossnet;
  Extr := EA_RAW;
  FLen := $FF;
  SArg := 0;
  Ver  := $20101015;
 end;
end;

procedure IA_DAT_Crossnet;
begin
 with ArcFormat do begin
  ID   := index;
  IDS  := 'Crossnet PACK';
  Ext  := '.dat';
  Stat := $f;
  Open := OA_DAT_Crossnet;
//  Save := SA_DAT_Crossnet;
  Extr := EA_RAW;
  FLen := $16;
  SArg := 0;
  Ver  := $20131204;
 end;
end;

function OA_DAT_Crossnet;
var Hdr : TCrossDatHdr;
    Dir : TCrossDatDir;
    i,j : longword;
begin
 Result := False;

 with ArchiveStream do begin
  Seek(0,soBeginning);
  Read(Hdr,SizeOf(Hdr));
  with Hdr do begin
   if Magic <> 'PACK' then Exit;
   if Unknown[2] + Unknown[3] + Unknown[4] + Unknown[5] + Unknown[6] <> 0 then Exit; // those fields are usually empty
   RecordsCount := FileCount;
  end;

{*}Progress_Max(RecordsCount);

// Reading file table...
  for i := 1 to RecordsCount do begin

{*}Progress_Pos(i);

   with Dir,RFA[i] do begin
    Read(Dir,SizeOf(Dir));
    RFA_1 := Offset;
    RFA_2 := FileSize;
    RFA_C := FileSize;
    for j := 1 to length(FileName) do if FileName[j] <> #0 then RFA_3 := RFA_3 + FileName[j] else break;
   end;

  end;

  Result := True;

 end;

end;

function OA_BIN_Crossnet;
var Hdr : TCrossnetHdr;
    Dir : array of TCrossnetDir;
    NameTable : array of char;
    i : longword;
    MiniBuffer : array[1..4] of char;
    HZC1Hdr : THZC1Hdr;
begin

 Result := false;
 
 with ArchiveStream do begin
 
  Seek(0,soBeginning);
  
  Read(Hdr,sizeof(Hdr));
  
  with Hdr do begin
  
   if (FileCount = 0) or
      (FileCount > $FFFF) or
      (NameTableLen = 0) or
      (NameTableLen > (Size div 10)) then Exit; // div 10 ������ ���� ������ ������� ����� ������

   SetLength(Dir,FileCount);
   SetLength(NameTable,NameTableLen);

   Read(Dir[0],FileCount*SizeOf(TCrossnetDir));
   Read(NameTable[0],NameTableLen);

   RecordsCount := FileCount;

{*}Progress_Max(RecordsCount);

   for i := 1 to RecordsCount do try

 {*}Progress_Pos(i);

    with RFA[i] do begin

     RFA_1 := Dir[i-1].FileOffset;
     RFA_2 := Dir[i-1].FileSize;
     
     if (RFA_1 = 0) or (RFA_1 > Size) or (RFA_2 = 0) or (RFA_2 > Size) then begin
      SetLength(Dir,0);
      SetLength(NameTable,0);
      Exit;
     end;
     
     RFA_3 := String(Pchar(@NameTable[Dir[i-1].NameOffset]));
     RFA_C := RFA_2;
     
    end;
    
   except
    SetLength(Dir,0);
    SetLength(NameTable,0);
    Exit;
   end;

   SetLength(Dir,0);
   SetLength(NameTable,0);
 
  end; // with Hdr

  // file format and compression detection code
  for i := 1 to RecordsCount do begin
  
   with RFA[i] do begin

 {*}Progress_Pos(i);

    Seek(RFA_1,soBeginning);
    Read(MiniBuffer,SizeOf(MiniBuffer));

    if MiniBuffer = 'RIFF' then RFA_3 := RFA_3 + '.wav';
    if MiniBuffer = 'OggS' then RFA_3 := RFA_3 + '.ogg';
    if MiniBuffer = 'hzc1' then begin
     RFA_3 := RFA_3 + '.hzc';
     Seek(RFA_1,soBeginning);
     Read(HZC1Hdr,SizeOf(HZC1Hdr));
     RFA_2 := HZC1Hdr.Filesize;
    end;
   end;
   
  end;
  // end of

 end; // with ArchiveStream

 Result := True;

end;

function SA_BIN_Crossnet;
var Hdr : TCrossnetHdr;
    Dir : array of TCrossnetDir;
    NameTable : string;
    i : longword;
begin
 Result := False;

 RecordsCount := AddedFiles.Count;

 with Hdr do begin
  FileCount := RecordsCount;
  UpOffset := 0;
  NameTable := '';
 end;

 SetLength(Dir,RecordsCount);

 for i := 1 to RecordsCount do begin
{*}Progress_Pos(i);
  OpenFileStream(FileDataStream,RootDir+AddedFilesW.Strings[i-1],fmOpenRead,False);

  RFA[i].RFA_3 := ChangeFileExt(ExtractFileName(AddedFiles.Strings[i-1]),''); // removing extension

  Dir[i-1].NameOffset := UpOffset;
  Dir[i-1].FileSize := FileDataStream.Size;
  FreeAndNil(FileDataStream);
  UpOffset := UpOffset + Length(RFA[i].RFA_3)+ 1;
  NameTable := NameTable + RFA[i].RFA_3 + #0;
 end;

 Hdr.NameTableLen := UpOffset;

 UpOffset := UpOffset + sizeof(Hdr) + Sizeof(TCrossnetDir)*RecordsCount;

 for i := 1 to RecordsCount do begin
{*}Progress_Pos(i);
  Dir[i-1].FileOffset := UpOffset;
  UpOffset := UpOffset + Dir[i-1].FileSize;
 end;

 with ArchiveStream do begin

  Write(Hdr,Sizeof(Hdr));
  Write(Dir[0],Sizeof(TCrossnetDir)*RecordsCount);
  Write(NameTable[1],Length(NameTable));

  for i := 1 to RecordsCount do begin
{*}Progress_Pos(i);
   OpenFileStream(FileDataStream,RootDir+AddedFilesW.Strings[i-1],fmOpenRead);
   CopyFrom(FileDataStream,FileDataStream.Size);
   FreeAndNil(FileDataStream);
  end;

 end; // with ArchiveStream

 Result := True;

end;

end.