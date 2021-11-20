unit Unit_FHRAlgorithmus;

interface

uses	Classes,
			AdoDB,
			BetterADODataset,
			DB,
			unit_Schueler,
			ComCtrls,
			SysUtils,
			JvMemoryDataset;


type
  TFachRec = record
    Fach: string;
    Abschnitt: integer;
    Punkte: integer;
  end;

  TFachRec2 = record
    Fach: string;
    M1: boolean;
    P1: integer;
    M2: boolean;
    P2: integer;
    AnzM: integer;
    SumM: integer;
  end;


  TFachRecArray = array of TFachRec;

  TFachSorter = class( TObject )
    private
      FDaten:TFachRecArray;
      function GetAnzahl: integer;
      procedure QuickSort( iLo, iHi: Integer);
      procedure Reverse;
    public
      procedure Add( const fach: string; const abschnitt, punkte: integer );
      procedure Sortieren( const desc: boolean = false );
      property Daten: TFachRecArray read FDaten;
      property Anzahl: integer read GetAnzahl;
      constructor Create;
      destructor Destroy;
      procedure Free;
      procedure Clear;
    end;


	TFHRAlgorithmus = class( TObject )
		private
			slMsg: TStringList;
			FZeigeMeldungen: boolean;
			FSchildAdminDir: string;
			fQryFHR: TBetterADODataset;
			fQryS: TBetterADODataset;
			fQryFaecher: TBetterADODataset;
			fQryFachGr: TBetterADODataset;
      fQrySprFolge: TBetterADODataset;
			FProgress: TProgressBar;
			fConSchild: TADOConnection;
			FHR_Erreicht: boolean;
			FNameDone: boolean;
			FHR_1, FHR_2: integer;
			FHR_GesamtPunkte: integer;
			FHR_Belegung: boolean;
			FHR_BelegungGes: boolean;
			fC1 : TJvMemoryData;
			fC2 : TJvMemoryData;
			FS_ID: integer;
			FSchulform: string;
			FSchuelerName: string;
			FPruefOrdnung: string;
			FGliederung: string;
			FErrCnt: integer;
			FHeaderDone: boolean;
			F_A: array[1..8] of boolean;
			F_A_Fld: array[1..8] of string;
			FS : string;
			WB_FS1: string;
			W1_2: string;
			W2: string;
			W3_2: string;
			LK: string;
			FSchuelerFHR: TSchuelerFHR;
			FLeistungsdatenHolen: boolean;
      FFachSorter: TFachSorter;
      FAuffuellFaecher: TFachSorter;
      FAbschnitt_1, FAbschnitt_2: integer;
			procedure SetConSchild( con: TADOConnection );
			procedure Initialisieren;
			procedure HeaderSchreiben;
			procedure SchuelerDatenHolen;
			procedure Meldung( const msg: string );
			function PruefeFHRMoeglich: boolean;
			procedure PruefeGewerteteAbschnitte;
			procedure PruefeNichtGewerteteAbschnitte;
			procedure PruefeFHR( const i1, i2: integer );
			function FachHinzu( ds: TDataset; const ID, Fach_ID, Punkte1, Punkte2: integer; const Kursart1, Kursart2: string ): boolean;
			procedure GruppenBilden;
			function PruefeFHRBelegung: boolean;
      function PruefeFHRBelegung_WB10: boolean;
			procedure MarkierungenSetzen( const i1,i2: integer );
			procedure MarkierungenEntfernen;
			procedure AbschnitteErmitteln;
      function AnzahlMarkiert( const faecher: string; const beide: boolean ): integer;
			function PruefeBelegungPunkte( const menge: string ): boolean;
      function PruefeBelegungKursart( const menge, kursarten: string; const auch_nur_einfach: boolean = false ): boolean;
      procedure KursartenPruefen;
      function FachMarkieren( const fach: string; const ia: integer; const auch_bei_0: boolean = false ): boolean;
      procedure FachEntmarkieren( const fach: string; const ia: integer );
      function Punkte( const fach: string; const ia: integer ): integer;
      function AnzahlDefizite( const menge: string; const nur_markiert: boolean = true ): integer;
      function PunktSumme( const menge: string; const nur_markiert: boolean ): integer;
      procedure BestenKursMarkieren( const fach: string );
      procedure Auffuellen;
      function IstMarkiert( const fach: string; const ia: integer ): boolean;
      function OptimierungPruefen_KL( const menge: string ): boolean;
      function OptimierungPruefen_AG: boolean;
		public
			property ConSchild: TADOConnection read fConSchild write SetConSchild;
			property ZeigeMeldungen : boolean read fZeigeMeldungen write fZeigeMeldungen;
			property ProgressBar: TProgressBar read fProgress write fProgress;
			property LeistungsdatenHolen: boolean read FLeistungsdatenHolen write FLeistungsdatenHolen;
			destructor Destroy;
			constructor Create( SchuelerFHRObj: TSchuelerFHR;conSchild, conIntern: TAdoConnection; SchildAdminDir: string; const showmsg: boolean );
			procedure Free;
			procedure MeldungenLeeren;
			procedure MeldungenZeigen;
			function Ausfuehren( const SchuelerIDs: string ): boolean;
		end;

var
	FHRAlgorithmus: TFHRAlgorithmus;

implementation

uses
  Math,
	unit_Mengen,
	RBKStrings,
	RBkDBUtils,
	Dmod_2,
	Forms,
	Dialogs,
  StrUtils,
	unit_EigeneSchule_Basis,
	unit_SchildSettings,
  unit_SchildFunktionen,
  unit_TransactionHandler,
	Form_MessageList;

const
	C_FN: array[1..8] of string = ( 'SII_2_1','SII_2_2','SII_2_1_W','SII_2_2_W','SII_3_1','SII_3_2','SII_3_1_W','SII_3_2_W' );
  C_DEF_PKT = 4; // Beginn der Defizite
var
	SchrKA: TStringList;
	GS_Faecher: string;
  C_GK_MARKIERT: integer;

function NumPunkte( sp: string ):integer;
begin
	try
		Result := StrToInt( sp );
	except
		Result := 0;
	end;
end;

// TFachSorter
constructor TFachSorter.Create;
begin
  inherited;
end;

destructor TFachSorter.Destroy;
begin
  Clear;
  FDaten :=  nil;
  inherited;
end;

procedure TFachSorter.Free;
begin
  if self <> nil then
    Destroy;
end;

procedure TFachSorter.Clear;
begin
  SetLength( FDaten, 0 );
end;

procedure TFachSorter.Add( const fach: string; const abschnitt, punkte: integer );
begin
  SetLength( FDaten, High( FDaten ) + 2 );
  FDaten[ High( FDaten ) ].Fach := fach;
  FDaten[ High( FDaten ) ].Abschnitt := abschnitt;
  FDaten[ High( FDaten ) ].Punkte := punkte;
end;

procedure TFachSorter.Sortieren( const desc: boolean = false );
begin
  QuickSort( 0, High( FDaten ) );
  if desc then
    Reverse;
end;

function TFachSorter.GetAnzahl: integer;
begin
  Result := High( FDaten ) + 1;
end;

procedure TFachSorter.Reverse;
var
  i, hi: integer;
  mid: integer;
  T : TFachRec;
begin
  mid := High( FDaten ) div 2;
  hi := High( FDaten );
  for i := 0 to mid do
  begin
    T := FDaten[ i ];
    FDaten[ i ] := FDaten[ hi ];
    FDaten[ hi ] := T;
    dec( hi );
  end;
end;

procedure TFachSorter.QuickSort( iLo, iHi: Integer) ;
var
  Lo       : integer;
  Hi       : integer;
  T        : TFachRec;
  Mid      : integer;
begin
  if iHi <= iLo then
    exit;
  Lo := iLo;
  Hi := iHi;
  Mid := FDaten[(Lo + Hi) div 2].Punkte;
  repeat

    while FDaten[Lo].Punkte < Mid do
      Inc(Lo) ;
    while FDaten[Hi].Punkte > Mid do
      Dec(Hi) ;

    if Lo <= Hi then
    begin
      T := FDaten[Lo];
      FDaten[Lo] := FDaten[Hi];
      FDaten[Hi] := T;
      Inc(Lo);
      Dec(Hi);
    end;

  until Lo > Hi;

  if Hi > iLo then
    QuickSort( iLo, Hi);
  if Lo < iHi then
    QuickSort( Lo, iHi);

end;

//--------------------------------------------------
constructor TFHRAlgorithmus.Create( SchuelerFHRObj: TSchuelerFHR; conSchild, conIntern: TAdoConnection; SchildAdminDir: string; const showmsg: boolean );
begin
	fZeigeMeldungen := showmsg;
	FLeistungsdatenHolen := false;
	FSchildAdminDir := SchildAdminDir;
	slMsg := TStringList.Create;
	fConSchild := conSchild;
	FSchuelerFHR := SchuelerFHRObj;
	fQryFHR := TBetterADODataset.Create( nil );
	fQryFaecher := TBetterADODataset.Create( nil );
	fQryFachGr := TBetterADODataset.Create( nil );
  fQrySprFolge := TBetterADODataset.Create( nil );
	fQryS := TBetterADODataset.Create( nil );
	fProgress := nil;
	fC1 := TJvMemoryData.Create( nil );
	fC2 := TJvMemoryData.Create( nil );

	with fC1.FieldDefs do
	begin
		Clear;
		Add( 'ID', ftInteger, 0, false );
		Add( 'Fach', ftWideString, 2, false );
		Add( 'Fach_ID', ftInteger, 0, false );
		Add( 'FachIntern', ftWideString, 20, false );
		Add( 'Kursart1', ftWideString, 5 , false );
		Add( 'Kursart2', ftWideString, 5 , false );
		Add( 'Punkte1', ftInteger, 0, false );
		Add( 'Punkte2', ftInteger, 0, false );
		Add( 'Markiert1', ftWideString, 1, false );
		Add( 'Markiert2', ftWideString, 1, false );
	end;
	fC2.FieldDefs := fC1.FieldDefs;
	fC1.Open;
	fC2.Open;
	with fQryFachGr do
	begin
		Connection := conIntern;
		CommandText := 'SELECT Fach, FachGruppeKrz FROM FaecherSortierung ORDER BY Fach';
	end;

  with fQrySprFolge do
  begin
    Connection := fConSchild;
    CommandText := Format( 'select F.StatistikKrz from SchuelerSprachenfolge S, EigeneSchule_Faecher F' +
                           ' where S.SchulnrEigner=%d and S.Schueler_ID=:SID and S.Reihenfolge=%s' +
                           ' and F.ID=S.Fach_ID',
                           [ SchildSettings.Schulnr, QuotedStr( '1' ) ] );
    Parameters[0].Datatype := ftWideString;
  end;

	SchrKA := TStringList.Create;
	with SchrKA do
	begin
		Add( 'LK1' );
		Add( 'LK2' );
		Add( 'GKS' );
		Add( 'AB3' );
		Add( 'AB4' );
		Add( 'AK3' );
		Add( 'AK4' );
	end;

  FFachSorter := TFachSorter.Create;
  FAuffuellFaecher := TFachSorter.Create;

end;

destructor TFHRAlgorithmus.Destroy;
begin
	FreeAndNil( slMsg );
	FreeAndNil( fQryS );
	FreeAndNil( fQryFHR );
	FreeAndNil( fQryFachgr );
	FreeAndNil( fQryFaecher );
  FreeAndNil( fQrySprFolge );
	FreeAndNil( fC1 );
	FreeAndNil( fC2 );
	FreeAndNil( SchrKA );
  FFachSorter.Free;
  FAuffuellFaecher.Free;
end;

procedure TFHRAlgorithmus.Free;
begin
	if self <> nil then
		Destroy;
end;


procedure TFHRAlgorithmus.SetConSchild( con: TADOConnection );
begin
	fConSchild := con;
end;

procedure TFHRAlgorithmus.MeldungenLeeren;
begin
	slMsg.Clear;
end;

