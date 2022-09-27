unit Unit_BasisPruefungsalgorithmus;

interface

uses	Classes,
			AdoDB,
{$IFDEF UNIDAC}
      Uni,
{$ELSE}
			BetterADODataset,
{$ENDIF}
      ComCtrls,
      unit_FachEinstellungen,
			DB,
      unit_SchildGlob,
      MemTableDataEh,
      MemTableEh;

type


	TPruefungsAlgorithmus = class( TObject )
		private
      fProgress : TProgressBar;
			fSchuelerName : string;
			fMaxID: integer;
			fNameDone : boolean;
      fPrfOrdDone: boolean;
			slMsg: TStringList;
      slMsgGes: TStringList;
			fConIntern: TADOConnection;
			FConInternFromOutside: boolean;
			fConSchildString: string;
{$IFDEF UNIDAC}
			fQryFachGr: TUniQuery;
			fQryJG: TUniQuery;
			fQryS : TUniQuery;
			fQryF : TUniQuery;
			fQryP : TUniQuery;
			fQryAbschl: TUniQuery;
{$ELSE}
			fQryFachGr: TBetterADODataset;
			fQryJG: TBetterADODataset;
			fQryS : TBetterADODataset;
			fQryF : TBetterADODataset;
			fQryP : TBetterADODataset;
			fQryAbschl: TBetterADODataset;

{$ENDIF}
			fKlassenart: string;
			fIstVersetzt: boolean;
			FIst_BK: boolean;
			fExternalConnection: boolean;
			FIst_BKAbschl: boolean;
			FSGL_BKAbschl: string;
			FJG_BKAbschl: string;
			FMdlFaecherErmitteln: boolean;
			FZulassung: boolean;

			FAnzLeer: integer;

			FDBFormat: string;

			FAnzahlNichtGemahnt: integer;

      FPruefOrdListe: TStringList;

//			procedure SetSchildInternDir( fInternDir: string );
//			procedure SetConSchildString( cs: string );
//			procedure SetConSchild( con: TADOConnection );
			procedure CreateMemTables;

			procedure SetPruefOrdnung( po: string );
			function Pruefen: string;
			procedure Initialisieren;
			procedure MeldungenLeeren;
			procedure MeldungenZeigen;
			function FaecherDatenHolen: boolean;
			procedure SchuelerdatenHolen;
			function SISprachenAusSprachenfolge: integer;
      function AnzahlInSprachenfolge: integer;
      procedure FC0_FC1_Zeigen;
    protected

			fC0 : TMemTableEh;
			fC1 : TMemTableEh;
			fC2 : TMemTableEh;
			fCS : TMemTableEh;		// für Sicherung
      FRefNiveaus: TStringList;

			fPruefOrdnung: string;
			fTeilPruefOrdKrz: string;
			fTeilPruefOrdLang: string;
		  fJahr, fAbschnitt: integer;
			FBK_Aktiv: boolean;
			FBK_Modus: string;		// Z: Zulassung berechnen, M: mündl. Prüfungsfächer ermitteln; A: Abschluss berechnen
			FPruefungsArt: string;		// V: Versetzung; A: Abschluss
			FSchulgliederung: string;
      FBKGliederung: TBKGliederung;
			FMeldungAktiv: boolean;
			FNachprFaecherErmitteln: boolean;
      FNPFaecher: string;
			FGrenznote: double;
			FConSchild: TADOConnection;
			FS_ID: integer;
      FA_ID: integer;
			FAnzSprachenSI: byte;
      FAnzSprachenBK: byte;

			FPraktPrfNote: integer;
			FNoteKolloquium: integer;
      FBAP_Vorhanden: boolean;
      FNoteFachpraxis: string;
      FNotePraktischePruefung: string;
			FAbgangsart: string;
			FBildungsGang: string;
			FBerufsabschluss: boolean;
			FBesteNote: double;
			FJahrgang: string;
			FFachklasse_ID: integer;
			FFachklasse: string;
			FWiederholung: boolean;
			FBK_Zulassung: string;
			FJahrgang_ID: integer;
			fZuwenigFaecher: boolean;
			FSchulform: string;
      FAnzahlAbschnitte: integer;
			FGesamtnoteGS: integer;
			FGesamtnoteNW: integer;
      FVolljaehrig: boolean;
      FInfoNichtGemahnt: string;
			FFSF: boolean;
			fMSP: boolean;
      FDauerUnterrichtseinheit: integer;
      FSPP_FachID: integer;
      FSPN_FachID: integer;
      FPONichtUnterstuetzt: TStringList;
      FTextNoten: TStringList;
      FAbbruch: boolean;
      FPrognoseIgnorieren: boolean;
      FLSEntlassart: string;
      FEntlassart: string;
      FAbschlussHierarchie: TStringList;
      function Teilpruefung: string;virtual;
			procedure VersetzungSpeichern( vers: string );
			procedure AbschlussSpeichern( const abschl: ShortInt );
			procedure Meldung( msg: string );
			function FeldWertIDs( Tabelle: TDataset; Feld, Wert: string; WertLaenge: integer ): string;
      function HauptFachID( Tabelle: TDataset ; const Feld, Fach: string ): string;
			function BesteNoteID( Tabelle: TDataset; Feld, Wert: string; IDIgnor: integer ): string;
			function BesteNoteIDAusListe( Tabelle: TDataset; const Liste: string ): string;
			procedure Uebertragen( src, dst: TDataset; ids: string );
			procedure Kopieren( src, dst: TDataset; ids: string );
      procedure DurchschnittsnoteSpeichern( const dsn: double; const fn_dsn, fn_dsn_text: string );
      procedure DurchschnittsnoteSpeichernFuerAbschnitt( const dsn: double );
			procedure AusContainerLoeschen( ds: TDataset; ids: string );
			function FeldWertAnzahl( Tabelle: TDataset ; Feld, Wert: string ): integer;
			procedure VersetzungsMeldung( const msg1: string; var msg2: string );
			function SchreibeFachNote( Tabelle: TDataset; const ID: integer ): string;
			function SchreibeFachNoteFeld( Tabelle: TDataset; const ID: integer; const Feld: string ): string;
      procedure StrAdd( const s1: string; var s2: string );
			procedure SchuelerAbschlussSpeichern( const abschl: string );
      function IstPrognose: boolean;
			procedure AusgleichsfachAusgeben( idf: string; dset: TDataset; var msg: string );
			function NoteVorhanden( Tabelle: TDataset; const Feld, Op: string; const Note: double; const IDIgnor: integer ): string;overload;
      function NoteVorhanden( Tabelle: TDataset; const Feld, Op: string; const Note: double; const Kursart: string ): string;overload;
      function NoteVorhandenAusListe( Tabelle: TDataset; const Liste, Feld, Op: string; const Note: double ): string;
			procedure FachHinzu( const FachKrz, StatKrz, FachLang, Unterichtssprache, Kursart, Note, NoteSchr,NoteMdl, NotePrfGesamt : string; const Wochenstd, Gewichtung, GewichtungFHR, Fachgruppe_ID, Fach_ID: integer; const schr, schrBA: boolean; const NoteAbschl, NoteAbschlBA, Prf10: string; const Gemahnt, IstFS: boolean );
      function AnzahlNotenBesserAls( ds: TDataset; const prfnote: integer ): integer;
      procedure MeldungenInGesamtliste;
      procedure MeldungenSpeichern;
      function IstInListe( const comp, liste: string ): boolean;
      function IstTeilInListe( const comp, liste: string ): boolean;
      function ReferenzNiveauVorhanden( const refniv: string ): boolean;
		public
			property PruefungsOrdnung: string read fPruefOrdnung;// write SetPruefOrdnung;
			property SchuelerName: string read fSchuelerName;// write fSchuelerName;
			property Jahrgang: string read fJahrgang;// write fJahrgang;
			property Schulform: string read fSchulform write FSchulform;
//			property SchildInternDir: string write SetSchildInternDir;
//			property ConnectionString: string read fConSchildString write SetConSchildString;
//			property ConSchild: TADOConnection read fConSchild write SetConSchild;
			property ProgressBar: TProgressBar read fProgress write fProgress;
			property DBFormat: string read FDBFormat write FDBFormat;
      property AnzahlAbschnitte: integer read FAnzahlAbschnitte write FAnzahlAbschnitte;
			property BK_Aktiv: boolean read FBK_Aktiv write FBK_Aktiv;
			property BK_Modus: string read FBK_Modus write FBK_Modus;
			property PruefungsArt: string read fPruefungsArt;// write fPruefungsArt;
      property DauerUnterrichtseinheit: integer read FDauerUnterrichtseinheit write FDauerUnterrichtseinheit;
			constructor Create( fInternDir: string; conschild, conint: TADOConnection );
			destructor Destroy;
			procedure Free;
			function Ausfuehren( const Leeren: boolean; SchuelerIDs: string; const Jahr, Abschnitt: integer; const von_bk_abschluss: boolean = false  ): string;
      function AusfuehrenZP10( const Leeren: boolean; const SchuelerIDs: string; const Jahr, Abschnitt: integer; const Modus: char ): string;
		end;

var
	PruefungsAlgorithmus: TPruefungsAlgorithmus;

//procedure TestePruefungsAlgorithmusEx( const SF: string; const AnzahlAbschn: integer; aconschild, aconintern: TAdoConnection; const DB_Format: string) ;

implementation

uses	SysUtils,
			RBKStrings,
			unit_SchildMisc,
			unit_SchildSettings,
			unit_Mengen,
      unit_TransactionHandler,
      unit_SchildFunktionen,
			Form_MessageList,
			Dialogs,
			StrUtils,
      Forms,
			RBkLists,
      RBKDBUtils,
			RBKGlob;
const
{$IFNDEF BWFS}
  C_MELDUNG = 'Die Versetzungs- und Abschlussberechnung ist ohne Gewähr und ersetzt nicht die Prüfung durch die betreuende Lehrkraft.';
{$ELSE}
  C_MELDUNG = 'Die Durchschnittsberechnung ist ohne Gewähr und ersetzt nicht die Prüfung durch die betreuende Lehrkraft.';
{$ENDIF}
  C_FG_ZUV = 1000;
  C_FG_ANGL = 1100;
  C_FG_FOERDER = 1400;
  C_FG_ABSCHLUSSARBEIT = 1700;
  C_FG_DIFFBEREICH = 30;


{procedure TestePruefungsAlgorithmusEx( const SF: string; const AnzahlAbschn: integer; aconschild, aconintern: TAdoConnection; const DB_Format: string) ;
begin
	if not Assigned( PruefungsAlgorithmus ) then
	begin
		PruefungsAlgorithmus := TPruefungsAlgorithmus.Create( RBKAdminDir + '\Keytabs', aconschild, aconintern );
		PruefungsAlgorithmus.Schulform := SF;
		PruefungsAlgorithmus.AnzahlAbschnitte := AnzahlAbschn;
	end;
	PruefungsAlgorithmus.DBFormat := DB_Format;
end;}


procedure TPruefungsAlgorithmus.StrAdd( const s1: string; var s2: string );
begin
	if pos( s1, s2 ) <= 0 then
		s2 := s2 + s1;
end;


constructor TPruefungsAlgorithmus.Create( fInternDir: string; conschild, conint: TADOConnection );
var
  fn, cmd: string;
