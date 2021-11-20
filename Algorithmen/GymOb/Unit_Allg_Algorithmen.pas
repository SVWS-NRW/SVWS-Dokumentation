unit Unit_Allg_Algorithmen;

interface

// #SCHILD30# komplett

uses
  db,
  unit_BasisPruefungsalgorithmus;

type
	TAllgPruefungsAlgorithmus = class( TPruefungsAlgorithmus )
		private
			FBelegungsfehler: boolean;
      FTestnote: integer;
      FTestFach_ID: integer;
      function Teilpruefung: string;override;

			function Pruefe_GY_APO_SI05_V6_10_Versetzung: string;

			function Pruefe_GY_APO_GOSt02_V12: string;
			function Pruefe_GY_APO_GOSt02_V12_Belegung: boolean;
			function Pruefe_GY_APO_GOSt02_V12_Versetzung: boolean;
      function Hole_GY_APO_GOSt10_V12_Faecher: boolean;


			function Pruefe_R_APO_SI05_V6_9_Versetzung: string;

			function Pruefe_H_APO_SI05_V6_9_Versetzung: string;
			function Pruefe_H_APO_SI05_V9_10B_Versetzung: string;

      function Vorpruefung_HSA_GE: boolean;
			function Pruefe_R_GY_GE_APO_SI05_HSA_9: string;		// Hauptschulabschluss am Ende von 9

			function Pruefe_APO_SI05_HSA_10: string; 		// Hauptschulabschluss nach Kl. 10

      function Pruefe_APO_SI05_FOR_Abschluss_GE( const PO_Art: string ): string;
			function Pruefe_APO_SI05_FOR_Abschluss: string;

			function Pruefe_APO_SI05_FORQ_Abschluss: string;

      function NachpruefungsFaecherErmitteln: boolean;

			procedure Fremdsprache_1_2( dsvon, dsnach: TDataset );

      procedure NichtGemahnte5Ersetzen;

			procedure ZuWenigKurse( txt: string );

			function FSF_Pruefen( const fach_ids: string; const Note: double ): string;
{$IFDEF BWFS}
      procedure BWFS_NotenDurchschnittBerechnen;
{$ENDIF}

    public

  end;

implementation

uses
  Classes,
  RBKLists,
  Dialogs,
  RBKStrings,
  StrUtils,
  unit_Mengen,
  unit_SchildSettings,
  unit_SchildFunktionen,
  unit_TransactionHandler,
{$IFDEF BWFS}
  {$IFDEF UNIDAC}
    Uni,
    uDBUtils_UNIDAC,
  {$ELSE}
    BetterADODataset,
  {$ENDIF}
{$ENDIF}

{$IFDEF UNIDAC}
  uDBUtils_UNIDAC,
{$ELSE}
  RBKDBUtils,
{$ENDIF}

  SysUtils;

{$IFDEF BWFS}
procedure TAllgPruefungsAlgorithmus.BWFS_NotenDurchschnittBerechnen;
var
	DSCnt: integer;
	note: double;
  DSN: double;
  s_id_save, a_id_save: integer;
  cmd, pkz: string;
{$IFDEF UNIDAC}
  qryP: TUniQuery;
  qryF: TUniQuery;
{$ELSE}
  qryP: TBetterADODataset;
  qryF: TBetterADODataset;
{$ENDIF}

  procedure SetCmdP( const cmd: string );
  begin
    qryP.Close;
{$IFDEF UNIDAC}
    qryP.SQL.Text := cmd;
{$ELSE}
    qryP.CommandText := cmd;
{$ENDIF}
    qryP.Open;
  end;

  procedure SetCmdF( const cmd: string );
  begin
    qryF.Close;
{$IFDEF UNIDAC}
    qryF.SQL.Text := cmd;
{$ELSE}
    qryF.CommandText := cmd;
{$ENDIF}
    qryF.Open;
  end;
begin
// NEU Nov. 2017: Auch Noten anderer Schulen berücksichtigen
  s_id_save := fS_ID;
  a_id_save := fA_ID;
{$IFDEF UNIDAC}
  qryP := CreateReadOnlyDataset( FConSchild );
  qryF := CreateReadOnlyDataset( FConSchild );
{$ELSE}
  qryP := CreateReadOnlyDataset( FConSchild, true );
  qryF := CreateReadOnlyDataset( FConSchild, true );
{$ENDIF}

  try
    cmd := Format( 'select PKz from BW_Schueler_FS where Schueler_ID=%d', [ s_id_save ] );
    SetCmdP( cmd );
    pkz := qryP.FieldByName( 'PKz' ).AsString;

    cmd := Format( 'select A.Schueler_ID, A.ID from SchuelerLernabschnittsdaten A where A.Schueler_ID in ' +
                   '(select FS.Schueler_ID from BW_Schueler_FS FS where FS.Pkz=%s) and A.Jahr=%d and A.Abschnitt=%d',// and A.ASDSchulgliederung=%s',
                   [ QuotedStr( pkz ),
                     FJahr,
                     FAbschnitt,
                     QuotedStr( FSchulgliederung ) ] );
    SetCmdP( cmd );
    while not qryP.Eof do
    begin
      fS_ID := qryP.FieldByName( 'Schueler_ID' ).AsInteger;
      fA_ID := qryP.FieldByName( 'ID' ).AsInteger;
      cmd := Format( 'select NotenKrz from SchuelerLeistungsdaten where Abschnitt_ID=%d',
                     [ fA_ID ] );
      SetCmdF( cmd );
      DSCnt := 0;
      DSN := 0;
      while not qryF.Eof do
      begin
        if qryF.FieldByname( 'NotenKrz' ).AsString <> '' then
        begin
          note := NoteNum( qryF.FieldByname( 'NotenKrz' ).AsString );
          if note <> 999 then
          begin
            inc( DSCnt );
            DSN := DSN + note;
          end;
        end;
        qryF.Next;
      end;
      if DSCnt > 0 then
      begin
        DSN := DSN / DSCnt;
        DSN := trunc( DSN * 10 );
        DSN := DSN * 0.1;
      end else
        DSN := -1;

      DurchschnittsNoteSpeichernFuerAbschnitt( DSN );
      DurchschnittsNoteSpeichern( DSN, 'Durchschnittsnote', 'DSN_Text' );
      if DSN > 0 then
      begin
        Meldung( 'Durchschnittsnote: ' + FloatToStr( DSN ) );
        Meldung( ' ' );
      end else
      begin
        Meldung( 'Durchschnittsnote konnte nicht berechnet werden' );
        Meldung( ' ' );
      end;
      qryP.Next;
    end;
  finally
    FreeAndNil( qryP );
    FreeAndNil( qryF );
    fS_ID := s_id_save;
    fA_ID := a_id_save;
  end;

end;
{$ENDIF}


function TAllgPruefungsAlgorithmus.Teilpruefung: string;
begin
{$IFDEF BWFS}
  BWFS_NotenDurchschnittBerechnen;
{$ELSE}
  if ( fTeilPruefOrdKrz = 'GY/APO-SI05/KV5' ) then
  begin
  // Keine Versetzung von Kl. 5 nach Kl. 6, APO-SI 05
    Meldung( 'Erprobungsstufe: Wechsel in Klasse 6' );
    VersetzungSpeichern( 'V' );
    AbschlussSpeichern( 0 );
    Result := 'V';
  end else if ( fTeilPruefOrdKrz = 'GY/APO-SI05/V6-10' ) then
  begin
  // Besondere Vers.-Best. für Kl. 6 bis Kl. 10, APO-SI05
    Result := Pruefe_GY_APO_SI05_V6_10_Versetzung;
    if Result = 'N' then
    begin		// nicht versetzt
      if ( StrToInt( fJahrgang ) >= 7 ) and not fZuWenigFaecher then
        if NachpruefungsFaecherErmitteln then
          Result := 'NP';
    end;
    VersetzungSpeichern( Result );
    AbschlussSpeichern( 0 );
    if ( Result = 'V' ) then
    begin
      if ( FSchulform = 'GY' ) then
      begin
        if ( fJahrgang = '09' ) and ( FSchulGliederung = 'GY' ) then
        begin//		Gymnasium: Wenn versetzt, dann autom. Berechtigung zur Obersufe
          Meldung( 'Berechtigung zum Besuch der Einführungsphase (G8) erreicht' );
    // Was ist hier bei G8?
          fTeilPruefOrdKrz := 'GY/APO-SI05/VSZ9';   // Versetzungszeugnis der Klasse 9 mit Berechtigung zum Besuch der Einführungsphase
          AbschlussSpeichern( 1 );
          FAbbruch := true;
        end else if ( fJahrgang = '10' ) and ( FSchulgliederung = 'GY9' ) then // Wiedereinrichter G9
        begin
          Meldung( 'Berechtigung zum Besuch der Einführungsphase (G9) erreicht' );
          fTeilPruefOrdKrz := 'GY/APO-SI05/FORQ-E';   // Versetzungszeugnis der Klasse 10 mit Berechtigung zum Besuch der Einführungsphase
          AbschlussSpeichern( 1 );
          FAbbruch := true;
        end;
      end else if ( FSchulform = 'GE' ) and ( fJahrgang = '10' ) then
      begin//		Gesamt/Sekundarschule: Wenn versetzt, dann autom. Berechtigung zur Obersufe
        Meldung( 'Berechtigung zum Besuch der Einführungsphase (G9) erreicht' );
        fTeilPruefOrdKrz := 'GY/APO-SI05/FORQ-E';   // Versetzungszeugnis der Klasse 10 mit Berechtigung zum Besuch der Einführungsphase
        AbschlussSpeichern( 1 );
        FAbbruch := true;
      end;

    end;

  end else if ( fTeilPruefOrdKrz = 'GY/APO-GOSt02/V12' ) or
              ( fTeilPruefOrdKrz = 'GE/APO-GOSt02/V12' ) or
// G8
              ( fTeilPruefOrdKrz = 'GY/APO-GOStG8/VQ' ) or
              ( fTeilPruefOrdKrz = 'GE/APO-GOStG8/VQ' ) or
// G9
              ( fTeilPruefOrdKrz = 'GY/APO-GOStG9/V12' ) or
              ( fTeilPruefOrdKrz = 'GE/APO-GOStG9/V12' ) then
  begin
    Result := Pruefe_GY_APO_GOSt02_V12;
    if ( Result = 'N' ) and not fZuWenigFaecher then
    begin
      if FWiederholung then
        Meldung( 'Keine Nachprüfung möglich, da Jahrgang wiederholt wird' )
      else if NachpruefungsFaecherErmitteln then
        Result := 'NP';
      AbschlussSpeichern( 0 );
      SchuelerAbschlussSpeichern( 'P' )
    end else if Result = 'V' then
    begin
      if fSchulform = 'GY' then
      begin // Beim Gymnasium mit der Versetzung wird auch der mittelere Schulabschluss erreicht
      // NEU
      // Ändern: Hier muss auch der Algorithmus für die FOR aufgerufen werden.
      // NEU
{        if fPruefOrdnung = 'APO-GOSt(C)10/G9' then
          fTeilPruefOrdKrz := 'GY/APO-GOStG9/FOR'
        else if fPruefOrdnung = 'APO-GOSt(B)10/G8' then
          fTeilPruefOrdKrz := 'GY/APO-GOStG8/FOR';
        AbschlussSpeichern( 1 );
        SchuelerAbschlussSpeichern( 'G' );}
      end;
    end;
    VersetzungSpeichern( Result );

  //----------------------------------------------------------------------------------------------------------------------------------------------
  // Nun die Realschule
  //----------------------------------------------------------------------------------------------------------------------------------------------
  end else if ( fTeilPruefOrdKrz = 'R/APO-SI05/KV5' ) then
  begin		// Keine Versetzung von Kl. 5 nach Kl. 6, APO-SI 05
    Meldung( 'Erprobungsstufe: Wechsel in Klasse 6' );
    VersetzungSpeichern( 'V' );
    AbschlussSpeichern( 0 );
    Result := 'V';
  end else if ( fTeilPruefOrdKrz = 'R/APO-SI05/V6' ) then
  begin
    Result := Pruefe_R_APO_SI05_V6_9_Versetzung;
    VersetzungSpeichern( Result );
    AbschlussSpeichern( 0 );
  end else if ( fTeilPruefOrdKrz = 'R/APO-SI05/V7-9' ) then
  begin
    Result := Pruefe_R_APO_SI05_V6_9_Versetzung;
    if ( Result = 'N' ) and not fZuWenigFaecher then
      if NachpruefungsFaecherErmitteln then
        Result := 'NP';
    VersetzungSpeichern( Result );
    AbschlussSpeichern( 0 );
    if ( Result = 'V' ) and ( fJahrgang = '09' ) then
    begin//		Wenn versetzt, dann autom. HSA
      Meldung( 'Abgangszeugnis mit Gleichstellung zum Hauptschulabschluss (mit Versetzungsvermerk) erreicht' );
      fTeilPruefOrdKrz := 'R/APO-SI05/AGZ_MHSA_MV';   // Versetzungszeugnis der Klasse 9 mit Berechtigung zum Besuch der Einführungsphase
      AbschlussSpeichern( 1 );
      FAbbruch := true;
    end;

  //---------------------------------------------------------------------------------------------------------------
  // nun die Hauptschule
  //---------------------------------------------------------------------------------------------------------------
  end else if ( fTeilPruefOrdKrz = 'H/APO-SI05/KV5' ) then
  begin
  // Keine Versetzung von Kl. 5 nach Kl. 6, APO-SI 05 §11(2)
    Meldung( 'Erprobungsstufe: Wechsel in Klasse 6' );
    VersetzungSpeichern( 'V' );
    AbschlussSpeichern( 0 );
    Result := 'V';

  end else if ( fTeilPruefOrdKrz = 'H/APO-SI05/V6-8' ) then
  begin
  // Besondere Vers.-Best. für Kl. 6 bis Kl. 8, APO-SI 05
    Result := Pruefe_H_APO_SI05_V6_9_Versetzung;
    if ( StrToInt( fJahrgang ) >= 7 ) and ( Result = 'N' ) and not fZuWenigFaecher then
      if NachpruefungsFaecherErmitteln then
        Result := 'NP';
    VersetzungSpeichern( Result );
    AbschlussSpeichern( 0 );

  // der Hauptschulabschluss am Ende von Jahrgang 9 in der HS mit Versetzung nach 10
  end else if ( fTeilPruefOrdKrz = 'H/APO-SI05/V9(10A)' ) then
  begin
    Result := Pruefe_H_APO_SI05_V6_9_Versetzung;  // identisch mit Versetzung 6 bi s9

  // Nachprüfung nur in Hauptschule erlaubt
    if ( Result = 'N' ) and not fZuWenigFaecher then
      if NachpruefungsFaecherErmitteln then
        Result := 'NP';
    if Result = 'V' then
    begin
      AbschlussSpeichern( 1 );
      VersetzungSpeichern( 'V' );    // Versetzung nach Kl. 10 in Hauptschule
    end else if Result = 'N' then
    begin
      AbschlussSpeichern( 2 );
      VersetzungSpeichern( 'N' );
    end else if Result = 'NP' then
    begin
      AbschlussSpeichern( 3 );
      VersetzungSpeichern( 'NP' );
    end;
    FAbbruch := ( Result <> 'V' );

  // Der Hauptschulabscluss am Gymnasium am Ende von 9 (ohne Nachprüfung)
  end else if
              ( fTeilPruefOrdKrz = 'R/APO-SI05/HA' ) or
              ( fTeilPruefOrdKrz = 'GY/APO-SI05/HA' ) or
              ( FTeilPruefOrdKrz = 'GE/APO-SI05/HA' ) then
  begin
    Result := Pruefe_R_GY_GE_APO_SI05_HSA_9;
    if Result = 'A' then
    begin
      FPrognoseIgnorieren := true; // dieser Abschluss ist keine Prognose!
      AbschlussSpeichern( 1 );
      FPrognoseIgnorieren := false;
      FAbbruch := false;
    end else if Result = 'N' then
    begin
      if ( FSchulform = 'GE' ) then
      begin
  // Hier bei Gesamtschule noch Nachprüfung möglich
        if not fZuWenigFaecher and NachpruefungsFaecherErmitteln then
        begin
          Result := 'NP';
          AbschlussSpeichern( 3 );
        end else
          AbschlussSpeichern( 2 );
      end else
        AbschlussSpeichern( 2 );

      FAbbruch := FSchulform <> 'GE'; //
    end;
  // In Gesamtschule ist der HSA_9 auch gleichzeitig die Versetzung in die 10
    if ( FSchulform = 'GE' ) and ( FAbschnitt = FAnzahlAbschnitte ) then
    begin
      if ( Result = 'A' ) then
        VersetzungSpeichern( 'V' )
      else
      begin // Kein Abschluss und daher auch keine Versetzung, hier ist Nachprüfung möglich (derzeit deaktiviert)
  {					    if  not fZuWenigFaecher and NachpruefungsFaecherErmitteln then
          VersetzungSpeichern( 'NP' )
        else}
          VersetzungSpeichern( 'N' );
      end;
      Result := 'A'; // Damit der HA10 noch geprüft werden kann
    end;

  // Versetzung nach 10B in Hauptschule
  end else if ( fTeilPruefOrdKrz = 'H/APO-SI05/V9(10B)' ) then
  begin
    Result := Pruefe_H_APO_SI05_V9_10B_Versetzung;
    if ( Result = 'N' ) and not fZuWenigFaecher then
      if NachpruefungsFaecherErmitteln then
        Result := 'NP';
    if Result = 'NONP' then
      Result := 'N';  // Auf nicht versetzt setzen, wenn Nachprüfungen sinnlos
    VersetzungSpeichern( Result );
    if Result = 'V' then
      AbschlussSpeichern( 1 )
    else if Result = 'N' then
      AbschlussSpeichern( 2 );

  // Der Hauptschulabschluss in H, GY, R nach Ende der 10
  end else if ( fTeilPruefOrdKrz = 'H/APO-SI05/SI' ) or   // 10A-Klasse
              ( fTeilPruefOrdKrz = 'H/APO-SI05/HA10' ) or // HSA nach Kl. 10 10B-Klasse
              ( fTeilPruefOrdKrz = 'R/APO-SI05/HA10' ) or  // gleichwertiger Hauptschul-Abschluss
              ( fTeilPruefOrdKrz = 'GY/APO-SI05/HA10' ) or  // gleichwertiger Hauptschul-Abschluss
  // Neu: Auch für Gesamtschule
              ( fTeilPruefOrdKrz = 'GE/APO-SI05/HA10' ) then
  begin
    Result := Pruefe_APO_SI05_HSA_10;
  // Keine Nachprüfung!! außer an GE
    if Result = 'A' then
    begin
      AbschlussSpeichern( 1 );
      FAbbruch := false;
    end else if Result = 'I' then
    begin
      FAbbruch := false; // Ignorieren
    end else if Result = 'N' then
    begin
      if ( FSchulform = 'GE' ) then
      begin
  // Hier bei Gesamtschule noch Nachprüfung bei Nicht-Bestehen?
        if not fZuWenigFaecher and NachpruefungsFaecherErmitteln then
        begin
          Result := 'NP';
          AbschlussSpeichern( 3 );
        end else
          AbschlussSpeichern( 2 );
      end else
        AbschlussSpeichern( 2 );
      FAbbruch := true;
    end;
  // In der Haupschule und Realschule ist der Vers-Vermerk='Abschluss'
    if ( FSchulgliederung = 'H' ) or ( FSchulgliederung = 'R' ) then
      VersetzungSpeichern( 'A' );

  // Sekundarabschluss I Fachoberschulreife
  end else if( ( fTeilPruefOrdKrz = 'H/APO-SI05/FOR' ) and ( fPruefOrdnung = 'H/APO-SI05/10B' ) ) or
              ( fTeilPruefOrdKrz = 'R/APO-SI05/FOR' ) or
              ( fTeilPruefOrdKrz = 'GY/APO-SI05/FOR' ) or
              ( fTeilPruefOrdKrz = 'GY/APO-GOStG8/FOR' ) or
              ( fTeilPruefOrdKrz = 'GY/APO-GOStG9/FOR' ) or
  // Gesamtschule
              ( fTeilPruefOrdKrz = 'GE/APO-SI05/FOR' )  then
  begin
    Result := Pruefe_APO_SI05_FOR_Abschluss;
    if ( Result = 'N' ) and not fZuWenigFaecher then
      if NachpruefungsFaecherErmitteln then
        Result := 'NP';
    if Result = 'A' then
    begin
      AbschlussSpeichern( 1 );
      FAbbruch := false;
    end else if Result = 'N' then
    begin
      AbschlussSpeichern( 2 );
      FAbbruch := true;
    end else if Result = 'NP' then
    begin
      AbschlussSpeichern( 3 );
      FAbbruch := true;
    end;
  // In der Haupsund Realschule ist der Vers-Vermerk='Abschluss'
    if ( FSchulgliederung = 'H' ) or ( FSchulgliederung = 'R' ) then
      VersetzungSpeichern( 'A' );

  // Hauptschule, Realschule: Berechtigung zum Bersuch der gymn. Oberstufe
  end else if ( ( fTeilPruefOrdKrz = 'H/APO-SI05/FORQ-E' ) and ( fPruefOrdnung = 'H/APO-SI05/10B' ) ) or
              ( fTeilPruefOrdKrz = 'R/APO-SI05/FORQ-E' ) or
  // Gesamtschule
              ( fTeilPruefOrdKrz = 'GE/APO-SI05/FORQ-E' ) then
  begin
    fGrenzNote := 3;
    Result := Pruefe_APO_SI05_FORQ_Abschluss;
    if ( Result = 'N' ) and not fZuWenigFaecher and not IstPrognose then
      if NachpruefungsFaecherErmitteln then
        Result := 'NP';
    if Result = 'A' then
    begin
      AbschlussSpeichern( 1 );
      FAbbruch := false;
    end else if Result = 'N' then
    begin
      fAbbruch := true;
      AbschlussSpeichern( 2 );
    end else if Result = 'NP' then
    begin
      FAbbruch := true;
      AbschlussSpeichern( 3 );
    end;
    fGrenzNote := 4;
  // In der Haupschule und Realschule ist der Vers-Vermerk='Abschluss'
    if ( FSchulgliederung = 'H' ) or ( FSchulgliederung = 'R' ) then
      VersetzungSpeichern( 'A' );
  end else
    FPONichtUnterstuetzt.Add( fTeilPruefOrdKrz );
{$ENDIF}
end;

