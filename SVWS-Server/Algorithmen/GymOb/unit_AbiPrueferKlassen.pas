unit unit_AbiPrueferKlassen;

interface

uses
  Classes,
  MemTableDataEh,
  MemTableEh;

type
  TFachRec = record
    Nr: integer;
    Fach_ID: integer;
    FachBez: string;
    BesterAbschnitt1: integer;
    BesterAbschnitt2: integer;
    Punkte: array[1..4] of integer;
    Punktsumme: integer;
    Defizite: integer;
  end;

  TFachArray = array of TFachRec;

  TFachHolder = class( TObject )
    private
      FMemD: TMemTableEh;
      FFachArray: TFachArray;
      FRecords: integer;
      FMindestBelegung: integer;
      FAbschnittskombination: integer;
      FAbschnitt1, FAbschnitt2: integer;
      FBestesFach_ID: integer;
    public
      property AbschnittsKombination: integer read FAbschnittsKombination write FAbschnittskombination;
      property MindestBelegung: integer read FMindestBelegung write FMindestBelegung;
      procedure Hinzufuegen( const fach_krz, stat_krz: string;
                             const f_id, p_q1, p_q2, p_q3, p_q4, gewicht: integer );
      procedure Reset;
      constructor Create;
      destructor Destroy;
      procedure Free;
      function SucheBestesFach( const AnzahlAbschnitte: integer ): boolean;
      property Abschnitt1: integer read FAbschnitt1;
      property Abschnitt2: integer read FAbschnitt2;
      property BestesFach_ID: integer read FBestesFach_ID;
    end;

  TAbiErgebnisVerwalter = class( TObject )
    private
      FDaten: TMemTableEh;
      FFachAbschnitte: TMemTableEh;
      FFachAbschnitteEbenen: TMemTableEh;
      FRootNode_ID: integer;
      FRecords: integer;
      FSpezial_IDs: TStringList;
      FPruefOrdnung: string;
      FDurchlauf: integer;
      procedure FachAbschnittLoeschen( const fach_id, abschnitt, punkte, ebene: integer );
      procedure DatenKopieren( src, dst: TMemTableEh );
      function GetMarkierteKurse: integer;
      function GetWurzelKnoten: integer;
      function FachAbschnittEbeneVorhanden( const fach_id, abschnitt, ebene: integer ): boolean;
    public
      constructor Create;
      destructor Destroy;
      procedure Free;
      procedure Reset;
      property WurzelKnoten: integer read GetWurzelKnoten;
      procedure Save( strLst: TStringList );
      procedure WurzelKnotenErzeugen( const pkt_sum, defizite, anzahl_markiert: integer );
      procedure FachAbschnittHinzu( const fach_id, abschnitt, punkte: integer );
      procedure FachAbschnitteLeeren;
      procedure FachAbschnitteSortieren;
      procedure FachAbschnitteFachLoeschen( const fach_id: integer );
      function KursBesserDurchschnittPruefen( const D: double; const MuRest, VILI, VPIP: integer ): boolean;

      function NeuenKnotenErzeugen( const fach, bemerkung: string;
                                     const knotenebene, root_node_id, fach_id, p_q1, p_q2, p_q3, p_q4: integer;
                                     markier_muster: string ): integer;
      function FachAbschnittVorhanden( const fach_id, abschnitt: integer ): boolean;
      procedure ZwischenstandSpeichern;
      procedure ZwischenstandWiederherstellen;
      property AnzahlMarkierteKurse: integer read GetMarkierteKurse;
      procedure RestArbeitenVorbereiten( const VPIP, knotenebene: integer );
      function OberstenEintragAusRestelisteHolen( var fach_id, abschnitt, punkte: integer ): boolean;overload;
      function OberstenEintragAusRestelisteHolen( const fach_ids: string; var fach_id, abschnitt, punkte: integer ): boolean;overload;
      function NaechstenEintragAusRestelisteHolen( var fach_id, abschnitt, punkte: integer ): boolean;
      procedure OberstenEintragAusRestelisteLoeschen;overload;
      procedure OberstenEintragAusRestelisteLoeschen( const fach_id, abschnitt, knotenebene: integer );overload;
      property Zeilen: integer read FRecords;
      property Spezial_IDs: TStringList read FSpezial_IDs;
      function Durchschnitt: double;
      function AnzahlMarkiert_Total: integer;
      function Punktsumme_Total: double;
      function DefizitSumme: integer;
      procedure EinzelErgebnisBerechnen;
      function BestesErgebnisSuchen( var rootnode_id, fach_id: integer; var markierung: string ): integer;
      procedure NaechstHoehereEbene( const node_id: integer; var rootnode_id, fach_id: integer; var markierung: string );
      function RestelisteBelegt: boolean;
      function RestelisteAnzahl: integer;
      property PruefungsOrdnung: string read FPruefOrdnung write FPruefOrdnung;
      procedure KnotenebeneWiederherstellen( const ebene: integer;
                                             const f1_id: integer = 0;
                                             const f1_bel: string = '----';
                                             const f2_id: integer = 0;
                                             const f2_bel: string = '----' );
      procedure RestfaecherAusgeben( const fn: string );
      function AnzahlW1_6: integer;
      procedure W1_6Loeschen( const knotenebene: integer );
      procedure ProjektkurseLoeschen( const knotenebene: integer );
      function AnzahlMarkierungenFuerFach( const statkrz: string ): integer;
      property Durchlauf: integer read FDurchlauf write FDurchlauf;
    end;


implementation

uses
  unit_SchildConst,
  unit_mengen,
  RBKMath,
  Variants,
  Sysutils,
  db;

const
  C_DEFIZIT_GRENZE = 5;

