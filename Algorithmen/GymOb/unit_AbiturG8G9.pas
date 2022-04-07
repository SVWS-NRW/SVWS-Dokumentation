unit unit_AbiturG8G9;

interface

uses
  unit_AbiBelegpruefungNeu,
  adodb,
  Classes,
  BetterADODataset;

type

  TSprachenfolgeRec = record
    Fach_ID: integer;
    FachKrz: string;
    StatKrz: string;
    Reihenfolge: string;
    BeginnJg: integer;
  end;

  TSprachenfolgeArray = array of TSprachenfolgeRec;

  TSchuelerSprachenfolge = class( TObject )
    private
      FSprachenfolgeDaten: TSprachenfolgeArray;
      FIstSortiert: boolean;
      FCon: TADOConnection;
      FQry: TBetterADODataset;
      FSchulform: string;
      procedure SetCon( acon: TADOConnection );
      function IndexAusFach( const s_krz: string ): integer;
      procedure Quicksort( const iLo, iHi: integer );
      procedure Sortieren;
    public
      constructor Create;
      destructor Destroy;
      procedure Free;
      procedure Leeren;
      procedure Hinzu( const f_id: integer; const s_krz, f_krz, Rf: string; const Jg: integer );
      function ReihenfolgeVon( const s_krz: string ): string;
      function BeginnJgVon( const s_krz: string ): integer;
      property Connection: TADOConnection read FCon write SetCon;
      property Schulform: string read FSChulform write FSchulform;
      procedure Laden( const s_id: integer );
      function Sek1Sprachen: string;
      function Sek1Sprachen5bis6: string;
      function Sek1Sprachen8: string;
      function Sek1Sprachfaecher5bis6: string;
      function Sek1Sprachfaecher8: string;
      function SprachnachweisVorhanden: boolean;
      function LateinBeginnJg: string;
    end;


  TAbitur = class( TObject )
    private
      FCon: TADOConnection;
      FSchulnr: integer;
      FSchulform: string;
      AbiPruefer: TAbiturBelegPruefer;
      FslFG: TStringList;
      FslReli: TStringList;
      FQryF: TBetterADODataset;
      FQryA: TBetterADODataset;
      FQryAF: TBetterADODataset;
      FQryS: TBetterADODataset;
      FQryKurszahl: TBetterADODataset;
      FS_ID: integer;
      FReli_Krz: string;
      FBll_art: string;
      FBll_punkte: integer;
      FS2_SekI_manuell: boolean;
      FSchuelerName: string;
      FPruefOrdnung: string;
      FAbiSprachenfolge: TSchuelerSprachenfolge;
      FBilingual: string;
      FGruppenModus: boolean;
      FslMsg: TStringList;
      FErrCnt: integer;
      FHeaderDone: boolean;
      FNameDone: boolean;
      FBelegungsfehlerIgnorieren: boolean;
			FZeigeMeldungen: boolean;
      FRequery: boolean;
      FDBFormat: string;
      FFA_Fach: string;
      FFA_Punkte: integer;
      FSchuljahr: integer;
      FAbschnitt: integer;
      procedure SetSchueler_ID( const s_id: integer );
      procedure DatenAusAbiturbereichAnAbiPrueferUebergeben;
      procedure HeaderSchreiben;
      procedure Meldung( const msg: string );
      procedure Meldungsliste( slmsg: TStringList );
      procedure DatenZuruecksetzen( const mit_markierung: boolean );
      procedure ZulassungPunkteSpeichern;
      procedure ZwischenstandPunkteSpeichern;
      procedure EndstandPunkteSpeichern;
      procedure ErgebnisAusgeben;
      function GetIstG8G9: boolean;
    public
      constructor Create( acon, aconintern: TADOConnection );
      destructor Destroy;
      property Schueler_ID: integer read FS_ID write SetSchueler_ID;
      procedure Free;
      property Schulnummer: integer read FSchulnr write FSchulnr;
      property Schulform: string read FSchulform;
      property Gruppenmodus: boolean read FGruppenModus write FGruppenModus;
      property BelegungsfehlerIgnorieren: boolean read FBelegungsfehlerIgnorieren write FBelegungsfehlerIgnorieren;
			procedure MeldungenZeigen;
			procedure MeldungenLeeren;
			property ZeigeMeldungen : boolean read FZeigeMeldungen write FZeigeMeldungen;
      function KurseMarkieren: boolean;
      procedure ZulassungPruefen;
      function MuendlichePruefungen( const loeschen: boolean = true ): boolean;
      function EndergebnisBerechnen: boolean;
      property Ist_G8G9: boolean read GetIstG8G9;
      procedure SetzeSchuldaten( const snr: integer; const sfrm: string; const dauer: double );
      property DerAbiPruefer: TAbiturBelegPruefer read AbiPruefer;
      procedure AktuelleKurszahlErmitteln( const s_id: integer );
//			property ProgressBar: TProgressBar read FProgress write FProgress;
    end;

var
  AbiturG8G9: TABitur;

procedure AbiturG8G9Pruefen( acon, aconint: TADOConnection; const snr: integer; const sfrm: string; const dauer: double );



implementation

uses
  StrUtils,
  SysUtils,
  db,
  RBKStrings,
  unit_mengen,
  unit_TransactionHandler,
  unit_LupoMessenger,
  unit_NotenPunkte,
  unit_GetDBFormat,
  Form_MessageList;

procedure AbiturG8G9Pruefen( acon, aconint: TADOConnection; const snr: integer; const sfrm: string; const dauer: double );
begin
  if not Assigned( AbiturG8G9 ) then
  begin
    AbiturG8G9 := TAbitur.Create( acon, aconint );
    if sfrm = 'WB' then
      AbiturG8G9.SetzeSchuldaten( snr, sfrm, dauer )
    else
      AbiturG8G9.SetzeSchuldaten( snr, sfrm, 45 );
    LupoMessenger.Schulform := sfrm;
  end;
end;


///////////////////////////////////////////////////////////////////////////////

function IstG8( const prford: string ): boolean;
begin
  Result := AnsiContainsText( prford, '/G8' ) or ( prford = 'APO-BK-11/D-BAB' ) or ( prford = 'APO-BK-15/D-BAB' ) or AnsiContainsText( prford, 'WBK10' );
end;

function IstG9( const prford: string ): boolean;
begin
  Result := AnsiContainsText( prford, '/G9' ) or ( prford = 'APO-GOSt(C)10' );
end;

function IstG8G9( const prford: string ): boolean;
begin
  Result := IstG8( prford ) or IstG9( prford );
end;

function Schulform_WB( prford: string ): string;
begin
  if AnsiContainsText( prford, '-KL' ) then
    Result := 'KL'
  else
    Result := 'AG';
end;


constructor TAbitur.Create( acon, aconintern: TADOConnection );
var
  qry: TBetterADODataset;
  fach, fachgr: string;
begin
  inherited Create;

  FCon := acon;

  FDBFormat := GetDBFormat( FCON.ConnectionString );

  FslFG := TStringList.Create;
  FslReli := TStringList.Create;
  FslMsg := TStringList.Create;

  FQryS := TBetterADODataset.Create( nil );
  FQryS.Connection := FCon;
  FQryS.LockType := ltReadOnly;
  FQryS.CommandText := 'select Name, Vorname, BilingualerZweig, Religion_ID, PruefOrdnung from Schueler where ID=:ID';
  FQryS.Parameters[0].DataType := ftInteger;

  FQryA := TBetterADODataset.Create( nil );
  FQryA.Connection := FCon;
  FQryA.LockType := ltReadOnly;
  FQryA.CommandText := 'select BLL_Art, BLL_Punkte, FS2_SekI_manuell from SchuelerAbitur where Schueler_ID=:S_ID';
  FQryA.Parameters[0].DataType := ftInteger;

  FQryAF := TBetterADODataset.Create( nil );
  FQryAF.Connection := FCon;
  FQryAF.LockType := ltReadOnly;
  FQryAF.CommandText := 'select * from SchuelerAbiFaecher AF where AF.Schueler_ID=:SID order by FSortierung';
  FQryAF.Parameters[0].DataType := ftInteger;


  FqryF := TBetterADODataset.Create( nil );
  FQryF.LockType := ltReadOnly;
  FqryF.Connection := FCon;
  FqryF.CommandText := 'select ID, StatistikKrz, FachKrz, Bezeichnung, IstSprache, UnterichtsSprache, Leitfach_ID, Leitfach2_ID, Aufgabenfeld, ZeugnisBez,' +
                       'E1_WZE, E2_WZE, Q_WZE' +
                       ' from EigeneSchule_Faecher where SchulnrEigner=:SE';
  FqryF.Parameters[0].DataType := ftInteger;

  FQryKurszahl := TBetterADODataset.Create( nil );
  FQryKurszahl.LockType := ltReadOnly;
  FQryKurszahl.Connection := FCon;
  FQryKurszahl.CommandText := 'select R12_1, R12_2, R13_1, R13_2 from SchuelerAbiFaecher where Schueler_ID=:SID';
  FQryKurszahl.Parameters[0].Datatype := ftInteger;

  FAbiSprachenfolge := TSchuelerSprachenfolge.Create;
  FAbiSprachenfolge.Connection := acon;

	FNameDone := false;
	FHeaderDone := false;
  FZeigeMeldungen := true;

  qry := TBetterAdoDataset.Create( nil );
  qry.Cursortype := ctOpenForwardOnly;
  try
    with qry do
    begin
      if aconintern <> nil then
        Connection := aconintern
      else
        Connection := acon;
      Commandtext := 'select Fach, FachgruppeKrz from FaecherSortierung order by Fach';
      Open;
      while not Eof do
      begin
        fach := FieldByName( 'Fach' ).AsString;
        fachgr := FieldByname( 'FachgruppeKrz' ).AsString;
        if fachgr <> '' then
          FslFG.Add( Format( '%s=%s', [ fach, fachgr ] ) );
        Next;
      end;
      Close;
      FslFG.Sorted := true;

      Connection := acon;
      CommandText := Format( 'select ID, StatistikKrz from K_Religion where SchulnrEigner in (0,%d)', [ FSchulnr ] );
      Open;
      while not Eof do
      begin
        FslReli.Add( Format( '%d=%s', [ FieldByName( 'ID' ).AsInteger, FieldByname( 'StatistikKrz' ).AsString ] ) );
        Next;
      end;
      Close;
      FslReli.Sorted := true;
    end;

  finally
    FreeAndNil( qry );
  end;
