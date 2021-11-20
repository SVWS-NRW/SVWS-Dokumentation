unit PrognoseUtils;
(*------------------------------------------------------------------------------*)
interface
(*------------------------------------------------------------------------------*)
uses
  Classes,
  SysUtils,
  BaseUtils2;
const
  MaxPFaecher=  25;
  LF         = #13;
  DLF        = #13#13;
  SLD        : String= ' — ';
type
  tPrognose = (pOA, pHA9, pHA10, pMSA, pMSAQ);
  tPFach = record
             Kuerzel, Fach, Note: String;
             Gruppe             : String;
             Niveau             : String;
             MitNiveau          : Boolean;
             Zeile              : Integer;
             FachSpalte         : Integer;
             NotenSpalte        : Integer;
             NivSpalte          : Integer;
             FGNote             : Integer;
           end;
  tFaecherGruppe = set of Byte;
  tNoten = set of Byte;
  tPFaecher = array[1..MaxPFaecher] of tPFach;
  tPrognoseBerechnung = class
                          private
                            FNachname             : String;
                            FVorname              : String;
                            FKlasse               : String;
                            FASDJahrgang          : String;
                            FAnzahlFaecher        : Integer;
                            FFaecher              : tPFaecher;
                            FZusaetzlicheFS       : String;
                            FPhNivBak             : String;
                            FChNivBak             : String;
                            FMNivBak              : String;
                            FPrognose             : tPrognose;
                            FPrognoseErgebnis     : String;
                            FFachersetzungen      : String;
                            FNPFaecherHA9         : String;
                            FNPFaecherHA10        : String;
                            FNPFaecherMSA         : String;
                            FNPFaecherMSAQ        : String;
                            FFG                   : array[1..2] of tFaecherGruppe;
                            slFFachersetzungen    : tStringList;
                            FFullDokuMode         : Boolean;
                            FNPFullDokuMode       : Boolean;
                            FNameDatumMode        : Boolean;
                            FBlockBegin, FBlockEnd: String;
                            FLC                   : String;

                            procedure   SetNachname(const Nachname: String);
                            procedure   SetVorName(const VorName: String);
                            procedure   SetKlasse(const Klasse: String);
                            procedure   SetASDJahrgang(const ASDJahrgang: String);
                            procedure   SetPrognose(Prognose: tPrognose);
                            procedure   SetPrognoseErgebnis(const PrognoseErgebnis: String);
                            procedure   SetFach(Index: Integer; Fach: tPFach);
                            function    GetFach(Index: Integer): tPFach;
                            procedure   SetMNivBak(const aNiv: String);
                            procedure   SetPhNivBak(const aNiv: String);
                            procedure   SetChNivBak(const aNiv: String);

                            procedure   SetZusaetzlicheFS(const ZusaetzlicheFS: String);
                            procedure   SetFachersetzungen(const Fachersetzungen: String);
                            procedure   SetFullDokuMode(TextModus: Boolean);
                            procedure   SetNPFullDokuMode(TextModus: Boolean);
                            procedure   SetNameDatumMode(NameDatumModus: Boolean);
                            procedure   AddText(const Text: String);
                            procedure   AddText2(const Hinweis: String);
                            procedure   AddText3(const Hinweis: String);
                            function    SinPluConcat(const Wort1, Wort2: String): String;
                          public
                            property    Nachname: String read FNachname write SetNachname;
                            property    VorName: String read FVorName write SetVorName;
                            property    Klasse: String read FKlasse write SetKlasse;
                            property    ASDJahrgang: String read FASDJahrgang write SetASDJahrgang;
                            property    Prognose: tPrognose read FPrognose write SetPrognose;
                            property    PrognoseErgebnis: String read FPrognoseErgebnis write SetPrognoseErgebnis;
                            property    AnzahlFaecher: Integer read FAnzahlFaecher;
                            property    Faecher[Index: Integer]: tPFach read GetFach write SetFach;
                            property    MNivBak: String  read FMNivBak  write SetMNivBak;
                            property    PhNivBak: String read FPhNivBak write SetPhNivBak;
                            property    ChNivBak: String read FChNivBak write SetChNivBak;
                            property    ZusaetzlicheFS: String read FZusaetzlicheFS write SetZusaetzlicheFS;
                            property    Fachersetzungen: String read FFachersetzungen write SetFachersetzungen;
                            property    FullDokuMode: Boolean read FFullDokuMode write SetFullDokuMode;
                            property    NPFullDokuMode: Boolean read FNPFullDokuMode write SetNPFullDokuMode;
                            property    NameDatumMode: Boolean read FNameDatumMode write SetNameDatumMode;

                            constructor Create;
                            destructor  Destroy;
                            function    GetFachIndexByFK(FK: String): Integer;
                            function    GetFachGruppeByFK(const FK: String): String;
                            function    GetFachIndexByZeile(Z: Integer): Integer;
                            procedure   SetFachSpalten(const Header: String);
                            procedure   ClearFaecherNotenNiveauPrognose;

                            function    Note2FGNote(const Note: String): Integer;
                            procedure   InitFGNoten;
                            procedure   DecNote(var Note: Integer);
                            procedure   IncNote(var Note: Integer);
                            function    GetFachFGNote(const FK: String): Integer;
                            function    GetFachNiveau(const FK: String): String;
                            function    IsZusaetzlicheFremdsprache(const FK: String): Boolean;
                            function    IsLBNotenVorhanden(var Ergebnis: String): Boolean;
                            function    IsFKInFachListe(const FK, FachListe: String): Boolean;
                            function    LoescheFKAusFachListe(const FK, FachListe: String): String;
                            procedure   PrepareZusaetzlicheEFaecher(aPrognose: tPrognose; var Ergebnis: String);

                            function    MatchFG(aFI, aFG: Integer): Boolean;
                            function    SetFaecherGruppen(aPrognose: tPrognose; var Ergebnis: String): Boolean;
                            function    GetFKsAusFG(aFG: Integer; aPrognose: tPrognose; Erweitert: Boolean= True): String;
                            function    GetNPFaecher(aPrognose: tPrognose): String;
                            function    GetAnzMitNote(aNoten: tNoten; aFG: Integer; const aNiv: String): Integer;
                            function    GetFKsMitNote(aNoten: tNoten; aFG: Integer; const aNiv: String): String;
                            function    GetAnzMitNiv(aFG: Integer; const aNiveau: String): Integer;
                            function    GetFKsMitNiv(aFG: Integer; const aNiveau: String): String;
                            procedure   GetAnzFKsDef(var Anz: Integer; var FKs: String; aFG: Integer; aPrognose: tPrognose; aAnzNS: Integer; AlleDefizite: Boolean);
                            procedure   GetAnzFKsAusgleiche(var Anz: Integer; var FKs: String; aFG: Integer; aPrognose: tPrognose);

                            function    Prog2Str(aPrognose: tPrognose): String;
                            function    PrognoseAsString: String;
                            function    Str2Prog(asPrognose: String): tPrognose;

                            function    IsHA(var Ergebnis: String; var CheckNP: Boolean; Einzug: Integer = 1): Boolean;

                            function    CheckHA9: Boolean;
                            function    CheckHA10: Boolean;

                            function    IsMSA(var Ergebnis: String; var CheckAusgleich: Boolean; Einzug: Integer = 1): Boolean;
                            function    CheckMSAAusgleich(var ProgErgebnis: String; var CheckNP: Boolean; const NPFach: String; Einzug: Integer = 1): Boolean;
                            function    CheckMSA: Boolean;

                            function    IsMSAQ(var Ergebnis: String; var CheckAusgleich: Boolean; Einzug: Integer = 1): Boolean;
                            function    CheckMSAQAusgleich(var ProgErgebnis: String; var CheckNP: Boolean; const NPFach: String; Einzug: Integer = 1): Boolean;
                            function    CheckMSAQ: Boolean;

                            procedure   GetPrognoseInfo(var Ergebnis: String; aPrognose: tPrognose);
                            procedure   InitPrognose;
                            procedure   BerechnePrognose;
                          end;

(*------------------------------------------------------------------------------*)
implementation

(*------------------------------------------------------------------------------*)
destructor tPrognoseBerechnung.Destroy;
begin
  Inherited Destroy;
  slFFachersetzungen.Free;
end;

(*------------------------------------------------------------------------------*)
constructor tPrognoseBerechnung.Create;
var
  I    : Integer;
  PFach: tPFach;
begin
  Inherited Create;
  FFullDokuMode:= True;
  FNameDatumMode:= True;
  FBlockBegin:= '==========';
  FBlockEnd  := '______________________________';
  FLC        := '=>';
  with PFach do begin Kuerzel:= ''; Fach:= ''; Zeile:= -1; MitNiveau:= False; Gruppe:= ''; FachSpalte := -1; NotenSpalte:= -1; NivSpalte  := -1; end;
  for I:= 1 to MaxPFaecher do FFaecher[I]:= PFach;
  I:= 1;
  with PFach do begin Kuerzel:= 'D'   ; Gruppe:= 'HF'; Fach:= 'Deutsch' ;   MitNiveau:= True;      Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'E'   ; Gruppe:= 'HF'; Fach:= 'Englisch';   MitNiveau:= True;      Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'M'   ; Gruppe:= 'HF'; Fach:= 'Mathematik'; MitNiveau:= True;      Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'WP'  ; Gruppe:= 'HF'; Fach:= 'WP-Fach';    MitNiveau:= False;     Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'LBNW'; Gruppe:= 'NW'; Fach:= 'Lernbereich - Naturwissenschaften'; Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'Bi'  ; Gruppe:= 'NW'; Fach:= 'Biologie';                          Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'Ch'  ; Gruppe:= 'NW'; Fach:= 'Chemie';     MitNiveau:= True;      Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'Ph'  ; Gruppe:= 'NW'; Fach:= 'Physik';     MitNiveau:= True;      Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'GL'  ; Gruppe:= 'GL'; Fach:= 'Gesellschaftslehre';                Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'Ek'  ; Gruppe:= 'GL'; Fach:= 'Erdkunde';                          Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'Ge'  ; Gruppe:= 'GL'; Fach:= 'Geschichte';                        Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'Pk'  ; Gruppe:= 'GL'; Fach:= 'Politik';                           Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'LBAL'; Gruppe:= 'AL'; Fach:= 'Lernbereich - Arbeitslehre';        Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'AT'  ; Gruppe:= 'AL'; Fach:= 'Arbeitslehre - Technik';            Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'AW'  ; Gruppe:= 'AL'; Fach:= 'Arbeitslehre - Wirtschaft';         Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'AH'  ; Gruppe:= 'AL'; Fach:= 'Arbeitslehre - Hauswirtschaft';     Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'RePP'; Gruppe:= 'SF'; Fach:= 'Rel./Prak. Philo.';                 Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'Sp'  ; Gruppe:= 'SF'; Fach:= 'Sport';                             Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'Ku'  ; Gruppe:= 'SF'; Fach:= 'Kunst';                             Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'Mu'  ; Gruppe:= 'SF'; Fach:= 'Musik';                             Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'Tx'  ; Gruppe:= 'SF'; Fach:= 'Textilkunde';                       Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'EF1' ; Gruppe:= 'EF'; Fach:= 'EF1-Fach';                          Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'EF2' ; Gruppe:= 'EF'; Fach:= 'EF2-Fach';                          Zeile:= I; end; FFaecher[I]:= PFach; Inc(I);
  with PFach do begin Kuerzel:= 'EF3' ; Gruppe:= 'EF'; Fach:= 'EF3-Fach';                          Zeile:= I; end; FFaecher[I]:= PFach;
  FAnzahlFaecher := I;
  slFFachersetzungen:= tStringList.Create;