constructor TFachHolder.Create;
begin
  inherited;
  FMindestBelegung := 0;
  FAbschnittskombination := 0;
  FMemD := TMemTableEh.Create( nil );
	with FMemD.FieldDefs do
	begin
		Clear;
    Add( 'Nr', ftInteger, 0, false );
    Add( 'F1_Fach_ID', ftInteger, 0, false );
    Add( 'F1_FachKrz', ftString, 20, false );
    Add( 'F1_StatistikKrz', ftString, 2, false );
    Add( 'F1_BesterAbschnitt1', ftSmallInt, 0, false );
    Add( 'F1_BesterAbschnitt2', ftSmallInt, 0, false );
    Add( 'F1_Punkte_3', ftSmallInt, 0, false );
    Add( 'F1_Punkte_4', ftSmallInt, 0, false );
    Add( 'F1_Punkte_5', ftSmallInt, 0, false );
    Add( 'F1_Punkte_6', ftSmallInt, 0, false );
    Add( 'F1_Punktsumme', ftSmallInt, 0, false ); // Gesamte Punktsumme
    Add( 'F1_Punktsumme2', ftSmallInt, 0, false ); // Punktsumme der 2 besten Kurse
    Add( 'F1_Defizite', ftSmallInt, 0, false );
    Add( 'F1_Gewicht', ftSmallint, 0, false );
    Add( 'F2_Fach_ID', ftInteger, 0, false );
    Add( 'F2_FachKrz', ftString, 20, false );
    Add( 'F2_StatistikKrz', ftString, 2, false );
    Add( 'F2_Punkte_5', ftSmallInt, 0, false );
    Add( 'F2_Punkte_6', ftSmallInt, 0, false );
//    Add( 'Sortierung', ftSmallInt, 0, false ); // Sortierung unter Berücksichtigung aller Kurse
//    Add( 'Sortierung2', ftSmallInt, 0, false ); // Sortierung unter Berücksichtigung der 2 besten Kurse
  end;
  FMemD.CreateDataset;
  FMemD.Open;
  FRecords := 0;
end;

destructor TFachHolder.Destroy;
begin
  FreeAndNil( FMemD );
  inherited;
end;

procedure TFachHolder.Free;
begin
  if self <> nil then
    Destroy;
end;

procedure TFachHolder.Hinzufuegen( const fach_krz, stat_krz: string;
                                   const f_id, p_q1, p_q2, p_q3, p_q4, gewicht: integer );
var
  ix, i, pmx1, pmx2: integer;
  def, pkt_sum, ba_1, ba_2, pkt: integer;
  npkt: integer;
begin
  npkt := 0;
  if p_q1 > 0 then
    inc( npkt );
  if p_q2 > 0 then
    inc( npkt );
  if p_q3 > 0 then
    inc( npkt );
  if p_q4 > 0 then
    inc( npkt );
  if npkt < FMindestBelegung then
    exit;

  with FMemD do
  begin
    if not Locate( 'Fach_ID', f_id, [] ) then
    begin
      Insert;
      inc( FRecords );
      FieldByName( 'Nr' ).AsInteger := FRecords;
      FieldByName( 'F1_Fach_ID' ).AsInteger := f_id;
      FieldByname( 'F1_FachKrz' ).AsString := fach_krz;
      FieldByname( 'F1_StatistikKrz' ).AsString := AnsiUppercase( stat_krz );
    end else
      Edit;

    FieldByName( 'F1_Punkte_3' ).AsInteger := p_q1;
    FieldByName( 'F1_Punkte_4' ).AsInteger := p_q2;
    FieldByName( 'F1_Punkte_5' ).AsInteger := p_q3;
    FieldByName( 'F1_Punkte_6' ).AsInteger := p_q4;
    pmx1 := 0;
    pmx2 := 0;
    def := 0;
    pkt_sum := 0;
    ba_1 := 0;
    ba_2 := 0;

    for i := C_Q1 to C_Q4 do
    begin
      pkt := FieldByName( Format( 'F1_Punkte_%d', [ i ] ) ).AsInteger;
      if pkt >= 0 then
      begin
        pkt_sum := pkt_sum + pkt;
        if pkt < C_DEFIZIT_GRENZE then
          inc( def );
        if pkt > pmx1 then
        begin
          pmx1 := pkt;
          ba_1 := i;
        end;
        if ( pkt > pmx2 ) and ( i <> ba_1 ) then
        begin
          pmx2 := pkt;
          ba_2 := i;
        end;
      end;
    end;
    FieldByName( 'F1_BesterAbschnitt1' ).AsInteger := ba_1;
    FieldByName( 'F1_BesterAbschnitt2' ).AsInteger := ba_2;
    FieldByName( 'F1_Punktsumme' ).AsInteger := pkt_sum;
    FieldByName( 'F1_Punktsumme2' ).AsInteger := 0;
    if FAbschnittsKombination = 0 then
    begin
      if ( ba_1 > 0 ) and ( ba_2 > 0 ) then
        FieldByName( 'F1_Punktsumme2' ).AsInteger := FieldByName( Format( 'F1_Punkte_%d', [ ba_1 ] ) ).AsInteger +
                                                  FieldByName( Format( 'F1_Punkte_%d', [ ba_2 ] ) ).AsInteger
    end else
    begin
      case FAbschnittsKombination of
      56 : FieldByName( 'F1_Punktsumme2' ).AsInteger := FieldByName( 'F1_Punkte_5' ).AsInteger +
                                                     FieldByName( 'F1_Punkte_6' ).AsInteger;
      end;
    end;
    FieldByName( 'F1_Defizite' ).AsInteger := -def; // damit die absteigende Sortierung funktioniert
    if gewicht > 0 then
      FieldByname( 'F1_Gewicht' ).AsInteger := gewicht
    else
      FieldByname( 'F1_Gewicht' ).AsInteger := 1;
    Post;
  end;