function TAllgPruefungsAlgorithmus.Pruefe_GY_APO_GOSt02_V12: string;
var
	ok : boolean;
begin
  if ( fTeilPruefOrdKrz = 'GY/APO-GOSt02/V12' ) or // Belegung nur bei "alter" Prüfungsordnung
		 ( fTeilPruefOrdKrz = 'GE/APO-GOSt02/V12' ) then
  	ok := Pruefe_GY_APO_GOSt02_V12_Belegung
  else
  begin
    if SchildSettings.IgnoriereNichtGemahnte5 then
      NichtGemahnte5Ersetzen;
    ok := Hole_GY_APO_GOSt10_V12_Faecher;
  end;
	if ok then
	begin
		ok := Pruefe_GY_APO_GOSt02_V12_Versetzung;
		if ok then
			Result := 'V'
		else
			Result := 'N';
	end else if FBelegungsfehler then
		Result := '?'
	else
		Result := 'N';
end;

function TAllgPruefungsAlgorithmus.Pruefe_GY_APO_GOSt02_V12_Belegung: boolean;

	function FSF_SPR_NW: boolean;
	var
		idspr, idnw, idwn: string;
		n_spr, n_nw, n_wn: double;
	begin
// Die Prüfung auf ein fremsparchliches fach muss noch erfolgen

		idspr := FeldWertIDs( fC0, 'Fachgruppe', 'FS', 0 );	// ID's der Sprachfächer
		idnw := FeldWertIDs( fC0, 'Fachgruppe', 'NW', 0 );// ID's der NW-Fächer
		idwn := FeldWertIDs( fC0, 'Fachgruppe', 'WN', 0 );// ID's der NW-Fächer
		if ( idspr = '' ) and ( idnw = '' ) and ( idwn = '' ) then
		begin
			Result := false;
			exit;	// wder 2. NW noch 2. Sprache gefunden
		end;

		if idspr <> '' then
		begin
			idspr := BesteNoteID( fC0, 'Fachgruppe', 'FS', -1 );
			n_spr := fBesteNote;
		end else
			n_spr := 6;

		if idnw <> '' then
		begin	// klass. NW
			idnw := BesteNoteID( fC0, 'Fachgruppe', 'NW', -1 );
			n_nw := fBesteNote;
		end else
			n_nw := 6;
		;// else if idwn <> '' then
		if idwn <> '' then
		begin	// weiter NW
			idwn := BesteNoteID( fC0, 'Fachgruppe', 'WN', -1 );
			n_wn := fBesteNote;
		end else
			n_wn := 6;

		if ( n_spr <= n_nw ) and ( n_spr <= n_wn ) then
			Uebertragen( fC0, fC2, idspr )
		else if ( n_nw <= n_spr ) and ( n_nw <= n_wn ) then
			Uebertragen( fC0, fC2, idnw )
		else if ( n_wn <= n_spr ) and ( n_wn <= n_nw ) then
			Uebertragen( fC0, fC2, idwn );

		fFSF := true;
	end;


var
	S_FS9, S_D : integer;
	ids: string;
	DSN: double;
	DSCnt: integer;
	note: double;
	kurszahl: integer;
	C2Zahl: integer;
  idHF: string;
begin
// auf 6 prüfen
	with fC0 do
	begin
		First;
		while not Eof do
		begin
			if fC0.FieldByname( 'Note' ).AsFloat = 6 then
				Delete
			else
				Next;
		end;
	end;
	kurszahl := 10;
	C2Zahl := 7;
	Result := false;
	FBelegungsfehler := true;

// FOLIE "Versetzungsfächer nach Klasse 11 gem. §§8,9 APO-GOST

// Evtl. nicht weitergeführte Sprachen aus SI berücksichtigen
{	if not FMSP then
	begin
		FAnzSprachenSI := FAnzSprachenSI;// + SISprachenAusSprachenfolge;
		fMSP := fAnzSprachenSI > 1;
	end;}

	if FAnzSprachenSI > 1 then
	begin
		if FAnzSprachenSI > 2 then
		begin		// mehr als 2 Fremdsprachen aus SI
			Uebertragen( fC0, fC1, BesteNoteID( fC0, 'FachgruppeIntern', 'FSI', -1 ) );		// von C0 nach C1
		end else
		begin		// 2 Fremdsprachen aus SI
			S_FS9 := FeldWertAnzahl( fC0, 'FachgruppeIntern2', 'FS9' );		// Anzahl Fremdsprachen aus 9

			if S_FS9 = 0 then		// alle beiden Fremdsprachen vor 9
				Uebertragen( fC0, fC1, BesteNoteID( fC0, 'FachgruppeIntern', 'FSI', -1 ) )		// von C0 nach C1
			else
			begin		// mind. 1 Fremdsprache in 9
				Uebertragen( fC0, fC2, FeldWertIDs( fC0, 'FachgruppeIntern2', 'FS9', 0 ) );		// die FS aus 9 in C2
				Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'FachgruppeIntern', 'FSI', 0 ) );		// von C0 nach C1
				fFSF := true;		// FSF-Flag setzen
			end;

		end;

	end else if FAnzSprachenSI > 0 then
	begin			// eine Fremdsprache aus SI
		Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'FachgruppeIntern', 'FSI', 0 ) );		// von C0 nach C1
		if not ( fMSP or ( FeldWertAnzahl( fC0, 'FachgruppeIntern', 'NS' ) > 0 ) ) then
		begin		// keine neue Fremdsprache in SII
			Meldung( '§8(5): Fremdsprache aus SII fehlt' );
			Meldung( 'Belegungsfehler!' );
			exit;
		end;
	end else if FAnzSprachenSI = 0 then
	begin		// keine Fremsprache
		Meldung( '§8(2): Fremdsprache fehlt bzw. §11(2) Nr.2, Satz 4' );
		Meldung( 'Belegungsfehler!' );
		exit;
	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung der Fremdsprachen' );
		exit;
	end;

// FOLIE 2

// Deutsch prüfen

	idHF := HauptFachID( fC0, 'Fach', 'D' );
  if idHF = '' then
	begin		// Deutsch enthalten?
		Meldung( '§8(2): Deutsch fehlt' );
		Meldung( 'Belegprüfung nicht bestanden' );
		exit;
	end else
		Uebertragen( fC0, fC1, idHF );

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung von Deutsch' );
		exit;
	end;

// Mathe prüfen
	idHF := HauptFachID( fC0, 'Fach', 'M' );
	if idHF = '' then
	begin		// Mathe enthalten?
		Meldung( '§8(2): Mathematik fehlt' );
		Meldung( 'Belegungsfehler!' );
		exit;
	end else
	begin
		if not fFSF then// Prüfung eines fremdsprachlichen Mathe-Unterichts!
			FSF_Pruefen( idHF, -1 );
		Uebertragen( fC0, fC1, idHF );
	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung von Mathematik' );
		exit;
	end;

// Sport prüfen
	idHF := HauptFachID( fC0, 'Fach', 'SP' );
	if idHF = '' then
	begin		// kein Sport enthalten
		Meldung( '§8(2): Sport fehlt (Bei Abmeldung muss Sport aber ebenfalls belegt sein)' );
		Meldung( 'Belegungsfehler!' );
		exit;
	end else
	begin
		fC0.Locate( 'ID', idHF, [] );
		if fC0.FieldByname( 'NoteKrz' ).AsString = 'AT' then
		begin
			AusContainerLoeschen( fC0, idHF ); // C0\SP
		end else
		begin
			if not fFSF then// Prüfung eines fremdsprachlichen Sport-Unterichts!
				FSF_Pruefen( idHF, -1 );
			Uebertragen( fC0, fC2, idHF );		// SP von C0 nach C2!!
		end;

	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung von Sport' );
		exit;
	end;

// Religion prüfen
  idHF := HauptFachID( fC0, 'FachgruppeIntern', 'RE' );
  if idHF = '' then
	begin		// keine Religion, dann auf Philosophie prüfen
    idHF := HauptFachID( fC0, 'Fach', 'PL' );
		if idHF = '' then
		begin		// keine Philosophie prüfen
			Meldung( '§8(2): Religion oder Philosophie fehlt' );
			Meldung( 'Belegungsfehler!' );
			exit;
		end else
		begin
			if not fFSF then// Prüfung eines fremdsprachlichen Philosophie-Unterichts!
				FSF_Pruefen( idHF, -1 );
			Uebertragen( fC0, fC2, idHF );		// PL von C0 nach C2!!
		end;
	end else
	begin	// Religion vorhanden
		Uebertragen( fC0, fC2, idHF );		// RE von C0 nach C2!!
	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung von Religion/Philosophie' );
		exit;
	end;

// Gesellschftswissenschften prüfen
  idHF := HauptFachID( fC0, 'FachgruppeIntern2', 'GP' );
  if idHF = '' then
	begin		// keine GS-Fächer
		Meldung( '§8(2): Gesellschaftswissenschftliche Fächer fehlen' );
		Meldung( 'Belegungsfehler!' );
		exit;
	end else
	begin
		ids := FSF_Pruefen( idHF, 5 );		// Prüfung eines fremdsprachlichen GS-Unterichts!bei GS muss auf NOte <5 geprüft werden
		if ids <> '' then
			ids := GetToken( ids, ';', 1 )	// ID des fremdpsrachlichen GS-Faches = "V-Fach"
		else
			ids := BesteNoteID( fC0, 'FachgruppeIntern2', 'GP', -1 );	// V-Fach = min GS
		Uebertragen( fC0, fC2, ids );		//
	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung der geselschaftswissenschaftlichen Fächer' );
		exit;
	end;

// PH BI CH prüfen
  idHF := HauptFachID( fC0, 'FachgruppeIntern', 'BCP' );
  if idHF = '' then
	begin		// keine PH BI CH-Fächer
		Meldung( '§8(2): Physik, Biologie oder Chemie fehlen' );
		Meldung( 'Belegungsfehler!' );
		exit;
	end else
	begin
		ids := FSF_Pruefen( idHF, 5 );		// bei PH, BI, CH muss auf NOte <5 geprüft werden
		if ids <> '' then
			ids := GetToken( ids, ';', 1 )	// ID des fremdpsrachlichen GS-Faches = "V-Fach"
		else
			ids := BesteNoteID( fC0, 'FachgruppeIntern', 'BCP', -1 );	// V-Fach = min PH BI CH
		Uebertragen( fC0, fC2, ids );		// PL von C0 nach C2!!
	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung von Physik/Biologie/Chemie' );
		exit;
	end;

// Musische Fächer prüfen
  idHF := HauptFachID( fC0, 'FachgruppeIntern', 'MS' );
  if idHF = '' then
	begin		// keine musischen Fächer
		Meldung( '§8(2): Musische Fächer fehlen' );
		Meldung( 'Belegungsfehler!' );
		exit;
	end else
	begin
		ids := FSF_Pruefen( idHF, 5 );		// bei PH, BI, CH muss auf NOte <5 geprüft werden
		if ids <> '' then
			ids := GetToken( ids, ';', 1 )	// ID des fremdpsrachlichen GS-Faches = "V-Fach"
		else
			ids := BesteNoteID( fC0, 'FachgruppeIntern', 'MS', -1 );	// V-Fach = min PH BI CH
		Uebertragen( fC0, fC2, ids );		// PL von C0 nach C2!!
	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung der musischen Fächer' );
		exit;
	end;

// Auffüllen auf 10 Kurse
	while ( fC1.RecordCount + fC2.RecordCount ) < kurszahl do
	begin
		if fC0.RecordCount = 0 then
		begin
			ZuWenigKurse( 'beim Auffüllen auf 10 Kurse' );
			exit;
		end;
//		fFSF := true; // Test
		if fFSF then
		begin
			ids := BesteNoteID( fC0, 'FachGruppeIntern', '', -1 );
			Uebertragen( fC0, fC2, ids );
		end else
		begin
			fFSF := FSF_SPR_NW;
			if not fFSF then
			begin
				Meldung( '§8(2): 2. Naturwissenschaft oder 2. Fremdsprache fehlt' );
				Meldung( 'Belegungsfehler!' );
				exit;
			end;
		end;
	end;

	if ( fC1.RecordCount < 3 ) or ( fC2.RecordCount < C2Zahl ) then
	begin
		Meldung( 'Zu wenig versetzungsrelevante Fächer. Der Algorithmus kann keine Versetzungsentscheidung vorschlagen' );
		exit;
	end;

	Meldung( '10 Kurse gefunden' );
	Meldung( ' ' );
	Meldung( 'Gruppe 1' );
	Meldung( '------------------' );
	DSN := 0;
	DSCnt := 0;
	fC1.First;
	while not fC1.EOF do
	begin
		Meldung( fC1.FieldByname( 'FachName' ).AsString + ', Note: ' + fC1.FieldByname( 'NoteKrz' ).AsString );
		note := NoteNum( fC1.FieldByname( 'NoteKrz' ).AsString );
		if note <> 999 then
		begin
			inc( DSCnt );
			DSN := DSN + note;
		end;
		fC1.Next;
	end;
	Meldung( ' ' );
	Meldung( 'Gruppe 2' );
	Meldung( '------------------' );
	fC2.First;
	while not fC2.EOF do
	begin
		Meldung( fC2.FieldByname( 'FachName' ).AsString + ', Note: ' + fC2.FieldByname( 'NoteKrz' ).AsString );
		note := NoteNum( fC2.FieldByname( 'NoteKrz' ).AsString );
		if note <> 999 then
		begin
			inc( DSCnt );
			DSN := DSN + note;
		end;
		fC2.Next;
	end;
	if DSCnt > 0 then
		DSN := DSN / DSCnt;
	DSN := trunc( DSN * 10 );
	DSN := DSN * 0.1;

	DurchschnittsNoteSpeichern( DSN, 'Durchschnittsnote', 'DSN_Text' );
	Meldung( ' ' );
	Meldung( 'Durchschnittsnote: ' + FloatToStr( DSN ) );
	Meldung( ' ' );
	FBelegungsfehler := false;
	Result := true; 		// Belegprüfung bestanden
end;


function TAllgPruefungsAlgorithmus.NachpruefungsFaecherErmitteln: boolean;
var
	ds: TDataset;
	i : integer;
	actID : integer;
	fach, res : string;
	cnt: integer;
	notetmp, notesav: integer;
	testen: boolean;
	lstIDs: TIntegerList;
	Prf10, cmd: string;
begin
// Die IDs sichern
	lstIDs := TIntegerList.Create;
	try

	fCS.First;
	while not fCS.EOF do
	begin
		lstIDs.Add( fCS.FieldByName( 'ID' ).AsInteger );
		fCS.Next;
	end;

	FNachprFaecherErmitteln := true;
	fMeldungAktiv := false;
	cnt := 0;

	for i := 0 to lstIDs.Count - 1 do
	begin		// Schleife über die Fächer-IDs