procedure  TFHRAlgorithmus.MeldungenZeigen;
begin
	if slMsg.Count = 0 then
		exit;
	with TFrm_MessageList.Create( nil ) do
	begin
		Memo.Font.Name := 'Courier New';
		Memo.Lines := slMsg;
		Caption := 'Ergebnisse des Prüfungsalgorithmus';
		ShowModal;
		Free;
	end;
end;

procedure TFHRAlgorithmus.Meldung( const msg: string );
var
	s : string;
begin
	if msg = '' then
		exit;

	if pos( 'Fehler', msg ) > 0 then
		inc( FErrCnt );
	slMsg.Add( msg );
end;

function TFHRAlgorithmus.PruefeFHRMoeglich: boolean;
var
	i: integer;
begin
	for i := 1 to 8 do
		F_A[i] := false;
	with fQryS do
	begin
		Close;
		Connection := fConSchild;
		CommandText := Format( 'SELECT * FROM SchuelerFHRFaecher WHERE Schueler_ID=%d', [ FS_ID ] );
		Open;
		First;
		while not EOF do
		begin
			for i := 1 to 8 do
			begin
				if F_A_Fld[i] <> '' then
				F_A[i] := F_A[i] or ( NumPunkte( FieldByName( 'P' + F_A_Fld[i] ).AsString ) > 0 );//
//				F_A[i] := F_A[i] or not FieldByName( 'P' + F_A_Fld[i] ).IsNull;
			end;
{			if F_A_Fld[2] <> '' then
				F_A[2] := F_A[2] or ( NumPunkte( FieldByName( 'P' + F_A_Fld[2] ).AsString ) > 0 );
			if F_A_Fld[3] <> '' then
				F_A[3] := F_A[3] or ( NumPunkte( FieldByName( 'P' + F_A_Fld[3] ).AsString ) > 0 );
			if F_A_Fld[4] <> '' then
				F_A[4] := F_A[4] or ( NumPunkte( FieldByName( 'P' + F_A_Fld[4] ).AsString ) > 0 );
			if F_A_Fld[5] <> '' then
				F_A[5] := F_A[5] or ( NumPunkte( FieldByName( 'P' + F_A_Fld[5] ).AsString ) > 0 );}

			Next;
		end;
		Close;
	end;
	Result := ( F_A[1] and F_A[2] ) or ( F_A[2] and F_A[3] ) or ( F_A[3] and F_A[4] );
end;

procedure TFHRAlgorithmus.AbschnitteErmitteln;
var
	i, index: integer;

	procedure FelderSuchen;
	var
		i, j, a: integer;
	begin
		with fQryFHR do
		begin
			fQryS.First;
			while not fQryS.Eof do
			begin
				j := fQryS.FieldByName( 'Jahr' ).AsInteger;
				a := fQryS.FieldByName( 'Abschnitt' ).AsInteger;
				for i := 1 to 8 do
				begin
					if ( abs( FieldByname( 'J' + C_FN[i] ).AsInteger ) = j ) and
						 ( FieldByName( 'A' + C_FN[i] ).AsInteger = a ) then
					begin
						inc( index );
						F_A_Fld[ index ] := C_FN[i];
						break;
					end;
				end;
				fQryS.Next;
			end;
		end;
	end;

begin
	index := 0;
	for i := 1 to 8 do
		F_A_Fld[i] := '';

	with fQryFHR do
	begin
		Close;
		Connection := fConSchild;
		CommandText := Format( 'SELECT * FROM SchuelerFHR WHERE Schueler_ID=%d', [ FS_ID] );
		Open;
	end;


	with fQryS do
	begin
		Close;
		Connection := fConSchild;
		CommandText := Format( 'select Jahr,Abschnitt,SemesterWertung,Wiederholung from SchuelerLernabschnittsdaten where Schueler_ID=%d and WechselNr=999 order by Jahr,Abschnitt', [ FS_ID ] );
		Open;
		Filter := 'SemesterWertung=' + QuotedStr( '+' );
		Filtered := true;
		FelderSuchen;
		Filtered := false;
		Filter := 'SemesterWertung=' + QuotedStr( '-' );
		Filtered := true;
		FelderSuchen;
		Filtered := false;
		Filter := '';
		Close;
	end;
end;

function TFHRAlgorithmus.Ausfuehren( const SchuelerIDs: string ): boolean;
var
	ndata, i: integer;
	s: string;
begin
	FHeaderDone := false;
	FSchuelerFHR.AutoAbschluss := false;
	try
		MeldungenLeeren;
		ndata := NumToken( SchuelerIDs, ',' );
		if Assigned( fProgress ) then
		begin
			fProgress.Position := 0;
			fProgress.Max := ndata;
		end;
		for i := 1 to ndata do
		begin
			if Assigned( fProgress ) then
				fProgress.Position := fProgress.Position + 1;

			s := GetToken( SchuelerIDs, ',', i );
			fS_ID := StrToInt( s );
			Initialisieren;
			SchuelerDatenHolen;
			if not IstGueltigeAbiPruefungsordnung( fPruefOrdnung ) then
			begin
				Meldung( 'Fehler: Keine oder falsche Prüfungsordnung: ' + fPruefOrdnung );
				continue;
			end;
			FSchuelerFHR.DatenAktualisieren( FS_ID, fPruefOrdnung, FLeistungsdatenHolen );
			AbschnitteErmitteln;
			if F_A_Fld[1] = '' then
			begin
				FSchuelerFHR.DatenAktualisieren( FS_ID, fPruefOrdnung, false );
				AbschnitteErmitteln;
				if F_A_Fld[i] = '' then
				begin
					Meldung( 'Fehler: Keine gültigen Abschnitte gefunden' );
					continue;
				end;
			end;
			if not PruefeFHRMoeglich then
			begin
				if FSchulform = 'WB' then
					Meldung( 'Fehler: Keine FHR-Berechnung möglich, da noch nicht mindestens das III. und IV. Semester belegt und bewertet worden ist' )
				else
					Meldung( 'Fehler: Keine FHR-Berechnung möglich, da noch nicht mindestens zwei Abschnitte der 12 bzw. der Q1 belegt und bewertet worden sind' );
				continue;
			end;
			PruefeGewerteteAbschnitte;
			if FHR_Erreicht then
			begin
				FSchuelerFHR.AutoAbschluss := true;
				PruefeFHR( FHR_1, FHR_2 );
				FSchuelerFHR.AutoAbschluss := false;
			end else
			begin
				if ( fSchulform = 'GY' ) or ( fSchulform = 'GE' ) or ( fSchulform = 'BK' ) or ( fSchulform = 'SB' ) then
					PruefeNichtGewerteteAbschnitte;
				if FHR_Erreicht then
				begin
					FSchuelerFHR.AutoAbschluss := true;
					PruefeFHR( FHR_1, FHR_2 );
					FSchuelerFHR.AutoAbschluss := false;
				end else
				begin
//					MarkierungenEntfernen;
					FSchuelerFHR.Datenquelle.Requery;
				end;
			end;

			if FHR_Erreicht then
      begin
// Bei Wiederholern muss anschließend geprüft werden, ob die Kursarten in SchuelerFHRFaecher auch korrekt sind
// Durch Wechsel des Leistungskurses kann hier eine Änderung notwendig sein
        KursartenPruefen;
				Meldung( 'Schulischer Teil der Fachhochschulreife erreicht' );
			end else
			begin
				Meldung( 'Schulischer Teil der Fachhochschulreife nicht erreicht' );
				if not FHR_BelegungGes then
					Meldung( 'Keine gültige Belegung gefunden' );
			end;
			fQryFHR.Close;
			Application.ProcessMessages;
		end;

		if Assigned( fProgress ) then
			fProgress.Position := 0;

		if fZeigeMeldungen then
			MeldungenZeigen;
	finally
		FSchuelerFHR.AutoAbschluss := true;
	end;

end;

procedure TFHRAlgorithmus.PruefeGewerteteAbschnitte;
var
	i : integer;
begin
	for i := 1 to 4 do
		F_A[i] := F_A[i] and ( F_A_Fld[i] <> '');

	for i := 1 to 3 do
	begin
		if ( F_A[i] and F_A[i+1] ) and ( F_A_Fld[i] <  F_A_Fld[i+1] ) then
			PruefeFHR( i, i+1 );
	end;

end;

procedure TFHRAlgorithmus.PruefeNichtGewerteteAbschnitte;
var
	i : integer;
begin
	for i := 5 to 8 do
		F_A[i] := F_A[i] and ( F_A_Fld[i] <> '');

	for i := 5 to 7 do
	begin
		if ( F_A[i] and F_A[i+1] ) and ( F_A_Fld[i] <  F_A_Fld[i+1] ) then
			PruefeFHR( i, i+1 );
	end;

end;

function TFHRAlgorithmus.FachHinzu( ds: TDataset; const ID, Fach_ID, Punkte1, Punkte2: integer; const Kursart1, Kursart2: string ): boolean;
var
	kaa, sk, istSchr, fach: string;
	abi, jg, folge, fg: integer;
begin
	Result := true;
	with fQryFaecher do
	begin
		if not Active then
		begin
			Connection := fConSchild;
			CommandText := Format( 'select * FROM EigeneSchule_Faecher where SchulnrEigner=%d order by ID', [ SchildSettings.Schulnr] );
			Open;
		end;
		Locate( 'ID', Fach_ID, [] );
		fg := FieldByname( 'Fachgruppe_ID' ).AsInteger;
    fach := fQryFaecher.FieldByname( 'StatistikKrz' ).AsString;
// Keine "Zusätzlichen Unterrichtsveranstaltungen", "Förderunterricht" und "Angleichungskurse"
		if ( fg = 1000 ) or ( fg = 1100 ) or ( fg = 1400 )  then
		begin
			Result := false;
			exit;
		end;
	end;

  if ( Kursart1 = 'PJK' ) and ( Kursart2 = 'PJK' ) and ( fach <> 'PX' ) then
    fach := 'PX';

	if ds.Locate( 'Fach_ID', Fach_ID, [] ) then
	begin
		Result := false;
		exit;
	end;

	with ds do
	begin
		Append;
		FieldByname( 'ID' ).AsInteger := ID;
		FieldByname( 'Fach_ID' ).AsInteger := Fach_ID;
		FieldByname( 'FachIntern' ).AsString := fQryFaecher.FieldByname( 'FachKrz' ).AsString;
		FieldByname( 'Fach' ).AsString := fach;
{		if ( fQryFaecher.FieldByName( 'IstSprache' ).AsString = '+' ) then
		begin // es handelt sich um eine Fremdsprache
			folge := 0;
			sk := Trim( fQryFaecher.FieldByName( 'StatistikKrz' ).AsString );	// Statistik-Kürzel des Faches
			if ( length( sk ) = 1 )  then
			begin	// Sprachfach, aber ohne Angabe der Jahrganges
				jg := SpracheBeginnJahrgang( Fach_ID, FieldByName( 'Fach' ).AsString, folge );		// Den Beginn-JG aus den Sprachfolgen holen
				if jg > 0 then
					sk := sk + IntToStr( jg );		// Jahrgang zum Kürzel hinzufügen
			end else
			begin		// Sprachfach mit Jahrgangsangabe
				try
					jg := StrToInt( sk[2] );
					if jg < 1 then
						jg := jg + 10;
				except
					jg := 0;
				end;
			end;

			if ( jg > 0 ) then
			begin
				FieldByname( 'Fach' ).AsString := sk;
				if jg <= 0 then
					jg := 1;
				FieldByname( 'BeginnJahrgang' ).AsInteger := jg;
				if folge > 0 then
					FieldByName( 'SprachenFolge' ).AsInteger := folge;
			end;
		end;}

		FieldByname( 'Kursart1' ).AsString := Kursart1;
		FieldByname( 'Kursart2' ).AsString := Kursart2;
		FieldByName( 'Punkte1' ).AsInteger := Punkte1;
		FieldByName( 'Punkte2' ).AsInteger := Punkte2;
		FieldByName( 'Markiert1' ).AsString := '-';
		FieldByName( 'Markiert2' ).AsString := '-';
		Post;
	end;

