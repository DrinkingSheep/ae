{
  AE - VN Tools
  � 2007-2013 WinKiller Studio and The Contributors.
  This software is free. Please see License for details.

  Generic: Direct Conversion internal structures and functions.

  Written by dsp2003.
}

unit Generic_DC;

interface

uses Classes;

type
 TDCFunction = function(iStream, oStream : TStream) : boolean;

 TDCFormats = packed record
  ID     : integer;
  IDSIn  : string;     // �������� ������� �������� �����
  IDSOut : string;     // �������� ������� ��������� �����
  ExtIn  : string;     // ���������� �������� �����
  ExtOut : string;     // ���������� ��������� �����
  Save   : TDCFunction; // ��������� �� ������� �������������� ������
  Ver    : integer;     // ������ ���������� � ���� ����� $������������. ��������, $20091231
 end;

 TIDCFunction = procedure(var DCF : TDCFormats; i : integer);

implementation

end.