end;

(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetNachname(const Nachname: String);
begin
  FNachname:= Nachname;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetVorName(const VorName: String);
begin
  FVorName:= VorName;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetKlasse(const Klasse: String);
begin
  FKlasse:= Klasse;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetASDJahrgang(const ASDJahrgang: String);
begin
  FASDJahrgang:= ASDJahrgang;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetPrognose(Prognose: tPrognose);
begin
  FPrognose:= Prognose;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetPrognoseErgebnis(const PrognoseErgebnis: String);
begin
  FPrognoseErgebnis:= PrognoseErgebnis;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetFach(Index: Integer; Fach: tPFach);
begin
  if (Length(Fach.Niveau) > 0) and (Fach.Niveau[1] <> 'E') and (Fach.Niveau[1] <> 'G') then Fach.Niveau:= '';
  FFaecher[Index]:= Fach;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.GetFach(Index: Integer): tPFach;
begin
  Result:= FFaecher[Index];
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetMNivBak(const aNiv: String);
begin
  FMNivBak := aNiv;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetPhNivBak(const aNiv: String);
begin
  FPhNivBak := aNiv;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetChNivBak(const aNiv: String);
begin
  FChNivBak := aNiv;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.Prog2Str(aPrognose: tPrognose): String;
// Umwandlungsroutine
begin
  case aPrognose of
    pOA  : Result:= 'OA';
    pHA9 : Result:= 'HA';
    pHA10: Result:= 'HA10';
    pMSA : Result:= 'FOR';
    pMSAQ: Result:= 'FORQ-E';
  end;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.PrognoseAsString: String;
// Umwandlungsroutine
begin
  Result:= Prog2Str(FPrognose);
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.Str2Prog(asPrognose: String): tPrognose;
// Umwandlungsroutine
begin
  Result:= pOA;

  if Pos('GE/APO-SI05/', asPrognose) > 0 then asPrognose:= After('GE/APO-SI05/', asPrognose);

  if asPrognose = 'OA'      then Result:= pOA;

  if asPrognose = 'HA 10'   then Result:= pHA10;// Altlast
  if asPrognose = '(HA 10)' then Result:= pHA10;// Altlast
  if asPrognose = 'HA 10?'  then Result:= pOA;  // Altlast

  if asPrognose = 'HA'      then Result:= pHA9;
  if asPrognose = 'HA10'    then Result:= pHA10;
  if asPrognose = 'FOR'     then Result:= pMSA;
  if asPrognose = 'FORQ-E'  then Result:= pMSAQ;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetZusaetzlicheFS(const ZusaetzlicheFS: String);
begin
  FZusaetzlicheFS:= ZusaetzlicheFS;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetFachersetzungen(const Fachersetzungen: String);
var
  N, I   : Integer;
  L, J   : Integer;
  Item   : String;
  FK, EFK: String;
begin
  FFachersetzungen:= Fachersetzungen;
  slFFachersetzungen.Clear;
  if FFachersetzungen = '' then Exit;
  N:= NCountOf(';',Fachersetzungen);
  for I := 1 to N do
    begin
      Item:= NBetween(I,';',Fachersetzungen);
      FK  := Before('=',Item);
      EFK := After ('=',Item);
      if (FK <> '') and (EFK <> '') then
        begin
          L:= NCountOf(',', EFK);
          for J:= 1 to L do slFFachersetzungen.Add(NBetween(J, ',', EFK) + SLD + FK);
        end;
    end;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetFullDokuMode(TextModus: Boolean);
begin
  FFullDokuMode:= TextModus;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetNPFullDokuMode(TextModus: Boolean);
begin
  FNPFullDokuMode:= TextModus;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetNameDatumMode(NameDatumModus: Boolean);
begin
  FNameDatumMode:= NameDatumModus;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.AddText(const Text: String);
begin
  if Text = ''
    then FPrognoseErgebnis:= FPrognoseErgebnis + LF
    else FPrognoseErgebnis:= SConcat(FPrognoseErgebnis,Text,LF,False,False);
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.AddText2(const Hinweis: String);
begin
  if (FFullDokuMode) and (Hinweis <> '')
    then AddText(Hinweis);
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.AddText3(const Hinweis: String);
begin
  if (FFullDokuMode) and (FNPFullDokuMode) and (Hinweis <> '')
    then AddText(Hinweis);
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.SinPluConcat(const Wort1, Wort2: String): String;
begin
  if Pos(',',Wort2) > 0
    then Result:= Wort1 + 'e' + ': ' + Wort2
    else Result:= Wort1       + ': ' + Wort2;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.GetFachIndexByFK(FK: String): Integer;
var
  I: Integer;
begin
  Result:= -1;
  I:= SLIndexOf(FK,slFFachersetzungen);
  if (I <> -1) then FK:= After(SLD,slFFachersetzungen[I]);
  if FK = '' then Exit;
  FK:= Upper(FK);
  for I:= 1 to FAnzahlFaecher do with FFaecher[I] do
    begin
      if (Upper(Kuerzel) = FK) then
        begin;
          Result:= I;
          Exit;
        end;
    end;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.GetFachGruppeByFK(const FK: String): String;
var
  FI: Integer;
begin
  FI:= GetFachIndexByFK(FK);
  if FI <> -1
    then Result:= FFaecher[FI].Gruppe
    else Result:= '';
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.GetFachIndexByZeile(Z: Integer): Integer;
var
  I: Integer;
begin
  Result:= -1;
  for I:= 1 to FAnzahlFaecher do with FFaecher[I] do
    begin
      if (Zeile = Z) then
        begin;
          Result:= I;
          Exit;
        end;
    end;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.SetFachSpalten(const Header: String);
var
  S, N, FI: Integer;
  Del     : Char;
  FK      : String;
begin
  Del:= GetDelimiter(Header);
  N:= NCountOf(Del,Header);
  for S:= 1 to N do
    begin
      FK:= Before('-Note',NBetween(S,Del,Header));
      if FK <> '' then
        begin
          FI:= GetFachIndexByFK(FK);
          if FI <> -1 then FFaecher[FI].NotenSpalte:= S;
          Continue;
        end;
      FK:= Before('-Niv',NBetween(S,Del,Header));
      if FK <> '' then
        begin
          FI:= GetFachIndexByFK(FK);
          if FI <> -1 then FFaecher[FI].NivSpalte:= S;
          Continue;
        end;
      FK:= Before('-Fach',NBetween(S,Del,Header));
      if FK <> '' then
        begin
          FI:= GetFachIndexByFK(FK);
          if FI <> -1 then FFaecher[FI].FachSpalte:= S;
          Continue;
        end;
    end;
end;

(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.ClearFaecherNotenNiveauPrognose;
var
  I: Integer;
begin
  for I:= 1 to FAnzahlFaecher do with FFaecher[I] do
    begin
      Note  := '';
      Niveau:= '';
    end;
  Prognose:= pOA;
  PrognoseErgebnis:= '';
end;

(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.Note2FGNote(const Note: String): Integer;
begin
  if (Length(Note) >= 1) and (CharInSet(Note[1],['1'..'6']))
    then Result:= IntegerVal(Note[1])
    else Result:= -1;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.InitFGNoten;
var
  I: Integer;
begin
  for I:= 1 to FAnzahlFaecher do
    with FFaecher[I] do
      begin
        FGNote:= Note2FGNote(Note);
        if Kuerzel = 'M'  then Niveau:= FMNivBak;
        if Kuerzel = 'Ph' then Niveau:= FPhNivBak;
        if Kuerzel = 'Ch' then Niveau:= FChNivBak;
      end;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.DecNote(var Note: Integer);
begin
  if Note > 1 then Note:= Note - 1;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.IncNote(var Note: Integer);
begin
  if Note < 6 then Note:= Note + 1;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.GetFachFGNote(const FK: String): Integer;
var
  FI: Integer;
begin
  FI:= GetFachIndexByFK(FK);
  if FI <> -1
    then Result:= FFaecher[FI].FGNote
    else Result:= -1;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.GetFachNiveau(const FK: String): String;
var
  FI: Integer;
begin
  FI:= GetFachIndexByFK(FK);
  if FI <> -1
    then Result:= FFaecher[FI].Niveau
    else Result:= '';
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.IsZusaetzlicheFremdsprache(const FK: String): Boolean;
begin
  Result:= IstEnthalten(FK, FZusaetzlicheFS);
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.IsLBNotenVorhanden(var Ergebnis: String): Boolean;
var
  FI                : Integer;
  IsLBNWnv, IsLBALnv: Boolean;
begin
  Ergebnis:= '';

  FI:= GetFachIndexByFK('LBNW'); IsLBNWnv:= (FI = -1) or (FFaecher[FI].Note = '');
  FI:= GetFachIndexByFK('LBAL'); IsLBALnv:= (FI = -1) or (FFaecher[FI].Note = '');

  if (IsLBNWnv and IsLBALnv)
    then Ergebnis:= FLC + ' Fehler: Lernbereichsnoten NW/AL nicht vorhanden!'
    else
      begin
        if IsLBNWnv then Ergebnis:= FLC + ' Fehler: Lernbereichsnote NW nicht vorhanden!';
        if IsLBALnv then Ergebnis:= FLC + ' Fehler: Lernbereichsnote AL nicht vorhanden!';
      end;
  Result:= Ergebnis = '';
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.IsFKInFachListe(const FK, FachListe: String): Boolean;
begin
  Result:= IstEnthalten(Fk, FachListe);
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.LoescheFKAusFachListe(const FK, FachListe: String): String;
var
  D             : String;
  I             : Integer;
  slExplodeItems: tStringlist;
begin
  Result:= FachListe;
  if IstEnthalten(Fk, FachListe) then
    begin
      slExplodeItems:= tStringlist.Create;
      D:= GetDelimiter(FachListe);
      Explode2StringList(D,'',FachListe,slExplodeItems);
      for I := slExplodeItems.Count-1 downto 0 do
        if slExplodeItems[I] = FK
          then slExplodeItems.Delete(I);
      Result:= ImplodeStringList2String(D, slExplodeItems);
      slExplodeItems.Free;
    end;

end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.PrepareZusaetzlicheEFaecher(aPrognose: tPrognose; var Ergebnis: String);
var
  FI, UG, FG1_Anz_E, FG2_Anz_E: Integer;
begin
  UG:= 0;
  if aPrognose = pMSA  then UG:= 2;
  if aPrognose = pMSAQ then UG:= 3;
  if UG = 0 then Exit;
  FG1_Anz_E:= GetAnzMitNiv(1,'E');
  FG2_Anz_E:= GetAnzMitNiv(2,'E');
  if (FG1_Anz_E + FG2_Anz_E <= UG) then Exit;
  if (FG2_Anz_E > 0) and (FG1_Anz_E + FG2_Anz_E > UG) then
    begin // in diesem Fall ist Ch/Ph ein überzähliges E-Niv-Fach
      FI:= GetFachIndexByFK('Ch');
      if FI <> -1 then with FFaecher[FI] do
        if Niveau = 'E' then
          begin
            DecNote(FGNote);
            Niveau:= 'G';
            FChNivBak:= 'E';
            Ergebnis:= SConcat(Ergebnis,'Ch:E('+SInteger(FGNote+1)+')->G('+SInteger(FGNote)+')',',',True,True);
          end;
      FI:= GetFachIndexByFK('Ph');
      if FI <> -1 then with FFaecher[FI] do
        if Niveau = 'E' then
          begin
            DecNote(FGNote);
            Niveau:= 'G';
            FPhNivBak:= 'E';
            Ergebnis:= SConcat(Ergebnis,'Ph:E('+SInteger(FGNote+1)+')->G('+SInteger(FGNote)+')',',',True,True);
          end;
    end;
  if (FG1_Anz_E > UG) then
    begin // in diesem Fall ist Mathematik auch noch ein überzähliges E-Niv-Fach
      FI:= GetFachIndexByFK('M');
      if FI <> -1 then with FFaecher[FI] do
        if Niveau = 'E' then
          begin
            DecNote(FGNote);
            Niveau:= 'G';
            FMNivBak:= 'E';
            Ergebnis:= SConcat(Ergebnis,'M:E('+SInteger(FGNote+1)+')->G('+SInteger(FGNote)+')',',',True,True);
          end;
    end;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.MatchFG(aFI, aFG: Integer): Boolean;
begin
  if (aFG < 3) and (aFI < 256)
    then Result:= ((aFG > 0) and (aFI in FFG[aFG])) or ((aFG = 0) and ((aFI in FFG[1]) or (aFI in FFG[2])))
    else Result:= False;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.SetFaecherGruppen(aPrognose: tPrognose; var Ergebnis: String): Boolean;
var
  F: Integer;
begin
  Ergebnis:= '';
  FFG[1]:= [];
  FFG[2]:= [];
  if aPrognose = pHA9 then
    begin
      for F:= 1 to FAnzahlFaecher do
        with FFaecher[F] do
          begin
            if (Kuerzel = 'LBNW') or (Kuerzel = 'LBAL') then Continue;
            FGNote:= Note2FGNote(Note);
            if FGNote <> -1 then
              begin
                if (Niveau = 'E') and (FGNote > 1) then begin DecNote(FGNote); Ergebnis:= SConcat(Ergebnis,Kuerzel+'(E):'+ SInteger(FGNote+1)+'->'+ SInteger(FGNote),',',True,True); end;
                if ((Kuerzel= 'D') or (Kuerzel= 'M'))
                  then FFG[1]:= FFG[1] + [F]
                  else
                    begin
                      FFG[2]:= FFG[2] + [F];
//                      if not IsZusaetzlicheFremdsprache(Fach)
//                        then FFG[2]:= FFG[2] + [F]
//                        else Ergebnis:= SConcat(Ergebnis,'Ignoriere: ' + Fach,',',True,True)
                    end;
              end;
          end;
    end;
  if aPrognose = pHA10 then
    begin
      for F:= 1 to FAnzahlFaecher do
        with FFaecher[F] do
          begin
            FGNote:= Note2FGNote(Note);
            if FGNote <> -1 then
              begin
                if (Niveau = 'E') and (FGNote > 1) then begin DecNote(FGNote); Ergebnis:= SConcat(Ergebnis,Kuerzel+'(E):'+ SInteger(FGNote+1)+'->'+ SInteger(FGNote),',',True,True); end;
                if ((Kuerzel= 'D') or (Kuerzel= 'M') or (Kuerzel= 'LBNW') or (Kuerzel= 'LBAL'))
                  then FFG[1]:= FFG[1] + [F]
                  else
                    begin
                      if (Kuerzel= 'Bi') or (Kuerzel= 'Ph') or (Kuerzel= 'Ch') then Continue;
                      if (Kuerzel= 'AT') or (Kuerzel= 'AW') or (Kuerzel= 'AH') then Continue;
                      FFG[2]:= FFG[2] + [F];
//                      if not IsZusaetzlicheFremdsprache(Fach)
//                        then FFG[2]:= FFG[2] + [F]
//                        else Ergebnis:= SConcat(Ergebnis,'Ignoriere: ' + Fach,',',True,True)
                    end;
              end;
          end;
    end;
  if (aPrognose = pMSA) or (aPrognose = pMSAQ) then
    begin
      for F:= 1 to FAnzahlFaecher do
        with FFaecher[F] do
          begin
            if (Kuerzel = 'LBNW') or (Kuerzel = 'LBAL') then Continue;
            FGNote:= Note2FGNote(Note);
            if FGNote <> -1 then
              begin
                if ((Kuerzel= 'D') or (Kuerzel= 'M') or (Kuerzel= 'E') or (Kuerzel= 'WP'))
                  then FFG[1]:= FFG[1] + [F]
                  else FFG[2]:= FFG[2] + [F];
              end;
          end;
    end;
  PrepareZusaetzlicheEFaecher(aPrognose, Ergebnis); // eventuell wird aus Ph/CH E-Kurs ein G-Kurs mit einer besseren Note (-1)

  Result:= (FFG[1] <> []) and (FFG[2] <> []);
  if not Result then
    begin
      Ergebnis:= SConcat(Ergebnis,FBlockEnd,LF,False,True);
      Ergebnis:= SConcat(Ergebnis,FLC + ' Fehler: FG1 oder FG2 enthält keine Leistungsdaten',LF,False,True);
    end;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.GetFKsAusFG(aFG: Integer; aPrognose: tPrognose; Erweitert: Boolean= True): String;
var
  F   : Integer;
  Item: String;
begin
  Result:= '';
  for F:= 1 to FAnzahlFaecher do
    if MatchFG(F,aFG) then
      with FFaecher[F] do
        begin
          if Erweitert
            then
              begin
                Item:= Kuerzel + '(';
                if (aPrognose in [pMSA, pMSAQ])
                  then if ((Niveau = 'E') or (Niveau = 'G')) then Item:= Item + Niveau + ',';
                Item:= Item + SInteger(FGNote) + ')';
                Result:= SConcat(Result,Item,',', True, True);
              end
            else Result:= SConcat(Result,Kuerzel,',', True, True);
        end;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.GetNPFaecher(aPrognose: tPrognose): String;
// Gibt die Nachprüfungsfächer zu der Prognose aPrognose
// Wenn aPrognose= pOA: Werden alle möglichen Nachprüfungsfächer zurückgegeben: Bsp: "HA10: GL; MSA: RePP, IF"
begin
  Result:= '';
  if aPrognose = pHA9  then Result:= FNPFaecherHA9;
  if aPrognose = pHA10 then Result:= FNPFaecherHA10;
  if aPrognose = pMSA  then Result:= FNPFaecherMSA;
  if aPrognose = pMSAQ then Result:= FNPFaecherMSAQ;
  if aPrognose = pOA then
    begin
      if FNPFaecherHA9  <> '' then Result:= SConcat(Result,'HA 9: '  + FNPFaecherHA9 ,'; ', False, False);
      if FNPFaecherHA10 <> '' then Result:= SConcat(Result,'HA 10: ' + FNPFaecherHA10,'; ', False, False);
      if FNPFaecherMSA  <> '' then Result:= SConcat(Result,'MSA: '   + FNPFaecherMSA ,'; ', False, False);
      if FNPFaecherMSAQ <> '' then Result:= SConcat(Result,'MSAQ: '  + FNPFaecherMSAQ,'; ', False, False);
    end;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.GetAnzMitNote(aNoten: tNoten; aFG: Integer; const aNiv: String): Integer;
// Gibt die Anzahl der Fächer, die im Notenintervall aNoten liegen und zur FG=aFG gehören
// und das Niveau aNiv haben
// aFG=0,1,2 (0=beide FGs)
// aNiv='': Niveau wird ignoriert, aNiv='X': kein Niveau
var
  F: Integer;
begin
  Result:= 0;
  for F:= 1 to FAnzahlFaecher do
    if MatchFG(F,aFG) then
      with FFaecher[F] do
        if (FGNote in aNoten) and ((aNiv = '') or (Niveau = aNiv) or ((aNiv = 'X') and (Niveau = '')))
          then Inc(Result,1);
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.GetFKsMitNote(aNoten: tNoten; aFG: Integer; const aNiv: String): String;
// Gibt die Fächer, die im Notenintervall aNoten liegen und zur FG=aFG gehören
// und das Niveau aNiv haben
// aFG=0,1,2 (0=beide FGs)
// aNiv='': Niveau wird ignoriert, aNiv='X': kein Niveau
var
  F: Integer;
begin
  Result:= '';
  for F:= 1 to FAnzahlFaecher do
    if MatchFG(F,aFG) then
      with FFaecher[F] do
        if (FGNote in aNoten) and ((aNiv = '') or (Niveau = aNiv) or ((aNiv = 'X') and (Niveau = '')))
          then Result:= SConcat(Result,Kuerzel,',',True,True);
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.GetAnzMitNiv(aFG: Integer; const aNiveau: String): Integer;
var
  F: Integer;
begin
  Result:= 0;
  for F:= 1 to FAnzahlFaecher do
    if MatchFG(F,aFG) then
      with FFaecher[F] do
        if (Niveau = aNiveau) then Inc(Result,1);
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.GetFKsMitNiv(aFG: Integer; const aNiveau: String): String;
var
  F: Integer;
begin
  Result:= '';
  for F:= 1 to FAnzahlFaecher do
    if MatchFG(F,aFG) then
      with FFaecher[F] do
        if Niveau = aNiveau then Result:= SConcat(Result,Kuerzel,',',True,True);
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.GetAnzFKsDef(var Anz: Integer; var FKs: String; aFG: Integer; aPrognose: tPrognose; aAnzNS: Integer; AlleDefizite: Boolean);
// bestimmt die Anzahl und die Fächer mit Defizit zur Prognose=aPrognose und der FG=aFG
// AlleDefizite=True : alle ab aAnzNS-Notenstufen
// AlleDefizite=False: um aAnzNS-Notenstufen
var
  NI1, NI2   : set of Byte;
  FG2_1_3_Anz: Integer;
begin
  FKs:= '';
  Anz := 0;
  NI1    := [];
  NI2    := [];
  if (aPrognose = pHA9) or (aPrognose = pHA10) then
    begin
      if AlleDefizite
        then
          case aAnzNS of
            1: NI1:= [5..6];
            2: NI1:= [6];
            3: NI1:= [];
          end
        else
          case aAnzNS of
            1: begin NI1:= [5]; NI2:= [4]; end;
            2: begin NI1:= [6]; NI2:= [5]; end;
            3: begin NI1:= [] ; NI2:= [6]; end;
          end
    end;
  if (aPrognose = pMSA)  then
    begin
      if AlleDefizite
        then
          case aAnzNS of
            1: begin NI1:= [5..6]; NI2:= [4..6]; end;
            2: begin NI1:= [6]   ; NI2:= [5..6]; end;
            3: begin NI1:= []    ; NI2:= [6];    end;
          end
        else
          case aAnzNS of
            1: begin NI1:= [5]; NI2:= [4]; end;
            2: begin NI1:= [6]; NI2:= [5]; end;
            3: begin NI1:= [] ; NI2:= [6]; end;
          end
    end;
  if (aPrognose = pMSAQ) then
    begin
      if AlleDefizite
        then
          case aAnzNS of
            1: begin NI1:= [4..6]; NI2:= [3..6]; end;
            2: begin NI1:= [5..6]; NI2:= [4..6]; end;
            3: begin NI1:= [6];    NI2:= [5..6]; end;
            4: begin NI1:= [ ];    NI2:= [6];    end;
          end
        else
          case aAnzNS of
            1: begin NI1:= [4]; NI2:= [3]; end;
            2: begin NI1:= [5]; NI2:= [4]; end;
            3: begin NI1:= [6]; NI2:= [5]; end;
            4: begin NI1:= [ ]; NI2:= [6]; end;
          end
    end;
  if (NI1 <> []) or (NI2 <> []) then
    begin
      if (aPrognose = pHA9) or (aPrognose = pHA10)
        then
          begin
            Anz:= GetAnzMitNote(NI1,aFG,'');
            if Anz > 0
              then FKs:= SConcat(FKs,GetFKsMitNote(NI1,aFG,''),',',True,True);
          end
        else
          begin
            Anz:= GetAnzMitNote(NI1,aFG,'E') + GetAnzMitNote(NI2,aFG,'G') + GetAnzMitNote(NI1,aFG,'X');
            if Anz > 0 then
              begin
                FKs:= SConcat(FKs,GetFKsMitNote(NI1,aFG,'E'),',',True,True);
                FKs:= SConcat(FKs,GetFKsMitNote(NI2,aFG,'G'),',',True,True);
                FKs:= SConcat(FKs,GetFKsMitNote(NI1,aFG,'X'),',',True,True);
              end;
            if (aPrognose = pMSA) and (aFG=2) and (AlleDefizite or (aAnzNS=1)) then
            // in diesem Fall muss geprüft werden ob mindestens 2x"3" vorhanden ist, ansonsten die Defizite erhöhen bzw. ausweisen
              begin
                FG2_1_3_Anz:= GetAnzMitNote([1..3],2, 'X');
                // wenn die Anzahl der notwendigen 2x"3" nicht gegeben ist, wird die Anzahl der Defizite (1NS) entsprechend hochgesetzt
                if FG2_1_3_Anz < 2 then
                  begin
                    FKs:= SConcat(FKs,SInteger(2-FG2_1_3_Anz) + 'x"3"', ',', False, True);
                    Inc(Anz,2-FG2_1_3_Anz);
                  end;
              end;
          end;
    end;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.GetAnzFKsAusgleiche(var Anz: Integer; var FKs: String; aFG: Integer; aPrognose: tPrognose);
// gibt zu einem bestimmten Abschluss die Anzahl und die Ausgleichfächer für Fächergruppe aFG
// aFG=0 nicht möglich!
var
  NI1, NI2     : set of Byte;
  FG2_3_Anz    : Integer;
  FG2_3_Faecher: String;
  F            : Integer;
begin
  FKs:= '';
  Anz := 0;
  NI1:= [];
  NI2:= [];
  if (aPrognose = pMSA)  then begin NI1:= [1..3]; NI2:= [1..2]; end;
  if (aPrognose = pMSAQ) then begin NI1:= [1..2]; NI2:= [1]   ; end;
  if (NI1 <> []) and (NI2 <> []) then
    begin
      if aFG = 1 then Anz:= GetAnzMitNote(NI1,aFG,'E') + GetAnzMitNote(NI2,aFG,'G') + GetAnzMitNote(NI1,aFG,'X');
      if aFG = 2 then
        begin
          // MSA, FG2=2: In diesem Fall kommen noch die zusätzlichen "3" hinzu (2 sind Pflicht)
          if (aPrognose = pMSA) then
            begin
              // Noten "1" und "2" erhöhen schon einmal Ausgleich
              Inc(Anz,GetAnzMitNote([1..2],aFG,''));
              FG2_3_Anz:= GetAnzMitNote([3],  aFG,'X');
              // die überzähligen "3" zählen auch zu den Ausgleichsfächern
              if FG2_3_Anz > 2 then Inc(Anz,FG2_3_Anz-2);
            end;
          if (aPrognose = pMSAQ) then Anz:= GetAnzMitNote(NI1,aFG,'E') + GetAnzMitNote(NI2,aFG,'G') + GetAnzMitNote(NI1,aFG,'X');
        end;
      if Anz > 0 then
        begin
          if aFG = 1 then
            begin
              FKs:= SConcat(FKs,GetFKsMitNote(NI1,aFG,'E'),',',True,True);
              FKs:= SConcat(FKs,GetFKsMitNote(NI2,aFG,'G'),',',True,True);
              FKs:= SConcat(FKs,GetFKsMitNote(NI1,aFG,'X'),',',True,True);
            end;
          if aFG = 2 then
            begin
              // MSA, In diesem Fall kommen noch die zusätzlichen "3" hinzu (2 sind Pflicht)
              if (aPrognose = pMSA) then
                begin
                  // Noten "1" und "2" zählen schon einmal zu den Ausgleichfächern
                  FKs:= SConcat(FKs,GetFKsMitNote([1..2],aFG,''),',',True,True);
                  FG2_3_Faecher:= GetFKsMitNote([3],aFG,'X');
                  FG2_3_Anz    := GetAnzMitNote( [3],aFG,'X');
                  // die überzähligen "3" zählen auch zu den Ausgleichsfächern
                  if FG2_3_Anz > 2 then
                    for F:= 3 to FG2_3_Anz do FKs:= SConcat(FKs,NBetween(F,',',FG2_3_Faecher),',',True,True);
                end;
              if (aPrognose = pMSAQ) then
                begin
                  FKs:= SConcat(FKs,GetFKsMitNote(NI1,aFG,'E'),',',True,True);
                  FKs:= SConcat(FKs,GetFKsMitNote(NI2,aFG,'G'),',',True,True);
                  FKs:= SConcat(FKs,GetFKsMitNote(NI1,aFG,'X'),',',True,True);
                end;
            end;
        end;
    end;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.IsHA(var Ergebnis: String; var CheckNP: Boolean; Einzug: Integer = 1): Boolean;
var
  Offset, Bed         : String;
  FG1_Anz_5, FG1_Anz_6: Integer;
  FG2_Anz_5, FG2_Anz_6: Integer;
  FG2_Anz_5_6         : Integer;
  FG1_FKs_Def         : String;
  FG2_FKs_Def        : String;
begin
  Result  := False;
  OffSet  := Space(Einzug);
  Ergebnis:= '';

  FG1_Anz_5  := GetAnzMitNote([5]  ,1,'');
  FG1_Anz_6  := GetAnzMitNote([6]  ,1,'');
  FG2_Anz_5  := GetAnzMitNote([5]  ,2,'');
  FG2_Anz_6  := GetAnzMitNote([6]  ,2,'');
  FG2_Anz_5_6:= GetAnzMitNote([5,6],2,'');

  FG1_FKs_Def:= GetFKsMitNote([5,6],1,'');
  FG2_FKs_Def:= GetFKsMitNote([5,6],2,'');

  if FG1_FKs_Def <> '' then Ergebnis:= SConcat(Ergebnis,OffSet + SinPluConcat('- FG1: Defizit',FG1_FKs_Def), LF, False, True);
  if FG2_FKs_Def <> '' then Ergebnis:= SConcat(Ergebnis,OffSet + SinPluConcat('- FG2: Defizit',FG2_FKs_Def), LF, False, True);

// Kein Abschluss
  Bed:= '(FG1: 1x"6" o. FG2: 2x"6")';
  if (FG1_Anz_6 >= 1) or (FG2_Anz_6 >= 2) then
    begin
      Ergebnis:= SConcat(Ergebnis,OffSet + '- Kein Abschluss: '+ Bed, LF, False, True);
      CheckNP := False;
      Exit;
    end;
// Mindestanforderung
  Bed:= '(FG1: "4" u. FG2: "4")';
  if (FG1_Anz_5 = 0) and (FG2_Anz_5_6 = 0) then
    begin
      CheckNP := False;
      Result  := True;
      Ergebnis:= SConcat(Ergebnis,OffSet + '- Mindestanforderungen erfüllt: '+ Bed, LF, False, True);
      Exit;
    end;
// Erlaubte Defizite?
  case FG1_Anz_5 of
    0: begin
         Bed:= '(FG1: 0x"5"/"6" u. FG2: 2x"5" o. 1x"5" u. 1x"6")';
         if (FG2_Anz_5_6 <= 2) // erlaubte(s) Defizite
           then
             begin
               CheckNP := False;
               Ergebnis:= SConcat(Ergebnis,OffSet + '- Defizite erlaubt: ' + Bed, LF, False, True);
               Result  := True;
             end
           else // nicht erlaubte(s) Defizite
             begin
               CheckNP := (FG2_Anz_5 = 3) or ((FG2_Anz_5 = 2) and (FG2_Anz_6 = 1));
               Ergebnis:= SConcat(Ergebnis,OffSet + '- Defizite: zu viele: '  + Bed, LF, False, True);
               Result  := False;
               Exit;
             end;
       end;
    1: begin
         Bed:= '(FG1: 1x"5" u. FG2: 1x"5" o. 1x"6")';
         if (FG2_Anz_5_6 <= 1) // erlaubte(s) Defizite
           then
             begin
               CheckNP := False;
               Ergebnis:= SConcat(Ergebnis,OffSet + '- Defizite: erlaubt: ' + Bed, LF, False, True);
               Result:= True;
             end
           else // nicht erlaubte(s) Defizite
             begin
               CheckNP := (FG2_Anz_5 = 2) or ((FG2_Anz_5 = 1) and (FG2_Anz_6 = 1));
               Ergebnis:= SConcat(Ergebnis,OffSet + '- Defizite: zu viele: '  + Bed, LF, False, True);
               Exit;
             end;
       end;
    else // nicht erlaubte(s) Defizite
      begin
        Bed     := '(FG1: 2x"5")';
        CheckNP := (FG1_Anz_5 = 2);
        Ergebnis:= SConcat(Ergebnis,OffSet + '- Defizite: zu viele: '  + Bed, LF, False, True); Exit; end;
      end;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.CheckHA9: Boolean;
var
  DefFKs          : String;
  DefAnz          : Integer;
  CheckNP         : Boolean;
  NPFach          : String;
  ProgErgebnis    : String;
  F, FI, FGNoteBak: Integer;
begin
  Result:= False;
  InitFGNoten;
  FNPFaecherHA9:= '';
  AddText('');
  AddText('Prüfe HA9:');
  AddText2(FBlockBegin);
  AddText2(' - Fächergruppen:');
  if not SetFaecherGruppen(pHA9,ProgErgebnis) then begin AddText2(ProgErgebnis); Exit; end;
  if ProgErgebnis <> '' then AddText2( '  - ' + ProgErgebnis);
  AddText2('  - FG1: ' + GetFKsAusFG(1, pHA9));
  AddText2('  - FG2: ' + GetFKsAusFG(2, pHA9));
  if IsHA(ProgErgebnis,CheckNP,1)
    then
      begin
        AddText2(ProgErgebnis);
        AddText2(FBlockEnd);
        AddText(FLC + ' HA 9: APO-SI §40 (3)');
        Result:= True;
      end
    else
      begin
        AddText2(ProgErgebnis);
        if CheckNP then
          begin
            AddText2(' - kein HA9');
            AddText2(' - Nachprüfungsmöglichkeiten:');
            DefFKs:= GetFKsMitNote([5],0,'');
            DefAnz := GetAnzMitNote( [5],0,'');
            AddText3('  - Fächer: ' + DefFKs);
            for F:= 1 to DefAnz do
              begin
                NPFach:= NBetween(F,',',DefFKs);
                FI:= GetFachIndexByFK(NPFach);
                if FI <> -1 then with FFaecher[FI] do
                  begin
                    AddText3('  - Nachprüfung in ' + NPFach + '(' + Fach + '): ' + Sinteger(FGNote) + ' -> ' + Sinteger(FGNote-1));
                    FGNoteBak:= FGNote;
                    DecNote(FGNote);
                    if IsHA(ProgErgebnis, CheckNP, 3)
                      then
                        begin
                          AddText3(ProgErgebnis);
                          FNPFaecherHA9:= SConcat(FNPFaecherHA9, NPFach, ',',True,True);
                          AddText3('  - HA9 !');
                        end
                      else begin AddText3(ProgErgebnis); AddText2('  - kein HA9 !'); end;
                    FGNote:= FGNoteBak;
                  end;
              end;
          end;
        AddText2(FBlockEnd);
        if FNPFaecherHA9 <> ''
          then AddText(FLC + ' kein HA9 - Nachprüfungsmöglichkeite(en) in ' + FNPFaecherHA9)
          else AddText(FLC + ' kein HA9 - KEINE Nachprüfungsmöglichkeiten!');
      end;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.CheckHA10: Boolean;
var
  DefFKs          : String;
  DefAnz          : Integer;
  NPFach          : String;
  CheckNP         : Boolean;
  ProgErgebnis    : String;
  F, FI, FGNoteBak: Integer;
begin
  Result:= False;
  InitFGNoten;
  FNPFaecherHA10:= '';
  AddText('');
  AddText('Prüfe HA10:');
  AddText2(FBlockBegin);
  if not IsLBNotenVorhanden(ProgErgebnis) then
    begin
      AddText2(FBlockEnd);
      AddText(ProgErgebnis);
      Exit;
    end;

  AddText2(' - Fächergruppen:');
  if not SetFaecherGruppen(pHA10,ProgErgebnis) then begin AddText2(ProgErgebnis); Exit; end;

  if ProgErgebnis <> '' then AddText2( '  - ' + ProgErgebnis);
  AddText2('  - FG1: ' + GetFKsAusFG(1, pHA10));
  AddText2('  - FG2: ' + GetFKsAusFG(2, pHA10));
  if IsHA(ProgErgebnis, CheckNP, 1)
    then
      begin
        AddText2(ProgErgebnis);
        AddText2(FBlockEnd);
        AddText(FLC + ' HA10: APO-SI §41 (1)');
        Result:= True;
      end
    else
      begin
        AddText2(ProgErgebnis);
        if CheckNP then
          begin
            AddText2(' - kein HA10');
            AddText3(' - Nachprüfungsmöglichkeiten:');
            DefFKs:= GetFKsMitNote([5],0,'');
            DefAnz := GetAnzMitNote([5],0,'');
            AddText3('  - Fächer: ' + DefFKs);
            for F:= 1 to DefAnz do
              begin
                NPFach:= NBetween(F,',',DefFKs);
                if (NPFach = 'D') or (NPFach = 'E') or (NPFach = 'M') then Continue;
                FI:= GetFachIndexByFK(NPFach);
                if FI <> -1 then with FFaecher[FI] do
                  begin
                    AddText3('  - Nachprüfung in ' + NPFach + '(' + Fach + '): ' + Sinteger(FGNote) + ' -> ' + Sinteger(FGNote-1));
                    FGNoteBak:= FGNote;
                    DecNote(FGNote);
                    if IsHA(ProgErgebnis, CheckNP, 3)
                      then
                        begin
                          AddText3(ProgErgebnis);
                          FNPFaecherHA10:= SConcat(FNPFaecherHA10,NPFach,',',True,True);
                          AddText3('  - HA10 !');
                        end
                      else begin AddText3(ProgErgebnis); AddText3('  - kein HA10 !'); end;
                    FGNote:= FGNoteBak;
                 end;
              end;
          end;
        AddText2(FBlockEnd);
        if FNPFaecherHA10 <> ''
          then AddText(FLC + ' kein HA10 - Nachprüfungsmöglichkeite(en) in ' + FNPFaecherHA10)
          else AddText(FLC + ' kein HA10 - KEINE Nachprüfungsmöglichkeiten!');
      end;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.IsMSA(var Ergebnis: String; var CheckAusgleich: Boolean; Einzug: Integer = 1): Boolean;
var
  Offset, Bed    : String;
  NI1, NI2       : set of Byte;
  FG1_Anz_Def_1NS: Integer;
  FG1_Anz_Def_2NS: Integer;
  FG2_Anz_Def_1NS: Integer;
  FG2_Anz_1_3    : Integer;
  E_Niv_Anz      : Integer;
  NW_E_Niv_Def   : Boolean;
  FG1_FKs_Def    : String;
  FG2_FKs_Def    : String;

begin
  OffSet        := Space(Einzug);
  Ergebnis      := '';
  CheckAusgleich:= False;

  E_Niv_Anz   := GetAnzMitNiv(0,'E');
  NW_E_Niv_Def:= ((GetFachNiveau('Ch') = 'E') and (GetFachFGNote('Ch') > 4)) or ((GetFachNiveau('Ph') = 'E') and (GetFachFGNote('Ph') > 4));

  NI1:= [5,6]; NI2:= [4,5,6];
  FG1_Anz_Def_1NS:= GetAnzMitNote(NI1,1, 'E') + GetAnzMitNote(NI2,1, 'G') + GetAnzMitNote(NI1,1, 'X');
  NI1:= [6];   NI2:= [5,6];
  FG1_Anz_Def_2NS:= GetAnzMitNote(NI1,1, 'E') + GetAnzMitNote(NI2,1, 'G') + GetAnzMitNote(NI1,1, 'X');

  NI1:= [5,6]; NI2:= [4,5,6];
  FG2_Anz_Def_1NS:= GetAnzMitNote(NI1,2, 'E') + GetAnzMitNote(NI2,2, 'G') + GetAnzMitNote(NI1,2, 'X');
  NI1:= [6];   NI2:= [5,6];

  FG2_Anz_1_3:= GetAnzMitNote([1..3],2, 'X');

  NI1:= [5,6]; NI2:= [4..6]; FG1_FKs_Def:= '';
  FG1_FKs_Def:= SConcat(FG1_FKs_Def,GetFKsMitNote(NI1,1,'E'),',',True,True);
  FG1_FKs_Def:= SConcat(FG1_FKs_Def,GetFKsMitNote(NI2,1,'G'),',',True,True);
  FG1_FKs_Def:= SConcat(FG1_FKs_Def,GetFKsMitNote(NI1,1,'X'),',',True,True);

  NI1:= [5,6]; NI2:= [4..6]; FG2_FKs_Def:= '';
  FG2_FKs_Def:= SConcat(FG2_FKs_Def,GetFKsMitNote(NI1,2,'E'),',',True,True);
  FG2_FKs_Def:= SConcat(FG2_FKs_Def,GetFKsMitNote(NI2,2,'G'),',',True,True);
  FG2_FKs_Def:= SConcat(FG2_FKs_Def,GetFKsMitNote(NI1,2,'X'),',',True,True);

  if FG1_FKs_Def <> '' then Ergebnis:= SConcat(Ergebnis,OffSet + SinPluConcat('- FG1: Defizit', FG1_FKs_Def), LF, False, True);
  if FG2_FKs_Def <> '' then Ergebnis:= SConcat(Ergebnis,OffSet + SinPluConcat('- FG2: Defizit', FG2_FKs_Def), LF, False, True);

  // Mindestanforderungen
  Bed:= '(2xE)';
  if (E_Niv_Anz < 2) then
    begin
      CheckAusgleich:= False;
      Result        := False;
      Ergebnis      := SConcat(Ergebnis,OffSet + '- Mindestanforderungen NICHT erfüllt: '+ Bed, LF, False, True);
      Exit;
    end;
//  Bed:= '(2xE u. ohne Ch-E/Ph-E-Defizit)';
//  if (E_Niv_Anz = 2) and (NW_E_Niv_Def) then
//    begin
//      CheckAusgleich:= False;
//      Result        := False;
//      Ergebnis      := SConcat(Ergebnis,OffSet + '- Mindestanforderungen NICHT erfüllt: '+ Bed, LF, False, True);
//      Exit;
//    end;
  Bed:= '(FG2: 2x"3")';
  if (FG2_Anz_1_3 < 2) then
    begin
      CheckAusgleich:= True;
      Result        := False;
      Ergebnis      := SConcat(Ergebnis,OffSet + '- Mindestanforderungen NICHT erfüllt: '+ Bed, LF, False, True);
      Exit;
    end;
  Bed:= '(2xE) u. (FG1: E:"4",G:"3",WP:"4") u. (FG2: E:"4",G:"3", so.: 2x"3","4")';
  if (FG1_Anz_Def_1NS = 0) and (FG2_Anz_Def_1NS = 0) and (FG2_Anz_1_3 >= 2) then
    begin
      CheckAusgleich:= False;
      Result        := True;
      Ergebnis      := SConcat(Ergebnis,OffSet + '- Mindestanforderungen erfüllt: '+ Bed, LF, False, True);
      Exit;
    end;
  // Kein Abschluss
  Bed:= '(FG1: 2x1NS o. 1x2NS) o. (FG2: 2x2NS)';
  if (FG1_Anz_Def_1NS >= 2) or (FG1_Anz_Def_2NS >= 1) or (FG1_Anz_Def_2NS >= 2) then
    begin
      CheckAusgleich:= False;
      Result        := False;
      Ergebnis      := SConcat(Ergebnis,OffSet + '- Kein Abschluss: '+ Bed, LF, False, True);
      Exit;
    end;

  CheckAusgleich:= True;
  Result        := False;
  Ergebnis      := SConcat(Ergebnis,OffSet + '- Mindestanforderungen NICHT erfüllt!', LF, False, True);
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.CheckMSAAusgleich(var ProgErgebnis: String; var CheckNP: Boolean; const NPFach: String; Einzug: Integer = 1): Boolean;
// wenn NPFach <> '', werden Nachprüfungsmöglichkeiten getestet: NPFach muss aus den Ausgleichen eliminiert werden
var
  Offset                  : String;
  EZ                      : Integer;
  FG1_Def_Anz             : Integer;
  FG1_Aus_Anz             : Integer;
  FG1_1NS_Anz             : Integer;
  FG1_1NS_Faecher         : String;
  FG1_2NS_Anz             : Integer;
  FG1_2NS_Faecher         : String;
  FG1_Def_Faecher         : String;
  FG1_Aus_Faecher         : String;

  FG2_Def_Anz             : Integer;
  FG2_Aus_Anz             : Integer;
  FG2_1NS_Anz             : Integer;
  FG2_1NS_Faecher         : String;
  FG2_2NS_Anz             : Integer;
  FG2_2NS_Faecher         : String;
  FG2_Def_Faecher         : String;
  FG2_Aus_Faecher         : String;

  Def_xNS_Anz             : Integer;
  Def_xNS_Faecher         : String;

  FG1_Ausgleich           : Boolean; // in FG1 wird ein Ausgleich angewendet
  FG2_Ausgleich           : Boolean; // in FG2 wird ein Ausgleich angewendet

begin
  Result       := False;
  CheckNP      := False;
  OffSet       := Space(Einzug);
  ProgErgebnis := '';
  FG1_Ausgleich:= False;
  FG2_Ausgleich:= False;

// prüfen ob Unterschreitungen von 3 oder 4 Notenstufen)
  GetAnzFKsDef(Def_xNS_Anz,Def_xNS_Faecher,0,pMSA,3,True);
  if (Def_xNS_Anz > 0) then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis,OffSet + '- Unterschreitung um mindestens 3 Notenstufen ('+Def_xNS_Faecher+')' , LF, False, True);
      CheckNP     := False;
      Result      := False;
      Exit;
    end;

//  >>>>>>>>>> Betrachtung FG1 <<<<<<<<<<
  GetAnzFKsDef  (FG1_Def_Anz, FG1_Def_Faecher, 1, pMSA, 1,True);
  GetAnzFKsDef  (FG1_1NS_Anz, FG1_1NS_Faecher, 1, pMSA, 1,False);
  GetAnzFKsDef  (FG1_2NS_Anz, FG1_2NS_Faecher, 1, pMSA, 2,False);
  GetAnzFKsAusgleiche(FG1_Aus_Anz, FG1_Aus_Faecher, 1, pMSA);

  if (NPFach <> '') and (IsFKInFachListe(NPFach,FG1_Aus_Faecher)) then
    begin
      // NPFach muss aus den Ausgleichen eliminiert werden
      Dec(FG1_Aus_Anz);
      FG1_Aus_Faecher:= LoescheFKAusFachListe(NPFach, FG1_Aus_Faecher);
    end;

  if FG1_Def_Faecher <> '' then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis,OffSet + SinPluConcat('- FG1: Defizit', FG1_Def_Faecher), LF, False, True);
      if (FG1_Def_Anz > 0) and (FG1_Aus_Faecher <> '') then ProgErgebnis:= SConcat(ProgErgebnis,SinPluConcat('Ausgleich', FG1_Aus_Faecher), ' / ', False, True);
    end;

// FG1: Kein MSA und keine NP, wenn Unterschreitung um eine Notenstufe in zwei Fächern oder um zwei Notenstufen in einem Fach
  if (FG1_1NS_Anz > 1) then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis,'mindestens 2 Defizite !' , ' -> ', False, True);
      CheckNP     := True;
      Result      := False;
      Exit;
    end;
  if (FG1_2NS_Anz > 0) then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis,'Unterschreitung um mindestens 2 Notenstufen !' , ' -> ' , False, True);
      CheckNP     := False;
      Result      := False;
      Exit;
    end;

  if (FG1_1NS_Anz = 1) and (FG1_Aus_Anz > 0) then FG1_Ausgleich:= True;
  if (FG1_1NS_Anz = 0)                       then FG1_Ausgleich:= False;

  if (FG1_1NS_Anz = 1) and (FG1_Aus_Anz = 0) then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis, 'Kein Ausgleich für Defizit !', ' -> ', False, True);
      CheckNP     := True;
      Result      := False;
      Exit;
    end;