end;

procedure TFHRAlgorithmus.GruppenBilden;
var
	gruppe, fach, fmax, fs1: string;
	i, pmax, p: integer;
	add: boolean;
begin
//	if ( FSchulform = 'GY' ) or ( FSchulform = 'GE' ) then
//		SISprachenAusSprachenfolge;
	W1_2 := '';
	W3_2 := '';
	W2 := '';
	LK := '';
	FS := '';
	WB_FS1 := '';

	if not fQryFachgr.Active then
		fQryFachgr.Open;
	with fC1 do
	begin
		First;
		while not EOF do
		begin
			fach := FieldByname( 'Fach' ).AsString;
// Bei AG und gesellschaftswiss. Fach reicht Belegung in einem Abschnitt
      if fSchulform = 'WB' then
      begin
			  if ( FGliederung = 'AG' ) and InMenge( fach, GS_Faecher ) then
				  add := ( FieldByName( 'Punkte1' ).AsInteger > 0 ) or ( FieldByName( 'Punkte2' ).AsInteger > 0 )
			  else
				  add := ( FieldByName( 'Punkte1' ).AsInteger > 0 ) and ( FieldByName( 'Punkte2' ).AsInteger > 0 );
      end else
        add := true;
			if add then
			begin
				fQryFachGr.Locate( 'Fach', fach, [] );
				gruppe := Trim( fQryFachGr.FieldByname( 'FachgruppeKrz' ).AsString );

	// Jetzt die Gruppen abarbeiten
				if gruppe = 'FS' then // eine Fremdsprache
					ZuMengeHinzu( FS, fach )
				else if gruppe = 'NW' then         //  klassische Naturwissenschaften
					ZuMengeHinzu( W3_2, fach );

	// Einzelne Fächer
				if InMenge( fach, GS_Faecher ) then
					ZuMengeHinzu( W2, fach );

				if ( copy( FieldByname( 'Kursart1' ).AsString, 1, 2 ) = 'LK' ) and ( copy( FieldByname( 'Kursart2' ).AsString, 1, 2 ) = 'LK' ) then
					ZuMengeHinzu( LK, fach );   // die Fächer mit Leistungskursen
			end;
			Next;
		end;
	end;

// Die 1. Fremdsprache ermitteln
	if fSchulform = 'WB' then
	begin
    fs1 := '';
    with fQrySprFolge do
    begin
      Parameters[0].Value := FS_ID;
      Requery;
      if not ( Bof and Eof ) then
        fs1 := FieldByName( 'StatistikKrz' ).AsString;
      Close;
    end;
    if fs1 <> '' then
    begin
      for i := 1 to AnzahlElemente( FS ) do
      begin
        fach := EinzelElement( FS, i );
        if ( fach <> '' ) and ( fach[1] = fs1[1] ) then
        begin
          WB_FS1 := fach;
          break;
        end;
      end;
    end;

    if WB_FS1 = '' then
      Meldung( 'Erste Fremdsprache konnte nicht ermittelt werden' );
  end;

end;

function TFHRAlgorithmus.PruefeBelegungPunkte( const menge: string ): boolean;
var
	i: integer;
	f: string;
begin
	Result := false;
	for i := 1 to NumToken( menge, ';' ) do
	begin
		f := GetToken( menge, ';', i );
		if fC1.Locate( 'Fach', f, [] ) then
		begin
			if fC1.FieldByName( 'Punkte1' ).AsInteger*fC1.FieldByName( 'Punkte2' ).AsInteger > 0 then
			begin
				Result := true;
				exit;
			end;
		end;
	end;
end;

function TFHRAlgorithmus.PruefeBelegungKursart( const menge, kursarten: string; const auch_nur_einfach: boolean = false ): boolean;
var
	i, j: integer;
	f: string;
  ka1, ka2, ka: string;
begin
	Result := false;
	for i := 1 to AnzahlElemente( menge ) do
	begin
		f := GetToken( menge, ';', i );
		if fC1.Locate( 'Fach', f, [] ) then
		begin
      if f = 'PX' then
      begin // Projektfach, wird autom. zu Projektkurs, auch wenn evtl. was anderes eingetragen ist
        if FGliederung = 'AG' then
          exit; // nicht erlaubt in AG
        ka2 := copy( FC1.FieldByname( 'Kursart2' ).AsString, 1, 2 );
        if ka2 = '' then
          exit; // nicht im zweiten Abschnoitt belegt, ungültig
        ka1 := 'PJ';
        ka2 := 'PJ';
      end else
      begin
        ka1 := copy( FC1.FieldByname( 'Kursart1' ).AsString, 1, 2 );
        ka2 := copy( FC1.FieldByname( 'Kursart2' ).AsString, 1, 2 );

        if ( ka1 = '' ) and ( ka2 = '' ) then
        begin
          ka1 := 'GK';
          ka2 := 'GK';
        end;

        if ( ka1 = 'PJ' ) and ( ka2 <> 'PJ' ) then
          exit; // falsche Kombi bei Projektkurs
        if ( FGliederung = 'AG' ) and ( ( ka1 = 'PJ' ) or ( ka2 = 'PJ' ) ) then
          exit; // Projektkurs nicht erlaubt in AG
        if ka1 = 'AK' then
          ka1 := 'GK';
        if ka2 = 'AK' then
          ka2 := 'GK';
        if ka1 = 'AB' then
          ka1 := 'GK';
        if ka2 = 'AB' then
          ka2 := 'GK';
        if ( ka1 <> '' ) and ( ka2 = '' ) then
          ka2 := ka1; // Trick bei Abwahl
      end;
      for j := 1 to AnzahlElemente( kursarten ) do
      begin
        ka := EinzelElement( kursarten, j );
        if auch_nur_einfach then
        begin
          if ( ka1 = ka ) or ( ka2 = ka ) then
          begin
            Result := true;
            exit;
          end;
        end else
        begin
          if ( ka1 = ka ) and ( ka2 = ka ) then
          begin
            Result := true;
            exit;
          end;
        end;
      end;
		end;
	end;
end;

function TFHRAlgorithmus.Punkte( const fach: string; const ia: integer ): integer;
begin
  with FC1 do
  begin
    if FieldByname( 'Fach' ).AsString <> fach then
      Locate( 'Fach', fach, [] );
    try
      Result := FieldByname( Format( 'Punkte%d', [ ia ] ) ).AsInteger;
    except
      Result := 0;
    end;
  end;
end;

function TFHRAlgorithmus.AnzahlMarkiert( const faecher: string; const beide: boolean ): integer;
var
  i: integer;
  fach: string;
begin
  for i := 1 to AnzahlElemente( faecher ) do
  begin
    fach := EinzelElement( faecher, i );
    with FC1 do
    begin
      if FieldByname( 'Fach' ).AsString <> fach then
        Locate( 'Fach', fach, [] );
      if beide then
      begin
        if ( FieldByName( 'Markiert1' ).AsString = '+' ) and ( FieldByName( 'Markiert2' ).AsString = '+' ) then
          inc( Result,2 );
      end else
      begin
        if FieldByName( 'Markiert1' ).AsString = '+' then
          inc( Result );
        if FieldByName( 'Markiert2' ).AsString = '+' then
          inc( Result );
      end;
    end;
  end;
end;


procedure TFHRAlgorithmus.FachEntmarkieren( const fach: string; const ia: integer );
begin
  with FC1 do
  begin
    if FieldByname( 'Fach' ).AsString <> fach then
      Locate( 'Fach', fach, [] );
    Edit;
    FieldByname( Format( 'Markiert%d', [ ia ] ) ).AsString := '-';
    Post;
  end;
end;

function TFHRAlgorithmus.FachMarkieren( const fach: string; const ia: integer; const auch_bei_0: boolean = false ): boolean;
begin
  Result := false;
  with FC1 do
  begin
    if FieldByname( 'Fach' ).AsString <> fach then
      Locate( 'Fach', fach, [] );
    if ( ( auch_bei_0 ) or ( FieldByname( Format( 'Punkte%d', [ ia ] ) ).AsInteger > 0 ) ) and ( FieldByname( Format( 'Markiert%d', [ ia ] ) ).AsString <> '+' ) then
    begin
      Edit;
      FieldByname( Format( 'Markiert%d', [ ia ] ) ).AsString := '+';
      Post;
      Result := true;
    end;
  end;
end;

function TFHRAlgorithmus.IstMarkiert( const fach: string; const ia: integer ): boolean;
begin
  Result := false;
  with FC1 do
  begin
    if FieldByname( 'Fach' ).AsString <> fach then
      Locate( 'Fach', fach, [] );
    Result := FieldByname( Format( 'Markiert%d', [ ia ] ) ).AsString  = '+';
  end;
end;


function TFHRAlgorithmus.AnzahlDefizite( const menge: string; const nur_markiert: boolean = true ): integer;
var
  fach: string;
  i: integer;
begin
  Result := 0;
  for i := 1 to AnzahlElemente( menge ) do
  begin
    fach := EinzelElement( menge, i );
    with FC1 do
    begin
      if FieldByname( 'Fach' ).AsString <> fach then
        Locate( 'Fach', fach, [] );
      if nur_markiert then
      begin
        if ( FieldByname( 'Markiert1' ).AsString = '+' ) and ( FieldByName( 'Punkte1' ).AsInteger <= C_DEF_PKT ) then
          Result := Result + 1;
        if ( FieldByname( 'Markiert2' ).AsString = '+' ) and ( FieldByName( 'Punkte2' ).AsInteger <= C_DEF_PKT ) then
          Result := Result + 1;
      end else
      begin
        if ( FieldByName( 'Punkte1' ).AsInteger <= C_DEF_PKT ) then
          Result := Result + 1;
        if ( FieldByName( 'Punkte2' ).AsInteger <= C_DEF_PKT ) then
          Result := Result + 1;
      end;
    end;
  end;
end;

function TFHRAlgorithmus.PunktSumme( const menge: string; const nur_markiert: boolean ): integer;
var
  fach: string;
  i: integer;
  do_it: boolean;
begin
  Result := 0;
  for i := 1 to AnzahlElemente( menge ) do
  begin
    fach := EinzelElement( menge, i );
    with FC1 do
    begin
      if FieldByname( 'Fach' ).AsString <> fach then
        Locate( 'Fach', fach, [] );

      if nur_markiert then
      begin
        do_it := FieldByname( 'Markiert1' ).AsString = '+';
        if do_it then
          Result := Result + FieldByName( 'Punkte1' ).AsInteger;

        do_it := FieldByname( 'Markiert2' ).AsString = '+';
        if do_it then
          Result := Result + FieldByName( 'Punkte2' ).AsInteger;
      end else
      begin
        do_it := FieldByName( 'Punkte1' ).AsInteger * FieldByName( 'Punkte2' ).AsInteger > 0;
        if do_it then
          Result := FieldByName( 'Punkte1' ).AsInteger + FieldByName( 'Punkte2' ).AsInteger;
      end;
    end;
  end;
end;

procedure TFHRAlgorithmus.BestenKursMarkieren( const fach: string );
begin
  with FC1 do
  begin
    if FieldByname( 'Fach' ).AsString <> fach then
      Locate( 'Fach', fach, [] );
    if FieldByName( 'Punkte1' ).AsInteger >= FieldByname( 'Punkte2' ).AsInteger then
      FachMarkieren( fach, 1 )
    else
      FachMarkieren( fach, 2 );
  end;
end;

procedure TFHRAlgorithmus.Auffuellen;
var
  i, i1, i2: integer;
  anz_gk_markiert: integer;
  fach, ka1, ka2, pjfach: string;
  ist_pjk: boolean;
  p_pjk1, p_pjk2, p1, p2: integer;
  anz_hinzu_min: integer;
