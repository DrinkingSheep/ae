{
  AE - VN Tools
  � 2007-2016 WKStudio and The Contributors.
  This software is free. Please see License for details.

  Translation library. Version 3.1

  Written by dsp2003.
}

unit AnimED_Translation;

interface

uses AnimED_Math,
     AnimED_Directories,
     AnimED_Translation_Strings,
     AnimED_Version, Menus,
     Forms, SysUtils, IniFiles, StdCtrls, Buttons, ComCtrls, ExtCtrls,
     Classes,
     JReconvertor,
     JvExControls, JvComponent, JvArrowButton, UnicodeComponents;

procedure LoadTranslation(LangFile : widestring);

procedure LoadTranslation_Forms(Form : TForm);

procedure FindLangFiles;
function LS(TextPart:widestring):widestring;
procedure FillCredits;
function RandomJoke : widestring;

function AELangAutodetect : cardinal;

procedure JokeAdd(NewJoke : string);
procedure ContribAdd(NewContrib : string);
procedure TransAdd(NewTrans : string);
procedure CompoAdd(NewCompo : string);

var AMS : array of string; //Messages array
    TransFile : TIniFile;

    Contrib   : array of string; //Contributors array
    Compo     : array of string; //Components array
    Trans     : array of string; //Translators array
    Joke      : array of string; //Jokes array
    FileTypes : array of string; //File types array

    LanguageList : array[1..32,1..3] of string;

    LanguageTotal, LanguageLast : integer;

const LangFileHdr = 'Lang';

implementation

{ All translateable units goes here }

uses AnimED_Main,
     AnimED_Console,
     AnimED_Dialogs,
     AnimED_GrapS, Windows;