// Jedesmal wieder aus fCS nach fC0 zurück
		fC0.EmptyTable;
		fC1.EmptyTable;
		fC2.EmptyTable;
		fCS.First;
		while not fCS.EOF do
		begin
			fC0.Append;
			RBKCopyRecord( fCS, fC0 );
			fC0.Post;
			fCS.Next;
		end;
		with fC0 do
		begin
			actID := lstIDs[i];
			Locate( 'ID', actID, [] );
			fach := FieldByname( 'FachName' ).AsString;
      FTestFach_ID := FieldByName( 'Fach_ID' ).AsInteger;
			prf10 := FieldByname( 'Prf10Fach' ).AsString;
			if fPruefungsArt = 'V' then
			begin   // Bei Versetzung
				testen := FieldByname( 'Note' ).AsInteger = 5;//fGrenznote + 1;
				notetmp := 4;
				notesav := FieldByname( 'Note' ).AsInteger;
			end else if fPruefungsArt = 'A' then
			begin // Bei Abschluss
				testen := FieldByname( 'Note' ).AsInteger >= fGrenzNote;
				notetmp := FieldByname( 'Note' ).AsInteger - 1;
				notesav := FieldByname( 'Note' ).AsInteger;
			end;

			if testen and ( prf10 = '-' ) then
			begin
        FTestNote := notetmp;
				Edit;
				FieldByname( 'Note' ).AsFloat := notetmp;
				Post;

//--------------------------------------------------------------------------------------------------
// Die Versetzungen
//--------------------------------------------------------------------------------------------------
				if ( fTeilPruefOrdKrz = 'GY/APO-SI05/V6-10' ) then
					res := Pruefe_GY_APO_SI05_V6_10_Versetzung
				else if ( fTeilPruefOrdKrz = 'GY/APO-GOSt02/V12' ) or
								( fTeilPruefOrdKrz = 'GE/APO-GOSt02/V12' ) or
                ( fTeilPruefOrdKrz = 'GY/APO-GOStG8/VQ' ) or
                ( fTeilPruefOrdKrz = 'GE/APO-GOStG8/VQ' ) or
                ( fTeilPruefOrdKrz = 'GY/APO-GOStG9/V12' ) or
                ( fTeilPruefOrdKrz = 'GE/APO-GOStG9/V12' ) then
          res := Pruefe_GY_APO_GOSt02_V12
				else if ( fTeilPruefOrdKrz = 'R/APO-SI05/V6' ) then
					res := Pruefe_R_APO_SI05_V6_9_Versetzung
				else if ( fTeilPruefOrdKrz = 'R/APO-SI05/V7-9' )  then
					res := Pruefe_R_APO_SI05_V6_9_Versetzung
				else if ( fTeilPruefOrdKrz = 'H/APO-SI05/V6-8' ) then
					res := Pruefe_H_APO_SI05_V6_9_Versetzung
				else if fTeilPruefOrdKrz = 'H/APO-SI05/V9(10A)' then
					res := Pruefe_H_APO_SI05_V6_9_Versetzung
				else if fTeilPruefOrdKrz = 'H/APO-SI05/V9(10B)' then
					res := Pruefe_H_APO_SI05_V9_10B_Versetzung
//--------------------------------------------------------------------------------------------------------
// HSA 9 in Gesamtschule = Versetzung von 9 anch 10
        else if ( FSchulform = 'GE' ) and ( FTeilPruefOrdKrz = 'GE/APO-SI05/HA' ) then
					res := Pruefe_R_GY_GE_APO_SI05_HSA_9
  // Neu: Auch für Gesamtschule
        else if ( fTeilPruefOrdKrz = 'GE/APO-SI05/HA10' ) then
          res := Pruefe_APO_SI05_HSA_10

//--------------------------------------------------------------------------------------------------------
// Die Abschlüsse
//--------------------------------------------------------------------------------------------------------
// FOR
				else if ( ( fTeilPruefOrdKrz = 'H/APO-SI05/FOR' ) and ( fPruefOrdnung = 'H/APO-SI05/10B' ) ) or
								( fTeilPruefOrdKrz = 'R/APO-SI05/FOR' ) or
								( fTeilPruefOrdKrz = 'GY/APO-SI05/FOR' ) or
                ( fTeilPruefOrdKrz = 'GY/APO-GOStG8/FOR' ) or
                ( fTeilPruefOrdKrz = 'GY/APO-GOStG9/FOR' ) or
  // Gesamtschule
                ( fTeilPruefOrdKrz = 'GE/APO-SI05/FOR' )  then
					res := Pruefe_APO_SI05_FOR_Abschluss

//FORQ
        else if ( ( fTeilPruefOrdKrz = 'H/APO-SI05/FORQ-E' ) and ( fPruefOrdnung = 'H/APO-SI05/10B' ) ) or
              ( fTeilPruefOrdKrz = 'R/APO-SI05/FORQ-E' ) or
  // Gesamtschule
              ( fTeilPruefOrdKrz = 'GE/APO-SI05/FORQ-E' ) then
					res := Pruefe_APO_SI05_FORQ_Abschluss;

				Locate( 'ID', actID, [] );		// wieder zurückfinden
				if ( ( res = 'V' ) or ( res = 'A' ) ) and ( prf10 = '-' ) then// mit einer 4 würde die Versetzung/Abschluss klappen
				begin
					inc( cnt );
					fMeldungAktiv := true;
					if cnt = 1 then
						Meldung( ' ' );
					Meldung( fach + ' ist mögliches Nachprüfungsfach' );
					fMeldungAktiv := false;
          if FNPFaecher <> '' then
            FNPFaecher := FNPFaecher + ', ';
          FNPFaecher := FNPFaecher + fach;
				end;
				Edit;
				FieldByname( 'Note' ).AsInteger := notesav;
				Post;
			end;
			Next;
		end;
	end;
	fMeldungAktiv := true;
	fNachprFaecherErmitteln := false;
	Result := cnt > 0;
	if cnt = 0 then
	begin
		Meldung ( ' ' );
    Meldung( 'Keine möglichen Nachprüfungsfächer gefunden' );
    cmd := Format( 'update SchuelerLernabschnittsdaten set MoeglNPFaecher=NULL where ID=%d', [ fA_ID ] );
	end else
    cmd := Format( 'update SchuelerLernabschnittsdaten set MoeglNPFaecher=%s where ID=%d', [ QuotedStr( FNPFaecher ), fA_ID ] );
  TransactionHandler.DoExecute( cmd );

	finally
	  FreeAndNil( lstIDs );
	end;

end;


function TAllgPruefungsAlgorithmus.Pruefe_GY_APO_GOSt02_V12_Versetzung: boolean;
var
	idf, idfa, ide, idc: string;
	i : integer;
	msg: string;
	ausgl: boolean;
begin

	Result := false;
	msg := '';
// Auf 6 in C1 prüfen
	idf := NoteVorhanden( fC1, 'Note', '=', 6, -1 );
	if idf <> '' then
	begin		// 6 vorhanden
		for i := 1 to NumToken( idf, ';' ) do
			StrAdd( SchreibeFachNote( fC1, StrToInt( GetToken( idf, ';', i ) ) ), msg );
		VersetzungsMeldung( 'Keine Versetzung:', msg );
		exit;
	end;

// Auf 5 in C1 prüfen
	idf := NoteVorhanden( fC1, 'Note', '=', 5, -1 );
	if idf <> '' then
	begin	// 5 vorhanden
		for i := 1 to NumToken( idf, ';' ) do
			StrAdd( SchreibeFachNote( fC1, StrToInt( GetToken( idf, ';', i ) ) ), msg );
		if NumToken( idf, ';' ) > 1 then
		begin		// zwei oder mehr 5
			VersetzungsMeldung( 'Keine Versetzung:', msg );
			exit;
		end else
		begin		// eine 5, Ausgleichsfach in C1 vorhanden?
			idfa := BesteNoteID( fC1, '', '', -1 );
			ausgl := ( idfa <> '' ) and ( fBesteNote < 4 );
			if not ausgl then
			begin
				msg := msg + 'Kein Ausgleichsfach unter den Kernfächern gefunden';
				VersetzungsMeldung( 'Keine Versetzung:', msg );
				exit;
			end else
			begin
				AusgleichsfachAusgeben( idfa, fC1, msg );
// prüfen, ob in C2 eine 5 existiert
				idf := NoteVorhanden( fC2, 'Note', '=', 5, -1 );
				if idf <> '' then
				begin		// es gibt eine 5 in C2
					for i := 1 to NumToken( idf, ';' ) do
						StrAdd( SchreibeFachNote( fC2, StrToInt( GetToken( idf, ';', i ) ) ), msg );
					VersetzungsMeldung( 'Keine Versetzung:', msg );
					exit;
				end;
			end;
		end;

	end else
	begin // Keine 5 in C1, jetzt C2 prüfen
		idf := NoteVorhanden( fC2, 'Note', '>', 4, -1 );
		if idf <> '' then
		begin		// in C2 Fächer schlechter als 4
			for i := 1 to NumToken( idf, ';' ) do
				StrAdd( SchreibeFachNote( fC2, StrToInt( GetToken( idf, ';', i ) ) ), msg );
			if NumToken( idf, ';' ) > 1 then
			begin		// zwei oder mehr Fächer in C2 schlechter als 4
				VersetzungsMeldung( 'Keine Versetzung:', msg );
				exit;
			end else
			begin	 // nur ein Fach in C2 schlechter als 4, prüfen ob 6
				fC2.Locate( 'ID', StrToInt( GetToken( idf, ';', 1 ) ), [] );
				if fC2.FieldByName( 'Note' ).AsFloat = 6 then
				begin	// das fach aus C2  ist 6
					VersetzungsMeldung( 'Keine Versetzung:', msg );
					exit;
				end;
			end;
		end;
	end;

	Result := true;		// keine 5 in C2: Versetzt!!!
	Meldung( 'Versetzt!' );
end;


function TAllgPruefungsAlgorithmus.Hole_GY_APO_GOSt10_V12_Faecher: boolean;

	function FSF_SPR_NW: boolean;
	var
		idspr, idnw, idwn: string;
		n_spr, n_nw, n_wn: double;
	begin
// Die Prüfung auf ein fremsparchliches fach muss noch erfolgen

		idspr := FeldWertIDs( fC0, 'Fachgruppe', 'FS', 0 );	// ID's der Sprachfächer
		idnw := FeldWertIDs( fC0, 'Fachgruppe', 'NW', 0 );// ID's der NW-Fächer
		idwn := FeldWertIDs( fC0, 'Fachgruppe', 'WN', 0 );// ID's der NW-Fächer
		if ( idspr = '' ) and ( idnw = '' ) and ( idwn = '' ) then
		begin
			Result := false;
			exit;	// wder 2. NW noch 2. Sprache gefunden
		end;

		if idspr <> '' then
		begin
			idspr := BesteNoteID( fC0, 'Fachgruppe', 'FS', -1 );
			n_spr := fBesteNote;
		end else
			n_spr := 6;

		if idnw <> '' then
		begin	// klass. NW
			idnw := BesteNoteID( fC0, 'Fachgruppe', 'NW', -1 );
			n_nw := fBesteNote;
		end else
			n_nw := 6;
		;// else if idwn <> '' then
		if idwn <> '' then
		begin	// weiter NW
			idwn := BesteNoteID( fC0, 'Fachgruppe', 'WN', -1 );
			n_wn := fBesteNote;
		end else
			n_wn := 6;

		if ( n_spr <= n_nw ) and ( n_spr <= n_wn ) then
			Uebertragen( fC0, fC2, idspr )
		else if ( n_nw <= n_spr ) and ( n_nw <= n_wn ) then
			Uebertragen( fC0, fC2, idnw )
		else if ( n_wn <= n_spr ) and ( n_wn <= n_nw ) then
			Uebertragen( fC0, fC2, idwn );

		fFSF := true;
	end;


var
	DSN: double;
	DSCnt: integer;
  S_FS89, kurszahl, C2Zahl, c1_cnt, c2_cnt: integer;
  idHF: string;
	ids: string;
  anzFSI: integer;
	note: double;
begin
	kurszahl := 10;
	C2Zahl := 7;


	FBelegungsfehler := true;
  anzFSI := FeldWertAnzahl( fC0, 'FachgruppeIntern', 'FSI' );
	if anzFSI > 1 then
	begin
		if anzFSI > 2 then
		begin		// mehr als 2 Fremdsprachen aus SI
			Uebertragen( fC0, fC1, BesteNoteID( fC0, 'FachgruppeIntern', 'FSI', -1 ) );		// von C0 nach C1
		end else
		begin		// 2 Fremdsprachen aus SI
			S_FS89 := FeldWertAnzahl( fC0, 'FachgruppeIntern2', 'FS89' );		// Anzahl Fremdsprachen aus 9

			if S_FS89 = 0 then		// alle beiden Fremdsprachen vor 8
				Uebertragen( fC0, fC1, BesteNoteID( fC0, 'FachgruppeIntern', 'FSI', -1 ) )		// von C0 nach C1
			else
			begin		// mind. 1 Fremdsprache in 9
				Uebertragen( fC0, fC2, FeldWertIDs( fC0, 'FachgruppeIntern2', 'FS89', 0 ) );		// die FS aus 9 in C2
				Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'FachgruppeIntern', 'FSI', 0 ) );		// von C0 nach C1
				fFSF := true;		// FSF-Flag setzen
			end;
		end;

	end else if anzFSI > 0 then
	begin			// eine Fremdsprache aus SI
		Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'FachgruppeIntern', 'FSI', 0 ) );		// von C0 nach C1
	end else if anzFSI = 0 then
	begin		// keine Fremsprache
		Meldung( 'Fortgeführte Fremdsprache fehlt' );
		exit;
	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung der Fremdsprachen' );
		exit;
	end;

// FOLIE 2

// Deutsch prüfen

	idHF := HauptFachID( fC0, 'Fach', 'D' );
  if idHF = '' then
	begin		// Deutsch enthalten?
		Meldung( 'Deutsch fehlt' );
		exit;
	end else
		Uebertragen( fC0, fC1, idHF );

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung von Deutsch' );
		exit;
	end;

// Mathe prüfen
	idHF := HauptFachID( fC0, 'Fach', 'M' );
	if idHF = '' then
	begin		// Mathe enthalten?
		Meldung( 'Mathematik fehlt' );
		exit;
	end else
	begin
		if not fFSF then// Prüfung eines fremdsprachlichen Mathe-Unterichts!
			FSF_Pruefen( idHF, -1 );
		Uebertragen( fC0, fC1, idHF );
	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung von Mathematik' );
		exit;
	end;

// Sport prüfen
	idHF := HauptFachID( fC0, 'Fach', 'SP' );
	if idHF = '' then
	begin		// kein Sport enthalten
		Meldung( 'Sport fehlt (Bei Abmeldung muss Sport aber ebenfalls belegt sein)' );
		exit;
	end else
	begin
		fC0.Locate( 'ID', idHF, [] );
		if fC0.FieldByname( 'NoteKrz' ).AsString = 'AT' then
		begin
			AusContainerLoeschen( fC0, idHF ); // C0\SP
		end else
		begin
			if not fFSF then// Prüfung eines fremdsprachlichen Sport-Unterichts!
				FSF_Pruefen( idHF, -1 );
			Uebertragen( fC0, fC2, idHF );		// SP von C0 nach C2!!
		end;

	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung von Sport' );
		exit;
	end;

// Religion prüfen
  idHF := HauptFachID( fC0, 'FachgruppeIntern', 'RE' );
  if idHF = '' then
	begin		// keine Religion, dann auf Philosophie prüfen
    idHF := HauptFachID( fC0, 'Fach', 'PL' );
		if idHF = '' then
		begin		// keine Philosophie prüfen
			Meldung( 'Religion oder Philosophie fehlt' );
			exit;
		end else
		begin
			if not fFSF then// Prüfung eines fremdsprachlichen Philosophie-Unterichts!
				FSF_Pruefen( idHF, -1 );
			Uebertragen( fC0, fC2, idHF );		// PL von C0 nach C2!!
		end;
	end else
	begin	// Religion vorhanden
		Uebertragen( fC0, fC2, idHF );		// RE von C0 nach C2!!
	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung von Religion/Philosophie' );
		exit;
	end;

// Gesellschftswissenschften prüfen
  idHF := HauptFachID( fC0, 'FachgruppeIntern2', 'GP' );
  if idHF = '' then
	begin		// keine GS-Fächer
		Meldung( 'Gesellschaftswissenschftliche Fächer fehlen' );
		exit;
	end else
	begin
		ids := FSF_Pruefen( idHF, 5 );		// Prüfung eines fremdsprachlichen GS-Unterichts!bei GS muss auf NOte <5 geprüft werden
		if ids <> '' then
			ids := GetToken( ids, ';', 1 )	// ID des fremdpsrachlichen GS-Faches = "V-Fach"
		else
			ids := BesteNoteID( fC0, 'FachgruppeIntern2', 'GP', -1 );	// V-Fach = min GS
		Uebertragen( fC0, fC2, ids );		//
	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung der geselschaftswissenschaftlichen Fächer' );
		exit;
	end;

// PH BI CH prüfen
  idHF := HauptFachID( fC0, 'FachgruppeIntern', 'BCP' );
  if idHF = '' then
	begin		// keine PH BI CH-Fächer
		Meldung( 'Physik, Biologie oder Chemie fehlen' );
		exit;
	end else
	begin
		ids := FSF_Pruefen( idHF, 5 );		// bei PH, BI, CH muss auf NOte <5 geprüft werden
		if ids <> '' then
			ids := GetToken( ids, ';', 1 )	// ID des fremdpsrachlichen GS-Faches = "V-Fach"
		else
			ids := BesteNoteID( fC0, 'FachgruppeIntern', 'BCP', -1 );	// V-Fach = min PH BI CH
		Uebertragen( fC0, fC2, ids );		// PL von C0 nach C2!!
	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung von Physik/Biologie/Chemie' );
		exit;
	end;

// Musische Fächer prüfen
  idHF := HauptFachID( fC0, 'FachgruppeIntern', 'MS' );
  if idHF = '' then
	begin		// keine musischen Fächer
		Meldung( 'Musische Fächer fehlen' );
		exit;
	end else
	begin
		ids := FSF_Pruefen( idHF, 5 );		// bei PH, BI, CH muss auf NOte <5 geprüft werden
		if ids <> '' then
			ids := GetToken( ids, ';', 1 )	// ID des fremdpsrachlichen GS-Faches = "V-Fach"
		else
			ids := BesteNoteID( fC0, 'FachgruppeIntern', 'MS', -1 );	// V-Fach = min PH BI CH
		Uebertragen( fC0, fC2, ids );		// PL von C0 nach C2!!
	end;

	if fC0.RecordCount = 0 then
	begin
		ZuWenigKurse( 'nach Bearbeitung der musischen Fächer' );
		exit;
	end;

// Auffüllen auf 10 Kurse
	while ( fC1.RecordCount + fC2.RecordCount ) < kurszahl do
	begin
		if fC0.RecordCount = 0 then
		begin
			ZuWenigKurse( 'beim Auffüllen auf 10 Kurse' );
			exit;
		end;