begin
// Jetzt Auffüllen
// Erst mal den aktuellen Stand ermitteln
  if FSchulform = 'WB' then
    anz_hinzu_min := 4
  else
    anz_hinzu_min := 2;
  anz_gk_markiert := 0;
  p_pjk1 := 0;
  p_pjk2 := 0;
  FFachSorter.Clear;
  ist_pjk := false;
  pjfach := '';
  with FC1 do
  begin
    First;

    while not Eof do
    begin
      Fach := FieldByName( 'Fach' ).AsString;
      if PruefeBelegungKursart( fach, 'GK;ZK;PJ', FGliederung = 'KL' ) then
      begin // nur GK's berücksichtigen
        ka1 := FieldByname( 'Kursart1' ).AsString;
        ka2 := FieldByname( 'Kursart2' ).AsString;
// Projektkurse hier gesondert behandeln
        ist_pjk := not ist_pjk and ( ( Fach = 'PX' ) or ( ka1 = 'PJK' ) or ( ka2 = 'PJK' ) );

        if FieldByname( 'Markiert1' ).AsString = '+' then
          inc( anz_gk_markiert )
        else if not ist_pjk then
          FFachSorter.Add( fach, 1, Punkte( fach, 1 ) )
        else
          p_pjk1 := FieldByName( 'Punkte1' ).AsInteger;

        if FieldByname( 'Markiert2' ).AsString = '+' then
          inc( anz_gk_markiert )
        else if not ist_pjk then
          FFachSorter.Add( fach, 2, Punkte( fach, 2 ) )
        else
          p_pjk2 := FieldByName( 'Punkte2' ).AsInteger;

        if ist_pjk then
        begin // dafür sorgen, dass beide Punkte gleich sind
//          p_pjk2 := Max( p_pjk1, p_pjk2 );
          p_pjk1 := p_pjk2;
          pjfach := Fach;
        end;
      end;
      Next;
    end;
  end;

  if anz_gk_markiert >= C_GK_MARKIERT then
    exit;

  FAuffuellFaecher.Clear;

  try
    FFachSorter.Sortieren( true );
    for i := 0 to High( FFachSorter.Daten ) do
    begin
      if anz_gk_markiert >= C_GK_MARKIERT then
        break; // fertig
      FachMarkieren( FFachSorter.Daten[i].Fach, FFachSorter.Daten[i].Abschnitt );
      FAuffuellFaecher.Add( FFachSorter.Daten[i].Fach, FFachSorter.Daten[i].Abschnitt, FFachSorter.Daten[i].Punkte );
      inc( anz_gk_markiert );
    end;

// Prüfen, ob die Projektkurse hinzu kommen können
// Regelung WBK, KL:
// Es müssen mindestens 2 "normale" Fächer bleiben, d.h. eine Berücksichtigung der PJK's ist nur dann
// Möglich, wenn mindesten 4 Einträgfe hinzugekommen sind (die PJK's müssen ja 2 vorhandene ersetzen)
//Regelung GY, GE:
//eine Berücksichtigung der PJK's ist nur dann
// Möglich, wenn mindesten 2 Einträgfe hinzugekommen sind (die PJK's müssen ja 2 vorhandene ersetzen)
    if ( p_pjk1 > 0 ) and ( p_pjk2 > 0 ) and ( FAuffuellFaecher.Anzahl >= anz_hinzu_min ) then
    begin // Grundvoraussetzung erfüllt
// Die Punktsumme der letzen beiden Einträge
      i2 := High( FAuffuellFaecher.Daten );
      p2 := FAuffuellFaecher.Daten[i2].Punkte;
      i1 := High( FAuffuellFaecher.Daten ) - 1;
      p1 := FAuffuellFaecher.Daten[i1].Punkte;
      if p1 + p2 < p_pjk1 + p_pjk2 then
      begin // Die Projektkurse würden das Ergebnis verbessern
// Die alten Einträge entmarkieren
        FachEntmarkieren( FAuffuellFaecher.Daten[i2].Fach, FAuffuellFaecher.Daten[i2].Abschnitt );
        FachEntmarkieren( FAuffuellFaecher.Daten[i1].Fach, FAuffuellFaecher.Daten[i1].Abschnitt );
        FachMarkieren( pjfach, 1, true );
        FachMarkieren( pjfach, 2, true );
      end;
    end;
  finally
  end;
end;



function TFHRAlgorithmus.PruefeFHRBelegung_WB10: boolean;
// für WBK hier findet auch die interne Markierung statt
var
  M, fach, fachmax: string;
  i, psum, psummax, nmark_gs, nmark_nw: integer;
  zu_wenig: boolean;
  gw_nw_lk: string;
  gk_def, sum_gk_def: integer;

begin
  Result := true;
  FFachSorter.Clear;
  sum_gk_def := 0;

  if FGliederung = 'KL' then
    C_GK_MARKIERT := 11
  else if FGliederung = 'AG' then
    C_GK_MARKIERT := 5;

// Zuerst die Leistungskurse
  Result := AnzahlElemente( LK ) = 2;
  if not Result then
    Meldung ( 'Fehler: Falsche Anzahl von Leistungskursen' )
  else
    Result := PruefeBelegungPunkte( LK );
  if not Result then
    exit;

  if FGliederung = 'KL' then
  begin // In KL alle LK markieren
    for i := 1 to AnzahlElemente( LK ) do
    begin
      fach := EinzelElement( LK, i );
      FachMarkieren( fach, 1 );
      FachMarkieren( fach, 2 );
    end;
  end else if FGliederung = 'AG' then
  begin // bei AG nur die 3 besten LK-Kurse nehmen
    FFachSorter.Clear;
// NEU: Hier prüfen, ob in den LK's genau ein LK aus NW oder GW ist
    gw_nw_lk := VereinigungsMenge( Schnittmenge( LK, W2 ), Schnittmenge( LK, W3_2 ) );
    if AnzahlElemente( gw_nw_lk ) = 1 then
    begin // Markiere beide Kurse
      FachMarkieren( gw_nw_lk, 1 );
      FachMarkieren( gw_nw_lk, 2 );

// Jetzt noch das restliche Fach ermitteln
      fach := DifferenzMenge( LK, gw_nw_lk );
      FFachSorter.Add( fach, 1, Punkte( fach, 1 ) );
      FFachSorter.Add( fach, 2, Punkte( fach, 2 ) );
      FFachSorter.Sortieren( true ); // Absteigend sortieren
      FachMarkieren( FFachSorter.Daten[0].Fach, FFachSorter.Daten[0].Abschnitt );
    end else
    begin // Normales Markieren der besten drei LK's
      for i := 1 to AnzahlElemente( LK ) do
      begin
        fach := EinzelElement( LK, i );
        FFachSorter.Add( fach, 1, Punkte( fach, 1 ) );
        FFachSorter.Add( fach, 2, Punkte( fach, 2 ) );
      end;
      FFachSorter.Sortieren( true ); // Absteigend sortieren
      for i := 0 to 2 do // 3 Kurse markieren
        FachMarkieren( FFachSorter.Daten[i].Fach, FFachSorter.Daten[i].Abschnitt );
    end;
  end;



// Ist D LK?
  if IstLeer( SchnittMenge( 'D', LK ) ) then
  begin // Deutsch ist kein LK
    Result := PruefeBelegungPunkte( 'D' ); // D muss in beiden Abschnitten belegt sein
    if Result then
      Result := PruefeBelegungKursart( 'D', 'GK' );
    if not Result then
      exit;
    if FGliederung = 'KL' then
    begin // Beide D-Kurse markieren
      FachMarkieren( 'D', 1 );
      FachMarkieren( 'D', 2 );
    end else if FGliederung = 'AG' then
    begin
//Sonderfall AG: Falls ein LK aus W3_2 und ein LK aus ( W2_1 U W2_2 ), dann nur besten D-Kurs markieren
      if gw_nw_lk <> '' then
        BestenKursMarkieren( 'D' )
      else
      begin
        FachMarkieren( 'D', 1 );
        FachMarkieren( 'D', 2 );
      end;
    end;
    sum_gk_def := sum_gk_def + AnzahlDefizite( 'D' );
  end;

// Ist M <> LK?
  if IstLeer( SchnittMenge( 'M', LK ) ) then
  begin
    Result := PruefeBelegungPunkte( 'M' );
    if Result then
      Result := PruefeBelegungKursart( 'M', 'GK' );
    if not Result then
      exit;
    FachMarkieren( 'M', 1 );
    FachMarkieren( 'M', 2 );
    sum_gk_def := sum_gk_def + AnzahlDefizite( 'M' );
  end;

// 1. FS <> LK
  if ( WB_FS1 <> '' ) then
  begin
    if IstLeer( SchnittMenge( WB_FS1, LK ) ) then
    begin
      Result := PruefeBelegungPunkte( WB_FS1 );
      if Result then
        Result := PruefeBelegungKursart( WB_FS1, 'GK' );
      if not Result then
        exit;
      FachMarkieren( WB_FS1, 1 );
      FachMarkieren( WB_FS1, 2 );
      sum_gk_def := sum_gk_def + AnzahlDefizite( WB_FS1 );
    end;
  end else
  begin
    Result := false;
    exit;
  end;

//	Für Gliederung Kolleg
// Für den Bildungsgang KL gilt:
//   Unter den anzurechnenden Kursen müssen entweder als LK oder als GK  je zwei Halbjahreskurse in
//   Deutsch, in der 1. Fremdsprache, in einem Fach des gesellschaftswissenschaftlichen  Aufgabenfeldes,
//   in Mathematik und in einer Naturwissenschaft enthalten sein.
//   d.h: je zwei D-Kurse, zwei 1. Fremdsprache-Kurse, zwei GWS-FachKurse, zwei Mathematikkurse und zwei NWS-Fachkurse sind Pflichtkurse (>0 Pkt,)

  if FGliederung = 'KL' then
  begin
// Ist NW <> LK
    if IstLeer( SchnittMenge( W3_2, LK ) ) then
    begin // kein NW in LK, markiere GK-Fach mit bester Punktsumme

      psummax := 0;
      fachmax := '';
      for i := 1 to AnzahlElemente( W3_2 ) do
      begin
        fach := EinzelElement( W3_2, i );
        psum := PunktSumme( fach, false );
        if psum > psummax then
        begin
          psummax := psum;
          fachmax := fach;
        end;
      end;

      if fachmax <> '' then
      begin
        Result := PruefeBelegungPunkte( fachmax );
        if Result then
          Result := PruefeBelegungKursart( fachmax, 'GK' );
        if not Result then
          exit;
        FachMarkieren( fachmax, 1 );
        FachMarkieren( fachmax, 2 );
      end;
    end;

// Weiter KL: Ist Gesellschaftwissenschaft <> LK
    if IstLeer( SchnittMenge( W2, LK ) ) then
    begin // Keine GW in LK
      psummax := 0;
      fachmax := '';
      for i := 1 to AnzahlElemente( W2 ) do
      begin
        fach := EinzelElement( W2, i );
        psum := PunktSumme( fach, false );
        if psum > psummax then
        begin
          psummax := psum;
          fachmax := fach;
        end;
      end;
      if fachmax <> '' then
      begin
        Result := PruefeBelegungPunkte( fachmax );
        if Result then
          Result := PruefeBelegungKursart( fachmax, 'GK' );
        if not Result then
          exit;
        FachMarkieren( fachmax, 1 );
        FachMarkieren( fachmax, 2 );
      end;
    end;

  end else if FGliederung = 'AG' then
  begin
// Ist eine GW oder eine NW in LK?
    if gw_nw_lk = '' then
    begin
      M := Vereinigungsmenge( W2, W3_2 ); // Suche Fach aus W2 oder W3_2 mit max. Punktzahl
      psummax := 0;
      fachmax := '';
      for i := 1 to AnzahlElemente( M ) do
      begin
        fach := EinzelElement( M, i );
        psum := PunktSumme( fach, false );
        gk_def := AnzahlDefizite( fach, false );
        if ( psum > psummax ) and ( gk_def + sum_gk_def < 3 ) then
        begin
          psummax := psum;
          fachmax := fach;
        end;
      end;
      if fachmax <> '' then
      begin
        Result := PruefeBelegungPunkte( fachmax );
        if Result then
          Result := PruefeBelegungKursart( fachmax, 'GK' );
        if not Result then
          exit;
        FachMarkieren( fachmax, 1 );
        FachMarkieren( fachmax, 2 );
        sum_gk_def := sum_GK_DEf + AnzahlDefizite( fach );
      end;
    end;