end;

destructor TAbitur.Destroy;
begin
  FreeAndNil( FslFG );
  FreeAndNil( FslReli );
  FreeAndNil( FslMsg );
  FAbiSprachenfolge.Free;
  FreeAndNil( FQryF );
  FreeAndNil( FQryA );
  FreeAndNil( FQryAF );
  FreeAndNil( FQryS );
  FreeAndNil( FQryKurszahl );
  if Assigned( AbiPruefer ) then
    AbiPruefer.Free;
  inherited;
end;

procedure TAbitur.Free;
begin
  if self <> nil then
    Destroy;
end;

function TAbitur.GetIstG8G9: boolean;
begin
  Result := IstG8G9( FPruefOrdnung );
end;

procedure TAbitur.SetSchueler_ID( const s_id: integer );
var
  reli_id: integer;
  statkrz: string;
begin
//  if FS_ID = s_id then
//    exit;
  FS_ID := s_id;

// SChuelerdaten
  FQryS.Parameters[0].Value := FS_ID;
  FQryS.Requery;
  FSchuelerName := FQryS.FieldByname( 'Name' ).AsString + ', ' + FQryS.FieldByname( 'Vorname' ).AsString;
  FBilingual := FQryS.FieldByname( 'BilingualerZweig' ).AsString;
  if FBilingual = '' then
    FBilingual := '-';
  FPruefOrdnung := FQryS.FieldByname( 'PruefOrdnung' ).AsString;

  reli_id := FQryS.FieldByname( 'Religion_ID' ).AsInteger;
  FReli_Krz := '';
  if reli_id > 0 then
    FReli_krz := FslReli.Values[ IntToStr( reli_id ) ];

// Abiturdaten
  FQryA.Parameters[0].Value := FS_ID;
  FQryA.Requery;
  FBll_art := FQryA.FieldByname( 'BLL_Art' ).AsString;
  if FBLL_Art = '' then
    FBLL_Art := 'K';
  FBLL_punkte := FQryA.FieldByname( 'BLL_Punkte' ).AsInteger;
  FS2_SekI_manuell := FQryA.FieldByname( 'FS2_SekI_manuell' ).AsString = '+';

  FAbiSprachenfolge.Laden( FS_ID );
  if not FS2_SekI_manuell then
    FS2_SekI_manuell := FAbiSprachenfolge.SprachNachweisVorhanden;

  if not FqryF.Active then
  begin
    FqryF.Parameters[0].Value := FSchulnr;
    FqryF.Open;
  end;

  FQryAF.Parameters[0].Value := FS_ID;
  FQryAF.Requery;
  while not FQryAF.Eof do
  begin
    FqryF.Locate( 'ID', FqryAF.FieldByname( 'Fach_ID' ).AsInteger, [] );
    if FqryF.FieldByname( 'IstSprache' ).AsString = '+' then
    begin
      statkrz := Trim( FqryF.FieldByname( 'StatistikKrz' ).AsString );
      FAbiSprachenfolge.Hinzu( FqryAF.FieldByname( 'Fach_ID' ).AsInteger,
                                     statkrz,
                                     Trim( FqryF.FieldByname( 'FachKrz' ).AsString ),
                                     '', 0 );
    end;
    FqryAF.Next;
  end;

  if FZeigeMeldungen then
  begin
  	FslMsg.Clear;
    FHeaderDone := false;
  end;

  FNameDone := false;

end;

procedure TAbitur.DatenZuruecksetzen( const mit_markierung: boolean );
var
	cmd: string;
begin
  if ( FDBFormat = 'MSACCESS' ) or ( FDBFormat = 'MSSQL' )  or ( FDBFormat = 'MSSQLCE' )  then
    cmd := Format( 'update SchuelerAbitur set Zugelassen=NULL, SummeGK=NULL, SummeLK=NULL, PruefungBestanden=NULL, [Note]=NULL, GesamtPunktzahl=NULL,' +
                   'Notensprung=NULL, FehlendePunktzahl=NULL, AnzRelLK=NULL, AnzRelGK=NULL, AnzDefLK=NULL, AnzDefGK=NULL, SummenOK=NULL, Jahr=NULL, Abschnitt=NULL,' +
                   'Kurse_I=NULL,Punktsumme_I=NULL,Defizite_I=NULL,LK_Defizite_I=NULL,Durchschnitt_I=NULL,Punktsumme_II=NULL,Defizite_II=NULL,LK_Defizite_II=NULL,' +
                   'FA_Punkte=NULL,FA_Fach=NULL' +
                   ' where Schueler_ID=%d', [ FS_ID ] )
  else
    cmd := Format( 'update SchuelerAbitur set Zugelassen=NULL, SummeGK=NULL, SummeLK=NULL, PruefungBestanden=NULL, Note=NULL, GesamtPunktzahl=NULL,' +
                   ' Notensprung=NULL, FehlendePunktzahl=NULL, AnzRelLK=NULL, AnzRelGK=NULL, AnzDefLK=NULL, AnzDefGK=NULL, SummenOK=NULL, Jahr=NULL, Abschnitt=NULL,' +
                   'Kurse_I=NULL,Punktsumme_I=NULL,Defizite_I=NULL,LK_Defizite_I=NULL,Durchschnitt_I=NULL,Punktsumme_II=NULL,Defizite_II=NULL,LK_Defizite_II=NULL,' +
                   'FA_Punkte=NULL,FA_Fach=NULL' +
                   ' where Schueler_ID=%d', [ FS_ID ] );
  TransactionHandler.DoExecute( cmd );

  if mit_markierung then
    cmd := Format( 'UPDATE SchuelerAbiFaecher SET AbiPruefErgebnis=NULL, Zwischenstand=NULL, Durchschnitt=NULL, Zulassung=NULL,' +
                  'MdlPflichtPruefung=%s, MdlFreiwPruefung=%s, MdlBestPruefung=%s,MdlPruefErgebnis=NULL, MdlPruefFolge=NULL, AbiErgebnis=NULL,' +
                  'R12_1=%s,R12_2=%s,R13_1=%s,R13_2=%s,R_FA=%s' +
                  ' WHERE Schueler_ID=%d',
                 [ QuotedStr( '-' ), QuotedStr( '-' ), QuotedStr( '-' ), QuotedStr( '-' ), QuotedStr( '-' ), QuotedStr( '-' ), QuotedStr( '-' ), QuotedStr( '-' ), FS_ID ] )
  else
    cmd := Format( 'UPDATE SchuelerAbiFaecher SET AbiPruefErgebnis=NULL, Zwischenstand=NULL,' +
                  'MdlPflichtPruefung=%s, MdlFreiwPruefung=%s, MdlBestPruefung=%s,MdlPruefErgebnis=NULL, MdlPruefFolge=NULL, AbiErgebnis=NULL' +
                  ' WHERE Schueler_ID=%d',
                 [ QuotedStr( '-' ), QuotedStr( '-' ), QuotedStr( '-' ), FS_ID ] );

	TransactionHandler.DoExecute( cmd );