end;

function TFachHolder.SucheBestesFach( const AnzahlAbschnitte: integer ): boolean;
begin
  Result := FRecords > 0;
  if not Result then
    exit;

  with FMemD do
  begin
// Für koorekte Sortierung sorgen
    if FRecords > 1 then
    begin
      case AnzahlAbschnitte of
      2 : SortByFields( 'F1_Punktsumme2 DESC,F1_Defizite DESC,F1_Gewicht DESC' );
      4 : SortByFields( 'F1_Punktsumme DESC,F1_Defizite DESC,F1_Gewicht DESC' );
      end;
    end;
    First;
    FBestesFach_ID := FieldByName( 'F1_Fach_ID' ).AsInteger;
    if AnzahlAbschnitte = 4 then
      exit;
// Wenn nur 2 Abschnitte betroffen:
    case FAbschnittsKombination of
    0 :
      begin
        FAbschnitt1 := FieldByName( 'F1_BesterAbschnitt1' ).AsInteger;
        FAbschnitt2 := FieldByName( 'F1_BesterAbschnitt2' ).AsInteger;
      end;
    56 :
      begin
        FAbschnitt1 := 5;
        FAbschnitt2 := 6;
      end;
    end;
  end;
end;

procedure TFachHolder.Reset;
begin
  FMemD.EmptyTable;
  FRecords := 0;
end;



constructor TAbiErgebnisVerwalter.Create;
begin
  inherited;
  FSpezial_IDs := TStringList.Create;
  FDaten := TMemTableEh.Create( nil );
  with FDaten.FieldDefs do
  begin
    Add( 'Durchlauf', ftInteger, 0, false );
    Add( 'Node_ID', ftInteger, 0, false );
    Add( 'RootNode_ID', ftInteger, 0, false );
    Add( 'Knotenebene', ftSmallInt, 0, false );
    Add( 'Bemerkung', ftString, 50 );
    Add( 'Fach', ftString, 2, false );
    Add( 'Fach_ID', ftInteger, 0, false );
    Add( 'Markierung', ftString, 4, false );
    Add( 'Punktsumme_Markiert', ftSmallInt, 0, false );
    Add( 'Defizite', ftSmallInt, 0, false );
    Add( 'Punktsumme_Markiert_Total', ftFloat, 0, false );
    Add( 'Defizite_Total', ftSmallInt, 0, false );
    Add( 'AnzMarkiert_Total', ftSmallInt, 0, false );
    Add( 'Ergebnis', ftFloat, 0, false );
  end;
  FDaten.CreateDataset;
  FDaten.Open;
  FFachAbschnitte := TMemTableEh.Create( nil );
	with FFachAbschnitte.FieldDefs do
	begin
		Clear;
    Add( 'Fach_ID', ftInteger, 0, false );
    Add( 'Abschnitt', ftSmallInt, 0, false );
    Add( 'Punkte', ftSmallInt, 0, false );
    Add( 'Wichtung', ftSmallInt, 0, false ); // alle erhalten 3, LI=2, IP/VP=1, damit bei gleichen Noten Mu vor LI vor IP/VP
  end;
  FFachAbschnitte.CreateDataset;
  FFachAbschnitte.Open;

  FFachAbschnitteEbenen := TMemTableEh.Create( nil );
	with FFachAbschnitteEbenen.FieldDefs do
	begin
		Clear;
    Add( 'Fach_ID', ftInteger, 0, false );
    Add( 'Abschnitt', ftSmallInt, 0, false );
    Add( 'Knotenebene', ftSmallInt, 0, false );
    Add( 'Punkte', ftSmallInt, 0, false );
  end;
  FFachAbschnitteEbenen.CreateDataset;
  FFachAbschnitteEbenen.Open;

end;

destructor TAbiErgebnisVerwalter.Destroy;
begin
  FreeAndNil( FDaten );
  FreeAndNil( FFachAbschnitte );
  FreeAndNil( FSpezial_IDs );
  inherited;
end;

procedure TAbiErgebnisVerwalter.Free;
begin
  if self <> nil then
    Destroy;
end;

procedure TAbiErgebnisVerwalter.Reset;
begin
  FRecords := 0;
  FDaten.EmptyTable;
  FFachAbschnitte.EmptyTable;
  FFachAbschnitteEbenen.EmptyTable;
end;


procedure TAbiErgebnisVerwalter.FachAbschnittHinzu( const fach_id, abschnitt, punkte: integer );
begin

  with FFachAbschnitte do
  begin
    Append;
    FieldByName( 'Fach_ID' ).AsInteger := fach_id;
    FieldByName( 'Abschnitt' ).AsInteger := abschnitt;
    FieldByName( 'Punkte' ).AsInteger := punkte;
    FieldByName( 'Wichtung' ).AsInteger := 3;
    Post;
  end;

end;

procedure TAbiErgebnisVerwalter.FachAbschnitteLeeren;
begin
  FFachAbschnitte.EmptyTable;
end;

procedure TAbiErgebnisVerwalter.FachAbschnitteSortieren;
begin
  FFachAbschnitte.SortByFields( 'Punkte DESC' );
end;

