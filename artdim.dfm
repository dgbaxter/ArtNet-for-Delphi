object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Simple dim'
  ClientHeight = 307
  ClientWidth = 510
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 287
    Top = 8
    Width = 43
    Height = 17
    Caption = 'Address:'
  end
  object TrackBar1: TTrackBar
    Left = 24
    Top = 8
    Width = 25
    Height = 113
    Max = 255
    Orientation = trVertical
    Frequency = 10
    Position = 255
    TabOrder = 0
    OnChange = TrackBar1Change
  end
  object Memo1: TMemo
    Left = 8
    Top = 136
    Width = 497
    Height = 169
    TabOrder = 1
  end
  object TrackBar2: TTrackBar
    Left = 64
    Top = 8
    Width = 25
    Height = 113
    Max = 255
    Orientation = trVertical
    Frequency = 10
    Position = 255
    TabOrder = 2
    OnChange = TrackBar2Change
  end
  object Edit1: TEdit
    Left = 336
    Top = 8
    Width = 161
    Height = 21
    TabOrder = 3
    Text = '255.255.255.255'
  end
  object Button1: TButton
    Left = 440
    Top = 40
    Width = 57
    Height = 25
    Hint = 'Move found IP to Address'
    Caption = 'Reset'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 440
    Top = 80
    Width = 57
    Height = 25
    Hint = 'See what interface is out there'
    Caption = 'Poll'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = Button2Click
  end
  object TrackBar3: TTrackBar
    Left = 104
    Top = 8
    Width = 25
    Height = 113
    Max = 255
    Orientation = trVertical
    Frequency = 10
    Position = 255
    TabOrder = 6
    OnChange = TrackBar3Change
  end
  object TrackBar4: TTrackBar
    Left = 144
    Top = 8
    Width = 25
    Height = 113
    Max = 255
    Orientation = trVertical
    Frequency = 10
    Position = 255
    TabOrder = 7
    OnChange = TrackBar4Change
  end
  object IdUDPServer1: TIdUDPServer
    Bindings = <>
    DefaultPort = 0
    Left = 272
    Top = 48
  end
end