end;



procedure TAbitur.DatenAusAbiturbereichAnAbiPrueferUebergeben;
  function KursartUmsetzer( ka: string ): string;
  begin
    ka := Trim( ka );
    Result := '';
    if ka = 'M' then
      Result := 'GKM'
    else if ka = 'S' then
      Result := 'GKS'
    else if ka = 'Z' then
      Result := 'ZK'
    else if ka = 'L' then
      Result := 'LK'
    else if ka = 'V' then
      Result := 'VTF'
    else if ka <> '' then
      Result := 'GKM';
  end;

var
  fachkrz, statkrz, fachbez, istFS, usprache, fachgr, leitfachkrz, leitfach2krz, spr_folge, beginn_jg: string;
  abifach, abiprueferg, mdlprueferg: integer;
  s1_spr, s1_spr_5_6, s1_spr_8, reli_krz, aufgabenfeld, s1_sprfaecher_5_6, s1_sprfaecher_8: string;
  sprachnachweis: boolean;
  sportbefreit: boolean;
  do_add: boolean;
  p12_1, p12_2, p13_1, p13_2: string;
  ka11_1, ka11_2, ka12_1, ka12_2, ka13_1, ka13_2: string;

begin

  try
    AbiPruefer.Initialisieren( FBLL_Art[1], FBLL_Punkte );
    AbiPruefer.PruefungsOrdnung := FPruefOrdnung;
    AbiPruefer.BelegungsfehlerIgnorieren := FBelegungsfehlerIgnorieren;

    sportbefreit := false;

    if not FqryF.Active then
    begin
      FqryF.Parameters[0].Value := FSchulnr;
      FqryF.Open;
    end;

//    if FRequery then
    begin
      FqryAF.Requery;
      FRequery := false;
    end;

    FqryAF.First;
    FFA_Fach := '';
    FFA_Punkte := 0;

    while not FqryAF.Eof do
    begin
      FqryF.Locate( 'ID', FqryAF.FieldByname( 'Fach_ID' ).AsInteger, [] );
// Prüfen auf Facharbiet
      if FQryAF.FieldByName( 'P_FA' ).AsString <> '' then
      begin
        try
          FFA_Punkte := FQryAF.FieldByName( 'P_FA' ).AsInteger;
          FFA_Fach := Trim( FqryF.FieldByname( 'ZeugnisBez' ).AsString );
        except
        end;
      end;
      statkrz := Trim( FqryF.FieldByname( 'StatistikKrz' ).AsString );
      fachkrz := Trim( FqryF.FieldByname( 'FachKrz' ).AsString );
      fachbez := Trim( FqryF.FieldByname( 'Bezeichnung' ).AsString );
      istFS := Trim( FqryF.FieldByname( 'IstSprache' ).AsString );
      usprache := Trim( FqryF.FieldByname( 'UnterichtsSprache' ).AsString );
      aufgabenfeld := FqryF.FieldByname( 'Aufgabenfeld' ).AsString;
      leitfachkrz := '';
      leitfach2krz := '';
      if not FqryF.FieldByname( 'Leitfach_ID' ).IsNull then
      begin
        FqryF.Locate( 'ID', FqryF.FieldByName( 'Leitfach_ID' ).AsInteger, [] );
        leitfachkrz := Trim( FqryF.FieldByName( 'FachKrz' ).AsString );
      end;
// Wichtig: Wider zurückfinden
      FqryF.Locate( 'ID', FqryAF.FieldByname( 'Fach_ID' ).AsInteger, [] );
      if not FqryF.FieldByname( 'Leitfach2_ID' ).IsNull then
      begin
        FqryF.Locate( 'ID', FqryF.FieldByName( 'Leitfach2_ID' ).AsInteger, [] );
        leitfach2krz := Trim( FqryF.FieldByName( 'FachKrz' ).AsString );
      end;
      fachgr := FslFG.Values[ statkrz ];
      abifach := 0;
      if FqryAF.FieldByname( 'AbiFach' ).AsString <> '' then
        try
          abifach := FqryAF.FieldByname( 'AbiFach' ).AsInteger;
        except
        end;

      spr_folge := '';
      beginn_jg := '';

      if istFS = '+' then
      begin
        spr_folge := FAbiSprachenfolge.ReihenfolgeVon( statkrz );
        beginn_jg := IntToStr( FAbiSprachenfolge.BeginnJgVon( statkrz ) );
      end;

      do_add := true;

      ka11_1 := KursartUmsetzer( FqryAF.FieldByName( 'S11_1' ).AsString );
      ka11_2 := KursartUmsetzer( FqryAF.FieldByName( 'S11_2' ).AsString );
      ka12_1 := KursartUmsetzer( FqryAF.FieldByName( 'S12_1' ).AsString );
      ka12_2 := KursartUmsetzer( FqryAF.FieldByName( 'S12_2' ).AsString );
      ka13_1 := KursartUmsetzer( FqryAF.FieldByName( 'S13_1' ).AsString );
      ka13_2 := KursartUmsetzer( FqryAF.FieldByName( 'S13_2' ).AsString );

      p12_1 := FqryAF.FieldByName( 'P12_1' ).AsString;
      p12_2 := FqryAF.FieldByName( 'P12_2' ).AsString;
      p13_1 := FqryAF.FieldByName( 'P13_1' ).AsString;
      p13_2 := FqryAF.FieldByName( 'P13_2' ).AsString;

      if p12_1 = 'AT' then
        ka12_1 := 'AT';
      if p12_2 = 'AT' then
        ka12_2 := 'AT';
      if p13_1 = 'AT' then
        ka13_1 := 'AT';
      if p13_2 = 'AT' then
        ka13_2 := 'AT';

      if ( statkrz = 'SP' ) or ( statkrz = 'S3' ) or ( statkrz = 'S4' ) then
      begin
        sportbefreit := ( p12_1 = 'AT' ) or ( p12_2 = 'AT' ) or ( p13_1 = 'AT' ) or ( p13_2 = 'AT' );
//        do_add := not sportbefreit;
      end;

      if do_add then
        AbiPruefer.FachHinzu( FqryAF.FieldByName( 'Fach_ID' ).AsInteger,
                            statkrz,
                            fachkrz,
                            fachbez,
                            fachgr,
                            usprache,
                            istFS,
                            spr_folge,
                            leitfachkrz,
                            leitfach2krz,
                            beginn_jg,
                            ka11_1,
                            ka11_2,
                            ka12_1,
                            ka12_2,
                            ka13_1,
                            ka13_2,
//                            KursartUmsetzer( FqryAF.FieldByName( 'S11_1' ).AsString ),
//                            KursartUmsetzer( FqryAF.FieldByName( 'S11_2' ).AsString ),
//                            KursartUmsetzer( FqryAF.FieldByName( 'S12_1' ).AsString ),
//                            KursartUmsetzer( FqryAF.FieldByName( 'S12_2' ).AsString ),
//                            KursartUmsetzer( FqryAF.FieldByName( 'S13_1' ).AsString ),
//                            KursartUmsetzer( FqryAF.FieldByName( 'S13_2' ).AsString ),
                            FQryF.FieldByname( 'E1_WZE' ).AsInteger,
                            FQryF.FieldByname( 'E2_WZE' ).AsInteger,
                            FQryF.FieldByname( 'Q_WZE' ).AsInteger,
                            abifach,
                            p12_1,
                            p12_2,
                            p13_1,
                            p13_2,
//                            FqryAF.FieldByName( 'P12_1' ).AsString,
//                            FqryAF.FieldByName( 'P12_2' ).AsString,
//                            FqryAF.FieldByName( 'P13_1' ).AsString,
//                            FqryAF.FieldByName( 'P13_2' ).AsString,
                            FqryAF.FieldByName( 'R12_1' ).AsString = '+',
                            FqryAF.FieldByName( 'R12_2' ).AsString = '+',
                            FqryAF.FieldByName( 'R13_1' ).AsString = '+',
                            FqryAF.FieldByName( 'R13_2' ).AsString = '+',
                            FqryAF.FieldByName( 'R_FA' ).AsString = '+',
                            aufgabenfeld,
                            FqryAF.FieldByName( 'P_FA' ).AsString,
                            FQryAF.FieldByName( 'W12_1' ).AsInteger,
                            FQryAF.FieldByName( 'W12_2' ).AsInteger,
                            FQryAF.FieldByName( 'W13_1' ).AsInteger,
                            FQryAF.FieldByName( 'W13_2' ).AsInteger
                             );


      if abifach in [1,2,3,4] then
      begin
        if FqryAF.FieldByName( 'AbiPruefErgebnis' ).IsNull then
          abiprueferg := -1
        else
          abiprueferg := FqryAF.FieldByName( 'AbiPruefErgebnis' ).AsInteger;

        if FqryAF.FieldByName( 'MdlPruefErgebnis' ).IsNull then
          mdlprueferg := -1
        else
          mdlprueferg := FqryAF.FieldByName( 'MdlPruefErgebnis' ).AsInteger;

        AbiPruefer.AbiturdatenHinzu( FqryAF.FieldByName( 'Fach_ID' ).AsInteger,
                          abifach,
                          abiprueferg,
                          mdlprueferg );
      end;
      FqryAF.Next;
    end;

    s1_spr := FAbiSprachenfolge.Sek1Sprachen;
    s1_spr_5_6 := FAbiSprachenfolge.Sek1Sprachen5bis6;
    s1_spr_8 := FAbiSprachenfolge.Sek1Sprachen8;

    s1_sprfaecher_5_6 := FAbiSprachenfolge.Sek1Sprachfaecher5bis6;
    s1_sprfaecher_8 := FAbiSprachenfolge.Sek1Sprachfaecher8;


    with AbiPruefer do
    begin
      if FSchulform = 'WB' then
        sprachnachweis := FAbiSprachenfolge.SprachNachweisVorhanden
      else
        sprachnachweis := false;
      SetzeSchuelerDaten( FS_ID,
                          FS2_SekI_manuell,
                          s1_spr,
                          s1_spr_5_6,
                          s1_spr_8,
                          s1_sprfaecher_5_6,
                          s1_sprfaecher_8,
                          FBilingual,
                          sprachnachweis,
                          sportbefreit,
                          FAbiSprachenfolge.LateinBeginnJg );
      SetzeWeitereSchuelerdaten( FReli_krz );
    end;

  finally

  end;