//  >>>>>>>>>> Betrachtung FG2 <<<<<<<<<<
  GetAnzFKsDef  (FG2_Def_Anz, FG2_Def_Faecher, 2, pMSA, 1, True);
  GetAnzFKsDef  (FG2_1NS_Anz, FG2_1NS_Faecher, 2, pMSA, 1, False);
  GetAnzFKsDef  (FG2_2NS_Anz, FG2_2NS_Faecher, 2, pMSA, 2, False);
  GetAnzFKsAusgleiche(FG2_Aus_Anz, FG2_Aus_Faecher, 2, pMSA);
  if (NPFach <> '') and (IsFKInFachListe(NPFach,FG2_Aus_Faecher)) then
    begin
      // NPFach muss aus den Ausgleichen eliminiert werden
      Dec(FG2_Aus_Anz);
      FG2_Aus_Faecher:= LoescheFKAusFachListe(NPFach, FG2_Aus_Faecher);
    end;

  EZ:= 0;
  if FG2_Def_Faecher <> '' then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis,OffSet + SinPluConcat('- FG2: Defizit', FG2_Def_Faecher), LF, False, True);
      if (FG2_Def_Anz > 0) and (FG2_Aus_Faecher <> '') then ProgErgebnis:= SConcat(ProgErgebnis,SinPluConcat('Ausgleich', FG2_Aus_Faecher), ' / ', False, True);
      EZ:= 1;
    end;