// Jetzt noch prüfen, ob auch genügend NW und GS markiert sind, wenn diese LK's sind, kann es vorkommen, dass zu wenige
// Kurse markiert sind, weil nur die 3 besten LK's markiert wurden, so dass darin u.U. nur ein NW oder GS dabei ist
    nmark_gs := 0;
    nmark_nw := 0;
    if not IstLeer( Schnittmenge( W2, LK ) ) or not IstLeer( Schnittmenge( W3_2, LK ) ) then
    begin
      nmark_gs := AnzahlMarkiert( Schnittmenge( W2, LK ), false );
      nmark_nw := AnzahlMarkiert( Schnittmenge( W3_2, LK ), false );
      if ( nmark_gs < 2 ) and ( nmark_nw < 2 ) then
      begin
        if nmark_gs = 1 then
          M := Schnittmenge( W2, LK )
        else
          M := Schnittmenge( W3_2, LK );
        fach := EinzelElement( M, 1 );
        FachMarkieren( fach, 1 );
        FachMarkieren( fach, 2 );
      end;
    end;


{      if nmark_gw < 2 then
      begin
        M := Schnittmenge( W2, LK );
        for i := 1 to AnzahlElemente( M ) do
        begin
          fach := EinzelElement( M, i );
          if FachMarkieren( fach, 1 ) then
            inc( nmark );
          if FachMarkieren( fach, 2 ) then
            inc( nmark );
        end;
      end;

      if nmark_nw < 2 then
      begin
        M := Schnittmenge( W3_2, LK );
        for i := 1 to AnzahlElemente( M ) do
        begin
          fach := EinzelElement( M, i );
          if FachMarkieren( fach, 1 ) then
            inc( nmark );
          if FachMarkieren( fach, 2 ) then
            inc( nmark );
        end;
      end;
    end;}
  end;

// Jetzt die in C2 "geparkten" Einträge (diese enthalten die Fächer, die nur in einem Abschnitt belegt sind), zu C1 hinzufügen
  if ( FGliederung = 'KL') and ( FAbschnitt_1 = 1 ) and ( FAbschnitt_2 = 2 ) then
  begin
    fC2.First;
    while not fC2.Eof do
    begin
      fach := FC2.FieldByName( 'Fach' ).AsString;
      fC1.Append;
      FC1.FieldByName( 'Fach' ).AsString := fach;
      RBKCopyRecord( fC2, fC1 );
      fC1.Post;
      fC2.Next;
    end;
  end;

  Auffuellen;


// Neue Überlegung: Optimierung versuchen
  if FGliederung = 'KL' then
  begin
    if IstLeer( SchnittMenge( W3_2, LK ) ) then // kein NW in LK, potentielle Optimierung möglich
      OptimierungPruefen_KL( W3_2 );

    if IstLeer( SchnittMenge( W2, LK ) ) then
      OptimierungPruefen_KL( W2 );
  end else
    OptimierungPruefen_AG;


end;


function TFHRAlgorithmus.OptimierungPruefen_KL( const menge: string ): boolean;

  procedure Daten_Holen( var fr: TFachRec2 );
  begin
    with FC1 do
    begin
      Locate( 'Fach', fr.Fach, [] );
      fr.AnzM := 0;
      fr.SumM := 0;
      fr.M1 := FieldByName( 'Markiert1' ).AsString = '+';
      fr.M2 := FieldByName( 'Markiert2' ).AsString = '+';
      fr.P1 := FieldByName( 'Punkte1' ).AsInteger;
      fr.P2 := FieldByName( 'Punkte2' ).AsInteger;
      if fr.M1 then
      begin
        inc( fr.AnzM );
        inc( fr.SumM, fr.P1 );
      end;
      if fr.M2 then
      begin
        inc( fr.AnzM );
        inc( fr.SumM, fr.P2 );
      end;
    end;
  end;

var
  fach: string;
  f1, f2, ft: TFachRec2;
  sum_akt: integer;


begin
  if AnzahlElemente( menge ) <> 2 then
    exit;

  f1.Fach := EinzelElement( menge, 1 );
  Daten_Holen( f1 );

  f2.Fach := EinzelElement( menge, 2 );
  Daten_Holen( f2 );

  if ( f1.AnzM = f2.AnzM ) or ( f1.AnzM = 0 ) or ( f2.AnzM = 0 ) then
    exit; // nichts zu optimieren

  if ( f1.AnzM = 2 ) and ( f2.AnzM = 1 ) then
  begin // tauschen
    ft := f1;
    f1 := f2;
    f2 := ft;
  end;
// f1 enthält jetzt das Fach mit einer Markierung, f2 das mit 2 Markierungen
  sum_akt := f1.SumM + f2.SumM;

// Jetzt Markierungen tauschen
  with f1 do
  begin
    M1 := true;
    M2 := true;
    SumM := P1 + P2;
    AnzM := 2;
  end;

// Bei fs das geringere Punktfeld entmarkieren
  with f2 do
  begin
    if P1 < P2 then
    begin
      M1 := false;
      SumM := P2;
    end else
    begin
      M2 := false;
      SumM := P1;
    end;
    AnzM := 1;
  end;

  if ( f1.SumM + f2.SumM ) > sum_akt then
  begin // Optomierung bringt besseres Ergebnis
    FachEntmarkieren( f1.fach, 1 );
    FachEntmarkieren( f1.fach, 2 );
    if f1.M1 then
      FachMarkieren( f1.fach, 1 );
    if f1.M2 then
      FachMarkieren( f1.fach, 2 );

    FachEntmarkieren( f2.fach, 1 );
    FachEntmarkieren( f2.fach, 2 );
    if f2.M1 then
      FachMarkieren( f2.fach, 1 );
    if f2.M2 then
      FachMarkieren( f2.fach, 2 );
  end;

end;


function TFHRAlgorithmus.OptimierungPruefen_AG: boolean;
var
  fach: string;
  i, ilast, iv, pv: integer;
  nw_lk, gs_lk: string;
  nw_m, gs_m: string;
  gsnw_lk, anderer_lk: string;
  gsnw_mark: integer;
begin

// Falls ein NW-Fach oder ein GS-Fach LK ist, dann püüfen, ob die NW-GS-Belegung bereits durch ein anderes Fach erfüllt wird, dann kann evtl. der LK getauscht werden

  if AnzahlMarkiert( LK, false ) = 4 then
    exit; // alle LK's markiert

// Erst mal prüfen, ob ein NW oder GS-Kurs LK ist
  gs_lk := SchnittMenge( LK, W2 );
  nw_lk := SchnittMenge( LK, W3_2 );


// Wenn keine NW oder GS LK ist (oder beide) dann raus
  if IstLeer( gs_lk ) and IstLeer( nw_lk ) then
    exit;

  if not IstLeer( gs_lk ) and not IstLeer( nw_lk ) then
    exit;

  if not IstLeer( gs_lk ) then
  begin // GS ist LK
    gsnw_lk := gs_lk;
    gsnw_mark := AnzahlMarkiert( W3_2, true );
  end else
  begin // NW ist LK
    gsnw_lk := nw_lk;
    gsnw_mark := AnzahlMarkiert( W2, true );
  end;

  if gsnw_mark >= 2 then
  begin // Markierungsbedigung erfüllt
// Prüfen, ob
    anderer_lk := DifferenzMenge( LK, gsnw_lk );
    if PunktSumme( gsnw_lk, false ) >= PunktSumme( anderer_lk, false ) then
      exit; // Tauschen würde nichts bringen

// Wenn wir hier sind, bringt das Tauschen etwas
    FachMarkieren( anderer_lk, 1 );
    FachMarkieren( anderer_lk, 2 );

    FachEntMarkieren( gsnw_lk, 1 );
    FachEntMarkieren( gsnw_lk, 2 );

    if FC1.FieldByName( 'Punkte1' ).AsInteger >= FC1.FieldByName( 'Punkte2' ).AsInteger then
      FachMarkieren( gsnw_lk, 1 )
    else
      FachMarkieren( gsnw_lk, 2 );
  end;

{  for i := 1 to AnzahlElemente( LK ) do
  begin
    fach := EinzelElement( LK, i );
    if AnzahlMarkiert( fach, false ) = 2 then
      continue;

    if IstMarkiert( fach, 1 ) then
    begin
      iv := 1;
      pv := FC1.FieldByName( 'Punkte1' ).AsInteger;
    end else
    begin
      iv := 2;
      pv := FC1.FieldByName( 'Punkte2' ).AsInteger;
    end;

// Jetzt den letzen Eintrag der Auffüllliste suchen
    ilast := High( FAuffuellFaecher.Daten );

    if FAuffuellFaecher.Daten[ilast].Punkte < pv then
    begin // Tauschen bringt Vorteil
      FachEntmarkieren( FAuffuellFaecher.Daten[ilast].Fach, FAuffuellFaecher.Daten[ilast].Abschnitt );
      FachMarkieren( fach, iv );
    end;
  end;}

end;



function TFHRAlgorithmus.PruefeFHRBelegung: boolean;
// Prüft die korrekte Belegung in den beiden ausgewählten Abschnitten

  function PunkteVollstaendig( const fach: string ): boolean;
  begin
    if FC1.FieldByName( 'Fach' ).AsString <> fach then
      FC1.Locate( 'Fach', fach, [] );
    Result := ( FC1.FieldByName( 'Punkte1' ).AsInteger > 0 ) and ( FC1.FieldByName( 'Punkte2' ).AsInteger > 0 );
  end;


	function PruefeFHRBelegung_GY_GE: boolean;
  var
    i: integer;
    fach: string;
    is_ok: boolean;
	begin
		Result := true;
	// D in C1?
		if not fC1.Locate( 'Fach', 'D', [] ) then
		begin
	//		Meldung( 'Fehler: Deutsch fehlt' );
			Result := false;
		end else
    begin
      if not PunkteVollstaendig( FC1.FieldByName( 'Fach' ).AsString ) then
        Result := false;
    end;


	// Gibt es ein Fach aus F1_2 U F1_3 in C1?
		if FS = '' then
		begin
	//		Meldung( 'Fehler: Keine Fremdsprache belegt' );
			Result := false;
		end else
    begin
      is_ok := false;
      for i := 1 to AnzahlElemente( FS ) do
      begin
        fach := EinzelElement( FS, i );
        is_ok := PunkteVollstaendig( fach );
        if is_ok then
          break;
      end;
      if not is_ok then
        Result := false;
    end;

	// Gibt es ein Fach aus F2 in C1
		if W2 = '' then
		begin
	//		Meldung( 'Fehler: Kein gesellschaftswiss. Fach belegt' );
			Result := false;
		end else
    begin
      is_ok := false;
      for i := 1 to AnzahlElemente( W2 ) do
      begin
        fach := EinzelElement( W2, i );
        is_ok := PunkteVollstaendig( fach );
        if is_ok then
          break;
      end;
      if not is_ok then
        Result := false;
    end;

	// M in C1?
		if not FC1.Locate( 'Fach', 'M', [] ) then
		begin
	//		Meldung( 'Mathematik fehlt' );
			Result := false;
		end else
    begin
      if not PunkteVollstaendig( FC1.FieldByName( 'Fach' ).AsString ) then
        Result := false;
    end;


	// Gibt esein Fach aus F3_2
		if W3_2 = '' then
		begin
	//		Meldung( 'Kein naturwissenschaftliches Fach belegt' );
			Result := false;
		end else
    begin
      is_ok := false;
      for i := 1 to AnzahlElemente( W3_2 ) do
      begin
        fach := EinzelElement( W3_2, i );
        is_ok := PunkteVollstaendig( fach );
        if is_ok then
          break;
      end;
      if not is_ok then
        Result := false;
    end;

		if NumToken( LK, ';' ) <> 2 then
			Result := false
		else
    begin
      is_ok := false;
      for i := 1 to AnzahlElemente( LK ) do
      begin
        fach := EinzelElement( LK, i );
        is_ok := PunkteVollstaendig( fach );
        if is_ok then
          break;
      end;
      if not is_ok then
        Result := false;
    end;

	end;

	function PruefeFHRBelegung_WB: boolean;