//		fFSF := true; // Test
		if fFSF then
		begin
			ids := BesteNoteID( fC0, 'FachGruppeIntern', '', -1 );
			Uebertragen( fC0, fC2, ids );
		end else
		begin
			fFSF := FSF_SPR_NW;
			if not fFSF then
			begin
				Meldung( '§8(2): 2. Naturwissenschaft oder 2. Fremdsprache fehlt' );
				Meldung( 'Belegungsfehler!' );
				exit;
			end;
		end;
	end;

  c1_cnt := AnzahlNotenBesserAls( FC1, 6 );
  c2_cnt := AnzahlNotenBesserAls( FC2, 6 );

	if ( c1_cnt < 3 ) or ( c2_cnt < C2Zahl ) then
	begin
		Meldung( 'Zu wenig versetzungsrelevante Fächer. Der Algorithmus kann keine Versetzungsentscheidung vorschlagen' );
		exit;
	end;

	DSN := 0;
	DSCnt := 0;
	fC1.First;
	while not fC1.EOF do
	begin
		note := NoteNum( fC1.FieldByname( 'NoteKrz' ).AsString );
		if note <> 999 then
		begin
			inc( DSCnt );
			DSN := DSN + note;
		end;
		fC1.Next;
	end;
	fC2.First;
	while not fC2.EOF do
	begin
		note := NoteNum( fC2.FieldByname( 'NoteKrz' ).AsString );
		if note <> 999 then
		begin
			inc( DSCnt );
			DSN := DSN + note;
		end;
		fC2.Next;
	end;
	if DSCnt > 0 then
		DSN := DSN / DSCnt;
	DSN := trunc( DSN * 10 );
	DSN := DSN * 0.1;

	DurchschnittsNoteSpeichern( DSN, 'Durchschnittsnote', 'DSN_Text' );
	Meldung( ' ' );
	Meldung( 'Durchschnittsnote: ' + FloatToStr( DSN ) );
	Meldung( ' ' );
	FBelegungsfehler := false;
	Result := true; 		// Belegprüfung bestanden


	FBelegungsfehler := false;  
	Result := true; 		// Belegprüfung bestanden
end;



function TAllgPruefungsAlgorithmus.Pruefe_GY_APO_SI05_V6_10_Versetzung: string;
var
	idf,idfa, idfa2, msg: string;
	i : integer;
	ausgl: boolean;
  idHF: string;
begin
	Result := 'N';
	msg := '';

// Deutsch prüfen
  idHF := HauptFachID( fC0, 'Fach', 'D' );
  if idHF = '' then
	begin		// Deutsch enthalten?
		Meldung( 'Deutsch fehlt' );
		fZuWenigFaecher := true;
	end else
		Uebertragen( fC0, fC1, idHF );

// Mathe prüfen
  idHF := HauptfachID( fC0, 'Fach', 'M' );
  if idHF = '' then
	begin
		Meldung( 'Mathematik fehlt' );
		fZuWenigFaecher := true;
	end else
		Uebertragen( fC0, fC1, idHF );

// Fremdsprachen prüfen
  idHF := HauptFachID( fC0, 'Fachgruppe', 'FS' );
  if idHF = '' then
	begin
		Meldung( 'Fremdsprachen fehlen' );
		fZuWenigFaecher := true;
	end else
	begin
		Uebertragen( fC0, fC1, idHF );
// Jetzt evtl. 3. Fremdsprache wieder in C0 zurück
		Fremdsprache_1_2( fC1, fC0 );
	end;

  if FZuWenigFaecher then
    exit;

// C1 enthält nun D/M/Fremdsprachen, C0 alle anderen Fächer

  if not IstPrognose and SchildSettings.IgnoriereNichtGemahnte5 then
    NichtGemahnte5Ersetzen;

// Auf 6 in C1 prüfen
	idf := NoteVorhanden( fC1, 'Note', '=', 6, -1 );
	if idf <> '' then
	begin		// 6 vorhanden
		for i := 1 to NumToken( idf, ';' ) do
			StrAdd( SchreibeFachNote( fC1, StrToInt( GetToken( idf, ';', i ) ) ), msg );
		VersetzungsMeldung( 'Keine Versetzung:', msg );
		exit;
	end;

// Auf 5 in C1 prüfen
	idf := NoteVorhanden( fC1, 'Note', '=', 5, -1 );
	if idf <> '' then
	begin	// 5 in D/M/E vorhanden
		for i := 1 to NumToken( idf, ';' ) do
			 StrAdd( SchreibeFachNote( fC1, StrToInt( GetToken( idf, ';', i ) ) ), msg );
// Block (a)
		if NumToken( idf, ';' ) > 1 then
		begin		// zwei oder mehr 5
			VersetzungsMeldung( 'Keine Versetzung:', msg );
			exit;
		end else
		begin		// eine 5, Ausgleichsfach vorhanden?
			idfa := BesteNoteID( fC1, '', '', -1 );
			ausgl := ( idfa <> '' ) and ( fBesteNote < 4 );
			if not ausgl then
			begin
				msg := msg + 'Kein Ausgleichsfach unter den Kernfächern gefunden';
				VersetzungsMeldung( 'Keine Versetzung:', msg );
				exit;
			end else
			begin	// prüfen, ob in C0 Note > 4 existiert
				AusgleichsfachAusgeben( idfa, fC1, msg );
				idf := NoteVorhanden( fC0, 'Note', '>', 4, -1 );
				if idf <> '' then
				begin		// es gibt mindestens ein Neben-Fächer mit Note schlechter als 4
					for i := 1 to NumToken( idf, ';' ) do
						StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf, ';', i ) ) ), msg );
					VersetzungsMeldung( 'Keine Versetzung:', msg );
					exit;
				end;
			end;
		end;
	end else
	begin		// keine 5 in D/M/FS
// Block (b)
		idf := NoteVorhanden( fC0, 'Note', '>', 4, -1 );
		if idf <> '' then
		begin		// in C0 Fächer schlechter als 4 (1b)
			for i := 1 to NumToken( idf, ';' ) do
				StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf, ';', i ) ) ), msg );
			if NumToken( idf, ';' ) > 1 then
			begin		// mehr als 1 Fach in C0 schlechter als 4; (Block c)
				if NumToken( idf, ';' ) > 2 then
				begin		//	mehr als 2 Fächer in C0 schlechter als 4;
					VersetzungsMeldung( 'Keine Versetzung:', msg );
					exit;
				end else
				begin	 // 2 Fächer in C0 schlechter als 4, prüfen ob 6 vorkommt
					idf := NoteVorhanden( fC0, 'Note', '=', 6, -1 );
// Hier neu
					if NumToken( idf, ';' ) > 1 then
					begin // mehr als eine 6 vorhanden
						VersetzungsMeldung( 'Keine Versetzung:', msg );
						exit;
					end;
// Wenn wir hier ankommen, wurde höchsten eine 6 gefunden
// prüfen ob in C1 ein Ausgleichsfach vorhanden
					idfa := BesteNoteID( fC1, '', '', -1 );
					ausgl := ( idfa <> '' ) and ( fBesteNote < 4 );
					if ausgl then
					begin
            AusgleichsfachAusgeben( idfa, fC1, msg );
					end else
					begin		// kein Ausgleichsfach in C1 gefunden, was ist mit C0?
						idfa := BesteNoteID( fC0, '', '', -1 );
						ausgl := ( idfa <> '' ) and ( fBesteNote < 4 );
						if ausgl then
						begin
              AusgleichsfachAusgeben( idfa, fC0, msg );
						end else
						begin
							msg := msg + 'Kein Ausgleichsfach gefunden';
							VersetzungsMeldung( 'Keine Versetzung:', msg );
							exit;
						end;
					end;
				end;
			end;
		end;
	end;

	if msg <> '' then
		VersetzungsMeldung( ' ', msg );

	Result := 'V';
	Meldung( 'Versetzt!' );
end;


// Hauptschule 6 - 8
function TAllgPruefungsAlgorithmus.Pruefe_H_APO_SI05_V6_9_Versetzung: string;
var
	idHF, idf, msg: string;
	i : integer;
begin
// Dieser Algorithmus ist auch identsich mit der Berechbung des Hauptschulabschlusses am Ende von 9 in der HS und
// in der RS und GY am Ende von 9 (dann wírd aber nur Englisch gewertetet)
	Result := 'N';
	msg := '';

// Deutsch prüfen
  idHF := HauptfachID( fC0, 'Fach', 'D' );
  if idHF = '' then
	begin		// Deutsch enthalten?
		Meldung( 'Deutsch fehlt' );
		fZuWenigFaecher := true;
	end else
		Uebertragen( fC0, fC1, idHF );

// Mathe prüfen
  idHF := HauptfachID( fC0, 'Fach', 'M' );
  if idHF = '' then
	begin
		Meldung( 'Mathematik fehlt' );
		fZuWenigFaecher := true;
	end else
		Uebertragen( fC0, fC1, idHF );

// Englisch prüfen
  idHF := HauptfachID( fC0, 'Fach', 'E' );
  if idHF = '' then
	begin
		Meldung( 'Englisch fehlt' );
		fZuWenigFaecher := true;
	end else if StrToInt( fJahrgang ) <= 7 then
		Uebertragen( fC0, fC1, idHF );		// Enlisch zählt lt. Barnscheid nur in jg. 6 und 7 zu den "Hauptfächern"

  if FZuWenigFaecher then
    exit;

// C1 enthält nun D/M/E, C0 alle anderen Fächer
  if SchildSettings.IgnoriereNichtGemahnte5 then
    NichtGemahnte5Ersetzen;

// Auf 6 in C1 prüfen
	idf := NoteVorhanden( fC1, 'Note', '=', 6, -1 );
	if idf <> '' then
	begin		// mindestens eine 6 vorhanden
		for i := 1 to NumToken( idf, ';' ) do
			StrAdd( SchreibeFachNote( fC1, StrToInt( GetToken( idf, ';', i ) ) ), msg );
		VersetzungsMeldung( 'Keine Versetzung:', msg );
		exit;
	end;

// Auf 5 in C1 prüfen
	idf := NoteVorhanden( fC1, 'Note', '=', 5, -1 );
	if idf <> '' then
	begin	// 5 in D/M/E vorhanden
		for i := 1 to NumToken( idf, ';' ) do
			StrAdd( SchreibeFachNote( fC1, StrToInt( GetToken( idf, ';', i ) ) ), msg );
		if NumToken( idf, ';' ) > 1 then
		begin		// zwei oder mehr 5
			VersetzungsMeldung( 'Keine Versetzung:', msg );
			exit;
		end else
		begin		// eine 5, wie sieht es bei den übrigen Fächern aus?
			idf := NoteVorhanden( fC0, 'Note', '>', 4, -1 );   // >4
			if idf <> '' then
			begin		// es gibt mindestens ein Fach mit 5 oder 6 in C0
				for i := 1 to NumToken( idf, ';' ) do
					StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf, ';', i ) ) ), msg );
				if NumToken( idf, ';' ) > 1 then
				begin		// zwei oder mehr 5,6 in C0
					VersetzungsMeldung( 'Keine Versetzung:', msg );
					exit;
				end;
			end;
		end;
	end else
	begin		// keine 5 in D/M/E
		idf := NoteVorhanden( fC0, 'Note', '>', 4, -1 );
		if idf <> '' then
		begin		// in C0 Fächer schlechter als 4
			for i := 1 to NumToken( idf, ';' ) do
				StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf, ';', i ) ) ), msg );
			if NumToken( idf, ';' ) > 1 then
			begin		//	2 oder mehr Fächer in C0 schlechter als 4
				if NumToken( idf, ';' ) > 2 then
				begin // 3 oder mehr Fächer in C0 schlechter als 4 ==> Keine Versetzung
					VersetzungsMeldung( 'Keine Versetzung:', msg );
					exit;
				end else
				begin	// es gibt 2 Fächer >4 in fC0, ist dabei eine 6?
					idf := NoteVorhanden( fC0, 'Note', '=', 6, -1 );
					if NumToken( idf, ';' ) > 1 then
					begin	//
						VersetzungsMeldung( 'Keine Versetzung:', msg );
						exit;
					end;
				end;
			end;
		end;
	end;

	Result := 'V';
	Meldung( 'Versetzt!' );

end;


function  TAllgPruefungsAlgorithmus.Vorpruefung_HSA_GE: boolean;
var
  idGK, idWPI, idUeb, idTmp: string;
  i, anz4: integer;
begin
// Gesamtschule:
  with fC0 do
  begin
    First;
    while not EOF do
    begin
      if ( Trim( FieldByname( 'Kursart' ).AsString ) = 'E' ) then
      begin
        Edit;
        FieldByName( 'Kursart' ).AsString := 'G';
        if ( FieldByName( 'Note' ).AsInteger = 5 ) then
          FieldByName( 'Note' ).AsInteger := 4;
        Post;
      end;
      Next;
    end;
  end;

  idGK := NoteVorhanden( fC0, 'Note', '<=', 4, 'G' ); // G-Kurse 4 oder besser
  idWPI := NoteVorhanden( fC0, 'Note', '<=', 4, 'WPI' ); // WPI-Kurse 4 oder besser

  Result := AnzahlElemente( idGK ) >= 4;
  if Result then
  begin
    Result := AnzahlElemente( idWPI ) >= 1;
    if Result then
    begin // übrige Fächer 4
      idUeb := NoteVorhanden( fC0, 'Note', '<=', 6, -1 ); // die übrigen Fächer (enthalten anfänglich alle Fächer)
      idTmp := NoteVorhanden( fC0, 'Note', '<=', 6 , 'G' ); // alle G-Kurse
      idUeb := DifferenzMenge( idUeb, idTmp ); // alle G-Kurse raus
      idTmp := NoteVorhanden( fC0, 'Note', '<=', 6 , 'WPI' ); // alle E-Kurse
      idUeb := DifferenzMenge( idUeb, idTmp ); // alle WP raus
      anz4 := 0;
      for i := 1 to AnzahlElemente( idUeb ) do
      begin
        FC0.Locate( 'ID', StrToInt( Einzelelement( idUeb, i ) ), [] );
        if FC0.FieldByname( 'Note' ).AsInteger = 4 then
          inc( anz4 );
      end;
      Result := anz4 = AnzahlElemente( idUeb );
    end;
  end;
end;

function TAllgPruefungsAlgorithmus.Pruefe_R_GY_GE_APO_SI05_HSA_9: string;
var
	idf0, idf1, msg, idHF: string;
	i : integer;
  erfolg, del: boolean;
begin
// Dieser Algorithmus ist auch identsich mit der Berechbung des Hauptschulabschlusses am Ende von 9 in der HS und
// in der RS und GY am Ende von 9 (dann wírd aber nur Englisch gewertetet)
	Result := 'N';
	msg := '';

  if FSchulform = 'GE' then
    erfolg := Vorpruefung_HSA_GE
  else
    erfolg := false;

  if not erfolg then
  begin
  // Deutsch prüfen
    idHF := HauptfachID( fC0, 'Fach', 'D' );
    if idHF = '' then
    begin		// Deutsch enthalten?
      Meldung( 'Deutsch fehlt' );
      fZuWenigFaecher := true;
    end else
      Uebertragen( fC0, fC1, idHF );

  // Mathe prüfen
    idHF := HauptfachID( fC0, 'Fach', 'M' );
    if idHF = '' then
    begin
      Meldung( 'Mathematik fehlt' );
      fZuWenigFaecher := true;
    end else
      Uebertragen( fC0, fC1, idHF );

  // Englisch prüfen
    idHF := HauptfachID( fC0, 'Fach', 'E' );
    if idHF = '' then
    begin
      Meldung( 'Englisch fehlt' );
      fZuWenigFaecher := true;
    end else if StrToInt( fJahrgang ) <= 7 then
      Uebertragen( fC0, fC1, idHF );		// Enlisch zählt lt. Barnscheid nur in jg. 6 und 7 zu den "Hauptfächern"

    if FZuWenigFaecher then
      exit;

  // Jetzt noch die Fremdsprachen ib C0 außer Englisch löschen
    with fC0 do
    begin
      First;
      while not EOF do
      begin
        del := false;
        if ( FieldByname( 'Fachgruppe' ).AsString = 'FS' ) and ( fC0.FieldByname( 'Fach' ).AsString <> 'E' ) then
        begin
          if FSchulgliederung = 'GE' then
            del := FieldByName( 'Note' ).AsInteger > 4 // Defizite bleiben in allen FS außer E unberücksichtigt
          else
            del := true;
        end;
        if del then
          Delete
        else
          Next;
      end;
    end;

  // Auf 6 in C1 prüfen
    idf1 := NoteVorhanden( fC1, 'Note', '=', 6, -1 );
    idf0 := NoteVorhanden( fC0, 'Note', '>=', 5, -1 );
    if idf1 <> '' then
    begin		// mindestens eine 6 vorhanden
      for i := 1 to AnzahlElemente( idf1 ) do
        StrAdd( SchreibeFachNote( fC1, StrToInt( EinzelElement( idf1, i ) ) ), msg );
      for i := 1 to AnzahlElemente( idf0 ) do
        StrAdd( SchreibeFachNote( fC0, StrToInt( EinzelElement( idf0, i ) ) ), msg );
      VersetzungsMeldung( 'Kein Hauptschulabschluss:', msg );
      exit;
    end;

  // Auf 5 in C1 prüfen
    idf1 := NoteVorhanden( fC1, 'Note', '=', 5, -1 );
    if idf1 <> '' then
    begin	// 5 in D/M/E vorhanden
      for i := 1 to AnzahlElemente( idf1 ) do
        StrAdd( SchreibeFachNote( fC1, StrToInt( EinzelElement( idf1, i ) ) ), msg );
      for i := 1 to AnzahlElemente( idf0 ) do
        StrAdd( SchreibeFachNote( fC0, StrToInt( EinzelElement( idf0, i ) ) ), msg );

      if AnzahlElemente( idf1 ) > 1 then
      begin		// zwei oder mehr 5
        VersetzungsMeldung( 'Kein Hauptschulabschluss:', msg );
        exit;
      end else
      begin		// eine 5, wie sieht es bei den übrigen Fächern aus?
        if AnzahlElemente( idf0 ) > 1 then
        begin		// zwei oder mehr 5,6 in C0
          VersetzungsMeldung( 'Kein Hauptschulabschluss:', msg );
          exit;
        end;
      end;
    end else if idf0 <> '' then
    begin		// in C0 Fächer schlechter als 4
      for i := 1 to NumToken( idf0, ';' ) do
        StrAdd( SchreibeFachNote( fC0, StrToInt( EinzelElement( idf0,  i ) ) ), msg );
      if AnzahlElemente( idf0 ) > 1 then
      begin		//	2 oder mehr Fächer in C0 schlechter als 4
        if AnzahlElemente( idf0 ) > 2 then
        begin // 3 oder mehr Fächer in C0 schlechter als 4 ==> Keine Versetzung
          VersetzungsMeldung( 'Kein Hauptschulabschluss:', msg );
          exit;
        end else
        begin	// es gibt 2 Fächer >4 in fC0, ist dabei eine 6?
          idf0 := NoteVorhanden( fC0, 'Note', '=', 6, -1 );
          if AnzahlElemente( idf0 ) > 1 then
          begin	//
            VersetzungsMeldung( 'Kein Hauptschulabschluss:', msg );
            exit;
          end;
        end;
      end;
    end;
  end;

	Result := 'A';

