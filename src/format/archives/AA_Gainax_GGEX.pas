{
  AE - VN Tools
  � 2007-2016 WKStudio & The Contributors.
  This software is free. Please see License for details.

  GAiNAX G2 engine archive format and functions

  Written by Nik.
}

unit AA_Gainax_GGEX;

interface

uses AA_RFA,

     AnimED_Console,
     AnimED_Math,
     AnimED_Misc,
     AnimED_Directories,
     AnimED_Progress,
     AnimED_Translation,
     Generic_Hashes,
     SysUtils, Classes, Windows, Forms;

 procedure IA_Gainax_GCEX(var ArcFormat : TArcFormats; index : integer);

 function OA_Gainax_GCEX : boolean;
 function SA_Gainax_GCEX_GCE3(Mode : integer) : boolean;
 
type
// ������ �� ����������� exe PM4 ��������� ������
	TGainaxGCEXHeader = packed record
	  Magic : array[1..4] of char; // 'GCEX'
	  Unk1 : longword; // �������� 0/�� 0 (0x4�86020) | 0 
	  TableOffset : longword; // �������� ������ �������� �������
	  Unk2 : longword; // ������ �� 0x4C8659 � ����� �� ���� XD | 0 
	end;
	
	TGainaxGCE3TableHeader = packed record
	  Magic : array[1..4] of char; // 'GCE3' (����� ������ GCE0 � GCE1 (0x4C86A0))
    // � ����� - � Aster GCE1
	  Unk1 : longword;// | 0 
	  {
		��� ����� ����� ����������� �������� (0x4C8052)
			and $10
			(shr 8) and 1
			and $20
	  }
	  Size : longword; // ������ �������
	  Unk2 : longword; // ��� �������� ����������� (0x4C807A) � �������� ������ | 0
	  Unk3 : longword; // | 0
	  Hash : longword; // ����������� �� ������� Gainax_Hash
	  FilesCount : longword; // ���������� ������
	  Unk4 : longword; // | 0
	end;
	
	TGainaxGCE3Table = packed record
	  Data1 : Int64; // ?  0x4C8E27 (����� ����� ����� �� �������, ��� ��� ����� �������� �����)
	  dwLowDateTime : longword; //   0x4c8f8a � ����� 0x498250
    dwHighDateTime : longword;
	  Size1 : Int64;// ������ �����, ��� �������������
	  Size2 : Int64;// � ����������� ������� (����� �� ������ � ����� ������� ��. 0x4C7740)
	end;
{
   ����� : ����� - word, � ��� ����� ����
}

implementation

uses AnimED_Archives;

procedure IA_Gainax_GCEX;
begin
 with ArcFormat do begin
  ID   := index;
  IDS  := 'Gainax GCEX (GCE3)';
  Ext  := '';
  Stat := $0;
  Open := OA_Gainax_GCEX;
  Save := SA_Gainax_GCEX_GCE3;
  Extr := EA_RAW;
  FLen := $FFFF;
  SArg := 0;
  Ver  := $20090819;
 end;
end;

function OA_Gainax_GCEX;
var Header : TGainaxGCEXHeader;
    THeader : TGainaxGCE3TableHeader;
    Table : array of TGainaxGCE3Table;
    NameLen : word;
    i, UO : longword;
begin
 Result := false;
 ArchiveStream.Position := 0;
 ArchiveStream.Read(Header,sizeof(Header));
 if Header.Magic <> 'GCEX' then Exit;

 ArchiveStream.Position := Header.TableOffset;
 ArchiveStream.Read(THeader,sizeof(THeader));

 if Header.Magic <> 'GCE3' then Exit;

 RecordsCount := THeader.FilesCount;
 SetLength(Table,RecordsCount);
 ArchiveStream.Read(Table[0],RecordsCount*sizeof(Table[0]));

 UO := sizeof(Header);