procedure TAbiErgebnisVerwalter.FachAbschnitteFachLoeschen( const fach_id: integer );
begin
  with FFachAbschnitte do
  begin
    First;
    while not Eof do
    begin
      if FieldByName( 'Fach_ID' ).AsInteger = fach_id then
        Delete
      else
        Next;
    end;
    First;
  end;

	with FFachAbschnitteEbenen do
	begin
    First;
    while not Eof do
    begin
      if FieldByName( 'Fach_ID' ).AsInteger = fach_id then
        Delete
      else
        Next;
    end;
    First;
  end;

end;

procedure TAbiErgebnisVerwalter.WurzelKnotenErzeugen( const pkt_sum, defizite, anzahl_markiert: integer );
begin
  Reset;
  FRecords := 1;
  FDurchlauf := 1;
  with FDaten do
  begin
    if not Active then
      Open;
    Append;
    FieldByName( 'Node_ID' ).AsInteger := 0;
    FieldByName( 'RootNode_ID' ).AsInteger := -1;
    FieldByName( 'Knotenebene' ).AsInteger := 0;
    FieldByname( 'Bemerkung' ).AsString := 'Zwangsbelegung';
    FieldByName( 'Fach' ).AsString := 'ZB'; // Zwangsbelegung
    FieldByName( 'Fach_ID' ).AsInteger := 0;
    FieldByName( 'Markierung' ).AsString := '++++';
    FieldByName( 'Punktsumme_Markiert' ).AsInteger := pkt_sum;
    FieldByName( 'Defizite' ).AsInteger := defizite;
    FieldByName( 'Punktsumme_Markiert_Total' ).AsFloat := pkt_sum;
    FieldByName( 'Defizite_Total' ).AsInteger := -defizite;  // Defizite werden negativ gespeichert, damit hinterher die absteigende Sortierung leichter wird
    FieldByName( 'AnzMarkiert_Total' ).AsInteger := anzahl_markiert;
    FieldByName( 'Durchlauf' ).AsInteger := FDurchlauf;
    Post;
  end;
end;

{function TAbiErgebnisVerwalter.FachAbschnittVorhan( const fach_id, abschnitt: integer ): boolean;
begin
  with FFachAbschnitte do
  begin
    if ( FieldByname( 'Fach_ID' ).AsInteger <> fach_id ) or ( FieldByName( 'Abschnitt' ).AsInteger <> abschnitt ) then
      Result := Locate( 'Fach_ID;Abschnitt', VarArrayOf( [ fach_id, abschnitt ] ), [] )
    else
      Result := true;
  end;
end;}

function TAbiErgebnisVerwalter.FachAbschnittEbeneVorhanden( const fach_id, abschnitt, ebene: integer ): boolean;
begin
  with FFachAbschnitteEbenen do
  begin
    Result := ( FieldByName( 'Fach_ID' ).AsInteger = fach_id ) and
              ( FieldByName( 'Abschnitt' ).AsInteger = abschnitt ) and
              ( FieldByName( 'KnotenEbene' ).AsInteger = ebene );
    if Result then
      exit;
    First;
    while not Eof do
    begin
      Result := ( FieldByName( 'Fach_ID' ).AsInteger = fach_id ) and
                ( FieldByName( 'Abschnitt' ).AsInteger = abschnitt ) and
                ( FieldByName( 'KnotenEbene' ).AsInteger = ebene );
      if Result then
        exit;
      Next;
    end;
  end;
end;

procedure TAbiErgebnisVerwalter.FachAbschnittLoeschen( const fach_id,  abschnitt, punkte, ebene: integer );
var
  abschn: integer;
begin
  if FachAbschnittVorhanden( fach_id, abschnitt ) then
  begin
// Die Daten in die Sicherungstabelle übernehmen
    if fach_id = 15 then
      abschn := abschnitt
    else
      abschn := abschnitt;
    if not FachAbschnittEbeneVorhanden( fach_id, abschnitt, ebene ) then
    begin
      FFachAbschnitteEbenen.Append;
      FFachAbschnitteEbenen.FieldByName( 'Fach_ID' ).AsInteger := fach_id;
      FFachAbschnitteEbenen.FieldByName( 'Abschnitt' ).AsInteger := abschn;
      FFachAbschnitteEbenen.FieldByName( 'Punkte' ).AsInteger := punkte;
      FFachAbschnitteEbenen.FieldByName( 'KnotenEbene' ).AsInteger := ebene;
      FFachAbschnitteEbenen.Post;
    end;
    FFachAbschnitte.Delete;
  end;
end;

function TAbiErgebnisVerwalter.NeuenKnotenErzeugen( const fach, bemerkung: string;
                                           const knotenebene, root_node_id, fach_id, p_q1, p_q2, p_q3, p_q4: integer;
                                           markier_muster: string ): integer;
var
  tpkt_sum: double;
  pkt_sum: integer;
  tdef, def: integer;
  tanz, anz: integer;
begin
// fach ist Statistik-Kürzel
// Frage: Welche Defizite: Nur die der markierten oder aller Punkte?
// Antwort: Nur die der Markierten
  tpkt_sum := 0;
  tdef := 0;
  tanz := 0;
  Result := 0;
  if FRecords > 0 then
  begin
    FDaten.LOcate( 'Node_ID', root_node_id, [] );
    tpkt_sum := FDaten.FieldByName( 'Punktsumme_Markiert_Total' ).AsFloat;
    tdef := FDaten.FieldByName( 'Defizite_Total' ).AsInteger;
    tanz := FDaten.FieldByName( 'AnzMarkiert_Total' ).AsInteger;
  end;

  pkt_sum := 0;
  def := 0;
  anz := 0;