//alte Version, neu ist PruefeFHRBelegung_WB10
	var
		i: integer;
	begin
		Result := true;
// Deutsch vorhanden?
		Result := PruefeBelegungPunkte( 'D' );
		if not Result then
			exit;
// Mathe vorhanden?
		Result := PruefeBelegungPunkte( 'M' );
		if not Result then
			exit;
//	Nat.Wiss vorhanden?
		if FGliederung = 'KL' then
		begin
			Result := PruefeBelegungPunkte( W3_2 );
			if not Result then
				exit;
		end;
//	Fremdsprache vorhanden?
		Result := PruefeBelegungPunkte( FS );
		if not Result then
			exit;
// Gesell. vorhanden
		if FGliederung = 'KL' then
		begin
			Result := PruefeBelegungPunkte( W2 );
			if not Result then
				exit;
		end else
			Result := W2 <> '';

//	LK-Fächerbelegung prüfen
		Result := ( SchnittMenge( FS, LK ) <> '' ) or ( Schnittmenge( W3_2, LK ) <> '' ) or InMenge( 'M', LK );
		if not Result then
			Result := InMenge( 'D', LK );
	end;

//----------------------------------------------------------------------------------
begin
	Result := true;
	if ( fSchulform = 'GY' ) or ( fSchulform = 'GE' ) or ( fSchulform = 'BK' ) or ( fSchulform = 'SB' ) then
		Result := PruefeFHRBelegung_GY_GE
	else if ( fSchulform = 'WB' ) then
  begin
    if AnsiStartsText( 'APO-WBK10', FPruefOrdnung ) then
  		Result := PruefeFHRBelegung_WB10
    else
      Result := PruefeFHRBelegung_WB;
  end;
end;



procedure TFHRAlgorithmus.MarkierungenSetzen( const i1,i2: integer );
var
	D_Erl, FS_Erl, GS_Erl, M_Erl, NW_Erl: boolean;
	i : integer;
	fach: string;
	z : integer;
	psum, psummax, pdiff, pdiffmin, imax: integer;
	act_id: integer;

	function MaxPunkteID: integer;
	begin
		Result := 0;
		fC1.First;
		while not fC1.Eof do
		begin
			if fC1.FieldByName( 'Punkte1' ).AsInteger > psummax then
			begin
				psummax := fC1.FieldByName( 'Punkte1' ).AsInteger;
				Result := fC1.FieldByname( 'ID' ).AsInteger;
			end;
			if fC1.FieldByName( 'Punkte2' ).AsInteger > psummax then
			begin
				psummax := fC1.FieldByName( 'Punkte2' ).AsInteger;
				Result := fC1.FieldByname( 'ID' ).AsInteger;
			end;
			fC1.Next;
		end;
	end;

	procedure BestesFachSuchen;
	var
		p1, p2: integer;
	begin
		p1 := fC1.FieldByName( 'Punkte1' ).AsInteger;
		p2 := fC1.FieldByName( 'Punkte2' ).AsInteger;
		if p1*p2 = 0 then
			exit;
		psum := p1 + p2;
		pdiff := abs( p1 - p2 );
		if psum > psummax then
		begin
			psummax := psum;
			pdiffmin := pdiff;
			imax := fC1.FieldByname( 'ID' ).AsInteger;
		end else if ( psummax > 0 ) and ( psum = psummax ) then
		begin	// zwei Fächer mit gleicher Summe, prüfen, ob Differenz kleiner
			if pdiff < pdiffmin then
			begin
				pdiffmin := pdiff;
				imax := fC1.FieldByname( 'ID' ).AsInteger;
			end;
		end;
	end;

	procedure Markieren_WB( const ia: integer );
	begin
		with fC1 do
		begin
//			ShowMessage( FieldByName( 'Fach' ).AsString );
			Edit;
			FieldByname( Format( 'Markiert%d', [ ia ] ) ).AsString := '+';
			Post;
		end;
	end;


	procedure MarkierungenSetzen_GY_GE;
	var
		i : integer;
	begin

// Sichern
    FC2.EmptyTable;
    FC1.First;
    while not FC1.Eof do
    begin
      FC2.Insert;
			RBKCopyRecord( fC1, fC2 );
      FC2.Post;
      FC1.Next;
    end;
    C_GK_Markiert := 11;
	// Zuerst die Leistungskurse
		for i := 1 to NumToken( LK, ';' ) do
		begin
			fach := GetToken( LK, ';', i );
			if fach = 'D' then
				D_Erl := true
			else if InMenge( fach, FS ) then
				FS_Erl := true
			else if InMenge( fach, W2 ) then
				GS_Erl := true
			else if fach = 'M' then
				M_Erl := true
			else if InMenge( fach, W3_2 ) then
				NW_Erl := true;

			if fC1.Locate( 'Fach', fach, [] ) then
			begin
        FachMarkieren( fach, 1 );
        FachMarkieren( fach, 2 );
//				TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i1], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
//				TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i2], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
//				fC1.Delete;
			end;
		end;

		z := 0;

	// Nun die Pflichtfächer
		if not D_Erl then
		begin
			if fC1.Locate( 'Fach', 'D', [] ) then
			begin
        fach := FC1.FieldByName( 'Fach' ).AsString;
        FachMarkieren( fach, 1 );
        FachMarkieren( fach, 2 );
//				TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i1], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
//				TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i2], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
//				fC1.Delete;
				inc( z, 2 );
			end;
		end;

	// Suche Suche das Fach X in C1, dessen Punktsumme aus beiden Abschnitten maximal ist.
	// Gibt es mehrere Fächer mit gleicher Punktsumme, wähle das Fach, bei dem die Punktedifferenz minimal ist.
	// Markiere Markiere beide Lernabschnitte für X, Entferne X aus C1, z:= z + 2

		if not FS_Erl then
		begin
			psummax := 0;
			pdiffmin := 10000;
			imax := 0;
			for i := 1 to NumToken( FS, ';' ) do
			begin
				fach := GetToken( FS, ';', i );
				if fC1.Locate( 'Fach', fach, [] ) then
					BestesFachSuchen;
			end;
			if imax > 0 then
			begin
				fC1.Locate( 'ID', imax, [] );
        fach := FC1.FieldByName( 'Fach' ).AsString;
        FachMarkieren( fach, 1 );
        FachMarkieren( fach, 2 );
//				TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i1], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
//				TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i2], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
//				fC1.Delete;
				inc( z, 2 );
			end;
		end;

		if not GS_Erl then
		begin
			psummax := 0;
			pdiffmin := 10000;
			imax := 0;
			for i := 1 to NumToken( W2, ';' ) do
			begin
				fach := GetToken( W2, ';', i );
				if fC1.Locate( 'Fach', fach, [] ) then
					BestesFachSuchen;
			end;
			if imax > 0 then
			begin
				fC1.Locate( 'ID', imax, [] );
        fach := FC1.FieldByName( 'Fach' ).AsString;
        FachMarkieren( fach, 1 );
        FachMarkieren( fach, 2 );
//				TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i1], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
//				TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i2], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
//				fC1.Delete;
				inc( z, 2 );
			end;
		end;

		if not M_Erl then
		begin
			if fC1.Locate( 'Fach', 'M', [] ) then
			begin
        fach := FC1.FieldByName( 'Fach' ).AsString;
        FachMarkieren( fach, 1 );
        FachMarkieren( fach, 2 );
//				TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i1], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
//				TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i2], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
//				fC1.Delete;
				inc( z, 2 );
			end;
		end;

		if not NW_Erl then
		begin
			psummax := 0;
			pdiffmin := 10000;
			imax := 0;
			for i := 1 to NumToken( W3_2, ';' ) do
			begin
				fach := GetToken( W3_2, ';', i );
				if fC1.Locate( 'Fach', fach, [] ) then
					BestesFachSuchen;
			end;
			if imax > 0 then
			begin
				fC1.Locate( 'ID', imax, [] );
        fach := FC1.FieldByName( 'Fach' ).AsString;
        FachMarkieren( fach, 1 );
        FachMarkieren( fach, 2 );
//				TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i1], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
//				TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i2], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
//				fC1.Delete;
				inc( z, 2 );
			end;
		end;

// Jetzt Auffüllen
    Auffuellen;

// Und Speichern
    with FC1 do
    begin
      First;
      while not Eof do
      begin
        if ( FieldByname( 'Markiert1' ).AsString = '+' ) then
          TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i1], QuotedStr( '+' ), FieldByName( 'ID' ).AsInteger ] ) );
        if ( FieldByname( 'Markiert2' ).AsString = '+' ) then
          TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i2], QuotedStr( '+' ), FieldByName( 'ID' ).AsInteger ] ) );
        Next;
      end;
    end;
{
	// Nun die Restfächer
	// C1 := C1 U C2
		fC2.First;
		while not fC2.Eof do
		begin
			fC1.Append;
			RBKCopyRecord( fC2, fC1 );
			fC1.Post;
			fC2.Next;
		end;

		fC1.First;
		while ( z < 11 ) and not fC1.Eof do
		begin
			psummax := 0;
			act_id := fC1.FieldByname( 'ID' ).AsInteger;
			imax := MaxPunkteID;
			if imax = 0 then
				break
			else
			begin
				fC1.Locate( 'ID', imax , [] );
				fC1.Edit;
				if fC1.FieldByName( 'Punkte1' ).AsInteger > fC1.FieldByName( 'Punkte2' ).AsInteger then
				begin
					fC1.FieldByName( 'Punkte1' ).AsInteger := 0;
					TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i1], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
				end else
				begin
					fC1.FieldByName( 'Punkte2' ).AsInteger := 0;
					TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i2], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
				end;
				inc( z );
				fC1.Locate( 'ID', act_id, [] );
			end;
		end;}
	end;
//--------------------------end procedure MarkierungenSetzen_GY_GE--------------------------

	procedure MarkierungenSetzen_WB;


		procedure SchlechteresFachEntmarkieren( const fach: string );
		begin
			with fC1 do
			begin
				if not Locate( 'Fach', fach, [] ) then
					exit;
				if ( FieldByName( 'Punkte1' ).AsInteger < FieldByname( 'Punkte2' ).AsInteger ) and ( FieldByName( 'Markiert1' ).AsString = '+' ) then
				begin
					Edit;
					FieldByName( 'Markiert1' ).AsString := '-';
//					FieldByName( 'Punkte1' ).AsInteger := 0;
					Post;
				end else if ( FieldByName( 'Punkte2' ).AsInteger < FieldByname( 'Punkte1' ).AsInteger ) and ( FieldByName( 'Markiert2' ).AsString = '+' ) then
				begin
					Edit;
					FieldByName( 'Markiert2' ).AsString := '-';
//					FieldByName( 'Punkte2' ).AsInteger := 0;
					Post;
				end;
			end;
		end;

		function Sonderfaelle_AG_Erfuellt( var cnt: integer ): boolean;
		var
			M, M2: string;
		begin
			if not D_Erl then
			begin	// nur Grundkurse!!
				M := Schnittmenge( FS, LK );
				if NumToken( M , ';' ) > 1 then
	// Haben Studierende als LK`s zwei Fremdsprachen wird im GK Bereich nur ein Deutschkurs gewertet
	//			In die Gesamtrechung zur FHR darf nur ein Kurs Deutsch eingehen.
	//			Die schlechtere Deutschnote der Semester   h oder (h+1) wird „entmarkiert"
					SchlechteresFachEntmarkieren( 'D' )
				else
				begin
	// Haben Studierende eine Naturwissenschaft und ein gesellschaftswissenschaftliches Fach, wird im GK Bereich nur ein Deutschkurs gewertet