// Hier keine Progmosemitteilung, das HS (wenn erreicht) ein "ecter" Abschluss ist
	Meldung( 'Hauptschulabschluss erreicht!' );

end;



// Realschule Vers. von 6 bis 9
function TAllgPruefungsAlgorithmus.Pruefe_R_APO_SI05_V6_9_Versetzung: string;
var
  fs2_ausgl: string;


  procedure Fremdsprache_2_Entfernen;
  var
    f_id: integer;
  begin
    f_id := 0;
// Erst mal prüfen, ob aufgrund Jahrgang eine 2. FS zu ermitteln ist
    with FC0 do
    begin
      First;
      while not EOF do
      begin
        if ( FieldByname( 'Fachgruppe' ).AsString = 'FS' ) and ( FieldByname( 'BeginnJahrgang' ).AsInteger > 5 ) then
        begin
          f_id := FieldByname( 'Fach_ID' ).AsInteger;
          break;
        end;
        Next;
      end;

      if f_id <> 0 then
      begin
        Locate( 'Fach_ID', f_id, [] );
        if FieldByName( 'Note' ).AsInteger >= 5 then
          Delete
        else if FieldByName( 'Note' ).AsInteger <= 3 then
          fs2_ausgl := FieldByName( 'ID' ).AsString;
        exit;
      end;

// Wenn wir hier ankommen, wurde kein Fach anhand des Jahrganges gefunden
      First;
      while not EOF do
      begin
        if ( FieldByname( 'Fachgruppe' ).AsString = 'FS' ) and not AnsiStartsText( 'E', FieldByname( 'Fach' ).AsString ) then
        begin
          f_id := FieldByname( 'Fach_ID' ).AsInteger;
          break;
        end;
        Next;
      end;

      if f_id <> 0 then
      begin
        Locate( 'Fach_ID', f_id, [] );
        if FieldByName( 'Note' ).AsInteger >= 5 then
          Delete
        else if FieldByName( 'Note' ).AsInteger <= 3 then
          fs2_ausgl := FieldByName( 'ID' ).AsString;
      end;
    end;
  end;

// Hinweis: Die Unterschiede der Versetzungregeln von Kl. 6 nach 7 zu denen von Kl. 7 nach 8 (bzw. 8 nach 9, bzw. 9 nach 10) unterscheiden
// sich nur dahingegend, dass von 6 nach 7 das WP1-Fach nicht in C1 gehalten wird

var
	idf, idfa, msg, idHF: string;
	ausgl: boolean;
	i : integer;
	FS2: string;
begin
	Result := 'N';
	msg := '';
  fs2_ausgl := '';

// Hier noch prüfen, ob bei Versetzung von 6 nach 7 in der 2.FS eine 5 oder 6 vorkommt
  if FJahrgang = '06' then
    Fremdsprache_2_Entfernen;

// Deutsch prüfen
  idHF := HauptfachID( fC0, 'Fach', 'D' );
  if idHF = '' then
	begin		// Deutsch enthalten?
		Meldung( 'Deutsch fehlt' );
		fZuWenigFaecher := true;
	end else
		Uebertragen( fC0, fC1, idHF );

// Mathe prüfen
  idHF := HauptfachID( fC0, 'Fach', 'M' );
  if idHF = '' then
	begin
		Meldung( 'Mathematik fehlt' );
		fZuWenigFaecher := true;
	end else
		Uebertragen( fC0, fC1, idHF );

// Englisch prüfen
  idHF := HauptfachID( fC0, 'Fach', 'E' );
  if idHF = '' then
	begin
		Meldung( 'Englisch fehlt' );
		fZuWenigFaecher := true;
	end else
		Uebertragen( fC0, fC1, idHF );

// WP1 prüfen, sofer Jahrgang >= 7 ist
	if StrToInt( FJahrgang) >= 7 then
	begin
		if FeldWertAnzahl( fC0, 'Kursart', 'WP1FS' ) > 0 then
			Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'Kursart', 'WP1FS', 0 ) )
		else if FeldWertAnzahl( fC0, 'Kursart', 'WP1MU' ) > 0 then
			Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'Kursart', 'WP1MU', 0 ) )
		else if FeldWertAnzahl( fC0, 'Kursart', 'WP1NT' ) > 0 then
			Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'Kursart', 'WP1NT', 0 ) )
		else if FeldWertAnzahl( fC0, 'Kursart', 'WP1SW' ) > 0 then
			Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'Kursart', 'WP1SW', 0 ) )
		else
		begin
			Meldung( 'WP1 fehlt' );
			fZuWenigFaecher := true;
		end;
	end;

  if FZuWenigFaecher then
    exit;

  // C1 enthält nun D/M/E, ggf. WP1, C0 alle anderen Fächer
  if SchildSettings.IgnoriereNichtGemahnte5 then
    NichtGemahnte5Ersetzen;

// Auf 6 in C1 prüfen (ganz oben in Folie)
	idf := NoteVorhanden( fC1, 'Note', '=', 6, -1 );
	if idf <> '' then
	begin		// 6 vorhanden
		for i := 1 to NumToken( idf, ';' ) do
			StrAdd( SchreibeFachNote( fC1, StrToInt( GetToken( idf, ';', i ) ) ), msg );
		VersetzungsMeldung( 'Keine Versetzung:', msg );
		exit;
	end;

// Auf 5 in C1 prüfen (in Folie links unter "6")
	idf := NoteVorhanden( fC1, 'Note', '=', 5, -1 );
	if idf <> '' then
	begin	// 5 in D/M/E vorhanden
		for i := 1 to NumToken( idf, ';' ) do
			StrAdd( SchreibeFachNote( fC1, StrToInt( GetToken( idf, ';', i ) ) ), msg );
		if NumToken( idf, ';' ) > 1 then
		begin		// zwei oder mehr 5 (Verzweigung nach rechts in Folie)
			VersetzungsMeldung( 'Keine Versetzung:', msg );
			exit;
		end else
		begin		// eine 5, wie sieht es bei den übrigen Haupt-Fächern aus? (horizontal schraffierte Raute in Folie)
			idfa := BesteNoteID( fC1, '', '', -1 );
      if fBesteNote >= 4 then
        idfa := '';
			ausgl := ( idfa <> '' ) or ( fs2_ausgl <> '' );
			if not ausgl then   // kein Ausgleich
			begin
				msg := msg + 'Kein Ausgleichsfach unter den Kernfächern gefunden';
				VersetzungsMeldung( 'Keine Versetzung:', msg );
				exit;
			end else
			begin	// prüfen, ob in C0 eine Note schlechter als 4 existiert (alles im rechten Teil der Folie)
        if idfa <> '' then
  				AusgleichsfachAusgeben( idfa, fC1, msg )
        else if fs2_ausgl <> '' then
  				AusgleichsfachAusgeben( fs2_ausgl, fC0, msg );
				idf := NoteVorhanden( fC0, 'Note', '>', 4, -1 );
				for i := 1 to NumToken( idf, ';' ) do
					StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf, ';', i ) ) ), msg );
				if NumToken( idf, ';' ) > 1 then
				begin		// es gibt mehr als eine Note schlechter als 4 in C0
					VersetzungsMeldung( 'Keine Versetzung:', msg );
					exit;
				end;
			end;
		end;

	end else
	begin		// keine 5 in D/M/E, prüfe weitere Fächer (linker Teil der Folie)
// 5 oder 6 in der 2. FS zählen nicht  ( bei Versetzung von 6 nach 7)!
		idf := NoteVorhanden( fC0, 'Note', '>', 4, -1 );  // Gibt es Fächer schlechter als 4?
		if idf <> '' then
		begin		// es gibt Noten Schlechter als 4
			if NumToken( idf, ';' ) > 2 then
			begin		//	mehr als 2 Fächer in C0 schlechter als 4
				VersetzungsMeldung( 'Keine Versetzung:', msg );
				exit;
			end else if NumToken( idf, ';' ) > 1 then
			begin		// >1 Fach (d.h. 2 Fächer) schlechter als 4
				idf := NoteVorhanden( fC0, 'Note', '=', 6, -1 );	// Prüfen, ob 6 vorkommt
				if NumToken( idf, ';' ) > 1 then
				begin //mehr als eine 6 in C0
					VersetzungsMeldung( 'Keine Versetzung:', msg );
					exit;
				end;
// Wenn wir hier ankommen, gibt es keine oder eine 6
	//Ausgleichsfächer prüfen
				idf := NoteVorhanden( fC1, 'Note', '<', 4, -1 );  // in den Hauptfächern eine Note besser als 4
				if idf = '' then
				begin // keine Note besser als 4 in den Hauptfächern
					idf := NoteVorhanden( fC0, 'Note', '<', 4, -1 );  // in den Nebenfächern eine Note besser als 4 ?
					if idf = '' then
					begin   // Pech gehabt
						msg := msg + 'Kein Ausgleichsfach gefunden';
						VersetzungsMeldung( 'Keine Versetzung:', msg );
						exit;
					end else// Ausgleichsfach in nebenfächern gefunden
						AusgleichsfachAusgeben( idf, fC0, msg );
				end else// Ausgleichsfach in Hauptfächern gefunden
					AusgleichsfachAusgeben( idf, fC1, msg );
			end;
		end;
	end;

	Result := 'V';
	Meldung( 'Versetzt!' );
end;



function TAllgPruefungsAlgorithmus.Pruefe_H_APO_SI05_V9_10B_Versetzung: string;
var
	msg, idf: string;
	i : integer;
	anzE_3, anzE_4: byte;

	function C0_Test: boolean;
	var
		i : integer;
	begin
		idf := NoteVorhanden( fC0, 'Note', '>', 4, -1 );
		if idf <> '' then
		begin
			for i := 1 to NumToken( idf, ';' ) do
				StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf, ';', i ) ) ), msg );
			VersetzungsMeldung( 'Keine Versetzung nach 10B:', msg );
			Result := false;
		end else
			Result := true;
	end;

	function Fall_3a: string;
	begin
		Result := 'N';
		if not C0_Test then
			exit;
		idf := NoteVorhanden( fC0, 'Note', '<', 4, -1 );
		if NumToken( idf, ';' ) > 1 then
		begin
			Result := 'V';
			Meldung( 'Versetzt nach 10B' );
		end else
		begin
			msg := 'Nicht genügend Noten besser als 4 in den Nebenfächern';
			VersetzungsMeldung( 'Keine Versetzung nach 10B:', msg );
		end;
	end;

	function Fall_3b: string;
	begin
		Result := 'N';
		if not C0_Test then
			exit;
		idf := NoteVorhanden( fC0, 'Note', '<', 3, -1 );
		if NumToken( idf, ';' ) > 1 then
		begin
			Result := 'V';
			Meldung( 'Versetzt nach 10B' );
		end else
		begin
			msg := 'Nicht genügend Noten besser als 3 in den Nebenfächern';
			VersetzungsMeldung( 'Keine Versetzung nach 10B:', msg );
		end;
	end;

	function Fall_3c: string;
	begin
		Result := 'N';
		if not C0_Test then
			exit;
		idf := NoteVorhanden( fC0, 'Note', '<', 3, -1 );
		if NumToken( idf, ';' ) > 3 then
		begin
			Result := 'V';
			Meldung( 'Versetzt nach 10B' );
		end else
		begin
			msg := 'Nicht genügend Noten besser als 3 in den Nebenfächern';
			VersetzungsMeldung( 'Keine Versetzung nach 10B:', msg );
		end;
	end;

var
  idHF: string;

begin
	Result := 'NONP';
	msg := '';

// Deutsch prüfen
  idHF := HauptfachID( fC0, 'Fach', 'D' );
  if idHF = '' then
	begin		// Deutsch enthalten?
		Meldung( 'Deutsch fehlt' );
		fZuWenigFaecher := true;
	end else
		Uebertragen( fC0, fC1, idHF );

// Mathe prüfen
  idHF := HauptfachID( fC0, 'Fach', 'M' );
  if idHF = '' then
	begin
		Meldung( 'Mathematik fehlt' );
		fZuWenigFaecher := true;
	end else
		Uebertragen( fC0, fC1, idHF );

// Englisch prüfen
  idHF := HauptfachID( fC0, 'Fach', 'E' );
  if idHF = '' then
	begin
		Meldung( 'Englisch fehlt' );
		fZuWenigFaecher := true;
	end else
		Uebertragen( fC0, fC1, idHF );

  if FZuWenigFaecher then
    exit;

// C1 enthält nun D/M, C0 alle anderen Fächer
{  if SchildSettings.IgnoriereNichtGemahnte5 then
    NichtGemahnte5Ersetzen;}

// Zuerst prüfen: Note > 3 in E-Kurs

// E-Kurse checken
	anzE_3 := 0;
	anzE_4 := 0;
	fC1.Locate( 'Fach', 'E', [] );
	if ( Trim( fC1.FieldByname( 'Kursart' ).AsString ) = 'E' ) then
	begin
		if ( fC1.FieldByName('Note').AsFloat < 3 ) then
			inc( anzE_3 );
		if ( fC1.FieldByName('Note').AsFloat < 4 ) then
			inc( anzE_4 );
	end;

	fC1.Locate( 'Fach', 'M', [] );
	if ( Trim( fC1.FieldByname( 'Kursart' ).AsString ) = 'E' ) then
	begin
		if ( fC1.FieldByName('Note').AsFloat < 3 ) then
			inc( anzE_3 );
		if ( fC1.FieldByName('Note').AsFloat < 4 ) then
			inc( anzE_4 );
	end;

	if anzE_4 < 1 then
	begin
		msg := 'Zu wenig E-Kurse mit Note besser als 4';
		VersetzungsMeldung( 'Keine Versetzung nach 10B:', msg );
		Result := 'NONP'; // nicht versetztm Nachprüfungen würden auch nichts ändern
		exit;
	end;

// Noten besser als 3
	idf := NoteVorhanden( fC1, 'Note', '<', 3, -1 );
	if ( idf <> '' ) and ( anzE_3 > 0 ) and ( NumToken( idf, ';' ) > 2 ) then
	begin
		Result := Fall_3a;
		exit;
	end;

// Noten besser als 4
	idf := NoteVorhanden( fC1, 'Note', '<', 4, -1 );
	if ( idf <> '' ) and ( anzE_4 > 0 )  then
	begin
		if ( NumToken( idf, ';' ) > 2 ) then
		begin
			Result := Fall_3b;
			exit;
		end else if NumToken( idf, ';' ) > 1 then
		begin
			Result := Fall_3c;
			exit;
		end;
	end;

// Wer bis hier gekommen ist, hat Pech gehabt
	msg := 'Keine Noten besser als 4 in den Kernfächern';
	VersetzungsMeldung( 'Keine Versetzung nach 10B:', msg );
	Result := 'N'; // nicht versetzt
end;



function TAllgPruefungsAlgorithmus.Pruefe_APO_SI05_HSA_10: string;	// hauptschulabschluss nach Kl.10
var
	msg, idf0, idf1, idHF: string;
	i : integer;
  erfolg, del: boolean;
  inote: integer;
begin
// Der Algorithmus für den Hausptschulabschluss ist für H, R und GY weitestgehend identisch (Unterschiede nur bei der Auswahl der verwendeten Fächer)

	Result := 'N';
	msg := '';

// Lernbereichsnoten nur bei SI-Hauptschulabschluss
  if ( fSchulgliederung = 'H' ) or ( fSchulgliederung = 'GE' ) then    // Arbeitslehre statt Gesellschaftswissemschaft als Gesamtnote
  begin
    if fGesamtnoteGS <> 0 then
    begin
      AusContainerLoeschen( fC0, FeldWertIDs( fC0, 'Fachgruppe', 'AL', 0 ) );
      inote := FGesamtnoteGS;
      if FNachprFaecherErmitteln and ( FTestFach_ID = -100 ) then
        inote := FTestnote;
      FachHinzu( 'AL', 'AL', 'Arbeitslehre als Lernbereichsnote', '', '', IntToStr( inote ), '', '', '', 0, 1, 0, 0, -100, false, false, '', '', '-', false, false )
    end else
    begin
      Meldung( 'Arbeitslehre als Lernbereichsnote fehlt' );
      FZuWenigFaecher := true;
      Result := 'I';
    end;
  end else if ( fSchulgliederung = 'R' ) or ( fSchulgliederung = 'GY' ) then
  begin
    if fGesamtnoteGS <> 0 then
    begin
      AusContainerLoeschen( fC0, FeldWertIDs( fC0, 'Fachgruppe', 'GS', 0 ) );
      inote := FGesamtnoteGS;
      if FNachprFaecherErmitteln and ( FTestFach_ID = -100 ) then
        inote := FTestnote;
      FachHinzu( 'GL', 'GL', 'Gesellschaftswissenschaft als Lernbereichsnote', '', '', IntToStr( inote ), '', '', '', 0, 1, 0, 0, -100, false, false, '', '', '-', false, false );
    end else
    begin
      Meldung( 'Gesellschaftswissenschaft als Lernbereichsnote fehlt' );
      FZuWenigFaecher := true;
      Result := 'I';
    end;
  end;

  if fGesamtnoteNW <> 0 then
  begin
    AusContainerLoeschen( fC0, FeldWertIDs( fC0, 'Fachgruppe', 'NW', 0 ) );
    AusContainerLoeschen( fC0, FeldWertIDs( fC0, 'Fachgruppe', 'WN', 0 ) );
    inote := FGesamtnoteNW;
    if FNachprFaecherErmitteln and ( FTestFach_ID = -101 ) then
      inote := FTestnote;
    FachHinzu( 'NW', 'NW', 'Naturwissenschaft als Lernbereichsnote', '', '', IntToStr( inote ), '', '', '', 0, 1, 0, 0, -101, false, false, '', '', '-', false, false );
  end else
  begin
    Meldung( 'Naturwissenschaft als Lernbereichsnote fehlt' );
    FZuWenigFaecher := true;
    Result := 'I';
  end;

{  if FSchulgliederung = 'GE' then
    erfolg := Vorpruefung_HSA_GE
  else
    erfolg := false;}

  erfolg := false;

  if not erfolg then
  begin