begin
	FDBFormat := 'MSACCESS';
	fProgress := nil;
	fExternalConnection := false;
	fC0 := nil;
	fC1 := nil;
	fC2 := nil;
	fCS := nil;
	slMsg := TStringList.Create;
	slMsgGes := TStringList.Create;
	if conint = nil then
	begin
		fConIntern := TADOConnection.Create( nil );
		with fConIntern do
		begin
			LoginPrompt := false;
			CursorLocation :=	clUseClient;
			ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' +
													fInternDir + '\Schildintern.mdb;Persist Security Info=False;Jet OLEDB:Database Password=' + LoadSchild2000Pwd;
		end;
		FConInternFromOutside := false;
	end else
	begin
		FConIntern := conint;
		FConInternFromOutside := true;
	end;

	cmd := 'SELECT * FROM ZusatzInfos';
{$IFDEF UNIDAC}
	fQryFachGr := CreateReadOnlyDataset( fConIntern );
  fQryFachgr.SQL.Text := cmd;
	fQryP := CreateForwardDataset( fConIntern );
{$ELSE}
	fQryFachGr := CreateReadOnlyDataset( fConIntern, SchildSettings.StatistikDBZentral );
  fQryFachgr.CommandText := cmd;

	fQryP := CreateForwardDataset( fConIntern, SchildSettings.StatistikDBZentral );
{$ENDIF}
  with fQryFachGr do
	begin
		FSGL_BKAbschl := '';
		FJG_BKAbschl := '';
		Open;
		while not EOF do
		begin
			if FSGL_BKAbschl <> '' then
			begin
				FSGL_BKAbschl := FSGL_BKAbschl + ';';
				FJG_BKAbschl := FJG_BKAbschl + ';';
			end;
			FSGL_BKAbschl := FSGL_BKAbschl + FieldByname( 'SGL_BKAbschl' ).AsString;
			FJG_BKAbschl := FJG_BKAbschl + FieldByname( 'JG_BKAbschl' ).AsString;
			Next;
		end;
		Close;
		CommandText := 'SELECT Fach, FachGruppeKrz FROM FaecherSortierung ORDER BY Fach';
	end;
	fPruefungsArt := 'V';  // Versetzung ist default
	fMeldungAktiv := true;
	fZuwenigFaecher := false;

  if conschild = nil then
  begin

  end else
  begin
    fConSchild := conschild;
    fExternalConnection := true;
{$IFDEF UNIDAC}
    fQryS := CreateReadOnlyDataset( fConSchILD );
    fQryF := CreateForwardDataset( fConSchILD );

    fQryAbschl := CreateReadOnlyDataset( fConSchILD );
    fQryAbschl.SQL.Text := 'SELECT AbschlussArt, Abschluss FROM SchuelerLernabschnittsdaten WHERE ID=:ID';
    fQryAbschl.Params[0].DataType := ftInteger;

    fQryJG := CreateReadOnlyDataset( fConSchILD );
    fQryJG.SQL.Text := 'select ASDJahrgang from EigeneSchule_Jahrgaenge where ID=:ID';
    fQryJG.Params[0].DataType := ftInteger;
{$ELSE}
    fQryS := CreateReadOnlyDataset( fConSchILD, SchildSettings.DBFormat <> 'MSACCESS' );
    fQryF := CreateForwardDataset( fConSchILD, SchildSettings.DBFormat <> 'MSACCESS' );

    fQryAbschl := CreateReadOnlyDataset( fConSchILD, SchildSettings.DBFormat <> 'MSACCESS' );
    fQryAbschl.CommandText := 'SELECT AbschlussArt, Abschluss FROM SchuelerLernabschnittsdaten WHERE ID=:ID';
    fQryAbschl.Parameters[0].DataType := ftInteger;

    fQryJG := CreateReadOnlyDataset( fConSchILD, SchildSettings.DBFormat <> 'MSACCESS' );
    fQryJG.CommandText := 'select ASDJahrgang from EigeneSchule_Jahrgaenge where ID=:ID';
    fQryJG.Parameters[0].DataType := ftInteger;
{$ENDIF}
  end;

	fGrenzNote := 4;

  FTextNoten := TStringList.Create;
  with FTextNoten do
  begin
    Add( 'AT' );
    Add( 'E1' );
    Add( 'E2' );
    Add( 'E3' );
  end;

  FPruefOrdListe := TStringList.Create;
  FPruefOrdListe.Delimiter := ';';

  FPONichtUnterstuetzt := TStringList.Create;
  FRefNiveaus := TStringList.Create;

  FAbschlussHierarchie := TStringList.Create;
  fn := ExtractFilePath( Application.Exename ) + 'BKAbschlussHierarchie.txt';
  if FileExists( fn ) then
    FAbschlussHierarchie.LoadFromFile( fn );


end;

destructor TPruefungsAlgorithmus.Destroy;
begin
	FreeAndNil( slMsg );
	FreeAndNil( slMsgGes );

	if Assigned( fC0 ) then
		FreeAndNil( fC0 );
	if Assigned( fC1 ) then
		FreeAndNil( fC1 );
	if Assigned( fC2 ) then
		FreeAndNil( fC2 );
	if Assigned( fCS ) then
		FreeAndNil( fCS );

	if not fExternalConnection then
	begin
		if Assigned( fConSchild ) then
			FreeAndNil( fConSchild );
	end;
	FreeAndNil( fQryFachGr );
	FreeAndNil( fQryS );
	FreeAndNil( fQryF );
	FreeAndNil( fQryP );
	FreeAndNil( fQryAbschl );
	if not FConInternFromOutside then
		FreeAndNil( fConIntern );
  FreeAndNil( FTextNoten );
  FreeAndNil( FPruefOrdListe );
  FreeAndNil( FPONichtUnterstuetzt );
  FreeAndNil( FRefNiveaus );
  FreeAndNil( FAbschlussHierarchie );
end;

procedure TPruefungsAlgorithmus.Free;
begin
	if self <> nil then
		Destroy;
end;

function TPruefungsAlgorithmus.IstInListe( const comp, liste: string ): boolean;
begin
  FPruefOrdListe.Clear;
  FPruefOrdListe.DelimitedText := liste;
  Result := FPruefOrdListe.IndexOf( comp ) >= 0;
end;

function TPruefungsAlgorithmus.IstTeilInListe( const comp, liste: string ): boolean;
var
  i: integer;
  teil: string;
begin
  Result := false;
  for i := 1 to NumToken( liste, ';' ) do
  begin
    teil := GetToken( liste, ';', i );
    Result := AnsiStartsText( teil, comp );
    if Result then
      exit;
  end;
end;


{procedure TPruefungsAlgorithmus.SetConSchild( con: TADOConnection );
begin
  fConSchild := con;
  fExternalConnection := true;
  if not Assigned( fQryS ) then
  	fQryS := CreateReadOnlyDataset( fConSchILD, SchildSettings.DBFormat <> 'MSACCESS' );
  if not Assigned( fQryF ) then
	  fQryF := CreateReadOnlyDataset( fConSchILD, SchildSettings.DBFormat <> 'MSACCESS' );

  if not Assigned( fQryAbschl ) then
  	fQryAbschl := CreateReadOnlyDataset( fConSchILD, SchildSettings.DBFormat <> 'MSACCESS' );

  if not Assigned( fQryF ) then
  begin
  	fQryJG := CreateReadOnlyDataset( fConSchILD, SchildSettings.DBFormat <> 'MSACCESS' );
	  fQryJG.CommandText := 'select ASDJahrgang from EigeneSchule_Jahrgaenge where ID=:ID';
	  fQryJG.Parameters[0].DataType := ftInteger;
  end;


end;}

{procedure TPruefungsAlgorithmus.SetConSchildString( cs: string );
begin
	if not Assigned( fConSchild ) then
	begin
		fConSchild := TADOConnection.Create( nil );
		fExternalConnection := false;
	end;
	with fConSchild do
	begin
		Connected := false;
		LoginPrompt := false;
		ConnectionString := cs;

		if pos( 'Microsoft.Jet.OLEDB.4.0', cs ) > 0 then
			CursorLocation :=	clUseServer
		else
			CursorLocation :=	clUseClient;
	end;

  SetConSchild( fConSchild );

end;}

{procedure TPruefungsAlgorithmus.SetSchildInternDir( fInternDir: string );
begin
	with fConIntern do
	begin
		Connected := false;
		ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' +
												fInternDir + '\Schildintern.mdb;Persist Security Info=False;Jet OLEDB:Database Password=' + LoadSchild2000Pwd;
	end;
end;}

procedure TPruefungsAlgorithmus.SetPruefOrdnung( po: string );
begin
	fPruefOrdnung := po;
	if po = '' then
		Meldung( 'Versetzungsberechnung nicht möglich' );
end;


procedure TPruefungsAlgorithmus.Initialisieren;
begin
	if not Assigned( fC0 ) then
		CreateMemTables;

	if not fC0.Active then
		fC0.Open;
	if not fC1.Active then
		fC1.Open;
	if not fC2.Active then
		fC2.Open;
	if not fCS.Active then
		fCS.Open;


	fC0.EmptyTable;
	fC1.EmptyTable;
	fC2.EmptyTable;
	fCS.EmptyTable;
	fMaxID := 0;
	fFSF := false;
	fPrfOrdDone := false;
	fZuWenigFaecher := false;
	fNachprFaecherErmitteln := false;
end;


function TPruefungsAlgorithmus.IstPrognose: boolean;
var
  ende: boolean;
begin
  if FPrognoseIgnorieren then
  begin
    Result := false;
    exit;
  end;
  ende := FAbschnitt = FAnzahlAbschnitte;
  Result := ( FSchulform = 'GE' ) and ( ( FJahrgang = '09' ) or ( ( FJahrgang = '10' ) and not ende ) );
end;

procedure TPruefungsAlgorithmus.MeldungenInGesamtliste;
var
  i: integer;
begin
  if slMsg.Count = 0 then
    exit;
	if slMsgGes.Count > 0 then
		slMsgGes.Add( '' )		// Leerzeile in Ausgabepuffer
  else
    slMsgGes.Add( C_MELDUNG );
  for i := 0 to slMsg.Count - 1 do
    slMsgGes.Add( slMsg[i] );
  slMsg.Clear;

end;

procedure TPruefungsAlgorithmus.MeldungenSpeichern;
var
  cmd: string;
begin
  slMsg.Insert( 0, Format( 'Datum: %s', [ DateTimeToStr( now ) ] ) );
  slMsg.Insert( 0, C_MELDUNG );
  cmd := Format( 'update SchuelerLernabschnittsdaten set PruefAlgoErgebnis=%s where ID=%d', [ QuotedStr( slMsg.Text ), FA_ID ] );
  TransactionHandler.DoExecute( cmd );
  slMsg.Delete( 0 );

end;

function TPruefungsAlgorithmus.Ausfuehren( const Leeren: boolean; SchuelerIDs: string; const Jahr, Abschnitt: integer; const von_bk_abschluss: boolean = false  ): string;
var
	vers: string;
	i : integer;

begin
	Result := '';
	fJahr := Jahr;
	fAbschnitt := Abschnitt;
	if Leeren then
		MeldungenLeeren;
	if Assigned( fProgress ) then
	begin
		fProgress.Max := NumToken( SchuelerIDs, ',' );
		fProgress.Position := 0;
	end;
	for i := 1 to NumToken( SchuelerIDs, ',' ) do
	begin
		if Assigned( fProgress ) then
			fProgress.Position := fProgress.Position + 1;
		fS_ID := StrToInt( GetToken( SchuelerIDs, ',', i ) );
		SchuelerDatenHolen;

    if not von_bk_abschluss and FIst_BKAbschl then
    begin
      Meldung( 'Bitte führen Sie die Berechnung auf den Karteireitern "BK-Abschluss" aus' );
    end else
    begin
      if fPruefOrdnung <> '' then
        vers := Pruefen
      else
      begin
        vers := '?';
        Meldung( ' ' );
      end;
    end;
    MeldungenSpeichern;
    MeldungenInGesamtListe;
    Application.ProcessMessages;
	end;
	if Assigned( fProgress ) then
		fProgress.Position := 0;

	MeldungenZeigen;

end;

procedure TPruefungsAlgorithmus.SchuelerDatenHolen;
var
	i : integer;
begin
	fNameDone := false;
  fPrfOrdDone := false;
	fIstVersetzt := false;
	fQryS.Close;
  FPONichtUnterstuetzt.Clear;

	FIst_BK := ( fSchulform = 'BK' ) or ( fSchulform = 'SB' );

// den Namen des Schülers ermitteln
{$IFDEF UNIDAC}
	fQryS.SQL.Text := 'SELECT ID, Name, Vorname, Berufsabschluss, Jahrgang_ID, ASDSchulform, Fachklasse_ID, Klasse, Volljaehrig, LSEntlassart, Entlassart FROM Schueler WHERE ID=' + IntToStr( fS_ID );
{$ELSE}
	fQryS.CommandText := 'SELECT ID, Name, Vorname, Berufsabschluss, Jahrgang_ID, ASDSchulform, Fachklasse_ID, Klasse, Volljaehrig, LSEntlassart, Entlassart FROM Schueler WHERE ID=' + IntToStr( fS_ID );
{$ENDIF}
	fQryS.Open;
	fSchuelerName := fQryS.FieldByname( 'Name' ).AsString + ', ' + fQryS.FieldByname( 'VorName' ).AsString +
									 ' (' + fQryS.FieldByname( 'Klasse' ).AsString + ')';
	FBerufsabschluss := fQryS.FieldByname( 'Berufsabschluss' ).AsString = '+';
  FVolljaehrig := fQryS.FieldByname( 'Volljaehrig' ).AsString = '+';
	FJahrgang_ID := fQryS.FieldByname( 'Jahrgang_ID' ).AsInteger;
  FLSEntlassart := fQryS.FieldByname( 'LSEntlassart' ).AsString;
  FEntlassart := fQryS.FieldByname( 'Entlassart' ).AsString;