// Es muss hier jeweils geprüft werden, ob das Fach im jeweiligen Abschnitt nicht schon markiert ist
  if markier_muster[1] = '+' then
  begin
    if FachAbschnittVorhanden( fach_id, C_Q1 ) then
    begin
      pkt_sum := pkt_sum + p_q1;
      if p_q1 < C_DEFIZIT_GRENZE then
        inc( def );
      inc( anz );
      FachAbschnittLoeschen( fach_id, C_Q1, p_q1, knotenebene );
    end else
      markier_muster[1] := '-';
  end;
  if markier_muster[2] = '+' then
  begin
    if FachAbschnittVorhanden( fach_id, C_Q2 ) then
    begin
      pkt_sum := pkt_sum + p_q2;
      if p_q2 < C_DEFIZIT_GRENZE then
        inc( def );
      inc( anz );
      FachAbschnittLoeschen( fach_id, C_Q2, p_q2, knotenebene );
    end else
      markier_muster[2] := '-';
  end;
  if markier_muster[3] = '+' then
  begin
    if FachAbschnittVorhanden( fach_id, C_Q3 ) then
    begin
      pkt_sum := pkt_sum + p_q3;
      if p_q3 < C_DEFIZIT_GRENZE then
        inc( def );
      inc( anz );
      FachAbschnittLoeschen( fach_id, C_Q3, p_q3, knotenebene );
    end else
      markier_muster[3] := '-';
  end;
  if markier_muster[4] = '+' then
  begin
    if FachAbschnittVorhanden( fach_id, C_Q4 ) then
    begin
      pkt_sum := pkt_sum + p_q4;
      if p_q4 < C_DEFIZIT_GRENZE then
        inc( def );
      inc( anz );
      FachAbschnittLoeschen( fach_id, C_Q4, p_q4, knotenebene );
    end else
      markier_muster[4] := '-';
  end;

//  if anz = 0 then
//    exit; // Markierungen schon vorhanden

  inc( FRecords );
  with FDaten do
  begin
    Append;
    FieldByName( 'Node_ID' ).AsInteger := FRecords - 1;
    FieldByName( 'RootNode_ID' ).AsInteger := root_node_id;
    FieldByName( 'Knotenebene' ).AsInteger := knotenebene;
    FieldByname( 'Bemerkung' ).AsString := bemerkung;
    FieldByName( 'Fach' ).AsString := fach;
    FieldByName( 'Fach_ID' ).AsInteger := fach_id;
    if markier_muster = '----' then
      FieldByName( 'Markierung' ).AsString := markier_muster
    else
      FieldByName( 'Markierung' ).AsString := markier_muster;
    FieldByName( 'Punktsumme_Markiert' ).AsInteger := pkt_sum;
    FieldByName( 'Defizite' ).AsInteger := def;
    FieldByName( 'Punktsumme_Markiert_Total' ).AsFloat := pkt_sum + tpkt_sum;
    FieldByName( 'Defizite_Total' ).AsInteger := -def + tdef; // Defizite werden negaitv gespeichert, damit hinterher die absteigende Sortierung leichter wird
    FieldByName( 'AnzMarkiert_Total' ).AsInteger := anz + tanz;
    FieldByName( 'Durchlauf' ).AsInteger := FDurchlauf;
    Post;
  end;
  Result := FRecords - 1;
end;


function TAbiErgebnisVerwalter.FachAbschnittVorhanden( const fach_id, abschnitt: integer ): boolean;
begin

  with FFachAbschnitte do
  begin
    Result := ( FieldByName( 'Fach_ID' ).AsInteger = fach_id ) and
              ( FieldByname( 'Abschnitt' ).AsInteger = abschnitt );
    if Result then
      exit;
    First;
    while not Eof do
    begin
      Result := ( FieldByName( 'Fach_ID' ).AsInteger = fach_id ) and
                ( FieldByname( 'Abschnitt' ).AsInteger = abschnitt );
      if Result then
        exit;
      Next;
    end;
  end;


end;


procedure TAbiErgebnisVerwalter.KnotenebeneWiederherstellen( const ebene: integer;
                                       const f1_id: integer = 0;
                                       const f1_bel: string = '----';
                                       const f2_id: integer = 0;
                                       const f2_bel: string = '----' );
var
  f_id, abschn: integer;
  app: boolean;
begin
//  FFachAbschnitte.EmptyTable;
  with FFachAbschnitteEbenen do
  begin
    First;
    while not Eof do
    begin
      if ( FieldByName( 'Knotenebene' ).AsInteger >= ebene ) then
      begin
// Prüfen, ob es sich um das zu ignorierende Fach handelt
        app := true;
        f_id := FieldByName( 'Fach_ID' ).AsInteger;
        if f_id = 15 then
          abschn := FieldByName( 'Abschnitt' ).AsInteger
        else
          abschn := FieldByName( 'Abschnitt' ).AsInteger;
        if f_id = f1_id then
          app := f1_bel[ abschn-2 ] = '-'
        else if f_id = f2_id then
          app := f2_bel[ abschn-2 ] = '-';
        if app then
        begin
          if not FachAbschnittVorhanden( f_id, abschn ) then
          begin
            FFachAbschnitte.Append;
            FFachAbschnitte.FieldByName( 'Fach_ID' ).AsInteger := f_id;
            FFachAbschnitte.FieldByName( 'Abschnitt' ).AsInteger := abschn;
            FFachAbschnitte.FieldByName( 'Punkte' ).AsInteger := FieldByName( 'Punkte' ).AsInteger;
            FFachAbschnitte.FieldByName( 'Wichtung' ).AsInteger := 3; // erst mal, später erhalten alle 3, LI=2, IP/VP=1, damit bei gleichen Noten Mu vor LI vor IP/VP
            FFachAbschnitte.Post;
          end;
          Delete;
        end else
          Next;
      end else
        Next;
    end;
    First;
  end;
end;