// Deutsch prüfen
    idHF := HauptfachID( fC0, 'Fach', 'D' );
    if idHF = '' then
    begin		// Deutsch enthalten?
      Meldung( 'Deutsch fehlt' );
      fZuWenigFaecher := true;
    end else
      Uebertragen( fC0, fC1, idHF );

  // Mathe prüfen
    idHF := HauptfachID( fC0, 'Fach', 'M' );
    if idHF = '' then
    begin
      Meldung( 'Mathematik fehlt' );
      fZuWenigFaecher := true;
    end else
      Uebertragen( fC0, fC1, idHF );

  // Englisch prüfen
    idHF := HauptfachID( fC0, 'Fach', 'E' );
    if idHF = '' then
    begin
      Meldung( 'Englisch fehlt' );
      fZuWenigFaecher := true;
    end;{ else
      Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'FachIntern', 'E', 0 ) );}

  // C1 enthält nun D/M, C0 alle anderen Fächer

  // Jetzt noch die Fremdsprachen ib C0 außer Englisch löschen, nicht bei GE
    if FSchulgliederung <> 'GE' then
    begin
      with fC0 do
      begin
        First;
        while not EOF do
        begin
          del := false;
          if ( FieldByname( 'Fachgruppe' ).AsString = 'FS' ) and ( fC0.FieldByname( 'Fach' ).AsString <> 'E' ) then
          begin
            if FSchulgliederung = 'GE' then
              del := FieldByName( 'Note' ).AsInteger > 4 // Defizite bleiben in allen FS außer E unberücksichtigt
            else
              del := true;
          end;
          if del then
            Delete
          else
            Next;
        end;
      end;
    end;
  // Englisch prüfen
    idHF := HauptfachID( fC0, 'Fach', 'E' );
    if idHF = '' then
    begin
      Meldung( 'Englisch fehlt' );
      fZuWenigFaecher := true;
    end;

    if FZuWenigFaecher then
      exit;

  // Fallunterscheidung nach Schulformen
    if ( fSchulgliederung = 'H' ) or ( fSchulgliederung = 'GE' ) then
    begin
      Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'Fach', 'AL', 0 ) );
      Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'Fach', 'NW', 0 ) );
    end else if ( fSchulgliederung = 'R' ) or ( fSchulgliederung = 'GY' ) then
    begin   // Gymnasium/Realschule
      Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'Fach', 'GL', 0 ) );
      Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'Fach', 'NW', 0 ) );
    end;

  {$IFDEF DEBUGMODE}
  //  FC0_FC1_Zeigen;
  {$ENDIF}


  // Auf 6 in C1 prüfen
    idf1 := NoteVorhanden( fC1, 'Note', '=', 6, -1 );
    if idf1 <> '' then
    begin		// 6 vorhanden
      idf1 := NoteVorhanden( fC1, 'Note', '>=', 5, -1 );
      for i := 1 to NumToken( idf1, ';' ) do
        StrAdd( SchreibeFachNote( fC1, StrToInt( GetToken( idf1, ';', i ) ) ), msg );
      idf0 := NoteVorhanden( fC0, 'Note', '>=', 5, -1 );
      for i := 1 to NumToken( idf0, ';' ) do
        StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf0, ';', i ) ) ), msg );

      VersetzungsMeldung( 'Kein Hauptschulabschluss nach Klasse 10:', msg );
      exit;
    end;

  // Auf 5 in C1 prüfen
    idf1 := NoteVorhanden( fC1, 'Note', '=', 5, -1 );
    idf0 := NoteVorhanden( fC0, 'Note', '>=', 5, -1 );
    if idf1 <> '' then
    begin	// 5 in D/M vorhanden
      for i := 1 to NumToken( idf1, ';' ) do
        StrAdd( SchreibeFachNote( fC1, StrToInt( GetToken( idf1, ';', i ) ) ), msg );
      for i := 1 to NumToken( idf0, ';' ) do
        StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf0, ';', i ) ) ), msg );
      if NumToken( idf1, ';' ) > 1 then
      begin		// zwei oder mehr 5
        VersetzungsMeldung( 'Kein Hauptschulabschluss nach Klasse 10:', msg );
        exit;
      end else
      begin		// eine 5, wie sieht es bei den übrigen Fächern aus?
        if idf0 <> '' then
        begin		// es gibt mindestens ein Fach mit 5 oder 6 in C0
          for i := 1 to AnzahlElemente( idf0 ) do
            StrAdd( SchreibeFachNote( fC0, StrToInt( EinzelElement( idf0, i ) ) ), msg );
          if AnzahlElemente( idf0 ) > 1 then
          begin		// zwei oder mehr 5,6 in C0
            VersetzungsMeldung( 'Kein Hauptschulabschluss nach Klasse 10:', msg );
            exit;
          end;
        end;
      end;
    end else if idf0 <> '' then
    begin		// in C0 Fächer schlechter als 4
      for i := 1 to AnzahlElemente( idf0 ) do
        StrAdd( SchreibeFachNote( fC0, StrToInt( EinzelElement( idf0, i ) ) ), msg );
      if AnzahlElemente( idf0 ) > 1 then
      begin		// mehr als 1 Fach in C0 schlechter als 4
        if NumToken( idf0, ';' ) > 2 then
        begin		//	mehr als 2 Fächer in C0 schlechter als 4
          VersetzungsMeldung( 'Kein Hauptschulabschluss nach Klasse 10:', msg );
          exit;
        end else
        begin	 // 2 Fächer in C0 schlechter als 4, prüfen ob 6 vorkommt
          idf0 := NoteVorhanden( fC0, 'Note', '=', 6, -1 );
          if AnzahlElemente( idf0 ) > 1 then
          begin	// mehr als eine 6 in C0
            VersetzungsMeldung( 'Kein Hauptschulabschluss nach Klasse 10:', msg );
            exit;
          end;
        end;
      end;
    end;
  end;
	Result := 'A';
  if IstPrognose then
  	Meldung( 'Prognose: Hauptschulabschluss nach Klasse 10' )
  else
  	Meldung( 'Hauptschulabschluss nach Klasse 10 erreicht!' );
end;


function TAllgPruefungsAlgorithmus.Pruefe_APO_SI05_FOR_Abschluss_GE( const PO_Art: string ): string;
// PO_Art: FOR oder FORQ


  function AnzahlBesserGrenzNote( ds: TDataset; const id_liste: string; const grenznote: integer ): integer;
  var
    i, id: integer;
  begin
    Result := 0;
    for i := 1 to AnzahlElemente( id_liste ) do
    begin
      id := StrToInt( EinzelElement( id_liste, i ) );
      if ds.Locate( 'ID', id, [] ) then
      begin  // es kann sein, dass das betreffende Fach in einer anderen Gruppe ist, daher muss LOcate nicht zum Erfolg führen
        if ds.FieldByName( 'Note' ).AsInteger <= grenznote then
          inc( Result );
      end;
    end;
  end;

var
  msg: string;
  idHF, idEK, idGK, idWPI, idUeb, idTmp, idAusgl, ka : string;
  idDef_mA_FG1, idDef_oA_FG1, idAusgl_FG1: string;
  idDef_mA_FG2, idDef_oA_FG2, idAusgl_FG2: string;
  idDef_mA2_FG2, sID: string;
  i, anz3, anz4, note: integer;
  erfolg: boolean;
  nMinE, GN_EK, GN_GK, GN_WPI, GN_Ueb, GN_: integer;
  ausgl_fg1, gn_ueberschreitung: boolean;
  neg_msg: string;
begin

  Result := 'N';
  msg := '';

//Grenznoten festlegen
  if PO_Art = 'FOR' then
  begin
    nMinE := 2;
    GN_EK := 4;
    GN_GK := 3;
    GN_WPI := 4;
    GN_Ueb := 4; // aber: mindestens 2 Fächer besser als 3
    neg_msg := 'Keine Fachoberschulreife ohne Qualifikationsvermerk';
  end else if PO_Art = 'FORQ' then
  begin
    nMinE := 3;
    GN_EK := 3;
    GN_GK := 2;
    GN_WPI := 3;
    GN_Ueb := 3;
    neg_msg := 'Keine Fachoberschulreife mit Berechtigung z. Besuch d. gymn. Oberstufe -Einführungsphase-';
  end;
{§40 (2) Eine Schülerin oder ein Schüler der Gesamtschule erwirbt nach dem
Abschlussverfahren am Ende der Klasse 10 den mittleren Schulabschluss
(Fachoberschulreife), wenn sie oder er
1.  an mindestens zwei Erweiterungskursen teilgenommen hat,
2.  in den Fächern der Erweiterungskurse und im Fach des Wahlpflichtun-
terrichts  mindestens  ausreichende,  in  den  Fächern  der  Grundkurse
mindestens befriedigende Leistungen erzielt hat,
3.  in den anderen  Fächern bei  sonst mindestens ausreichenden Leistun-
gen in zwei Fächern mindestens befriedigende Leistungen erzielt hat.

Bei der Teilnahme an mehr als zwei Erweiterungskursen werden die Leis-
tungen in den Fächern dieser Kurse wie eine um eine Notenstufe bessere
Leistung  im  Grundkursbereich  gewertet.

Der  Abschluss  wird auch  dann
vergeben, wenn die geforderten Leistungen
in nicht mehr als einem der FDeutsch,  Englisch,  Mathematik,  Fach  des  Wahlpflichtunterrichts
oder
in nicht mehr als einem der übrigen Fächer
um eine Notenstufe unterschritten werden und diese Leistung durch eine bessere Leistung in ei-
nem anderen Fach ausgeglichen wird; dabei muss die Minderleistung in
den Fächern Deutsch, Englisch, Mathematik, Fach des Wahlpflichtunter-
richts durch eine bessere Leistung in einem anderen Fach dieser Fächer-
gruppe ausgeglichen werden. Eine weitere Unterschreitung der Leistun-
gen in den übrigen Fächern um bis zu zwei Notenstufen bleibt unberück-
sichtigt.
}
// Bei folgenden Bedingungen ist FOR erreicht
// 2 E-Kurse mit 4 oder besser und
// 3 G-Kurse mit 3 oder besser und
// 1 WPI-Kurs mit 4 oder besser
// 2x3, sonst 4 in übrigen Fächern



//FORQ
{(4) Eine Schülerin oder ein Schüler der Gesamtschule erwirbt mit dem mitt-
leren Schulabschluss (Fachoberschulreife) die Berechtigung zum Besuch
der gymnasialen Oberstufe und setzt die Schullaufbahn dort in der Einfüh-
rungsphase fort, wenn
1.  sie oder er an mindestens drei Erweiterungskursen teilgenommen hat,
2.  die Leistungen in den Fächern der Erweiterungskurse und im Fach des
Wahlpflichtunterrichts  mindestens  befriedigend  und  im  Fach  des
Grundkurses mindestens gut sind,
3.  die Leistungen in den übrigen Fächern mindestens befriedigend sind.

Bei der Teilnahme an mehr als drei Erweiterungskursen wird die im Fach
des vierten Erweiterungskurses erzielte Leistung wie eine um eine Noten-
stufe bessere Note im Fach des Grundkurses gewertet.

Die Berechtigung
wird auch dann vergeben, wenn die geforderten Leis-tungen in nicht mehr
als  einem  der  Fächer  Deutsch,  Englisch,  Mathematik,  Fach  des  Wahl-
pflichtunterrichts  um  eine  Notenstufe  unterschritten  werden  und  diese
Leistung durch eine bessere Note in einem anderen Fach dieser Fächer-
gruppe ausgeglichen wird. Bis zu zwei Unterschreitungen um eine Noten-
stufe und eine weitere Unterschreitung um bis zu zwei Notenstufen in der
Gruppe der übrigen Fächer müssen durch jeweils mindestens gute Leis-
tungen in anderen Fächern ausgeglichen werden. Jedes Fach darf nur ein-
mal zum Ausgleich herangezogen werden.}

// Prüfen, ob "überzählige" E-Kurse da sind
  idEK := NoteVorhanden( fC0, 'Note', '<=', 6, 'E' ); // Alle E-Kurse sammeln
  if AnzahlElemente( idEK ) > nMinE then
  begin
    fC2.EmptyTable; // temporärer Speicher für E-Kurse
    Kopieren( fC0, fC2, idEK );
// Bei mehreren E-Kurse diese als G-Kurse umsetzen (mit 1 Note besser)
// Die E-Kurse nach Noten sortieren
    fC2.SortByFields( 'Note' );
    fC2.First;
    for i := 1 to nMinE do
      fC2.Next;
    while not fC2.Eof do
    begin
      FC2.Next;
      FC0.Locate( 'ID', fC2.FieldByName( 'ID' ).AsInteger, [] );
      FC0.Edit;
      if fC0.FieldByname( 'Note' ).AsInteger > 1 then
        fC0.FieldByname( 'Note' ).AsInteger := fC0.FieldByname( 'Note' ).AsInteger - 1;
      fC0.FieldByName( 'Kursart' ).AsString := 'G';
      fC0.Post;
    end;
    fC2.EmptyTable;
  end;

// Jetzt die Kurse nochmals holen
  idEK := '';
  idGK := '';
  idUeb := '';

  with fC0 do
  begin
    First;
    while not Eof do
    begin
      ka := FieldByName( 'Kursart' ).AsString;
      if ka = 'E' then
        ZuMengeHinzu( idEK, FieldByname( 'ID' ).AsString )
      else if ka = 'G' then
        ZuMengeHinzu( idGK, FieldByname( 'ID' ).AsString )
      else if ( ka = 'WPI' ) or ( ka = 'WPIG' ) then
        ZuMengeHinzu( idWPI, FieldByname( 'ID' ).AsString )
      else
        ZuMengeHinzu( idUeb, FieldByname( 'ID' ).AsString );
      Next;
    end
  end;

  if PO_Art = 'FOR' then
  begin
// Eine weitere Unterschreitung der Leistungen in den übrigen Fächern um bis zu zwei Notenstufen
// bleibt unberücksichtigt.
// Prüfen, ob bei den Grundkursen
//"Eine weitere Unterschreitung der Leistungengen um bis zu zwei Notenstufen" vorhanden ist
    gn_ueberschreitung := false;
    fC2.EmptyTable;
    Kopieren( fC0, fC2, idGK );
    fC2.SortByFields( 'Note desc' );
    fC2.First;
    while not fC2.Eof do
    begin
      if ( FC2.FieldByname( 'Note' ).AsInteger = 4 ) or
         ( FC2.FieldByname( 'Note' ).AsInteger = 5 )  then
      begin
//        AusMengeLoeschen( idGK, FC2.FieldByname( 'ID' ).AsString );
        AusMengeLoeschen( idUeb, FC2.FieldByname( 'ID' ).AsString );
        gn_ueberschreitung := true;
        break;
      end else
        FC2.Next;
    end;

// Falls bei den Grundkursen keine Überschreitung festgestellt wurde, auch bei den übrigen nachschauen
  // Bei den übrigen ein Fach mit der Note GN_Ueb + 1 oder + 2 suchen,
    if not gn_ueberschreitung then
    begin
      fC2.EmptyTable;
      Kopieren( fC0, fC2, idUeb );
      fC2.SortByFields( 'Note desc' );
      fC2.First;
      while not fC2.Eof do
      begin
        if ( FC2.FieldByname( 'Note' ).AsInteger = GN_Ueb + 1 ) or
           ( FC2.FieldByname( 'Note' ).AsInteger = GN_Ueb + 2 )  then
        begin
          AusMengeLoeschen( idUeb, FC2.FieldByname( 'ID' ).AsString );
          break;
        end else
          FC2.Next;
      end;
    end;
    fC2.EmptyTable;
  end;


// Mindestens nMinE E-Kurse belegt   (Punkt 1 in obiger Liste)
  if AnzahlElemente( idEK ) < nMinE then
  begin
    msg := 'Zu wenig E-Kurse';
    VersetzungsMeldung( neg_msg, msg );
    fZuWenigFaecher := true;
  end;

  if idWPI = '' then
  begin
    msg := 'Kein WPI-Kurs';
    VersetzungsMeldung( neg_msg, msg );
    fZuWenigFaecher := true;
  end else
    Uebertragen( fC0, fC1, idWPI );

// Die Container füllen
  // Deutsch prüfen
  idHF := HauptfachID( fC0, 'Fach', 'D' );
  if idHF = '' then
  begin		// Deutsch enthalten?
    Meldung( 'Deutsch fehlt' );
    fZuWenigFaecher := true;
  end else
    Uebertragen( fC0, fC1, idHF );

// Mathe prüfen
  idHF := HauptfachID( fC0, 'Fach', 'M' );
  if idHF = '' then
  begin
    Meldung( 'Mathematik fehlt' );
    fZuWenigFaecher := true;
  end else
    Uebertragen( fC0, fC1, idHF );

// Englisch prüfen
  idHF := HauptfachID( fC0, 'Fach', 'E' );
  if idHF = '' then
  begin
    Meldung( 'Englisch fehlt' );
    fZuWenigFaecher := true;
  end else
    Uebertragen( fC0, fC1, idHF );

  if FZuWenigFaecher then
    exit;

// Trick, um bei Prognosen die Ermittlung der Nachprüfungsfächer zu verhindern
  fZuwenigFaecher := IstPrognose;

// Jetzt die Prüfungen:
// FOR: in den Fächern der Erweiterungskurse mindestens befriedigende Leistungen erzielt hat,
// d.h. alle EK-Kurse besser als Grenznote
  erfolg := ( AnzahlBesserGrenznote( FC0, idEK, GN_EK ) + AnzahlBesserGrenznote( FC1, idEK, GN_EK ) ) = AnzahlElemente( idEK );
  if erfolg then
// FOR in den Fächern des Wahlpflichtunterrichts  mindestens  ausreichende Leistungen
    erfolg := ( AnzahlBesserGrenznote( FC0, idWPI, GN_WPI ) + AnzahlBesserGrenznote( FC1, idWPI, GN_WPI ) ) = AnzahlElemente( idWPI );
  if erfolg then
// FOR den  Fächern  der  Grundkurse mindestens befriedigende Leistungen erzielt hat
    erfolg := ( AnzahlBesserGrenznote( FC0, idGK, GN_GK ) + AnzahlBesserGrenznote( FC1, idGK, GN_GK ) ) = AnzahlElemente( idGK );

// jetzt die übrigen Fächer
  if erfolg then
  begin
    erfolg := ( AnzahlBesserGrenznote( FC0, idUeb, GN_Ueb ) + AnzahlBesserGrenznote( FC1, idUeb, GN_Ueb ) ) = AnzahlElemente( idUeb );
    if erfolg and ( PO_Art = 'FOR' ) then // zusätzlich 2 Kurse 3 oder besser
      erfolg := ( AnzahlBesserGrenznote( FC0, idUeb, 3 ) + AnzahlBesserGrenznote( FC1, idUeb, 3 ) ) >= 2;
  end;

  if erfolg then
  begin
    Result := 'A';
    exit;
  end;