// Jahrgang und Prüfungsordnung ermitteln
	fQryS.Close;
{$IFDEF UNIDAC}
	fQryS.SQL.Text := 'SELECT * FROM SchuelerLernabschnittsdaten' +
										' WHERE Schueler_ID=' + IntToStr( fS_ID ) +
										' AND Jahr=' + IntTosTr( fJahr ) + ' AND Abschnitt=' + IntToStr( fAbschnitt );
{$ELSE}
	fQryS.CommandText := 'SELECT * FROM SchuelerLernabschnittsdaten' +
										' WHERE Schueler_ID=' + IntToStr( fS_ID ) +
										' AND Jahr=' + IntTosTr( fJahr ) + ' AND Abschnitt=' + IntToStr( fAbschnitt );
{$ENDIF}
	fQryS.Open;
	fPruefOrdnung := fQryS.FieldByname( 'PruefOrdnung' ).AsString;

{$IFDEF BWFS}
  fPruefOrdnung := 'PO_BWFS';
  fTeilPruefOrdKrz := 'PO_BWFS';
{$ENDIF}
	fA_ID := fQryS.FieldByname( 'ID' ).AsInteger;

{$IFDEF UNIDAC}
  fQryJG.Close;
	fQryJG.Params[0].AsInteger := FJahrgang_ID;
	fQryJG.Open;
{$ELSE}
	fQryJG.Parameters[0].Value := FJahrgang_ID;
	fQryJG.Requery;
{$ENDIF}
	fJahrgang := fQryJG.FieldByname( 'ASDJahrgang' ).AsString;

	fKlassenart := fQryS.FieldByname( 'Klassenart' ).AsString;
	fGesamtnoteGS := fQryS.FieldByname( 'Gesamtnote_GS' ).AsInteger;
	fGesamtnoteNW := fQryS.FieldByname( 'Gesamtnote_NW' ).AsInteger;
	FWiederholung := fQryS.FieldByname( 'Wiederholung' ).AsString = '+';
	FSchulgliederung := fQryS.FieldByname( 'ASDSchulgliederung' ).AsString;
	FFachklasse_ID := fQryS.FieldByname( 'Fachklasse_ID' ).AsInteger;

//NEU Schulform anpassen
  if FSchulform = 'GE' then
  begin
    if AnsiStartsText( 'R', FSchulgliederung ) then
      FSchulform := 'R'
    else if AnsiStartsText( 'H', FSchulgliederung ) then
      FSchulform := 'H';
  end;

  if not( ( fSchulform = 'BK' ) or ( FSchulform = 'SB' ) or ( FSchulform = 'WB' ) ) then
  begin  //allgemein-bildende Schulen
    if ( FSchulgliederung = '***' ) or ( FSchulgliederung = '' ) then
      FSchulgliederung := FSchulform
    else if FSchulgliederung[1] =  FSchulform[1] then
      FSchulgliederung := FSchulform
    else
      FSchulgliederung := StringReplace( FSchulgliederung, '*', '', [ rfReplaceAll ] );
  end else if fSchulform = 'WB' then
  begin
		if FSchulgliederung = 'K02' then
			FSchulGliederung := 'KL'
		else if FSchulgliederung = 'G02' then
			FSchulGliederung := 'AG'
		else if FSchulgliederung = 'R02' then
			FSchulGliederung := 'AR';
  end;

  FBKGliederung := BK_Gliederung( FSchulGliederung );

	fQryS.Close;

  if FIst_BK then
    FachEigenschaften.GliederungFachklasseSetzen( FSchulgliederung, FFachklasse_ID );

	if FFachklasse_ID <> 0 then
	begin
{$IFDEF UNIDAC}
		fQryS.SQL.Text := Format( 'SELECT * FROM EigeneSchule_Fachklassen WHERE ID=%d', [ FFachklasse_ID ] );
{$ELSE}
		fQryS.CommandText := Format( 'SELECT * FROM EigeneSchule_Fachklassen WHERE ID=%d', [ FFachklasse_ID ] );
{$ENDIF}
		fQryS.Open;
		FFachklasse := fQryS.FieldByName( 'FKS' ).AsString + fQryS.FieldByName( 'AP' ).AsString;
		fQryS.Close;
	end;

	FIst_BKAbschl := false;
	for i := 1 to NumToken( FSGL_BKAbschl, ';' ) do
	begin
		if ( GetToken( FSGL_BKAbschl, ';', i ) = FSchulgliederung ) and
			 ( GetToken( FJG_BKAbschl, ';', i ) = FJahrgang )	then
		begin
			FIst_BKAbschl := true;
			break;
		end;
	end;

	if ( fJahrgang = '12' ) or ( fJahrgang = '13' ) or ( fJahrgang = 'Q1' ) or ( fJahrgang = 'Q2' ) then
	begin
		fTeilPruefOrdLang := fPruefOrdnung;
		Meldung( 'Bitte verwenden Sie die Kartei-Seite "Abitur" oder "FHR".' );
		exit;
	end;


// Eingangsqualifikation ermitteln
	if FIst_BK then
	begin
		if FIst_BKAbschl then// Zugriff auf Extra-Tabelle
		begin
{$IFDEF UNIDAC}
			fQryS.SQL.Text := 'SELECT * FROM SchuelerBKAbschluss WHERE Schueler_ID=' + IntToStr( fS_ID );
{$ELSE}
			fQryS.CommandText := 'SELECT * FROM SchuelerBKAbschluss WHERE Schueler_ID=' + IntToStr( fS_ID );
{$ENDIF}
			fQryS.Open;
			FZulassung := fQryS.FieldByname( 'Zulassung' ).AsString = '+';
			try
				FPraktPrfNote := fQryS.FieldByname( 'PraktPrfNote' ).AsInteger;
			except
				FPraktPrfNote := 999;
			end;
			try
				FNoteKolloquium := fQryS.FieldByname( 'NoteKolloquium' ).AsInteger;
			except
				FNoteKolloquium := 999;
			end;

      FBAP_Vorhanden := fQryS.FieldByname( 'BAP_Vorhanden' ).AsString = '+';
      FNoteFachpraxis := fQryS.FieldByname( 'NoteFachpraxis' ).AsString;
      FNotePraktischePruefung := fQryS.FieldByname( 'PraktPrfNote' ).AsString;

			fQryS.Close;
		end;
	end;
end;

function TPruefungsAlgorithmus.AnzahlInSprachenfolge: integer;
begin
	Result := 0;
	with fQryF do
	begin
		Close;
{$IFDEF UNIDAC}
		SQL.Text := 'SELECT Count( * ) as Anzahl FROM SchuelerSprachenfolge WHERE Schueler_ID=' + IntToStr( fS_id );
{$ELSE}
		CommandText := 'SELECT Count( * ) as Anzahl FROM SchuelerSprachenfolge WHERE Schueler_ID=' + IntToStr( fS_id );
{$ENDIF}
		Open;
    Result := FieldByName( 'Anzahl' ).AsInteger;
    Close;
  end;
end;

function TPruefungsAlgorithmus.SISprachenAusSprachenfolge: integer;
begin
	Result := 0;

  FAnzSprachenBK := 0;
  FSPP_FachID := -1; // ID des Sprachfaches, bei dem eine Prüfung gemacht wurde
  FSPN_FachID := -1; //
	with fQryF do
	begin
		Close;
{$IFDEF UNIDAC}
		SQL.Text := 'SELECT SF.*, F.StatistikKrz FROM SchuelerSprachenfolge SF, EigeneSchule_Faecher F' +
								' WHERE Schueler_ID=' + IntToStr( fS_id ) + ' AND F.ID=SF.Fach_ID';
{$ELSE}
		CommandText := 'SELECT SF.*, F.StatistikKrz FROM SchuelerSprachenfolge SF, EigeneSchule_Faecher F' +
								' WHERE Schueler_ID=' + IntToStr( fS_id ) + ' AND F.ID=SF.Fach_ID';
{$ENDIF}
		Open;
    FRefNiveaus.Clear;
		while not EOF do
		begin
      if ( FieldByname( 'Referenzniveau' ).AsString <> '' ) and ( FRefNiveaus.IndexOf( FieldByname( 'Referenzniveau' ).AsString ) < 0 ) then
        FRefNiveaus.Add( FieldByname( 'Referenzniveau' ).AsString );
      if FieldByname( 'Reihenfolge' ).AsString = 'P' then
        FSPP_FachID := FieldByname( 'Fach_ID' ).AsInteger
      else if FieldByname( 'Reihenfolge' ).AsString = 'N' then
        FSPN_FachID := FieldByname( 'Fach_ID' ).AsInteger;

      inc(  FAnzSprachenBK );

      if FSchulform = 'WB' then
      begin // Im WBK wird nach der Reihenfolge gegangen
        if FieldByname( 'Reihenfolge' ).AsString = '1' then
        begin
          if fC0.Locate( 'FremdspracheKrz', copy( FieldByname( 'StatistikKrz' ).AsString, 1, 1 ), [] ) then
          begin
            fC0.Edit;
            fC0.FieldByName( 'FachgruppeIntern' ).AsString := 'FSI';	// Fremdsprache aus SekI
            fC0.FieldByname( 'BeginnJahrgang' ).AsInteger := 5;
            fC0.Post;
            inc( Result );
// Wichtig: Die Änderungen auch in der "Sicherungsmenge" machen
            FCS.Locate('ID', FC0.FieldByname( 'ID' ).AsInteger, [] );
            FCS.Edit;
            RBKCopyRecord( fC0, fCS );
            FCS.Post;
            break;
          end;
        end;
      end else
      begin
        if ( FieldByName( 'JahrgangVon' ).AsInteger < 10 ) then
        begin		// Eine SI-Sprache
          if fC0.Locate( 'FremdspracheKrz', copy( FieldByname( 'StatistikKrz' ).AsString, 1, 1 ), [] ) then
          begin		// Sprache in SII vorhanden
            if fC0.FieldByName( 'BeginnJahrgang' ).AsInteger = 0 then 	// hat aber keinen Jahrgang
            begin
              fC0.Edit;
              fC0.FieldByName( 'FachgruppeIntern' ).AsString := 'FSI';	// Fremdsprache aus SekI
              if ( FSchulform = 'GY' ) or ( FSchulform = 'GE' ) then
              begin
                if FieldByName( 'JahrgangVon' ).AsInteger = 8 then	// Sprache aus 8
                  fC0.FieldByName( 'FachgruppeIntern2' ).AsString := 'FS89';	// Fremdsprache aus 9
              end else
              begin
                if FieldByName( 'JahrgangVon' ).AsInteger = 9 then	// Sprache aus 9
                  fC0.FieldByName( 'FachgruppeIntern2' ).AsString := 'FS89';	// Fremdsprache aus 9
              end;
              fC0.FieldByname( 'BeginnJahrgang' ).AsInteger := FieldByname( 'JahrgangVon' ).AsInteger;
              fC0.Post;
              inc( Result );
  // Wichtig: Die Änderungen auch in der "Sicherungsmenge" machen
              FCS.Locate('ID', FC0.FieldByname( 'ID' ).AsInteger, [] );
              FCS.Edit;
              RBKCopyRecord( fC0, fCS );
              FCS.Post;
            end;
          end else		// das Fach wurde nicht mehr weiter geführt, trotzdem gilt es als SI-Sprache
            inc( Result );
        end;

        if fSchulform = 'BK ' then
        begin  // Spezialfall für D01
          if fC0.Locate( 'FremdspracheKrz', copy( FieldByname( 'StatistikKrz' ).AsString, 1, 1 ), [] ) then
          begin
            fC0.Edit;
            fC0.FieldByName( 'Reihenfolge' ).AsString := FieldByName( 'Reihenfolge' ).AsString;
            fC0.Post;
          end;
        end;

      end;
			Next;
		end;
		Close;
	end;
end;


function TPruefungsAlgorithmus.FaecherDatenHolen: boolean;
var
	a_id: integer;
	jg, fg: integer;
	sk : string;

	function SpracheBeginnJahrgang( f_id: integer ): integer;
	var
		jg: integer;
	begin
		with fQryF do
		begin
			Close;
{$IFDEF UNIDAC}
			SQL.Text := 'SELECT * FROM SchuelerSprachenfolge WHERE Schueler_ID=' + IntToStr( fS_id ) +
									' AND Fach_ID=' + IntToStr( f_id );