end;


procedure TAbitur.HeaderSchreiben;
var
	i : integer;
begin
	FErrCnt := 0;
	if not FHeaderDone then
	begin
//		if not fNurBelegung then
		begin
      FslMsg.Add( 'Wichtiger Hinweis:' );
			FslMsg.Add( 'Über die Gesamtqualifikation und damit über die Abiturzulassung entscheidet' );
			FslMsg.Add( 'ausschließlich der zentrale Abiturausschuss (ZAA).' );
			FslMsg.Add( 'Dieses Programm liefert nur einen Vorschlag für die Beratung des ZAA.' );
		end;
		FHeaderDone := true;
	end;

	if not FNameDone then
	begin
		if FslMsg.Count > 0 then
			FslMsg.Add( '' );		// Leerzeile in Ausgabepuffer
		FslMsg.Add( FSchuelerName );
		FslMsg.Add( '========================================================================' );
		if FPruefOrdnung <> '' then
			FslMsg.Add( 'Prüfungsordnung: ' + FPruefOrdnung )
		else
			FslMsg.Add( 'Prüfungsordnung: Keine Prüfungsordnung zugewiesen' );

		FNameDone := true;
	end;

end;

procedure TAbitur.Meldung( const msg: string );
var
	s : string;
begin
	if msg = '' then
		exit;
  if AnsiStartsText( 'Fehler', msg ) then
		inc( FErrCnt );
	FslMsg.Add( msg );
end;

procedure TAbitur.Meldungsliste( slmsg: TStringList );
var
  i: integer;
begin
  for i := 0 to slmsg.Count - 1 do
    Meldung( slmsg[i] );
end;

procedure TAbitur.MeldungenZeigen;
var
	pd : string;
begin
	if FslMsg.Count = 0 then
		exit;
	with TFrm_MessageList.Create( nil ) do
	begin
		Memo.Font.Name := 'Courier New';
		Memo.Lines := FslMsg;
		Caption := 'Ergebnisse des Prüfungsalgorithmus';
		ShowModal;
		Release;
	end;
	FslMsg.Clear;
  FHeaderDone := false;
  FNameDone := false;
end;

procedure TAbitur.MeldungenLeeren;
begin
	FslMsg.Clear;
end;


function TAbitur.KurseMarkieren: boolean;
var
  cmd: string;

  procedure MarkierungSetzen( const mark: boolean; const abschn: string );
  var
    pfld, rfld: string;
  begin
    pfld := 'P' + abschn;
    rfld := 'R' + abschn;
    with FqryAF do
    begin
      if FieldByName( pfld ).AsString <> '' then
      begin
        if cmd <> '' then
          cmd := cmd + ',';

        if mark then
          cmd := cmd + Format( '%s=%s', [ rfld, QuotedStr( '+' ) ] )
        else
          cmd := cmd + Format( '%s=%s', [ rfld, QuotedStr( '-' ) ] );
      end;
    end;
  end;

var
  go_on: boolean;
  mq1, mq2, mq3, mq4, m_fa: boolean;
  fehler_da: boolean;
begin
  Result := false;

  if FZeigeMeldungen then
  begin
    FHeaderDone := false;
    FNameDone := false;
  end;

  HeaderSchreiben;

  DatenZuruecksetzen( true );

  AbiPruefer.FuerAbitur := true;

  DatenAusAbiturbereichAnAbiPrueferUebergeben;

  fehler_da := false;

  AbiPruefer.BelegpruefungFuerAbitur;
  if AbiPruefer.Belegungsmeldungen.Count > 0 then
  begin
    Meldung( 'Belegungsfehler:' );
    MeldungsListe( AbiPruefer.Belegungsmeldungen );
  end else if not FZeigeMeldungen then
    Meldung( 'Keine Belegungsfehler' );

	if FZeigeMeldungen and AbiPruefer.FehlerVorhanden then
		MeldungenZeigen;

{  if ( FSchulform = 'BK' ) or ( FSchulform = 'SB' ) then
    go_on := true
  else }
    go_on := not AbiPruefer.FehlerVorhanden or FBelegungsfehlerIgnorieren;

  if not go_on then
    exit;

  AbiPruefer.KurseMarkieren;
  if AbiPruefer.BilingualesSachfachBelegt then
    Meldung(  'Es wurde ein bilinguales Fach belegt. ' +
              'In diesem Fall muss das Ergebnis unbedingt überprüft werden, da eine fehlerfreie Auswahl der günstigsten Kursnoten nicht immer möglich ist.' );
  if AbiPruefer.Abbruch then
  begin
    MeldungsListe( AbiPruefer.Meldungen );
    if FZeigeMeldungen then
      MeldungenZeigen;
    if aeLK_Defizite_I in AbiPruefer.AbiturErgebnisse.Ergebnisse then
      go_on := false
    else
      go_on := FBelegungsfehlerIgnorieren;
  end else
    go_on := true;

  if go_on then
  begin
    with FqryAF do
    begin
      First;
      while not Eof do
      begin
        FqryF.LOcate( 'ID', FieldByName( 'Fach_ID' ).AsInteger, [] );
        m_fa := false;
        if ( FSchulform = 'GY' ) or ( FSchulform = 'GE' ) or ( FSchulform = 'WB' ) then
          go_on := AbiPruefer.MarkierungenHolenStatKrz( FqryF.FieldByName( 'StatistikKrz' ).AsString, mq1, mq2, mq3, mq4 )
        else
          go_on := AbiPruefer.MarkierungenHolenInternKrz( FqryF.FieldByName( 'FachKrz' ).AsString, mq1, mq2, mq3, mq4, m_fa );
        if go_on then
        begin
          cmd := '';
          MarkierungSetzen( mq1, '12_1' );
          MarkierungSetzen( mq2, '12_2' );
          MarkierungSetzen( mq3, '13_1' );
          MarkierungSetzen( mq4, '13_2' );
          MarkierungSetzen( m_fa, '_FA' );
          cmd := Format( 'update SchuelerAbiFaecher set %s where ID=%d', [ cmd, FieldByName( 'ID' ).AsInteger ] );
          TransactionHandler.DoExecute( cmd );
        end;
        Next;
      end;
    end;
    Result := true;
  end else
  begin
    cmd := Format( 'update SchuelerAbitur set Zugelassen=%s where Schueler_ID=%d',
                    [ QuotedStr( '-' ), FS_ID ] );
    TransactionHandler.DoExecute( cmd );
  end;
  FRequery := true;
end;


procedure TAbitur.SetzeSchuldaten( const snr: integer; const sfrm: string; const dauer: double );
var
  qry: TBetterADODataset;