procedure TAbiErgebnisVerwalter.Save( strLst: TStringList );
var
  i, cnt: integer;
  sln: string;
begin
  strLst.Clear;
  sln := 'Zähler';
  for i := 0 to FDaten.Fields.Count - 1 do
  begin
    if sln <> '' then
      sln := sln + ';';
    sln := sln + FDaten.Fields[i].Fieldname;
  end;
  strLst.Add( sln );
  with FDaten do
  begin
    First;
    cnt := 0;
    while not Eof do
    begin
      inc( cnt );
      sln := IntToStr( cnt );
      for i := 0 to Fields.Count - 1 do
      begin
        if sln <> '' then
          sln := sln + ';';
        sln := sln + Fields[i].AsString;
      end;
      strLst.Add( sln );
      Next;
    end;
    First;
  end;
end;

procedure TAbiErgebnisVerwalter.ZwischenstandSpeichern;
begin
  DatenKopieren( FFachAbschnitte, FFachAbschnitteEbenen );
end;

procedure TAbiErgebnisVerwalter.ZwischenstandWiederherstellen;
begin
  DatenKopieren( FFachAbschnitteEbenen, FFachAbschnitte );
end;

procedure TAbiErgebnisVerwalter.DatenKopieren( src, dst: TMemTableEh );
begin
  dst.EmptyTable;
  src.First;
  while not src.Eof do
  begin
    dst.Append;
    dst.FieldByName( 'Fach_ID' ).AsInteger := src.FieldByName( 'Fach_ID' ).AsInteger;
    dst.FieldByName( 'Abschnitt' ).AsInteger := src.FieldByName( 'Abschnitt' ).AsInteger;
    dst.FieldByName( 'Punkte' ).AsInteger := src.FieldByName( 'Punkte' ).AsInteger;
    dst.Post;
    src.Next;
  end;
  src.First;
  dst.First;
end;

function TAbiErgebnisVerwalter.GetMarkierteKurse: integer;
begin
  FDaten.Last;
  Result := FDaten.FieldByName( 'AnzMarkiert_Total' ).AsInteger;
end;

function TAbiErgebnisVerwalter.KursBesserDurchschnittPruefen( const D: double; const MuRest, VILI, VPIP: integer ): boolean;
var
  ignorieren: boolean;
begin
  Result := false;
  with FFachAbschnitte do
  begin
    SortByFields( 'Punkte DESC');
    First;
    while not Eof do
    begin
// Ist der Kurs Literatur und VILI=0
      ignorieren := ( FSpezial_IDs.IndexOf( 'LI=' + FieldByName( 'Fach_ID' ).AsString ) >= 0 ) and ( VILI = 0 );
// Ist der Kusr aus W1_6 und (VILI=0 oder VPIP=0 oder MuRest=0) // Klammern durch JR, Frage: richtig?
      if not ignorieren then
        ignorieren := ( ( FSpezial_IDs.IndexOf( 'IV=' + FieldByName( 'Fach_ID' ).AsString ) >= 0 ) or
                        ( FSpezial_IDs.IndexOf( 'IN=' + FieldByName( 'Fach_ID' ).AsString ) >= 0 ) or
                        ( FSpezial_IDs.IndexOf( 'VO=' + FieldByName( 'Fach_ID' ).AsString ) >= 0 ) ) and
                      ( ( VILI = 0 ) or ( VPIP = 0 ) or ( MuRest= 0 ) );
      if not ignorieren then
        ignorieren := ( FSpezial_IDs.IndexOf( 'MU=' + FieldByName( 'Fach_ID' ).AsString ) >= 0 ) and ( MuRest = 0 );
      if not ignorieren then
      begin
        Result := FieldByname( 'Punkte' ).AsInteger > D;
        exit;
      end;
      Next;
    end;
  end;
end;

procedure TAbiErgebnisVerwalter.ProjektkurseLoeschen( const knotenebene: integer );
begin
  with FFachAbschnitte do
  begin
    First;
// An dieser Stelle darf die Liste keine Projektkurse mehr enthalten
    while not Eof do
    begin
      if FSpezial_IDs.IndexOf( 'PX=' + FieldByName( 'Fach_ID' ).AsString ) >= 0 then
        FachAbschnittLoeschen( FieldByName( 'Fach_ID' ).AsInteger,
                               FieldByName( 'Abschnitt' ).AsInteger,
                               FieldByName( 'Punkte' ).AsInteger, knotenebene )
      else
        Next;
    end;
  end;
end;



procedure TAbiErgebnisVerwalter.RestArbeitenVorbereiten( const VPIP, knotenebene: integer );

  procedure WichtungSetzen( const wichtung: integer );
  begin
    with FFachAbschnitte do
    begin
      Edit;
      FieldByname( 'Wichtung' ).AsInteger := wichtung;
      Post;
    end;
  end;

var
  anz_iv: integer;
  go_next: boolean;
begin
// An dieser Stelle darf die Liste keine Projektkurse mehr enthalten
  ProjektkurseLoeschen( knotenebene );
  with FFachAbschnitte do
  begin
    First;
    while not Eof do
    begin
//Wichtung, alle erhalten erst mal 3, LI=2, IP/VP=1, damit bei gleichen Noten Mu vor LI vor IP/VP
      if FSpezial_IDs.IndexOf( 'LI=' + FieldByName( 'Fach_ID' ).AsString ) >= 0 then
        WichtungSetzen( 2 )
      else if ( FSpezial_IDs.IndexOf( 'IV=' + FieldByName( 'Fach_ID' ).AsString ) >= 0 ) or
              ( FSpezial_IDs.IndexOf( 'IN=' + FieldByName( 'Fach_ID' ).AsString ) >= 0 ) or
              ( FSpezial_IDs.IndexOf( 'VO=' + FieldByName( 'Fach_ID' ).AsString ) >= 0 ) then
        WichtungSetzen( 1 );
      Next;
    end;