{$ELSE}
			CommandText := 'SELECT * FROM SchuelerSprachenfolge WHERE Schueler_ID=' + IntToStr( fS_id ) +
									' AND Fach_ID=' + IntToStr( f_id );
{$ENDIF}
			Open;
			if IsEmpty then
				Result := -1
			else
			begin
				if FieldByName( 'Reihenfolge' ).AsString = 'P' then		// Sprachprüfung
				begin
					jg := FieldByName( 'JahrgangBis' ).AsInteger;	// Bei Sprachprüfungen muss der BisJahrgang eingetragen werden
					if jg > 0 then
					begin
						if jg <= 11 then
							inc( fAnzSprachenSI );	// "Mehrsprachler"-Flag setzen, hier gilt auch 11 als SI!!!
						Result := 5;		// Für weitere Behandlung wie Jahrgang 5
					end else
						Result := -1;		// kein Jahrgang eingetragen
				end else
				begin		// Normale Sprachfolge
					jg := FieldByName( 'JahrgangVon' ).AsInteger;
					if jg > 9 then
						jg := jg - 10		// auf einstellige Zahl bringen
					else if jg in [2,3,4] then	// kann u.U. in WBK vorkommen
						jg := 5;
					if jg <= 10 then
						inc( fAnzSprachenSI );	// "Mehrsprachler"-Flag setzen
					Result := jg;
				end;
			end;
			Close;
		end;
	end;


var
	prf10, cmd: string;
	warnung, zp10fach, hinzu, ist_fs, ist_schr_ba: boolean;
	gewicht, gewicht_fhr : integer;
	fach, nmdl, npges, nabschl, nabschl_ba, notekrz: string;
begin
	FAnzahlNichtGemahnt := 0;
  FNPFaecher := '';
	fAnzSprachenSI := 0;		// Anzahl der Fremd-Sprachen in SI
	FAnzLeer := 0;
	fQryF.Close;
	try
		Initialisieren;

    fQryS.Close;
    cmd := '';
		if fPruefOrdnung = 'ZP10' then
		begin
			cmd := 'SELECT L.Fach_ID, L.Vornote as NotenKrz,L.FachSchriftlich, L.FachSchriftlichBA, L.NoteSchriftlich, L.NoteMuendlich, L.MdlPruefung, L.MdlPruefungFW, L.NotePrfGesamt, L.NoteAbschluss, L.NoteAbschlussBA,' +
												'F.IstSprache, F.IstSchriftlich, F.FachKrz, F.StatistikKrz, F.Zeugnisbez, F.Unterichtssprache, F.Fachgruppe_ID' +
												' FROM SchuelerBKFaecher L, EigeneSchule_Faecher F' +
												' WHERE L.Schueler_ID=' + IntToStr( fS_ID ) + ' AND F.ID=L.Fach_ID ORDER BY F.Sortierung';
		end else if fPruefOrdnung <> '' then
		begin
// die Fächer holen
			if FIst_BKAbschl then// Zugriff auf Extra-Tabelle
			begin
{				if SchildSettings.ZeigeGewichtung then
					cmd := Format( 'SELECT L.Fach_ID, L.Vornote as NotenKrz,L.FachSchriftlich, L.FachSchriftlichBA, L.NoteSchriftlich, L.NoteMuendlich, L.MdlPruefung, L.MdlPruefungFW, L.NotePrfGesamt,L.NoteAbschluss, L.NoteAbschlussBA,' +
													'F.IstSprache, F.FachKrz, F.StatistikKrz, F.Zeugnisbez, F.Unterichtssprache, F.Fachgruppe_ID, F.Gewichtung as FachGewichtung, F.GewichtungFHR as FachGewichtungFHR, LL.Gewichtung' +
													' FROM SchuelerBKFaecher L, EigeneSchule_Faecher F, SchuelerLeistungsdaten LL' +
													' WHERE L.Schueler_ID=%d AND F.ID=L.Fach_ID' +
													' AND LL.Abschnitt_ID=%d AND LL.Fach_ID=L.Fach_ID	AND LL.SchulnrEigner=%d ORDER BY F.SortierungS2',
													 [ fS_ID, fA_ID, SchildSettings.Schulnr  ] )
				else}
					cmd := Format( 'SELECT L.Fach_ID, L.Vornote as NotenKrz,L.FachSchriftlich, L.FachSchriftlichBA, L.NoteSchriftlich, L.NoteMuendlich, L.MdlPruefung, L.MdlPruefungFW, L.NotePrfGesamt,L.NoteAbschluss, L.NoteAbschlussBA,' +
													'F.IstSprache, F.FachKrz, F.StatistikKrz, F.Zeugnisbez, F.Unterichtssprache, F.Fachgruppe_ID, F.Gewichtung as FachGewichtung, F.GewichtungFHR as FachGewichtungFHR' +
													' FROM SchuelerBKFaecher L, EigeneSchule_Faecher F' +
													' WHERE L.Schueler_ID=%d AND F.ID=L.Fach_ID ORDER BY F.SortierungS2',
													 [ fS_ID, fA_ID ] );
			end else
			begin
				if FIst_BK  then	// Bei BK auch abgeschlossene Fächer berücksichtigen
					cmd := Format( 'SELECT L.*, F.IstSprache, F.FachKrz, F.StatistikKrz, F.Zeugnisbez, F.Unterichtssprache, F.Fachgruppe_ID, F.Gewichtung as FachGewichtung, F.GewichtungFHR as FachGewichtungFHR' +
														' FROM SchuelerLeistungsdaten L, EigeneSchule_Faecher F' +
														' WHERE L.Hochrechnung<=0 AND L.Abschnitt_ID=%d AND L.AufZeugnis=%s and L.SchulnrEigner=%d' +
                            ' AND F.ID=L.Fach_ID ORDER BY L.Sortierung',
                            [ fA_ID, QuotedStr( '+' ), SchildSettings.Schulnr ] )
				else
					cmd := Format( 'SELECT L.*, F.IstSprache, F.FachKrz, F.StatistikKrz, F.Zeugnisbez, F.Unterichtssprache, F.Fachgruppe_ID, F.Gewichtung as FachGewichtung, F.GewichtungFHR as FachGewichtungFHR' +
														' FROM SchuelerLeistungsdaten L, EigeneSchule_Faecher F' +
														' WHERE L.Hochrechnung=0 AND L.Abschnitt_ID=%d AND L.AufZeugnis=%s AND L.SchulnrEigner=%d' +
                            ' AND F.ID=L.Fach_ID ORDER BY L.Sortierung',
                            [ fA_ID, QuotedStr( '+' ), SchildSettings.Schulnr ] );
			end;
		end;

		if cmd <> '' then
		begin
{$IFDEF UNIDAC}
      fQryS.SQL.Text := cmd;
{$ELSE}
      fQryS.CommandText := cmd;
{$ENDIF}
			fQryS.Open;
			fQryS.First;
			while not fQryS.EOF do
			begin
				sk := fQryS.FieldByName( 'StatistikKrz' ).AsString;	// Statistik-Kürzel des Faches
        ist_fs := false;
				if not FIst_BK and ( fQryS.FieldByName( 'IstSprache' ).AsString = '+' ) then
				begin // es handelt sich um eine Fremdsprache
          ist_fs := true;
					if ( length( sk ) = 1 ) then
					begin	// Sprachfach, aber ohne Angabe der Jahrganges
						jg := SpracheBeginnJahrgang( fQryS.FieldByName( 'Fach_ID' ).AsInteger );		// Den Beginn-JG aus den Sprachfolgen holen
						if jg > 0 then
							sk := sk + IntToStr( jg );		// Jahrgang zum Kürzel hinzufügen
					end else
					begin		// Sprachfach mit Jahrgangsangabe
						try
							jg := StrToInt( sk[2] );
							if jg <= 10 then
								inc( fAnzSprachenSI );	// "Mehrsprachler"-Flag setzen
						except
							sk := '';
						end;
					end;
				end;
// Keine "Zusätzlichen Unterrichtsveranstaltungen", "Förderunterricht" und "Angleichungskurse"
				fg := fQryS.FieldByName( 'Fachgruppe_ID' ).AsInteger;

        if FSchulform = 'WB' then
          hinzu := true
        else
          hinzu := ( sk <> '' ) and ( fg <> C_FG_ZUV ) and ( fg <> C_FG_ANGL ) and ( fg <> C_FG_FOERDER );
        if hinzu then
				begin
					try
            if fQryS.FindField( 'Warnung' ) <> nil then
  						warnung := ( fQryS.FieldByName( 'Warnung' ).AsString = '+' )
            else
              warnung := false;
					except
						warnung := false;
					end;

					if FIst_BKAbschl then
					begin // auf Seite "BK-Abschluss", hierzu zählt auch ZP10
						if ( ( fQryS.FieldByname( 'MdlPruefung' ).AsString = '+' ) or ( fQryS.FieldByname( 'MdlPruefungFW' ).AsString = '+' ) ) and ( fQryS.FieldByname( 'NoteMuendlich' ).AsString = '' ) then
							nmdl := '?'
						else
							nmdl := Trim( fQryS.FieldByname( 'NoteMuendlich' ).AsString );

						if ( fQryS.FieldByname( 'FachSchriftlich' ).AsString = '+' ) and ( fQryS.FieldByname( 'NotePrfGesamt' ).AsString = '' ) then
							npges := '?'
						else
							npges := Trim( fQryS.FieldByname( 'NotePrfGesamt' ).AsString );

// Für die ZP10 auch die Abschlussnote berücksichtigen
						if fPruefOrdnung = 'ZP10' then
						begin
							if fQryS.FieldByname( 'NoteAbschluss' ).AsString = '' then
								nabschl := '?'
							else
								nabschl := fQryS.FieldByname( 'NoteAbschluss' ).AsString;
							if fQryS.FieldByname( 'NoteAbschlussBA' ).AsString = '' then
								nabschl_ba := '?'
							else
								nabschl_ba := fQryS.FieldByname( 'NoteAbschlussBA' ).AsString;
							prf10 := '-';
						end else
						begin
//							nabschl := '';
//							nabschl_ba := '';
							if fQryS.FieldByname( 'NoteAbschluss' ).AsString = '' then
								nabschl := '?'
							else
								nabschl := fQryS.FieldByname( 'NoteAbschluss' ).AsString;
							if fQryS.FieldByname( 'NoteAbschlussBA' ).AsString = '' then
								nabschl_ba := '?'
							else
								nabschl_ba := fQryS.FieldByname( 'NoteAbschlussBA' ).AsString;
							prf10 := '-';
						end;

            gewicht := 1;
    				gewicht_fhr := 0;
            if FIst_BK then
            begin
              try
//                if SchildSettings.ZeigeGewichtung then
//                  gewicht := fQryS.FieldByName( 'Gewichtung' ).AsInteger
//                else
                  gewicht := FachEigenschaften.GewichtungBB( fQryS.FieldByName( 'Fach_ID' ).AsInteger );
              except
              end;
  						try
    						gewicht_fhr := FachEigenschaften.GewichtungAB( fQryS.FieldByName( 'Fach_ID' ).AsInteger );
		  				except
				  		end;
            end;

            fach := fQryS.FieldByName( 'FachKrz' ).AsString;

            notekrz := Trim( fQryS.FieldByName( 'NotenKrz' ).AsString );
            if FBKGliederung in [ glA01, glA03, glA05, glA06, glA07, glA12, glA13, glB06, glB07 ] then
            begin
              notekrz := nabschl_ba;
              nabschl_ba := '';
            end;

            ist_schr_ba := ( fQryS.FieldByname( 'FachSchriftlichBA' ).AsString = '+' ) and (
                            ( FSchulGliederung = 'C01' )  or ( FSchulgliederung = 'D01' ) );

						FachHinzu( fach,
										 sk,
										 Trim( fQryS.FieldByName( 'Zeugnisbez' ).AsString ),
										 Trim( fQryS.FieldByName( 'Unterichtssprache' ).AsString ),
										 '',
										 notekrz,
										 Trim( fQryS.FieldByName( 'NoteSchriftlich' ).AsString ),
										 nmdl,
										 npges,
										 0, //fQryS.FieldByname( 'Wochenstunden' ).AsInteger,
										 gewicht,
                     gewicht_fhr,
										 fQryS.FieldByName( 'Fachgruppe_ID' ).AsInteger,
										 fQryS.FieldByName( 'Fach_ID' ).AsInteger,
										 fQryS.FieldByname( 'FachSchriftlich' ).AsString = '+',
//										 ( fQryS.FieldByname( 'FachSchriftlichBA' ).AsString = '+' ) and ( ( FSchulGliederung = 'C01' ) or ( FSchulGliederung = 'A02' ) ),
                     ist_schr_ba,
										 nabschl,
                     nabschl_ba,
										 prf10, warnung, ist_fs )

					end else
					begin

// Aufruf von Seite "Akt. Halbjahr"
// Bei der Ermittlung der Nachprüfungsfächer werden die Fächer der ZP10 ignoriert, daher feststellen, ob es sich um ein solches Fach handelt
						if FIst_BK then
							prf10 := '-'
						else
							prf10 := fQryS.FieldByname( 'Prf10Fach' ).AsString;
						if prf10 = '' then
							prf10 := '-';

            gewicht := 1;
            gewicht_fhr := 0;
            if FIst_BK then
            begin
              try