function AELangAutodetect : cardinal;
{ Via http://msdn.microsoft.com/en-us/goglobal/bb964664.aspx }
var EnglishDefault, LangDetected, LangFound, i : integer;
begin
 LangDetected := GetSystemDefaultLCID; // reading current system locale id

 EnglishDefault := -1;
 LangFound := -1;

 // detecting position of English (Default) language file (if exists)
 for i := 1 to LanguageTotal do begin
  if LanguageList[i,3] = '1033' then begin
   EnglishDefault := i;
   break;
  end;
 end;

 // detecting if any language matches the current user's locale
 for i := 1 to LanguageTotal do begin
  if inttostr(LangDetected) = LanguageList[i,3] then begin
   LangFound := i;
   break;
  end;
 end;

 // if haven't found any matching, setting to English (Default)
 if LangFound <> -1 then begin
  Result := LangFound;
 end else begin
  // if English (Default) was deleted
  if EnglishDefault <> -1 then begin
   // returning zero
   Result := EnglishDefault;
  end else begin
   Result := 0;
  end;
 end;
 // MessageBox(0,pchar(inttostr(LangDetected)),pchar('LCID Test'),mb_ok); // debug
end;

procedure FindLangFiles;
var i : integer; version_text : string;
begin
 LanguageTotal := 0;
 PickDirContents(WhereAreWe,'*.lang',smFilesOnly);
 if AddedFiles.Count > 0 then begin
  MainForm.CB_Language.Clear;
  for i := 1 to AddedFiles.Count do begin
   TransFile := TIniFile.Create(WhereAreWe+AddedFiles.Strings[i-1]);
   version_text := LS('AppVersion');
   if hextoint(version_text) >= current_version then begin
    inc(LanguageTotal);
    LanguageList[i,1] := AddedFiles.Strings[i-1];
    LanguageList[i,2] := LS('Name');
    LanguageList[i,3] := LS('LCID');
    MainForm.CB_Language.Items.Add(LanguageList[i,2]);
   end else LogE(AddedFiles.Strings[i-1]+': unsupported / outdated language file ['+version_text+']');
  end;
  MainForm.CB_Language.ItemIndex := 0;
  if LanguageTotal = 0 then begin
   MainForm.CB_Language.Enabled := False;
   LogW('No valid language files has been detected. Pretty shitty, you know?');
  end;
 end else MainForm.CB_Language.Enabled := False;

// CB_Language.ItemIndex

end;

function LS(TextPart:widestring):widestring;
begin
 Result := TransFile.ReadString(LangFileHdr,TextPart,'');
end;

procedure LoadTranslation_Forms(Form : TForm);
var i, NameTag{, FontCharSet, FontSize} : integer; {FontFace, }NameStr, HintStr : string;
begin
 with Form do begin
///////// FONT SETTINGS
// FontFace    := TransFile.ReadString('Lang','FontFace','Lucida Console');
// FontCharSet := TransFile.ReadInteger('Lang','Charset',1);
// FontSize    := TransFile.ReadInteger('Lang','FontSize',7);
{  MainForm.Font.Name    := FontFace;
   MainForm.Font.Charset := FontCharSet;
   MainForm.Font.Size    := FontSize;}

 { Switching the whole components codepage }

{   for i := 0 to pred(ComponentCount) do try
    if Components[i] is TTabSheet    then begin
     if Components[i].Tag > -2 then (Components[i] as TTabSheet).Font.Charset    := FontCharSet;
     if Components[i].Tag > -2 then (Components[i] as TTabSheet).Font.Size       := FontSize;
     if Components[i].Tag > -2 then (Components[i] as TTabSheet).Font.Name       := FontFace;
    end;
    if Components[i] is TGroupBox    then begin
     if Components[i].Tag > -2 then (Components[i] as TGroupBox).Font.Charset    := FontCharSet;
     if Components[i].Tag > -2 then (Components[i] as TGroupBox).Font.Size       := FontSize;
     if Components[i].Tag > -2 then (Components[i] as TGroupBox).Font.Name       := FontFace;
    end;
    if Components[i] is TSpeedButton then begin
     if Components[i].Tag > -2 then (Components[i] as TSpeedButton).Font.Charset := FontCharSet;
     if Components[i].Tag > -2 then (Components[i] as TSpeedButton).Font.Size    := FontSize;
     if Components[i].Tag > -2 then (Components[i] as TSpeedButton).Font.Name    := FontFace;
    end;
    if Components[i] is TJvArrowButton then begin
     if Components[i].Tag > -2 then (Components[i] as TJvArrowButton).Font.Charset := FontCharSet;
     if Components[i].Tag > -2 then (Components[i] as TJvArrowButton).Font.Size    := FontSize;
     if Components[i].Tag > -2 then (Components[i] as TJvArrowButton).Font.Name    := FontFace;
     if Components[i].Tag > -2 then (Components[i] as TJvArrowButton).FillFont.Charset := FontCharSet;
     if Components[i].Tag > -2 then (Components[i] as TJvArrowButton).FillFont.Size    := FontSize;
     if Components[i].Tag > -2 then (Components[i] as TJvArrowButton).FillFont.Name    := FontFace;
    end;
    if Components[i] is TButton      then begin
     if Components[i].Tag > -2 then (Components[i] as TButton).Font.Charset      := FontCharSet;
     if Components[i].Tag > -2 then (Components[i] as TButton).Font.Size         := FontSize;
     if Components[i].Tag > -2 then (Components[i] as TButton).Font.Name         := FontFace;
    end;
    if Components[i] is TRadioButton then begin
     if Components[i].Tag > -2 then (Components[i] as TRadioButton).Font.Charset := FontCharSet;
     if Components[i].Tag > -2 then (Components[i] as TRadioButton).Font.Size    := FontSize;
     if Components[i].Tag > -2 then (Components[i] as TRadioButton).Font.Name    := FontFace;
    end;
    if Components[i] is TCheckBox    then begin
     if Components[i].Tag > -2 then (Components[i] as TCheckBox).Font.Charset    := FontCharSet;
     if Components[i].Tag > -2 then (Components[i] as TCheckBox).Font.Size       := FontSize;
     if Components[i].Tag > -2 then (Components[i] as TCheckBox).Font.Name       := FontFace;
    end;
    if Components[i] is TLabel       then begin
     if Components[i].Tag > -2 then (Components[i] as TLabel).Font.Charset       := FontCharSet;
     if Components[i].Tag > -2 then (Components[i] as TLabel).Font.Size          := FontSize;
     if Components[i].Tag > -2 then (Components[i] as TLabel).Font.Name          := FontFace;
    end;
    if Components[i] is TEdit    then begin
     if Components[i].Tag > -2 then (Components[i] as TEdit).Font.Charset        := FontCharSet;
     if Components[i].Tag > -2 then (Components[i] as TEdit).Font.Size           := FontSize;
     if Components[i].Tag > -2 then (Components[i] as TEdit).Font.Name           := FontFace;
    end;
    if Components[i] is TRichEdit    then begin
     if Components[i].Tag > -2 then (Components[i] as TRichEdit).Font.Charset    := FontCharSet;
     if Components[i].Tag > -2 then (Components[i] as TRichEdit).Font.Size       := FontSize;
     if Components[i].Tag > -2 then (Components[i] as TRichEdit).Font.Name       := FontFace;
    end;
    if Components[i] is TComboBox    then begin
     if Components[i].Tag > -2 then (Components[i] as TComboBox).Font.Charset    := FontCharSet;
     if Components[i].Tag > -2 then (Components[i] as TComboBox).Font.Size       := FontSize;
     if Components[i].Tag > -2 then (Components[i] as TComboBox).Font.Name       := FontFace;
    end;
    if Components[i] is TMenuItem    then begin
     {to-do: nothing to do}
 {   end;
   except
   end;}

 { New experimental translation code }
   for i := 0 to pred(ComponentCount) do begin
    NameStr := LS(Components[I].Name);
    HintStr := LS(Components[I].Name+'.Hint');
    NameTag := Components[i].Tag;

//  Application.ProcessMessages;

    if (NameTag > -1) and ((NameStr <> '') or (HintStr <> '')) then try
     if Components[i] is TTabSheet    then begin
      (Components[i] as TTabSheet).Caption         := NameStr;
     end;
     if Components[i] is TGroupBox    then begin
      (Components[i] as TGroupBox).Caption         := #32+NameStr+#32; // fixes problem with non-breakable spaces under Japanese locale
     end;
     if Components[i] is TSpeedButton then begin
      (Components[i] as TSpeedButton).Caption      := NameStr;
      (Components[i] as TSpeedButton).Hint         := HintStr;
     end;
     if Components[i] is TToolButton then begin
      // The absense of caption distorts tool buttons. Stupid VCL is stupid. >_<
      // Commented out due to tons of misalignment and misresizing errors. Stupid VCL is fwapping stupid. T-T
      {if NameStr <> '' then begin
       (Components[i] as TToolButton).Caption       := NameStr;
      end;}
      (Components[i] as TToolButton).Hint          := HintStr;
     end;
     if Components[i] is TJvArrowButton then begin
      (Components[i] as TJvArrowButton).Caption    := NameStr;
      (Components[i] as TJvArrowButton).Hint       := HintStr;
     end;
     if Components[i] is TButton      then begin
      (Components[i] as TButton).Caption           := NameStr;
      (Components[i] as TButton).Hint              := HintStr;
     end;
     if Components[i] is TRadioButton then begin
      (Components[i] as TRadioButton).Caption      := NameStr;
      (Components[i] as TRadioButton).Hint         := HintStr;
     end;
     if Components[i] is TCheckBox    then begin
      (Components[i] as TCheckBox).Caption         := NameStr;
      (Components[i] as TCheckBox).Hint            := HintStr;
     end;
     if Components[i] is TComboBox    then begin
// if we'll uncomment this, we'll destroy all data we had in the particular ComboBox
//    (Components[i] as TComboBox).Caption         := NameStr;
      (Components[i] as TComboBox).Hint            := HintStr;
     end;
     if Components[i] is TLabel       then begin
      (Components[i] as TLabel).Caption            := NameStr;
     end;
     if Components[i] is TLabelW      then begin
      (Components[i] as TLabelW).Caption            := NameStr;
     end;
     if Components[i] is TMenuItem    then begin
      (Components[i] as TMenuItem).Caption         := NameStr;
     end;
    except
    end;
   end;

  end;

end;

procedure LoadTranslation(LangFile : widestring);
var i {, FontCharSet, FontSize} : integer; {FontFace, }NameStr{, HintStr} : string;
begin
 if LanguageTotal > 0 then with MainForm do
  begin
   TransFile := TIniFile.Create(LangFile);
///////// LANGUAGE FLAG (DISPLAYED IF EXISTS)
   if FileExists(WhereAreWe+TransFile.ReadString(LangFileHdr,'LangFlag','Dummy')) then
   try
    Image_LangFlag.Picture.LoadFromFile(WhereAreWe+TransFile.ReadString(LangFileHdr,'LangFlag','Dummy'));
   except
    Image_LangFlag.Picture.Bitmap := nil;
   end;

   LoadTranslation_Forms(MainForm);

///////// Generic messages
// Greately reduced code //
   for i := 0 to ReadMeFile do begin
    NameStr := LS(inttohex(i,4));
    if NameStr <> '' then AMS[i] := NameStr;
   end;

///////// TABSHEETS

///////// COMMON CONTROLS
   L_Mini_Log.Hint             := LS('L_Mini_Log.Hint');

///////// GAME ARCHIVE TOOL CONTROLS
   LV_ArcFileList.Font.Charset := $80;
   for i := 0 to 3 do
    if LS('FileList_Column_'+inttostr(i)) <> '' then
     LV_ArcFileList.Column[i].Caption := ANSI2JIS(LS('FileList_Column_'+inttostr(i)));

///////// AUDIO TOOL CONTROLS

///////// IMAGE TOOL CONTROLS

///////// SCRIPT TOOL CONTROLS

///////// MISC TOOL CONTROLS

///////// OPTIONS CONTROLS
   L_LangAuthorValue.Caption        := LS('Translator');
   L_LangWWWValue.Caption           := LS('TranslatorWWW');
   L_LangEMailValue.Caption         := LS('TranslatorEMail');
   
///////// LOG

///////// ABOUT BOX

  { OpenDialog & SaveDialog filters }
   DialogFilters[0]       := AMS[AAllFiles] + ' (*)|*';
// DialogFilters[1]       := AMS[AAllFiles] + ' (*)|*';
   DialogFilters[2]       := AMS[AAllFiles] + ' (*)|*';
   DialogFIlters[3]       := AMS[AAllFiles] + ' (*)|*';
   DialogFIlters[4]       := AMS[AAllFiles] + ' (*)|*';

   // Little fix for the version info...
   MainForm.L_Version.Caption := {AMS[AVersion]+' '+}APP_VERSION;
   //MainForm.L_Version2.Caption := MainForm.L_Version1.Caption;

   FillCredits; // Preparing credits

  end;
end;

procedure JokeAdd;
begin
 SetLength(Joke,Length(Joke)+1);
 Joke[Length(Joke)-1] := NewJoke;
end;

procedure ContribAdd;
begin
 SetLength(Contrib,Length(Contrib)+1);
 Contrib[Length(Contrib)-1] := NewContrib;
end;

procedure CompoAdd;
begin
 SetLength(Compo,Length(Compo)+1);
 Compo[Length(Compo)-1] := NewCompo;
end;

procedure TransAdd;
begin
 SetLength(Trans,Length(Trans)+1);
 Trans[Length(Trans)-1] := NewTrans;
end;

function RandomJoke : widestring;
begin
 randomize;
 Result := Joke[random(Length(Joke)-1)];
end;

procedure AddN(Number : integer = 1);
var i : integer;
begin
 with MainForm.SCredits.Credits do for i := 0 to Number-1 do Add('');
end;

procedure FillCredits;
var i : integer;
begin
 with MainForm.SCredits.Credits do begin
  Clear;
  Add(RandomJoke);
  AddN(20);
  Add('&b&u'+APP_NAME+' - '+APP_SUBNAME);
  Add(AMS[AVersion]+' '+APP_VERSION);
  AddN(4);
  Add(AMS[CCredits]);
  AddN(4);
  Add(AMS[CCore]+' \ '+AMS[CContrib]);
  AddN(2);
  for i := 0 to Length(Contrib)-1 do Add(Contrib[i]);
  AddN(4);
  Add(AMS[CLocalise]);
  AddN(2);
  for i := 0 to Length(Trans)-1 do Add(Trans[i]);
  AddN(4);
  Add(AMS[CIncludes]); // Components
  AddN(2);
  for i := 0 to Length(Compo)-1 do Add(Compo[i]);
  AddN(2);
  Add(AMS[CAppMascotBy]);
  AddN(20);
  Add(AMS[CContinued]);
 end;
end;

end.