// Nach absteigenden Punkten und Wichtung sortieren
    SortByFields( 'Punkte DESC,Wichtung DESC' );
    First;
// In die Liste kommen nur die zwei besten Kurse aus W1_6 (=IV), sofern VPIP > 0
    anz_iv := 0;
    while not Eof do
    begin
      go_next := true;
      if FSpezial_IDs.IndexOf( 'IV=' + FieldByName( 'Fach_ID' ).AsString ) >= 0 then
      begin // IV
        if anz_iv < VPIP then
          inc( anz_iv )
        else
        begin
          FachAbschnittLoeschen( FieldByName( 'Fach_ID' ).AsInteger,
                                 FieldByName( 'Abschnitt' ).AsInteger,
                                 FieldByName( 'Punkte' ).AsInteger, 8 );
          go_next := false;
        end;
      end;
      if go_next then
        Next;

    end;
    First;
  end;
end;

function TAbiErgebnisVerwalter.AnzahlW1_6: integer;
// Liefert die Anzahl der IV-Kurse (=W1_6) zurück
begin
  Result := 0;
  with FFachAbschnitte do
  begin
    First;
// An dieser Stelle darf die Liste keine Projektkurse mehr enthalten
    while not Eof do
    begin
      if FSpezial_IDs.IndexOf( 'IV=' + FieldByName( 'Fach_ID' ).AsString ) >= 0 then
        inc( Result );
      Next;
    end;
  end;
end;

procedure TAbiErgebnisVerwalter.W1_6Loeschen( const knotenebene: integer );
begin
  with FFachAbschnitte do
  begin
    Last;
// Schlechtesten IV-Kurs löschen
    while not Bof do
    begin
     if FSpezial_IDs.IndexOf( 'IV=' + FieldByName( 'Fach_ID' ).AsString ) >= 0 then
     begin
        FachAbschnittLoeschen( FieldByName( 'Fach_ID' ).AsInteger,
                               FieldByName( 'Abschnitt' ).AsInteger,
                               FieldByName( 'Punkte' ).AsInteger, knotenebene );
        exit;
     end;
     Prior;
    end;
  end;
end;


procedure TAbiErgebnisVerwalter.RestfaecherAusgeben( const fn: string );
var
  slF: TStringList;
  fach_id: string;
begin
  slF := TStringList.Create;
  with FFachAbschnitte do
  begin
    First;
    while not Eof do
    begin
      fach_id := FieldByName( 'Fach_ID' ).AsString;
      slF.Add( fach_id );
      Next;
    end;
    First;
  end;
  slF.SaveToFile( fn );
  FreeAndNil( slF );
end;


function TAbiErgebnisVerwalter.RestelisteBelegt: boolean;
begin
  Result := FFachAbschnitte.RecordCount > 0;
end;

function TAbiErgebnisVerwalter.RestelisteAnzahl: integer;
begin
  Result := FFachAbschnitte.RecordCount;
end;

function TAbiErgebnisVerwalter.NaechstenEintragAusRestelisteHolen( var fach_id, abschnitt, punkte: integer ): boolean;
begin
  with FFachAbschnitte do
  begin
    if FFachAbschnitte.RecordCount = 0 then
    begin
      Result := false;
      exit;
    end;
    Next;
    fach_id := FieldByName( 'Fach_ID' ).AsInteger;
    abschnitt := FieldByName( 'Abschnitt' ).AsInteger;
    punkte := FieldByName( 'Punkte' ).AsInteger;
    Result := true;
  end;
end;


function TAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( var fach_id, abschnitt, punkte: integer ): boolean;
begin
  with FFachAbschnitte do
  begin
    if FFachAbschnitte.RecordCount = 0 then
    begin
      Result := false;
      exit;
    end;
    First;
    fach_id := FieldByName( 'Fach_ID' ).AsInteger;
    abschnitt := FieldByName( 'Abschnitt' ).AsInteger;
    punkte := FieldByName( 'Punkte' ).AsInteger;
    Result := true;
  end;
end;

function TAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( const fach_ids: string; var fach_id, abschnitt, punkte: integer ): boolean;
begin
  with FFachAbschnitte do
  begin
    if FFachAbschnitte.RecordCount = 0 then
    begin
      Result := false;
      exit;
    end;
    First;
    while not Eof do
    begin
      fach_id := FieldByName( 'Fach_ID' ).AsInteger;
      abschnitt := FieldByName( 'Abschnitt' ).AsInteger;
      punkte := FieldByName( 'Punkte' ).AsInteger;
      if InMenge( IntToStr( fach_id ), fach_ids ) then
      begin
        Result := true;
        exit;
      end;
      Next;
    end;
  end;
end;


procedure TAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen;
begin
  with FFachAbschnitte do
  begin
    First;
    FachAbschnittLoeschen( FieldByName( 'Fach_ID' ).AsInteger,
                           FieldByName( 'Abschnitt' ).AsInteger,
                           FieldByname( 'Punkte' ).AsInteger, 9 );
  end;
end;

procedure TAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen( const fach_id, abschnitt, knotenebene: integer );
begin
  with FFachAbschnitte do
  begin
    First;
    while not Eof do
    begin
      if ( FieldByName( 'Fach_ID' ).AsInteger = fach_id ) and ( FieldByName( 'Abschnitt' ).AsInteger = abschnitt ) then
      begin
        FachAbschnittLoeschen( FieldByName( 'Fach_ID' ).AsInteger,
                               FieldByName( 'Abschnitt' ).AsInteger,
                               FieldByname( 'Punkte' ).AsInteger, knotenebene );
        exit;
      end;
      Next;
    end;

  end;