//                if SchildSettings.ZeigeGewichtung then
//                  gewicht := fQryS.FieldByName( 'Gewichtung' ).AsInteger
//                else
                  gewicht := FachEigenschaften.GewichtungBB( fQryS.FieldByName( 'Fach_ID' ).AsInteger );
              except
              end;

              try
                gewicht_fhr := FachEigenschaften.GewichtungAB( fQryS.FieldByName( 'Fach_ID' ).AsInteger );
              except
              end;
            end;

            FachHinzu( fQryS.FieldByName( 'FachKrz' ).AsString,
                     sk,
                     Trim( fQryS.FieldByName( 'Zeugnisbez' ).AsString ),
                     Trim( fQryS.FieldByName( 'Unterichtssprache' ).AsString ),
                     Trim( fQryS.FieldByname( 'Kursart' ).AsString ),
                     Trim( fQryS.FieldByName( 'NotenKrz' ).AsString ),
                     '',
                     '',
                     '',
                     fQryS.FieldByname( 'Wochenstunden' ).AsInteger,
                     gewicht,
                     gewicht_fhr,
                     fQryS.FieldByName( 'Fachgruppe_ID' ).AsInteger,
                     fQryS.FieldByName( 'Fach_ID' ).AsInteger, false, false,
                     nabschl,
                     nabschl_ba,
                     prf10, warnung, ist_fs );
					end;
				end;
				fQryS.Next;
			end;
 			fAnzSprachenSI := fAnzSprachenSI + SISprachenAusSprachenfolge;
			fMSP := fAnzSprachenSI > 1;

		end;
	finally
	end;
	Result := fC0.RecordCount > 0;

end;



procedure TPruefungsAlgorithmus.MeldungenLeeren;
begin
	slMsg.Clear;
  slMsgGes.Clear;
end;

procedure TPruefungsAlgorithmus.MeldungenZeigen;
begin
	if slMsgGes.Count = 0 then
		exit;
  if slMsgGes.IndexOf( C_MELDUNG ) < 0 then
    slMsg.Insert( 0, 'Die Versetzungs- und Abschlussberechnung ist ohne Gewähr und ersetzt nicht die Prüfung durch die betreuende Lehrkraft.' );

	with TFrm_MessageList.Create( nil ) do
	begin
		Memo.Lines := slMsgGes;
		Caption := 'Ergebnisse des Prüfungsalgorithmus';
		ShowModal;
		Free;
	end;
end;

procedure TPruefungsAlgorithmus.AusgleichsfachAusgeben( idf: string; dset: TDataset; var msg: string );
var
	id: integer;
begin
	id := StrToInt( GetToken( idf, ';', 1 ) );
	dset.Locate( 'ID', id, [] );
	Delete( msg, length( msg), 1 );
	msg := msg + ', Ausgleichsfach ' + dset.FieldByName( 'FachName' ).AsString + ';';
	VersetzungsMeldung( 'Hinweis: ', msg );
//	Meldung( msg );
// Das Ausgleichsfach entfernen
	dset.Delete;
//	msg := '';
end;


procedure TPruefungsAlgorithmus.FachHinzu( const FachKrz, StatKrz, FachLang, Unterichtssprache, Kursart, Note, NoteSchr, NoteMdl, NotePrfGesamt: string; const Wochenstd, Gewichtung, GewichtungFHR, Fachgruppe_ID, Fach_ID: integer; const schr, schrBA: boolean; const NoteAbschl, NoteAbschlBA, Prf10: string; const Gemahnt, IstFS: boolean );
var
	sj : string;
	ij: integer;
	fGruppe: string;
	notnum: double;
	wp2: boolean;
begin
  if ( FSChulform <> 'WB' ) and not IstHauptkursart( Kursart ) then
    exit;

	wp2 := copy( Kursart, 1, 4 ) = 'WPII';

	if FTextNoten.IndexOf( Note ) >= 0 then
	begin
		notnum := 0;
    if Note <> 'AT' then
      exit;
	end else
	begin
		notnum := NoteNum( Note, FSchulgliederung );
		if ( notnum = 999 ) and ( Fachgruppe_ID <> C_FG_ABSCHLUSSARBEIT ) and ( NoteSchr = '' ) then
		begin
			inc( FAnzLeer );
			exit;
		end;
	end;

	if not Assigned( fC0 ) then
		CreateMemTables;
	inc( fMaxID );
	with fC0 do
	begin
		if not Active then
		begin
			Open;
			fC1.Open;
			fC2.Open;
			fCS.Open;
		end;
		Append;
		FieldByName( 'ID' ).AsInteger := fMaxID;		//"eindeutiger" Schlüssel
		FieldByName( 'Fach_ID' ).AsInteger := Fach_ID;
		FieldByName( 'FachKrz' ).AsString := FachKrz;
		FieldByName( 'Fach' ).AsString := StatKrz;
		if not wp2 then
			FieldByName( 'FachIntern' ).AsString := FachKrz
		else
			FieldByName( 'FachIntern' ).AsString := FachKrz + 'WP2';

		FieldByName( 'Fachname' ).AsString := FachLang;
		if not fQryFachGr.Active then
			fQryFachGr.Open;
		if fQryFachGr.Locate( 'Fach', StatKrz, [] ) then
			fGruppe := fQryFachGr.FieldByname( 'FachgruppeKrz' ).AsString
		else
			fGruppe := '';

    if FIst_BK and IstFS then
      fGruppe := 'FS';

		FieldByName( 'Fachgruppe' ).AsString := fGruppe;
		FieldByName( 'FachgruppeIntern' ).AsString := fGruppe;		// Default
// Jetzt besondere Fälle

		if ( fGruppe = 'FS' ) then
		begin	// Fremdsprachen
			FieldByName( 'FremdspracheKrz' ).AsString := StatKrz[1];
  		FieldByName( 'Fach' ).AsString := StatKrz[1];
			if not wp2 then
				FieldByName( 'FachIntern' ).AsString := FieldByName( 'FremdspracheKrz' ).AsString;
			if ( length( StatKrz ) > 1 ) and ( StatKrz[2] >= '1' ) and ( StatKrz[2] <= '9' ) then
			begin		// Sprache mit Jahrgang
				FieldByName( 'BeginnJahrgang' ).AsInteger := StrToInt( StatKrz[2] );
				if FieldByName( 'BeginnJahrgang' ).AsInteger = 1 then
					FieldByName( 'BeginnJahrgang' ).AsInteger := 11;
				if FieldByName( 'BeginnJahrgang' ).AsInteger < 11 then
				begin	// Sprache aus SI
					FieldByName( 'FachgruppeIntern' ).AsString := 'FSI';	// Fremdsprache aus SekI
          if ( FSchulform = 'GY' ) or ( FSchulform = 'GE' ) then
          begin
            if FieldByName( 'BeginnJahrgang' ).AsInteger = 8 then	// Sprache aus 8
              fC0.FieldByName( 'FachgruppeIntern2' ).AsString := 'FS89';	// Fremdsprache aus 9
          end else
          begin
            if FieldByName( 'BeginnJahrgang' ).AsInteger = 9 then	// Sprache aus 9
              fC0.FieldByName( 'FachgruppeIntern2' ).AsString := 'FS89';	// Fremdsprache aus 9
          end;
				end else
					FieldByName( 'FachgruppeIntern' ).AsString := 'NS';	// Neue Fremdsprache in SekII
			end;
		end else if ( fGruppe = 'NW' ) then
		begin	// Naturwissenschaften
			if ( StatKrz = 'BI' ) or ( StatKrz = 'CH' ) or ( StatKrz = 'PH' ) then
				FieldByName( 'FachgruppeIntern' ).AsString := 'BCP';	// Bio, Chemie und Physik
			FieldByName( 'FachgruppeIntern2' ).AsString := 'NW';
		end else if ( fGruppe = 'WN' ) then	// weitere Naturwissenschaften
			FieldByName( 'FachgruppeIntern2' ).AsString := 'NW'	// Kommen ebenfall zu NW
		else if ( fGruppe = 'GS' ) or ( fGruppe = 'PL' ) then
			FieldByName( 'FachgruppeIntern2' ).AsString := 'GP';	// Gesellschaftswiss. + Philosophie

		if Unterichtssprache <> '' then
			FieldByName( 'Unterichtssprache' ).AsString := Unterichtssprache
		else
			FieldByName( 'Unterichtssprache' ).AsString := 'D';

		FieldByname( 'Kursart' ).AsString := Trim( Kursart );
    if notnum <> 999 then
  		FieldByName( 'Note' ).AsFloat := Notnum;
		if not FVolljaehrig and ( NotNum >= 5 ) and not Gemahnt then
			inc( FAnzahlNichtGemahnt );

    if Gemahnt then
      FieldByname( 'Gemahnt' ).AsString := '+'
    else
      FieldByname( 'Gemahnt' ).AsString := '-';

		FieldByname( 'NoteKrz' ).AsString := note;

		if schr then
			FieldByname( 'IstSchriftlich' ).AsString := '+'
		else
			FieldByname( 'IstSchriftlich' ).AsString := '-';

// Wichtig:
		if schrBA then
			FieldByname( 'IstSchriftlichBA' ).AsString := '+'
		else
			FieldByname( 'IstSchriftlichBA' ).AsString := '-';

		if ( schr or schrBA ) then
		begin
			if ( NoteSchr <> '' ) then
				FieldByname( 'NoteSchr' ).AsFloat := NoteNum( NoteSchr )
			else
				FieldByname( 'NoteSchr' ).AsFloat := 999;
		end;

		if ( NoteMdl <> '' ) then
		begin
			if NoteMdl = '?' then
				FieldByname( 'NoteMdl' ).AsFloat := 999
			else
				FieldByname( 'NoteMdl' ).AsFloat := NoteNum( NoteMdl );
		end;

		if ( NotePrfGesamt <> '' ) then
		begin
			if NotePrfGesamt = '?' then
				FieldByName( 'NotePrfGesamt' ).AsFloat := 999
			else
				FieldByName( 'NotePrfGesamt' ).AsFloat := NoteNum( NotePrfGesamt );
		end;

		if ( NoteAbschl <> '' ) then
		begin
			if NoteAbschl = '?' then
				FieldByName( 'NoteAbschl' ).AsFloat := 999
			else
				FieldByName( 'NoteAbschl' ).AsFloat := NoteNum( NoteAbschl );
		end;

		if ( NoteAbschlBA <> '' ) then
		begin
			if NoteAbschlBA = '?' then
				FieldByName( 'NoteAbschlBA' ).AsFloat := 999
			else
				FieldByName( 'NoteAbschlBA' ).AsFloat := NoteNum( NoteAbschlBA );
		end;



		FieldByname( 'Wochenstd' ).AsInteger := Wochenstd;
		if not FIst_BK and ( Gewichtung = 0 ) then
			FieldByname( 'Gewichtung' ).AsInteger := 1
		else
			FieldByname( 'Gewichtung' ).AsInteger := Gewichtung;

		FieldByname( 'GewichtungFHR' ).AsInteger := GewichtungFHR;
		FieldByName( 'Fachgruppe_ID' ).AsInteger := Fachgruppe_ID;
		FieldByName( 'Prf10Fach' ).AsString := Prf10;
		Post;
	end;
	fCS.Append;
	RBKCopyRecord( fC0, fCS );
	fCS.Post;

end;

procedure TPruefungsAlgorithmus.CreateMemTables;
begin
	fC0 := TMemTableEh .Create( nil );
	with fC0.FieldDefs do
	begin
		Clear;
		Add( 'ID', ftInteger, 0, false );
		Add( 'Fach_ID', ftInteger, 0, false );
		Add( 'Fach', ftWideString, 2, false );
		Add( 'FachKrz', ftWideString, 20, false );
		Add( 'FachIntern', ftWideString, 5, false );		// hier kommt z.B. M für Mathe oder MWP2 für Mathefach in WP2 rein
		Add( 'Fachname', ftWideString, 80, false );
		Add( 'Fachgruppe', ftWideString, 2, false );
		Add( 'FachgruppeIntern', ftWideString, 5, false );
		Add( 'FachgruppeIntern2', ftWideString, 5, false );
		Add( 'Unterichtssprache', ftWideString, 1, false );
		Add( 'FremdspracheKrz', ftWideString, 1, false );
		Add( 'BeginnJahrgang', ftInteger, 0, false );
		Add( 'Reihenfolge', ftWideString, 1, false );
		Add( 'Kursart', ftWideString, 5 , false );
		Add( 'Note', ftFloat, 0, false );
		Add( 'NoteKrz', ftWideString, 2, false );
		Add( 'IstSchriftlich', ftWideString, 1, false );
		Add( 'IstSchriftlichBA', ftWideString, 1, false );
		Add( 'NoteSchr', ftFloat, 0, false );
		Add( 'NoteMdl', ftFloat, 0, false );
		Add( 'NotePrfGesamt', ftFloat, 0, false );
		Add( 'NoteAbschl', ftInteger, 0, false );
		Add( 'NoteAbschlBA', ftInteger, 0, false );
		Add( 'Wochenstd', ftSmallInt, 0, false );
		Add( 'Gewichtung', ftSmallInt, 0, false );
		Add( 'GewichtungFHR', ftSmallInt, 0, false );
		Add( 'Fachgruppe_ID', ftInteger, 0, false );
		Add( 'Prf10Fach', ftWideString, 1, false );
    Add( 'Gemahnt', ftWideString, 1 , false );
	end;
  fC0.CreateDataset;
	fC1 := TMemTableEh.Create( nil );
	fC1.FieldDefs := fC0.FieldDefs;
  fC1.CreateDataset;

	fC2 := TMemTableEh.Create( nil );
	fC2.FieldDefs := fC0.FieldDefs;
  fC2.CreateDataset;

	fCS := TMemTableEh.Create( nil );
	fCS.FieldDefs := fC0.FieldDefs;
  fCS.CreateDataset;