// prüfen ob zu viele Defizite (2 x 1NS oder (1 x 1NS und 1 x 2NS) ist okay)
// FG2: Kein MSA, wenn Unterschreitung um zwei Notenstufen in zwei Fächern
  if (FG2_2NS_Anz >= 2) then
    begin
     ProgErgebnis:= SConcat(ProgErgebnis,'zu viele Defizite (' + FG2_Def_Faecher + ') 2x2NS!', ' -> ', False, True);
      CheckNP     := False;
      Result      := False;
      Exit;
    end;

  if (FG2_2NS_Anz >= 1)
    then // 1 x 2NS ist ohne Ausgleich okay
      begin
        ProgErgebnis:= SConcat(ProgErgebnis,OffSet + '- FG2: 1 Defizit (2NS) (' + FG2_2NS_Faecher + ') bleibt unberücksichtigt!', LF, False, True);
        Dec(FG2_2NS_Anz,1);
        Dec(FG2_Def_Anz,1);
        EZ:= 2;
      end
    else
      begin
        if (FG2_1NS_Anz >= 1)
          then // 1 x 1NS ist ohne Ausgleich okay
            begin
              ProgErgebnis:= SConcat(ProgErgebnis,OffSet + '- FG2: 1 Defizit (1NS) (' + FG2_1NS_Faecher + ') bleibt unberücksichtigt!', LF, False, True);
              Dec(FG2_1NS_Anz,1);
              Dec(FG2_Def_Anz,1);
              EZ:= 2;
            end
      end;

  if (FG2_Def_Anz >= 1) then // prüfen ob ein Ausgleich in FG2 möglich ist
    if (FG2_Def_Anz = 1) and ((FG2_Aus_Anz > 0) or ((FG1_Aus_Anz > 0) and (not FG1_Ausgleich)))
      then
        begin
          // 1 Defizit kann ausgeglichen werden!
          if EZ=1 then
            begin
              if (FG2_Aus_Anz > 0)
                then ProgErgebnis:= SConcat(ProgErgebnis, 'Ausgleich (FG2) möglich!', ' -> ', False, True)
                else ProgErgebnis:= SConcat(ProgErgebnis, 'Ausgleich (FG1) möglich!', ' -> ', False, True);
            end;
          if EZ <> 1 then
            begin
              if (FG2_Aus_Anz > 0)
                then ProgErgebnis:= SConcat(ProgErgebnis,OffSet + '- FG2: für 1 Defizit (' + FG2_Def_Faecher + ') Ausgleich (FG2) möglich!', LF, False, True)
                else ProgErgebnis:= SConcat(ProgErgebnis,OffSet + '- FG2: für 1 Defizit (' + FG2_Def_Faecher + ') Ausgleich (FG1) möglich!', LF, False, True);
            end;
          FG2_Ausgleich:= True;
        end
      else
        begin
          // Ausgleiche in FG2 nicht möglich!
          ProgErgebnis:= SConcat(ProgErgebnis,'Ausgleich NICHT möglich!', ' -> ', False, True);
          CheckNP     := True;
          Result      := False;
          Exit;
        end;
  if (FG1_Ausgleich xor FG2_Ausgleich) then Result:= True;  // Ausgleich ist möglich!
  if (FG1_Ausgleich and FG2_Ausgleich) then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis,OffSet + '- Ausgleich in FG1 UND FG2 NICHT möglich!', LF, False, True);
      CheckNP     := True;
      Result      := False;
    end;
  if (FG1_Def_Anz = 0) and (FG2_Def_Anz = 0) then Result:= True; // es muss nichts ausgeglichen werden, da die Defizite tolerierbar sind
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.CheckMSA: Boolean;
var
  ProgErgebnis  : String;
  CheckNP       : Boolean;
  CheckAusgleich: Boolean;
  F             : Integer;
  DefFKs        : String;
  DefAnz        : Integer;
(* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  *)
procedure TesteNachPruefung(NPFach: String; var NPFaecher, Ergebnis: String);
var
  FI, FGNoteBak : Integer;
  CheckNP       : Boolean;
  CheckAusgleich: Boolean;
begin
  FI:= GetFachIndexByFK(NPFach);
  if FI <> -1 then with FFaecher[FI] do
    begin
      if FGNote <> 5 then Exit; // in MSA kommen nut Fächer mit Note "5" als Nachprüfungsfach in Frage
      AddText3('  - Nachprüfung in ' + NPFach + '(' + Fach + '): ' + Sinteger(FGNote) + ' -> ' + Sinteger(FGNote-1));
      FGNoteBak:= FGNote;
      DecNote(FGNote);
      if IsMSA(Ergebnis,CheckAusgleich,3)
        then
          begin
            AddText3(Ergebnis);
            NPFaecher:= SConcat(NPFaecher, NPFach, ',',True,True);
            AddText3('   - MSA (FOR) !');
          end
        else
          begin
            if (CheckAusgleich) and (CheckMSAAusgleich(Ergebnis, CheckNP,NPFach,3))
              then
                begin
                  AddText3(Ergebnis);
                  NPFaecher:= SConcat(NPFaecher, NPFach, ',',True,True);
                  AddText3('   - MSA (FOR) - wegen Ausgleichsregelung!');
                end
              else
                begin
                  AddText3(Ergebnis);
                  AddText2('   - kein MSA (FOR) !');
                end;
          end;
      FGNote:= FGNoteBak;
    end;