//#[(W3.2)geschnitten LK]>0 und #[(W2.1)geschnitten LK]>0 ]
					M := Schnittmenge( W3_2, LK );
					M2 := Schnittmenge( W2, LK );
					if ( NumToken( M, ';' ) > 0 ) and ( NumToken( M2, ';' ) > 0 ) then
					begin
						SchlechteresFachEntmarkieren( 'D' );
						dec( cnt );
					end;
				end;
			end;

			if not M_Erl then
			begin
// Bei zwei Naturwissenschaften wird nur ein Mathematukkurs gewertet.(jeweils der bessere)
				M := Schnittmenge( W3_2, LK );
				if NumToken( M, ';' ) > 1 then
				begin
					SchlechteresFachEntmarkieren( 'M' );
					dec( cnt );
				end;
			end;
		end;

	var
		i, j : integer;
		pmax, p: integer;
		M, fmax: string;
		ok: boolean;
		GK_Quali: integer;
	begin
// Zuerst die Leistungskurse
		pmax := 0;
		for i := 1 to NumToken( LK, ';' ) do
		begin
			fach := GetToken( LK, ';', i );
			if fC1.Locate( 'Fach', fach, [] ) then
			begin
				p := fC1.FieldByName( 'Punkte1' ).AsInteger;
				if ( p > pmax ) then
				begin
					pmax := p;
					fmax := fach;
				end;
				if fach = 'D' then
					D_Erl := true
				else if InMenge( fach, FS ) then
					FS_Erl := true
				else if InMenge( fach, W2 ) then
					GS_Erl := true
				else if fach = 'M' then
					M_Erl := true
				else if InMenge( fach, W3_2 ) then
					NW_Erl := true;

				// in AG wird nur das 2. HJ grundsätzlich markiert, im 1. HJ nur der bessere Kurs
				if fGliederung = 'KL'  then
					Markieren_WB( 1 );
				Markieren_WB( 2 );
			end;
		end;
// Für AG hier den besten Kurs aus 1. Hj. markieren
		if ( fGliederung = 'AG' ) and fC1.Locate( 'Fach', fmax, [] ) then
			Markieren_WB( 1 );

		z := 0;
//		exit;

// Nun Deutsch
		if not D_Erl then
		begin
			if fC1.Locate( 'Fach', 'D', [] ) then
			begin
// Wenn 3 u. 4. Abschitt, dann muss Deutsch die Kursart GKS haben!
				ok := true;
				if i1 = 1 then
					ok := ( SchrKA.IndexOf( fC1.FieldByName( 'Kursart1' ).AsString ) > 0 ) and ( SchrKA.IndexOf( fC1.FieldByName( 'Kursart2' ).AsString ) > 0 );
				if ok then
				begin
					Markieren_WB( 1 );
					Markieren_WB( 2 );
					inc( z, 2 );
				end;
			end;
		end;

// Nun Mathe
		if not M_Erl then
		begin
			if fC1.Locate( 'Fach', 'M', [] ) then
			begin
// Wenn 3 u. 4. Abschitt, dann muss Mathe die Kursart GKS haben!
				ok := true;
				if i1 = 1 then
					ok := ( SchrKA.IndexOf( fC1.FieldByName( 'Kursart1' ).AsString ) > 0 ) and ( SchrKA.IndexOf( fC1.FieldByName( 'Kursart2' ).AsString ) > 0 );
				if ok then
				begin
					Markieren_WB( 1 );
					Markieren_WB( 2 );
					inc( z, 2 );
				end;
			end;
		end;

// Nun Fremdsprache
		if not FS_Erl then
		begin
			if fC1.Locate( 'Fach', WB_FS1, [] ) then
			begin
// Wenn 3 u. 4. Abschitt, dann muss FS die Kursart GKS haben!
				ok := true;
				if i1 = 1 then
					ok := ( SchrKA.IndexOf( fC1.FieldByName( 'Kursart1' ).AsString ) > 0 ) and ( SchrKA.IndexOf( fC1.FieldByName( 'Kursart2' ).AsString ) > 0 );
				if ok then
				begin
					Markieren_WB( 1 );
					Markieren_WB( 2 );
					inc( z, 2 );
				end;
			end;
		end;

// Nun NW
		if fGliederung = 'KL' then
		begin
			if not NW_Erl then
			begin
				psummax := 0;
				pdiffmin := 10000;
				imax := 0;
				for i := 1 to NumToken( W3_2, ';' ) do
				begin
					fach := GetToken( W3_2, ';', i );
					if fC1.Locate( 'Fach', fach, [] ) then
						BestesFachSuchen;
				end;
				if imax > 0 then
				begin
					fC1.Locate( 'ID', imax, [] );
					Markieren_WB( 1 );
					Markieren_WB( 2 );
					inc( z, 2 );
				end;
			end;

	// Nun GS
			if not GS_Erl then
			begin
				psummax := 0;
				pdiffmin := 10000;
				imax := 0;
				for i := 1 to NumToken( W2, ';' ) do
				begin
					fach := GetToken( W2, ';', i );
					if fC1.Locate( 'Fach', fach, [] ) then
						BestesFachSuchen;
				end;
				if imax > 0 then
				begin
					fC1.Locate( 'ID', imax, [] );
					Markieren_WB( 1 );
					Markieren_WB( 2 );
					inc( z, 2 );
				end;
			end;

		end else if FGliederung = 'AG' then
		begin
			M := Vereinigungsmenge( W2, W3_2 );
			if SchnittMenge( M, LK ) = '' then
			begin	// keine nat.wiss. und gesellw. Fach in LK
				psummax := 0;
				pdiffmin := 10000;
				imax := 0;
				for i := 1 to NumToken( M, ';' ) do
				begin
					fach := GetToken( M, ';', i );
					if fC1.Locate( 'Fach', fach, [] ) then
						BestesFachSuchen;
				end;
				if imax > 0 then
				begin
					fC1.Locate( 'ID', imax, [] );
					Markieren_WB( 1 );
					Markieren_WB( 2 );
					inc( z, 2 );
				end;
			end;
			Sonderfaelle_AG_Erfuellt( z );
		end;

// Auf 10 (KL) bzw. 5 (AG) GK auffüllen

// Jetzt die temporären Markierungen speichern
		with fC1 do
		begin
			First;
			while not Eof do
			begin
				if ( FieldByname( 'Markiert1' ).AsString = '+' ) or (FieldByname( 'Markiert2' ).AsString = '+' ) then
				begin
					fach := FieldByName( 'Fach' ).AsString;
					Edit;
					if ( FieldByname( 'Markiert1' ).AsString = '+' ) then
					begin
						TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i1], QuotedStr( '+' ), FieldByName( 'ID' ).AsInteger ] ) );
						FieldByName( 'Punkte1' ).AsInteger := 0; // Damit dieser Kurs im weiteren Verlauf nicht nochmals berücksichtigt wird
					end;
					if ( FieldByname( 'Markiert2' ).AsString = '+' ) then
					begin
						TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i2], QuotedStr( '+' ), FieldByName( 'ID' ).AsInteger ] ) );
						FieldByName( 'Punkte2' ).AsInteger := 0; // Damit dieser Kurs im weiteren Verlauf nicht nochmals berücksichtigt wird
					end;
					Post;
				end;
				Next;
			end;
		end;
//		exit; // Hier ist PA einfach markiert

// Jetzt die in C2 "geparkten" Einträge (diese enthalten die Fächer, die nur in einem Abschnitt belegt sind), zu C1 hinzufügen
		fC2.First;
		while not fC2.Eof do
		begin
			fC1.Append;
			RBKCopyRecord( fC2, fC1 );
			fC1.Post;
			fC2.Next;
		end;

// Da es jetzt nur noch auf die Grundkurse ankommt, die LK's löschen
		for i := 1 to NumToken( LK, ';' ) do
		begin
			fach := GetToken( LK, ';', i );
			if fC1.Locate( 'Fach', fach, [] ) then
				fC1.Delete;
		end;



		if fGliederung = 'KL' then
			GK_Quali := 10
		else if fGliederung = 'AG' then
			GK_Quali := 5;

		fC1.First;
		while ( z < GK_Quali ) and not fC1.Eof do
		begin
			psummax := 0;
			act_id := fC1.FieldByname( 'ID' ).AsInteger;
			imax := MaxPunkteID;
			if imax = 0 then
				break
			else
			begin
				fC1.Locate( 'ID', imax , [] );
				if ( fC1.FieldByName( 'Punkte1' ).AsInteger > 0 ) or ( fC1.FieldByName( 'Punkte2' ).AsInteger > 0 ) then
				begin
//					ShowMessage( fC1.FieldByName( 'fach' ).AsString );
					fC1.Edit;
					if fC1.FieldByName( 'Punkte1' ).AsInteger > fC1.FieldByName( 'Punkte2' ).AsInteger then
					begin
						fC1.FieldByName( 'Punkte1' ).AsInteger := 0; // Damit dieser Kurs im weiteren Verlauf nicht nochmals berücksichtigt wird
						TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i1], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
					end else
					begin
						fC1.FieldByName( 'Punkte2' ).AsInteger := 0; // Damit dieser Kurs im weiteren Verlauf nicht nochmals berücksichtigt wird
						TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i2], QuotedStr( '+' ), fC1.FieldByName( 'ID' ).AsInteger ] ) );
					end;
					fC1.Post;
					inc( z );
				end;
				fC1.Locate( 'ID', act_id, [] );
				fC1.Next;
			end;
		end;

	end;

//--------------------------end procedure MarkierungenSetzen_WB--------------------------

	procedure MarkierungenSetzen_WB10;
  begin
    with FC1 do
    begin
      First;
      while not Eof do
      begin
        if ( FieldByname( 'Markiert1' ).AsString = '+' ) then
          TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i1], QuotedStr( '+' ), FieldByName( 'ID' ).AsInteger ] ) );
        if ( FieldByname( 'Markiert2' ).AsString = '+' ) then
          TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set R%s=%s where ID=%d', [ F_A_Fld[i2], QuotedStr( '+' ), FieldByName( 'ID' ).AsInteger ] ) );
        Next;
      end;
    end;

  end;

//++++++++++++++++++++++++++begin procedure MarkierungenSetzen++++++++++++++++++++++++++
begin
// Die Abschnitte markieren
	TransactionHandler.DoExecute( Format( 'update SchuelerFHR set J%s=-J%s where Schueler_ID=%d', [ F_A_Fld[i1], F_A_Fld[i1], FS_ID ] ) );
	TransactionHandler.DoExecute( Format( 'update SchuelerFHR set J%s=-J%s where Schueler_ID=%d', [ F_A_Fld[i2], F_A_Fld[i2], FS_ID ] ) );

// Jetzt die Fächer
	D_Erl := false;
	FS_Erl := false;
	GS_Erl := false;
	M_Erl := false;
	NW_Erl := false;

	if ( fSchulform = 'GY' ) or ( fSchulform = 'GE' ) or ( fSchulform = 'BK' ) or ( fSchulform = 'SB' ) then
		MarkierungenSetzen_GY_GE
	else if fSchulform = 'WB' then
  begin
    if AnsiStartsText( 'APO-WBK10', FPruefOrdnung ) then
  		MarkierungenSetzen_WB10
    else
      MarkierungenSetzen_WB;
  end;

end;

procedure TFHRAlgorithmus.MarkierungenEntfernen;
var
	i :integer;
	cmd, sj,sr: string;
begin
	sj := '';
	sr := '';
	for i := 1 to 8 do
	begin
		if sr <> '' then
			sr := sr + ',';
		sj := Format( 'J%s=-J%s', [ C_FN[i], C_FN[i] ] );
		cmd := Format( 'update SchuelerFHR set %s where Schueler_ID=%d and J%s<0', [ sj, FS_ID, C_FN[i] ] );
		TransactionHandler.DoExecute( cmd );
		sr := sr + Format( 'R%s=%s', [ C_FN[i], QuotedStr('-' ) ] );
	end;
	cmd := Format( 'update SchuelerFHR set AnzRelLK=NULL, AnzRelGK=NULL, AnzDefLK=NULL, AnzDefGK=NULL, SummeLK=NULL, SummeGK=NULL, GesamtPunktzahl=NULL where Schueler_ID=%d', [ FS_ID ] );
	TransactionHandler.DoExecute( cmd );
	TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set %s where Schueler_ID=%d', [ sr, FS_ID ] ) );