end;

function TPruefungsAlgorithmus.FeldWertAnzahl( Tabelle: TDataset ; Feld, Wert: string ): integer;
begin
	Result := 0;
	with Tabelle do
	begin
		First;
		while not EOF do
		begin
			if Tabelle.FieldByName( Feld ).AsString = Wert then
				Result := Result + 1;
			Next;
		end;
	end;
end;

function TPruefungsAlgorithmus.HauptFachID( Tabelle: TDataset ; const Feld, Fach: string ): string;
var
  do_add: boolean;
begin
	Result := '';
	with Tabelle do
	begin
		First;
		while not EOF do
		begin
      if Fach <> '' then
        do_add := ( Tabelle.FieldByName( Feld ).AsString = Fach ) and IstHauptkursart( Tabelle.FieldByName( 'Kursart' ).AsString )
      else
        do_add := IstHauptkursart( Tabelle.FieldByName( 'Kursart' ).AsString );
      if do_add then
      begin
        if Result <> '' then
          Result := Result + ';';
				Result := Result + FieldByName( 'ID' ).AsString;
      end;
			Next;
		end;
	end;
end;


function TPruefungsAlgorithmus.FeldWertIDs( Tabelle: TDataset; Feld, Wert: string; WertLaenge: integer ): string;
var
	ok: boolean;
begin
	Result := '';
	with Tabelle do
	begin
		First;
		while not EOF do
		begin
			if WertLaenge = 0 then
				ok := FieldByName( Feld ).AsString = Wert
			else
				ok := copy( FieldByName( Feld ).AsString, 1, WertLaenge ) = Wert;
			if ok then
			begin
				if Result <> '' then
					Result := Result + ';';
				Result := Result + FieldByName( 'ID' ).AsString;
			end;
			Next;
		end;
	end;
end;


function TPruefungsAlgorithmus.BesteNoteID( Tabelle: TDataset; Feld, Wert: string; IDIgnor: integer ): string;
var
	min_id: integer;
	min: double;
	check: boolean;
begin
	min := 1000;
	min_id := -1;
	with Tabelle do
	begin
		First;
		while not EOF do
		begin
			if ( FieldByName( 'ID' ).AsInteger <> IDIgnor ) and IstHauptKursart( FieldByname( 'Kursart' ).AsString ) then
			begin
				if Wert <> '' then
					check := ( FieldByName( Feld ).AsString = Wert )
				else
					check := true;
				if check and ( Tabelle.FieldByName( 'Note' ).AsFloat < min ) then
				begin
					min_id := FieldByname( 'ID' ).AsInteger;
					min := FieldByName( 'Note' ).AsFloat;
				end;
			end;
			Next;
		end;
	end;
	Result := IntToStr( min_id );		// Die ID des Datensatzes mit der besten NOte
	fBesteNote := min;
end;

function TPruefungsAlgorithmus.BesteNoteIDAusListe( Tabelle: TDataset; const Liste: string ): string;
var
	min_id, i, fach_id: integer;
	min: double;
	check: boolean;
begin
	min := 1000;
	min_id := -1;
  for i := 1 to AnzahlElemente( Liste ) do
  begin
    fach_id := StrToInt( EinzelElement( Liste, i ) );

  	with Tabelle do
	  begin
      Locate( 'ID', fach_id, [] );
      if FieldByName( 'Note' ).AsFloat < min then
      begin
        min_id := FieldByname( 'ID' ).AsInteger;
        min := FieldByName( 'Note' ).AsFloat;
      end;
    end;
	end;
	Result := IntToStr( min_id );		// Die ID des Datensatzes mit der besten NOte
	fBesteNote := min;
end;


procedure TPruefungsAlgorithmus.DurchschnittsnoteSpeichern( const dsn: double; const fn_dsn, fn_dsn_text: string );
var
  sdsn: string;
begin
	if dsn > 0 then
	begin
		if ( fSchulform = 'BK' ) or ( fSchulform = 'SB' ) then
    begin
      sdsn := FloatToStr( dsn );
      sdsn := StringReplace( sdsn, DecimalSeparator, ',', [] );
      if not AnsiContainsText( sdsn, ',' ) then
        sdsn := sdsn + ',0';
			TransactionHandler.DoExecute( Format( 'UPDATE Schueler SET %s=%s, %s=%s WHERE ID=%d',
																	[ fn_dsn,
                                    QuotedStr( sdsn ),
                                    fn_dsn_text,
                                    QuotedStr( DurchschnittsnoteText( dsn ) ),
                                    fS_ID ] ) )
		end else
			TransactionHandler.DoExecute( Format( 'UPDATE Schueler SET %s=%s WHERE ID=%d',
																	[ fn_dsn, QuotedStr( FloatToStr( dsn ) ), fS_ID ] ) );
	end else
		TransactionHandler.DoExecute( Format( 'UPDATE Schueler SET %s=NULL, %s=NULL WHERE ID=%d',
																[ fn_dsn, fn_dsn_text, fS_ID ] ) );
end;

procedure TPruefungsAlgorithmus.DurchschnittsnoteSpeichernFuerAbschnitt( const dsn: double );
var
  sdsn: string;
begin
	if dsn > 0 then
	begin
    sdsn := FloatToStr( dsn );
    sdsn := StringReplace( sdsn, DecimalSeparator, ',', [] );
    if not AnsiContainsText( sdsn, ',' ) then
      sdsn := sdsn + ',0';
    TransactionHandler.DoExecute( Format( 'UPDATE SchuelerLernabschnittsdaten SET DSNote=%s WHERE ID=%d',
                                [ QuotedStr( sdsn ),
                                  fA_ID ] ) );
	end else
		TransactionHandler.DoExecute( Format( 'UPDATE SchuelerLernabschnittsdaten SET DSNote=NULL WHERE ID=%d',
																[ fA_ID ] ) );
end;



function TPruefungsAlgorithmus.Pruefen: string;
var
	ok, abbruch, use_like : boolean;
  strSF, cmd, sPO: string;
  tp_res: string;
begin

{$IFDEF BWFS}
  FaecherDatenHolen;
  Teilpruefung;
  exit;
{$ENDIF}

// Wird nach "SchuelerDatenHolen" ausgeführt, d.h. die Schulform und die Schülerdaten sind bekannt

// Die "Teilprüfungsordnung ermitteln

	try
		with fQryP do
		begin
			Close;
      if ( fSchulform = 'BK' ) or ( fSchulform = 'SB' ) or ( fSchulform = 'WB' )  then
        strSF := fSchulform
      else
        strSF := FSchulgliederung;

      use_like := false;
      if AnsiStartsText( 'APO-BK-03/E', fPruefOrdnung ) then
      begin
        sPO := 'APO-BK-03/E%';
        use_like := true;
      end else if AnsiStartsText( 'APO-BK-11/E', fPruefOrdnung ) then
      begin
        sPO := 'APO-BK-11/E%';
        use_like := true;
      end else
        sPO := fPruefOrdnung;

      if use_like then
        cmd := Format( 'SELECT * FROM PruefOrd_Optionen WHERE OP_POKrz like %s', [ QuotedStr( sPO ) ] )
      else
        cmd := Format( 'SELECT * FROM PruefOrd_Optionen WHERE OP_POKrz=%s', [ QuotedStr( sPO ) ] );
      cmd := cmd +  ' AND OP_Reihenfolge not in (0,99)' +
                    ' AND OP_Schulformen LIKE ' + QuotedStr( '%-' + strSF + '-%' ) +
                    ' AND OP_Jahrgaenge LIKE ' + QuotedStr( '%-' + fJahrgang + '-%' ) +
                    ' AND OP_Art IN (' + QuotedStr( 'V') + ',' + QuotedStr( 'A' ) + ') AND OP_TYP IS NULL';
			if fIst_BK and ( FSchulgliederung <> '' ) then
				cmd := cmd + ' AND OP_BKAnl_Typ LIKE ' + QuotedStr( '%-' + FSchulgliederung + '-%' );
      cmd := cmd + ' ORDER BY OP_Reihenfolge';
{$IFDEF UNIDAC}
			SQL.Text := cmd;
{$ELSE}
			CommandText := cmd;
{$ENDIF}
			Open;
			First;
			if IsEmpty then
			begin
				Result := '?';
				Meldung( 'Für die Prüfungsordnung des Schülers ist noch kein Algorithmus vorhanden' );
				Meldung( 'Möglicherweise sind auch falsche Einträge vorhanden' );
        Meldung( 'oder Sie müssen die Berechnung auf den Karteireitern "BK-Abschluss", "FHR" oder "Abitur" durchführen' );
				Close;
				exit;
			end;

// Die Abschluss-Felder leeren
			AbschlussSpeichern( -1 );

			Fabbruch := false;
//      if DEbugHook <> 0 then
//        FAbbruch := true;

			while not EOF and not Fabbruch do
			begin   // Schleife über alle Optionen
				fTeilPruefOrdKrz := FieldByName( 'OP_Krz' ).AsString;
				fTeilPruefOrdLang := FieldByName( 'OP_Name' ).AsString;
				fPruefungsArt := FieldByName( 'OP_Art' ).AsString;
				FBildungsGang := FieldByname( 'OP_Bildungsgang' ).AsString;
				FAbgangsart := FieldByName( 'OP_Abgangsart_B' ).AsString;
        abbruch := false;
				if FAbgangsart = '' then
					FAbgangsart := '-';
// Die Faecher ermitteln, dies ist für jede Option notwendig, da die Fächer je nach Option unterschiedlich in C0, C1, C2 verteilt werden
				if not FaecherDatenHolen and ( pos( 'KV5',  fTeilPruefOrdKrz ) = 0 ) then
				begin
					Meldung( 'Keine Fächer gefunden oder keine Noten eingetragen' );
					abbruch := true;
				end;

        if not abbruch then
          tp_res := Teilpruefung;
        if AnsiStartsText( 'N', tp_res ) or abbruch then
          FAbbruch := true;

        if FAbbruch then
          exit;

				Next;
			end;
		end;

	finally

    if FPONichtUnterstuetzt.Count > 0 then
    begin
      Meldung ( ' ' );
      Meldung( Format( 'Hinweis: Für die Prüfungfsordnung "%s" sind einige Teile nicht als Algorithmus hinterlegt', [ fPruefOrdnung ] ) );
    end;

		fTeilPruefOrdKrz := '';
		fTeilPruefOrdLang := '';
	end;
end;

function  TPruefungsAlgorithmus.TeilPruefung;
begin

end;

procedure TPruefungsAlgorithmus.Meldung( msg: string );
begin
	if not fMeldungAktiv then
		exit;
	if msg = '' then
		exit;

	if not fNameDone then
	begin