begin
  FSchulnr := snr;
  FSchulform := sfrm;

  FAbiSprachenfolge.Schulform := FSchulform;
  if FSchulform = 'SB' then
    FSchulform := 'BK'
  else if FSchulform = 'SG' then
    FSchulform := 'GY';

  if not Assigned( AbiPruefer ) then
  begin
    AbiPruefer := TAbiturBelegPruefer.Create( nil, FSchulform );
    AbiPruefer.AufrufendesProgramm := apSCHILD;
  end;

  AbiPruefer.DauerUnterrichtseinheit := dauer;

  qry := TBetterADODataset.Create( nil );
  try
    qry.Connection := FCon;
    qry.LockType := ltReadOnly;
    qry.CommandText := Format( 'select Schuljahr, SchuljahrAbschnitt from EigeneSchule where Schulnr=%s', [ QuotedStr( IntToStr( snr ) ) ] );
    qry.Open;
    FSchuljahr := qry.FieldByName( 'Schuljahr' ).AsInteger;
    FAbschnitt := qry.FieldByName( 'SchuljahrAbschnitt' ).AsInteger;
    if FAbschnitt = 3 then
      FAbschnitt := 4;
  finally
    FreeAndNil( qry );
  end;

end;



procedure TAbitur.ZulassungPruefen;
var
  go_on: boolean;
  zugelassen: boolean;
  szugelassen: string;
  sum_anz_mark: integer;
  cmd: string;
begin
  zugelassen := false;

  HeaderSchreiben;

  DatenZuruecksetzen( false );

  AbiPruefer.FuerAbitur := true;

  DatenAusAbiturbereichAnAbiPrueferUebergeben;

  AbiPruefer.MarkierungenPruefen;
  if AbiPruefer.Meldungen.Count > 0 then
  begin
    MeldungsListe( AbiPruefer.Meldungen );
    MeldungenZeigen;
  end;

  go_on := not AbiPruefer.Abbruch or FBelegungsfehlerIgnorieren;

  if go_on then
  begin
    AbiPruefer.Block_I_Berechnen;
    zugelassen := ( aeZugelassen in AbiPruefer.AbiturErgebnisse.Ergebnisse );
  end;

  if zugelassen then
  begin
    szugelassen := '+';
  end else
  begin
    szugelassen := '-';
  end;

  if not FZeigeMeldungen then
  begin
    if zugelassen then
      Meldung( 'Zur Abiturprüfung zugelassen' )
    else
      Meldung( 'Zur Abiturprüfung nicht zugelassen' );
  end;

  if AbiPruefer.AbiturErgebnisse.Kurszahl_I > 0 then
    cmd := Format( 'update SchuelerAbitur set Zugelassen=%s, Kurse_I=%d, AnzRelGK=%d, AnzRelLK=%d, LK_Defizite_I=%d, Defizite_I=%d,' +
                   ' Punktsumme_I=%d, SummeLK=%d, SummeGK=%d, AnzahlKurse_0=%d, Durchschnitt_I=%s where Schueler_ID=%d',
                  [ QuotedStr( szugelassen ),
                    AbiPruefer.AbiturErgebnisse.Kurszahl_I,
                    AbiPruefer.AbiturErgebnisse.Kurszahl_I_GK,
                    AbiPruefer.AbiturErgebnisse.Kurszahl_I_LK,
                    AbiPruefer.AbiturErgebnisse.LK_Defizite_I,
                    AbiPruefer.AbiturErgebnisse.Defizite_I,
                    AbiPruefer.AbiturErgebnisse.Punktsumme_I,
                    AbiPruefer.AbiturErgebnisse.Punktsumme_LK,
                    AbiPruefer.AbiturErgebnisse.Punktsumme_GK,
                    AbiPruefer.AbiturErgebnisse.Kurszahl_I_0_Pkt,
                    StringSetDecSep( FloatToStr( AbiPruefer.AbiturErgebnisse.Durchschnitt_I ), '.' ),
                    FS_ID ] )
  else
    cmd := Format( 'update SchuelerAbitur set Zugelassen=%s where Schueler_ID=%d', [ QuotedStr( szugelassen ), FS_ID ] );

  TransactionHandler.DoExecute( cmd );

  if ( ( FSChulform = 'BK' ) or ( FSchulform = 'SB' ) ) and ( FFA_Fach <> '' ) and ( FFA_Punkte > 0 ) then
  begin
    cmd := Format( 'update SchuelerAbitur set FA_Fach=%s, FA_Punkte=%d where Schueler_ID=%d',
                   [ QuotedStr( FFa_Fach ), FFa_Punkte, FS_ID ] );
    TransactionHandler.DoExecute( cmd );
  end;

  ZulassungPunkteSpeichern;
end;

function TAbitur.MuendlichePruefungen( const loeschen: boolean = true ): boolean;
var
  res: char;
  cmd: string;
begin
  Result := true;
  if loeschen then
  begin
    cmd := Format( 'UPDATE SchuelerAbiFaecher SET MdlPflichtPruefung=%s, MdlFreiwPruefung=%s, MdlBestPruefung=%s,MdlPruefErgebnis=NULL, MdlPruefFolge=NULL, AbiErgebnis=NULL' +
                    ' WHERE Schueler_ID=%d',
                   [ QuotedStr( '-' ), QuotedStr( '-' ), QuotedStr( '-' ), FS_ID ] );
    TransactionHandler.DoExecute( cmd );
  end;

  FRequery := true;

  if not FZeigeMeldungen then
    HeaderSchreiben;

  AbiPruefer.FuerAbitur := true;

  DatenAusAbiturbereichAnAbiPrueferUebergeben;
  AbiPruefer.Block_I_Berechnen;
  AbiPruefer.Block_II_Berechnen;

  if aeFehlendeSchrAbiLeistungen in AbiPruefer.Abiturergebnisse.Ergebnisse then
  begin
    if not FZeigeMeldungen then
      Meldung( 'Abiturleistungen unvollständig' );
    Result := false;
    exit;
  end;

  with FqryAF do
  begin
    First;
    while not Eof do
    begin
      if ( FieldByName( 'Abifach' ).AsString = '1' ) or
         ( FieldByName( 'Abifach' ).AsString = '2' ) or
         ( FieldByName( 'Abifach' ).AsString = '3' ) then
      begin
        if not FieldByname( 'AbiPruefErgebnis' ).IsNull then
        begin
          res := AbiPruefer.MuendlichePruefungNotwendig( FieldByName( 'P12_1' ).AsString,
                                                         FieldByName( 'P12_2' ).AsString,
                                                         FieldByName( 'P13_1' ).AsString,
                                                         FieldByName( 'P13_2' ).AsString,
                                                         FieldByname( 'AbiPruefErgebnis' ).AsInteger );
          if res = '+' then
          begin
            cmd := Format( 'update SchuelerAbiFaecher set MdlPflichtPruefung=%s where ID=%d', [ QuotedStr( '+' ), FieldByname( 'ID' ).AsInteger ] );
            TransactionHandler.DoExecute( cmd );
          end else if AbiPruefer.AbiturErgebnisse.Bestehenspruefung then
          begin
            cmd := Format( 'update SchuelerAbiFaecher set MdlBestPruefung=%s where ID=%d', [ QuotedStr( '+' ), FieldByname( 'ID' ).AsInteger ] );
            TransactionHandler.DoExecute( cmd );
          end;
        end;
      end;
      Next;
    end;
  end;


  ZwischenstandPunkteSpeichern;
  if AbiPruefer.AbiturErgebnisse.LeistungenVollstaendig then
  begin
    Meldung( 'Keine mündliche Prüfung notwendig' );
    EndstandPunkteSpeichern;
    ErgebnisAusgeben;
  end else
  begin
    if not FZeigeMeldungen then
    begin
      if AbiPruefer.AbiturErgebnisse.Bestehenspruefung then
        Meldung( 'Mündliche Bestehensprüfungen notwendig' )
      else if AbiPruefer.AbiturErgebnisse.Abweichungspruefung then
        Meldung( 'Mündliche Abweichungsprüfung notwendig' )
      else
        Meldung( 'Keine mündliche Prüfung notwendig' );
    end;
    EndstandPunkteSpeichern;
    ErgebnisAusgeben;

  end;

  FRequery := true;

//      MessageDlg( 'Schriftliche Noten unvollständig', mtError, [ mbOK ], 0 );


end;

function TAbitur.EndergebnisBerechnen: boolean;
begin
  FRequery := true;

  if not FZeigeMeldungen then
    HeaderSchreiben;

  AbiPruefer.FuerAbitur := true;

  DatenAusAbiturbereichAnAbiPrueferUebergeben;
  AbiPruefer.Block_I_Berechnen;
  AbiPruefer.Block_II_Berechnen;
  Result := AbiPruefer.AbiturErgebnisse.LeistungenVollstaendig;
  if Result then
  begin
    EndstandPunkteSpeichern;
    ErgebnisAusgeben;
  end;
end;


procedure TAbitur.ErgebnisAusgeben;
var
  psum_ii, def_ii, lk_def_ii, psum_abi: integer;
  abi_note, abi_best: string;
  noten_sprung,pktabst_besser: integer;
  cmd, abschluss: string;
  pktabst_besser_s, noten_sprung_s: string;