//Der  Abschluss  wird auch  dann vergeben, wenn die geforderten Leistungen in nicht mehr als einem der Fächer
//Deutsch,  Englisch,  Mathematik,  Fach  des  Wahlpflichtunterrichts um eine Notenstufe unterschritten werden
// dabei muss die Minderleistung in den Fächern Deutsch, Englisch, Mathematik, Fach des Wahlpflichtunter-
//richts durch eine bessere Leistung in einem anderen Fach dieser Fächergruppe ausgeglichen werden
// d.h. wir betrachten Fächergruppe 1
  idDef_mA_FG1 := '';
  idDef_oA_FG1 := '';
  idAusgl_FG1 := '';
  idDef_mA_FG2 := '';
  idDef_oA_FG2 := '';
  idAusgl_FG2 := '';

// Fächergruppe 1 prüfen
  with FC1 do
  begin
    First;
    while not Eof do
    begin
      ka := FieldByName( 'Kursart' ).AsString;
      if ka = 'E' then
        GN_ := GN_EK
      else if ka = 'G' then
        GN_ := GN_GK
      else if ( ka = 'WPI' ) or ( ka = 'WPIG' ) then
        GN_ := GN_WPI
      else
        GN_ := GN_Ueb;
      if FieldByName( 'Note' ).AsInteger = GN_ + 1 then  // Defizit mit Ausgleichmöglichkeit
        ZuMengeHinzu( idDef_mA_FG1, FieldByname( 'ID' ).AsString )
      else if FieldByName( 'Note' ).AsInteger > GN_ + 1 then  // Defizit ohne Ausgleichmöglichkeit
        ZuMengeHinzu( idDef_oA_FG1, FieldByname( 'ID' ).AsString )
      else if FieldByName( 'Note' ).AsInteger < GN_ then
        ZuMengeHinzu( idAusgl_FG1, FieldByname( 'ID' ).AsString );
      Next;
    end;
  end;

// Fächergruppe 2
  idDef_mA2_FG2 := '';
  with FC0 do
  begin
    SortByFields( 'Note' );
    First;
    while not Eof do
    begin
      ka := FieldByName( 'Kursart' ).AsString;
      note := FieldByName( 'Note' ).AsInteger;
      sID := FieldByName( 'ID' ).AsString;
      if ka = 'E' then
        GN_ := GN_EK
      else if ka = 'G' then
        GN_ := GN_GK
      else if ( ka = 'WPI' ) or ( ka = 'WPIG' ) then
        GN_ := GN_WPI
      else
      begin
        GN_ := GN_Ueb;
        if ( PO_Art = 'FOR' ) and ( AnzahlElemente( idAusgl_FG2 ) < 2 ) then // esrt ab 2 Ausgleichfächer kann Grenznote 4 genommen werden
          GN_ := GN_ - 1;
      end;
// Wichtig: die Bedingung für die weiteren Fächer ist
//3.  in den anderen  Fächern bei  sonst mindestens ausreichenden Leistungen in zwei Fächern mindestens befriedigende Leistungen erzielt hat.
// d.h. zum Ausgleich können nur
      if PO_Art = 'FOR' then
      begin
        if note = GN_ + 1 then  // Defizit mit Ausgleichmöglichkeit
          ZuMengeHinzu( idDef_mA_FG2, sID )
        else if note > GN_ + 1 then  // Defizit ohne Ausgleichmöglichkeit
          ZuMengeHinzu( idDef_oA_FG2, sID )
        else if note < GN_ then  // ist potentielles Ausgleichsfach
          ZuMengeHinzu( idAusgl_FG2, sID );
      end else if PO_Art = 'FORQ' then
      begin
        if note = GN_ + 1 then  // Defizit mit Ausgleichmöglichkeit
          ZuMengeHinzu( idDef_mA_FG2, sID )
        else if ( note = GN_ + 2 ) and ( idDef_mA2_FG2 = '' ) then
          ZuMengeHinzu( idDef_mA2_FG2, sID )
        else if note > GN_ + 1 then  // Defizit ohne Ausgleichmöglichkeit
          ZuMengeHinzu( idDef_oA_FG2, sID )
        else if note < GN_ then
          ZuMengeHinzu( idAusgl_FG2, sID );
      end;
      Next;
    end;
  end;


  ausgl_fg1 := false;
  if PO_Art = 'FOR' then
  begin
// Fächergruppe I
    if ( idDef_oA_FG1 <> '' ) or ( idDef_mA_FG1 <> '' ) then
    begin // DEfizite in Fachgruppe 1 gefunden
      erfolg := ( idDef_oA_FG1 = '' ) and ( AnzahlElemente( idDef_mA_FG1 ) = 1 ) and ( AnzahlElemente( idAusgl_FG1 ) > 0 );
      if not erfolg then
      begin
        msg := 'Defizit(e) ohne Ausgleichsmöglichkeit in Fächergruppe I gefunden';
        VersetzungsMeldung( 'Keine Fachoberschulreife:', msg );
        exit;
      end else
      begin
        Meldung( 'Defizit(e) in Fachgruppe I, Ausgleich gefunden' );
        AusMengeLoeschen( idAusgl_FG1, EinzelElement( idAusgl_FG1, 1 ) ); // Ist "verbraucht"
        ausgl_fg1 := true;
      end;
    end;

// Jetzt noch die übrigen Fächer
    if ( idDef_oA_FG2 <> '' ) or ( idDef_mA_FG2 <> '' ) then
    begin // DEfizite in Fachgruppe 2 gefunden
// Eine weitere Unterschreitung der Leistungen in den übrigen Fächern um bis zu zwei Notenstufen bleibt unberücksichtigt.
// NEUFASSUNG?
      if AnzahlElemente( idDef_mA_FG2 ) = 2 then
        idDef_mA_FG2 := EinzelElement( idDef_mA_FG2, 1 );  // Nehme nur ein Fach

// Wichtig: die Bedingung für die weiteren Fächer ist
//3.  in den anderen  Fächern bei  sonst mindestens ausreichenden Leistungen in zwei Fächern mindestens befriedigende Leistungen erzielt hat.

      idAusgl_FG2 := Vereinigungsmenge( idAusgl_FG1, idAusgl_FG2 );
      erfolg := {not ausgl_fg1 and} ( idDef_oA_FG2 = '' ) and ( AnzahlElemente( idDef_mA_FG2 ) = 1 ) and ( AnzahlElemente( idAusgl_FG2 ) > 0 );
      if not erfolg then
      begin
        msg := 'Defizit(e) ohne Ausgleichsmöglichkeit in Fächergruppe II gefunden';
        VersetzungsMeldung( 'Keine Fachoberschulreife:', msg );
        exit;
      end else
        Meldung( 'Defizit(e) in Fachgruppe II, Ausgleich gefunden' );
    end;
  end else if PO_Art = 'FORQ' then
  begin
// 2 Fälle:
    if ( idDef_oA_FG1 <> '' ) or ( idDef_mA_FG1 <> '' ) then
    begin // DEfizite in Fachgruppe 1 gefunden
// 1. In FGI max. 1 x Abweichung um eine NOte, in FGII max. 3 Abweichungen um ein Note
// Fächergruppe I
      erfolg := ( idDef_oA_FG1 = '' ) and ( AnzahlElemente( idDef_mA_FG1 ) = 1 ) and ( AnzahlElemente( idAusgl_FG1 ) > 0 );
      if not erfolg then
      begin
        msg := 'Defizit(e) ohne Ausgleichsmöglichkeit in Fächergruppe I gefunden';
        VersetzungsMeldung( 'Keine Berechtigung zum Besuch der gymnasialen Oberstufe:', msg );
        exit;
      end else
      begin
        Meldung( 'Defizit(e) in Fachgruppe I, Ausgleich gefunden' );
        AusMengeLoeschen( idAusgl_FG1, EinzelElement( idAusgl_FG1, 1 ) ); // Ist "verbraucht"
      end;
//In FGII max. 3 Abweichungen um ein Note
      if ( idDef_oA_FG2 <> '' ) or ( idDef_mA_FG2 <> '' ) then
      begin // DEfizite in Fachgruppe 2 gefunden
        idAusgl_FG2 := Vereinigungsmenge( idAusgl_FG1, idAusgl_FG2 );
        erfolg := ( idDef_oA_FG2 = '' ) and
                  ( AnzahlElemente( idDef_mA_FG2 ) <= 3 ) and
                  ( AnzahlElemente( idAusgl_FG2 ) >= AnzahlElemente( idDef_mA_FG2 ) );
        if not erfolg then
        begin
          msg := 'Defizit(e) ohne Ausgleichsmöglichkeit in Fächergruppe II gefunden';
          VersetzungsMeldung( 'Keine Fachoberschulreife:', msg );
          exit;
        end else
          Meldung( 'Defizit(e) in Fachgruppe II, Ausgleich gefunden' );
      end;
    end else
    begin // Keine Defizite in FG1 gefunden
// Bis  zu zwei Unterschreitungen um eine Notenstufe und eine weitere Unterschreitung um bis zu
// zwei Notenstufen in der Gruppe der übrigen Fächer müssen durch jeweils mindestens gute Leistungen
// in anderen Fächern ausgeglichen werden.
// 2. 2 x Abweichnung in FG2 um eine Note und 1 x um zwei Noten
      if ( idDef_oA_FG2 <> '' ) or ( idDef_mA_FG2 <> '' ) or ( idDef_mA2_FG2 <> '' ) then
      begin // DEfizite in Fachgruppe 2 gefunden
        idAusgl_FG2 := Vereinigungsmenge( idAusgl_FG1, idAusgl_FG2 );
        erfolg := ( idDef_oA_FG2 = '' ) and
                  ( AnzahlElemente( Vereinigungsmenge( idDef_mA_FG2, idDef_mA2_FG2 ) ) <= 3 ) and
                  ( AnzahlElemente( idAusgl_FG2 ) >= AnzahlElemente( idDef_mA_FG2 ) + AnzahlElemente( idDef_mA2_FG2 ) );
        if not erfolg then
        begin
          msg := 'Defizit(e) ohne Ausgleichsmöglichkeit in Fächergruppe II gefunden';
          VersetzungsMeldung( 'Keine Fachoberschulreife:', msg );
          exit;
        end else
          Meldung( 'Defizit(e) in Fachgruppe II, Ausgleich gefunden' );
      end;

    end;
  end;
  Result := 'A';
end;

function TAllgPruefungsAlgorithmus.Pruefe_APO_SI05_FOR_Abschluss: string;
var
	idf1, idf: string;
	i : integer;
  idHF, msg: string;
begin
  Result := 'N';
  msg := '';

  if FSchulform = 'GE' then
  begin
    Result := Pruefe_APO_SI05_FOR_Abschluss_GE( 'FOR' );
    if Result = 'A' then
    begin
      if IstPrognose then
       	Meldung( 'Prognose: Fachoberschulreife' )
      else
       	Meldung( 'Fachoberschulreife erreicht!' );
    end;
  end else
  begin // 
  // Deutsch prüfen
    idHF := HauptfachID( fC0, 'Fach', 'D' );
    if idHF = '' then
    begin		// Deutsch enthalten?
      Meldung( 'Deutsch fehlt' );
      fZuWenigFaecher := true;
    end else
      Uebertragen( fC0, fC1, idHF );

  // Mathe prüfen
    idHF := HauptfachID( fC0, 'Fach', 'M' );
    if idHF = '' then
    begin
      Meldung( 'Mathematik fehlt' );
      fZuWenigFaecher := true;
    end else
      Uebertragen( fC0, fC1, idHF );

  // Englisch prüfen
    idHF := HauptfachID( fC0, 'Fach', 'E' );
    if idHF = '' then
    begin
      Meldung( 'Englisch fehlt' );
      fZuWenigFaecher := true;
    end else
      Uebertragen( fC0, fC1, idHF );

    if FSchulgliederung = 'H' then
    begin
  // WP1 in H weg
  // WP1-Fächer werden nicht berücksichtig
      AusContainerLoeschen( fC0, FeldWertIDs( fC0, 'Kursart', 'WP1FS', 0 ) );
      AusContainerLoeschen( fC0, FeldWertIDs( fC0, 'Kursart', 'WP1MU', 0 ) );
      AusContainerLoeschen( fC0, FeldWertIDs( fC0, 'Kursart', 'WP1NT', 0 ) );
      AusContainerLoeschen( fC0, FeldWertIDs( fC0, 'Kursart', 'WP1SW', 0 ) );
    end else if ( FSchulgliederung = 'R' ) or ( FSchulgliederung = 'GE' ) then
    begin
  // WP1 in R udn GE in fC1 setzen
      idf := '';
      with FC0 do
      begin
        First;
        while not Eof do
        begin
          if AnsiStartsText( 'WPI', fC0.FieldByName( 'Kursart' ).AsString ) or AnsiStartsText( 'WP1', fC0.FieldByName( 'Kursart' ).AsString ) then
          begin
            if idf <> '' then
              idf := idf + ';';
            idf := idf + FieldByName( 'ID' ).AsString;
          end;
          Next;
        end;
      end;
      if idf <> '' then
        Uebertragen( fC0, fC1, idf )
      else
      begin
        Meldung( 'WP1 fehlt' );
        fZuWenigFaecher := true;
      end;
    end else if FSchulgliederung = 'GY' then
    begin
      Uebertragen( fC0, fC1, FeldWertIDs( fC0, 'Fachgruppe', 'FS', 0 ) );
    end;

    if FZuWenigFaecher then
      exit;

  // C1 enthält nun D/M/E, ggf. WP1, C0 alle anderen Fächer


  // Die folgenden 3 Teilalgorithmen sind gleich;sie unterscheiden sich je nach Schulform nur durch die Inhalte der Fachgruppen!

  // Auf 6 in C1 prüfen (ganz oben in Folie)
    idf := NoteVorhanden( fC1, 'Note', '=', 6, -1 );
    if idf <> '' then
    begin		// 6 vorhanden
      for i := 1 to NumToken( idf, ';' ) do
        StrAdd( SchreibeFachNote( fC1, StrToInt( GetToken( idf, ';', i ) ) ), msg );
      VersetzungsMeldung( 'Keine Fachoberschulreife:', msg );
      exit;
    end;

  // Auf 5 in C1 prüfen (in Folie links unter "6")
    idf := NoteVorhanden( fC1, 'Note', '=', 5, -1 );
    if idf <> '' then
    begin	// 5 in D/M/E vorhanden
      for i := 1 to NumToken( idf, ';' ) do
        StrAdd( SchreibeFachNote( fC1, StrToInt( GetToken( idf, ';', i ) ) ), msg );
      if NumToken( idf, ';' ) > 1 then
      begin		// zwei oder mehr 5 (Verzweigung nach rechts in Folie)
        VersetzungsMeldung( 'Keine Fachoberschulreife:', msg );
        exit;
      end else
      begin		// eine 5, gibt es in fC1 Noten besser als 4?
        idf1 := NoteVorhanden( fC1, 'Note', '<', 4, -1 );
        if NumToken( idf1, ';' ) = 0 then
        begin		// Keine Noten besser als 4 gefunden
          msg := msg + 'Kein Ausgleichsfach in den Hauptfächern gefunden';
          VersetzungsMeldung( 'Keine Fachoberschulreife:', msg );
          exit;
        end else
        begin		// Noten besser 4 gefunden, gibt es in fC0 Noten schlechter als 4
          idf := NoteVorhanden( fC0, 'Note', '>', 4, -1 );
          if NumToken( idf, ';' ) > 1 then
          begin
            for i := 1 to NumToken( idf, ';' ) do
              StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf, ';', i ) ) ), msg );
            VersetzungsMeldung( 'Keine Fachoberschulreife:', msg );
            exit;
          end;
        end;
      end;
    end else
    begin		// keine 5 in D/M/E, prüfe weitere Fächer (linker Teil der Folie)
      idf := NoteVorhanden( fC0, 'Note', '>', 4, -1 );  // Gibt es Fächer schlechter als 4?
      if idf <> '' then
      begin		// es gibt Noten Schlechter als 4
        for i := 1 to NumToken( idf, ';' ) do
          StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf, ';', i ) ) ), msg );
        if NumToken( idf, ';' ) > 2 then
        begin		//	mehr als 2 Fächer in C0 schlechter als 4
          VersetzungsMeldung( 'Keine Fachoberschulreife:', msg );
          exit;
        end else if NumToken( idf, ';' ) > 1 then
        begin		// >1 Fach (d.h. 2 Fächer) schlechter als 4
          idf := NoteVorhanden( fC0, 'Note', '=', 6, -1 );	// Prüfen, ob 6 vorkommt
          if NumToken( idf, ';' ) > 1 then
          begin //mehr als eine 6 in C0
            VersetzungsMeldung( 'Keine Fachoberschulreife:', msg );
            exit;
          end;
  // Wenn wir hier ankommen, gibt es keine oder eine 6
    //Ausgleichsfächer prüfen
          idf := NoteVorhanden( fC0, 'Note', '<', 4, -1 );  // in den Hauptfächern eine Note besser als 4
          if NumToken( idf, ';' ) = 0 then
          begin // keine Note besser als 4 in den Hauptfächern oder Nebenfächern
            msg := msg + 'Kein Ausgleichsfach in den Nebenfächern gefunden';
            VersetzungsMeldung( 'Keine Fachoberschulreife:', msg );
            exit;
          end else
          begin// Ausgleichsfächer gefunden
            if idf1 <> '' then
              AusgleichsfachAusgeben( idf, fC1, msg );
            if idf <> '' then
              AusgleichsfachAusgeben( idf, fC0, msg );
          end;
        end;
      end;
    end;
  	Result := 'A';
   	Meldung( 'Fachoberschulreife erreicht!' );
  end;

end;



function TAllgPruefungsAlgorithmus.Pruefe_APO_SI05_FORQ_Abschluss: string;
const
	MsgNeg = 'Keine Berechtigung zum Besuch der gymnasialen Oberstufe: ';
	MsgPos = 'Berechtigung zum Besuch der gymnasialen Oberstufe erreicht!';