//		if slMsg.Count > 0 then
//			slMsg.Add( '' );		// Leerzeile in Ausgabepuffer
		slMsg.Add( fSchuelerName );
		slMsg.Add( '========================================================================' );
  end;

  if not fPrfOrdDone and ( FPONichtUnterstuetzt.IndexOf( fTeilPruefOrdKrz ) < 0 )then
  begin
    if fNameDone then
      slMsg.Add( '' );
{$IFNDEF BWFS}
    if fPruefOrdnung <> '' then
    begin
      if fTeilPruefOrdLang <> '' then
        slMsg.Add( 'Prüfungsordnung: ' + fTeilPruefOrdLang );
    end else
      slMsg.Add( 'Prüfungsordnung: Keine Prüfungsordnung zugewiesen' );
    if not FIst_BK and ( FSchulform <> 'WB' ) and not IstPrognose then
    begin
      if FAnzahlNichtGemahnt = 1 then
        slMsg.Add( 'Achtung: Es wurde ein Fach mit Note 5 oder 6 gefunden, das nicht gemahnt wurde' )
      else if FAnzahlNichtGemahnt > 1 then
        slMsg.Add(Format( 'Achtung: Es wurden %d Fächer mit Note 5 oder 6 gefunden, die nicht gemahnt wurden', [ FAnzahlNichtGemahnt ] ) );
      if FInfoNichtGemahnt <> '' then
      begin
        slMsg.Add( FInfoNichtGemahnt );
        FInfoNichtGemahnt := '';
      end;
  	end;
{$ENDIF}
    if ( FBKGliederung <> glD01 ) and ( fAnzLeer > 0 ) then
      slMsg.Add( 'Hinweis: Nicht alle Fächer benotet' );

  end;
	fNameDone := true;
  fPrfOrdDone := true;

	slMsg.Add( msg );
end;

procedure TPruefungsAlgorithmus.VersetzungSpeichern( vers: string );
begin
  if ( FSchulform <> 'WB' ) and ( FAbschnitt <> FAnzahlAbschnitte ) then
    exit; // Bei Nicht-WBK nur im letzten Abschnitt die Versetzung eintragen
	if fIstVersetzt then
		exit;		// Es wurde schon eine Versetzung eingetragen, die bleibt dann auch

	with TransactionHandler do
	begin
		if vers <> '?' then
			DoExecute( Format( 'UPDATE SchuelerLernabschnittsdaten SET VersetzungKrz=%s WHERE ID=%d', [QuotedStr( vers ), fA_ID] ) )
		else
			DoExecute( Format( 'UPDATE SchuelerLernabschnittsdaten SET VersetzungKrz=NULL WHERE ID=%d', [ fA_ID] ) );
	end;
	fIstVersetzt := vers = 'V';
end;

procedure TPruefungsAlgorithmus.AbschlussSpeichern( const abschl: ShortInt );
var
  cmd: string;
begin
  case abschl of
  -1: begin
        TransactionHandler.DoExecute( Format( 'UPDATE SchuelerLernabschnittsdaten SET AbschlussArt=Null, Abschluss=NULL, Abschluss_B=NULL WHERE ID=%d', [ fA_ID] ) );
        SchuelerAbschlussSpeichern( '' );
      end;
  0 : begin   // Jahrgang ohne Abschluss
        TransactionHandler.DoExecute( Format( 'UPDATE SchuelerLernabschnittsdaten SET AbschlussArt=%d, Abschluss=NULL WHERE ID=%d', [ abschl, fA_ID] ) );
  //					SchuelerAbschlussSpeichern( '' );
      end;
  1 : begin   // mit Abschluss
        if FBildungsGang = 'A' then
        begin
          if fTeilPruefOrdKrz = '' then
            TransactionHandler.DoExecute( Format( 'UPDATE SchuelerLernabschnittsdaten SET AbschlussArt=%d, Abschluss=NULL WHERE ID=%d', [ abschl, fA_ID] ) )
          else
          begin
            if IstPrognose then
            begin
              cmd := Format( 'UPDATE SchuelerLernabschnittsdaten SET AbschlIstPrognose=%s, AbschlussArt=NULL, Abschluss=%s WHERE ID=%d', [ QuotedStr( '+' ), QuotedStr( fTeilPruefOrdKrz ), fA_ID] );
              TransactionHandler.DoExecute( cmd );
            end else
            begin
              cmd := Format( 'UPDATE SchuelerLernabschnittsdaten SET AbschlIstPrognose=%s, AbschlussArt=%d, Abschluss=%s WHERE ID=%d', [ QuotedStr( '-' ), abschl, QuotedStr( fTeilPruefOrdKrz ), fA_ID] );
              TransactionHandler.DoExecute( cmd );
            end;
          end;
        end else if FBildungsGang = 'B' then
        begin
          if fTeilPruefOrdKrz <> '' then
            TransactionHandler.DoExecute( Format( 'UPDATE SchuelerLernabschnittsdaten SET AbschlussArt=%d, Abschluss_B=%s WHERE ID=%d', [ abschl, QuotedStr( fTeilPruefOrdKrz ), fA_ID] ) )
          else
            TransactionHandler.DoExecute( Format( 'UPDATE SchuelerLernabschnittsdaten SET AbschlussArt=%d, Abschluss_B=NULL WHERE ID=%d', [ abschl, fA_ID] ) );
        end;
        SchuelerAbschlussSpeichern( FAbgangsart );
      end;
  2,3 : begin   // ohne Abschluss bzw. mit Nachpr.
          with fQryAbschl do
          begin
{$IFDEF UNIDAC}
            Close;
            Params[0].AsInteger := fA_ID;
            Open;
{$ELSE}
            Parameters[0].Value := fA_ID;
            Requery;
{$ENDIF}
        //    ShowMessage( IntToStr( RecordCount ) );

            if not IstPrognose and ( FieldByName( 'AbschlussArt' ).AsInteger <> 1 ) then
            begin
              if FBildungsgang = 'A' then
                TransactionHandler.DoExecute( Format( 'UPDATE SchuelerLernabschnittsdaten SET AbschlussArt=%d, Abschluss=NULL WHERE ID=%d', [ abschl, fA_ID] ) )
              else if FBildungsgang = 'B' then
                TransactionHandler.DoExecute( Format( 'UPDATE SchuelerLernabschnittsdaten SET AbschlussArt=%d, Abschluss_B=NULL WHERE ID=%d', [ abschl, fA_ID] ) );
            end;
          end;
        end;
//		Close;
	end;
end;

procedure TPruefungsAlgorithmus.SchuelerAbschlussSpeichern( const abschl: string );
begin
	if FBildungsgang = 'B' then
		exit;
	if abschl = '' then
		TransactionHandler.DoExecute( Format( 'UPDATE Schueler SET EntlassArt=NULL, Entlassjahrgang_ID=NULL WHERE ID=%d', [ fS_ID] ) )
	else if abschl <> '-' then
		TransactionHandler.DoExecute( Format( 'UPDATE Schueler SET EntlassArt=%s, Entlassjahrgang_ID=%d WHERE ID=%d', [ QuotedStr( abschl ), FJahrgang_ID, fS_ID] ) );
end;




procedure TPruefungsAlgorithmus.Uebertragen( src, dst: TDataset; ids: string );
var
	i : integer;
	id : integer;
begin
	for i := 1 to NumToken( ids, ';' ) do
	begin
		id := StrToInt( GetToken( ids, ';', i ) );
		src.Locate( 'ID', id, [] );
		if src.FieldByName( 'Note' ).AsFloat <> 999 then
		begin
			if not dst.Locate( 'ID', id, [] ) then
			begin
				dst.Append;
				RBKCopyRecord( src, dst );
				dst.Post;
			end;
			src.Delete;
		end else
			Meldung( Format( 'Falsche Note ("%s") in %s', [ src.FieldByName( 'NoteKrz' ).AsString, src.FieldByName( 'Fachname' ).AsString] ) ) ;
	end;
end;

procedure TPruefungsAlgorithmus.Kopieren( src, dst: TDataset; ids: string );
var
	i : integer;
	id : integer;
begin
	for i := 1 to NumToken( ids, ';' ) do
	begin
		id := StrToInt( GetToken( ids, ';', i ) );
		src.Locate( 'ID', id, [] );
		if src.FieldByName( 'Note' ).AsFloat <> 999 then
		begin
			if not dst.Locate( 'ID', id, [] ) then
			begin
				dst.Append;
				RBKCopyRecord( src, dst );
				dst.Post;
			end;
		end else
			Meldung( Format( 'Falsche Note ("%s") in %s', [ src.FieldByName( 'NoteKrz' ).AsString, src.FieldByName( 'Fachname' ).AsString] ) ) ;
	end;
end;


procedure TPruefungsAlgorithmus.AusContainerLoeschen( ds: TDataset; ids: string );
var
	i : integer;
	id : integer;
begin
	for i := 1 to AnzahlElemente( ids ) do
	begin
		id := StrToInt( EinzelElement( ids, i ) );
		ds.Locate( 'ID', id, [] );
		ds.Delete;
	end;
end;



function TPruefungsAlgorithmus.NoteVorhanden( Tabelle: TDataset; const Feld, Op: string; const Note: double; const IDIgnor: integer ): string;
var
	fnd: boolean;
	actnote: double;
begin
	Result := '';		// d.h. kein fach mit der Note gefunden
	with Tabelle do
	begin
		First;
		while not EOF do
		begin
			if FieldByName( 'ID' ).AsInteger <> IDIgnor then
			begin
				actnote := FieldByname( Feld ).AsFloat;
				if op = '=' then
					fnd := actnote = Note
				else if op = '>' then
					fnd := actnote > Note
				else if op = '>=' then
					fnd := actnote >= Note
				else if op = '<=' then
					fnd := ( actnote > 0 ) and ( actnote <= Note )
				else if op = '<' then
					fnd := ( actnote > 0 ) and ( actnote < Note );
				if fnd then
				begin
					if Result <> '' then
						Result := Result + ';';
					Result := Result + FieldByName( 'ID' ).AsString;
				end;
			end;
			Next;
		end;
	end;
end;

function TPruefungsAlgorithmus.NoteVorhanden( Tabelle: TDataset; const Feld, Op: string; const Note: double; const Kursart: string ): string;
var
	fnd: boolean;
	actnote: double;
begin
	Result := '';		// d.h. kein fach mit der Note gefunden
	with Tabelle do
	begin
		First;
		while not EOF do
		begin
			if FieldByName( 'Kursart' ).AsString = Kursart then
			begin
				actnote := FieldByname( Feld ).AsFloat;
				if op = '=' then
					fnd := actnote = Note
				else if op = '>' then
					fnd := actnote > Note
				else if op = '>=' then
					fnd := actnote >= Note
				else if op = '<=' then
					fnd := ( actnote > 0 ) and ( actnote <= Note )
				else if op = '<' then
					fnd := ( actnote > 0 ) and ( actnote < Note );
				if fnd then
				begin
					if Result <> '' then
						Result := Result + ';';
					Result := Result + FieldByName( 'ID' ).AsString;
				end;
			end;
			Next;
		end;
	end;
end;

function TPruefungsAlgorithmus.NoteVorhandenAusListe( Tabelle: TDataset; const Liste, Feld, Op: string; const Note: double ): string;
var
	fnd: boolean;
	actnote: double;
  i, fach_id: integer;
begin
	Result := '';		// d.h. kein fach mit der Note gefunden
  for i := 1 to AnzahlElemente( Liste ) do
  begin
    fach_id := StrToInt( EinzelElement( Liste, i ) );
  	with Tabelle do
	  begin
      Locate( 'ID', fach_id, [] );
      actnote := FieldByname( Feld ).AsFloat;
      if op = '=' then
        fnd := actnote = Note
      else if op = '>' then
        fnd := actnote > Note
      else if op = '>=' then
        fnd := actnote >= Note
      else if op = '<=' then
        fnd := ( actnote > 0 ) and ( actnote <= Note )
      else if op = '<' then
        fnd := ( actnote > 0 ) and ( actnote < Note );
      if fnd then
      begin
        if Result <> '' then
          Result := Result + ';';
        Result := Result + FieldByName( 'ID' ).AsString;
      end;
		end;
	end;
end;



function TPruefungsAlgorithmus.SchreibeFachNote( Tabelle: TDataset; const ID: integer ): string;
begin
	with Tabelle do
	begin
		Locate( 'ID', id, [] );
		Result := FieldByname( 'NoteKrz' ).AsString + ' in ' + FieldByname( 'Fachname' ).AsString + ';';
	end;
end;

function TPruefungsAlgorithmus.SchreibeFachNoteFeld( Tabelle: TDataset; const ID: integer; const Feld: string ): string;
begin
	with Tabelle do
	begin
		Locate( 'ID', id, [] );
		Result := FieldByname( Feld ).AsString + ' in ' + FieldByname( 'Fachname' ).AsString + ';';
	end;
end;

procedure TPruefungsAlgorithmus.VersetzungsMeldung( const msg1: string; var msg2: string );
var
	i : integer;
begin
	if msg1 <> '' then
		Meldung( msg1 );
	StringTrimRight( msg2, ';' );
	for i := 1 to NumToken( msg2, ';' ) do
		Meldung( GetToken( msg2, ';', i ) );
	msg2 := '';
end;

procedure TPruefungsAlgorithmus.FC0_FC1_Zeigen;
var
  st: string;