end;
(* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  *)
begin
  Result:= False;
  InitFGNoten;
  FNPFaecherMSA:= '';
  AddText('');
  AddText('Prüfe MSA:');
  AddText2(FBlockBegin);
  AddText2(' - Fächergruppen:');
  if not SetFaecherGruppen(pMSA,ProgErgebnis) then begin AddText2(ProgErgebnis); Exit; end;

  if ProgErgebnis <> '' then AddText2('  - ' + ProgErgebnis);
  AddText2('  - FG1: ' + GetFKsAusFG(1, pMSA));
  AddText2('  - FG2: ' + GetFKsAusFG(2, pMSA));

  if IsMSA(ProgErgebnis,CheckAusgleich,1)
    then
      begin
        AddText2(ProgErgebnis);
        AddText2(FBlockEnd);
        AddText(FLC + ' MSA (FOR): APO-SI §42 (3)');
        Result:= True;
      end
    else
      begin
        if not CheckAusgleich
          then
            begin
              AddText2(ProgErgebnis);
              AddText2(FBlockEnd);
              AddText(FLC + ' kein MSA (FOR) ! - KEINE Nachprüfungsmöglichkeiten!')
            end
          else
            begin
              AddText2(ProgErgebnis);
              AddText2(' - kein MSA (FOR)');
              AddText2(' - Ausgleichsprüfung:');
              if CheckMSAAusgleich(ProgErgebnis, CheckNP,'',2)
                then
                  begin
                    AddText2(ProgErgebnis);
                    AddText2(FBlockEnd);
                    AddText(FLC + ' MSA (FOR): APO-SI §42 (3) - wegen Ausgleichsregelung!');
                    Result:= True;
                  end
                else
                  begin
                    Result:= False;
                    AddText2(ProgErgebnis);
                    if not CheckNP
                      then
                        begin
                          AddText2(FBlockEnd);
                          AddText(FLC + ' kein MSA (FOR) - KEINE Ausgleichsregelung! / KEINE Nachprüfungsmöglichkeiten!');
                        end
                      else
                        begin
                          AddText2(' - kein MSA (FOR) - KEINE Ausgleichsregelung');
                          AddText2(' - Nachprüfungsmöglichkeiten:');
                          // ist WP-Note "5" ? wenn ja Nachprüfungsmöglichkeit prüfen...
                          TesteNachPruefung('WP',FNPFaecherMSA, ProgErgebnis);
                          // Defizite (nur Note=5) in FG2 prüfen...
                          DefFKs:= GetFKsMitNote([5],2,'');
                          DefAnz := GetAnzMitNote([5],2,'');
                          if DefAnz > 0 then AddText2('  - Fächer: ' + DefFKs);
                          for F:= 1 to DefAnz do TesteNachPruefung(NBetween(F,',',DefFKs),FNPFaecherMSA, ProgErgebnis);
                          AddText3(FBlockEnd);
                          if FNPFaecherMSA <> ''
                            then AddText(FLC + ' kein MSA (FOR) - Nachprüfungsmöglichkeite(en) in ' + FNPFaecherMSA)
                            else AddText(FLC + ' kein MSA (FOR) - KEINE Nachprüfungsmöglichkeiten!');
                        end;
                  end;
            end;
      end;
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.IsMSAQ(var Ergebnis: String; var CheckAusgleich: Boolean; Einzug: Integer = 1): Boolean;
var
  Offset, Bed    : String;
  NI1, NI2       : set of Byte;
  FG1_Anz_Def_1NS: Integer;
  FG1_Anz_Def_2NS: Integer;
  FG2_Anz_Def_1NS: Integer;
  FG2_Anz_Def_2NS: Integer;
  E_Niv_Anz      : Integer;
  FG1_FKs_Def    : String;
  FG2_FKs_Def    : String;

