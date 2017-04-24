object GrapSForm: TGrapSForm
  Left = 391
  Top = 146
  AutoScroll = False
  ClientHeight = 615
  ClientWidth = 644
  Color = clBtnFace
  Constraints.MinHeight = 560
  Constraints.MinWidth = 594
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -9
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu_GrapS
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnPaint = FormPaint
  OnShow = FormShow
  DesignSize = (
    644
    615)
  PixelsPerInch = 96
  TextHeight = 11
  object I_Graps_View: TImage
    Left = 276
    Top = 0
    Width = 367
    Height = 591
    Hint = 'Double-click to save...'
    Anchors = [akLeft, akTop, akRight, akBottom]
    ParentShowHint = False
    ShowHint = True
    OnDblClick = M_Graps_SaveAsBMPClick
  end
  object Memo_Graps_HowTo: TMemo
    Left = 284
    Top = 9
    Width = 351
    Height = 574
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsNone
    Color = clBtnFace
    DragMode = dmAutomatic
    Lines.Strings = (
      'How to use:'
      ''
      
        'Open (or drag-n-drop) any file that (possibly) contain UNCOMPRES' +
        'SED bitmap data (game or software memory dumps, for example).'
      ''
      
        'Next, use trackbars or enter desirable bitmap size and set bits ' +
        'per pixel resolution (be careful. You will get no image if the s' +
        'ize is overruned).'
      ''
      'Use seeking controls to search the correct image offset.'
      ''
      
        'When you'#39'll get what you want, double-click the view to save BMP' +
        ' file. ^_^'
      ''
      'P.S. You can also search directly in application'#39's memory. ^_~')
    ReadOnly = True
    TabOrder = 0
    WordWrap = False
  end
  object PC_Graps_Controls: TPageControl
    Left = 0
    Top = 0
    Width = 276
    Height = 284
    ActivePage = TS_Graps_FileMode
    BiDiMode = bdLeftToRight
    HotTrack = True
    ParentBiDiMode = False
    Style = tsButtons
    TabOrder = 1
    object TS_Graps_FileMode: TTabSheet
      Caption = 'File Mode'
      object GB_Graps_Seek: TGroupBox
        Left = 4
        Top = 2
        Width = 259
        Height = 250
        Caption = ' Seek control '
        TabOrder = 0
        object L_Graps_Offset: TLabelW
          Left = 9
          Top = 18
          Width = 241
          Height = 19
          AutoSize = False
          Caption = 'Enter beginning offset:'
        end
        object L_Graps_SeekStep: TLabelW
          Left = 9
          Top = 62
          Width = 241
          Height = 19
          AutoSize = False
          Caption = 'Seeking step (for << and >>):'
        end
        object L_Graps_FinalOffsetText: TLabelW
          Left = 9
          Top = 187
          Width = 241
          Height = 19
          AutoSize = False
          Caption = 'Ending offset:'
        end
        object L_Graps_FinalOffset: TLabelW
          Left = 133
          Top = 204
          Width = 117
          Height = 10
          Alignment = taRightJustify
          AutoSize = False
          Caption = '0'
        end
        object E_Graps_Offset: TEdit
          Left = 9
          Top = 36
          Width = 241
          Height = 19
          TabOrder = 0
          Text = '0'
          OnChange = E_Graps_OffsetChange
        end
        object B_Graps_Back2: TButton
          Left = 42
          Top = 133
          Width = 19
          Height = 19
          Caption = '<'
          TabOrder = 1
          OnClick = B_Graps_Back2Click
        end
        object B_Graps_BackSeek: TButton
          Left = 62
          Top = 133
          Width = 19
          Height = 19
          Caption = '<<'
          TabOrder = 2
          OnClick = B_Graps_BackSeekClick
        end
        object B_Graps_JumpUp: TButton
          Left = 80
          Top = 107
          Width = 99
          Height = 19
          Caption = '^ Size ^'
          TabOrder = 3
          OnClick = B_Graps_JumpUpClick
        end
        object B_Graps_NextSeek: TButton
          Left = 178
          Top = 133
          Width = 19
          Height = 19
          Caption = '>>'
          TabOrder = 5
          OnClick = B_Graps_NextSeekClick
        end
        object B_Graps_Next2: TButton
          Left = 198
          Top = 133
          Width = 19
          Height = 19
          Caption = '>'
          TabOrder = 6
          OnClick = B_Graps_Next2Click
        end
        object E_Graps_Step: TEdit
          Left = 9
          Top = 80
          Width = 241
          Height = 19
          TabOrder = 7
          Text = '1024'
        end
        object B_Graps_Back1: TButton
          Left = 22
          Top = 133
          Width = 19
          Height = 19
          Caption = '.'
          TabOrder = 8
          OnClick = B_Graps_Back1Click
        end
        object B_Graps_Next1: TButton
          Left = 218
          Top = 133
          Width = 19
          Height = 19
          Caption = '.'
          TabOrder = 9
          OnClick = B_Graps_Next1Click
        end
        object B_Graps_Reset: TButton
          Left = 98
          Top = 133
          Width = 63
          Height = 19
          Caption = 'RESET'
          TabOrder = 10
          OnClick = B_Graps_ResetClick
        end
        object B_Graps_JumpDown: TButton
          Left = 80
          Top = 161
          Width = 99
          Height = 18
          Caption = 'v Size v'
          TabOrder = 4
          OnClick = B_Graps_JumpDownClick
        end
      end
    end
    object TS_Graps_ProcessList: TTabSheet
      Caption = 'Process List Mode'
      ImageIndex = 1
      OnShow = TS_Graps_ProcessListShow
      object CB_Graps_ProcessList: TGroupBox
        Left = 4
        Top = 2
        Width = 259
        Height = 250
        Caption = ' Process list and seeking '
        TabOrder = 0
        object L_Graps_ProcAddressStart: TLabelW
          Left = 9
          Top = 147
          Width = 241
          Height = 12
          AutoSize = False
          Caption = 'Memory address (HEX):'
        end
        object L_Graps_ProcMemError: TLabelW
          Left = 9
          Top = 132
          Width = 241
          Height = 10
          Alignment = taCenter
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Lucida Console'
          Font.Style = []
          ParentFont = False
        end
        object L_Graps_ProcMemCpy: TLabelW
          Left = 9
          Top = 183
          Width = 179
          Height = 13
          AutoSize = False
          Caption = 'Amount to copy (HEX):'
        end
        object LB_Graps_ProcessList: TListBox
          Left = 9
          Top = 16
          Width = 216
          Height = 116
          ItemHeight = 11
          TabOrder = 0
        end
        object E_Graps_ProcStart: TEdit
          Left = 9
          Top = 160
          Width = 115
          Height = 19
          MaxLength = 16
          TabOrder = 1
          Text = '0'
        end
        object B_Graps_CopyProcMem: TButton
          Left = 196
          Top = 160
          Width = 54
          Height = 56
          Caption = 'Grab memory'
          TabOrder = 2
          WordWrap = True
          OnClick = B_Graps_CopyProcMemClick
        end
        object B_Graps_ProcListRefresh: TButton
          Left = 229
          Top = 16
          Width = 21
          Height = 117
          Caption = 'REFRESH'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Lucida Console'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          WordWrap = True
          OnClick = TS_Graps_ProcessListShow
        end
        object E_Graps_ProcMemAmount: TEdit
          Left = 9
          Top = 197
          Width = 115
          Height = 19
          MaxLength = 16
          TabOrder = 4
          Text = '0'
        end
        object B_Graps_MemCpyFromCalc: TButton
          Left = 124
          Top = 197
          Width = 64
          Height = 19
          Caption = 'Get'
          TabOrder = 5
          OnClick = B_Graps_MemCpyFromCalcClick
        end
        object B_Graps_MemAddrPaste: TButton
          Left = 124
          Top = 160
          Width = 64
          Height = 19
          Caption = 'Paste'
          TabOrder = 6
          OnClick = B_Graps_MemAddrPasteClick
        end
        object CB_Graps_MemoryAutoCpy: TCheckBox
          Left = 9
          Top = 217
          Width = 179
          Height = 31
          Caption = 'Automatically grab every...'
          TabOrder = 7
          WordWrap = True
          OnClick = CB_Graps_MemoryAutoCpyClick
        end
        object E_Graps_CpyAutoRef: TEdit
          Left = 196
          Top = 222
          Width = 43
          Height = 19
          ReadOnly = True
          TabOrder = 8
          Text = '500'
        end
        object UD_Graps_AutoMemRef: TUpDown
          Left = 239
          Top = 222
          Width = 13
          Height = 19
          Associate = E_Graps_CpyAutoRef
          Min = 5
          Max = 32767
          Increment = 5
          Position = 500
          TabOrder = 9
          OnClick = UD_Graps_AutoMemRefClick
        end
      end
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 288
    Width = 276
    Height = 305
    ActivePage = TabSheet1
    BiDiMode = bdLeftToRight
    HotTrack = True
    ParentBiDiMode = False
    Style = tsButtons
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Image properties'
      object GB_Graps_Image: TGroupBox
        Left = 4
        Top = 2
        Width = 259
        Height = 271
        Caption = ' Image properties '
        TabOrder = 0
        object L_Graps_Width: TLabelW
          Left = 9
          Top = 18
          Width = 241
          Height = 19
          AutoSize = False
          Caption = 'Enter image width:'
        end
        object L_Graps_Height: TLabelW
          Left = 9
          Top = 83
          Width = 241
          Height = 13
          AutoSize = False
          Caption = 'Enter image height:'
        end
        object L_Graps_Bitdepth: TLabelW
          Left = 9
          Top = 151
          Width = 170
          Height = 19
          AutoSize = False
          Caption = 'Select bit resolution:'
        end
        object E_Graps_Width: TEdit
          Left = 9
          Top = 36
          Width = 241
          Height = 19
          TabOrder = 0
          Text = '1'
          OnChange = E_Graps_WidthChange
        end
        object E_Graps_Height: TEdit
          Left = 9
          Top = 98
          Width = 241
          Height = 19
          TabOrder = 1
          Text = '1'
          OnChange = E_Graps_HeightChange
        end
        object CB_Graps_Bitdepth: TComboBox
          Left = 200
          Top = 147
          Width = 50
          Height = 19
          Style = csDropDownList
          ItemHeight = 11
          ItemIndex = 3
          TabOrder = 2
          Text = '32'
          OnChange = CB_Graps_BitdepthChange
          Items.Strings = (
            '8'
            '16'
            '24'
            '32')
        end
        object TrackBar_Graps_Width: TTrackBar
          Left = 9
          Top = 54
          Width = 241
          Height = 28
          Max = 8192
          Min = 1
          Position = 1
          TabOrder = 3
          ThumbLength = 10
          TickMarks = tmTopLeft
          OnChange = TrackBar_Graps_WidthChange
        end
        object TrackBar_Graps_Height: TTrackBar
          Left = 9
          Top = 117
          Width = 241
          Height = 27
          Max = 8192
          Min = 1
          Position = 1
          TabOrder = 4
          ThumbLength = 10
          TickMarks = tmTopLeft
          OnChange = TrackBar_Graps_HeightChange
        end
        object CB_Graps_Interleaved: TCheckBox
          Left = 9
          Top = 169
          Width = 241
          Height = 19
          Caption = 'Interleaved stream (BMP-alike)'
          Checked = True
          Enabled = False
          State = cbChecked
          TabOrder = 5
        end
        object CB_Graps_HasPalette: TCheckBox
          Left = 9
          Top = 193
          Width = 88
          Height = 19
          Caption = 'Has palette at:'
          Checked = True
          State = cbChecked
          TabOrder = 6
          OnClick = CB_Graps_HasPaletteClick
        end
        object E_Graps_PaletteOffset: TEdit
          Left = 96
          Top = 193
          Width = 97
          Height = 19
          TabOrder = 7
          Text = '0'
          OnChange = E_Graps_OffsetChange
        end
        object CB_Graps_Palette_Bitdepth: TComboBox
          Left = 200
          Top = 193
          Width = 50
          Height = 19
          Style = csDropDownList
          ItemHeight = 11
          ItemIndex = 0
          TabOrder = 8
          Text = '32'
          OnChange = CB_Graps_Palette_BitdepthChange
          Items.Strings = (
            '32'
            '24')
        end
        object CB_GrapS_ImageFlipVertical: TCheckBox
          Left = 9
          Top = 216
          Width = 241
          Height = 17
          Caption = 'Vertical flip'
          TabOrder = 9
          OnClick = CB_GrapS_ImageFlipVerticalClick
        end
        object CB_GrapS_ColourSwap: TCheckBox
          Left = 9
          Top = 239
          Width = 184
          Height = 17
          Caption = 'Colour swap'
          TabOrder = 10
          OnClick = CB_GrapS_ColourSwapClick
        end
        object CB_GrapS_ColourSwapMode: TComboBox
          Left = 200
          Top = 238
          Width = 50
          Height = 19
          Style = csDropDownList
          ItemHeight = 11
          ItemIndex = 0
          TabOrder = 11
          Text = 'BGR'
          OnChange = CB_GrapS_ColourSwapModeChange
          Items.Strings = (
            'BGR'
            'BRG'
            'GBR'
            'GRB'
            'RBG')
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Additional options'
      ImageIndex = 1
      OnShow = TS_Graps_ProcessListShow
      object GroupBox2: TGroupBox
        Left = 4
        Top = 2
        Width = 259
        Height = 250
        Caption = ' Additional options '
        TabOrder = 0
        object L_Graps_CalcStrSizeHEX: TLabelW
          Left = 9
          Top = 19
          Width = 125
          Height = 31
          AutoSize = False
          Caption = 'Calculated size (HEX):'
          WordWrap = True
        end
        object L_Graps_StreamSizeValue: TLabelW
          Left = 137
          Top = 40
          Width = 110
          Height = 10
          AutoSize = False
          Caption = '0'
        end
        object Bevel_Graps_2: TBevel
          Left = 1
          Top = 248
          Width = 257
          Height = 2
          Shape = bsTopLine
        end
        object Bevel_Graps_1: TBevel
          Left = 1
          Top = 216
          Width = 257
          Height = 2
          Shape = bsTopLine
        end
        object CB_Graps_Stretch: TCheckBox
          Left = 9
          Top = 223
          Width = 241
          Height = 19
          Caption = 'Stretch for viewer'
          TabOrder = 0
          OnClick = CB_Graps_StretchClick
        end
        object E_Graps_StreamSizeValue: TEdit
          Left = 133
          Top = 14
          Width = 117
          Height = 19
          MaxLength = 16
          ReadOnly = True
          TabOrder = 1
          Text = '0'
          OnChange = E_Graps_StreamSizeValueChange
        end
      end
    end
  end
  object SB_Graps_ImageProperties: TStatusBar
    Left = 0
    Top = 596
    Width = 644
    Height = 19
    Panels = <
      item
        Text = '0 x 0'
        Width = 100
      end
      item
        Text = '0 bit'
        Width = 50
      end
      item
        Text = '(not a file)'
        Width = 0
      end>
  end
  object MainMenu_GrapS: TMainMenu
    Left = 317
    Top = 144
    object M_Graps_File: TMenuItem
      Caption = ' File '
      object M_Graps_OpenFile: TMenuItem
        Caption = 'Open...'
        OnClick = M_Graps_OpenFileClick
      end
      object M_Graps_Sep1: TMenuItem
        Caption = '-'
      end
      object M_Graps_SaveAsBMP: TMenuItem
        Caption = 'Save as BMP...'
        OnClick = M_Graps_SaveAsBMPClick
      end
      object M_Graps_Sep2: TMenuItem
        Caption = '-'
      end
      object M_Graps_Exit: TMenuItem
        Caption = 'Return to AE'
        OnClick = M_Graps_ExitClick
      end
    end
    object M_Graps_Help: TMenuItem
      Caption = ' ? '
      OnClick = M_Graps_HelpClick
    end
  end
  object T_Graps_AutoMemRef: TTimer
    Enabled = False
    Interval = 500
    OnTimer = T_Graps_AutoMemRefTimer
    Left = 317
    Top = 191
  end
end