begin
  st := 'Hauptfächer(FC1)' + #10#13;
  with fC1 do
  begin
    First;
    while not Eof do
    begin
      st := st + FieldByName( 'Fach' ).AsString + ': ' + FieldByName( 'Note' ).AsString + #10#13;
      Next;
    end;
  end;

  st := st + 'Sonstige Fächer(FC0)' + #10#13;
  with fC0 do
  begin
    First;
    while not Eof do
    begin
      st := st + FieldByName( 'Fach' ).AsString + ': ' + FieldByName( 'Note' ).AsString + #10#13;
      Next;
    end;
  end;

  MessageDlg( st, mtInformation, [mbOK ], 0 );
end;

function TPruefungsAlgorithmus.AusfuehrenZP10( const Leeren: boolean; const SchuelerIDs: string; const Jahr, Abschnitt: integer; const Modus: char ): string;

	procedure MdlPruefungen;
	var
		cnt: integer;
		msg: string;
	begin
{		fConSchild.Execute( Format( 'UPDATE SchuelerBKFaecher SET MdlPruefung=%s, NoteMuendlich=NULL, NoteAbschluss=NULL WHERE Schueler_ID=%d',
												[ QuotedStr( '-' ), fS_ID ] ) );}
		TransactionHandler.DoExecute( Format( 'UPDATE SchuelerBKFaecher SET MdlPruefung=%s, NoteMuendlich=NULL WHERE Schueler_ID=%d',
												[ QuotedStr( '-' ), fS_ID ] ) );
		with fC0 do
		begin
			First;
			cnt := 0;
			while not Eof do
			begin
				if abs( FieldByname( 'Note' ).AsFloat - FieldByname( 'NoteSchr' ).AsFloat ) >= 3 then
				begin
					if msg <> '' then
						msg := msg + ';';
					msg := msg + Format( '%s: Vornote=%s, Prüfungsnote=%s',
															[ fC0.FieldByname( 'Fachname' ).AsString,
																fC0.FieldByname( 'Note' ).AsString,
																fC0.FieldByname( 'NoteSchr' ).AsString ] );

					TransactionHandler.DoExecute( Format( 'UPDATE SchuelerBKFaecher SET MdlPruefung=%s WHERE Schueler_ID=%d AND Fach_ID=%d',
												[ QuotedStr( '+' ), fS_ID, fC0.FieldByname( 'Fach_ID' ).AsInteger ] ) );
					inc( cnt );
				end;
				Next;
        Application.ProcessMessages;
			end;
		end;

		Meldung( ' ' );
		Meldung( 'Mündliche Prüfung' );
		Meldung( '---------------------------------' );
		if cnt = 0 then
			Meldung( 'Keine mündlichen Prüfungen notwendig' )
		else
			VersetzungsMeldung( 'Abweichung Vornote/Prüfungsnote:' , msg );
	end;

	procedure Ergebnis;
	var
		cnt: integer;
		msg: string;
		anote: double;
		inote: integer;
	begin
// Erst mal prüfen, ob die mündl. Fächer gefüllt sind
		if FeldWertAnzahl( fC0, 'NoteMdl', '999' ) > 0 then
		begin
			Meldung( 'Mündliche Noten unvollständig' );
			exit;
		end;
		with fC0 do
		begin
			First;
			while not Eof do
			begin
				if FieldByName( 'NoteMdl' ).IsNull then
				begin
					anote := 0.5*( FieldByName( 'Note' ).AsFloat + FieldByname( 'NoteSchr' ).AsFloat );
					inote := trunc( anote );
					if ( inote <> anote ) then		// keine Glatte Note
					begin
						if ( fC0.FieldByName( 'NoteAbschl' ).AsFloat = 999 ) then
							Meldung( Format( '%s: Endnote muss noch zwischen Erst- und Zweitkorrektor abgestimmt werden', [ FieldByname( 'FachName' ).AsString ] ) );
						inote := 0;
					end;
				end else
				begin
					anote := ( 5 * FieldByname( 'Note' ).AsFloat + 3 * FieldByname( 'NoteSchr' ).AsFloat + 2 * FieldByname( 'NoteMdl' ).AsFloat ) / 10;
					inote := trunc( anote + 0.499 );
//					Meldung( Format( '%s: Bitte Abschlussnote manuell eingeben', [ FieldByname( 'FachName' ).AsString ] ) );
				end;
				if inote <> 0 then
					TransactionHandler.DoExecute( Format( 'UPDATE SchuelerBKFaecher SET NoteAbschluss=%d WHERE Schueler_ID=%d AND Fach_ID=%d',
												[ inote, fS_ID, fC0.FieldByname( 'Fach_ID' ).AsInteger ] ) );
				Next;
        Application.ProcessMessages;
			end;
		end;
	end;

	procedure Aktualisieren;
	var
		cmd: string;
    na, na_ba: string;
	begin
    with FC0 do
    begin
      First;
      while not Eof do
      begin
        if FieldByname( 'NoteKrz' ).AsString = 'AT' then
          Delete
        else
          Next;
      end;
      First;
    end;


		if FeldWertAnzahl( fC0, 'NoteAbschl', '999' ) > 0 then
		begin
			Meldung( 'Abschlussnoten unvollständig' );
			exit;
		end;
		with fC0 do
		begin
			First;
			while not Eof do
			begin
        na := FieldByName( 'NoteAbschl' ).AsString;
        na_ba := FieldByName( 'NoteAbschlBA' ).AsString;
        if na_ba = '999' then
          na_ba := 'NULL'
        else
          na_ba := QuotedStr( na_ba );
        if na = '999' then
          na_ba := 'NULL'
        else
          na := QuotedStr( na );

				if FDBFormat = 'MSACCESS' then
					cmd := Format( 'update SchuelerLeistungsdaten L, SchuelerLernabschnittsdaten A set L.NotenKrz=%s, L.NoteAbschlussBA=%s' +
												 ' where A.Schueler_ID=%d and A.Jahr=%d and A.Abschnitt=%d and L.Abschnitt_ID=A.ID and L.Fach_ID=%d' +
                         ' and L.SchulnrEigner=%d',
												 [ na,
                           na_ba,
                           fS_ID, fJahr, fAbschnitt,
                           FieldByname( 'Fach_ID' ).AsInteger,
                           SchildSettings.Schulnr ] )
				else
					cmd := Format( 'update SchuelerLeistungsdaten set NotenKrz=%s, NoteAbschlussBA=%s where SchulnrEigner=%d and Fach_ID=%d and Abschnitt_ID=' +
												 '(select ID from SchuelerLernabschnittsdaten A where A.Schueler_ID=%d and A.Jahr=%d and A.Abschnitt=%d)',
												 [ na,
                           na_ba,
                           SchildSettings.Schulnr,
                           FieldByname( 'Fach_ID' ).AsInteger, fS_ID, fJahr, fAbschnitt ] );
				TransactionHandler.DoExecute( cmd );
				Next;
        Application.ProcessMessages;
			end;
		end;
	end;

  procedure AktualisierenZK( const s_id: integer );
  var
{$IFDEF UNIDAC}
    qryZK: TUniQuery;
{$ELSE}
    qryZK: TBetterADODataSet;
{$ENDIF}

    cmd: string;
    na: string;
  begin
    cmd := Format( 'select Fach_ID, NoteAbschluss from SchuelerBKFaecher where Schueler_ID=%d', [ s_id ] );
{$IFDEF UNIDAC}
    qryZK := CreateForwardDataset( fConSchILD );
    qryZK.SQL.Text := cmd;
{$ELSE}
    qryZK := CreateForwardDataset( fConSchILD, SchildSettings.DBFormat <> 'MSACCESS' );
    qryZK.CommandText := cmd;
{$ENDIF}
    try
      with qryZK do
      begin
        Open;
        while not Eof do
        begin
          na := FieldByName( 'NoteAbschluss' ).AsString;
          if na <> '' then
          begin
            if FDBFormat = 'MSACCESS' then
              cmd := Format( 'update SchuelerLeistungsdaten L, SchuelerLernabschnittsdaten A set L.NotenKrz=%s' +
                             ' where A.Schueler_ID=%d and A.Jahr=%d and A.Abschnitt=%d and L.Abschnitt_ID=A.ID and L.Fach_ID=%d',
                             [ QuotedStr( na ),
                               s_id, fJahr, fAbschnitt, FieldByname( 'Fach_ID' ).AsInteger ] )
            else
              cmd := Format( 'update SchuelerLeistungsdaten set NotenKrz=%s where SchulnrEigner=%d and Fach_ID=%d and Abschnitt_ID=' +
                             '(select ID from SchuelerLernabschnittsdaten A where A.Schueler_ID=%d and A.Jahr=%d and A.Abschnitt=%d)',
                             [ QuotedStr( na ),
                               SchildSettings.Schulnr,
                               FieldByname( 'Fach_ID' ).AsInteger, s_id, fJahr, fAbschnitt ] );
    				TransactionHandler.DoExecute( cmd );
		    		Next;
          end;
        end;
      end;
    finally
      FreeAndNil( qryZK );
    end;
  end;

var
	i: integer;
	docont: boolean;
  istZK: boolean;
begin
	Result := '';
	fJahr := Jahr;
	fAbschnitt := Abschnitt;
	if Leeren then
		MeldungenLeeren;
	if Assigned( fProgress ) then
	begin
		fProgress.Max := NumToken( SchuelerIDs, ',' );
		fProgress.Position := 0;
	end;


	try
		for i := 1 to NumToken( SchuelerIDs, ',' ) do
		begin
			docont := true;
			if Assigned( fProgress ) then
				fProgress.Position := fProgress.Position + 1;
			fS_ID := StrToInt( GetToken( SchuelerIDs, ',', i ) );
 			SchuelerDatenHolen;
      istZK := false;
      if FSchulform = 'GY' then
        istZK := true
      else if FSchulform = 'GY' then
        istZK := ( FJahrgang = '11' ) or ( FJahrgang = 'EF' );

			fPruefOrdnung := 'ZP10';
			fTeilPruefOrdLang := 'Zentrale Abschlussprüfung Jahrgang 10';
			FIst_BKAbschl := true;
      if FIst_BK or not istZK then
      begin // nur bei BJ (wegen Übertragung) oder wenn nicht ZK
        FaecherDatenHolen;
    // Ist die Anzahl der Fächer korrekt?

        if not FIst_BK and ( fC0.RecordCount <> 3 ) then
        begin
          Meldung( 'Falsche Anzahl von Prüfungsfächern' );
          docont := false;
          continue;
        end;

    // Überall Noten eingeben?
        fC0.First;
        while not fC0.Eof do
        begin
          if ( fC0.FieldByname( 'Note' ).AsFloat = 999 ) or ( fC0.FieldByname( 'NoteSchr' ).AsFloat = 999 ) then
          begin
            Meldung( 'Noten unvollständig' );
            docont := false;
            break;
          end;
          fC0.Next;
        end;
        fC0.First;
      end;

			if docont then
			begin
				case Modus of
				'M': MdlPruefungen;
				'A': Ergebnis;
				'U': if istZK then
              AktualisierenZK( fS_ID ) // zentrale Klausuren
             else
              Aktualisieren;
				end;
			end;
		end;

	finally

		if Assigned( fProgress ) then
			fProgress.Position := 0;

		MeldungenZeigen;

	end;

end;

function TPruefungsAlgorithmus.AnzahlNotenBesserAls( ds: TDataset; const prfnote: integer ): integer;
begin
  Result := 0;
  with ds do
  begin
    First;
    while not Eof do
    begin
      if FieldByName( 'Note' ).AsInteger < prfnote then
        Result := Result + 1;
      Next;
    end;
  end;
end;

function TPruefungsAlgorithmus.ReferenzNiveauVorhanden( const refniv: string ): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to FRefNiveaus.Count - 1 do
  begin
    Result := FRefNiveaus[i] >= refniv;
    if Result then
      exit;
  end;

end;


initialization

finalization
	if Assigned( PruefungsAlgorithmus ) then
	begin
		PruefungsAlgorithmus.Free;
		PruefungsAlgorithmus := nil;
	end;


end.



end.


SELECT L.Fach_ID, L.Vornote as NotenKrz,L.FachSchriftlich, L.FachSchriftlichBA, L.NoteSchriftlich, L.NoteMuendlich, L.MdlPruefung, L.MdlPruefungFW,
L.NotePrfGesamt,L.NoteAbschluss, L.NoteAbschlussBA,F.IstSprache, F.FachKrz, F.StatistikKrz, F.Zeugnisbez, F.Unterichtssprache, F.Fachgruppe_ID,
F.Gewichtung as FachGewichtung, F.GewichtungFHR as FachGewichtungFHR FROM SchuelerBKFaecher L, EigeneSchule_Faecher F WHERE L.Schueler_ID=1006702
AND F.ID=L.Fach_ID ORDER BY F.SortierungS2