begin
// Hierfür noch felder notwendig
  psum_ii := AbiPruefer.AbiturErgebnisse.Punktsumme_II;
  def_ii := AbiPruefer.AbiturErgebnisse.Defizite_II;
  lk_def_ii := AbiPruefer.AbiturErgebnisse.LK_Defizite_II;

// Hierfür Felder da
  psum_abi := AbiPruefer.AbiturErgebnisse.Punktsumme_Abi;
  if AbiPruefer.AbiturErgebnisse.Abiturnote_Besser = 0 then
  begin // keine Verbesserung möglich
    noten_sprung_s := 'NULL';
    pktabst_besser_s := 'NULL';
  end else
  begin
    pktabst_besser := AbiPruefer.AbiturErgebnisse.Punktabstand_Besser;
    noten_sprung := psum_abi + pktabst_besser;
    noten_sprung_s := IntToStr( noten_sprung );
    pktabst_besser_s := IntToStr( pktabst_besser );
  end;
  abi_note := FloatToStr( AbiPruefer.AbiturErgebnisse.Abiturnote );

  if aeFehlendeZusAbiLeistungen in AbiPruefer.Abiturergebnisse.Ergebnisse then
    abi_best := 'NULL'
  else if aeNichtBestanden in AbiPruefer.Abiturergebnisse.Ergebnisse then
  begin
    abi_best := QuotedStr( '-' );
    if not FZeigeMeldungen then
      Meldung( 'Abiturprüfung nicht bestanden' );
  end else if  aeBestanden in AbiPruefer.Abiturergebnisse.Ergebnisse then
  begin
    abi_best := QuotedStr( '+' );
    if not FZeigeMeldungen then
      Meldung( 'Abiturprüfung bestanden' );
  end;

  if ( FDBFormat = 'MSACCESS' ) or ( FDBFormat = 'MSSQL' ) or ( FDBFormat = 'MSSQLCE' ) then
    cmd := Format( 'update SchuelerAbitur set PruefungBestanden=%s, GesamtPunktzahl=%d, [Note]=%s, Notensprung=%s, FehlendePunktzahl=%s,' +
                   'Punktsumme_II=%d, Defizite_II=%d, LK_Defizite_II=%d, Jahr=%d, Abschnitt=%d where Schueler_ID=%d',
                   [ abi_best,
                     psum_abi,
                     QuotedStr( abi_note ),
                     noten_sprung_s,
                     pktabst_besser_s,
                     psum_ii,
                     def_ii,
                     lk_def_ii,
                     FSchuljahr,
                     FAbschnitt,
                     FS_ID ] )
  else
    cmd := Format( 'update SchuelerAbitur set PruefungBestanden=%s, GesamtPunktzahl=%d, Note=%s, Notensprung=%s, FehlendePunktzahl=%s,' +
                   'Punktsumme_II=%d, Defizite_II=%d, LK_Defizite_II=%d, Jahr=%d, Abschnitt=%d where Schueler_ID=%d',
                   [ abi_best,
                     psum_abi,
                     QuotedStr( abi_note ),
                     noten_sprung_s,
                     pktabst_besser_s,
                     psum_ii,
                     def_ii,
                     lk_def_ii,
                     FSchuljahr,
                     FAbschnitt,
                     FS_ID ] );

  if cmd <> '' then
  begin
    TransactionHandler.DoExecute( cmd );

// Die Anschlüsse setzen
    if aeBestanden in AbiPruefer.Abiturergebnisse.Ergebnisse then
    begin
// Jetzt noch evtl. Bestehensprüfungen rausnehmen, die noch keine Punkte haben
      cmd := Format( 'update SchuelerAbiFaecher set MdlBestPruefung=%s where Schueler_ID=%d and MdlBestPruefung=%s and MdlPruefErgebnis is null',
                   [ QuotedStr( '-' ), FS_ID, QuotedStr( '+' ) ] );
      TransactionHandler.DoExecute( cmd );

      if FSchulform = 'GY' then
      begin
        cmd := Format( 'update Schueler set EntlassArt=%s where ID=%d', [ QuotedStr( 'K' ), FS_ID ] );
        TransactionHandler.DoExecute( cmd );
        if IstG8( FPruefOrdnung ) then
          abschluss := 'GY/APO-GOStG8/ABI'
        else
          abschluss := 'GY/APO-GOStG9/ABI';
        cmd := Format( 'update SchuelerLernabschnittsdaten set Abschlussart=1, VersetzungKrz=%s, Abschluss=%s where Schueler_ID=%d and Jahr=%d and Abschnitt=%d',
                       [ QuotedStr( 'A' ),
                         QuotedStr( abschluss ),
                         FS_ID,
                         FSchuljahr,
                         FAbschnitt ] );
        TransactionHandler.DoExecute( cmd );
      end else if FSchulform = 'GE' then
      begin
        cmd := Format( 'update Schueler set EntlassArt=%s where ID=%d', [ QuotedStr( 'K' ), FS_ID ] );
        TransactionHandler.DoExecute( cmd );
        if IstG8( FPruefOrdnung ) then
          abschluss := 'GE/APO-GOStG8/ABI'
        else
          abschluss := 'GE/APO-GOStG9/ABI';
        cmd := Format( 'update SchuelerLernabschnittsdaten set Abschlussart=1, VersetzungKrz=%s, Abschluss=%s where Schueler_ID=%d and Jahr=%d and Abschnitt=%d',
                       [ QuotedStr( 'A' ),
                         QuotedStr( abschluss ),
                         FS_ID,
                         FSchuljahr,
                         FAbschnitt ] );
        TransactionHandler.DoExecute( cmd );
      end else if FSChulform = 'WB' then
      begin
        cmd := Format( 'update Schueler set EntlassArt=%s where ID=%d', [ QuotedStr( 'K' ), FS_ID ] );
        TransactionHandler.DoExecute( cmd );

        if Schulform_WB( FPruefOrdnung ) = 'KL' then
          abschluss := 'APO-WBK10-KL/ABI'
        else
          abschluss := 'APO-WBK10-AG/ABI';
        cmd := Format( 'update SchuelerLernabschnittsdaten set Abschlussart=1, VersetzungKrz=%s, Abschluss=%s where Schueler_ID=%d and Jahr=%d and Abschnitt=%d',
                       [ QuotedStr( 'A' ),
                         QuotedStr( abschluss ),
                         FS_ID,
                         FSchuljahr,
                         FAbschnitt ] );
        TransactionHandler.DoExecute( cmd );
      end else if FSchulform = 'BK' then
      begin
// Bei BK noch kein Statistik-Kürzel
        cmd := Format( 'update Schueler set EntlassArt=%s where ID=%d', [ QuotedStr( '0K' ), FS_ID ] );
        TransactionHandler.DoExecute( cmd );

        abschluss := 'APO-BK-03/D-BAB/AHR';
        cmd := Format( 'update SchuelerLernabschnittsdaten set Abschlussart=1, VersetzungKrz=%s, Abschluss=%s where Schueler_ID=%d and Jahr=%d and Abschnitt=%d',
                       [ QuotedStr( 'A' ),
                         QuotedStr( abschluss ),
                         FS_ID,
                         FSchuljahr,
                         FAbschnitt ] );
        TransactionHandler.DoExecute( cmd );

      end;
    end;
  end;