{*}Progress_Max(RecordsCount);
 for i := 1 to RecordsCount do
 begin
{*}Progress_Pos(i);
   if Table[i-1].Size1 = Table[i-1].Size2 then
   begin
     RFA[i].RFA_C := longword(Table[i-1].Size1);
     RFA[i].RFA_2 := longword(Table[i-1].Size1);
   end
   else
   begin
     RFA[i].RFA_C := longword(Table[i-1].Size2);
     RFA[i].RFA_2 := longword(Table[i-1].Size1);
     RFA[i].RFA_Z := true;
     RFA[i].RFA_X := $7F; // ����������� �������
   end;
   RFA[i].RFA_1 := UO;
   UO := UO + RFA[i].RFA_C;
   ArchiveStream.Read(NameLen,2);
   SetLength(RFA[i].RFA_3,NameLen);
   ArchiveStream.Read(RFA[i].RFA_3[1],NameLen);
 end;

 SetLength(Table,0);
 Result := True;

end;

function SA_Gainax_GCEX_GCE3;
var Header : TGainaxGCEXHeader;
    THeader : TGainaxGCE3TableHeader;
    Table : TGainaxGCE3Table;
    stream : TStream;
    NameLen : word;
    Hash, i : longword;
//    hl : longword;
//    T1, T2, T3 : FileTime;
    Times : TFileTimes;
begin
 RecordsCount := AddedFiles.Count;
 Header.Magic := 'GCEX';
 Header.Unk1 := 0;
 Header.Unk2 := 0;
 UpOffset := sizeof(Header);

 FillChar(THeader,sizeof(THeader),0);
 THeader.Magic := 'GCE3';
 THeader.FilesCount := RecordsCount;

 FillChar(Table,sizeof(Table),0);
 stream := TMemoryStream.Create;
 stream.Position := sizeof(THeader);

 for i := 1 to RecordsCount do begin
{*}Progress_Pos(i);
//  FileDataStream := TFileStream.Create(GetFolder+AddedFiles.Strings[i-1],fmOpenRead);
//  hl := CreateFile(PAnsiChar(GetFolder+AddedFiles.Strings[i-1]),GENERIC_READ,0,nil,OPEN_EXISTING,FILE_ATTRIBUTE_READONLY,0);
//  GetFileTime(hl, @T1, @T2, @T3);
//  Table.dwLowDateTime := T1.dwLowDateTime;
//  Table.dwHighDateTime := T1.dwHighDateTime;
//  Table.Size1 := GetFileSize(hl,nil);
//  Table.Size2 := Table.Size1;
//  CloseHandle(hl);

  Times := AE_GetFileTime(RootDir+AddedFilesW.Strings[i-1]);
  
  OpenFileStream(FileDataStream,RootDir+AddedFilesW.Strings[i-1],fmOpenRead);

  Table.dwLowDateTime  := Times[1].dwLowDateTime;
  Table.dwHighDateTime := Times[1].dwHighDateTime;
  Table.Size1          := FileDataStream.Size;

  RFA[i].RFA_3 := AddedFiles.Strings[i-1];
  FreeAndNil(FileDataStream);
  stream.Write(Table,sizeof(Table));
  UpOffset := UpOffset + Table.Size1;
 end;

 for i := 1 to RecordsCount do begin
{*}Progress_Pos(i);
  NameLen := Length(RFA[i].RFA_3);
  stream.Write(NameLen,2);
  stream.Write(RFA[i].RFA_3[1],NameLen);
 end;

 THeader.Size := stream.Size;
 stream.Position := 0;
 stream.Write(THeader,sizeof(THeader));
 stream.Position := 0;
 Hash := Gainax_Hash(stream,0);
 stream.Position := $14;
 stream.Write(Hash,4);
 stream.Position := 0;
 Header.TableOffset := UpOffset;

 ArchiveStream.Write(Header,sizeof(Header));
 for i := 1 to RecordsCount do begin
{*}Progress_Pos(i);

  OpenFileStream(FileDataStream,RootDir+AddedFilesW.Strings[i-1],fmOpenRead);

  ArchiveStream.CopyFrom(FileDataStream,FileDataStream.Size);
  FreeAndNil(FileDataStream);
 end;
 ArchiveStream.CopyFrom(stream,stream.Size);
 FreeAndNil(stream);

 Result := True;
end;

end.