begin
  OffSet        := Space(Einzug);
  Ergebnis      := '';
  CheckAusgleich:= False;

  E_Niv_Anz   := GetAnzMitNiv(0,'E');

  NI1:= [4,5,6]; NI2:= [3,4,5,6];
  FG1_Anz_Def_1NS:= GetAnzMitNote(NI1,1, 'E') + GetAnzMitNote(NI2,1, 'G') + GetAnzMitNote(NI1,1, 'X');
  NI1:= [5,6];   NI2:= [4,5,6];
  FG1_Anz_Def_2NS:= GetAnzMitNote(NI1,1, 'E') + GetAnzMitNote(NI2,1, 'G') + GetAnzMitNote(NI1,1, 'X');

  NI1:= [4,5,6]; NI2:= [3,4,5,6];
  FG2_Anz_Def_1NS:= GetAnzMitNote(NI1,2, 'E') + GetAnzMitNote(NI2,2, 'G') + GetAnzMitNote(NI1,2, 'X');
  NI1:= [5,6];   NI2:= [4,5,6];
  FG2_Anz_Def_2NS:= GetAnzMitNote(NI1,2, 'E') + GetAnzMitNote(NI2,2, 'G') + GetAnzMitNote(NI1,2, 'X');

  NI1:= [4..6]; NI2:= [3..6]; FG1_FKs_Def:= '';
  FG1_FKs_Def:= SConcat(FG1_FKs_Def,GetFKsMitNote(NI1,1,'E'),',',True,True);
  FG1_FKs_Def:= SConcat(FG1_FKs_Def,GetFKsMitNote(NI2,1,'G'),',',True,True);
  FG1_FKs_Def:= SConcat(FG1_FKs_Def,GetFKsMitNote(NI1,1,'X'),',',True,True);

  NI1:= [4..6]; NI2:= [3..6]; FG2_FKs_Def:= '';
  FG2_FKs_Def:= SConcat(FG2_FKs_Def,GetFKsMitNote(NI1,2,'E'),',',True,True);
  FG2_FKs_Def:= SConcat(FG2_FKs_Def,GetFKsMitNote(NI2,2,'G'),',',True,True);
  FG2_FKs_Def:= SConcat(FG2_FKs_Def,GetFKsMitNote(NI1,2,'X'),',',True,True);

  if FG1_FKs_Def <> '' then Ergebnis:= SConcat(Ergebnis,OffSet + SinPluConcat('- FG1: Defizit', FG1_FKs_Def), LF, False, True);
  if FG2_FKs_Def <> '' then Ergebnis:= SConcat(Ergebnis,OffSet + SinPluConcat('- FG2: Defizit', FG2_FKs_Def), LF, False, True);

// Mindestanforderung
  Bed:= '(3xE)';
  if (E_Niv_Anz < 3) then
    begin
      CheckAusgleich:= False;
      Result        := False;
      Ergebnis      := SConcat(Ergebnis,OffSet + '- Mindestanforderungen NICHT erfüllt: '+ Bed, LF, False, True);
      Exit;
    end;
  Bed:= '(3xE) u. (FG1: E:"3",G:"2",WP:"3") u. (FG2: E:"3",G:"2", so.:"3")';
  if (E_Niv_Anz >= 3) and (FG1_Anz_Def_1NS = 0) and (FG2_Anz_Def_1NS = 0) then
    begin
      CheckAusgleich:= False;
      Result        := True;
      Ergebnis      := SConcat(Ergebnis,OffSet + '- Mindestanforderungen erfüllt: '+ Bed, LF, False, True);
      Exit;
    end;
  // Kein Abschluss
  Bed:= '(FG1: 2x1NS o. 1x2NS) o. (FG2: 2x2NS)';
  if (FG1_Anz_Def_1NS >= 2) or (FG1_Anz_Def_2NS >= 1) or (FG2_Anz_Def_2NS >= 2) then
    begin
      CheckAusgleich:= False;
      Result        := False;
      Ergebnis      := SConcat(Ergebnis,OffSet + '- Kein Abschluss: '+ Bed, LF, False, True);
      Exit;
    end;

  CheckAusgleich:= True;
  Result        := False;
  Ergebnis      := SConcat(Ergebnis,OffSet + '- Mindestanforderungen NICHT erfüllt!', LF, False, True);
end;
(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.CheckMSAQAusgleich(var ProgErgebnis: String; var CheckNP: Boolean; const NPFach: String; Einzug: Integer = 1): Boolean;
// wenn NPFach <> '', werden Nachprüfungsmöglichkeiten getestet: NPFach muss aus den Ausgleichen eliminiert werden
var
  Offset                  : String;

  FG1_Def_Anz             : Integer;
  FG1_Aus_Anz             : Integer;
  FG1_1NS_Anz             : Integer;
  FG1_1NS_Faecher         : String;
  FG1_2NS_Anz             : Integer;
  FG1_2NS_Faecher         : String;
  FG1_Def_Faecher         : String;
  FG1_Aus_Faecher         : String;

  FG2_Def_Anz             : Integer;
  FG2_Aus_Anz             : Integer;
  FG2_1NS_Anz             : Integer;
  FG2_1NS_Faecher         : String;
  FG2_2NS_Anz             : Integer;
  FG2_2NS_Faecher         : String;
  FG2_Def_Faecher         : String;
  FG2_Aus_Faecher         : String;

  Def_xNS_Anz             : Integer;
  Def_xNS_Faecher         : String;

  FG1_Ausgleich           : Boolean; // in FG1 wird ein Ausgleich angewendet
  FG2_Ausgleich           : Boolean; // in FG2 wird ein Ausgleich angewendet
begin
  Result       := False;
  CheckNP      := False;
  OffSet       := Space(Einzug);
  ProgErgebnis := '';
  FG1_Ausgleich:= False;

// prüfen ob Unterschreitungen von 3 oder 4 Notenstufen)
  GetAnzFKsDef(Def_xNS_Anz,Def_xNS_Faecher,0,pMSAQ,3, True);
  if (Def_xNS_Anz > 0) then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis,OffSet + '- Unterschreitung um mindestens 3 Notenstufen ('+Def_xNS_Faecher+')' , LF, False, True);
      CheckNP     := False;
      Result      := False;
      Exit;
    end;
//  >>>>>>>>>> Betrachtung FG1 <<<<<<<<<<
  GetAnzFKsDef  (FG1_Def_Anz, FG1_Def_Faecher, 1, pMSAQ, 1, True);
  GetAnzFKsDef  (FG1_1NS_Anz, FG1_1NS_Faecher, 1, pMSAQ, 1, False);
  GetAnzFKsDef  (FG1_2NS_Anz, FG1_2NS_Faecher, 1, pMSAQ, 2, False);
  GetAnzFKsAusgleiche(FG1_Aus_Anz, FG1_Aus_Faecher, 1, pMSAQ);
  if (NPFach <> '') and (IsFKInFachListe(NPFach,FG1_Aus_Faecher)) then
    begin
      // NPFach muss aus den Ausgleichen eliminiert werden
      Dec(FG1_Aus_Anz);
      FG1_Aus_Faecher:= LoescheFKAusFachListe(NPFach, FG1_Aus_Faecher);
    end;

  if FG1_Def_Faecher <> '' then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis,OffSet + SinPluConcat('- FG1: Defizit', FG1_Def_Faecher), LF, False, True);
      if (FG1_Def_Anz > 0) and (FG1_Aus_Faecher <> '') then ProgErgebnis:= SConcat(ProgErgebnis,SinPluConcat('Ausgleich', FG1_Aus_Faecher), ' / ', False, True);
    end;

// FG1: Kein MSAQ und keine NP, wenn Unterschreitung um eine Notenstufe in zwei Fächern oder um zwei Notenstufen in einem Fach
  if (FG1_1NS_Anz > 1) then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis,'mindestens 2 Defizite !' , ' -> ', False, True);
      CheckNP     := False;
      Result      := False;
      Exit;
    end;
  if (FG1_2NS_Anz > 0) then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis,'Unterschreitung um mindestens 2 Notenstufen !' , ' -> ', False, True);
      CheckNP     := False;
      Result      := False;
      Exit;
    end;

  if (FG1_1NS_Anz = 1) and (FG1_Aus_Anz > 0) then FG1_Ausgleich:= True;
  if (FG1_1NS_Anz = 0)                       then FG1_Ausgleich:= False;

  if (FG1_Def_Anz = 1) and (FG1_Aus_Anz = 0) then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis,'Kein Ausgleich !', ' -> ', False, True);
      CheckNP     := GetFachFGNote('WP') = 4;
      Result      := False;
      Exit;
    end;
  if (FG1_Def_Anz = 1) and (FG1_Aus_Anz > 0) then Dec(FG1_Aus_Anz);