//, AnzRelLK=NULL, AnzRelGK=NULL, AnzDefLK=NULL, AnzDefGK=NULL, SummeLK=NULL, SummeGK=NULL, GesamtPunktzahl=NULL
end;



procedure TFHRAlgorithmus.PruefeFHR( const i1, i2: integer );
var
	np1, np2: integer;
	ds: TDataset;
	gp: integer;
	add: boolean;
begin
  FAbschnitt_1 := i1;
  FAbschnitt_2 := i2;
	MarkierungenEntfernen;
	fC1.EmptyTable;
	fC2.EmptyTable;
	FHR_Belegung := false;
	with fQryFHR do
	begin
		Close;
		Connection := fConSchild;
		CommandText := 'SELECT SF.*, F.StatistikKrz, F.Bezeichnung FROM SchuelerFHRFaecher SF, EigeneSchule_Faecher F' +
								' WHERE SF.Schueler_ID=' + IntToStr( fS_ID ) + ' AND F.ID=SF.Fach_ID ORDER BY SF.FSortierung';
		Open;
		First;
		while not EOF do
		begin
			np1 := NumPunkte( FieldByName( 'P' + F_A_Fld[i1] ).AsString );
			np2 := NumPunkte( FieldByName( 'P' + F_A_Fld[i2] ).AsString );
// Bei AG und gesellschaftswiss. Fach reicht Belegung in einem Abschnitt
      if FSchulform = 'WB' then
      begin
        if ( FGliederung = 'KL' ) and (
           ( FieldByName( 'StatistikKrz' ).AsString = 'PX' ) or
           ( FieldByName( 'K' + F_A_Fld[i1] ).AsString = 'PJK' ) or
           ( FieldByName( 'K' + F_A_Fld[i2] ).AsString = 'PJK' ) ) then // Projektkurs benötigt nur einen Noteneintrag
          add := ( np1 > 0 ) or ( np2 > 0 )
        else if ( FGliederung = 'AG' ) and InMenge( FieldByName( 'StatistikKrz' ).AsString, GS_Faecher ) then
          add := ( np1 > 0 ) or ( np2 > 0 )
        else
          add := ( np1 > 0 ) and ( np2 > 0 );
      end else
      begin
        add := ( np1 > 0 ) or ( np2 > 0 );
      end;
			if add then
			begin
				ds := fC1;
				FachHinzu( fC1,
									 FieldByName( 'ID' ).AsInteger,
									 FieldByName( 'Fach_ID' ).AsInteger,
									 np1, np2,
									 FieldByName( 'K' + F_A_Fld[i1] ).AsString,
									 FieldByName( 'K' + F_A_Fld[i2] ).AsString );
			end else if ( np1 > 0 ) or ( np2 > 0 ) then
			begin
				FachHinzu( fC2,
									 FieldByName( 'ID' ).AsInteger,
									 FieldByName( 'Fach_ID' ).AsInteger,
									 np1,
									 np2,
									 FieldByName( 'K' + F_A_Fld[i1] ).AsString,
									 FieldByName( 'K' + F_A_Fld[i2] ).AsString );
			end;
			Next;
		end;
		Close;
	end;
	GruppenBilden;
	FHR_Belegung := PruefeFHRBelegung;
	FHR_BelegungGes := FHR_BelegungGes or FHR_Belegung;
	if FHR_Belegung then
	begin
    if i1 = 3 then
  		MarkierungenSetzen( i1, i2 )
    else
  		MarkierungenSetzen( i1, i2 );
		FSchuelerFHR.MeldungZeigen := false;
		FSchuelerFHR.Datenquelle.Close; // wg. Fehler in Firebird
		FSchuelerFHR.FHRFaecher.Datenquelle.Close;
		FSchuelerFHR.ErgebnisBerechnen( FS_ID, FPruefOrdnung );
		FSchuelerFHR.MeldungZeigen := true;
		with fQryS do
		begin
			Close;
			CommandText := Format( 'select FHRErreicht, GesamtPunktzahl from SchuelerFHR where Schueler_ID=%d', [ FS_ID ] );
			Open;
			if FieldByName( 'FHRErreicht' ).AsString = '+' then
			begin
				gp := FieldByName( 'GesamtPunktzahl' ).AsInteger;
				if gp > FHR_GesamtPunkte then
				begin
					FHR_Erreicht := true;
					FHR_1 := i1;
					FHR_2 := i2;
					FHR_GesamtPunkte := gp;
				end;
			end;
			Close;
		end;
	end;

end;


procedure TFHRAlgorithmus.HeaderSchreiben;
var
	i : integer;
begin
	FErrCnt := 0;
	if not fHeaderDone then
	begin
{		if not fNurBelegung then
		begin
			slMsg.Add( 'Über die Gesamtqualifikation und damit über die Abiturzulassung entscheidet' );
			slMsg.Add( 'nach APOGOST ausschließlich der zentrale Abiturausschuss (ZAA).' );
			slMsg.Add( 'Dieses Programm liefert nur einen Vorschlag für die Beratung des ZAA.' );
		end else
		begin}
		slMsg.Add( 'Gegenanzeige:' );
		slMsg.Add( 'In äußerst seltenen Fällen – Wiederholung der Jahrgangsstufe 13/Q2 nach nicht bestandener' );
		slMsg.Add( 'Abiturprüfung, wenn in der Qualifikationsphase bereits ein Halbjahr der 13/Q2 wiederholt' );
		slMsg.Add( 'worden ist – kann es vorkommen, dass SchILD die FHR nicht oder nicht richtig ermitteln kann.' );
		slMsg.Add( 'Bei zwei oder mehreren Fremdsprachen, Gesellschaftswissenschaften oder klassischen' );
		slMsg.Add( 'Naturwissenschaften kann es in seltenen Fällen (dann, wenn die Halbjahresnoten extrem' );
		slMsg.Add( 'unterschiedlich sind) vorkommen, dass SchILD nicht die für die Schülerin oder den Schüler' );
		slMsg.Add( 'optimale Punktzahl der FHR ermittelt. Wir bitten Sie, in solchen Fällen um eine manuelle' );
		slMsg.Add( 'Kontrolle des von SchILD gelieferten Vorschlags.' );

		fHeaderDone := true;
	end;

	if not fNameDone then
	begin
		if slMsg.Count > 0 then
			slMsg.Add( '' );		// Leerzeile in Ausgabepuffer
		slMsg.Add( fSchuelerName );
		slMsg.Add( '========================================================================' );
		if fPruefOrdnung <> '' then
			slMsg.Add( 'Prüfungsordnung: ' + fPruefOrdnung )
		else
			slMsg.Add( 'Prüfungsordnung: Keine Prüfungsordnung zugewiesen' );
		fNameDone := true;
	end;

end;


procedure TFHRAlgorithmus.Initialisieren;
begin
	FHR_erreicht := false;
	FHR_1 := 0;
	FHR_2 := 0;
	FHR_GesamtPunkte := 0;
end;

procedure TFHRAlgorithmus.SchuelerDatenHolen;
var
	jg : integer;
	cnt: integer;
begin
	fNameDone := false;
	FHR_BelegungGes := false;
	fQryS.Close;
	fQryS.Connection := fConSchild;

// Schuldaten holen
	fQryS.CommandText := Format( 'select * from EigeneSchule where SchulnrEigner=%d', [ SchildSettings.Schulnr ] );
	fQryS.Open;

	FSchulform := fQryS.FieldByName( 'SchulformKrz' ).AsString;
	fQryS.Close;

// den Namen des Schülers ermitteln
	fQryS.CommandText := 'SELECT ID, Name, Vorname, PruefOrdnung, ASDSchulform, ASDJahrgang FROM Schueler WHERE ID=' + IntToStr( fS_ID );
	fQryS.Open;
	fSchuelerName := fQryS.FieldByname( 'Name' ).AsString + ', ' + fQryS.FieldByname( 'VorName' ).AsString;
	fPruefOrdnung := fQryS.FieldByname( 'PruefOrdnung' ).AsString;

	if fSchulform = 'WB' then
	begin
		GS_Faecher := 'GE;GW;SL;EK;PA;PL;VW;PS';
		if fQryS.FieldByName( 'ASDSchulform' ).AsString = 'K02' then
			fGliederung := 'KL'
		else if fQryS.FieldByName( 'ASDSchulform' ).AsString = 'G02' then
			fGliederung := 'AG';
	end else
	begin
		fGliederung := 'GY';
		GS_Faecher := 'PL;GE;SW;EK;PA;RK;PS;GL;DM';
	end;

	HeaderSchreiben;

end;

procedure TFHRAlgorithmus.KursartenPruefen;
var
  i: integer;
  qry: TBetterADODataset;
  kfld, ka: string;
begin
  qry := TBetterADODataset.Create( nil );
  try
    qry.Connection := FConSchild;
    qry.CommandText := Format( 'select * from SchuelerFHR where Schueler_ID=%d', [ FS_ID ] );
    qry.Open;
    kfld := '';
    for i := 8 downto 1 do
    begin
      if F_A_Fld[i] <> '' then
      begin
        if qry.FieldByName( 'J' + F_A_Fld[i] ).AsInteger < 0 then
        begin
          kfld := 'K' + F_A_Fld[i]; // Das Kursfeld in SchuelerFHRFaecher
          break;
        end;
      end;
    end;

    if kfld = '' then
      exit;


    qry.Close;
    qry.CommandText := Format( 'Select ID, %s from SchuelerFHRFaecher where Schueler_ID=%d', [ kfld, FS_ID ] );
    qry.Open;
    while not qry.Eof do
    begin
      ka := qry.FieldByname( kfld ).AsString;
      if ka <> '' then
      begin
        ka := copy( ka, 1, 2 );
        if ka <> 'LK' then
          ka := 'GK';
        TransactionHandler.DoExecute( Format( 'update SchuelerFHRFaecher set KursartAllg=%s where ID=%d', [ QuotedStr( ka ), qry.FieldByName( 'ID' ).AsInteger ] ) );
      end;
      qry.Next;
    end;
  finally

    FreeAndNil( qry );

  end;
end;




initialization

finalization
	if Assigned( FHRAlgorithmus ) then
	begin
		FHRAlgorithmus.Free;
		FHRAlgorithmus := nil;
	end;


end.



procedure QuickSort(var A: array of Integer; iLo, iHi: Integer) ;
 var
   Lo, Hi, Pivot, T: Integer;
 begin
   Lo := iLo;
   Hi := iHi;
   Pivot := A[(Lo + Hi) div 2];
   repeat
     while A[Lo] < Pivot do Inc(Lo) ;
     while A[Hi] > Pivot do Dec(Hi) ;
     if Lo <= Hi then
     begin
       T := A[Lo];
       A[Lo] := A[Hi];
       A[Hi] := T;
       Inc(Lo) ;
       Dec(Hi) ;
     end;
   until Lo > Hi;
   if Hi > iLo then QuickSort(A, iLo, Hi) ;
   if Lo < iHi then QuickSort(A, Lo, iHi) ;
 end;


procedure QuickSort(var List: array of Double; iLo, iHi: Integer) ;
var
  Lo       : integer;
  Hi       : integer;
  T        : Double;
  Mid      : Double;
begin
  Lo := iLo;
  Hi := iHi;
  Mid:= List[(Lo + Hi) div 2];
  repeat

    while List[Lo] < Mid do Inc(Lo) ;
    while List[Hi] > Mid do Dec(Hi) ;

    if Lo <= Hi then
    begin
      T := List[Lo];
      List[Lo] := List[Hi];
      List[Hi] := T;
      Inc(Lo);
      Dec(Hi);
    end;

  until Lo > Hi;

  if Hi > iLo then QuickSort(List, iLo, Hi);
  if Lo < iHi then QuickSort(List, Lo, iHi);

end;