{  if aeNichtBestanden in AbiPruefer.Abiturergebnisse.Ergebnisse then
  begin
    abi_best := QuotedStr( '-' );
    if not FZeigeMeldungen then
      Meldung( 'Abiturprüfung nicht bestanden' );
    if ( FDBFormat = 'MSACCESS' ) or ( FDBFormat = 'MSSQL' ) then
      cmd := Format( 'update SchuelerAbitur set PruefungBestanden=%s, GesamtPunktzahl=%d, [Note]=NULL, Notensprung=NULL, FehlendePunktzahl=Null,' +
                     'Punktsumme_II=%d, Defizite_II=%d, LK_Defizite_II=%d where Schueler_ID=%d',
                     [ QuotedStr( '-' ),
                       psum_abi,
                       psum_ii,
                       def_ii,
                       lk_def_ii,
                       FS_ID ] )
    else
      cmd := Format( 'update SchuelerAbitur set PruefungBestanden=%s, GesamtPunktzahl=%d, Note=NULL, Notensprung=NULL, FehlendePunktzahl=Null,' +
                     'Punktsumme_II=%d, Defizite_II=%d, LK_Defizite_II=%d where Schueler_ID=%d',
                     [ QuotedStr( '-' ),
                       psum_abi,
                       psum_ii,
                       def_ii,
                       lk_def_ii,
                       FS_ID ] );
  end else if aeFehlendeZusAbiLeistungen in AbiPruefer.Abiturergebnisse.Ergebnisse then
  begin
    if ( FDBFormat = 'MSACCESS' ) or ( FDBFormat = 'MSSQL' ) then
      cmd := Format( 'update SchuelerAbitur set PruefungBestanden=NULL, GesamtPunktzahl=%d, [Note]=%s, Notensprung=%d, FehlendePunktzahl=%d,' +
                     'Punktsumme_II=%d, Defizite_II=%d, LK_Defizite_II=%d where Schueler_ID=%d',
                     [ psum_abi,
                       QuotedStr( abi_note ),
                       noten_sprung,
                       pktabst_besser,
                       psum_ii,
                       def_ii,
                       lk_def_ii,
                       FS_ID ] )
    else
      cmd := Format( 'update SchuelerAbitur set PruefungBestanden=NULL, GesamtPunktzahl=%d, Note=%s, Notensprung=%d, FehlendePunktzahl=%d,' +
                     'Punktsumme_II=%d, Defizite_II=%d, LK_Defizite_II=%d where Schueler_ID=%d',
                     [ psum_abi,
                       QuotedStr( abi_note ),
                       noten_sprung,
                       pktabst_besser,
                       psum_ii,
                       def_ii,
                       lk_def_ii,
                       FS_ID ] );

  end else if aeBestanden in AbiPruefer.Abiturergebnisse.Ergebnisse then
  begin
    if not FZeigeMeldungen then
      Meldung( 'Abiturprüfung bestanden' );

    if ( FDBFormat = 'MSACCESS' ) or ( FDBFormat = 'MSSQL' ) then
      cmd := Format( 'update SchuelerAbitur set PruefungBestanden=%s, GesamtPunktzahl=%d, [Note]=%s, Notensprung=%d, FehlendePunktzahl=%d,' +
                     'Punktsumme_II=%d, Defizite_II=%d, LK_Defizite_II=%d where Schueler_ID=%d',
                     [ QuotedStr( '+' ),
                       psum_abi,
                       QuotedStr( abi_note ),
                       noten_sprung,
                       pktabst_besser,
                       psum_ii,
                       def_ii,
                       lk_def_ii,
                       FS_ID ] )
    else
      cmd := Format( 'update SchuelerAbitur set PruefungBestanden=%s, GesamtPunktzahl=%d, Note=%s, Notensprung=%d, FehlendePunktzahl=%d,' +
                     'Punktsumme_II=%d, Defizite_II=%d, LK_Defizite_II=%d where Schueler_ID=%d',
                     [ QuotedStr( '+' ),
                       psum_abi,
                       QuotedStr( abi_note ),
                       noten_sprung,
                       pktabst_besser,
                       psum_ii,
                       def_ii,
                       lk_def_ii,
                       FS_ID ] );
  end;
  if cmd <> '' then
    TransactionHandler.DoExecute( cmd );}
end;


procedure TAbitur.ZulassungPunkteSpeichern;
var
  cmd, sds: string;
  psum_mark: integer;
  durchschn: double;
begin
  with FQryAF do
  begin
    First;
    while not Eof do
    begin
      AbiPruefer.PunktSummeFuerFachBerechnen( FieldByname( 'Fach_ID' ).AsInteger, psmZulassung, psum_mark, durchschn );
      if psum_mark > 0 then
      begin
        if durchschn > 0 then
        begin
          sds := StringSetDecSep( FloatToStr( durchschn ), '.' );
          cmd := Format( 'update SchuelerAbiFaecher set Zulassung=%d, Durchschnitt=%s where ID=%d', [ psum_mark, sds, FieldByname( 'ID' ).AsInteger ] );
        end else
          cmd := Format( 'update SchuelerAbiFaecher set Zulassung=%d where ID=%d', [ psum_mark, FieldByname( 'ID' ).AsInteger ] );
        TransactionHandler.DoExecute( cmd );
      end;
      Next;
    end;
  end;

  FRequery := true;

end;


procedure TAbitur.ZwischenstandPunkteSpeichern;
var
  cmd, sds: string;
  psum_mark: integer;
  durchschn: double;
begin
  cmd := '';
  with FQryAF do
  begin
    First;
    while not Eof do
    begin
      AbiPruefer.PunktSummeFuerFachBerechnen( FieldByname( 'Fach_ID' ).AsInteger, psmZwischenstand, psum_mark, durchschn );
      if psum_mark >= 0 then
        cmd := Format( 'update SchuelerAbiFaecher set Zwischenstand=%d where ID=%d', [ psum_mark, FieldByname( 'ID' ).AsInteger ] );
//      else {if psum_mark = 0 then}
//        cmd := Format( 'update SchuelerAbiFaecher set Zwischenstand=NULL where ID=%d', [ FieldByname( 'ID' ).AsInteger ] );
      if cmd <> '' then
        TransactionHandler.DoExecute( cmd );
      Next;
    end;
  end;

  FRequery := true;

end;

procedure TAbitur.EndstandPunkteSpeichern;
var
  cmd, sds: string;
  psum_mark: integer;
  durchschn: double;
begin
  cmd := '';
  with FQryAF do
  begin
    First;
    while not Eof do
    begin
      AbiPruefer.PunktSummeFuerFachBerechnen( FieldByname( 'Fach_ID' ).AsInteger, psmEndstand, psum_mark, durchschn );
      if psum_mark >= 0 then
        cmd := Format( 'update SchuelerAbiFaecher set AbiErgebnis=%d where ID=%d', [ psum_mark, FieldByname( 'ID' ).AsInteger ] );
//      else if psum_mark = 0 then
//        cmd := Format( 'update SchuelerAbiFaecher set AbiErgebnis=NULL where ID=%d', [ FieldByname( 'ID' ).AsInteger ] );
      if cmd <> '' then
        TransactionHandler.DoExecute( cmd );
      Next;
    end;
  end;

  FRequery := true;

end;

procedure TAbitur.AktuelleKurszahlErmitteln( const s_id: integer );
var
  kurszahl: integer;
  cmd: string;
begin
  kurszahl := 0;
  with FQryKurszahl do
  begin
    Parameters[0].Value := s_id;
    Requery;
    First;
    while not Eof do
    begin
      if FieldByName( 'R12_1' ).AsString <> '-' then
        inc( kurszahl );
      if FieldByName( 'R12_2' ).AsString <> '-' then
        inc( kurszahl );
      if FieldByName( 'R13_1' ).AsString <> '-' then
        inc( kurszahl );
      if FieldByName( 'R13_2' ).AsString <> '-' then
        inc( kurszahl );
      Next;
    end;
  end;

  cmd := Format( 'update SchuelerAbitur set Kurse_I=%d where Schueler_ID=%d', [ kurszahl, s_id ] );
  TransactionHandler.DoExecute( cmd );
end;

////////////////////////////////////////////////////////////////////////////////

constructor TSchuelerSprachenfolge.Create;
begin
  inherited;
  FQry := TBetterADODataset.Create( nil );
  FQry.LockType := ltReadOnly;
end;

destructor TSchuelerSprachenfolge.Destroy;
begin
  FreeAndNil( FQry );
  inherited;
end;

procedure TSchuelerSprachenfolge.Free;
begin
  if self <> nil then
    Destroy;
end;

procedure TSchuelerSprachenfolge.SetCon( acon: TADOConnection );
var
  cmd: string;
begin
  if FCon <> nil then
    FCon.Connected := false;
  FCon := acon;
  FQry.Connection := acon;
  cmd := 'select SP.Fach_ID, SP.JahrgangVon, SP.JahrgangBis, SP.Reihenfolge, F.StatistikKrz, F.FachKrz from SchuelerSprachenfolge SP, EigeneSchule_Faecher F' +
         ' where SP.Schueler_ID=:ID and F.ID=SP.Fach_ID';
  FQry.CommandText := cmd;
  FQry.Parameters[0].Datatype := ftInteger;
end;

procedure TSchuelerSprachenfolge.Leeren;
begin
  SetLength( FSprachenfolgeDaten, 0 );
  FIstSortiert := false;
end;

procedure TSchuelerSprachenfolge.Laden( const s_id: integer );
var
  cmd: string;
  do_add: boolean;
  dauer: integer;