//  >>>>>>>>>> Betrachtung FG2 <<<<<<<<<<
  GetAnzFKsDef  (FG2_Def_Anz, FG2_Def_Faecher, 2, pMSAQ, 1, True);
  GetAnzFKsDef  (FG2_1NS_Anz, FG2_1NS_Faecher, 2, pMSAQ, 1, False);
  GetAnzFKsDef  (FG2_2NS_Anz, FG2_2NS_Faecher, 2, pMSAQ, 2, False);
  GetAnzFKsAusgleiche(FG2_Aus_Anz, FG2_Aus_Faecher, 2, pMSAQ);
  if (NPFach <> '') and (IsFKInFachListe(NPFach,FG2_Aus_Faecher)) then
    begin
      // NPFach muss aus den Ausgleichen eliminiert werden
      Dec(FG2_Aus_Anz);
      FG2_Aus_Faecher:= LoescheFKAusFachListe(NPFach, FG2_Aus_Faecher);
    end;

  if FG2_Def_Faecher <> '' then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis,OffSet + SinPluConcat('- FG2: Defizit', FG2_Def_Faecher), LF, False, True);
      if (FG2_Def_Anz > 0) and (FG2_Aus_Faecher <> '') then ProgErgebnis:= SConcat(ProgErgebnis,SinPluConcat('Ausgleich', FG2_Aus_Faecher), ' / ', False, True);
    end;

// FG2: Mögliche Defizite: Entweder (2 x "4" und 1 x "5") oder (3 x "4") jeweils mit gleicher Anzahl an Ausgleichsfächern
  if (FG2_1NS_Anz + FG2_2NS_Anz) > 3  then
    begin
      ProgErgebnis:= SConcat(ProgErgebnis,'zu viele Defizite: (2x"4" u. 1x"5") o. 3x"4" !', ' -> ', False, True);
      CheckNP     := False;
      Result      := False;
      Exit;
    end;

  if (FG2_1NS_Anz + FG2_2NS_Anz) > 0
    then
      begin
        FG2_Ausgleich:= True;
        if ((FG2_Aus_Anz + FG1_Aus_Anz) < (FG2_1NS_Anz + FG2_2NS_Anz)) then
          begin
            ProgErgebnis:= SConcat(ProgErgebnis,'Ausgleiche reichen nicht aus!', ' -> ', False, True);
            CheckNP     := True;
            Result      := False;
            Exit;
          end;
        if (FG1_Aus_Anz > 0) and (FG2_Aus_Anz < FG2_1NS_Anz + FG2_2NS_Anz) // Ausgleich durch FG1
          then ProgErgebnis:= SConcat(ProgErgebnis,SinPluConcat('FG1-Ausgleich', FG1_Aus_Faecher), ' / ', False, True);
      end
    else FG2_Ausgleich:= False;
  if (FG1_Ausgleich or FG2_Ausgleich) then Result:= True;  // Ausgleich(e) vorhanden!
  if (FG1_Def_Anz = 0) and (FG2_Def_Anz = 0) then Result:= True; // es muss nichts ausgeglichen werden, da die Defizite tolerierbar sind
end;

(*------------------------------------------------------------------------------*)
function tPrognoseBerechnung.CheckMSAQ: Boolean;
var
  DefFKs          : String;
  DefAnz          : Integer;
  CheckNP         : Boolean;
  CheckAusgleich  : Boolean;
  NPFach          : String;
  ProgErgebnis    : String;
  F, FI, FGNoteBak: Integer;
begin
  Result:= False;
  InitFGNoten;
  FNPFaecherMSAQ:= '';
  AddText('');
  AddText('Prüfe MSA-Q:');
  AddText2(FBlockBegin);
  AddText2(' - Fächergruppen:');
  if not SetFaecherGruppen(pMSAQ,ProgErgebnis) then begin AddText2(ProgErgebnis); Exit; end;
  if ProgErgebnis <> '' then AddText2('  - ' + ProgErgebnis);
  AddText2('  - FG1: ' + GetFKsAusFG(1, pMSAQ));
  AddText2('  - FG2: ' + GetFKsAusFG(2, pMSAQ));
  if IsMSAQ(ProgErgebnis,CheckAusgleich,1)
    then
      begin
        AddText2(ProgErgebnis);
        AddText2(FBlockEnd);
        AddText(FLC + ' MSA-Q (FOR-Q): APO-SI §43 (4)');
        Result:= True;
      end
    else
      begin
        if not CheckAusgleich
          then
            begin
              AddText2(ProgErgebnis);
              AddText2(FBlockEnd);
              AddText(FLC + ' kein MSA-Q (FOR-Q) - KEINE Nachprüfungsmöglichkeiten!')
            end
          else
            begin
              AddText2(ProgErgebnis);
              AddText2(' - kein MSA-Q (FOR-Q)');
              AddText2(' - Ausgleichsprüfung:');

              if CheckMSAQAusgleich(ProgErgebnis, CheckNP,'',2)
                then
                  begin
                    AddText2(ProgErgebnis);
                    AddText2(FBlockEnd);
                    AddText(FLC + ' MSA-Q (FOR-Q): APO-SI §43 (4) - wegen Ausgleichsregelung!');
                    Result:= True;
                  end
                else
                  begin
                    Result:= False;
                    if not CheckNP
                      then
                        begin
                          AddText2(ProgErgebnis);
                          AddText2(FBlockEnd);
                          AddText(FLC + ' kein MSA-Q (FOR-Q) - KEINE Ausgleichsregelung! / KEINE Nachprüfungsmöglichkeiten!');
                        end
                      else
                        begin
                          AddText2(ProgErgebnis);
                          AddText2(' - kein MSA-Q (FOR-Q)');
                          AddText2(' - Nachprüfungsmöglichkeiten:');
                          DefFKs:= GetFKsMitNote([2..5],0,'');
                          DefAnz := GetAnzMitNote( [2..5],0,'');
                          AddText3('  - Fächer: ' + DefFKs);
                          for F:= 1 to DefAnz do
                            begin
                              NPFach:= NBetween(F,',',DefFKs);
                              if (NPFach = 'D') or (NPFach = 'E') or (NPFach = 'M') then Continue;
                              FI:= GetFachIndexByFK(NPFach);
                              if FI <> -1 then with FFaecher[FI] do
                                begin
                                  AddText3('  - Nachprüfung in ' + NPFach + '(' + Fach + '): ' + Sinteger(FGNote) + ' -> ' + Sinteger(FGNote-1));
                                  FGNoteBak:= FGNote;
                                  DecNote(FGNote);
                                  if IsMSAQ(ProgErgebnis,CheckAusgleich, 3)
                                    then
                                      begin
                                        AddText3(ProgErgebnis);
                                        FNPFaecherMSAQ:= SConcat(FNPFaecherMSAQ, NPFach, ',',True,True);
                                        AddText3('   - MSA-Q !');
                                      end
                                    else
                                      if (CheckAusgleich) and (CheckMSAQAusgleich(ProgErgebnis, CheckNP,NPFach,3))
                                        then
                                          begin
                                            AddText3(ProgErgebnis);
                                            FNPFaecherMSAQ:= SConcat(FNPFaecherMSAQ, NPFach, ',',True,True);
                                            AddText3('   - MSA-Q (FOR-Q) - wegen Ausgleichsregelung!');
                                          end
                                        else
                                          begin
                                            AddText3(ProgErgebnis);
                                            AddText3('   - kein MSA-Q !');
                                          end;
                                  FGNote:= FGNoteBak;
                                end;
                            end;
                          AddText2(FBlockEnd);
                          if FNPFaecherMSAQ <> ''
                            then AddText(FLC + ' kein MSA-Q (FOR-Q) - Nachprüfungsmöglichkeite(en) in ' + FNPFaecherMSAQ + ' APO-SI (§44 (2), (3) )')
                            else AddText(FLC + ' kein MSA-Q (FOR-Q) - KEINE Nachprüfungsmöglichkeiten! (APO-SI §44 (2), (3) )');
                        end;
                  end;
            end;
      end;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.GetPrognoseInfo(var Ergebnis: String; aPrognose: tPrognose);
var
  PBak : tPrognose;
  PEBak: String;
begin
//  aktuelle Prognosewerte buffern
  PBak := FPrognose;
  PEBak:= PrognoseErgebnis;
  FPrognose:= pOA;
  FPrognoseErgebnis:= '';
  if FNameDatumMode then
    begin
      AddText('Name   : '+ SConcat(FNachname, Vorname, ', ', True) + IIF(FKlasse <> '', ' (' + Klasse + ')', ''));
      AddText('Datum  : '+ SystemDate + ' ' + SystemTime);
    end;
  AddText('Hinweis: Informationen zum ' + Prog2Str(aPrognose));
  {$IFDEF TESTMODUS}
  AddText('         Das Programm befindet sich im Test-Modus - Es befreit nicht von einer auf der geltenden Rechtslage basierenden Entscheidungsfindung!');
  {$ENDIF}

  AddText('___________________________________________________');
  if aPrognose = pHA9  then CheckHA9;
  if aPrognose = pHA10 then CheckHA10;
  if aPrognose = pMSA  then CheckMSA;
  if aPrognose = pMSAQ then CheckMSAQ;
  Ergebnis:= PrognoseErgebnis;
//  aktuelle Prognosewerte zurückspeichern
  FPrognose:= PBak;
  PrognoseErgebnis:= PEBak;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.InitPrognose;
begin
  FPrognose        := pOA;
  FPrognoseErgebnis:= '';
  FNPFaecherHA9    := '';
  FNPFaecherHA10   := '';
  FNPFaecherMSA    := '';
  FNPFaecherMSAQ   := '';
  if FNameDatumMode then
    begin
      AddText('Name   : '+ SConcat(FNachname, Vorname, ', ', True) + IIF(FKlasse <> '', ' (' + Klasse + ')', ''));
      AddText('Datum  : '+ SystemDate + ' ' + SystemTime);
  {$IFDEF TESTMODUS}
      AddText('Hinweis: Das Programm befindet sich im Test-Modus - Es befreit nicht von einer auf der geltenden Rechtslage basierenden Entscheidungsfindung!');
  {$ENDIF}
      AddText('___________________________________________________');
    end;
end;
(*------------------------------------------------------------------------------*)
procedure tPrognoseBerechnung.BerechnePrognose;
var
  Ergebnis: String;
begin
  InitPrognose;
  if FASDJahrgang <> '10' then
    begin
      if CheckHA9
        then FPrognose:= pHA9;
    end;
  if CheckHA10 then FPrognose:= pHA10;
  if (FPrognose <> POA) or (not IsLBNotenVorhanden(Ergebnis)) then
    if CheckMSA then
      begin
        FPrognose:= pMSA;
        if CheckMSAQ
          then FPrognose:= pMSAQ;
      end;
end;
(*------------------------------------------------------------------------------*)
initialization
(*------------------------------------------------------------------------------*)
end.