var
	msg, idf, idfa, idfa1: string;
	i : integer;
	ausgl: boolean;
	ncnt: integer;
	ok : boolean;

	function _1_2_3( mincnt: integer ): boolean;
	var
		nausgl, i: integer;
	begin
		Result := false;

		idf := NoteVorhanden( fC0, 'Note', '=', 6, -1 );  //
		if idf <> '' then
		begin   // mind. eine 6 vorhanden
			for i := 1 to NumToken( idf, ';' ) do
				StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf, ';', i ) ) ), msg );
			VersetzungsMeldung( MsgNeg, msg );
			exit;
		end;

		case mincnt of
		1 : 		// eine Note schlechter als 3
			begin
				idf := NoteVorhanden( fC0, 'Note', '<', 3, -1 ); // Noten besser als 3 in C0
				idfa := NoteVorhanden( fC1, 'Note', '<', 3, -1 ); // Noten besser als 3 in C1
				idf := VereinigungsMenge( idf, idfa );
				if idf = '' then // Keine Note besser als 3
				begin
					StrAdd( 'Kein Fach besser als 3 gefunden', msg );
					exit;
				end;
			end;
		2 : 		// 2 Noten schlechter als 3
			begin
				idf := NoteVorhanden( fC0, 'Note', '>=', 5, -1 );  // Noten 5 oder schlechter?
				if NumToken( idf, ';' ) > 1 then
				begin
					for i := 1 to NumToken( idf, ';' ) do
						StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf, ';', i ) ) ), msg );
					VersetzungsMeldung( MsgNeg, msg );
					exit;
				end;
				idf := NoteVorhanden( fC0, 'Note', '<', 3, -1 ); // Noten besser als 3 in C0
				idfa := NoteVorhanden( fC1, 'Note', '<', 3, -1 ); // Noten besser als 3 in C1
				idf := VereinigungsMenge( idf, idfa );
				if NumToken( idf , ';' ) < 2 then
				begin
					StrAdd( 'Keine zwei Fächer besser als 3 gefunden', msg );
					exit;
				end;
			end;
		3 : 		// 3 Noten schlechter als 3
			begin
				idf := NoteVorhanden( fC0, 'Note', '>=', 5, -1 );  // Noten 5 oder schlechter?
				if NumToken( idf, ';' ) > 1 then
				begin
					for i := 1 to NumToken( idf, ';' ) do
						StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf, ';', i ) ) ), msg );
					VersetzungsMeldung( MsgNeg, msg );
					exit;
				end;
				idf := NoteVorhanden( fC0, 'Note', '<', 3, -1 ); // Noten besser als 3 in C0
				idfa := NoteVorhanden( fC1, 'Note', '<', 3, -1 ); // Noten besser als 3 in C1
				idf := VereinigungsMenge( idf, idfa );
				if NumToken( idf , ';' ) < 3 then
				begin
					StrAdd( 'Keine drei Fächer besser als 3 gefunden', msg );
					exit;
				end;
			end;
		end;
		Result := true; // bis hier gekommen? also ok
	end;

var
  idHF: string;
  idEK_3: string;
  idEK_ges, idGK, idWPI, idTmp: string;
  erfolg: boolean;
  anz3: integer;
begin
	Result := 'N';
	msg := '';


  if FSchulform = 'GE' then
  begin
    Result := Pruefe_APO_SI05_FOR_Abschluss_GE( 'FORQ' );
    if Result = 'A' then
    begin
      if IstPrognose then
       	Meldung( 'Prognose: Berechtigung zum Besuch der gymnasialen Oberstufe' )
      else
       	Meldung( 'Berechtigung zum Besuch der gymnasialen Oberstufe erreicht!' );
    end;
  end else
  begin // bei allen Schulformen außer GE obligatorisch
// Deutsch prüfen
    idHF := HauptfachID( fC0, 'Fach', 'D' );
    if idHF = '' then
    begin
      Meldung( 'Deutsch fehlt' );
      fZuWenigFaecher := true;
    end else
      Uebertragen( fC0, fC1, idHF );

  // Mathe prüfen
    idHF := HauptfachID( fC0, 'Fach', 'M' );
    if idHF = '' then
    begin
      Meldung( 'Mathematik fehlt' );
      fZuWenigFaecher := true;
    end else
      Uebertragen( fC0, fC1, idHF );

  // Englisch prüfen
    idHF := HauptfachID( fC0, 'Fach', 'E' );
    if idHF = '' then
    begin
      Meldung( 'Englisch fehlt' );
      fZuWenigFaecher := true;
    end else
      Uebertragen( fC0, fC1, idHF );

    if ( FSchulgliederung = 'GE' ) then
    begin
  // WP1 in GE in fC1 setzen
      idf := '';
      with FC0 do
      begin
        First;
        while not Eof do
        begin
          if AnsiStartsText( 'WPI', fC0.FieldByName( 'Kursart' ).AsString ) or AnsiStartsText( 'WP1', fC0.FieldByName( 'Kursart' ).AsString ) then
          begin
            if idf <> '' then
              idf := idf + ';';
            idf := idf + FieldByName( 'ID' ).AsString;
          end;
          Next;
        end;
      end;
      if idf <> '' then
        Uebertragen( fC0, fC1, idf )
      else
      begin
        Meldung( 'WP1 fehlt' );
        fZuWenigFaecher := true;
      end;
    end;

    if FZuWenigFaecher then
      exit;

  // C1 enthält nun die Hauptfächer, C0 alle anderen Fächer
  // Auf Noten schlechter als 3 in C1 prüfen
    idf := NoteVorhanden( fC1, 'Note', '>', 3, -1 );
    for i := 1 to NumToken( idf, ';' ) do
      StrAdd( SchreibeFachNote( fC1, StrToInt( GetToken( idf, ';', i ) ) ), msg );
    if NumToken( idf , ';' ) > 1 then
    begin // mehr als eine Note > 3
      VersetzungsMeldung( MsgNeg, msg );
      exit;
    end else if NumToken( idf, ';' ) = 1 then
    begin // eine Note schlechter als 3
      idf := NoteVorhanden( fC1, 'Note', '>', 4, -1 );  // Noten schlechter als 4
      if idf <> '' then
      begin   // Noten schlechter als 4 vorhanden
        VersetzungsMeldung( MsgNeg, msg );
        exit;
      end else
      begin   // Keine Note Schlechter als 4, Suche Ausgleich
        idfa := BesteNoteID( fC1, '', '', -1 );
        ausgl := ( idfa <> '' ) and ( fBesteNote < 3 );
        if not ausgl then
        begin
          msg := msg + 'Kein Ausgleichsfach unter den Kernfächern gefunden';
          VersetzungsMeldung( MsgNeg, msg );
          exit;
        end;
        AusgleichsfachAusgeben( idfa, fC1, msg );
      end;
    end;

  // Haupfächer erledigt, nun Nebenfächer
    idf := NoteVorhanden( fC0, 'Note', '>', 3, -1 );
    ncnt := NumToken( idf, ';' );
    if ncnt >= 1 then
    begin   // 2 oder mehr Noten schlechter als 3 gefunden
      ok := false;
      for i := 1 to ncnt do
        StrAdd( SchreibeFachNote( fC0, StrToInt( GetToken( idf, ';', i ) ) ), msg );
      if ncnt <= 3 then
        ok := _1_2_3( ncnt );
      if not ok then
      begin
        VersetzungsMeldung( MsgNeg, msg );
        exit;
      end;
    end;
  	Result := 'A';
 	  Meldung( MsgPos );
  end;

end;

procedure TAllgPruefungsAlgorithmus.Fremdsprache_1_2( dsvon, dsnach: TDataset );
var
	jg1, jg2: byte;
begin
	jg1 := 20;
	jg2 := 20;
	with dsvon do
	begin
		First;
		while not EOF do
		begin
      if ( FieldByname( 'Fachgruppe' ).AsString = 'FS' ) and ( FieldByname( 'BeginnJahrgang' ).AsInteger > 0 ) then
      begin
				if FieldByname( 'BeginnJahrgang' ).AsInteger < jg1 then
					jg1 := FieldByname( 'BeginnJahrgang' ).AsInteger
				else if FieldByname( 'BeginnJahrgang' ).AsInteger < jg2 then
					jg2 := FieldByname( 'BeginnJahrgang' ).AsInteger;
			end;
			Next;
		end;
	end;

	if ( jg1 = 20 ) or ( jg2 = 20 ) then
		exit;   // keine Behandlung notwendig

	with dsvon do
	begin
		First;
		while not EOF do
    begin
      if ( FieldByname( 'Fachgruppe' ).AsString = 'FS' ) and ( FieldByname( 'BeginnJahrgang' ).AsInteger > 0 ) then
				if FieldByname( 'BeginnJahrgang' ).AsInteger > jg2 then
          Uebertragen( dsvon, dsnach, FieldByname( 'ID' ).AsString );   // 3. Fremdspache oder mehr
      Next;
    end;
  end;
end;


procedure TAllgPruefungsAlgorithmus.NichtGemahnte5Ersetzen;

  procedure Fuellen( ds: TDataset; slN: TStringList );
  begin
    with ds do
    begin // Enthält die "Nebenfächer"
      First;
      while not Eof do
      begin
        if FieldByName( 'Note' ).AsFloat >= 5 then
        begin  // "Kritische" Noten
//          if FieldByName( 'Gemahnt' ).AsString = '-' then
          slN.Add( Format( '%d;%s;%d;%s', [ FieldByName( 'Note' ).AsInteger, FieldByName( 'Fach' ).AsString, FieldByname( 'Fach_ID' ).AsInteger, FieldByName( 'Gemahnt' ).AsString ] ) );
        end;
        Next;
      end;
      First;
    end;
    slN.Sort;
  end;

  procedure AusgleichSuchen( ds: TDataset; slN: TStringList );
  var
    i, ix: integer;
    idign: integer;
    idfa: string;
    del_lst: string;
    gemahnt: boolean;
    anote: integer;
  begin
    for i := slN.Count - 1 downto 0 do
    begin // Schlechteste Noten stehen am Schluss!
      anote := StrToInt( GetToken( slN[i], ';', 1 ) );
      if anote = 5 then
      begin
        idign := StrToInt( GetToken( slN[i], ';', 3 ) );
        idfa := BesteNoteID( fC1, '', '', idign );
        gemahnt := GetToken( slN[i], ';', 4 ) = '+';
        if ( ( idfa <> '' ) and ( fBesteNote < 4 ) ) or gemahnt then
        begin // Ausgleich gefunden oder gemahnt
          if del_lst <> '' then
            del_lst := del_lst + ';';
          del_lst := del_lst + IntToStr( i );
        end;
      end;
    end;
    for i := 1 to NumToken( del_lst, ';' ) do
    begin
      ix := StrToInt( GetToken( del_lst, ';', i ) );
      slN.Delete( ix );
    end;
  end;

  procedure InfoAusgeben( ds: TDataset );
  begin
    if fNachprFaecherErmitteln then
      exit;
    FInfoNichtGemahnt := Format( 'Die nicht ausreichende Leistung im Fach "%s" wurde nicht berücksichtigt, da die Minderleistung nicht gemahnt wurde.', [ ds.FieldByName( 'Fachname' ).AsString ] );
  end;

  function Anzahl( slN: TStringList; const note, mahnung: string ): integer;
  var
    i, j: integer;
    anot, amahn: string;
  begin
    Result := 0;
    for i := 0 to slN.Count - 1 do
    begin
      anot := GetToken( slN[i], ';', 1 );
      amahn := GetToken( slN[i], ';', 4 );
      for j := 1 to length( note ) do
      begin
        if mahnung <> '' then
        begin
          if ( anot = note[j] ) and ( amahn = mahnung ) then
            inc( Result );
        end else
        begin
          if ( anot = note[j] ) then
            inc( Result );
        end;
      end;
    end;
  end;

  function FachIDFinden( slN: TStringList; const note, mahnung: string ): integer;
  var
    i, j: integer;
    anot, amahn: string;
  begin
    Result := 0;
    for i := slN.Count - 1 downto 0 do
    begin
      anot := GetToken( slN[i], ';', 1 );
      amahn := GetToken( slN[i], ';', 4 );
      for j := 1 to length( note ) do
      begin
        if ( anot = note[j] ) and ( amahn = mahnung ) then
        begin
          Result := StrToInt( GetToken( slN[i], ';', 3 ) );
          exit;
        end;
      end;
    end;

  end;

var
  slFG1, slFG2: TStringList;
  id: integer;
  sl: string;
  gruppe: integer;
begin
  if fNachprFaecherErmitteln or FVolljaehrig then
    exit;

  FInfoNichtGemahnt := '';
  slFG1 := TStringList.Create;
  slFG2 := TStringList.Create;
  try
    Fuellen( fC1, slFG1 ); // Die Hauptfächer
    Fuellen( fC0, slFG2 ); // Die "Nebnfächer"
    if ( slFG1.Count = 0 ) and ( slFG2.Count = 0 ) then
      exit;
//    AusgleichSuchen( fC1, slFG1 );
//    AusgleichSuchen( fC0, slFG2 );
    id := 0;
// Wenn nur ein nicht gemahntes Defizit, dann dieses Streichne
    if Anzahl( slFG1, '56', '-' ) +  Anzahl( slFG2, '56', '-' ) <= 1 then
    begin
      id := FachIDFinden( slFG1, '56', '-' );
      gruppe := 1;
      if id = 0 then
      begin
        id := FachIDFinden( slFG2, '56', '-' );
        gruppe := 2;
      end;
// Falls eine ungemahnte 6 in FG1 existiert, ist diese Strichkandidat
    end else if Anzahl( slFG1, '6', '-' ) >= 1 then  // Ungemahnte 6 in FG1
    begin
      id := FachIDFinden( slFG1, '6', '-' );
      gruppe := 1;
//Wenn zwei oder mehr ungemahnte 6 in FG2, dann eine streichen
    end else if ( Anzahl( slFG2, '6', '-' ) >= 2 )  then
    begin
      id := FachIDFinden( slFG2, '6', '-' );
      gruppe := 2;
// Wenn zwei 5 in FG1 und davon eine ungemahnt, dann diese streichen
    end else if ( Anzahl( slFG1, '5', '-' ) >= 2 ) then
    begin
      id := FachIDFinden( slFG1, '5', '-' );
      gruppe := 1;
// Wenn drei oder mehr 5 in FG2 davon eine streichen
    end else if ( Anzahl( slFG2, '5', '-' ) >= 3 ) then
    begin
      id := FachIDFinden( slFG2, '5', '-' );
      gruppe := 2;
// Wenn mehr als eine 5 in FG1, eine davon streichen
    end else if ( Anzahl( slFG1, '5', '-' ) >= 1) then
    begin
      id := FachIDFinden( slFG1, '5', '-' );
      gruppe := 1;
    end else if ( Anzahl( slFG2, '5', '-' ) >= 1) then
    begin
// Wenn mehr als eine 5 in FG2, eine davon streichen
      id := FachIDFinden( slFG2, '5', '-' );
      gruppe := 2;
    end;

    if id > 0 then
    begin
      if gruppe = 1 then
      begin
        FC1.Locate( 'Fach_ID', id, [] );
        FC1.Edit;
        FC1.FieldByname( 'Note' ).AsInteger := 4;
        FC1.Post;
        InfoAusgeben( FC1 );
      end else
      begin
        FC0.Locate( 'Fach_ID', id, [] );
        FC0.Edit;
        FC0.FieldByname( 'Note' ).AsInteger := 4;
        FC0.Post;
        InfoAusgeben( FC0 );
      end;
      FCS.Locate( 'Fach_ID', id, [] );
      FCS.Edit;
      FCS.FieldByname( 'Note' ).AsInteger := 4;
      FCS.Post;

    end;

  finally
    FreeAndNil( slFG1 );
    FreeAndNil( slFG2 );
  end;
end;

procedure TAllgPruefungsAlgorithmus.ZuWenigKurse( txt: string );
begin
	Meldung( '§8(1) Satz 2: Zu wenig Kurse (' + txt + ')' );
	Meldung( 'Belegprüfungsfehler!' );
end;

function TAllgPruefungsAlgorithmus.FSF_Pruefen( const fach_ids: string; const Note: double ): string;
var
	ids, idf1, idf2: string;
	i : integer;
begin
	Result := '';
	ids := fach_ids;		// die ID's der in Frage kommenden Datensätze
	with fC0 do
	begin
		for i := 1 to NumToken( ids, ';' ) do
		begin
			Locate('ID', StrToInt( GetToken( ids, ';', i ) ), [] );	// den einzelnen Datensatz finden
			if FieldByName( 'UnterichtsSprache').AsString <> 'D' then
			begin		// Fach wird in einer Fremdsprache unterichtet
				if Result <> '' then
					Result := Result + ';';
				Result := Result + GetToken( ids, ';', i ) ;
				idf1 := FeldWertIDs( fC1, 'Fach', FieldByName( 'UnterichtsSprache' ).AsString, 1 );		// die ID's der Fremdspracahen in C1
				idf2 := FeldWertIDs( fC2, 'Fach', FieldByName( 'UnterichtsSprache' ).AsString, 1 );		// die ID's der Fremdspracahen in C2
				if Note < 0 then	// keine Berücksichtigung der Note
					fFSF := ( idf1 = '' ) and ( idf2 = '' );		// Unterichtssprache nicht als Sprachfach vorhanden
			end;
		end;
	end;
end;

end.




Guten Morgen zusammen,

erstmal danke für die Antworten. Die Lernbereichsnoten sind uznd waren eingetragen (beide 3),
daran kann es nicht liegen. Ich kann hier noch einen weiteren Fall schildern:

HA-10-Problem

D-G      4
E-E       5
M-G      5
Ch-G     4
WPI-F6  5
BI         3
EK        4-
GE        4
AW       3
SP        5
Eth       3


D-E       4
E-G       3-
M-E       5
Ch-G     5
WPI-F6  5
BI         4-
EK        5
GE        4-
AW       4-
SP        4-
Eth       3-
LB AL     4
LB NW   4

=============================================================================

Zusammenfassung:            Prognosefehler GE
Beschreibung:
falsche
Berechnung bei folgendem Notenbild aufgefallen:

D-E 1;
E-E 1;
M-E 1;
CH-E 4;
WP 1;
BI 4;
PH 4;
GL 1;
AW 1;
ER 1
KU 1
SP 1

Ergebnis:
Prüfungsordnung: FORQ-E: .....
Keine Fachoberschulreife:
Defizit(e) ohne Ausgleichsmöglichkeit in Fächergruppe II gefunden

-----------------------------------

Bei einer Verschlechterung des Notenbildes dann jedoch eine richtig e Prognose:

D-E 1; E-E 1; M-E 1; CH-E
4
; WP 1; BI
5
; PH
4
; GL 1; AW 1; ER; 1 KU 1 SP 1

Prüfungsordnung: FORQ-E: ...
Defizit(e) in Fachgruppe II, Ausgleich gefunden
Prognose: Berechtigung zum Besuch der gymnasialen Oberstufe

------------------------

Bei weiteren Verschlechterungen des Notenbildes ebenfalls richtig e Prognosen, z.B.:

D-E 2; E-E 3; M-E
4
; CH-E
4
; WP 3; BI
5
; PH
4
; GL 2; AW 2; ER; 2 KU 3 SP 3

Prüfungsordnung: FORQ-E:.....
Defizit(e) in Fachgruppe I, Ausgleich gefunden
Defizit(e) in Fachgruppe II, Ausgleich gefunden
Prognose: Berechtigung zum Besuch der gymnasialen Oberstufe

