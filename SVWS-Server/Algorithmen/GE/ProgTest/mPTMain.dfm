object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 425
  ClientWidth = 682
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 336
    Height = 384
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 682
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitTop = -6
    object Label1: TLabel
      Left = 144
      Top = 14
      Width = 38
      Height = 17
      Caption = 'Label1'
    end
    object Button1: TButton
      Left = 8
      Top = 10
      Width = 121
      Height = 25
      Caption = 'Berechne Prognose'
      TabOrder = 0
      OnClick = Button1Click
    end
    object CheckBox1: TCheckBox
      Left = 432
      Top = 13
      Width = 169
      Height = 17
      Caption = 'Ausf'#252'hrliche Dokumentation'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
  end
  object StringGrid1: TStringGrid
    Left = 336
    Top = 41
    Width = 346
    Height = 384
    Align = alRight
    DefaultColWidth = 35
    RowCount = 2
    TabOrder = 2
    ColWidths = (
      35
      35
      35
      35
      35)
    RowHeights = (
      24
      24)
  end
end