end;

function TAbiErgebnisVerwalter.Punktsumme_Total: double;
var
  psum_t: integer;
  anz_t: integer;
begin
  with FDaten do
  begin
    Last;
    Result := FieldByName( 'Punktsumme_Markiert_Total' ).AsFloat; // Die Punkte der LK's sind schon dopplet gezählt!
  end;
end;

function TAbiErgebnisVerwalter.AnzahlMarkiert_Total: integer;
var
  psum_t: integer;
  anz_t: integer;
begin
  with FDaten do
  begin
    Last;
    Result := FieldByName( 'AnzMarkiert_Total' ).AsInteger; // Die Punkte der LK's sind schon dopplet gezählt!
  end;
end;



function TAbiErgebnisVerwalter.Durchschnitt: double;
var
  psum_t: double;
  anz_t: integer;
begin
  with FDaten do
  begin
    Last;
    psum_t := FieldByName( 'Punktsumme_Markiert_Total' ).AsFloat; // Die Punkte der LK's sind schon dopplet gezählt!
    anz_t := FieldByname( 'AnzMarkiert_Total' ).AsInteger + 8; // weil LK doppelt zählen
    Result := psum_t / anz_t;
  end;
end;

function TAbiErgebnisVerwalter.DefizitSumme: integer;
begin
  with FDaten do
  begin
    Last;
    Result := abs( FieldByName( 'Defizite_Total' ).AsInteger );
  end;
end;

procedure TAbiErgebnisVerwalter.EinzelErgebnisBerechnen;
var
  psum: double;
  anz: integer;
  sum: double;
begin
  with FDaten do
  begin
    Last;
    Edit;
    psum := FieldByName( 'Punktsumme_Markiert_Total' ).AsFloat;
    anz := FieldByname( 'AnzMarkiert_Total' ).AsInteger + 8;
    sum := 40 * psum / anz;
    FieldByName( 'Ergebnis' ).AsFloat := sum;//Runden( sum );
// + 8 wegen der doppelten Wichtung der LK's (bei Punktsumme schon berücksichtigt)
    Post;
  end;
  inc( FDurchlauf );

end;

function TAbiErgebnisVerwalter.BestesErgebnisSuchen( var rootnode_id, fach_id: integer; var markierung: string ): integer;
var
  defizit_problem: boolean;
  S_n, AnzDef_n, node_id: integer;
  erg: double;
begin
  Result := 0;
  with FDaten do
  begin
    SortByFields( 'Ergebnis DESC,Defizite_Total' );
    First;
    while not Eof and not FieldByName( 'Ergebnis' ).IsNull do
    begin
      node_id := FieldByName( 'Node_ID' ).AsInteger;
      rootnode_id := FieldByName( 'RootNode_ID' ).AsInteger;
      fach_id := FieldByName( 'Fach_ID' ).AsInteger;
      markierung := FieldByName( 'Markierung' ).AsString;
      erg := FDaten.FieldByName( 'Ergebnis' ).AsFloat;
      S_n := FieldByName( 'AnzMarkiert_Total' ).AsInteger;
      AnzDef_n := abs( FieldByName( 'Defizite_Total' ).AsInteger );
      defizit_problem := ( ( S_n < 38 ) and ( AnzDef_n > 7 ) ) or ( ( S_n > 37 ) and ( AnzDef_n > 8 ) );
      if not defizit_problem then
      begin
        Result := 1;
        exit;
      end else
        Next;
    end;

    if Result = 0 then
    begin // Kein Ergebnis gefunden, vermutl. wg. zu vielen Defiziten, nehme als Pseudoergebnis das erste
      First;
      if not FieldByName( 'Ergebnis' ).IsNull then
      begin
        node_id := FieldByName( 'Node_ID' ).AsInteger;
        rootnode_id := FieldByName( 'RootNode_ID' ).AsInteger;
        fach_id := FieldByName( 'Fach_ID' ).AsInteger;
        markierung := FieldByName( 'Markierung' ).AsString;
        erg := FDaten.FieldByName( 'Ergebnis' ).AsFloat;
        S_n := FieldByName( 'AnzMarkiert_Total' ).AsInteger;
        AnzDef_n := abs( FieldByName( 'Defizite_Total' ).AsInteger );
        Result := -1;
      end;
    end;
  end;
end;

procedure TAbiErgebnisVerwalter.NaechstHoehereEbene( const node_id: integer; var rootnode_id, fach_id: integer; var markierung: string );
begin
  with FDaten do
  begin
    Locate( 'Node_ID', node_id, [] );
    rootnode_id := FieldByName( 'RootNode_ID' ).AsInteger;
    fach_id := FieldByName( 'Fach_ID' ).AsInteger;
    markierung := FieldByName( 'Markierung' ).AsString;
  end;
end;

function TAbiErgebnisVerwalter.GetWurzelKnoten: integer;
begin
  Result := FRecords - 1;
end;

function TAbiErgebnisVerwalter.AnzahlMarkierungenFuerFach( const statkrz: string ): integer;
var
  muster: string;
  i: integer;
begin
  Result := 0;
  if not FDaten.Locate( 'Durchlauf;Fach', VarArrayOf( [ FDurchlauf,statkrz ] ), [] ) then
    exit;
  muster := FDaten.FieldByname( 'Markierung' ).AsString;
  for i := 1 to length( muster ) do
  begin
    if muster[i] = '+' then
      inc( Result );
  end;
end;


end.
