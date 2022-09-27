unit mPTMain;
(*------------------------------------------------------------------------------*)
interface
(*------------------------------------------------------------------------------*)
uses
  System.Classes, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids,

  PrognoseUtils;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    PrognoseBerechnung: tPrognoseBerechnung;
  end;

var
  Form1: TForm1;

implementation
(*------------------------------------------------------------------------------*)
{$R *.dfm}
(*------------------------------------------------------------------------------*)
procedure TForm1.Button1Click(Sender: TObject);
var
  N: Integer;
(* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  *)
procedure SetFachNote(aFach, aNote, aNiveau: String);
var
  FI   : Integer;
  PFach: tPFach;
begin
  with PrognoseBerechnung do
    begin
       FI:= GetFachIndexByFK(aFach);
       if FI <> -1 then with PFach do
         begin
           PFach      := Faecher[FI];
           Note       := aNote;
           NIveau     := aNiveau;
           Faecher[FI]:= PFach;
         end;
    end;
end;
(* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  *)
begin
  with PrognoseBerechnung do
    begin
      FullDokuMode:= CheckBox1.Checked;
      Nachname    := 'Sorgenvoll';
      VorName     := 'Benno';
      SetFachNote('D'   ,'3','E');
      SetFachNote('E'   ,'3','E');
      SetFachNote('M'   ,'3','E');
      SetFachNote('WP'  ,'3','' );
      SetFachNote('LBNW','3','' );
      SetFachNote('PH'  ,'3','' );
      SetFachNote('CH'  ,'2','G');
      SetFachNote('BI'  ,'3','' );
      SetFachNote('GE'  ,'3','' );
      SetFachNote('EK'  ,'3','' );
      SetFachNote('PK'  ,'3','' );
      SetFachNote('LBAL','3','' );
      SetFachNote('AT'  ,'3','' );
      SetFachNote('AW'  ,'3','' );
      SetFachNote('AH'  ,'3','' );
      SetFachNote('SP'  ,'3','' );
      SetFachNote('KU'  ,'3','' );
      SetFachNote('MU'  ,'3','' );

      BerechnePrognose;

      Memo1.Lines.Text:= PrognoseErgebnis;
      Label1.Caption:= 'Prognose / Abschluss: ' + PrognoseAsString;
      for N:= 1 to AnzahlFaecher do with Faecher[N], StringGrid1 do
        begin
          Cells[0,N]:= Gruppe;
          Cells[1,N]:= Kuerzel;
          Cells[2,N]:= Fach;
          Cells[3,N]:= Note;
          Cells[4,N]:= Niveau;
        end;
    end;
end;
(*------------------------------------------------------------------------------*)
procedure TForm1.FormCreate(Sender: TObject);
var
  N: Integer;
begin
  PrognoseBerechnung:= tPrognoseBerechnung.Create;
  with StringGrid1 do
    begin
      RowCount:= PrognoseBerechnung.AnzahlFaecher;
      ColWidths[2]:= 175;
      Cells[0,0]  := 'Grp.';
      Cells[1,0]  := 'Krz.';
      Cells[2,0]  := 'Fach';
      Cells[3,0]  := 'No.';
      Cells[4,0]  := 'Niv.';
      for N:= 1 to PrognoseBerechnung.AnzahlFaecher do with PrognoseBerechnung.Faecher[N] do
        begin
          Cells[0,N]:= Gruppe;
          Cells[1,N]:= Kuerzel;
          Cells[2,N]:= Fach;
          Cells[3,N]:= Note;
          Cells[4,N]:= Niveau;
        end;
    end;
end;

end.