begin
  Leeren;
  with FQry do
  begin
    Parameters[0].Value := s_id;
    Requery;
    First;
    while not Eof do
    begin
      if ( FSchulform = 'WB' ) then
        do_add := FieldByName( 'Reihenfolge' ).AsString <> ''
      else
        do_add := not FieldByName( 'JahrgangVon' ).IsNull;
      if do_add and ( FSchulform = 'BK' ) then
      begin
        if not FieldByName( 'JahrgangBis' ).IsNull and ( FieldByName( 'JahrgangVon' ).AsInteger < 10 ) then
        begin
          dauer := abs( FieldByName( 'JahrgangBis' ).AsInteger - FieldByName( 'JahrgangVon' ).AsInteger ) + 1;
          do_add := dauer > 3;
        end;
      end;

      if do_add then
        Hinzu( FieldByname( 'Fach_ID' ).AsInteger,
                    FieldByName( 'StatistikKrz' ).AsString,
                    FieldByName( 'FachKrz' ).AsString,
                    FieldByName( 'Reihenfolge' ).AsString,
                    FieldByName( 'JahrgangVon' ).AsInteger );
      Next;
    end;
  end;
end;

function TSchuelerSprachenfolge.IndexAusFach( const s_krz: string ): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to High( FSprachenfolgeDaten ) do
  begin
    if FSprachenfolgeDaten[i].StatKrz[1] = s_krz[1] then
    begin
      Result := i;
      exit;
    end;
  end;
end;

// #SCHILD30#
procedure TSchuelerSprachenfolge.Hinzu( const f_id: integer; const s_krz, f_krz, Rf: string; const Jg: integer );
var
  ix: integer;
  sjg, srf: string;
  ljg: integer;
begin
  ix := IndexAusFach( S_Krz );
  if ix >= 0 then
    exit;

  ljg := Jg;

// Prüfen, ob Fach mit Jahrgang
  if length( s_krz ) > 1 then
  begin // Sprache mit Jg
    sjg := s_krz[2];
    try
      ljg := StrToInt( sjg );
    except
      exit;
    end;
    case ljg of
    0 : ljg := 10;
    1 : ljg := 11;
    end;
  end;

  srf := Rf;
  if ( srf = 'N' ) or ( srf = 'P' ) then
  begin
    srf := '2';
    ljg := 10;
  end else if srf = '1' then
  begin
    if ljg = 0 then
      ljg := 5;
  end;


  if ljg = 0 then
    exit;

  SetLength( FSprachenfolgeDaten, High( FSprachenfolgeDaten ) + 2 );
  ix := High( FSprachenfolgeDaten );
  with FSprachenfolgeDaten[ix] do
  begin
    Fach_ID := f_id;
    StatKrz := s_krz[1];
    FachKrz := f_krz;
    Reihenfolge := rf;
    BeginnJg := ljg;
  end;
end;

procedure TSchuelerSprachenfolge.QuickSort( const iLo, iHi: integer );
var
  Lo       : integer;
  Hi       : integer;
  T        : TSprachenfolgeRec;
  Mid      : integer;
begin
  Lo := iLo;
  Hi := iHi;
  Mid := FSprachenfolgeDaten[(Lo + Hi) div 2].BeginnJg;
  repeat

    while FSprachenfolgeDaten[Lo].BeginnJg < Mid do
      Inc(Lo) ;
    while FSprachenfolgeDaten[Hi].BeginnJg > Mid do
      Dec(Hi) ;

    if Lo <= Hi then
    begin
      T := FSprachenfolgeDaten[Lo];
      FSprachenfolgeDaten[Lo] := FSprachenfolgeDaten[Hi];
      FSprachenfolgeDaten[Hi] := T;
      Inc(Lo);
      Dec(Hi);
    end;

  until Lo > Hi;

  if Hi > iLo then
    QuickSort( iLo, Hi);
  if Lo < iHi then
    QuickSort( Lo, iHi);
end;

procedure TSchuelerSprachenfolge.Sortieren;
var
  i: integer;
begin
  if High( FSprachenfolgeDaten ) < 0 then
    exit;
  QuickSort( 0, High( FSprachenfolgeDaten ) );
  for i := 0 to High( FSprachenfolgeDaten ) do
  begin
    if FSprachenfolgedaten[i].Reihenfolge = '' then
      FSprachenfolgedaten[i].Reihenfolge := IntToStr( i + 1 );
  end;
  FIstSortiert := true;
end;

function TSchuelerSprachenfolge.ReihenfolgeVon( const s_krz: string ): string;
var
  ix: Integer;
begin
  Result := '';
  ix := IndexAusFach( s_krz );
  if ix >= 0 then
    Result := FSprachenfolgeDaten[ix].Reihenfolge;
end;

function TSchuelerSprachenfolge.BeginnJgVon( const s_krz: string ): integer;
var
  ix: Integer;
begin
  Result := 0;
  ix := IndexAusFach( s_krz );
  if ix >= 0 then
    Result := FSprachenfolgeDaten[ix].BeginnJg;
end;

function TSchuelerSprachenfolge.LateinBeginnJg: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to High( FSprachenfolgeDaten ) do
  begin
    if AnsiStartsText( 'L', FSprachenfolgeDaten[i].StatKrz ) then
    begin
      Result := IntToStr( FSprachenfolgeDaten[i].BeginnJg );
      if Length( Result ) = 1 then
        Result := '0' + Result;
    end;
  end;
end;

function TSchuelerSprachenfolge.Sek1Sprachen: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to High( FSprachenfolgeDaten ) do
  begin
    if FSprachenfolgeDaten[i].BeginnJg in [ 5, 6, 7, 8, 9 ] then
      ZuMengeHinzu( Result, copy( FSprachenfolgeDaten[i].StatKrz, 1, 1 ) );
  end;
end;

function TSchuelerSprachenfolge.Sek1Sprachen5bis6: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to High( FSprachenfolgeDaten ) do
  begin
    if FSprachenfolgeDaten[i].BeginnJg in [ 5, 6 ] then
      ZuMengeHinzu( Result, copy( FSprachenfolgeDaten[i].StatKrz, 1, 1 ) );
  end;
end;

function TSchuelerSprachenfolge.Sek1Sprachen8: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to High( FSprachenfolgeDaten ) do
  begin
    if FSprachenfolgeDaten[i].BeginnJg in [ 8 ] then
      ZuMengeHinzu( Result, copy( FSprachenfolgeDaten[i].StatKrz, 1, 1 ) );
  end;
end;

function TSchuelerSprachenfolge.Sek1Sprachfaecher5bis6: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to High( FSprachenfolgeDaten ) do
  begin
    if FSprachenfolgeDaten[i].BeginnJg in [ 5, 6 ] then
      ZuMengeHinzu( Result, FSprachenfolgeDaten[i].FachKrz );
  end;
end;

function TSchuelerSprachenfolge.Sek1Sprachfaecher8: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to High( FSprachenfolgeDaten ) do
  begin
    if FSprachenfolgeDaten[i].BeginnJg in [ 8 ] then
      ZuMengeHinzu( Result, FSprachenfolgeDaten[i].FachKrz );
  end;
end;


function TSchuelerSprachenfolge.SprachnachweisVorhanden: boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to High( FSprachenfolgeDaten ) do
  begin
    if ( FSprachenfolgeDaten[i].Reihenfolge = 'N' ) or ( FSprachenfolgeDaten[i].Reihenfolge = 'P' ) then
    begin
      Result := true;
      exit;
    end;
  end;
end;


initialization

finalization
  if Assigned( AbiturG8G9 ) then
    AbiturG8G9.Free;




end.


procedure TAbitur.ZwischenstandBerechnen;
var
  zwstand: float;
begin
  with FqryAF do
  begin
    First;
    while not Eof do
    begin
      if ( FieldByName( 'Abifach' ).AsString = '1' ) or
         ( FieldByName( 'Abifach' ).AsString = '2' ) or
         ( FieldByName( 'Abifach' ).AsString = '3' ) then
      begin
        if FBLL_Art = 'K' then
        begin // keine BLL
          zwstand := 5*FieldByName( 'AbiPruefErgebnis' ).AsInteger;
        end else
        begin // BLL
          zwstand := 4*FieldByName( 'AbiPruefErgebnis' ).AsInteger;
        end;




        if FBLL_Art = 'K' then
        begin // keine BLL
          if not FieldByname( 'MdlPruefErgebnis' ).IsNull then
            FieldByname( 'Berechnung' ).AsFloat := 5/3*(2*FieldByName( 'AbiPruefErgebnis' ).AsInteger + FieldByName( 'MdlPruefErgebnis' ).AsInteger)
          else
            FieldByname( 'Berechnung' ).AsFloat := 5*FieldByName( 'AbiPruefErgebnis' ).AsInteger;
        end else
        begin // BLL
          if not FieldByname( 'MdlPruefErgebnis' ).IsNull then
            FieldByname( 'Berechnung' ).AsFloat := 4/3*(2*FieldByName( 'AbiPruefErgebnis' ).AsInteger + FieldByName( 'MdlPruefErgebnis' ).AsInteger)
          else
            FieldByname( 'Berechnung' ).AsFloat := 4*FieldByName( 'AbiPruefErgebnis' ).AsInteger;
        end;

