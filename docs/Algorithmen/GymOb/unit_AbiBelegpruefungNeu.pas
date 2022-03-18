unit unit_AbiBelegPruefungNeu;

interface

uses	Classes,
{$IFDEF UNIDAC}
      Uni,
      uDBUtils_UNIDAC,
{$ELSE}
			AdoDB,
			BetterADODataset,
      RBKDBUtils,
{$ENDIF}
			DB,
      Graphics,
//			ComCtrls,
      SysUtils,
      unit_AbiPrueferKlassen,
      unit_SchildConst,
      MemTableDataEh,
      MemTableEh;
//			JvMemoryDataset;


type
  TAufrufendesProgramm = ( apLUPO, apSCHILD );
  TPunktsummenModus = ( psmZulassung, psmZwischenstand, psmEndstand );
  TZweierCombi = record
    Abschnitt1: integer;
    Abschnitt2: integer;
  end;
  TZweierCombiArray = array[1..6] of TZweierCombi; // Kombinationen der möglichen Abschnittspaare
  TAbiFaecher = set of byte;
  TAbiPruefErgebnis = ( aeNichtZugelassen, aeZugelassen, aeNichtBestanden, aeBestanden, aeFehlendeAbiLeistungen,
                        aeFehlendeZusAbiLeistungen, aeFehlendeMdlAbiLeistungen, aeFehlendeSchrAbiLeistungen, aeFehlendeLKAbiLeistungen,
                        aeZuWenigKurse_I, aeDefizite_I, aeLK_Defizite_I, aeZuWenigPunkte_I,
                        aeDefizite_II, aeLK_Defizite_II, aeZuWenigPunkte_II );

  TKursZahlRecord = record
    StatistikKrz: string[2];
    AnzahlKurse: integer;
    AbiturArt: integer;
    BelegungsMuster: string[6];
  end;

  TMuRestRecord = record
    _MURest: integer;
    _VPIP: integer;
    _VILI: integer;
  end;

  TAbiturRec = record
    SummeAnzahlMarkiert: integer;
    SummePunkteMarkiert: integer;
    Punktsumme_I: integer;
    Kurszahl_I: integer;
    Kurszahl_I_GK: integer;
    Kurszahl_I_LK: integer;
    Kurszahl_I_0_Pkt: integer;
    LK_Defizite_I: integer;
    Defizite_I: integer;
    Durchschnitt_I: double;
    Farbe_Anzahl_I: TColor;
    Farbe_LK_Defizite_I: TColor;
    Farbe_Defizite_I: TColor;
    Farbe_Punktsumme_I: TColor;
    Punktsumme_LK: integer;
    Punktsumme_GK: integer;

    Punktsumme_II: integer;
    LK_Defizite_II: integer;
    Defizite_II: integer;
    Durchschnitt_II: double;
    Farbe_LK_Defizite_II: TColor;
    Farbe_Defizite_II: TColor;
    Farbe_Punktsumme_II: TColor;

    Punktsumme_Abi: integer;
    Durchschnitt_Abi: double;
    AbiturAbbruch: boolean;
    Abiturnote: double;
    Abiturnote_Besser: double;
    Punktabstand_Besser: integer;
    Abiturnote_Schlechter: double;
    Punktabstand_Schlechter: integer;
    Zulassung: boolean;
    Bestehenspruefung: boolean;
    Abweichungspruefung: boolean;
    AbweichungspruefungOhnePunkte: boolean;
    BlockIIDefizite: boolean;
    LeistungenVollstaendig: boolean;
    Ergebnisse: set of TAbiPruefErgebnis;
  end;


  TKurseStunden = record
    Kurse: integer;
    Stunden: double;
    AnzGKS: integer;
    AnzGK: integer;
  end;
  TSummen = array[1..7] of TKurseStunden;   // /: Gesamtsummen
  TSchueler = record
    ID: integer;
    SPP: boolean;
    LateinBeginn: string;
    BilingualerZweig: string;
    Sportbefreit: boolean;
    S1_Sprachen: string;
    S1_Sprachen_5_6: string;
    S1_Sprachen_8: string;
    S1_Sprachfaecher_5_6: string;
    S1_Sprachfaecher_8: string;
    Einsprachler: boolean;
    FS2_SekI_manuell: boolean;
    Konfession: string;
    BLL_Art: string;
    BLL_Punkte: integer;
  end;

	TKursZaehler = class( TObject )
		private
      FPhase: char;
      FKursZahlen: array of TKursZahlRecord;
      FAnzahlKurseE: integer;
      FPX_ist_BLL: boolean;
      function Index( const stkrz: string ): integer;
      function GetGesamtzahl: integer;
    public
      property Phase: char read FPhase write FPhase;
      property PX_ist_BLL: boolean read FPX_ist_BLL write FPX_ist_BLL;
      property Gesamtzahl: integer read GetGesamtzahl;
      property AnzahlKurseE: integer read FAnzahlKurseE;
      procedure Initialisieren;
      procedure FachHinzu( const stkrz: string; const abif: integer;
                           const ka_1, ka_2, ka_3, ka_4, ka_5, ka_6: string );

    end;

	TAbiturBelegPruefer = class( TObject )
		private
			fC0 : TMemTableEh;
      FPX : TMemTableEh;
      FAbiturDaten: TMemTableEh;
      FReliRest: TMemTableEh;
      FReliTemp: TMemTableEh;
      FTemp1: TMemTableEh;
      FTemp2: TMemTableEh;
{$IFDEF UNIDAC}
			FConABP: TUniConnection;
{$ELSE}
			FConABP: TADOConnection;
{$ENDIF}
      FShowMsg: boolean;

      FKursZaehler: TKursZaehler;

			W1_1 : string;		// Deutsch
			W1_2 : string;		// SI-Fremdspr.
			W1_3 : string;		// SII-Fremdspr.
			W1_4 : string;		// Musik, Kunst
			W1_5 : string;		// mus. Ersatzfächer LI IV
      W1_6 : string;    // nur IV
			W1   : string;		// Vereinigung von W1_1 bis W1_5

			W2_1 : string;		// Geschichte
			W2_2 : string;		// Sozialwissenschaften
			W2_3 : string;		// Erdkunde, Erziehungswissenschaft, Rechtskunde, Psychologie
			W2_4 : string;		// Philosophie
      W_ZK : string;    // Zusatzkurse
//			W2_5 : string;		// Geschichte, Zusatzkurs (stillgelegt)
//			W2_6 : string;		// Sozialwissenschaften, Zusatzkurs
			W2   : string;		// Vereinigungsmenge W2_1 bis W2_6

			W3_1 : string;		// Mathematik
			W3_2 : string;		// klassische Naturwissenschaften
			W3_3 : string;		// weitere Naturwissenschaften
			W3   : string;		// Vereinigungsmenge W3_1 bis W3_3

			W4   : string;		// Religion
			W5   : string;		// Sport
			W6   : string;		// bilingual unterrichtete Fächer
      W_PF : string;    // Projektkurse
      W_VF : string;    // Verteifungskurse
      W_LK : string;
      W_GKS: string;
      W_GK : string;
      W_USprIstFS: string; // Fächer in FremdsprachenUnterrichtssprachen;
      W_AF: string ; // die Abiturfächer
      W_AGF: string; // Menge der Aufgabenfelder

      Fremdsprachen: string; // alle Fremdsprachen
      FS_Durchg: string; // Durchgängig belegbare FS aus
      FS_E11_Q11_Belegbar: string;// von E1.1 bis Q1.1 belegbare FS (für WBK)
      FS_EBelegbar: string;
      DurchgehendBelegbareFaecher: string;

      FSchulform: string;
      FGliederung: string;
      FSchueler: TSchueler;
      FLfdNr: integer;
      FBeratung: boolean;
      FEnd_Hj: integer;
      FPruefOrd: string;
      FPO_Krz: string;
      FJg_E: integer;
      FJg_Q_1: integer;
      FJg_Q_2: integer;
      FSummen: TSummen;
      FkeinReli: byte;
      FBelegteAbiFaecher: string;

      slSekI_JG: TStringList;
      slSekII_Jg: TStringList;
      slSekII_Spr: TStringList;
      slAbiFaecher: TStringList;

// Neu für Abiturberechnung
      FFuerAbitur: boolean;
      FFehlerZahl: integer;
      FBilSF_Belegt: boolean;
      FAnzLKDefizit: integer;
      FAbbruch: boolean;
      FMeldungen: TStringList;
      FBelegMeldungen: TStringList;

      FArrayMuKu: TFachHolder;
      FArrayGE: TFachHolder;
      FArraySW: TFachHolder;
      FArrayEinsprachler: TFachHolder;
      FArrayNW: TFachHolder;

      FAbiErgebnisVerwalter: TAbiErgebnisVerwalter;
      slAbiErgebnisListe: TStringList; // Für Ausgabe der Ergebnisse in Grid
      ZweierCombis: TZweierCombiArray;
      slZwangsFaecher: TStringList;

      FMenge_A: string;
      FMenge_C: string;
      FMenge_D: string;

      FAbiturErgebnisse: TAbiturRec;
      FAktivLevel: integer;
      FAktiveID: integer;
      FAnzahl_FA: integer;
      FPunkte_FA: integer;
      FMarkiert_FA: boolean;
      FAnzahl_0_Punkte: integer;
      FDauerUnterrichtseinheit: double;
      FAufrufendesProgramm: TAufrufendesProgramm;
      FBelegungsfehlerIgnorieren: boolean;
      procedure SetPruefOrd( const po: string );
      procedure CreateMemTables;
      procedure Pruefe_E_Phase_GY_GE;
      procedure Pruefe_Q_Phase_GY_GE( const BEGINN: integer );

      procedure Pruefe_E_Phase_WBK;
      procedure Pruefe_Q_Phase_WBK;
      procedure Pruefe_Q_Phase_BK;

      procedure GruppenBilden;
      function IstMarkiert( const fach: string; const hj: integer ): boolean;
      function IstSchriftlich( const fach: string; const hjv, hjb: integer ): boolean;
      function IstSchriftlich1( const fach: string; const hjv, hjb: integer ): boolean;
      function IstMuendlich( const fach: string; const hjv, hjb: integer ): boolean;
      function IstLK( const fach: string; const hjv, hjb: integer ): boolean;
      function IstZK( const fach: string; const hjv, hjb: integer ): boolean;
      function IstGKS( const fach: string; const hjv, hjb: integer ): boolean;
      function IstGK( const fach: string; const hjv, hjb: integer ): boolean;
      function IstAbifach( const fach: string; af: TAbiFaecher ): boolean;
      function FS_IstBelegt( const fs: string; const hjv, hjb: integer ): boolean;
      function FS_IstSchriftlich( const fs: string; const hjv, hjb: integer ): boolean;
      function IstBelegt( const fach: string; const hjv, hjb: integer; const kursart: string = '' ): boolean;
      function IstBelegt1( const fach: string; const hjv, hjb: integer ): boolean;
      function IstBelegtPunkte( const fach: string; const hjv, hjb: integer; var markier_muster: string; const kursart: string = '' ): boolean;
      function IstBelegtPunkte1( const fach: string; const hjv, hjb: integer ): boolean;
      function IstBelegtPunkteVar( const fach: string ): boolean;
      function PXIstBelegbar( const fach: string; const hj: integer ): boolean;
      function BeginnZK( const fach: string ): integer;
      function AnzahlMarkiert( const fach: string; const hjv, hjb: integer; const kursart: string = '' ): integer;
      function AnzahlNichtMarkiert( const fach: string; const hjv, hjb: integer; const kursart: string = '' ): integer;
      function GruppeGemischtBelegt( const gruppe: string; const hjv, hjb: integer ): boolean;
      function GesamtWochenstunden( const fach: string; const hjv, hjb: integer ): integer;
      function IstMehrfachAusgepraegt( const fach: string ): boolean;
      function LateinBelegt( const hjv, hjb: integer ): boolean;
      function Ist_Erste_FS( const afach: string ): boolean;
      function Ist_Zweite_FS( const afach: string ): boolean;
      function FS_als_NP: string;
      function AnzahlSchriftlich( const gruppe: string; const hjv, hjb: integer ): integer;
      function GruppeSchriftlich( const gruppe: string; const hjv, hjb: integer; const alle: boolean ): boolean;
      function GruppeSchriftlichSprache( const gruppe: string; const hjv, hjb: integer; const alle: boolean ): boolean;
      function GruppeBelegtSprache( const gruppe: string; const hjv, hjb: integer; const alle: boolean = false ): boolean;
      function GruppeMuendlich( const gruppe: string; const hjv, hjb: integer; const alle: boolean ): boolean;
      function GruppeBelegt( const gruppe: string; const hjv, hjb: integer; const kursart: string = '' ): boolean;
      function GruppeZK( const gruppe: string; const hjv, hjb: integer ): boolean;
      function AnzahlGruppeBelegt( const gruppe: string; const hjv, hjb: integer ): integer;
      function AnzahlBelegteHalbjahre( const fach: string; const hjv, hjb: integer; const kursart: string = '' ): integer;
      function AnzahlBelegtPunkte( const fach: string; const hjv, hjb: integer; const kursart: string = '' ): integer;
      function UnterrichtsSprache( const fach: string ): string;
      function StatistikKuerzel( const fach: string ): string;
      function IstFremdsprache( const fach: string ): boolean;
      function FachKuerzel_aus_ID( const fach_id: integer ): string;
      function Fach_ID_Von( const fach: string ): integer;
      function Fach_IDs_VonGruppe( const gruppe: string ): string;
      function Fachgruppe( const fach: string ): string;
      function Fachname( const fach: string ): string;
      function SchriftlicheFaecher( const M: string; von_hj, bis_hj: integer ): string;
      function FeldWertIDs( Tabelle: TDataset; Feld, Wert: string; WertLaenge: integer ): string;
      procedure PruefeDoppelbelegung( const M: string; const Fremdsprachen, AbschnittEgal: boolean );
      function SprachenVonBilingSachf( const schr: boolean; const hjv, hjb: integer ): string;
      function FilternBilingSachf( const schr: boolean; const hjv, hjb: integer ): string;
      function Beste2QKurse( const fach: string; var punktsumme: integer; const kursart: string = '' ): string;
      procedure KurseStundenBerechnen;
      procedure PruefeLatein_Q;
      procedure PruefeFS2_Q;
      procedure PruefeBelegungAusE1;
      procedure MehrfachAuspraegungenErmitteln;
//      function AbiturFach( const
      function MyLocate( DS: TDataset; const fn: string; const fv: string ): boolean;
      function GetBelegteAbiFaecher: string;
      function LeitfachBelegung_GY_GE( const pfach: string ): string;
      function LeitfachBelegt_WB( const pfach: string ): boolean;
      function PruefeReligion( hjv, hjb: integer ): boolean;
      function PruefeReligion_Q_GY_GE: string;
      procedure PruefeReligionNeu( const BEGINN: integer );
      function GetAnzahlKurse: integer;
      function GetAnzahlKurseE: integer;
      function StatKrzInMenge( const statkrz, menge: string ): boolean;
      function Ist_WBK_Quereinsteiger: boolean;
      function FachIn2HjBelegt( const fach: string; hjv, hjb: integer ): boolean;
      function WBK_AffinesFachBelegt( const statkrz: string; const hj: integer = 0 ): boolean;
      function WBK_SprachNachweisVorhanden: boolean;
      procedure WBK_AnrechenbarkeitPruefen( const fach: string; var ar_q1, ar_q2, ar_q3, ar_q4: boolean );
      function GetFehlerVorhanden: boolean;
      procedure KurseMarkieren_GY_GE;
      procedure KurseMarkieren_BK;
      procedure KurseMarkieren_WBK;
      procedure MarkierungenPruefen_GY_GE;
      procedure MarkierungenPruefen_BK;
      procedure AbschnitteMarkieren( const fach: string; const istart, iend: integer; const mark: char );overload;
      procedure AbschnitteMarkieren( const fach_id: integer; const istart, iend: integer; const mark: char );overload;
      procedure Markieren( const fach: string; const abschnitt: integer; const mark: char );overload;
      procedure Markieren( const fach_id: integer; const abschnitt: integer; const mark: char );overload;
      function Punkte( const fach: string; abschnitt: integer ): integer;
      function NeuerKnoten( statkrz, markier_muster: string; const knoten_ebene, root_id: integer ): boolean;
      function PruefeInhaltsgleicheFaecher( const hj: integer ): boolean;
      procedure WesensgleicheFaecherErsetzen;
      procedure Knotenebene_1_GY_GE;
      procedure Knotenebene_2_GY_GE;
      procedure Knotenebene_3_GY_GE;
      procedure Knotenebene_4_GY_GE;
      procedure Knotenebene_5_GY_GE;
      procedure Knotenebene_6_GY_GE;
      procedure Knotenebene_7_GY_GE;
      procedure Knotenebene_8_GY_GE;
      procedure Knotenebene_9_GY_GE;
      procedure Knotenebene_10_GY_GE;

      procedure Knotenebene_1_WBK;
      procedure Knotenebene_2_WBK;
      procedure Knotenebene_3_WBK;
      procedure Knotenebene_4_WBK;
      procedure Knotenebene_5_WBK;
      procedure Knotenebene_6_WBK;
      procedure Knotenebene_7_WBK;

      procedure KnotenStrukturenErzeugen;
      function GetAbweichungsFaecher: string;
      function GetBestehensFaecher: string;
      function Defizite_OK_BK( const mark_kurse, defizite, lk_defizite: integer ): boolean;
      procedure BestesFachSuchen( const M: string; var fach_max: string; var pkt_max: integer );
      function HalbjahrText( i: integer ): string;
      function Schulstunden( const std: double ): integer;
      function FachAbiPunktsumme( const fach_id: integer; const Leer_wie_0: boolean = false ): integer;
      function PunktsummeBeste2KurseEinesFaches( const fach: string ): integer;
      function MarkiermusterBeste2KurseEinesFaches( const fach: string ): string;
      function FremdspracheFinden( const fach: string ): string;
      procedure BilingualePruefung_GY_GE( const BEGINN: integer );
    public
      property Schulform: string read FSchulform write FSchulform;
      property Gliederung: string read FGliederung write FGliederung;
      property ShowMessages: boolean read FShowMsg write FShowMsg;
      property End_Hj: integer read FEnd_Hj write FEnd_Hj;
      property PruefungsOrdnung: string read FPruefOrd write SetPruefOrd;
      property Schueler: TSchueler read FSchueler write FSchueler;
      property Summen: TSummen read FSummen;
      property BelegteAbiturFaecher: string read GetBelegteAbiFaecher;
      property AnzahlKurse: integer read GetAnzahlKurse;
      property AnzahlKurseE: integer read GetAnzahlKurseE;
{$IFDEF UNIDAC}
      constructor Create( conabp: TUniConnection; const schulfrm: string );
{$ELSE}
      constructor Create( conabp: TADOConnection; const schulfrm: string );
{$ENDIF}
      destructor Destroy;
      procedure Free;
      procedure Initialisieren( const bll_art: char; const bll_pkt: integer );
      procedure SetzeSchuelerdaten( const s_id: integer; const s1_2fs_manuell: boolean; const s1_spr, s1_spr_5_6, s1_spr_8, s1_sprfaecher_5_6, s1_sprfaecher_8,
                                  biling_zweig: string; const spp, sportattest: boolean; const lateinbeg: string );
      procedure SetzeWeitereSchuelerdaten( const konf: string );
      function FachHinzu( const fach_id: integer;
                          const statkrz, internkrz, fachname, fachgruppe, usprache, fsprache, sprfolge, leitfach1, leitfach2, beginn_jg: string;
                          const ka_e1, ka_e2, ka_q1, ka_q2, ka_q3, ka_q4: string;
                          const E1_WStd, E2_WStd, Q_WStd, abifach: integer;
                          pkt_q1, pkt_q2, pkt_q3, pkt_q4: string;
                          const m_q1: boolean = false;
                          const m_q2: boolean = false;
                          const m_q3: boolean = false;
                          const m_q4: boolean = false;
                          const m_fa: boolean = false;
                          const aufgabenfeld: string = '';
                          const pkt_fa: string = '';
                          const w_q1: integer = 0;
                          const w_q2: integer = 0;
                          const w_q3: integer = 0;
                          const w_q4: integer = 0 ): boolean;
      procedure Ausfuehren;
      procedure BelegpruefungFuerAbitur;
      function Beginn_IstSekI_Jg ( jg: string ): boolean;
      function Beginn_IstSekII_Jg ( const jg: string ): boolean;
      function SpracheAusSekI ( const stkrz: string ): boolean;
      function SpracheAusSekII ( const stkrz: string ): boolean;
      function W6_mit_anderer_FS_als( const faecher: string ): string;
      function Fremdsprachen_Suffix_Ermitteln( const faecher: string ): string;
      procedure HoleBelegbareFS;
      function HoleDurchgehendBelegbareFaecher: string;
      property FehlerVorhanden: boolean read GetFehlerVorhanden;
      procedure KurseMarkieren;
      procedure MarkierungenPruefen;
      property BilingualesSachfachBelegt: boolean read FBilSF_Belegt;
      property Abbruch: boolean read FAbbruch;
//      property AbiErgebnisVerwalter: TAbiErgebnisVerwalter read FAbiErgebnisVerwalter;
      function MarkierungenHolenStatKrz( const statkrz: string; var m3, m4, m5, m6: boolean ): boolean;
      function MarkierungenHolenInternKrz( const internkrz: string; var m3, m4, m5, m6, m_fa: boolean ): boolean;
      property AbiErgebnisListe: TStringList read slAbiErgebnisListe;
      procedure FehlerAusgeben( const fcode, ftext: string );
      property Meldungen: TStringList read FMeldungen;
      property BelegungsMeldungen: TStringList read FBelegMeldungen;
      procedure Block_I_Berechnen;
      procedure Block_II_Berechnen;
      function MuendlichePruefungNotwendig( const p_q1, p_q2, p_q3, p_q4: string; const p_abi: integer ): char;
      function AbiturdatenHinzu( const fach_id, abiturfach, abiprueferg, mdlprueferg: integer ): boolean;
      property AbiturErgebnisse: TAbiturRec read FAbiturErgebnisse;
      property AbweichungsFaecher: string read GetAbweichungsFaecher;
      property BestehensFaecher: string read GetBestehensFaecher;
      property AktivLevel: integer read FAktivLevel write FAktivLevel;
      procedure AktivLevelAendern( const iv: integer );
      property AktiveID: integer read FAktiveID write FAktiveID;
      procedure PunktsummeFuerFachBerechnen( const fach_id: integer; const ps_modus: TPunktSummenModus; var punktsumme: integer; var durchschnitt: double );
      property FuerAbitur: boolean read FFuerAbitur write FFuerAbitur;
      property DauerUnterrichtseinheit: double read FDauerUnterrichtseinheit write FDauerUnterrichtseinheit;
      property AufrufendesProgramm: TAufrufendesProgramm read FAufrufendesProgramm write FAufrufendesProgramm;
      property BelegungsfehlerIgnorieren: boolean read FBelegungsfehlerIgnorieren write FBelegungsfehlerIgnorieren;
      procedure FaecherBelegbarkeitAktualisieren;
    end;

const
  C_BLL_KEINE = -2;
  C_BLL_PF = -1;

implementation

uses
  Math,
  RBKStrings,
  RBKMath,
  Dialogs,
  StrUtils,
  unit_NotenPunkte,
  unit_LupoMessenger,
  unit_Mengen;

const
  C_KNOTENEBENEN = 10;
  C_EBENE_NW_FS = 1;
  C_EBENE_MU_KU = 2;
  C_EBENE_GE = 3;
  C_EBENE_SW = 4;
  C_EBENE_EINSPR = 5;
  C_EBENE_RE = 6;
  C_EBENE_GW = 7;
  C_EBENE_PX = 8;
  C_MAX_LOOPS = 300;
  C_DEFIZIT_GRENZE = 5;
  C_FEHLER_FARBE = clRed;
  C_WARN_FARBE = clYellow;
  C_ABBRUCH_FARBE = clWindow;
  C_OK_FARBE = clLime;

  C_MIN_KURSE_GY_G8 = 35;
  C_MAX_KURSE_GY_G8 = 40;

  C_MIN_KURSE_BK = 32;
  C_MAX_KURSE_BK = 100; // dummy

  C_MIN_KURSE_WB_AG = 16;
  C_MAX_KURSE_WB_AG = 24;

  C_MIN_KURSE_WB_KL = 28;
  C_MAX_KURSE_WB_KL = 34;

var
  AbiSP, AbiRE, AbiMNW, AbiNW, AbiM, AbiPL, AbiGW, AbiSW, AbiGE, AbiMuKu, AbiD, Abi1FS, AbiNFS, AbiFS: boolean;
  AnzAbiFS: integer;
  Nur_PL_AF: boolean;
  NW_SP, Sprachen_SP: boolean;
  HatProjektKurs, ProjBLL, ProjZwang, ProjMark: boolean;
  RootNode_ID: integer;
  MURest, VPIP, VILI: integer;
  MarkierBemerkungen: array[0..C_KNOTENEBENEN] of string;
  MuRestRec: TMuRestRecord;
// Für WBK
  Sum_USt_AF: array[1..3] of integer;

// TKursZaehler
procedure TKursZaehler.Initialisieren;
begin
  SetLength( FKursZahlen, 0 );
  FAnzahlKurseE := 0;
end;

procedure TKursZaehler.FachHinzu( const stkrz: string; const abif: integer;
                                  const ka_1, ka_2, ka_3, ka_4, ka_5, ka_6: string );
var
  ix, abiart: integer;
begin

  if ka_1 + ka_2 + ka_3 + ka_4 + ka_5 + ka_6 = '' then
    exit;

{  if ( FPhase = 'E' ) and ( ka_1 + ka_2 = '' ) then
    exit
  else if ( FPhase = 'G' ) and ( ka_3 + ka_4 + ka_5 + ka_6 = '' ) then
    exit;}
//Vertiefungskurse werden nie mitgezählt
  if stkrz = C_VERTIEFUNGSKURS then
    exit;
  if ( ka_1 = 'VTF' ) or ( ka_2 = 'VTF' ) or ( ka_3 = 'VTF' ) or ( ka_4 = 'VTF' ) then
    exit;
  ix := Index( stkrz );
  if ix = -1 then
  begin
    SetLength( FKursZahlen, High( FKursZahlen ) + 2 );
    ix := High( FKursZahlen );
    with FKursZahlen[ix] do
    begin
      StatistikKrz := stkrz;
      AbiturArt := 0;
    end;
  end;

//Gewichtung der Abiturarten
//	Wenn das Fach Ab1/2 dann
//    AbiArt = 2
//  Sonst Wenn das Fach Ab3/4 ist, dann
//    AbiArt = 1
//  Sonst
//    AbiArt = 0;

  if abif in [ 1, 2 ] then
    abiart := 2
  else if abif in [ 3, 4 ] then
    abiart := 1
  else
    abiart := 0;

  with FKursZahlen[ix] do
  begin
//Vergleichen der AbiArt mit einer eventuell schon bestehenden Einträgen. Trägt die AbiArt bei höherem Gewicht ein
//Wenn Array(x,3) < AbiArt Dann Array(x,3) = AbiArt
    if Abiturart < abiart then
      Abiturart := abiart;

//Addition aller nicht leeren Halbjahre des Faches (ASD-Kürzel)
//Schleife über die Halbjahre Q1.2 bis Q2.2 mit Kursart ≠ {}
//    if FPhase = 'E' then
    begin
      if ( ka_1 <> '' ) or ( ka_2 <> '' ) then
        FAnzahlKurseE := FAnzahlKurseE + 1;
    end;

    BelegungsMuster := '------';
    if ( ka_3 <> '' ) and ( ka_3 <> 'AT' ) then
    begin
      AnzahlKurse := AnzahlKurse + 1;
      BelegungsMuster[C_Q1] := '+';
    end;
    if ( ka_4 <> '' ) and ( ka_4 <> 'AT' ) then
    begin
      AnzahlKurse := AnzahlKurse + 1;
      BelegungsMuster[C_Q2] := '+';
    end;
    if ( ka_5 <> '' ) and ( ka_5 <> 'AT' ) then
    begin
      AnzahlKurse := AnzahlKurse + 1;
      BelegungsMuster[C_Q3] := '+';
    end;
    if ( ka_6 <> '' ) and ( ka_6 <> 'AT' ) then
    begin
      AnzahlKurse := AnzahlKurse + 1;
      BelegungsMuster[C_Q4] := '+';
    end;
  end;
end;

function TKursZaehler.GetGesamtzahl: integer;

  function IsIV( const StatistikKrz: string ): boolean;
  begin
    Result := ( StatistikKrz = 'IV' ) or ( StatistikKrz = 'IN' ) or ( StatistikKrz = 'VO' );
  end;

  function PXKurse( const bm: string ): integer;
  begin
    Result := 0;
    if ( bm[C_Q1] = '+' ) and ( bm[C_Q2] = '+' ) then
      Result := 2
    else if ( bm[C_Q2] = '+' ) and ( bm[C_Q3] = '+' ) then
      Result := 2
    else if ( bm[C_Q3] = '+' ) and ( bm[C_Q4] = '+' ) then
      Result := 2;
  end;


var

  i: integer;
  anzK: integer;
  anzLI: integer;
  anzIV: integer;
  anzMU: integer;
  abiMU: integer;
  anzDiff: integer;


begin
//Die Kurssummen in der Matrix werden daraufhin untersucht, ob sie die erlaubte Maximalgrenze in
//Abhängigkeit der AbiArt und des Faches überschreiten. Falls ja, wird die Kurssumme korrigiert.
//Schleife über alle x im Array
  anzMU := 0;
  anzLI := 0;
  anzIV := 0;
  for i := 0 to High( FKursZahlen ) do
  begin
    with FKursZahlen[i] do
    begin
//  Wenn (Array(x,2) = ‚LI’ Or Array(x,2) = ‚IV’ Or Array(x,2) = ‚PX’) And Array(x,2) > 2 dann Array (x,2) = 2
//	Sonst Wenn (Array(x,3) = 2 Or Array (x,1) = ‘SP’) And Array(x,2) > 4 Dann Array(x,2) = 4
//	Sonst Wenn  Array(x,3) = 1 And Array(x,2) > 6 dann Array(x,2) = 6
//	Sonst Wenn Array(x,2) > 5 Then Array (x,2) = 5
      if ( ( StatistikKrz = 'LI' ) or IsIV( StatistikKrz ) {or ( StatistikKrz = C_PROJEKTKURS )} ) and ( AnzahlKurse > 2 ) then
        AnzahlKurse := 2
      else if ( StatistikKrz = C_PROJEKTKURS ) then
      begin
        if FPX_ist_BLL then
          AnzahlKurse := 0
        else
          AnzahlKurse := PXKurse( BelegungsMuster );
      end else if ( ( AbiturArt = 2 ) or ( StatistikKrz = 'SP' ) ) and ( AnzahlKurse > 4 ) then
        AnzahlKurse := 4
      else if ( AbiturArt = 1 ) and ( AnzahlKurse > 6 ) then
        AnzahlKurse := 6
      else if AnzahlKurse > 5 then
        AnzahlKurse := 5;

//Die Kurssummen und die Abiart in MU der drei Sonderkurse werden in gesonderte Variablen geschrieben.
//Alternativ könnte man sich deren Position im Array merken.
//	Wenn Array(x,1) = ‘MU’ dann
//AnzMU = Array(x,2)
//AbiMU = Array(x,3)
      if StatistikKrz = 'MU' then
      begin
        anzMU := anzMU + AnzahlKurse;
        abiMU := AbiturArt;
//	Wenn Array(x,1) = ‘IV’ dann AnzIV = Array(x,2)
      end else if IsIV( StatistikKrz ) then
        anzIV := anzIV + AnzahlKurse
//Wenn Array(x,1) = ‘LI’ dann AnzLI = Array(x,2)
      else if StatistikKrz = 'LI' then
        anzLI := anzLI + AnzahlKurse
    end;
  end;

//Aufsummieren
//Schleife über alle x im Array
//	Wenn Array(x,1) ungleich LI, oder IV, oder MU dann AnzK = AnzK + Array(x,2)
//Nächstes x
  anzK := 0;
  for i := 0 to High( FKursZahlen ) do
  begin
    with FKursZahlen[i] do
      if not ( ( StatistikKrz = 'LI' ) or IsIV( StatistikKrz ) or ( StatistikKrz = 'MU' ) ) then
        anzK := anzK + AnzahlKurse;
  end;

//Können bei Musik noch Kurse aufgenommen werden?
//If AbiMu = 2 Then AnzDiff = 4 –AnzMu
//ElseIf AbiMu = 1 Then AnzDiff = 6 –AnzMu
//Else AnzDiff = 5 –AnzMu
//End If
  if abiMU = 2 then
    anzDiff := 4 - anzMU
  else if abiMU = 1 then
    anzDiff := 6 - anzMU
  else
    anzDiff := 5 - anzMU;

//Hinzuaddieren von maximal zwei Kursen LI, IV, in abhängigkeit der Freiplätze in MU und der Oberbegrenzung von zwei Kursen.
//Select Case AnzLi
//	Case Is 2
//		AnzK = AnzK + 2
//	Case Is 1
//		If AnzIV > 0 and AnzDiff > 0 then
//      AnzK = AnzK + 2
//		Else
//			AnzK = AnzK + 1
//	Case Is 0
//		If AnzDiff >1 Then
//      AnzK = AnzK + AnzIV
//		ElseIf AnzDiff = 1 And AnzIV > 0 Then
//      AnzK = AnzK + 1
//		End If
//End Select
  case anzLI of
    2 : anzK := anzK + 2;
    1 : if ( anzIV > 0 ) and ( anzDiff > 0 ) then
          anzK := anzK + 2
        else
          anzK := anzK + 1;
    0 : if anzDiff > 1 then
          anzK := anzK + anzIV
        else if ( anzDiff = 1 ) and ( anzIV > 0 ) then
          anzK := anzK + 1;
  end;
  Result := anzK + anzMU;
end;

function TKursZaehler.Index( const stkrz: string ): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to High( FKursZahlen ) do
  begin
    if FKursZahlen[i].StatistikKrz = stkrz then
    begin
      Result := i;
      exit;
    end;
  end;
end;


{$IFDEF UNIDAC}
constructor TAbiturBelegPruefer.Create( conabp: TUniConnection; const schulfrm: string );
{$ELSE}
constructor TAbiturBelegPruefer.Create( conabp: TADOConnection; const schulfrm: string );
{$ENDIF}
begin
  FAktivLevel := 0;
  FAufrufendesProgramm := apLUPO;
  CreateMemTables;

  if conabp <> nil then
  begin
    FConABP := conabp;
    FBeratung := true;
  end else
    FBeratung := false;

  FSchulform := schulfrm;
  if FSchulform = 'SB' then
    FSchulform := 'BK'
  else if FSchulform = 'SG' then
    FSchulform := 'GY';


  FEnd_Hj := 1;

  FDauerUnterrichtseinheit := 45;

  slAbiFaecher := TStringList.Create;

  slSekI_JG := TStringList.Create;
  with slSekI_Jg do
  begin
    Add( '5' );
    Add( '6' );
    Add( '7' );
    Add( '8' );
    Add( '9' );
  end;

  slSekII_Jg := TStringList.Create;
  with slSekII_Jg do
  begin
    Add( '10' );
    Add( '11' );
  end;

  slSekII_Spr := TStringList.Create;
  with slSekII_Spr do
  begin
    Add( '0' );
    Add( '1' );
  end;

  FKursZaehler := TKursZaehler.Create;

  FArrayMuKu := TFachHolder.Create;
  FArrayGE := TFachHolder.Create;
  FArraySW := TFachHolder.Create;
  FArrayEinsprachler := TFachHolder.Create;
  FArrayNW := TFachHolder.Create;
  FAbiErgebnisVerwalter := TAbiErgebnisVerwalter.Create;
  slAbiErgebnisListe := TStringList.Create;
  slZwangsFaecher := TStringList.Create;
  FMeldungen := TStringList.Create;
  FBelegMeldungen := TStringList.Create;

  ZweierCombis[1].Abschnitt1 := 3;
  ZweierCombis[1].Abschnitt2 := 4;

  ZweierCombis[2].Abschnitt1 := 4;
  ZweierCombis[2].Abschnitt2 := 5;

  ZweierCombis[3].Abschnitt1 := 5;
  ZweierCombis[3].Abschnitt2 := 6;

  ZweierCombis[4].Abschnitt1 := 3;
  ZweierCombis[4].Abschnitt2 := 5;

  ZweierCombis[5].Abschnitt1 := 4;
  ZweierCombis[5].Abschnitt2 := 6;

  ZweierCombis[6].Abschnitt1 := 3;
  ZweierCombis[6].Abschnitt2 := 6;

  FaecherBelegbarkeitAktualisieren;

end;

destructor TAbiturBelegPruefer.Destroy;
begin
	FreeAndNil( fC0 );
	FreeAndNil( FPX );
  FreeAndNil( FAbiturDaten );
  FreeAndNil( FReliRest );
  FreeAndNil( FReliTemp );
  FreeAndNil( FTemp1 );
  FreeAndNil( FTemp2 );
  FreeAndNil( slSekI_Jg );
  FreeAndNil( slSekII_Jg );
  FreeAndNil( slSekII_Spr );
  FreeAndNil( slAbiFaecher );
  FreeAndNil( slAbiErgebnisListe );
  FreeAndNil( slZwangsFaecher );
  FreeAndNil( FMeldungen );
  FreeAndNil( FBelegMeldungen );

  FKursZaehler.Free;
  FArrayMuKu.Free;
  FArrayGE.Free;
  FArraySW.Free;
  FArrayEinsprachler.Free;
  FArrayNW.Free;
  FAbiErgebnisVerwalter.Free;

end;

procedure TAbiturBelegPruefer.Free;
begin
  if self <> nil then
    Destroy;
end;

procedure TAbiturBelegPruefer.FaecherBelegbarkeitAktualisieren;
begin
  HoleBelegbareFS;
  DurchgehendBelegbareFaecher := HoleDurchgehendBelegbareFaecher;
end;



procedure TAbiturBelegPruefer.CreateMemTables;
begin
	fC0 := TMemTableEh.Create( nil );
	with fC0.FieldDefs do
	begin
		Clear;
		Add( 'LfdNr', ftInteger, 0, false );
		Add( 'Fach_ID', ftInteger, 0, false );
		Add( 'FachStatKrz', ftString, 2, false );
		Add( 'FachStatKrzOrig', ftString, 2, false );
		Add( 'FachInternKrz', ftString, 20, false );
		Add( 'Fachname', ftString, 80, false );
		Add( 'Fachgruppe', ftString, 2, false );
    Add( 'Basisfach', ftString, 2, false );
//    Add( 'Aufgabenbereich', ftString, 5, false );
		Add( 'Unterrichtssprache', ftString, 1, false );
		Add( 'BeginnJahrgang', ftString, 2, false );
		Add( 'SprachenFolge', ftString, 2, false );
    Add( 'Fremdsprache', ftString, 1, false );
		Add( 'Leitfach1Krz', ftString, 20, false );
		Add( 'Leitfach2Krz', ftString, 20, false );
		Add( 'KA_1', ftString, 5 , false );
    Add( 'WS_1', ftSmallInt, 0, false );
		Add( 'KA_2', ftString, 5 , false );
    Add( 'WS_2', ftSmallInt, 0, false );
		Add( 'KA_3', ftString, 5 , false );
    Add( 'WS_3', ftSmallInt, 0, false );
    Add( 'MA_3', ftString, 1, false ); // Markiert
    Add( 'PU_3', ftSmallInt, 0, false ); // Punkte
		Add( 'KA_4', ftString, 5 , false );
    Add( 'WS_4', ftSmallInt, 0, false );
    Add( 'MA_4', ftString, 1, false ); // Markiert
    Add( 'PU_4', ftSmallInt, 0, false ); // Punkte
		Add( 'KA_5', ftString, 5 , false );
    Add( 'WS_5', ftSmallInt, 0, false );
    Add( 'MA_5', ftString, 1, false ); // Markiert
    Add( 'PU_5', ftSmallInt, 0, false ); // Punkte
		Add( 'KA_6', ftString, 5 , false );
    Add( 'WS_6', ftSmallInt, 0, false );
    Add( 'MA_6', ftString, 1, false ); // Markiert
    Add( 'PU_6', ftSmallInt, 0, false ); // Punkte
    Add( 'Abiturfach', ftSmallInt, 0, false );
    Add( 'Multi', ftString, 1, false );
    Add( 'Aufgabenfeld', ftString, 1, false );
    Add( 'MA_FA', ftString, 1, false ); // Markiert für Facharbeit
    Add( 'PU_FA', ftSmallInt, 0, false ); // Punkte
	end;
  fC0.CreateDataset;
  fC0.Open;

	FPX := TMemTableEh.Create( nil );
	with FPX.FieldDefs do
	begin
		Clear;
		Add( 'FachInternKrz', ftString, 20, false );
    Add( 'E1', ftString, 1, false );
    Add( 'E2', ftString, 1, false );
    Add( 'Q1', ftString, 1, false );
    Add( 'Q2', ftString, 1, false );
    Add( 'Q3', ftString, 1, false );
    Add( 'Q4', ftString, 1, false );
  end;
  FPX.CreateDataset;
  FPX.Open;

  FAbiturdaten := TMemTableEh.Create( nil );
	with FAbiturdaten.FieldDefs do
	begin
		Clear;
    Add( 'Fach_ID', ftInteger, 0, false );
    Add( 'Abiturfach', ftInteger, 0, false );
    Add( 'AbiPruefErgebnis', ftInteger, 0, false );
    Add( 'MdlPruefErgebnis', ftInteger, 0, false );
    Add( 'MdlZusatzPruefung', ftString, 1, false );
    Add( 'Berechnung', ftFloat, 0, false );
    Add( 'Fehler', ftInteger, 0 , false );
  end;
  FAbiturdaten.CreateDataset;
  FAbiturdaten.Open;

  FTemp1 := TMemTableEh.Create( nil );
  with FTemp1.FieldDefs do
  begin
    Add( 'Fach', ftString, 20, false );
    Add( 'Abschnitt', ftInteger, 0, false );
    Add( 'Punkte', ftInteger, 0, false );
    Add( 'Wichtung', ftInteger, 0, false );
  end;
  FTemp1.CreateDataset;
  FTemp1.Open;

  FTemp2 := TMemTableEh.Create( nil );
  FTemp2.FieldDefs := FTemp1.FieldDefs;
  FTemp2.CreateDataset;
  FTemp2.Open;

  FReliTemp := TMemTableEh.Create( nil );
  FReliTemp.FieldDefs := FTemp1.FieldDefs;
  FReliTemp.CreateDataset;
  FReliTemp.Open;


  FReliRest := TMemTableEh.Create( nil );
  with FReliRest.FieldDefs do
  begin
    Add( 'Fach', ftString, 20, false );
    Add( 'Punkte_3', ftInteger, 0, false );
    Add( 'Punkte_4', ftInteger, 0, false );
    Add( 'Punkte_5', ftInteger, 0, false );
    Add( 'Punkte_6', ftInteger, 0, false );
    Add( 'PunktSumme', ftInteger, 0, false );
  end;
  FREliRest.CreateDataset;
  FReliRest.Open;

end;



procedure TAbiturBelegPruefer.SetPruefOrd( const po: string );
begin
  FPruefOrd := po;
  if ( FSchulform = 'GY' ) or ( FSchulform = '' ) then
  begin
    FPO_Krz := 'G8';
    FGliederung := 'GY';
  end else if FSchulform = 'GE' then
  begin
    FPO_Krz := 'G8';
    FGliederung := 'GE';
  end else if FSchulform = 'BK' then
  begin
    FGliederung := 'BK';
  end else if FSchulform = 'WB' then
  begin
    if AnsiContainsText( po, 'AG' ) then
      FGliederung := 'AG'
    else
      FGliederung := 'KL';
    FPO_Krz := 'G8';
  end;

  if ( FSchulform = 'GY' ) or ( FSchulform = 'GE' ) then
  begin
    if FPO_Krz = 'G8' then
    begin
      FJg_E := 10;
      FJg_Q_1 := 11;
      FJg_Q_2 := 12;
    end else
    begin
      FJg_E := 11;
      FJg_Q_1 := 12;
      FJg_Q_2 := 13;
    end;
  end else if FSchulform = 'BK' then
  begin
    FJg_E := 11;
    FJg_Q_1 := 12;
    FJg_Q_2 := 13;
  end else if FSchulform = 'WB' then
  begin
    FJg_E := 11;
    FJg_Q_1 := 12;
    FJg_Q_2 := 13;
  end;

end;

function TAbiturBelegPruefer.GetBelegteAbiFaecher: string;
var
  i: integer;
begin
  slAbiFaecher.Sort;
  Result := '';
  for i := 0 to slAbiFaecher.Count - 1 do
    Result := Result + slAbiFaecher[i];
end;

function TAbiturBelegPruefer.HalbjahrText( i: integer ): string;
begin
	if FGliederung <> 'WB' then
	begin
		case i of
		1 : Result := 'EF.1';
		2 : Result := 'EF.2';
		3 : Result := 'Q1.1';
		4 : Result := 'Q1.2';
		5 : Result := 'Q2.1';
		6 : Result := 'Q2.2';
		end;
	end else
	begin
		case i of
		1 : Result := 'I. Sem.';
		2 : Result := 'II. Sem.';
		3 : Result := 'III. Sem.';
		4 : Result := 'IV. Sem.';
		5 : Result := 'V. Sem.';
		6 : Result := 'VI. Sem.';
		end;
	end;

end;


function TAbiturBelegPruefer.GetFehlerVorhanden: boolean;
begin
  Result := FFehlerzahl > 0;
end;

procedure TAbiturBelegPruefer.Initialisieren( const bll_art: char; const bll_pkt: integer );
begin
  FLfdNr := 0;
  fC0.EmptyTable;
  slAbiFaecher.Clear;
  FKursZaehler.Initialisieren;
  FKursZaehler.PX_ist_BLL := bll_art = 'P';
  FAnzahl_FA := 0;
  FPunkte_FA := 0;
  FMarkiert_FA := false;
  FAnzahl_0_Punkte := 0;
  with FAbiturErgebnisse do
  begin
    SummeAnzahlMarkiert := 0;
    SummePunkteMarkiert := 0;

    Punktsumme_I := 0;
    Punktsumme_LK := 0;
    Punktsumme_GK := 0;
    Kurszahl_I := 0;
    Kurszahl_I_LK := 0;
    Kurszahl_I_GK := 0;
    Kurszahl_I_0_Pkt := 0;
    LK_Defizite_I := 0;
    Defizite_I := 0;
    Durchschnitt_I := 0;
    Farbe_Anzahl_I := C_OK_FARBE;
    Farbe_LK_Defizite_I := C_OK_FARBE;
    Farbe_Defizite_I := C_OK_FARBE;
    Farbe_Punktsumme_I := C_OK_FARBE;

    Punktsumme_II := 0;
    LK_Defizite_II := 0;
    Defizite_II := 0;
    Durchschnitt_II := 0;
    Farbe_LK_Defizite_II := C_OK_FARBE;
    Farbe_Defizite_II := C_OK_FARBE;
    Farbe_Punktsumme_II := C_OK_FARBE;

    Punktsumme_Abi := 0;
    Durchschnitt_Abi := 0;
    Abiturnote := 0;
    Punktabstand_Besser := 0;
    Punktabstand_Schlechter := 0;

    Zulassung := false;
    Bestehenspruefung := false;
    Abweichungspruefung := false;
    AbweichungspruefungOhnePunkte := false;
    LeistungenVollstaendig := false;
    Ergebnisse := [];
  end;
  FSchueler.BLL_Punkte := bll_pkt;
  FSchueler.BLL_Art := bll_art;
  if not( ( FSchueler.BLL_Art = 'P' ) or ( FSchueler.BLL_Art = 'E' ) ) then
    FSchueler.BLL_Art := 'K';
  FAbiturDaten.EmptyTable;
end;


function TAbiturBelegPruefer.StatKrzInMenge( const statkrz, menge: string ): boolean;
var
  i: integer;
  fkrz, skrz: string;
begin
  for i := 1 to AnzahlElemente( menge ) do
  begin
    fkrz := EinzelElement( menge, i );
    skrz := StatistikKuerzel( fkrz );
    Result := skrz = statkrz;
    if Result then
      exit;
  end;
end;


function TAbiturBelegPruefer.SpracheAusSekI ( const stkrz: string ): boolean;
begin
  Result := ( length( stkrz ) = 2 ) and ( slSekI_Jg.IndexOf( stkrz[2] ) >= 0 );
end;

function TAbiturBelegPruefer.SpracheAusSekII ( const stkrz: string ): boolean;
begin
  Result := ( length( stkrz ) = 2 ) and ( slSekII_Spr.IndexOf( stkrz[2] ) >= 0 );
end;


function TAbiturBelegPruefer.Beginn_IstSekI_Jg ( jg: string ): boolean;
begin
  Result := false;
  if jg = '' then
    exit;
  if jg[1] = '0' then
    jg := StringReplace( jg, '0', '', [] );
  Result := slSekI_Jg.IndexOf( jg ) >= 0;
end;

function TAbiturBelegPruefer.Beginn_IstSekII_Jg ( const jg: string ): boolean;
begin
  Result := slSekII_Jg.IndexOf( jg ) >= 0;
end;

function TAbiturBelegPruefer.W6_mit_anderer_FS_als( const faecher: string ): string;
var
  i, j: integer;
  tmp, fs_fach, fach, uspr, fremdsprachen, fs_faecher: string;
begin
  Result := '';
  fremdsprachen := Vereinigungsmenge( W1_2, W1_3 ); // die eigentlichen FS-Fächer
  tmp := '';
  for i := 1 to AnzahlElemente( fremdsprachen ) do
  begin
    fach := EinzelElement( fremdsprachen, i );
    ZuMengeHinzu( tmp, Fremdsprachen_Suffix_Ermitteln( fach ) );
  end;
  fremdsprachen := tmp;

  fs_faecher := Schnittmenge( faecher, fremdsprachen ); // die Fremdsprachen in der Menge

  for i := 1 to AnzahlElemente( fs_faecher ) do
  begin
    fs_fach := EinzelElement( fs_faecher, i );
    for j := 1 to AnzahlElemente( W6 ) do
    begin
      fach := EinzelElement( W6, j );
      uspr := Unterrichtssprache( fach );
  // Nur hinzufügen, wenn die Unterrichtssprache des Schfaches ein andere ist als die der Fremdsprache
      if ( uspr <> 'D' ) and ( uspr <> copy( fs_fach,1, 1 ) ) then
        ZuMengeHinzu( Result, fach );
    end;
  end;
end;

function TAbiturBelegPruefer.Fremdsprachen_Suffix_Ermitteln( const faecher: string ): string;
var
  i: integer;
  fach, statkrz: string;
begin
  Result := '';
  if faecher = '' then
    exit;

  for i := 1 to AnzahlElemente( faecher ) do
  begin
    fach := EinzelElement( faecher, i );
    statkrz := StatistikKuerzel( fach );
    ZuMengeHinzu( Result, copy( statkrz, 1, 1 ) );
  end;

end;


function TAbiturBelegPruefer.FeldWertIDs( Tabelle: TDataset; Feld, Wert: string; WertLaenge: integer ): string;
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


procedure TAbiturBelegPruefer.SetzeSchuelerdaten( const s_id: integer; const s1_2fs_manuell: boolean; const s1_spr, s1_spr_5_6, s1_spr_8, s1_sprfaecher_5_6, s1_sprfaecher_8,
                            biling_zweig: string; const spp, sportattest: boolean; const lateinbeg: string );
begin
  FSchueler.ID := s_id;
  FSchueler.SPP := spp;
  FSchueler.LateinBeginn := lateinbeg;
  FSchueler.Sportbefreit := sportattest;
  if biling_zweig <> '' then
    FSchueler.BilingualerZweig := biling_zweig
  else
    FSchueler.BilingualerZweig := '-';
  FSchueler.S1_Sprachen := s1_spr;
  FSchueler.S1_Sprachen_5_6 := s1_spr_5_6;
  FSchueler.S1_Sprachen_8 := s1_spr_8;
  FSchueler.S1_Sprachfaecher_5_6 := s1_sprfaecher_5_6;
  FSchueler.S1_Sprachfaecher_8 := s1_sprfaecher_8;
  FSchueler.FS2_SekI_manuell := s1_2fs_manuell;
  FSChueler.Einsprachler := ( AnzahlElemente( s1_spr ) <= 1 ) and not s1_2fs_manuell;
end;

procedure TAbiturBelegPruefer.SetzeWeitereSchuelerdaten( const konf: string );
begin
  FSchueler.Konfession := konf;
end;

function TAbiturBelegPruefer.FachHinzu( const fach_id: integer;
                                        const statkrz, internkrz, fachname, fachgruppe, usprache, fsprache, sprfolge, leitfach1, leitfach2, beginn_jg: string;
                                        const ka_e1, ka_e2, ka_q1, ka_q2, ka_q3, ka_q4: string;
                                        const E1_WStd, E2_WStd, Q_WStd, abifach: integer;
                                        pkt_q1, pkt_q2, pkt_q3, pkt_q4: string;
                                        const m_q1: boolean = false;
                                        const m_q2: boolean = false;
                                        const m_q3: boolean = false;
                                        const m_q4: boolean = false;
                                        const m_fa: boolean = false;
                                        const aufgabenfeld: string = '';
                                        const pkt_fa: string = '';
                                        const w_q1: integer = 0;
                                        const w_q2: integer = 0;
                                        const w_q3: integer = 0;
                                        const w_q4: integer = 0 ): boolean;

  function KursartUmsetzer( const ka: string ): string;
  begin
    Result := ka;
    if Result = 'S' then
      Result := 'GKS'
    else if Result = 'M' then
      Result := 'GKM'
    else if Result = 'V' then
      Result := 'VTF';
  end;

  function FachStunden( const hj: integer ): integer;
  var
    statkrz, fachkrz: string;
  begin
    with FC0 do
    begin
      statkrz := FieldByName( 'FachStatKrz' ).AsString;
      fachkrz := FieldByName( 'FachInternKrz' ).AsString;
      if FSchulform = 'WB' then
      begin
  // Beginn Sonderbehandlung für Weiterbildungskolleg
        if hj in [ 1, 2 ] then
        begin // E-Phase
          if statkrz = 'D' then
            Result := 4   // Deutsch
          else if statkrz = 'M' then
            Result := 4   // Mathematik
          else if statkrz = C_VERTIEFUNGSKURS then
            Result := 2
          else if statkrz = C_PROJEKTKURS then
            Result := 2
    // Falls explizite Wochenstunden angegeben sind
          else if ( hj = 1 ) and ( E1_WStd > 0 ) then
            Result := E1_WStd
          else if ( hj = 2 ) and ( E2_WStd > 0 ) then
            Result := E2_WStd
          else if ( FieldByname( 'Fremdsprache' ).AsString = '+' ) and Beginn_IstSekII_Jg( FieldByname( 'BeginnJahrgang' ).AsString ) then
            Result := 6    // neu einsetzende FS
          else if ( FieldByname( 'Fremdsprache' ).AsString = '+' ) and Beginn_IstSekI_Jg( FieldByname( 'BeginnJahrgang' ).AsString ) then
            Result := 4    // fortgeführte FS
          else
            Result := 2;  // alle anderen
        end else
        begin // Q-Phase
          if ( FieldByname( 'Fremdsprache' ).AsString = '+' ) and Beginn_IstSekII_Jg( FieldByname( 'BeginnJahrgang' ).AsString ) then
          begin  // Neu einsezende FS, laut PPT nicht festgelegt
            if Q_WStd > 0 then
              Result := Q_Wstd
            else
              Result := 3;
          end else if copy( FieldByName( Format( 'KA_%d', [hj] ) ).AsString, 1, 2 ) = 'GK' then
          begin
            if statkrz = 'D' then
              Result := 3    // Deutsch
            else if statkrz = 'M' then
              Result := 3   // Mathematik
            else if ( FieldByname( 'Fremdsprache' ).AsString = '+' ) and Ist_Erste_FS( fachkrz ) then
            begin
              if Q_WStd > 0 then
                Result := Q_WStd
              else
                Result := 3;
            end else // alle anderen GK sind entweder 2 WSt. oder die eingestellte Anzahl
            begin
              if Q_WStd > 0 then
                Result := Q_WStd
              else
                Result := 2;
            end;
          end else if FieldByName( Format( 'KA_%d', [hj] ) ).AsString = 'LK' then
            Result := 5
          else if statkrz = C_VERTIEFUNGSKURS then
            Result := 2
          else if statkrz = C_PROJEKTKURS then
            Result := 2
          else if ( Q_WStd > 0 ) then
            Result := Q_WStd
          else
            Result := 2;  // alle anderen
        end;
      end else
      begin
        if FieldByName( Format( 'KA_%d', [hj] ) ).AsString = 'LK' then
          Result := 5
        else if statkrz = C_VERTIEFUNGSKURS then
          Result := 2
        else if statkrz = C_PROJEKTKURS then
        begin
          if Q_WStd > 0 then
            Result := Q_Wstd
          else
            Result := 2;
        end else if ( FieldByname( 'Fremdsprache' ).AsString = '+' ) and Beginn_IstSekII_Jg( FieldByname( 'BeginnJahrgang' ).AsString ) then
          Result := 4    // neu einsetzende FS
        else
          Result := 3;
      end;
    end;
  end;

var
  ka, beg_jg: string;
  i: integer;
  stkrz, fachgr: string;
  bel: boolean;
begin
  if ( ka_e1 = '' ) and ( ka_e2 = '' ) and ( ka_q1 = '' ) and ( ka_q2 = '' ) and ( ka_q3 = '' ) and ( ka_q4 = '' ) then
    exit;

  if fachgruppe = 'SP' then
    stkrz := 'SP' // wegen S3 und S4
  else if ( fachgruppe = 'RE' ) and not FFuerAbitur then
    stkrz := 'RE'
  else
    stkrz := statkrz;

  FKursZaehler.FachHinzu( stkrz, abifach,
                          KursartUmsetzer( AnsiUpperCase( ka_e1 ) ),
                          KursartUmsetzer( AnsiUpperCase( ka_e2 ) ),
                          KursartUmsetzer( AnsiUpperCase( ka_q1 ) ),
                          KursartUmsetzer( AnsiUpperCase( ka_q2 ) ),
                          KursartUmsetzer( AnsiUpperCase( ka_q3 ) ),
                          KursartUmsetzer( AnsiUpperCase( ka_q4 ) ) );

  if FFuerAbitur and ( fsprache <> '+' ) then
    if ( ka_q1 = '' ) and ( ka_q2 = '' ) and ( ka_q3 = '' ) and ( ka_q4 = '' ) then
      exit;

  if ( FSchulform = 'BK' ) then
  begin // Bei BK wird ZK oft "missbraucht" für Kurse, die kein
    if ( ka_q1 = 'ZK' ) or ( ka_q2 = 'ZK' ) or ( ka_q3 = 'ZK' ) or ( ka_q4 = 'ZK' ) then
      exit;
  end;

  if ( ka_q1 = 'VTF' ) or ( ka_q2 = 'VTF' ) or ( ka_q3 = 'VTF' ) or ( ka_q4 = 'VTF' ) then
    stkrz := C_VERTIEFUNGSKURS;

  if stkrz = C_VERTIEFUNGSKURS then
    fachgr := C_VERTIEFUNGSKURS
  else if stkrz = C_PROJEKTKURS then
    fachgr := C_PROJEKTKURS
  else
    fachgr := fachgruppe;

  beg_jg := beginn_jg;

  with fC0 do
  begin
    Append;
    inc( FLfdNr );
    FieldByname( 'LfdNr' ).AsInteger := FLfdNr;
    FieldByname( 'Fach_ID' ).AsInteger := fach_id;
    FieldByname( 'FachStatKrzOrig' ).AsString := AnsiUpperCase( statkrz ); // brauchen wir, um hinterher zurückzufinden
    if ( ( fsprache = '+' ) or ( fsprache = 'J' ) ) and ( length( stkrz ) > 1 ) then
    begin // prüfen, ob korrektes Statistik-Kürzel
      if FPO_Krz = 'G8' then
      begin
        if stkrz[2] = '1' then
          stkrz[2] := '0';
      end else
      begin
        if stkrz[2] = '0' then
          stkrz[2] := '1';
      end;
    end;
//    if AnsiSameText( stkrz, 'S3' ) or AnsiSameText( stkrz, 'S4' ) then
//      stkrz := 'SP';
    FieldByname( 'FachStatKrz' ).AsString := AnsiUpperCase( stkrz );
    FieldByname( 'FachInternKrz' ).AsString := internkrz;
    FieldByname( 'Fachname' ).AsString := fachname;
    FieldByname( 'Fachgruppe' ).AsString := fachgr;
    FieldByname( 'Leitfach1Krz' ).AsString := leitfach1;
    FieldByname( 'Leitfach2Krz' ).AsString := leitfach2;
    if usprache = '' then
      FieldByname( 'Unterrichtssprache' ).AsString := 'D'
    else
      FieldByname( 'Unterrichtssprache' ).AsString := usprache;
    if ( fsprache = '+' ) or ( fsprache = 'J' ) then
      FieldByname( 'Fremdsprache' ).AsString := '+'
    else
      FieldByname( 'Fremdsprache' ).AsString := '-';
    if FieldByname( 'Fremdsprache' ).AsString = '+' then
    begin
      FieldByname( 'Basisfach' ).AsString := stkrz[1];
      if beg_jg <> ''  then
      begin
        if FSchulform = 'WB' then
        begin
          if sprfolge = '1' then
            beg_jg := '05'
          else if ( sprfolge = 'N' ) or ( sprfolge = 'P' ) or ( sprfolge = '2' ) then
            beg_jg := '11'
          else if beg_jg = '1' then
            beg_jg := '5'
        end else
        begin
          if AnsiContainsText( beg_jg, '3' ) or AnsiContainsText( beg_jg, '4' ) then
            beg_jg := '5';
        end;

        if length( beg_jg ) = 1 then
          FieldByname( 'BeginnJahrgang' ).AsString := '0' + beg_jg
        else
          FieldByname( 'BeginnJahrgang' ).AsString := beg_jg;
      end else
      begin // Wenn kein Sprachbeginn angegeben, prüfe ob er sich aus Fachbezeichnung ergibt
        if SpracheAusSekI( stkrz ) then
          FieldByname( 'BeginnJahrgang' ).AsString := '0' + stkrz[2]
        else if SpracheAusSekII( stkrz ) then
          FieldByname( 'BeginnJahrgang' ).AsString := '1' + stkrz[2]
        else // Kein Sprachbeginn aus Statistik-Kürzel feststellbar, Sprache ist aber belegt, als muss der Beginn bei G9-Schülern in 11, sonst in 10 liegen
        begin
          if FSchulform = 'WB' then
            FieldByname( 'BeginnJahrgang' ).AsString := '11'
          else
            FieldByname( 'BeginnJahrgang' ).AsString := '10';
        end;
      end;
      if Trim( sprfolge ) <> '' then
        FieldByname( 'Sprachenfolge' ).AsString := sprfolge;
    end else
      FieldByname( 'Basisfach' ).AsString := stkrz;

    if pkt_q1 <> '' then
      try
        FieldByname( 'PU_3' ).AsInteger := StrToInt( pkt_q1 );
        if FieldByname( 'PU_3' ).AsInteger = 0 then
          inc( FAnzahl_0_Punkte );
      except
      end;
    if pkt_q2 <> '' then
      try
        FieldByname( 'PU_4' ).AsInteger := StrToInt( pkt_q2 );
        if FieldByname( 'PU_4' ).AsInteger = 0 then
          inc( FAnzahl_0_Punkte );
      except
      end;

    if pkt_q3 <> '' then
      try
        FieldByname( 'PU_5' ).AsInteger := StrToInt( pkt_q3 );
        if FieldByname( 'PU_5' ).AsInteger = 0 then
          inc( FAnzahl_0_Punkte );
      except
      end;

    if pkt_q4 <> '' then
      try
        FieldByname( 'PU_6' ).AsInteger := StrToInt( pkt_q4 );
        if FieldByname( 'PU_6' ).AsInteger = 0 then
          inc( FAnzahl_0_Punkte );
      except
      end;

    if pkt_fa <> '' then
      try
        FieldByname( 'PU_FA' ).AsInteger := StrToInt( pkt_fa );
        if FieldByname( 'PU_FA' ).AsInteger > 0 then
        begin
          inc( FAnzahl_FA );
          FPunkte_FA := FieldByname( 'PU_FA' ).AsInteger;
        end;
      except
      end;

    ka := KursartUmsetzer( AnsiUpperCase( ka_e1 ) );
    FieldByname( 'KA_1' ).AsString := ka;

    ka := KursartUmsetzer( AnsiUpperCase( ka_e2 ) );
    FieldByname( 'KA_2' ).AsString := ka;

    ka := KursartUmsetzer( AnsiUpperCase( ka_q1 ) );
{    if FSchulform = 'BK' then
      bel := GueltigePunktzahlNichtLeer( pkt_q1 )
    else}
      bel := true;
    if bel then
      FieldByname( 'KA_3' ).AsString := ka;

    ka := KursartUmsetzer( AnsiUpperCase( ka_q2 ) );
{    if FSchulform = 'BK' then
      bel := GueltigePunktzahlNichtLeer( pkt_q2 )
    else}
      bel := true;
    if bel then
      FieldByname( 'KA_4' ).AsString := ka;

    ka := KursartUmsetzer( AnsiUpperCase( ka_q3 ) );
{   if FSchulform = 'BK' then
      bel := GueltigePunktzahlNichtLeer( pkt_q3 )
    else}
      bel := true;
    if bel then
      FieldByname( 'KA_5' ).AsString := ka;

    ka := KursartUmsetzer( AnsiUpperCase( ka_q4 ) );
{   if FSchulform = 'BK' then
      bel := GueltigePunktzahlNichtLeer( pkt_q4 )
    else}
      bel := true;
    if bel then
      FieldByname( 'KA_6' ).AsString := ka;

    if FSchulform = 'WB' then
    begin
      for i := C_E1 to C_E2 do
      begin // Bei WBK in E-Phase die Standards nehmen
        if Trim( FieldByName( Format( 'KA_%d', [i] ) ).AsString ) <> '' then
            FieldByName( Format( 'WS_%d', [i] ) ).AsInteger := FachStunden( i );
      end;
      if Trim( FieldByName( 'KA_3' ).AsString ) <> '' then
      begin
        if w_q1 > 0 then
          FieldByName( 'WS_3' ).AsInteger := w_q1
        else
          FieldByName( 'WS_3' ).AsInteger := FachStunden( C_Q1 );
      end;
      if Trim( FieldByName( 'KA_4' ).AsString ) <> '' then
      begin
        if w_q2 > 0 then
          FieldByName( 'WS_4' ).AsInteger := w_q2
        else
          FieldByName( 'WS_4' ).AsInteger := FachStunden( C_Q2 );
      end;
      if Trim( FieldByName( 'KA_5' ).AsString ) <> '' then
      begin
        if w_q3 > 0 then
          FieldByName( 'WS_5' ).AsInteger := w_q3
        else
          FieldByName( 'WS_5' ).AsInteger := FachStunden( C_Q3 );
      end;
      if Trim( FieldByName( 'KA_6' ).AsString ) <> '' then
      begin
        if w_q4 > 0 then
          FieldByName( 'WS_6' ).AsInteger := w_q4
        else
          FieldByName( 'WS_6' ).AsInteger := FachStunden( C_Q4 );
      end;

    end else
    begin
// Bei allen anderen SchuHier werden immer die Standard-Wochenstunden genommen
      for i := C_E1 to C_Q4 do
      begin
        if Trim( FieldByName( Format( 'KA_%d', [i] ) ).AsString ) <> '' then
            FieldByName( Format( 'WS_%d', [i] ) ).AsInteger := FachStunden( i );
      end;
    end;

    FieldByname( 'Abiturfach' ).AsInteger := abifach;
    if abifach > 0 then
      slAbiFaecher.Add( IntToStr( abifach ) );
    FieldByname( 'Multi' ).AsString := '-';

    if m_q1 then
      FieldByname( 'MA_3' ).AsString := '+'
    else
      FieldByname( 'MA_3' ).AsString := '-';
    if m_q2 then
      FieldByname( 'MA_4' ).AsString := '+'
    else
      FieldByname( 'MA_4' ).AsString := '-';
    if m_q3 then
      FieldByname( 'MA_5' ).AsString := '+'
    else
      FieldByname( 'MA_5' ).AsString := '-';
    if m_q4 then
      FieldByname( 'MA_6' ).AsString := '+'
    else
      FieldByname( 'MA_6' ).AsString := '-';

// Markierung für Facharbeit im BK
    if m_fa and ( pkt_fa <> '' ) then
    begin
      FieldByname( 'MA_FA' ).AsString := '+';
      FMarkiert_FA := true;
    end else
      FieldByname( 'MA_FA' ).AsString := '-';


    if AnsiUpperCase( stkrz ) = C_PROJEKTKURS then
    begin
      if ( pkt_q4 <> '' ) and ( pkt_q3 = '' ) then
      begin
        pkt_q3 := pkt_q4;
//        FBLL_Punkte := PunktZahlNum( pkt_q4 );
      end else if ( pkt_q3 <> '' ) and ( pkt_q3 = '' ) then
      begin
        pkt_q2 := pkt_q3;
//        FBLL_Punkte := PunktZahlNum( pkt_q3 );
      end else if ( pkt_q2 <> '' ) and ( pkt_q1 = '' ) then
      begin
        pkt_q1 := pkt_q2;
//        FBLL_Punkte := PunktZahlNum( pkt_q2 );
      end;
    end;


    if aufgabenfeld <> '' then
      FieldByname( 'Aufgabenfeld' ).AsString := aufgabenfeld;

    Post;
  end;
  Result := true;
end;

function TAbiturBelegPruefer.FachAbiPunktSumme( const fach_id: integer; const Leer_wie_0: boolean = false ): integer;
var
  abif: integer;
begin
  with FAbiturDaten do
  begin
    if FieldByName( 'Fach_ID' ).AsInteger <> fach_id then
      Locate( 'Fach_ID', fach_id, [] );
    abif := FieldByname( 'AbiturFach' ).AsInteger;
    if ( abif in [ 1, 2, 3 ] ) then
    begin
      if FSchueler.BLL_Art = 'K' then
      begin // keine BLL
        if not leer_wie_0 then
        begin
          if not FieldByname( 'MdlPruefErgebnis' ).IsNull then
            Result := Trunc (Runden( 5*( 2*FieldByName( 'AbiPruefErgebnis' ).AsInteger + FieldByName( 'MdlPruefErgebnis' ).AsInteger ) / 3 ) )
          else
            Result := 5*FieldByName( 'AbiPruefErgebnis' ).AsInteger;
        end else
          Result := Trunc( Runden( 5*( 2*FieldByName( 'AbiPruefErgebnis' ).AsInteger + FieldByName( 'MdlPruefErgebnis' ).AsInteger ) / 3 ) );
      end else
      begin // BLL
        if not leer_wie_0 then
        begin
          if not FieldByname( 'MdlPruefErgebnis' ).IsNull then
            Result := Trunc( Runden( 4*( 2*FieldByName( 'AbiPruefErgebnis' ).AsInteger + FieldByName( 'MdlPruefErgebnis' ).AsInteger ) / 3 ) )
          else
            Result := 4*FieldByName( 'AbiPruefErgebnis' ).AsInteger;
        end else
          Result := Trunc( Runden( 4*( 2*FieldByName( 'AbiPruefErgebnis' ).AsInteger + FieldByName( 'MdlPruefErgebnis' ).AsInteger ) / 3 ) );
      end;
    end else if abif = 4 then
    begin
      if FSchueler.BLL_Art = 'K' then // keine BLL
        Result := 5*FieldByName( 'AbiPruefErgebnis' ).AsInteger
      else
        Result := 4*FieldByName( 'AbiPruefErgebnis' ).AsInteger;
    end;
  end;
end;


function TAbiturBelegPruefer.AbiturdatenHinzu( const fach_id, abiturfach, abiprueferg, mdlprueferg: integer ): boolean;
begin
  if not abiturfach in [1,2,3,4] then
    exit;
  with FAbiturDaten do
  begin
    Append;
    FieldByName( 'Fach_ID' ).AsInteger := fach_id;
    FieldByName( 'AbiturFach' ).AsInteger := abiturfach;
    FieldByname( 'Fehler' ).AsInteger := 0;
    if abiprueferg >= 0 then
      FieldByName( 'AbiPruefErgebnis' ).AsInteger := abiprueferg
    else
      FieldByname( 'Fehler' ).AsInteger := 1;

    if mdlprueferg >= 0 then
      FieldByName( 'MdlPruefErgebnis' ).AsInteger := mdlprueferg;

    FieldByname( 'MdlZusatzPruefung' ).AsString := '';
    Post;

//b) Die einzelnen evtl. mit der Abweichungsprüfung berechneten Prüfungsergebnisse aus dem Abitur werden zunächst abgerundet und dann das abgerundete Einzelergebnis mit dem Faktor 4 bzw. 5 multipliziert.
    Edit;
    if FieldByname( 'Fehler' ).AsInteger = 0 then
      FieldByname( 'Berechnung' ).AsFloat := FachAbiPunktSumme( fach_id )
    else
      FieldByname( 'Berechnung' ).AsFloat := -1;
    Post;
  end;
end;


function TAbiturBelegPruefer.HoleDurchgehendBelegbareFaecher: string;

{$IFDEF UNIDAC}
  function HoleFaecher_LuPO: string;
  var
    qry: TUniQuery;
    cmd: string;
  begin
    Result := '';
    FPX.EmptyTable;
    cmd := 'select * from ABP_Faecher';
    qry := CreateReadOnlyDataset( FConABP );
    try
      with qry do
      begin
        SQL.Text := cmd;
        Open;
        while not Eof do
        begin
          if ( FieldByname( 'E1' ).AsString = 'J' ) and
             ( FieldByname( 'E2' ).AsString = 'J' ) and
             ( FieldByname( 'Q1' ).AsString = 'J' ) and
             ( FieldByname( 'Q2' ).AsString = 'J' ) and
             ( FieldByname( 'Q3' ).AsString = 'J' ) and
             ( FieldByname( 'Q4' ).AsString = 'J' ) then
          begin
            if Result <> '' then
              Result := Result + ';';
            Result := Result + FieldByname( 'FachKrz' ).AsString;
          end;
          if FieldByname( 'StatistikKrz' ).AsString = 'PX' then
          begin
            FPX.Append;
            FPX.FieldByName( 'FachInternKrz' ).AsString := FieldByname( 'FachKrz' ).AsString;
            FPX.FieldByName( 'E1' ).AsString := FieldByname( 'E1' ).AsString;
            FPX.FieldByName( 'E2' ).AsString := FieldByname( 'E2' ).AsString;
            FPX.FieldByName( 'Q1' ).AsString := FieldByname( 'Q1' ).AsString;
            FPX.FieldByName( 'Q2' ).AsString := FieldByname( 'Q2' ).AsString;
            FPX.FieldByName( 'Q3' ).AsString := FieldByname( 'Q3' ).AsString;
            FPX.FieldByName( 'Q4' ).AsString := FieldByname( 'Q4' ).AsString;
            FPX.Post;
          end;
          Next;
        end;
      end;
    finally
      qry.Close;
      FreeAndNil( qry );
    end;
  end;
{$ELSE}

// ADO

  function HoleFaecher_LuPO: string;
  var
    qry: TBetterADODataset;
    cmd: string;
  begin
    cmd := Format( 'select * from ABP_Faecher where IstSprache=%s', [ QuotedStr( 'J' ) ] );
    qry := CreateReadOnlyDataset( FConABP, false );
    try
      with qry do
      begin
        CommandText := cmd;
        Open;
        while not Eof do
        begin
          if ( FieldByname( 'E1' ).AsString = 'J' ) and
             ( FieldByname( 'E2' ).AsString = 'J' ) and
             ( FieldByname( 'Q1' ).AsString = 'J' ) and
             ( FieldByname( 'Q2' ).AsString = 'J' ) and
             ( FieldByname( 'Q3' ).AsString = 'J' ) and
             ( FieldByname( 'Q4' ).AsString = 'J' ) then
          begin
            if Result <> '' then
              Result := Result + ';';
            Result := Result + FieldByname( 'FachKrz' ).AsString;
          end;
          Next;
        end;
      end;
    finally
      qry.Close;
      FreeAndNil( qry );
    end;
  end;
{$ENDIF}

  function HoleFaecher_Schild: string;
  begin
// Wenn der Aufruf aus SchILD kommt, ist alles schon gelaufen, d.h. SchILD schaut in die Vergangenheit,
// die betreffende Prüfung, in der FS_Durchg benötigt wird, findet in SchILD gar nicht statt

    Result := '';
  end;

begin
  if FBeratung then
    Result := HoleFaecher_LuPO
  else
    Result := HoleFaecher_Schild;
end;


procedure TAbiturBelegPruefer.HoleBelegbareFS;

{$IFDEF UNIDAC}
  procedure HoleBelegbareFS_LuPO;
  var
    qry: TUniQuery;
    cmd: string;
  begin
    FS_Durchg := '';
    FS_EBelegbar := '';
    FS_E11_Q11_Belegbar := '';
    cmd := Format( 'select * from ABP_Faecher where IstSprache=%s', [ QuotedStr( 'J' ) ] );
    qry := TUniQuery.Create( nil );
    try
      qry.Connection := FConABP;
      with qry do
      begin
        SQL.Text := cmd;
        Open;
        while not Eof do
        begin
          if ( FieldByname( 'E1' ).AsString = 'J' ) and
             ( FieldByname( 'E2' ).AsString = 'J' ) then
    			  ZuMengeHinzu( FS_EBelegbar, FieldByname( 'FachKrz' ).AsString );

          if ( FieldByname( 'E1' ).AsString = 'J' ) and
             ( FieldByname( 'E2' ).AsString = 'J' ) and
             ( FieldByname( 'Q1' ).AsString = 'J' ) and
             ( FieldByname( 'Q2' ).AsString = 'J' ) and
             ( FieldByname( 'Q3' ).AsString = 'J' ) and
             ( FieldByname( 'Q4' ).AsString = 'J' ) then
    			  ZuMengeHinzu( FS_Durchg, FieldByname( 'FachKrz' ).AsString );
          if ( FieldByname( 'E1' ).AsString = 'J' ) and
             ( FieldByname( 'E2' ).AsString = 'J' ) and
             ( FieldByname( 'Q1' ).AsString = 'J' ) then
    			  ZuMengeHinzu( FS_E11_Q11_Belegbar, FieldByname( 'FachKrz' ).AsString );
          Next;
        end;
      end;
    finally
      qry.Close;
      FreeAndNil( qry );
    end;
  end;

  procedure HoleBelegbareFS_Schild;
  begin
// Wenn der Aufruf aus SchILD kommt, ist alles schon gelaufen, d.h. SchILD schaut in die Vergangenheit,
// die betreffende Prüfung, in der FS_Durchg benötigt wird, findet in SchILD gar nicht statt
    FS_Durchg := '';
  end;

begin
  if FBeratung then
    HoleBelegbareFS_LuPO
  else
    HoleBelegbareFS_Schild;
end;

{$ELSE}

// ADO

  procedure HoleBelegbareFS_LuPO;
  var
    qry: TBetterADODataset;
    cmd: string;
  begin
    FS_Durchg := '';
    FS_EBelegbar := '';
    cmd := Format( 'select * from ABP_Faecher where IstSprache=%s', [ QuotedStr( 'J' ) ] );
    qry := TBetterADODataset.Create( nil );
    try
      qry.Connection := FConABP;
      with qry do
      begin
        CommandText := cmd;
        Open;
        while not Eof do
        begin
          if ( FieldByname( 'E1' ).AsString = 'J' ) and
             ( FieldByname( 'E2' ).AsString = 'J' ) then
    			  ZuMengeHinzu( FS_EBelegbar, FieldByname( 'FachKrz' ).AsString );

          if ( FieldByname( 'E1' ).AsString = 'J' ) and
             ( FieldByname( 'E2' ).AsString = 'J' ) and
             ( FieldByname( 'Q1' ).AsString = 'J' ) and
             ( FieldByname( 'Q2' ).AsString = 'J' ) and
             ( FieldByname( 'Q3' ).AsString = 'J' ) and
             ( FieldByname( 'Q4' ).AsString = 'J' ) then
    			  ZuMengeHinzu( FS_Durchg, FieldByname( 'FachKrz' ).AsString );
          if ( FieldByname( 'E1' ).AsString = 'J' ) and
             ( FieldByname( 'E2' ).AsString = 'J' ) and
             ( FieldByname( 'Q1' ).AsString = 'J' ) then
    			  ZuMengeHinzu( FS_E11_Q11_Belegbar, FieldByname( 'FachKrz' ).AsString );
          Next;
        end;
      end;
    finally
      qry.Close;
      FreeAndNil( qry );
    end;
  end;

  procedure HoleBelegbareFS_Schild;
  begin
  // Wenn der Aufruf aus SchILD kommt, ist alles schon gelaufen, d.h. SchILD schaut in die Vergangenheit,
// die betreffende Prüfung, in der FS_Durchg benötigt wird, findet in SchILD gar nicht statt

    FS_Durchg := '';
  end;

begin
  if FBeratung then
    HoleBelegbareFS_LuPO
  else
    HoleBelegbareFS_Schild;
end;
{$ENDIF}

function TAbiturBelegPruefer.IstLK( const fach: string; const hjv, hjb: integer ): boolean;
var
  fn: string;
  i: integer;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  Result := true;
  for i := hjv to hjb do
  begin
    fn := Format( 'KA_%d', [ i ] );
    Result := Result and ( FC0.FieldByName( fn ).AsString = 'LK' );
  end;
end;

function TAbiturBelegPruefer.IstGKS( const fach: string; const hjv, hjb: integer ): boolean;
var
  fn: string;
  i: integer;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  Result := true;
  for i := hjv to hjb do
  begin
    fn := Format( 'KA_%d', [ i ] );
    Result := Result and ( FC0.FieldByName( fn ).AsString = 'GKS' );
  end;
end;

function TAbiturBelegPruefer.IstGK( const fach: string; const hjv, hjb: integer ): boolean;
var
  fn: string;
  i: integer;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  Result := true;
  for i := hjv to hjb do
  begin
    fn := Format( 'KA_%d', [ i ] );
    Result := Result and ( ( FC0.FieldByName( fn ).AsString = 'GKS' ) or ( FC0.FieldByName( fn ).AsString = 'GKM' ) or ( FC0.FieldByName( fn ).AsString = 'ZK' ));
  end;
end;

function TAbiturBelegPruefer.IstZK( const fach: string; const hjv, hjb: integer ): boolean;
var
  fn: string;
  i: integer;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  Result := true;
  for i := hjv to hjb do
  begin
    fn := Format( 'KA_%d', [ i ] );
    Result := Result and ( FC0.FieldByName( fn ).AsString = 'ZK' );
  end;
end;



function TAbiturBelegPruefer.IstAbifach( const fach: string; af: TAbiFaecher ): boolean;
var
  fn: string;
  i: integer;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  Result := FC0.FieldByName( 'Abiturfach' ).AsInteger in af;
end;

function TAbiturBelegPruefer.IstMehrfachAusgepraegt( const fach: string ): boolean;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  Result := FC0.FieldByname( 'Multi' ).AsString = '+';
end;

function TAbiturBelegPruefer.MyLocate( DS: TDataset; const fn: string; const fv: string ): boolean;
var
  cv: string;
begin
  with DS do
  begin
    First;
    while not Eof do
    begin
      cv := FieldByname( fn ).AsString;
      if cv = fv then
      begin
        Result := true;
        exit;
      end;
      Next;
    end;
  end;
  Result := false;
end;

function TAbiturBelegPruefer.IstSchriftlich( const fach: string; const hjv, hjb: integer ): boolean;
var
  fn: string;
  i: integer;
  statkrz, sk: string;
  ist_fs: boolean;
  belegung: string;
  afach, ka: string;
  fnd: boolean;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not fnd then
  begin
    Result := false;
    exit;
  end;
  afach := FC0.FieldByName( 'FachInternKrz' ).AsString;
  Result := true;
  if not IstMehrfachAusgepraegt( afach ) then
  begin
    for i := hjv to hjb do
    begin
      fn := Format( 'KA_%d', [ i ] );
      ka := FC0.FieldByName( fn ).AsString;
      Result := Result and ( ( ka = 'LK' ) or ( ka = 'GKS' ) );
      if FFuerAbitur and ( i >= C_Q1 ) then
        Result := Result and ( Punkte( afach, i ) > 0 );
    end;
    exit;
  end;

  // Neu: hier muss auch berücksichtigt werden, dass in einem biling. SF auch gewechselt werden kann
  statkrz := StatistikKuerzel( fach );
  ist_fs := FC0.FieldByname( 'Fremdsprache' ).AsString = '+';
  if ist_fs then
    statkrz := copy( statkrz, 1, 1 );

  with FC0 do
  begin
    First;
    while not Eof do
    begin
      sk := FieldByName( 'FachStatKrz' ).AsString;
      if FieldByname( 'Fremdsprache' ).AsString = '+' then
        sk := copy( sk, 1, 1);
      if statkrz = sk then
      begin // aus statistischer Sicht sind die Fächer gleich
        for i := hjv to hjb do
        begin
          fn := Format( 'KA_%d', [ i ] );
          fnd := ( FieldByName( fn ).AsString = 'LK' ) or ( FieldByName( fn ).AsString = 'GKS' );
          if fnd and FFuerAbitur and ( i >= C_Q1 ) then
            fnd := ( Punkte( afach, i ) > 0 );
          if fnd then
            ZuMengeHinzu( belegung, IntToStr( i ) );
        end;
      end;
      Next;
    end;
  end;
  Result := true;
  for i := hjv to hjb do
    Result := Result and InMenge( IntToStr( i ), belegung );
end;

function TAbiturBelegPruefer.IstSchriftlich1( const fach: string; const hjv, hjb: integer ): boolean;
var
  fn: string;
  i: integer;
  statkrz, sk: string;
  ist_fs: boolean;
  belegung: string;
  afach: string;
  fnd: boolean;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not fnd then
  begin
    Result := false;
    exit;
  end;
  afach := FC0.FieldByName( 'FachInternKrz' ).AsString;
  Result := true;
  for i := hjv to hjb do
  begin
    fn := Format( 'KA_%d', [ i ] );
    Result := Result and ( ( FC0.FieldByName( fn ).AsString = 'LK' ) or ( FC0.FieldByName( fn ).AsString = 'GKS' ) );
    if FFuerAbitur and ( i >= C_Q1 ) then
      Result := Result and ( Punkte( afach, i ) > 0 );
  end;
end;


function TAbiturBelegPruefer.IstMuendlich( const fach: string; const hjv, hjb: integer ): boolean;
var
  fn: string;
  i: integer;
  statkrz, sk: string;
  ist_fs: boolean;
  belegung: string;
  afach: string;
  fnd: boolean;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not fnd then
  begin
    Result := false;
    exit;
  end;
  afach := FC0.FieldByName( 'FachInternKrz' ).AsString;
  Result := true;
  if not IstMehrfachAusgepraegt( afach ) then
  begin
    for i := hjv to hjb do
    begin
      fn := Format( 'KA_%d', [ i ] );
      Result := Result and ( ( FC0.FieldByName( fn ).AsString <> '' ) and ( FC0.FieldByName( fn ).AsString <> 'LK' ) and ( FC0.FieldByName( fn ).AsString <> 'GKS' ) );
      if FFuerAbitur and ( i >= C_Q1 ) then
        Result := Result and ( Punkte( afach, i ) > 0 );
    end;
    exit;
  end;

  // Neu: hier muss auch berücksichtigt werden, dass in einem biling. SF auch gewechselt werden kann
  statkrz := StatistikKuerzel( fach );
  ist_fs := FC0.FieldByname( 'Fremdsprache' ).AsString = '+';
  if ist_fs then
    statkrz := copy( statkrz, 1, 1 );

  with FC0 do
  begin
    First;
    while not Eof do
    begin
      sk := FieldByName( 'FachStatKrz' ).AsString;
      if FieldByname( 'Fremdsprache' ).AsString = '+' then
        sk := copy( sk, 1, 1);
      if statkrz = sk then
      begin // aus statistischer Sicht sind die Fächer gleich
        for i := hjv to hjb do
        begin
          fn := Format( 'KA_%d', [ i ] );
          fnd := ( FieldByName( fn ).AsString <> '' ) and ( FieldByName( fn ).AsString <> 'LK' ) and ( FieldByName( fn ).AsString <> 'GKS' );
          if fnd and FFuerAbitur and ( i >= C_Q1 ) then
            fnd := ( Punkte( afach, i ) > 0 );
          if fnd then
            ZuMengeHinzu( belegung, IntToStr( i ) );
        end;
      end;
      Next;
    end;
  end;
  Result := true;
  for i := hjv to hjb do
    Result := Result and InMenge( IntToStr( i ), belegung );
end;

function TAbiturBelegPruefer.PXIstBelegbar( const fach: string; const hj: integer ): boolean;
var
  fnd: boolean;
begin
  Result := false;
  if FPX.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FPX.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not fnd then
    exit;

  case hj of
  C_E1: Result := FPX.FieldByname( 'E1' ).AsString = 'J';
  C_E2: Result := FPX.FieldByname( 'E2' ).AsString = 'J';
  C_Q1: Result := FPX.FieldByname( 'Q1' ).AsString = 'J';
  C_Q2: Result := FPX.FieldByname( 'Q2' ).AsString = 'J';
  C_Q3: Result := FPX.FieldByname( 'Q3' ).AsString = 'J';
  C_Q4: Result := FPX.FieldByname( 'Q4' ).AsString = 'J';
  end;
end;

function TAbiturBelegPruefer.IstBelegt( const fach: string; const hjv, hjb: integer; const kursart: string = '' ): boolean;
var
  ka, fn, ka_akt: string;
  i: integer;
  statkrz, sk: string;
  ist_fs: boolean;
  belegung: string;
  fnd, ka_ignore, go_on: boolean;
  do_add: boolean;
  cnt_bel: integer;
begin
  Result := false;
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not fnd then
    exit;

  ka := '';
  if kursart <> '' then
  begin
    ka := copy( kursart, 2, 2 );
    ka_ignore := kursart[1] = '-';
  end;

  cnt_bel := 0;

  if not IstMehrfachAusgepraegt( fach ) then
  begin
    for i := hjv to hjb do
    begin
      fn := Format( 'KA_%d', [ i ] );
      go_on := true;
      if ka <> '' then
      begin
        ka_akt := FC0.FieldByname( Format( 'KA_%d', [ i ] ) ).AsString;
        if ka_akt = '' then
          go_on := false
        else if ka_ignore then
          go_on := ka_akt <> ka
        else
          go_on := ka_akt = ka;
      end;

      if not go_on then
        continue;

      ka_akt := Trim( FC0.FieldByName( fn ).AsString );

      go_on :=  ka_akt <> '';
      if FFuerAbitur and ( i >= C_Q1 ) then
        go_on := go_on and ( ( Punkte( fach, i ) > 0 ) or ( ka_akt = 'AT' ) );
      if go_on then
        inc( cnt_bel );
    end;
    Result := cnt_bel = hjb - hjv + 1;
    exit;
  end;

// Neu: hier muss auch berücksichtigt werden, dass in einem biling. SF auch gewechselt werden kann
  statkrz := StatistikKuerzel( fach );
  ist_fs := FC0.FieldByname( 'Fremdsprache' ).AsString = '+';
  if ist_fs then
    statkrz := copy( statkrz, 1, 1 );

  with FC0 do
  begin
    First;
    while not Eof do
    begin
      sk := FieldByName( 'FachStatKrz' ).AsString;
      if FieldByname( 'Fremdsprache' ).AsString = '+' then
        sk := copy( sk, 1, 1);
      if statkrz = sk then
      begin // aus statistischer Sicht sind die Fächer gleich
        for i := hjv to hjb do
        begin
          go_on := true;
          if ka <> '' then
          begin
            ka_akt := FieldByname( Format( 'KA_%d', [ i ] ) ).AsString;
            if ka_akt = '' then
              go_on := false
            else if ka_ignore then
              go_on := ka_akt <> ka
            else
              go_on := ka_akt = ka;
          end;

          if not go_on then
            continue;

          do_add :=  Trim( FieldByName( Format( 'KA_%d', [ i ] ) ).AsString ) <> '';
          if do_add and FFuerAbitur then
            do_add := ( Punkte( fach, i ) > 0 );
          if do_add then
            ZuMengeHinzu( belegung, IntToStr( i ) );
        end;
      end;
      Next;
    end;
  end;
  Result := true;
  for i := hjv to hjb do
    Result := Result and InMenge( IntToStr( i ), belegung );

{  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [] );
  Result := true;
  for i := hjv to hjb do
  begin
    fn := Format( 'KA_%d', [ i ] );
    Result := Result and ( FC0.FieldByName( fn ).AsString <> '' );
  end;}
//  ShowMessage( FC0.FieldByName( fn ).AsString );
end;

function TAbiturBelegPruefer.IstBelegt1( const fach: string; const hjv, hjb: integer ): boolean;
var
  fn: string;
  i: integer;
  fnd: boolean;
  cnt_bel: integer;
begin
  Result := false;
// Prüft die Belegung ohne Berücksichtigung einer Mehrfachausprägung
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not fnd then
    exit;

  cnt_bel := 0;

  Result := true;
  for i := hjv to hjb do
  begin
    fn := Format( 'KA_%d', [ i ] );
    fnd := Trim( FC0.FieldByName( fn ).AsString ) <> '';
    if fnd and FFuerAbitur and ( i >= C_Q1 ) then
      fnd := ( Punkte( fach, i ) > 0 );
    if fnd then
      inc( cnt_bel );
  end;
  Result := cnt_bel = hjb - hjv + 1;
end;

function TAbiturBelegPruefer.FS_IstBelegt( const fs: string; const hjv, hjb: integer ): boolean;
// fs muss 1-stelliges Statistik-Kürzel sein
var
  belegung, fach, uspr, statkrz, ka: string;
  fn: string;
  i: integer;
begin
  belegung := '------';
  with FC0 do
  begin
    First;
    while not Eof do
    begin
      fach := FieldByname( 'FachInternKrz' ).AsString;
      statkrz := FieldByname( 'FachStatKrz' ).AsString;
      if FieldByName( 'Fremdsprache' ).AsString = '+' then
        statkrz := copy( statkrz, 1, 1 );
      uspr := Unterrichtssprache( fach );
      if ( uspr = fs ) or ( statkrz = fs ) then
      begin
        for i := C_E1 to C_Q4 do
        begin
          fn := Format( 'KA_%d', [ i ] );
          ka := Trim( FC0.FieldByName( fn ).AsString );
          if ka <> '' then
            belegung[i] := '+';
        end;
      end;
      Next;
    end;
  end;
  Result := true;
  for i := hjv to hjb do
    Result := Result and ( belegung[i] = '+' );
end;


function TAbiturBelegPruefer.FS_IstSchriftlich( const fs: string; const hjv, hjb: integer ): boolean;
// fs muss 1-stelliges Statistik-Kürzel sein
var
  schriftlich, fach, uspr, statkrz, ka: string;
  fn: string;
  i: integer;
begin
  schriftlich := '------';
  with FC0 do
  begin
    First;
    while not Eof do
    begin
      fach := FieldByname( 'FachInternKrz' ).AsString;
      statkrz := FieldByname( 'FachStatKrz' ).AsString;
      if FieldByName( 'Fremdsprache' ).AsString = '+' then
        statkrz := copy( statkrz, 1, 1 );
      uspr := Unterrichtssprache( fach );
      if ( uspr = fs ) or ( statkrz = fs ) then
      begin
        for i := C_E1 to C_Q4 do
        begin
          fn := Format( 'KA_%d', [ i ] );
          ka := Trim( FC0.FieldByName( fn ).AsString );
          if ( ka = 'LK' ) or ( ka = 'GKS' ) then
            schriftlich[i] := '+';
        end;
      end;
      Next;
    end;
  end;
  Result := true;
  for i := hjv to hjb do
    Result := Result and ( schriftlich[i] = '+' );
end;



function TAbiturBelegPruefer.IstBelegtPunkte1( const fach: string; const hjv, hjb: integer ): boolean;
var
  fn, spkt: string;
  i, pkt: integer;
  fnd: boolean;
  cnt_bel: integer;
begin
  Result := false;
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not fnd then
    exit;

  cnt_bel := 0;

  for i := hjv to hjb do
  begin
{    if FSchulform = 'BK' then
    begin
      fn := Format( 'PU_%d', [ i ] );
      Result := true;
      try
        spkt := FC0.FieldByName( fn ).AsString;
        pkt := StrToInt( spkt );
        if pkt > 0 then
          inc( cnt_bel );
      except
      end;
    end else}
    begin
      fn := Format( 'KA_%d', [ i ] );
      fnd := Trim( FC0.FieldByName( fn ).AsString ) <> '';
      if i >= C_Q1 then
        fnd := fnd and ( Punkte( fach, i ) > 0 );
      if fnd then
        inc( cnt_bel );
    end;
    if not fnd then
    begin
      Result := false;
      exit;
    end;
  end;
  Result := cnt_bel = hjb - hjv + 1;
end;

function TAbiturBelegPruefer.IstBelegtPunkte( const fach: string; const hjv, hjb: integer; var markier_muster: string; const kursart: string = '' ): boolean;
var
  fn, tmp_muster, ka, ka_akt: string;
  i: integer;
  fnd, bel: boolean;
  px_, ka_ignore, go_on: boolean;
  cnt: integer;
begin
  Result := false;
  tmp_muster := markier_muster;
  px_ := AnsiContainsText( markier_muster, '?' );
// Prüft die Belegung ohne Berücksichtigung einer Mehrfachausprägung
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not fnd then
    exit;

  ka := '';
  if kursart <> '' then
  begin
    ka := copy( kursart, 2, 2 );
    ka_ignore := kursart[1] = '-';
  end;

  cnt := 0;
  for i := hjv to hjb do
  begin
    fn := Format( 'KA_%d', [ i ] );
    go_on := true;
    if  ka <> '' then
    begin // falls eine Kursart eingetragen ist, prüfen, wie zu behandeln
      ka_akt := FC0.FieldByname( fn ).AsString; // die aktuelle Kursart des Faches
      if ka_akt = '' then
        go_on := false
      else if ka_ignore then
        go_on := ka_akt <> ka
      else
        go_on := ka_akt = ka;
    end;
    if not go_on then
      continue;

// Jetzt auf Belegung prüfen
    bel :=  ( Trim( FC0.FieldByName( fn ).AsString ) <> '' );

    if bel then
    begin
// Jetzt die Punktebelegug
//      if not px_ and not bel then
//        exit;
      if Punkte( fach, i ) > 0 then
        inc( cnt );
      if markier_muster <> '' then
      begin
        if ( markier_muster[ i-2 ] = '?' ) then
        begin // Kommt bei Projektkurs vor
          if bel then
          begin
            if Punkte( fach, i ) > 0 then
              markier_muster[ i-2 ] := '+'
            else
              markier_muster[ i-2 ] := '-';
          end;
        end;
      end;
    end;
  end;

  Result := cnt = hjb - hjv + 1;

  if markier_muster = '' then
    exit;

  if px_ then
    Result := markier_muster <> '----';

  exit;

  for i := 1 to length( tmp_muster ) do
  begin
    if ( tmp_muster[i] = '+' ) and ( Punkte( fach, i+2 ) = 0 ) then
      tmp_muster[i] := '-'
    else if ( tmp_muster[i] = '?' ) and ( Punkte( fach, i+2 ) > 0 ) then
      tmp_muster[i] := '+';
  end;

  if AnsiContainsText( markier_muster, '?' ) then
  begin
    markier_muster := tmp_muster;
    if markier_muster = '----' then
      Result := false;
  end else
    Result := tmp_muster = markier_muster;

  if not Result then
    Result := false;

end;

function TAbiturBelegPruefer.IstBelegtPunkteVar( const fach: string ): boolean;
var
  fn1, fn2: string;
  i: integer;
  fnd, bel: boolean;
  p1, p2: integer;
  markier_muster: string;
begin
  Result := false;
  markier_muster := '----';
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not fnd then
    exit;

  Result := true;
  for i := C_Q1 to C_Q3 do
  begin
    fn1 := Format( 'KA_%d', [ i ] );
    fn2 := Format( 'KA_%d', [ i+1 ] );
    bel :=  ( Trim( FC0.FieldByName( fn1 ).AsString ) <> '' ) and  ( Trim( FC0.FieldByName( fn2 ).AsString ) <> '' );
//    Result := Result and bel;
//    if not Result then
//      exit;
// NEU Jan. 2014
    if not bel then
      continue;
    p1 := Punkte( fach, i );
    p2 := Punkte( fach, i+1 );
    if p1*p2 > 0 then
    begin
      markier_muster[i-2] := '+';
      markier_muster[i-1] := '+';
      Result := true;
      exit;
    end;
  end;
end;

function TAbiturBelegPruefer.BeginnZK( const fach: string ): integer;
var
  fnd: boolean;
  i: integer;
begin
  Result := 0;
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not fnd then
    exit;
  for i := C_Q1 to C_Q4 do
  begin
    if FC0.FieldByname( Format( 'KA_%d', [ i ] ) ).AsString = 'ZK' then
    begin
      Result := i;
      exit;
    end;
  end;

end;

function TAbiturBelegPruefer.IstMarkiert( const fach: string; const hj: integer ): boolean;
var
  fnd: boolean;
begin
  Result := false;
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not fnd then
    exit;
  Result := FC0.FieldByname( Format( 'MA_%d', [ hj ] ) ).AsString = '+';
end;


function TAbiturBelegPruefer.AnzahlMarkiert( const fach: string; const hjv, hjb: integer; const kursart: string = '' ): integer;
var
  fn, ka, ka_akt: string;
  i: integer;
  fnd, ka_ignore, go_on: boolean;
begin
  Result := 0;
// Prüfe, wieviel Markierungen für eine Fach vorhanden sind
// Nur zur Markierungsprüfung verwenden
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not AnsiSameText( fach, FC0.FieldByName( 'FachInternKrz' ).AsString ) then
    exit;

  ka := '';
  if kursart <> '' then
  begin
    ka := copy( kursart, 2, 2 );
    ka_ignore := kursart[1] = '-';
  end;

  for i := hjv to hjb do
  begin
    go_on := true;
    if ka <> '' then
    begin
      ka_akt := FC0.FieldByname( Format( 'KA_%d', [ i ] ) ).AsString;
      if ka_akt = '' then
        go_on := false
      else if ka_ignore then
        go_on := ka_akt <> ka
      else
        go_on := ka_akt = ka;
    end;

    if not go_on then
      continue;

    fn := Format( 'MA_%d', [ i ] );
    if Trim( FC0.FieldByName( fn ).AsString ) = '+' then
      inc( Result );
  end;
end;

function TAbiturBelegPruefer.AnzahlNichtMarkiert( const fach: string; const hjv, hjb: integer; const kursart: string = '' ): integer;
var
  fn, ka, ka_akt: string;
  i: integer;
  fnd, ka_ignore, go_on: boolean;
begin
  Result := 0;
// Prüfe, wieviel Markierungen für eine Fach vorhanden sind
// Nur zur Markierungsprüfung verwenden
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not fnd then
    exit;

  ka := '';
  if kursart <> '' then
  begin
    ka := copy( kursart, 2, 2 );
    ka_ignore := kursart[1] = '-';
  end;

  for i := hjv to hjb do
  begin
    go_on := true;
    if ka <> '' then
    begin
      ka_akt := FC0.FieldByname( Format( 'KA_%d', [ i ] ) ).AsString;
      if ka_akt = '' then
        go_on := false
      else if ka_ignore then
        go_on := ka_akt <> ka
      else
        go_on := ka_akt = ka;
    end;

    if not go_on then
      continue;

    fn := Format( 'MA_%d', [ i ] );
    if IstBelegtPunkte1( fach, hjv,hjb ) and ( Trim( FC0.FieldByName( fn ).AsString ) = '-' ) then
      inc( Result );
  end;
end;



function TAbiturBelegPruefer.GesamtWochenstunden( const fach: string; const hjv, hjb: integer ): integer;
var
  fn: string;
  i: integer;
  fnd: boolean;
begin
  Result := 0;
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if not fnd then
    Result := 0;

  for i := hjv to hjb do
  begin
    fn := Format( 'WS_%d', [ i ] );
    Result := Result + FC0.FieldByName( fn ).AsInteger;
  end;

end;


function TAbiturBelegPruefer.FachIn2HjBelegt( const fach: string; hjv, hjb: integer ): boolean;
var
  i: integer;
begin
  Result := false;
  for i := hjv to hjb - 1 do
  begin
    Result := IstBelegt1( fach, i, i + 1 );
    if Result then
      exit;
  end;

end;

function TAbiturBelegPruefer.AnzahlBelegteHalbjahre( const fach: string; const hjv, hjb: integer; const kursart: string = '' ): integer;
var
  fn, afach: string;
  i: integer;
  add: boolean;
  ka, ka_akt: string;
  ka_ignore: boolean;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  Result := 0;
  afach := FC0.FieldByName( 'FachInternKrz' ).AsString;
  ka := '';
  if kursart <> '' then
  begin
    ka := copy( kursart, 2, 2 );
    ka_ignore := kursart[1] = '-';
  end;
  for i := hjv to hjb do
  begin
    fn := Format( 'KA_%d', [ i ] );
    add := ( FC0.FieldByName( fn ).AsString <> '' );
    if add and ( ka <> '' ) then
    begin // falls eine Kursart eingetragen ist, prüfen, wie zu behandeln
      ka_akt := FC0.FieldByname( Format( 'KA_%d', [ i ] ) ).AsString; // die aktuelle Kursart des Faches
      if ka_akt = '' then
        add := false
      else if ka_ignore then
        add := ka_akt <> ka
      else
        add := ka_akt = ka;
    end;

    if add and FFuerAbitur and ( i >= C_Q1 ) then
      add := ( Punkte( afach, i ) > 0 );
    if add then
      inc( Result );
  end;
end;

function TAbiturBelegPruefer.AnzahlBelegtPunkte( const fach: string; const hjv, hjb: integer; const kursart: string = '' ): integer;
var
  fn: string;
  i: integer;
  markier_muster: string;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  Result := 0;
  markier_muster := '';

  for i := hjv to hjb do
  begin
    if IstBelegtPunkte( fach, i, i, markier_muster, kursart ) then
      inc( Result );
  end;
end;

function TAbiturBelegPruefer.Fach_ID_Von( const fach: string ): integer;
begin
  if FC0.FieldByname( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  Result := FC0.FieldByname( 'Fach_ID' ).AsInteger;
end;

function TAbiturBelegPruefer.Fach_IDs_VonGruppe( const gruppe: string ): string;
var
  fach: string;
  i: integer;
begin
  Result := '';
  for i := 1 to AnzahlElemente( gruppe ) do
  begin
    fach := EinzelElement( gruppe, i );
    ZuMengeHinzu( Result, IntToStr( Fach_ID_Von( fach ) ) );
  end;
end;

function TAbiturBelegPruefer.StatistikKuerzel( const fach: string ): string;
begin
  if FC0.FieldByname( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  Result := FC0.FieldByname( 'FachStatKrz' ).AsString;
end;

function TAbiturBelegPruefer.IstFremdsprache( const fach: string ): boolean;
begin
  if fach = '' then
  begin
    Result := false;
    exit;
  end;
  if FC0.FieldByname( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  Result := FC0.FieldByname( 'Fremdsprache' ).AsString = '+';
end;

function TAbiturBelegPruefer.FachKuerzel_aus_ID( const fach_id: integer ): string;
begin
  if FC0.FieldByname( 'Fach_ID' ).AsInteger <> fach_id then
    FC0.Locate( 'Fach_ID', fach_id, [] );
  Result := FC0.FieldByName( 'FachInternKrz' ).AsString;
end;

function TAbiturBelegPruefer.Fachname( const fach: string ): string;
begin
  if FC0.FieldByname( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  Result := FC0.FieldByname( 'FachName' ).AsString;
end;

function TAbiturBelegPruefer.FachGruppe( const fach: string ): string;
begin
  if FC0.FieldByname( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  Result := FC0.FieldByname( 'Fachgruppe' ).AsString;
end;

function TAbiturBelegPruefer.GetAnzahlKurse: integer;
begin
  Result := FKursZaehler.Gesamtzahl;
end;

function TAbiturBelegPruefer.GetAnzahlKurseE: integer;
begin
  Result := FKursZaehler.AnzahlKurseE;
end;

procedure TAbiturBelegPruefer.BelegpruefungFuerAbitur;
begin
  FFEhlerZahl := 0;
  FMeldungen.Clear;
  FBelegMeldungen.Clear;
  GruppenBilden;

{  if DebugHook <> 0 then
  begin
    if FFuerAbitur then
      ShowMessage( Format( 'Für Abitur: %d', [ FC0.RecordCount ] ) )
    else
      ShowMessage( Format( 'Für Belegung: %d', [ FC0.RecordCount ] ) );
  end;}

  if FSchulform = 'WB' then
  begin
    KurseStundenBerechnen;
    Pruefe_Q_Phase_WBK;
  end else if ( FSchulform = 'GY' ) or ( FSchulform = 'GE' ) then
  begin
    KurseStundenBerechnen;
    Pruefe_Q_Phase_GY_GE( C_Q1 );
  end else if ( FSchulform = 'BK' ) then
  begin
    Pruefe_Q_Phase_BK;
  end;

  FAbiErgebnisVerwalter.Reset;
end;

procedure TAbiturBelegPruefer.Ausfuehren;
begin
  FFehlerzahl := 0;
  if FBeratung and Assigned( FConABP ) then
{$IFDEF UNIDAC}
    FConABP.ExecSQL( Format( 'delete from ABP_SchuelerFehlerMeldungen where Schueler_ID=%d', [ FSchueler.ID ] ) );
{$ELSE}
    FConABP.Execute( Format( 'delete from ABP_SchuelerFehlerMeldungen where Schueler_ID=%d', [ FSchueler.ID ] ) );
{$ENDIF}
  GruppenBilden;

{  if DebugHook <> 0 then
  begin
    if FFuerAbitur then
      ShowMessage( Format( 'Für Abitur: %d', [ FC0.RecordCount ] ) )
    else
      ShowMessage( Format( 'Für Belegung: %d', [ FC0.RecordCount ] ) );
  end;}

  if FSchulform = 'WB' then
  begin
    KurseStundenBerechnen;
    if FEnd_Hj < 3 then
      Pruefe_E_Phase_WBK
    else
      Pruefe_Q_Phase_WBK;
  end else
  begin
    KurseStundenBerechnen;
    MehrfachAuspraegungenErmitteln;
    if FEnd_Hj < 3 then
      Pruefe_E_Phase_GY_GE
    else
      Pruefe_Q_Phase_GY_GE( C_E1 );
  end;
end;

procedure TAbiturBelegPruefer.MehrfachAuspraegungenErmitteln;
var
  i: integer;
  fach: string;
  statkrz: string;
  ist_multi: boolean;
begin
// Bei bilingualen Sachfächern kann es vorkommen, dass ein Fach mal in der bilingualen Form,
// dann wieder in der "normalen" Form belegt wird. Das gilt dann auch als belegt. Dazu muss bei der
// Prüfung in IstBelegt und IstSchriftlich bekannt sein, ob ein Fach "mehrfach ausgeprägt" vorkommen kann
  for i := 1 to AnzahlElemente( W6 ) do
  begin // es brauchen nur die biling. Sachfächer betrachtet zu werden
    fach := EinzelElement( W6, i );
    statkrz := StatistikKuerzel( fach );
    with FC0 do
    begin
      First;
      ist_multi := false;
      while not Eof do
      begin
        if ( FieldByName( 'FachInternKrz' ).AsString <> fach ) and
           ( FieldByname( 'FachStatKrz' ).AsString = statkrz ) and
           ( FieldByname( 'Multi' ).AsString = '-' ) then
        begin
          ist_multi := true;
          Edit;
          FieldByname( 'Multi' ).AsString := '+';
          Post;
        end;
        Next;
      end;
      if ist_multi then
      begin // jetzt noch das fach selbst markieren
        Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
        Edit;
        FieldByname( 'Multi' ).AsString := '+';
        Post;
      end;
    end;
  end;
end;

procedure TAbiturBelegPruefer.KurseStundenBerechnen;
var
  i, wstd: integer;
  fn, fach, stkrz, ka: string;
  add_kurse, add_std: boolean;
  pxbel, pxdone: boolean;
begin
// FSummen enthält die Stunden bei ScHILD im schulinternen System, bei LuPO als 45 Minuten-Einheiten
  for i := C_E1 to C_Q4 + 1 do
  begin
    FSummen[i].Kurse := 0;
    FSummen[i].Stunden := 0;
    FSummen[i].AnzGKS := 0;
    FSummen[i].AnzGK := 0;
  end;

  pxdone := false;

  with FC0 do
  begin
    First;
    while not Eof do
    begin
      stkrz := FieldByname( 'FachStatKrz' ).AsString;
//      if stkrz = C_PROJEKTKURS then
//      begin
//        fach := FieldByname( 'FachInternKrz' ).AsString;
//        pxbel := IstBelegt( fach, C_Q1, C_Q2 ) or IstBelegt( fach, C_Q2, C_Q3 ) or IstBelegt( fach, C_Q3, C_Q4 );
//      end;

      fach := FieldByname( 'FachInternKrz' ).AsString;

      for i := C_E1 to C_Q4 do
      begin
        fn := Format( 'KA_%d', [ i ] );
        ka := FieldByname( fn ).AsString;
//        ShowMessage( FieldByname( 'FachStatKrz' ).AsString + ' ' + fn + ': ' + FieldByname( fn ).AsString );
        if ( ka <> '' ) and ( ka <> 'AT' ) then
        begin // Belegt
          add_kurse := true;
          add_std := true;

          if AnsiSameText( stkrz, C_VERTIEFUNGSKURS ) then
          begin
            add_kurse := false;
            add_std := true;
          end else if AnsiSameText( stkrz, C_PROJEKTKURS )  then
// Raffenberg
// Wenn ein Projektkurs belegt wurde und das Häkchen "Projektkurs ist besondere Lernleistung" gesetzt wird,
//so wird der Projektkus bei der Kurszählung und bei der Stundenzählung nicht mehr berücksichtigt. Letzteres ist falsch.
//Er muss bei der Stundensumme immer noch berücksichtigt werden.
          begin
            pxbel := false;
            case i of
            C_Q1: pxbel := IstBelegt( fach, C_Q1, C_Q2 );
            C_Q2: pxbel := {IstBelegt( fach, C_Q1, C_Q2 ) or } IstBelegt( fach, C_Q2, C_Q3 );
            C_Q3: pxbel := {IstBelegt( fach, C_Q2,  C_Q3 ) or } IstBelegt( fach, C_Q3, C_Q4 );
            C_Q4: pxbel := false;//IstBelegt( fach, C_Q3, C_Q4 );
            end;

            if pxbel then
            begin
              if ( FSchueler.BLL_Art = 'P' ) then
              begin
                add_kurse := false;
                add_std := true;
              end else
              begin
                add_kurse := true;
                add_std := true;
              end;
            end else
            begin
              add_kurse := false;
              add_std := true;
            end;
          end;

          if add_std then
          begin
            wstd := FieldByName( Format( 'WS_%d', [ i ] ) ).AsInteger;
            if ( FSchulform = 'WB' ) and FFuerAbitur and ( i >= C_Q1 ) then
            begin // Bei AbiBerechnung auf 0 Punkte prüfen, aner nur dann wenn kein Projektkusr
              if ( stkrz <> C_PROJEKTKURS ) and ( stkrz <> C_VERTIEFUNGSKURS) and ( Punkte( fach, i ) = 0 ) then
                wstd := 0;
            end;
          end else
            wstd := 0;

          if add_kurse then
          begin
            FSummen[i].Kurse := FSummen[i].Kurse + 1;
            if pxbel and ( i < C_Q4 ) and not pxdone then
            begin
              FSummen[i+1].Kurse := FSummen[i+1].Kurse + 1;
              pxdone := true;
            end;
          end;

          if i = C_E1 then
            FSummen[i].Stunden := FSummen[i].Stunden + wstd
          else
            FSummen[i].Stunden := FSummen[i].Stunden + wstd;

        end;
      end;
      Next;
    end;
  end;


end;

procedure TAbiturBelegPruefer.FehlerAusgeben( const fcode, ftext: string );
var
  mtxt, mgr: string;
  msort: integer;
begin
  if ( FSchulform = 'GY' ) or ( FSchulform = 'GE' ) or ( FSchulform = 'WB' ) then
    LupoMessenger.GetMessageText( fcode, mtxt, mgr, msort )
  else
  begin // BK, kein LuPO
    mtxt := ftext;
    mgr := 'B';
  end;

  if ( mgr <> 'I' ) then
  begin
// NEU: LI_IV_11 hinzu
    if not ( ( fcode = 'WST_20' ) or ( fcode = 'WST_21' ){ or ( fcode = 'LI_IV_11' )} ) then
      inc( FFehlerZahl );
  end;

  if FFuerAbitur then
  begin
    if ( mgr <> 'I' ) and not ( ( fcode = 'WST_20' ) or ( fcode = 'WST_21' ) )  then
      FBelegMeldungen.Add( mtxt );
    exit;
  end;

  if FBeratung and Assigned( FConABP ) then
{$IFDEF UNIDAC}
    FConABP.ExecSQL( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext, Fehlergruppe, Sortierung) values (%d,%s,%s,%s,%d)',
                            [ FSchueler.ID,
                              QuotedStr( fcode ),
                              QuotedStr( mtxt ),
                              QuotedStr( mgr ),
                              msort ] ) );
{$ELSE}
    FConABP.Execute( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext, Fehlergruppe, Sortierung) values (%d,%s,%s,%s,%d)',
                            [ FSchueler.ID,
                              QuotedStr( fcode ),
                              QuotedStr( mtxt ),
                              QuotedStr( mgr ),
                              msort ] ) );
{$ENDIF}
end;

function TAbiturBelegPruefer.AnzahlSchriftlich( const gruppe: string; const hjv, hjb: integer ): integer;
var
  i: integer;
  afach: string;
begin
  Result := 0;
  for i := 1 to AnzahlElemente( gruppe ) do
  begin
    afach := Einzelelement( gruppe, i );
    if IstSchriftlich( afach, hjv, hjb ) then
      inc( Result );
  end;
end;


function TAbiturBelegPruefer.GruppeSchriftlich( const gruppe: string; const hjv, hjb: integer; const alle: boolean ): boolean;
var
  i: integer;
  afach: string;
begin
  if gruppe = '' then
  begin
    Result := false;
    exit;
  end;

  if hjv > hjb then
  begin
    Result := true;
    exit;
  end;

  Result := true;
  for i := 1 to AnzahlElemente( gruppe ) do
  begin
    afach := Einzelelement( gruppe, i );
    if alle then
      Result := Result and IstSchriftlich( afach, hjv, hjb )
    else
    begin
      Result := IstSchriftlich( afach, hjv, hjb );
      if Result then
        exit;
    end;
  end;
end;

function TAbiturBelegPruefer.FremdspracheFinden( const fach: string ): string;
var
  fnd: boolean;
begin
  Result := '';
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;

  if fnd then
  begin
    Result := fach;
    exit;
  end;

// WEnn wir heir sind, wurde das fach nicht gefunden, das  kann daran liegen, sass in der gruppe nur das allgemeine Sprachfach steht z.B. "L"

  with FC0 do
  begin
    First;
    while not Eof do
    begin
      if ( FieldByname( 'Fremdsprache' ).AsString = '+' ) and AnsiStartsText( fach, FieldByName( 'FachInternKrz' ).AsString ) then
      begin
        Result := FieldByName( 'FachInternKrz' ).AsString;
        exit;
      end;
      Next;
    end;
    First;
  end;
end;

function TAbiturBelegPruefer.GruppeSchriftlichSprache( const gruppe: string; const hjv, hjb: integer; const alle: boolean ): boolean;
var
  i: integer;
  afach: string;
begin
  if gruppe = '' then
  begin
    Result := false;
    exit;
  end;

  if hjv > hjb then
  begin
    Result := true;
    exit;
  end;

  Result := true;
  for i := 1 to AnzahlElemente( gruppe ) do
  begin
    afach := FremdspracheFinden( Einzelelement( gruppe, i ) );
    if afach = '' then
    begin
      Result := false;
      exit;
    end;
    if alle then
      Result := Result and IstSchriftlich( afach, hjv, hjb )
    else
    begin
      Result := IstSchriftlich( afach, hjv, hjb );
      if Result then
        exit;
    end;
  end;
end;

function TAbiturBelegPruefer.GruppeBelegtSprache( const gruppe: string; const hjv, hjb: integer; const alle: boolean = false ): boolean;
var
  i: integer;
  afach: string;
begin
  if gruppe = '' then
  begin
    Result := false;
    exit;
  end;

  if hjv > hjb then
  begin
    Result := true;
    exit;
  end;

  Result := true;
  for i := 1 to AnzahlElemente( gruppe ) do
  begin
    afach := FremdspracheFinden( Einzelelement( gruppe, i ) );
    if afach = '' then
    begin
      Result := false;
      exit;
    end;
    if alle then
      Result := Result and IstBelegt( afach, hjv, hjb )
    else
    begin
      Result := IstBelegt( afach, hjv, hjb );
      if Result then
        exit;
    end;
  end;
end;



function TAbiturBelegPruefer.GruppeMuendlich( const gruppe: string; const hjv, hjb: integer; const alle: boolean ): boolean;
var
  i: integer;
  afach: string;
begin
  if gruppe = '' then
  begin
    Result := false;
    exit;
  end;

  if hjv > hjb then
  begin
    Result := false;
    exit;
  end;

  Result := true;
  for i := 1 to AnzahlElemente( gruppe ) do
  begin
    afach := Einzelelement( gruppe, i );
    if alle then
      Result := Result and IstMuendlich( afach, hjv, hjb )
    else
    begin
      Result := IstMuendlich( afach, hjv, hjb );
      if Result then
        exit;
    end;
  end;
end;


function TAbiturBelegPruefer.GruppeBelegt( const gruppe: string; const hjv, hjb: integer; const kursart: string = '' ): boolean;
var
  i, j: integer;
  afach: string;
begin
  if gruppe = '' then
  begin
    Result := false;
    exit;
  end;

  if hjv > hjb then
  begin
    Result := true;
    exit;
  end;

  Result := false;
  for i := 1 to AnzahlElemente( gruppe ) do
  begin
    afach := Einzelelement( gruppe, i );
    Result := IstBelegt( afach, hjv, hjb, kursart );
    if Result then
      exit;
  end;
end;


function TAbiturBelegPruefer.GruppeGemischtBelegt( const gruppe: string; const hjv, hjb: integer ): boolean;
var
  i, j: integer;
  afach: string;
  slBelegt: TStringList;
begin
  if gruppe = '' then
  begin
    Result := false;
    exit;
  end;

  if hjv > hjb then
  begin
    Result := true;
    exit;
  end;


  slBelegt := TStringList.Create;
  try

    Result := false;
    for i := 1 to AnzahlElemente( gruppe ) do
    begin
      afach := Einzelelement( gruppe, i );
      for j := hjv to hjb do
      begin
        if IstBelegt( afach, j, j ) then
        begin
          if slBelegt.IndexOf( IntToStr( j ) ) < 0 then
            slBelegt.Add( IntToStr( j ) );
        end;
      end;
    end;

    Result := slBelegt.Count = hjb - hjv + 1;
  finally
    FreeAndNil( slBelegt );
  end;
end;


function TAbiturBelegPruefer.GruppeZK( const gruppe: string; const hjv, hjb: integer ): boolean;
var
  i, j: integer;
  afach: string;
begin
  if gruppe = '' then
  begin
    Result := false;
    exit;
  end;
  Result := false;
  for i := 1 to AnzahlElemente( gruppe ) do
  begin
    afach := Einzelelement( gruppe, i );
    Result := IstZK( afach, hjv, hjb );
    if Result then
      exit;
  end;
end;


function TAbiturBelegPruefer.AnzahlGruppeBelegt( const gruppe: string; const hjv, hjb: integer ): integer;
var
  i, j: integer;
  afach: string;
begin
  Result := 0;
  if gruppe = '' then
  begin
    exit;
  end;

  for i := 1 to AnzahlElemente( gruppe ) do
  begin
    afach := Einzelelement( gruppe, i );
    if IstBelegt( afach, hjv, hjb ) then
      inc( Result );
  end;
end;


procedure TAbiturBelegPruefer.PruefeDoppelbelegung( const M: string; const FremdSprachen, AbschnittEgal: boolean );

  function Belegung( const fach: string ): string;
  var
    i: integer;
  begin
    if FC0.FieldByname( 'FachInternKrz' ).AsString <> fach then
      FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );

    Result := '------';
    for i := 1 to 6 do
      if FC0.FieldByname( Format( 'KA_%d', [i] ) ).AsString <> '' then
        Result[i] := '+';
  end;

var
  i, j, k: integer;
  f1, f2, s1, s2, f1n, f2n, bel1, bel2: string;
  err: boolean;
  anzahl: integer;
begin
  if M = '' then
    exit;
  anzahl := AnzahlElemente( M );
  for i := 1 to anzahl - 1 do
  begin
    f1 := Einzelelement( M, i );
    f1n := Fachname( f1 );
    s1 := StatistikKuerzel( f1 );
    bel1 := Belegung( f1 );

    for j := i + 1 to anzahl do
    begin
      f2 := Einzelelement( M, j );
      s2 := StatistikKuerzel( f2 );
      if Fremdsprachen then
      begin
        try
          err := s1[1] = s2[1]
        except
          err := false;
        end;
      end else
        err := s1 = s2;//true;
      if err and not AbschnittEgal then
      begin //
        bel2 := Belegung( f2 );
        for k := 1 to 6 do
        begin
          err := ( bel1[k] = '+' ) and ( bel2[k] = '+' );
          if err then
            break;
        end;
      end;

      if err then
      begin
        f2n := Fachname( f2 );
        if Assigned( FConABP ) then
{$IFDEF UNIDAC}
          FConABP.ExecSQL( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext) values (%d,%s,%s)',
                        [ FSchueler.ID,
                          QuotedStr( 'MEHRFACH' ),
                          QuotedStr( Format( 'Die Fächer "%s" und "%s" können nicht gemeinsam belegt werden', [ f1n, f2n ] ) )
                           ] ) );
{$ELSE}
          FConABP.Execute( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext) values (%d,%s,%s)',
                        [ FSchueler.ID,
                          QuotedStr( 'MEHRFACH' ),
                          QuotedStr( Format( 'Die Fächer "%s" und "%s" können nicht gemeinsam belegt werden', [ f1n, f2n ] ) )
                           ] ) );
{$ENDIF}
      end;
    end;
  end;
end;

function TAbiturBelegPruefer.UnterrichtsSprache( const fach: string ): string;
var
  fn: string;
  fnd: boolean;
  statkrz: string;
begin
// Liefert die Unterrichtssprache als 1-stellges Statitsik-Kürzel
  Result := '';
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    fnd := FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] )
  else
    fnd := true;
  if fnd then
  begin
    Result := FC0.FieldByName( 'Unterrichtssprache' ).AsString;
    if ( Result = 'D' ) and ( FC0.FieldByname( 'FremdSprache' ).AsString = '+' ) then
    begin
      statkrz := FC0.FieldByname( 'FachStatKrz' ).AsString;
      if statkrz <> '' then
        Result := statkrz[1];
    end;
  end;

  if Result = '' then
    Result := 'D';
end;



function TAbiturBelegPruefer.SprachenVonBilingSachf( const schr: boolean; const hjv, hjb: integer ): string;
// Liefer die Sprachen von Bilingualen Sachfächern
var
  afach, fn: string;
  add: boolean;
  i: integer;
  uspr: string;
begin
  Result := '';
  for i := 1 to AnzahlElemente( W6 ) do
  begin
    afach := Einzelelement( W6, i );
    if schr then
      add := IstSchriftlich( afach, hjv, hjb )
    else
      add := IstBelegt( afach, hjv, hjb );
    if add then
    begin
      uspr := UnterrichtsSprache( afach );
      if uspr <> 'D' then
        ZuMengeHinzu( Result, uspr );
    end;
  end;
end;

function TAbiturBelegPruefer.FilternBilingSachf( const schr: boolean; const hjv, hjb: integer ): string;
// Liefert die in unterschiedlichen Sprachen belegten Sachfächer
// dz.B. wenn GE_E und EK_E im gleichen Abschnitt belegt, dann wird nur eins von beiden genommen
var
  afach, fn: string;
  add: boolean;
  i: integer;
  uspr: string;
  sprachen: string;
begin
  Result := '';
  for i := 1 to AnzahlElemente( W6 ) do
  begin
    afach := Einzelelement( W6, i );
    if schr then
      add := IstSchriftlich( afach, hjv, hjb )
    else
      add := IstBelegt( afach, hjv, hjb );
    if add then
    begin
      uspr := UnterrichtsSprache( afach );
      if uspr <> 'D' then
      begin
        add := not InMenge( uspr, sprachen );
        if add then
        begin
          ZuMengeHinzu( Result, afach );
          ZuMengeHinzu( sprachen, uspr );
        end;
      end;
    end;
  end;
end;

function TAbiturBelegPruefer.PruefeInhaltsgleicheFaecher( const hj: integer ): boolean;
var
  slStatKrz: TStringList;
  fachkrz: string;
  statkrz: string;
begin
  Result := true;
  slStatKrz := TStringList.Create;
  try
    with FC0 do
    begin
      First;
      while not Eof do
      begin
        statkrz := FieldByname( 'Basisfach' ).AsString;
        if not AnsiSameText( statkrz, 'VX' ) {and not AnsiSameText( statkrz, 'PX' )} then
        begin
          fachkrz := FieldByname( 'FachInternKrz' ).AsString;
          if IstBelegt1( fachkrz, hj, hj ) then
          begin
            if slStatKrz.IndexOf( statkrz ) >= 0 then
            begin
              Result := false;
              exit;
            end else
              slStatKrz.Add( statkrz );
          end;
        end;
        Next;
      end;
    end;
  finally
    FC0.First;
    FreeAndNil( slStatKrz );
  end;

end;




procedure TAbiturBelegPruefer.Pruefe_E_Phase_GY_GE;
var
  fnd, err, schr, bel: boolean;
  err_code: string;
  i, j, anzahl, anzahl_s: integer;
  M1, M2, M3, afach, fsfach, statkrz, idf, uspr, M_A, M_C, M_D: string;
  SprBilSF: string;
  ds_e: double;
begin
  FKursZaehler.Phase := 'E';
  PruefeDoppelbelegung( Vereinigungsmenge( W1_2, W1_3 ), true, true );  // Fremdsprachen, dürfen grundsätzlich nicht gleichzeitig belegt sein
// Prüfung auf paraLlele Belegung4 in einem konkreten Abschnitt bei biling. Sachfächern
  PruefeDoppelbelegung( M1, false, false ); // Die biling. Sachfächer prüfen (z.B. ob EK_F und EK_E belegt ist)
  M1 := Vereinigungsmenge( W2_1, W6 );
  M1 := Vereinigungsmenge( W2_2, M1 );
  M1 := Vereinigungsmenge( W2_3, M1 );
  M1 := Vereinigungsmenge( W2_4, M1 );
  M1 := Vereinigungsmenge( W3, M1 );
  PruefeDoppelbelegung( M1, false, false );  // Fremdsprachen, dürfen grundsätzlich nicht gleichzeitig belegt sein

// NEU 2 Wurde Deutsch in EF.1 schriftlich belegt?
  schr := GruppeSchriftlich( W1_1, 1, 1, false );
  if not schr then
  begin
    err_code := 'D_1';
    FehlerAusgeben( err_code, 'Deutsch muss schriftlich belegt sein' );
  end;

// NEU 3 Wurde ein Kurs Kunst oder Musik in EF.1 belegt?
  bel := GruppeBelegt( W1_4, 1, 1 );
  if not bel then
  begin
    err_code := 'KU_MU_1';
    FehlerAusgeben( err_code, 'Kunst oder Musik muss belegt sein' );
  end;

// 3. Mindestens eine SI Fremdsprache muss belegt werden, die in der SII durchgehend angeboten wird.
// Andernfalls muss eine weitere beliebige durchgehend angebotene Fremdsprache als Ersatz angewählt werden.
// Es können auch mehrere Fremdsprachen gewählt werden

// NEU 4: Wurde eine fortgeführte Fremdsprache in EF.1 schriftlich belegt, die durchgehend von EF.1 bsi Q2.2 belegbar ist
  schr := false;
  bel := false;
  M1 := W1_2;  // fortgeführte FS
  for i := 1 to AnzahlElemente( M1 ) do
  begin
    afach := EinzelElement( M1, i );
    schr := IstSchriftlich( afach, 1, 1 ) and InMenge( afach, FS_Durchg );
    if schr then
      break;
  end;

  if schr then
  begin
// J: Weiter
  end else
  begin
//  N: Wurde das Häkchen Muttersprachenprüfung aktiviert?
    if FSchueler.SPP then
    begin
  // J: Wurde eine neu einsetzende Fremdsprache in EF.1 schriftlich belegt, die durchgehend von EF.1 bis Q2.2. belegbar ist?
      M1 := W1_3;
      for i := 1 to AnzahlElemente( M1 ) do
      begin
        afach := EinzelElement( M1, i );
        schr := IstSchriftlich( afach, C_E1, C_E1 ) and InMenge( afach, FS_Durchg );
        if schr then
          break;
      end;
      if schr then
      begin
  //  J: Hinweis FS_3
        err_code := 'FS_3';
        FehlerAusgeben( err_code, 'Eine erfolgreiche Feststellungsprüfung in der Muttersprache am Ende der Sekundarstufe I und am Ende von E2 ist notwendig, um die Fremdsprachenbedingungen zu erfüllen.' );
      end else
      begin
  //  N: Belegungsfehler FS_4
        err_code := 'FS_4';
        FehlerAusgeben( err_code, 'Mindestens eine Fremdsprache muss in E1 schriftlich belegt werden.' );
      end;

    end else
    begin   // keine SPP
// N: Wurde eine fortgeführte Fremdsprache in EF.1 schriftlich belegt, die auch in EF.2 belegbar ist?
      M1 := W1_2; // fortgeführet FS
      for i := 1 to AnzahlElemente( M1 ) do
      begin
        afach := EinzelElement( M1, i );
        schr := IstSchriftlich( afach, C_E1, C_E1 ) and InMenge( afach, FS_EBelegbar );
        if schr then
          break;
      end;

      if schr then
      begin
//    J : Wurde eine neu einsetzende Fremdsprache in EF.1 schriftlich belegt, die durchgehend von EF.1 bis Q2.2 belegbar ist?
        M1 := W1_3; // fortgeführet FS
        for i := 1 to AnzahlElemente( M1 ) do
        begin
          afach := EinzelElement( M1, i );
          schr := IstSchriftlich( afach, C_E1, C_E1 ) and InMenge( afach, FS_Durchg );
          if schr then
            break;
        end;

        if schr then
        begin
//      J: Weiter
        end else
        begin
//      N: Belegungsfehler FS_1
          err_code := 'FS_1';
          FehlerAusgeben( err_code, 'Da die gewählte Fremdsprache in der Oberstufe nicht durchgehend angeboten wird, muss entweder zusätzliche eine neu einsetzende Fremdsprache, oder eine andere in der Sekundarstufe I begonnene Fremdsprache belegt werden.' )
        end;

      end else
      begin
//    N : Belegungsfehler FS_2
        err_code := 'FS_2';
        FehlerAusgeben( err_code, 'Mindestens eine in der Sekundarstufe I begonnene Fremdsprache muss in E1 schriftlich belegt werden.' );
      end;
    end;
  end;


// 4. Für die Abiturzulassung muss eine 2. Fremdsprache ab der Jgst 06 belegt worden sein.
// Ist dies nicht der Fall, so muss eine neu einsetzende Fremdsprache, oder eine aus Jgst. 08 fortgeführte  Fremdsprache belegt werden

// Durch die Änderung auf Klasse 6/7 und Klasse 8/9  werden sowohl G8 als auch G9 Schüler
// geprüft. Schüler anderer Schulformen, die  einen Schulwechsel  Ende der SI vornehmen wollen,
// sind sehr wahrscheinlich zur Beratungssituation an der neuen Schule in Schild noch nicht erfasst.
// Für diese Schüler muss eine manuelle Eingabe der Sprachenfolge im Tool möglich sein.
// Alternativ  wäre ein manuell zu setzendes Häkchen „Schüler ohne 2. Fremdsprache“, wie in meiner Exceldatei, denkbar.


// NEU 5 Ist das Häkchen "Fremdsprache in SekI manuell geprüft" gesetzt?
//Hatte der Schüler eine 2. Fremdsprache in Klasse 6/7?
  if not FSchueler.FS2_SekI_manuell and ( AnzahlElemente( FSchueler.S1_Sprachen_5_6 ) <= 1 ) then
  begin // Keine 2. Fremdsprache aus Jg. 6/7

// Hatte der Schüler eine 2. Fremdsprache in Klasse 8/9?
    if FSchueler.S1_Sprachen_8 <> '' then
    begin
// Wurde ein Kurs aus F1.3 schriftlich belegt,Oder Wurde die 2. Fremdsprache aus Klasse 8/9 schriftlich belegt?
      schr := false;
      for i := 1 to AnzahlElemente( FSchueler.S1_Sprachfaecher_8 ) do      //
      begin
        afach := Einzelelement( FSchueler.S1_Sprachfaecher_8, i );
        schr := IstSchriftlich( afach, 1, 1 );
        if schr then
          break;
      end;
      if not schr and ( W1_3 <> '' ) then  // Fremdsprache aus 8 nicht schriftlich, prüfe neu einsetzende FS
        schr := GruppeSchriftlich( W1_3, 1, 1, false );
      if not schr then
      begin
        err_code := 'FS_5';
        FehlerAusgeben( err_code, 'Wurde die 2. Fremdsprache erst ab Klasse 8/9 erlernt, muss die in der Sekundarstufe 1 begonnene 2. Fremdsprache oder eine neu einsetzende Fremdsprache schriftlich in EF.1 belegt werden.' );
      end;

    end else
    begin // Keine Fremsprache ab 8, es muss eine neu einsetzende schriftliche FS sein
//Wurde in E1 eine neu einsetzende Fremdsprache schriftlich belegt
      schr := GruppeSchriftlich( W1_3 , 1, 1, false );
      if not schr then
      begin
        err_code := 'FS_6';
        FehlerAusgeben( err_code, 'Wurde bisher keine 2. Fremdsprache erlernt, muss eine neu einsetzende Fremdsprache in EF.1 schriftlich belegt werden.' );
      end;
    end;
  end;

// NEU 6 Wurde Latein in der SI beget, aber nicht in EF.1?
  if FSchueler.LateinBeginn <> '' then
  begin
//Wurde Latein in der SI belegt, aber nicht in E1?
    schr := LateinBelegt( C_E1, C_E1 );
    if not schr then
    begin
      err_code := 'L_1';
      FehlerAusgeben( err_code, 'Um das Latinum zu erlangen muss Latein in E1 schriftlich fortgeführt werden' );
    end;
  end;

// NEU 7 Latein G9 entfällt

// NEU 8 Wurden alle fortgeführten Fremdsprachen und neu einsetzende Fremdsprachen in EF.1 schriftlich belegt?
  M1 := W1_2;
  M1 := Vereinigungsmenge( M1, W1_3 );
  M2 := '';
  if ( M1 <> '' ) then
  begin
// Erst mal die in E1 belegten Fächer finden
    for i := 1 to AnzahlElemente( M1 ) do
    begin
      afach := EinzelElement( M1, i );
      if IstBelegt( afach, 1, 1 ) then
        ZuMengeHinzu( M2, afach );
    end;

    if M2 <> '' then
    begin
      schr := GruppeSchriftlich( M2, 1, 1, true );
      if not schr then
      begin
        err_code := 'FS_7';
        FehlerAusgeben( err_code, 'In E1 müssen alle belegten Fremdsprachen schriftlich belegt werden' );
      end;
    end;
  end;

//NEU 9 Wurde eine Gesellschaftswissenschaft in EF.1 schriftlich belegt?
// Vereinigungsmenge bilden
  M1 := W2_1;
  M1 := Vereinigungsmenge( M1, W2_1 ); // Geschichte
  M1 := Vereinigungsmenge( M1, W2_2 );  // Sozialwissenschaften
  M1 := Vereinigungsmenge( M1, W2_3 );
  M1 := Vereinigungsmenge( M1, W2_4 );
  schr := GruppeSchriftlich( M1, 1, 1, false );
  if not schr then
  begin
    err_code := 'GW_1';
    FehlerAusgeben( err_code, 'Mindestens eine Gesellschaftswissenschaft muss in E1 schriftlich belegt werden' );
  end;

// NEU 10: Wurde Geschichte in EF.1 belegt?
  bel := GruppeBelegt( W2_1, 1, 1 );
  if not bel then
  begin
    err_code := 'GE_1';
    FehlerAusgeben( err_code, 'Wird Geschichte nicht in E1 belegt, so muss Geschichte in der Qualifikationsphase als Zusatzkurs gewählt werden.' );
  end;

// NEU 11 Wurde Sozialwissenchaft in EF.1 belegt?
  bel := GruppeBelegt( W2_2, 1, 1 );
  if not bel then
  begin
    err_code := 'SW_1';
    FehlerAusgeben( err_code, 'Werden Sozialwissenschaften nicht in E1 belegt, so muss Geschichte in der Qualifikationsphase als Zusatzkurs gewählt werden.' );
  end;

// 10. Ein Religionskurs muss in E1 belegt werden. Als Ersatz kann Philosophie belegt werden,
// sofern eine weitere Gesellschaftswissenschaft bis zum Abitur belegt wird.
// Hier gilt: Genau ein Religionskurs. Zwei ist nicht erlaubt.
// Religion und Philosophie darf gewählt werden, da in diesem Fall Philosophie als Gesellschaftswissenschaft gilt.
// 1xF4 oder F2.4 und (F2.1 oder F2.2 oder F2.3)  belegt?

// NEU 12 Wurde Religion in EF.1 belegt oder wurde Philosophie und eine weitere durchgehend belegbare Geselschaftswissenscahft in EF.1 belegt?
  bel := GruppeBelegt( W4, C_E1, C_E1 );
  if not bel then
  begin
    M1 := VereinigungsMenge( W2_1, W2_2 );
    M1 := VereinigungsMenge( M1, W2_3 );
    bel := GruppeBelegt( M1, C_E1, C_E1 ) and GruppeBelegt( W2_4, C_E1, C_E1 );
  end;
  if not bel then
  begin
    err_code := 'RE_1';
    FehlerAusgeben( err_code, 'Ein Religionskurs muss in E1 belegt werden. Als Ersatz kann Philosophie belegt werden, sofern eine weitere Gesellschaftswissenschaft bis zum Abitur belegt wird' );
  end;

// NEU 13 Wurde Mathematik in EF.1 schriftlich belegt
  schr := GruppeSchriftlich( W3_1, C_E1, C_E1, false );
  if not schr then
  begin
    err_code := 'M_1';
    FehlerAusgeben( err_code, 'Mathematik muss in E1 schriftlich belegt werden' );
  end;


// NEU 14 Wurde eine klassische Naturwissenschaft schriftlich belegt?
  schr := GruppeSchriftlich( W3_2, C_E1, C_E1, false );
  if not schr then
  begin
    err_code := 'NW_1';
    FehlerAusgeben( err_code, 'Mindestens eines der Fächer Physik, Chemie oder Biologie muss in E1 schriftlich belegt werden' );
  end;

// NEU 15 Wurde Sport belgegt?
  bel := GruppeBelegt( W5, C_E1, C_E1 ); //or Schueler.Sportbefreit;
  if not bel then
  begin
    err_code := 'SP_1';
    FehlerAusgeben( err_code, 'Sport muss in E1 belegt werden' );
  end;


// NEU 16 Schleife über alle fortgeführten Fremdsprachenfächer und neu einsetzenden Fremdsprachenfächern
  M1 := VereinigungsMenge( W1_2, W1_3 );
  M_A := '';
  for i := 1 to AnzahlElemente( M1 ) do
  begin
    afach := EinzelElement( M1, i );
// Wurde das Fach in EF.1 schriftlich belegt und ist das Fach durchgehend belegbar? (Zusatz: Sicherheitshalber auch prüfen, ob belegt)
// J: Nimm die Unterrichtssprache, in der das Fach unterrichtet wird, in die Menge A auf
    if IstBelegt( afach, C_E1, C_E1 ) and IstSchriftlich( afach, C_E1, C_E1 ) and InMenge( afach, FS_Durchg ) then
      ZuMengeHinzu( M_A, Unterrichtssprache( afach ) );
  end;

// NEU 17 Ist die Anzahl der Elemente in Menge A genau 1?
  if AnzahlElemente( M_A ) = 1 then
  begin
// J: Schleife über alle in EF.1 belegten bilingualen Sachfächer (=W6)
    for i := 1 to AnzahlElemente( W6 ) do
    begin
      afach := EinzelElement( W6, i );
// Wurde das Fach in EF.1 schriftlich belegt und ist das Fach durchgehend belegbar? (Zusatz: Sicherheitshalber auch prüfen, ob belegt)
      if IstBelegt( afach, C_E1, C_E1 ) and IstSchriftlich( afach, C_E1, C_E1 ) and InMenge( afach, DurchgehendBelegbareFaecher ) then
        ZuMengeHinzu( M_A, Unterrichtssprache( afach ) );
    end;
  end;


// NEU 18 Schleife über alle klassischen und modernen Naturwissenschaften
  M1 := VereinigungsMenge( W3_2, W3_3 ); // klassische NW und weitere NW
  M_C := '';
  M_D := '';
  for i := 1 to AnzahlElemente( M1 ) do
  begin
    afach := EinzelElement( M1, i );
// Wurde das Fach in EF.1 belegt und ist das Fach durchgehend belegbar?
    if IstBelegt( afach, C_E1, C_E1 ) and InMenge( afach, DurchgehendBelegbareFaecher ) then
    begin
// Wurde das Fach in EF.1 schriftlich belegt?
      if IstSchriftlich( afach, C_E1, C_E1 ) then
      begin
// J: Nimm das Fach in eine Menge C und D auf
        ZuMengeHinzu( M_C, afach );
        ZuMengeHinzu( M_D, afach );
      end else
// N: Nimm das Fach in eine Menge C auf
        ZuMengeHinzu( M_C, afach );
    end;
  end;

// NEU 19: Ist die Anzahl der Elemente in Menge A größer gleich 2?
  if AnzahlElemente( M_A ) >= 2 then
  begin
// J: Ist die Anzahl der Elemente in Menge C größer oder gelich 2 und ist die Anzahl der Elemente in Menge D größer gleich 1?
    if ( AnzahlElemente( M_C ) >= 2 ) and ( AnzahlElemente( M_D ) >= 1 ) then
    begin
//    J: Weiter
    end else
    begin
//    Hinweis FS_NW_1
      err_code := 'FS_NW_1';
      FehlerAusgeben( err_code, 'Da nur eine Naturwissenschaft gewählt wurde, müssen zwei Fremdsprachen bis Q2.2 durchgehend belegt werden' );
    end;
  end else
  begin
// N: Ist die Anzahl der Elemente in Menge C größer gleich 2 und ist die Anzahl der Elemente in Menge D größer gleich 1?
    if ( AnzahlElemente( M_C ) >= 2 ) and ( AnzahlElemente( M_D ) >= 1 ) then
    begin
//  J: Hinweis FS_NW_2
      err_code := 'FS_NW_2';
      FehlerAusgeben( err_code, 'Hinweis: Da nur eine Fremdsprache gewählt wurde, müssen zwei naturwissenschaftliche Kurse bis Q2.2 durchgehend belegt werden' );
    end else
    begin
//  N: Belegungsfehler FS_NW_3
      err_code := 'FS_NW_3';
      FehlerAusgeben( err_code, 'In EF.1 müssen entweder zwei Fächer aus dem naturwissenschaftlich-technischen Bereich oder zwei Fremdsprachen gewählt werden. Zu letzterem zählen auch in einer zweiten Fremdsprache unterrichtete Sachfächer.' );
    end;
  end;

// NEU 20 Schüler des bilingualen Bildungsganges?
  if FSchueler.BilingualerZweig <> '-' then
  begin
// J: Fremdsprache des bilingualen Bildungsganges in EF.1 schriftlich belegt?
    M1 := W1_2;
    for i := 1 to AnzahlElemente( W1_2 ) do
    begin
      afach := Einzelelement( W1_2, i );
      statkrz := StatistikKuerzel( afach );
      schr := ( statkrz[1] = FSchueler.BilingualerZweig ) and IstSchriftlich( afach, 1, 1 );
      if schr then
        break;
    end;
    if not schr then
    begin
      err_code := 'BIL_1';
      FehlerAusgeben( err_code, 'Im bilingualen Bildungsgang muss die bilinguale Fremdsprache schriftlich belegt werden' );
    end;

// Mindestens ein blinguales Sachfach in der bilingualen Fremdsprache in EF.1 belegt
    bel := false;
    for i := 1 to AnzahlElemente( W6 ) do  // W6 die bilingualen Sachfächer
    begin
      afach := Einzelelement( W6, i );
      uspr := UnterrichtsSprache( afach );
      if ( uspr = FSchueler.BilingualerZweig ) and IstBelegt( afach, C_E1, C_E1 ) then
        inc( anzahl );
    end;
    if anzahl < 1  then
    begin
      err_code := 'BIL_2';
      FehlerAusgeben( err_code, 'Im bilingualen Bildungsgang muss mindestens ein bilinguales Sachfach in der bilingualen Fremdsprache belegt werden.' );
    end;
    if anzahl < 2 then
    begin
      err_code := 'BIL_5';
      FehlerAusgeben( err_code, 'Im bilingualen Bildungsgang sollten zwei bilinguale Sachfächer belegt werden.' );
    end;
  end;  // Ende bilingual

// NEU 21 Schleife über alle belegten bilingualen Sachfächer in EF.1: FIndet sich die Sprache des bilingualen Sachfaches
// in der Sprachenfolge des Schülers mit Sprachbeginn 5 oder 6 oder 8
  SprBilSF := SprachenVonBilingSachf( false, C_E1, C_E1 );
  for i := 1 to AnzahlElemente( W6 ) do  // W6: biling. Sachfächer
  begin
    afach := EinzelElement( W6, i );
    uspr := Unterrichtssprache( afach );
    if InMenge( uspr, FSchueler.S1_Sprachen ) then
    begin
// J: Wurde die zur Unterrichtssprache des bilingualen Sachfaches gehörende fortgeführte Fremdsprache in EF.1 schriftlich belegt?
// uspr := Unterrichtssprache des bilingualen Sachfaches
      schr := false;
      for j := 1 to AnzahlElemente( W1_2 ) do
      begin
        fsfach := EinzelElement( W1_2, j );
        if AnsiSameText( uspr, copy( fsfach, 1, 1 ) ) then
        begin // Hurra, wir haben das Sprachfach
          schr := IstSchriftlich( fsfach, C_E1, C_E1 );
          break;
        end;
      end;

      if schr then
// J: Weiter
      else
      begin
// N : Wurde das bilinguale Sachfach schriftlich in EF.1 belegt?
        if not IstSchriftlich( afach, C_E1, C_E1 ) then
        begin
          err_code := 'BIL_4';
          FehlerAusgeben( err_code, 'Sollen bilinguale Sachfächer gleichzeitig als weitere Fremdsprache herangezogen werden, so muss in E1 entweder das Sprachenfach aus Aufgabenfeld I oder das Sachfach schriftlich gewählt werden.' );
        end;
      end;

    end else
    begin
// N: Belegungsfehler BIL_3
      err_code := 'BIL_3';
      FehlerAusgeben( err_code, 'Es können nur bilinguale Sachfächer belegt werden, deren Sprache in der Sekundarstufe erlernt wurde' );
    end;
  end;


//Literatur, Zusatzkurse, Vertiefungskurse und Projektkurse können nur mündlich belegt werden
  M1 := VereinigungsMenge( W1_5, W_PF );
  M1 := VereinigungsMenge( M1, W_VF );
  for i := 1 to AnzahlElemente( M1 ) do
  begin
    afach := Einzelelement( M1, i );
    schr := IstSchriftlich( afach, 1, 1 );
    if schr then
    begin
      afach := Fachname( afach );
      if Assigned( FConABP ) then
{$IFDEF UNIDAC}
        FConABP.ExecSQL( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext) values (%d,%s,%s)',
                      [ FSchueler.ID,
                        QuotedStr( 'NICHTSCHR' ),
                        QuotedStr( Format( 'Das Fach "%s" darf nicht schriftlich belegt werden', [ afach ] ) )
                         ] ) );
{$ELSE}
        FConABP.Execute( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext) values (%d,%s,%s)',
                      [ FSchueler.ID,
                        QuotedStr( 'NICHTSCHR' ),
                        QuotedStr( Format( 'Das Fach "%s" darf nicht schriftlich belegt werden', [ afach ] ) )
                         ] ) );
{$ENDIF}
    end;
  end;

// NEU 22 Ist die Sume aller Fächer (ohne VX) >= 10 in EF.1
  bel := ( FSummen[C_E1].Kurse >= 10 );
  if not bel then
  begin
    err_code := 'ANZ_1';
    FehlerAusgeben( err_code, 'In EF.1 müssen mindestens 10 Kurse belegt werden. Bei der Kurszählung werden Vertiefungskurse nicht mitgezählt.' );
  end;


// NEU 23 Ist die Kursstundensumme (mit VX) >= 32 und <=36 in EF.1
  FSummen[7].Stunden := 0;
  for i := 1 to 6 do
    with FSummen[i] do
      FSummen[7].Stunden := FSummen[7].Stunden + Stunden;
  FSummen[7].Stunden := 0.5*FSummen[7].Stunden;

  anzahl := Schulstunden( FSummen[ C_E1 ].Stunden );
  if not Between( anzahl, 32, 36 ) then
  begin
    err_code := 'ANZ_2';
    FehlerAusgeben( err_code, 'Die Gesamtstundenzahl sollte 32 bis 36 Stunden betragen, um eine gleichmäßige Stundenbelastung in der Oberstufe zu gewährleisten.' );
  end;

// NEU 24 Ist die Summe belegter Projektkurse in EF.1 gleich Null?
  bel := GruppeBelegt( W_PF, 1, 1 );
  if bel then
  begin
    err_code := 'PF_1';
    FehlerAusgeben( err_code, 'In E1 können keine Projektkurse belegt werden' );
  end;

// NEU 25 G) Prüfung Anzahl Vertiefungsfächer entfällt

// NEU 26 Existieren in EF.1 (abgesehen von Vertiefungsfächern) belegte Fächer mit gleichem Statistikkürzel?
  if not PruefeInhaltsgleicheFaecher( C_E1 ) then
    FehlerAusgeben( 'IGF_1', 'Inhaltsgleiche Fächer dürfen nur einmal belegt werden' );

end;

procedure TAbiturBelegPruefer.GruppenBilden;
var
  fach, stfach, gruppe: string;
  i: integer;
  bgj: string;
	M: string;
begin
  W1_1 := '';// Deutsch
  W1_2 := '';		// SI-Fremdspr.
  W1_3 := '';		// SII-Fremdspr.
  W1_4 := '';		// Musik, Kunst
  W1_5 := '';		// mus Ersatzfächer LI IV
  W1_6 := '';
  W1   := '';		// Vereinigung von W1_1 bis W1_5

  W2_1 := '';		// Geschichte
  W2_2 := '';		// Sozialwissenschaften
  W2_3 := '';		// Erdkunde, Erziehungswissenschaft, Rechtskunde, Psychologie
  W2_4 := '';		// Philosophie
//  W2_5 := '';		// Geschichte, Zusatzkurs
//  W2_6 := '';		// Sozialwissenschaften, Zusatzkurs
  W2   := '';		// Vereinigungsmenge W2_1 bis W2_6
  W_ZK := '';

  W3_1 := '';		// Mathematik
  W3_2 := '';		// klassische Naturwissenschaften
  W3_3 := '';		// weitere Naturwissenschaften
  W3   := '';		// Vereinigungsmenge W3_1 bis W3_3

  W4   := '';		// Religion
  W5   := '';		// Sport
  W6   := '';		// bilingual unterrichtete SachFächer
  W_PF := '';
  W_VF := '';
  W_LK := '';
  W_GKS := '';
  W_GK := '';
  W_USprIstFS := ''; // Fächer in Fremdspachen
  W_AF := '';

	with fC0 do
	begin
		First;
		while not EOF do
		begin
			fach := FieldByname( 'FachInternKrz' ).AsString;
			stfach := FieldByname( 'FachStatKrz' ).AsString;
			gruppe := FieldByname( 'Fachgruppe' ).AsString;
  		bgj := FieldByname( 'BeginnJahrgang' ).AsString;
			if stfach = C_PROJEKTKURS then         //  Projektkurs
				ZuMengeHinzu( W_PF, fach )
			else if gruppe = 'D' then // Deutsch
				ZuMengeHinzu( W1_1, fach )
			else if gruppe = 'FS' then
			begin   // eine Fremdsprache
// #SCHILD30#
				ZuMengeHinzu( Fremdsprachen, copy( stfach, 1, 1 ) );		// erst mal zu den allgemeinen Fremdsprachen hinzu
        if bgj <> '' then
        begin
          if ( bgj >= '05' ) and ( bgj < IntToStr( FJg_E ) ) then
            ZuMengeHinzu( W1_2, fach )// SI-Sprachfach
          else
            ZuMengeHinzu( W1_3, fach );  // Zu den SII-Sprachfächern hinzu
        end else
          ZuMengeHinzu( W1_3, fach );  // Wenn kein Jahrgang eingetr. aber belegt >> Zu den SII-Sprachfächern hinzu
			end else if gruppe = 'MS' then    // musische Fächer
				ZuMengeHinzu( W1_4, fach )
			else if gruppe = 'ME' then    // musische Ersatzfächer
      begin
				ZuMengeHinzu( W1_5, fach );
        if stfach = 'VO' then
          ZuMengeHinzu( W1_6, fach )
        else if stfach = 'IN' then
          ZuMengeHinzu( W1_6, fach )
        else if stfach = 'IV' then
          ZuMengeHinzu( W1_6, fach );
      end else if gruppe = 'M' then         //  Mathematik
				ZuMengeHinzu( W3_1, fach )
			else if gruppe = 'NW' then         //  klassische Naturwissenschaften
				ZuMengeHinzu( W3_2, fach )
			else if gruppe = 'WN' then         //  weitere Naturwissenschaften
  			ZuMengeHinzu( W3_3, fach )
			else if gruppe = 'RE' then         //  Religion
				ZuMengeHinzu( W4, fach )
			else if gruppe = 'SP' then         //  Sport
				ZuMengeHinzu( W5, fach ) // Wegen S3 und S4
			else if stfach = C_VERTIEFUNGSKURS then         //  Vertiefungskurs
				ZuMengeHinzu( W_VF, fach );

      if FieldByName( 'Unterrichtssprache' ).AsString <> 'D' then
        ZuMengeHinzu( W_USprIstFS, fach );

      if FieldByname( 'AbiturFach' ).AsInteger > 0 then
        ZuMengeHinzu( W_AF, fach );

// Einzelne Fächer
			if ( fSchulform = 'GY' ) or ( fSchulform = 'GE' ) or ( FSchulform = '' ) then
			begin
        if stfach = 'GE' then
          ZuMengeHinzu( W2_1, fach )
        else if stfach = 'SW' then
          ZuMengeHinzu( W2_2, fach )
        else if ( stfach ='EK' ) or ( stfach = 'PA' ) or ( stfach = 'RK' ) or ( stfach = 'PS' ) then // Erdkunde, Erziehungswissenschaften, Rechtskunde, Psychologie
					ZuMengeHinzu( W2_3, fach )
				else if stfach = 'PL' then
					ZuMengeHinzu( W2_4, fach );
			end else if fSchulform = 'WB' then
			begin
        if stfach = 'GW' then
          ZuMengeHinzu( W2_1, fach )
				else if gruppe = 'GS'  then
				 ZuMengeHinzu( W2_2, fach )
				else if stfach = 'PL' then
					ZuMengeHinzu( W2_4, fach );
			end else if ( fSchulform = 'BK' ) then
      begin
        if stfach = 'GL' then
          ZuMengeHinzu( W2_1, fach );
      end;

// Hier Fallunterscheidung der
      if ( FieldByname( 'Unterrichtssprache' ).AsString <> 'D' ) and ( FieldByName( 'Fremdsprache' ).AsString = '-' ) then // ein bilinguales Sachfach
        ZuMengeHinzu( W6, fach );

      for i := C_Q1 to C_Q4 do
      begin
        if FieldByName( Format( 'KA_%d', [ i ] ) ).AsString = 'LK' then
          ZuMengeHinzu( W_LK, fach );
        if FieldByName( Format( 'KA_%d', [ i ] ) ).AsString = 'GKS' then
          ZuMengeHinzu( W_GKS, fach );
        if ( FieldByName( Format( 'KA_%d', [ i ] ) ).AsString = 'GKS' ) or
           ( FieldByName( Format( 'KA_%d', [ i ] ) ).AsString = 'GKM' ) or
           ( FieldByName( Format( 'KA_%d', [ i ] ) ).AsString = 'ZK' ) then
          ZuMengeHinzu( W_GK, fach );
        if ( FieldByName( Format( 'KA_%d', [ i ] ) ).AsString = 'ZK' ) then
          ZuMengeHinzu( W_ZK, fach );
      end;

      Next;
    end;
  end;

// Aufgabenbereiche

// Vereinigungsmengen erzeugen
	W1 := VereinigungsMenge( W1_1, W1_2 );
	W1 := VereinigungsMenge( W1, W1_3 );
	W1 := VereinigungsMenge( W1, W1_4 );
	W1 := VereinigungsMenge( W1, W1_5 );

	W2 := VereinigungsMenge( W2_1, W2_2 );
	W2 := VereinigungsMenge( W2, W2_3 );
	W2 := VereinigungsMenge( W2, W2_4 );
//	W2 := VereinigungsMenge( W2, W4 );

	W3 := VereinigungsMenge( W3_1, W3_2 );
	W3 := VereinigungsMenge( W3, W3_3 );

  W_AGF := '';
	for i := 1 to AnzahlElemente( W_AF ) do
	begin
		fach := EinzelElement( W_AF, i );
		if InMenge( fach, W1 ) then
			ZuMengeHinzu( W_AGF, '1' );
		if InMenge( fach, W2 ) then
			ZuMengeHinzu( W_AGF, '2' );
		if InMenge( fach, W3 ) then
			ZuMengeHinzu( W_AGF, '3' );
	end;



end;

function TAbiturBelegPruefer.LateinBelegt( const hjv, hjb: integer ): boolean;
var
  i: integer;
  afach: string;
  statkrz: string;
  ist_latein: boolean;
begin
  Result := false;
  for i := 1 to AnzahlElemente( W1_2 ) do
  begin
    afach := Einzelelement( W1_2, i );
    statkrz := StatistikKuerzel( afach );
    ist_latein := statkrz = 'L';
    if not ist_latein and ( length( statkrz ) > 1 ) then
      ist_latein := ( statkrz[1] = 'L' ) and ( statkrz[2] in [ '5', '6', '7', '8', '9' ] );
    if ist_latein and IstBelegt( afach, hjv, hjb ) then
    begin
      Result := true;
      break;
    end;
  end;
end;


procedure TAbiturBelegPruefer.PruefeLatein_Q;
var
  bel: boolean;
  err_code: string;
begin
//Wurde das Fach Latein in SI ab Klasse 5/6 belegt?
  if ( FSchueler.LateinBeginn = '05' ) or ( FSchueler.LateinBeginn = '06' ) or ( FSchueler.LateinBeginn = '07' )then
  begin //Fach Latein in SI ab Klasse 5/6/7 belegt
// Wurde Latein in E1 und E2 belegt?
    bel := LateinBelegt( C_E1, C_E2 );
    if not bel then
    begin
      err_code := 'L_10';
      FehlerAusgeben( err_code, 'Um das Latinum zu erlangen muss Latein in E1 und E2 belegt werden' );
    end;

// Wurde das Fach Latein in SI ab Klasse 8/9 belegt?
  end else if ( FSchueler.LateinBeginn = '08' ) or ( FSchueler.LateinBeginn = '09' ) then
  begin
//Wurde Latein von E1 bis Q4 belegt?
    bel := LateinBelegt( C_E1, C_Q4 );
    if not bel then
    begin
      err_code := 'L_11';
      FehlerAusgeben( err_code, 'Um das Latinum zu erlangen muss Latein mindestens bis Q2, je nach Stundenvolumen sogar bis Q4 belegt werden' );
    end;
  end else
  begin
    err_code := 'L_12';
    FehlerAusgeben( err_code, 'Um das Latinum zu erlangen muss Latein mindestens bis E2, je nach Beginn und Stundenvolumen sogar bis Q4 belegt werden' );
  end;
end;

procedure TAbiturBelegPruefer.PruefeFS2_Q;
var
  bel: boolean;
  err_code, afach: string;
  i: integer;
begin
// Ist das Häkchen "2. Fremdsprache in der Sekundarstufe I mauell geprüft" gesetzt
  if FSchueler.FS2_SekI_manuell then
    exit; // alles in Ordnung

// Findet sich in der Sprachenfolge eine 2. FS ab Klasse 5 oder 6 oder 7?
  if AnzahlElemente( FSchueler.S1_Sprachen_5_6 ) >= 2 then
//  J: Weiter
    exit;

// N: Findet sich in der Sprachenfolge eine 2.FS ab Klasse 8 ?
  if FSchueler.S1_Sprachen_8 <> '' then
  begin // 2.FS in SI
// J: Wurde diese FS in EF.1 und EF.2 belegt
    bel := GruppeBelegtSprache( FSchueler.S1_Sprachen_8, C_E1, C_E2 );
    if bel then
// J: WEiter
      exit;
// N: Wurde eine neu einsetzende Fremdsrache von EF.1 bis Q2.2 belegt?
    bel := GruppeBelegt( W1_3, C_E1, C_Q4 );
    if bel then
// J: Weiter
      exit;
// N: Belegungsfehler FS_13
    err_code := 'FS_13';
    FehlerAusgeben( err_code, 'Bei unzureichender 2. Fremdsprache, muss die in der Sekundarstufe 1 begonnene 2. Fremdsprache oder eine neu einsetzende Fremdsprache schriftlich in EF belegt werden.');
  end else
  begin
// N: Wurde eine neu einsetzende Fremdsprache von EF.1 bis Q2.2 belegt
    bel := GruppeBelegt( W1_3, C_E1, C_Q4 );
    if bel then
// J: Weiter
      exit;
// N: Belegungsfehler FS_14
    err_code := 'FS_14';
    FehlerAusgeben( err_code, 'Bei fehlender 2. Fremdsprache, muss eine neu einsetzende Fremdsprache durchgehend schriftlich belegt werden.' );
  end;

end;

procedure TAbiturBelegPruefer.PruefeBelegungAusE1;

  procedure StatKrzLoeschen( var m: string; const sk: string );
  var
    mr: string;
    i: integer;
    fkrz, skrz: string;
  begin
    for i := 1 to AnzahlElemente( m ) do
    begin
      fkrz := EinzelElement( m, i );
      skrz := StatistikKuerzel( fkrz );
      if skrz <> sk then
        ZumengeHinzu( mr, fkrz );
    end;
    m := mr;
  end;

var
  M1: string;
  add: boolean;
  i, j: integer;
  afach, statkrz,err_code, philo: string;
  showerr: boolean;
  bel, bel1: boolean;
begin
//26. Prüfe für jedes gewählte Fach von E2 bis Q4,außer für Literatur,
//vokalpraktische Kurse, instrumentalpraktische Kurse, Religion,
//ZK Geschichte, ZK Sozialwissenschaften,
//Vertiefungskurse, Projektkurse (und Philosophie falls Konstante „keinReli“ = 1),
//ob im vorhergehenden Halbjahr das Fach auch belegt wurde.

  M1 := '';
  with FC0 do
  begin
    First;
    while not Eof do
    begin
      statkrz := FieldByname( 'FachStatKrz' ).AsString;
      if ( statkrz = 'GE' ) or ( statkrz = 'SW' ) then
// Sonderfall Zusatzkurs GE und SW
      begin
        add := FieldByname( 'KA_3' ).AsString + FieldByname( 'KA_4' ).AsString + FieldByname( 'KA_5' ).AsString + FieldByname( 'KA_6' ).AsString <> '';
        if add then
          add := ( FieldByname( 'KA_3' ).AsString <> 'ZK' ) and
               ( FieldByname( 'KA_4' ).AsString <> 'ZK' ) and
               ( FieldByname( 'KA_5' ).AsString <> 'ZK' ) and
               ( FieldByname( 'KA_6' ).AsString <> 'ZK' )
      end else
        add := true;    // erst mal alle hinzu
      if add then
        ZuMengeHinzu( M1, FieldByname( 'FachInternKrz' ).AsString );
      Next;
    end;
  end;
// Jetzt die überflüssigen raus
  StatKrzLoeschen( M1, 'LI' ); // Literatur
  StatKrzLoeschen( M1, 'IV' ); // vokalpraktische Kurse, instrumentalpraktische Kurse
  StatKrzLoeschen( M1, 'IN' ); // instrumentalpraktische Kurse
  StatKrzLoeschen( M1, 'VO' ); // vokalpraktische Kurse
  StatKrzLoeschen( M1, 'RE' );
  StatKrzLoeschen( M1, 'KR' );
  StatKrzLoeschen( M1, 'ER' );
  StatKrzLoeschen( M1, 'HR' );
  StatKrzLoeschen( M1, 'IR' );
  StatKrzLoeschen( M1, 'AR' );
  StatKrzLoeschen( M1, 'YR' );
  StatKrzLoeschen( M1, C_VERTIEFUNGSKURS );
  StatKrzLoeschen( M1, C_PROJEKTKURS );

  StatKrzLoeschen( M1, 'PL' ); // Philosophie

// Jetzt mit dem Rest prüfen, ob, wenn in einem Abschnitt belegt, auch im vorherigen belegt
  showerr := false;
  for i := 1 to AnzahlElemente( M1 ) do
  begin
    afach := Einzelelement( M1, i );
    statkrz := StatistikKuerzel( afach );
    if statkrz = 'SP' then
// // bei Sport ist auch eine Belegung verschiedener Fächer möglich (SP, Ball, Leichtathletik)
    else
    begin
      for j := C_E2 to C_Q4 do
  //      if IstBelegt1( afach, j, j ) and not IstBelegt1( afach, j-1, j-1 ) then
        if IstBelegt( afach, j, j ) and not IstBelegt( afach, j-1, j-1 ) then
          showerr := true;
        if showerr then
          break;
    end;
  end;

// NEU 35
  if not showerr then
  begin
  // Ist Philo überhaupt belegt?
    if W2_4 = '' then // nicht belegt, also OK
      exit;

  // Ist Philo durchgehend belegt?
    philo := EinzelElement( W2_4, 1 );

// Schleife von EF.2 bis Q2.2
    bel := false;
    bel1 := false;
    showerr := false;

    for i := C_E2 to C_Q4 do
    begin
// Prüfe, ob Philo im Schleifenhalbjahr belegt ist
      if not IstBelegt1( philo, i, i ) then
        continue;
// Prüfe, ob Philo im Schleifenhalbjahr vorher belegt ist
      if IstBelegt1( philo, i-1, i-1 ) then
        continue;

// Prüfe, ob Religion im Schleifenhalbjahr belegt ist, wenn ja: Fehler
      for j := 1 to AnzahlElemente( W4 ) do
      begin
        afach := Einzelelement( W4, j );
        bel := IstBelegt1( afach, i, i );
        if bel then
        begin
          showerr := true;
          break;
        end;
      end;

// Prüfe, ob Religion im vorherigen Schleifenhalbjahr belegt ist, wenn nicht, Fehler
      if not showerr then
      begin
        bel1 := false;
        for j := 1 to AnzahlElemente( W4 ) do
        begin
          afach := Einzelelement( W4, j );
          bel1 := IstBelegt1( afach, i-1, i-1 );
          if bel1 then
            break;
        end;
        if not bel1 then
          showerr := true;
      end;

      if showerr then
        break;

    end;
  end;
  if showerr then
  begin
    err_code := 'E1BEL_10';
    FehlerAusgeben( err_code, 'Bis auf Literatur, vokal- und instrumentalpraktische Kurse, Zusatzkurse, Vertiefungskurse und Projektkurse können keine Fächer hinzugewählt werden, die nicht schon in E1 belegt wurden' );
  end;

end;

function TAbiturBelegPruefer.LeitfachBelegung_GY_GE( const pfach: string ): string;
var
  lfach1, lfach2, lfach1_stat, lfach2_stat, lfach, basisfach, fn, err_code, statkrz: string;
  lfach1_fs, lfach2_fs: boolean;

  i, pf_abschn, fach_id: integer;
  err1, bel, fnd: boolean;
  bel_str: string;

begin
  Result := '';
  err1 := false;
  if FC0.Locate( 'FachInternKrz', pfach, [loCaseInsensitive] ) then
// den ersten Abschnitt finden, in dem das Projektfach belegt ist
    pf_abschn := 0;
  for i := C_Q1 to C_Q4 do
  begin
    fn := Format( 'KA_%d', [ i ] );
    if Trim( FC0.FieldByName( fn ).AsString ) <> '' then
    begin
      pf_abschn := i;
      break;
    end;
  end;
  if pf_abschn = 0 then
  begin   // sollte eigentlich nicht vorkommen, da dies bedeutet, dass das Proj-Fach nicht belegt ist, aber man weiß ja nie
    exit;
  end;
  lfach1 := FC0.FieldByname( 'Leitfach1Krz' ).AsString;
  lfach2 := FC0.FieldByname( 'Leitfach2Krz' ).AsString;

  if FAufrufendesProgramm = apSCHILD then
  begin
    if lfach1 <> '' then
    begin
      lfach1_stat := StatistikKuerzel( lfach1 );   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
      lfach1_fs := IstFremdsprache( lfach1 )  // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
    end;
    if lfach2 <> '' then
    begin
      lfach2_stat := StatistikKuerzel( lfach2 );   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
      lfach2_fs := IstFremdsprache( lfach2 );   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
    end;
  end else
  begin
    if lfach1 <> '' then
    begin
      lfach1_stat := StatistikKuerzel( lfach1 );   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
      lfach1_fs := IstFremdsprache( lfach1 )  // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
    end;
    if lfach2 <> '' then
    begin
      lfach2_stat := StatistikKuerzel( lfach2 );   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
      lfach2_fs := IstFremdsprache( lfach2 );   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
    end;
//    lfach1_stat := FC0.FieldByname( 'Leitfach1Krz' ).AsString;   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
//    lfach2_stat := FC0.FieldByname( 'Leitfach2Krz' ).AsString;   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
  end;
  err1 := false;
  bel := false;
  with Fc0 do
  begin  // Schleife über die Fächer
    First;
    bel_str := '';
    while not Eof do
    begin
      fach_id := FieldByname( 'Fach_ID' ).AsInteger;
      if FieldByName( 'FachInternKrz' ).AsString <> pfach then
      begin // den projektkurs selbst nicht berücksichtigen
        basisfach := FieldByname( 'Basisfach' ).AsString; // das "Basisfach", bei F6 ist das "F"
        if ( FieldByName( 'Fremdsprache' ).AsString = '+' ) and ( lfach1_fs or lfach2_fs ) then  // bei Fremdsprachen
          fnd := ( copy( lfach1_stat, 1, 1 ) = basisfach ) or ( copy( lfach2_stat, 1, 1 ) = basisfach )
        else
          fnd := ( lfach1_stat = basisfach ) or ( lfach2_stat = basisfach ) ;
        if fnd then
        begin   // ein Fach mit dem gleichen Statistik-Kürzel wie das Leitfach gefunden, wurde es belegt?
          lfach := FieldByName( 'FachInternKrz' ).AsString; // Das Leitfach als schulinternes Kürzel
          if IstBelegt( lfach, C_Q1, C_Q1 ) and not AnsiContainsText( bel_str, '3' ) then
            bel_str := bel_str + '3';
          if IstBelegt( lfach, C_Q2, C_Q2 ) and not AnsiContainsText( bel_str, '4' ) then
            bel_str := bel_str + '4';
          if IstBelegt( lfach, C_Q3, C_Q3 ) and not AnsiContainsText( bel_str, '5' )then
            bel_str := bel_str + '5';
          if IstBelegt( lfach, C_Q4, C_Q4 ) and not AnsiContainsText( bel_str, '6' )then
            bel_str := bel_str + '6';
        end;
      end;
      if FieldByname( 'Fach_ID' ).AsInteger <> fach_id then
        Locate( 'Fach_ID', fach_id, [] );
      Next;
    end;
  end;

  Result := bel_str;

//// Projektkurs in zwei aufeinanderfolgenden Halbjahren der Qualifikationsphase belegt?
//    bel := IstBelegt( pfach, C_Q1, C_Q2 ) or IstBelegt( pfach, C_Q2, C_Q3 ) or IstBelegt( pfach, C_Q3, C_Q4 );
//    if not bel then
//    begin
//      err_code := 'PF_14';
//      FehlerAusgeben( err_code, 'Projektkurse müssen in zwei aufeinanderfolgenden Halbjahren belegt werden.' );
//    end else
//    begin // Ein Leitfach in Q1+Q2 belegt?
//      bel := AnsiContainsText( bel_str, '34' );
//      if not bel then
//      begin
////Ein Leitfach in Q3+Q4 belegt? und Projektkurs in Q3+Q4 belegt?
//        bel := AnsiContainsText( bel_str, '56' ) and IstBelegt( pfach, C_Q3, C_Q4 );
//        if not bel then
//        begin
//          err_code := 'PF_13';
//          FehlerAusgeben( err_code, 'Ein Projektkurs kann nur belegt werden, wenn in der Qualifikationsphase auch sein Leitfach zwei Halbjahre lang belegt wurde.' );
//        end;
//      end;
//    end;
//  end;
//  Result := bel and not err1;
end;

function TAbiturBelegPruefer.LeitfachBelegt_WB( const pfach: string ): boolean;
var
  lfach1, lfach2, lfach1_stat, lfach2_stat, lfach, basisfach, fn, err_code, statkrz: string;
  lfach1_fs, lfach2_fs: boolean;

  i, pf_abschn, fach_id: integer;
  err1, bel, fnd: boolean;
  bel_str: string;

begin
  err1 := false;
  if FC0.Locate( 'FachInternKrz', pfach, [loCaseInsensitive] ) then
// den ersten Abschnitt finden, in dem das Projektfach belegt ist
    pf_abschn := 0;
  for i := C_Q1 to C_Q4 do
  begin
    fn := Format( 'KA_%d', [ i ] );
    if Trim( FC0.FieldByName( fn ).AsString ) <> '' then
    begin
      pf_abschn := i;
      break;
    end;
  end;
  if pf_abschn = 0 then
  begin   // sollte eigentlich nicht vorkommen, da dies bedeutet, dass das Proj-Fach nicht belegt ist, aber man weiß ja nie
    Result := true;
    exit;
  end;
  lfach1 := FC0.FieldByname( 'Leitfach1Krz' ).AsString;
  lfach2 := FC0.FieldByname( 'Leitfach2Krz' ).AsString;

  if FAufrufendesProgramm = apSCHILD then
  begin
    if lfach1 <> '' then
    begin
      lfach1_stat := StatistikKuerzel( lfach1 );   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
      lfach1_fs := IstFremdsprache( lfach1 )  // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
    end;
    if lfach2 <> '' then
    begin
      lfach2_stat := StatistikKuerzel( lfach2 );   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
      lfach2_fs := IstFremdsprache( lfach2 );   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
    end;
  end else
  begin
    if lfach1 <> '' then
    begin
      lfach1_stat := StatistikKuerzel( lfach1 );   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
      lfach1_fs := IstFremdsprache( lfach1 )  // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
    end;
    if lfach2 <> '' then
    begin
      lfach2_stat := StatistikKuerzel( lfach2 );   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
      lfach2_fs := IstFremdsprache( lfach2 );   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
    end;
//    lfach1_stat := FC0.FieldByname( 'Leitfach1Krz' ).AsString;   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
//    lfach2_stat := FC0.FieldByname( 'Leitfach2Krz' ).AsString;   // das Leitfach in Statistik-Notation, kann z.B. F6 oder F sein
  end;
  err1 := false;
  bel := false;
  with Fc0 do
  begin  // Schleife über die Fächer
    First;
    bel_str := '';
    while not Eof do
    begin
      fach_id := FieldByname( 'Fach_ID' ).AsInteger;
      if FieldByName( 'FachInternKrz' ).AsString <> pfach then
      begin // den projektkurs selbst nicht berücksichtigen
        basisfach := FieldByname( 'Basisfach' ).AsString; // das "Basisfach", bei F6 ist das "F"
        if ( FieldByName( 'Fremdsprache' ).AsString = '+' ) and ( lfach1_fs or lfach2_fs ) then  // bei Fremdsprachen
          fnd := ( copy( lfach1_stat, 1, 1 ) = basisfach ) or ( copy( lfach2_stat, 1, 1 ) = basisfach )
        else
          fnd := ( lfach1_stat = basisfach ) or ( lfach2_stat = basisfach ) ;
        if fnd then
        begin   // ein Fach mit dem gleichen Statistik-Kürzel wie das Leitfach gefunden, wurde es belegt?
          lfach := FieldByName( 'FachInternKrz' ).AsString; // Das Leitfach als schulinternes Kürzel
          if IstBelegt( lfach, C_Q1, C_Q1 ) and not AnsiContainsText( bel_str, '3' ) then
            bel_str := bel_str + '3';
          if IstBelegt( lfach, C_Q2, C_Q2 ) and not AnsiContainsText( bel_str, '4' ) then
            bel_str := bel_str + '4';
          if IstBelegt( lfach, C_Q3, C_Q3 ) and not AnsiContainsText( bel_str, '5' )then
            bel_str := bel_str + '5';
          if IstBelegt( lfach, C_Q4, C_Q4 ) and not AnsiContainsText( bel_str, '6' )then
            bel_str := bel_str + '6';
        end;
      end;
      if FieldByname( 'Fach_ID' ).AsInteger <> fach_id then
        Locate( 'Fach_ID', fach_id, [] );
      Next;
    end;
  end;
//
// Projektkurs in zwei aufeinanderfolgenden Halbjahren der Qualifikationsphase belegt?
  bel := IstBelegt( pfach, C_Q1, C_Q2 ) or IstBelegt( pfach, C_Q2, C_Q3 ) or IstBelegt( pfach, C_Q3, C_Q4 );
  if not bel then
  begin
    err_code := 'PF_14';
    FehlerAusgeben( err_code, 'Projektkurse müssen in zwei aufeinanderfolgenden Halbjahren belegt werden.' );
  end else
  begin // Ein Leitfach in Q1+Q2 belegt?
    bel := AnsiContainsText( bel_str, '34' );
    if not bel then
    begin
//Ein Leitfach in Q3+Q4 belegt? und Projektkurs in Q3+Q4 belegt?
      bel := AnsiContainsText( bel_str, '56' ) and IstBelegt( pfach, C_Q3, C_Q4 );
      if not bel then
      begin
        err_code := 'PF_13';
        FehlerAusgeben( err_code, 'Ein Projektkurs kann nur belegt werden, wenn in der Qualifikationsphase auch sein Leitfach zwei Halbjahre lang belegt wurde.' );
      end;
    end;
  end;
  Result := bel and not err1;
end;



procedure TAbiturBelegPruefer.PruefeReligionNeu( const BEGINN: integer );
var
  i, j: integer;
  M1, fach, errcode: string;
  phbel, bel, tmp_abi, nur_w2_4: boolean;
  anzGE, anzSW: integer;
begin
  tmp_abi := FFuerAbitur;

  if BEGINN = C_E1 then
  begin
    phbel := GruppeBelegt( W2_4, C_E1, C_Q4 );
    M1 := W2_1;
    M1 := Vereinigungsmenge( M1, W2_2 );
    M1 := Vereinigungsmenge( M1, W2_3 );

    errcode := '';
// NEU 22 Schleife von EF.1 bis EF.2: Wurde Religionslehre im Schleifenhalbjahr belegt?
    for j := C_E1 to C_E2 do
    begin
      bel := GruppeBelegt( W4, j, j );
// J : Nächstes SChleifenhalbjahr
      if bel then
        continue;
//N: Wurde Philosophie im Schleifenhalbjahr belegt
      bel := GruppeBelegt( W2_4, j, j );
      if bel then
      begin
//    J: Wurde Philosophie von EF.1 bis Q2.2 belegt?
        if phbel then
        begin
//      J: Wurde im Schleifenhalbjahr neben Philosophie eine weitere Gesellschaftswissenschaft belegt?
          bel := GruppeBelegt( M1, j, j );
//        J: Nächstes Schleifenhalbjahr
          if bel then
            continue
          else
//        N: Belegungsfehler RE_10
            errcode := 'RE_10';
        end else
//      N: Nächstes Schleifenhalbjahr
          continue;
      end else
      begin
//    N: Belegungsfehler RE_10
        errcode := 'RE_10';
      end;
    end; // end for

  end;

// Erst mal prüfen: Ist W2.4 einziges durchgened belegtes fach in W2?
  M1 := '';
  for i := 1 to AnzahlElemente( W2 ) do
  begin
    fach := EinzelElement( W2, i );
    if IstBelegt( fach, C_Q1, C_Q4, '-ZK' ) then
      ZuMengeHinzu( M1, fach );
  end;
  nur_w2_4 := Differenzmenge( M1, W2_4 ) = '';

// Anzahl belegte GE und SW Kurse in Q-Phase
  anzGE := 0;
  for i := 1 to AnzahlElemente( W2_1 ) do
  begin
    fach := EinzelElement( W2_1, i );
    anzGE := anzGE + AnzahlBelegteHalbjahre( fach, C_Q1, C_Q4 );
  end;

  anzSW := 0;
  for i := 1 to AnzahlElemente( W2_2 ) do
  begin
    fach := EinzelElement( W2_2, i );
    anzSW := anzSW + AnzahlBelegteHalbjahre( fach, C_Q1, C_Q4 );
  end;


  for j := C_Q1 to C_Q2 do
  begin
// NEU 23 Schleife von Q!.1 bis Q1.2: Wurde Religionslehre im Schleifenhalbjahr belegt?
    bel := GruppeBelegt( W4, j, j );
//  J: Nächstes SChleifenhalbjahr
    if bel then
      continue;
//  N: Wurde Philosophie im Schleifenhalbjahr belegt?
    bel := GruppeBelegt( W2_4, j, j );
    if bel then
    begin
//    J: Ist Philosophie die einzige Gesellschaftswissenschaft, die durchgehend von EF.1 bis Q2.2 belegt wurde (ohne ZKs)?
      if nur_w2_4 then
      begin
//      J: Wurde im Schleifenhalbjahr Erdkunde oder Erziehungswissenschaft oder Rechtskunde oder Psychologie belegt
        bel := GruppeBelegt( W2_3, j, j );
        if bel then
//        J: Nächstes Schleifenhalbjahr
          continue;
//        N: Ist das Schleifenhalbjahr Q1.1 und wurden drei Kurse Geschichte oder drei Kurse Sozialwissenschaften in der Qualifikationsphase
//           (Q1.1 bis Q2.2) belegt (auch ZKs)?
        if ( j = C_Q1 ) and ( ( anzGE >= 3 ) or ( anzSW >= 3 ) ) then
          continue
        else
          errcode := 'RE_10';
      end else
//    N: Nächstes Schleifenhalbjahr
        continue;

    end else
//    N: Belegungsfehler RE_10;
      errcode := 'RE_10';
  end;

//  FFuerAbitur := tmp_abi;
  if errcode <> '' then
      FehlerAusgeben( errcode, 'Religionslehre muss wenigstens von EF.1-Q1.2 durchgehend belegt werden.' );

end;


function TAbiturBelegPruefer.PruefeReligion( hjv, hjb: integer ): boolean;
var
  ia, j, anz_bel: integer;
  bel: boolean;
  afach, err_code: string;
  showerr: boolean;
  M: string;
  w2_bel: boolean;
  istart: integer;

begin
// HINWEIS: Diese Prozedur enthält auch die "alte" Version für die Q-Phase
{•	Auf der Folie 18 wird Religionslehre geprüft.
Hier gibt es drei mögliche Ausstiegspunkte (oben/mitte/unten).
Die Schleife läuft zunächst bis Q1.2. Sollte einer der Ausstiegspunkte oben/mitte angelaufen werden,
so kommt es zu einer Fehlermeldung.
Sollte der Ausstiegspunkt in Q1.1 unten angelaufen werden, so wird zunächst keine Fehlermeldung ausgegeben,
sondern geprüft, ob ein Fach aus W2.3 zumindest belegt wurde.
Wenn ja, darf die Schleife ein Halbjahr weiterlaufen (also bis Q2.1).
Gleiches gilt für Fehlermeldungen in den Halbjahren Q1.2 und Q2.1.
Sollte kein Fach aus W2.3 im Halbjahr belegt worden sein, so kommt es zur Fehlermeldung.
Wenn kein Halbjahr mehr erweitert werden kann, so kommt es ebenfalls zur Fehlermeldung.
}
  showerr := false;
  if FFuerAbitur then
    istart := C_Q1
  else
    istart := C_E1;

//Wurde mindestens ein Fach aus F2.1/F2.2/F2.3 durchgehend von E1 bis Q4 belegt?
//  if hjv = C_Q1 then
  begin
    M := W2_1;
    M := Vereinigungsmenge( M, W2_2 );
    M := Vereinigungsmenge( M, W2_3 );
    w2_bel := GruppeBelegt( M, istart, C_Q4 );
  end;

  anz_bel := 0;
  ia := hjv - 1;
  while ia < hjb do
//  for ia := hjv to hjb do
  begin
    inc( ia );
//Es existiert mindestens ein belegtes Fach in F4 im Schleifen- Halbjahr
    bel := GruppeBelegt( W4, ia, ia );
    if bel then
    begin
      inc( anz_bel );
      continue;
    end;

//Wurde F2.4 im Schleifen- Halbjahr belegt? (Philosophie)
    bel := GruppeBelegt( W2_4, ia, ia );
    if not bel then
    begin // oberer Ausstiegspunkt
      showerr := true;
      break;
    end;

// NEU Jan. 2014 rausgenommen
//    FkeinReli := 1;

// Bei Prüfung ab Q1: Wurde mindestens ein Fach aus F2.1/F2.2/F2.3 durchgehend von E1 bis Q4 belegt?
    if ( hjv = C_Q1 ) and w2_bel then
      continue;

//Wurde F2.4 von E1 bis Q4 durchgehend belegt?
    bel := GruppeBelegt( W2_4, istart, C_Q4 );
    if hjv = C_E1 then
    begin // Folie 17
      if not bel then
        continue; // hier keine Fehlermeldung
    end else
    begin
      if not bel then
      begin // mittlerer Ausstiegspkt.
        showerr := true;
        break;
      end;
    end;

    if hjv = C_E1 then
//Wurde im Schleifen-Halbjahr ein Fach aus F2.1/F2.2/F2.3 belegt?
      bel := GruppeBelegt( M, ia, ia )
    else
//Wurde im Schleifen-Halbjahr ein Fach aus F2.3 belegt?
      bel := GruppeBelegt( W2_3, ia, ia ); // Geselschaftswiss.Fach

    if not bel and not FFuerAbitur then
    begin
      showerr := true;
      break;
    end;

    if bel then
      inc( anz_bel );
    if FFuerAbitur and not bel then
    begin  // passiert, wenn zwar belegt, aber 0 Punkte
//Sollte der Ausstiegspunkt in Q1.1 unten angelaufen werden, so wird zunächst keine Fehlermeldung ausgegeben,
//sondern geprüft, ob ein Fach aus W2.3 zumindest belegt wurde
      FFuerAbitur := false; // Um die Punkteprüfung temporär abzuschalten
      bel := GruppeBelegt( W2_3, ia, ia );
      FFuerAbitur := true; // wieder anschalten
//Sollte kein Fach aus W2.3 im Halbjahr belegt worden sein, so kommt es zur Fehlermeldung.
      if not bel then
      begin
        showerr := true;
        break;
      end;
//Wenn ein Fach aus W2.3 im Halbjahr belegt wurde, darf die Schleife ein Halbjahr weiterlaufen (also bis Q2.1).
      inc( hjb );
//Wenn kein Halbjahr mehr erweitert werden kann, so kommt es ebenfalls zur Fehlermeldung.
      if hjb > C_Q4 then
      begin
        showerr := true;
        break;
      end;
    end;
  end;

  Result := not showerr;

end;

function TAbiturBelegPruefer.PruefeReligion_Q_GY_GE: string;

  function Stern1( const hj: integer ): boolean;
  var
    M_, fach: string;
    i: integer;
  begin
    Result := false;
    case hj of
    C_Q1 :
// Falls Schleife in Q1.1
// Ist W2_1 ohne ZK in Q1.2 und Q2.1 belegt
// Oder W2_1 nur ZK in Q2.1 und Q2.2 belegt?
      begin
        for i := 1 to AnzahlElemente( W2_1 ) do
        begin
          fach := EinzelElement( W2_1, i );
          Result := IstBelegt( fach, C_Q2, C_Q3, '-ZK' ) or IstBelegt( fach, C_Q3, C_Q4, '+ZK' );
          if Result then
            exit;
        end;
      end;
    C_Q2 :
//Falls Schleife in Q2.1
// Ist W2_1 ohne ZK durchgehend belegt?
      begin
        for i := 1 to AnzahlElemente( W2_1 ) do
        begin
          fach := EinzelElement( W2_1, i );
          Result := IstBelegt( fach, C_Q1, C_Q4, '-ZK' );
          if Result then
            exit;
        end;
      end;
    end;
  end;

  function Stern2( const hj: integer ): boolean;
  var
    M_, fach: string;
    i: integer;
  begin
    Result := false;
    case hj of
    C_Q1 :
// Falls Schleife in Q1.1
// Ist W2_2 ohne ZK in Q1.2 und Q2.1 belegt
// Oder W2_2 nur ZK in Q2.1 und Q2.2 belegt?
      begin
        for i := 1 to AnzahlElemente( W2_2 ) do
        begin
          fach := EinzelElement( W2_2, i );
          Result := IstBelegt( fach, C_Q2, C_Q3, '-ZK' ) or IstBelegt( fach, C_Q3, C_Q4, '+ZK' );
          if Result then
            exit;
        end;
      end;
    C_Q2 :
// Ist W2_2 ohne ZK durchgehend belegt?
      begin
        for i := 1 to AnzahlElemente( W2_2 ) do
        begin
          fach := EinzelElement( W2_2, i );
          Result := IstBelegt( fach, C_Q1, C_Q4, '-ZK' );
          if Result then
            exit;
        end;
      end;
    end;
  end;

  function Punkte_groesser_0( const m: string; const abschn: integer ): boolean;
  var
    i: integer;
    fach: string;
  begin
    Result := false;
    for i := 1 to AnzahlElemente( m ) do
    begin
      fach := EinzelElement( m, i );
      Result := Punkte( fach, abschn ) > 0;
      if Result then
        exit;
    end;
  end;


var
  i, j, reli_zaehler: integer;
  M_, fach: string;
  nur_w2_4, bel: boolean;
  tmp_abi: boolean;
begin
  Result := 'RE_10';

// Erst mal prüfen: Ist W2.4 einziges durchgened belegtes fach in W2?
  M_ := '';
  reli_zaehler := 0;
  tmp_abi := FFuerAbitur;
  for i := 1 to AnzahlElemente( W2 ) do
  begin
    fach := EinzelElement( W2, i );
    if IstBelegt( fach, C_Q1, C_Q4, '-ZK' ) then
      ZuMengeHinzu( M_, fach );
  end;
  nur_w2_4 := Differenzmenge( M_, W2_4 ) = '';

  try

  // Schleife Q1.1 bis Q1.2
  // NEU: Das Schleifenende kann auch bis Q2.2 gehen, dann darf aber nur bis "W2_3/AF belegt?" gegangen werden
    for j := C_Q1 to C_Q4 do
    begin

      if reli_zaehler = 2 then
        break;

  // W4 belegt ?
  // Neu: Hier FFuerAbitur temporär ausschalten
      FFuerAbitur := false;
      bel := false;
      for i := 1 to AnzahlElemente( W4 ) do
      begin
        fach := EinzelElement( W4, i );
        bel := Istbelegt( fach, j, j );
        if bel then
          break;
      end;
//      FFuerAbitur := tmp_abi;

      if bel then
      begin
        if not FuerAbitur then
          inc( reli_zaehler )
        else if Punkte_groesser_0( W4, j ) then
          inc( reli_zaehler );
        continue; // nächster Schleifenschritt
      end;

  // W2.4 belegt?
  // Farhe: Was bedeutet hier "belegt" in Verbindung mit der 0 Punkte-Regelung ?
  // Antwort Raffenberg: Auch 0 Punkte sind hier "belegt"
      FFuerAbitur := false; // wieder ausschalten
      for i := 1 to AnzahlElemente( W2_4 ) do
      begin
        fach := EinzelElement( W2_4, i );
        bel := Istbelegt( fach, j, j );
        if bel then
          break;
      end;
//      FFuerAbitur := tmp_abi;
      if not bel then // Fehlermeldung
        exit;

  // Ist W2_4 Abifach oder W2_4 einziges durchgehend belegets Fach in W2 ?
  // NEU Ja. 2014: Ist W2_4 einziges durchgehend belegets Fach in W2 ?
  // Wenn nein, nächster Schleifenschritt
//      if not( nur_w2_4 or ( Schnittmenge( W2_4, W_AF ) <> '' ) ) then
      if not nur_w2_4  then
      begin
        if not FFuerAbitur then
          inc( reli_zaehler )
        else if Punkte_groesser_0( W2_4, j ) then
          inc( reli_zaehler );
        continue; // nächster Schleifenschritt
      end;

  // Ist W2_3 \ AF belegt (im Abschnitt );
  // Neu Jan. 2014: Ist W2_3 belegt (im Abschnitt );
//      M_ := Differenzmenge( W2_3, W_AF );
      M_ := W2_3;
      bel := false;
      FFuerAbitur := false; // wieder ausschalten
      for i := 1 to AnzahlElemente( M_ ) do
      begin
        fach := EinzelElement( M_, i );
        bel := IstBelegt( fach, j, j );
        if bel then
          break;
      end;
//      FFuerAbitur := tmp_abi;
      if bel then
      begin
        if not FuerAbitur then
          inc( reli_zaehler )
        else if Punkte_groesser_0( M_, j ) then
          inc( reli_zaehler );
        continue; // nächster Schleifenschritt
      end;

  // NEU wenn wir in C_Q3 oder C_Q4 sind und hier ankommen, ist was faul
      if j > C_Q2 then
        exit;

  // Ist W2_1 ohne ZK / AF belegt?    also GE
// NEU Jan. 2014: Ist W2_1 ohne ZK belegt?    also GE
//      M_ := Differenzmenge( W2_1, W_AF );
      M_ := W2_1;
      bel := false;
      for i := 1 to AnzahlElemente( M_ ) do
      begin
        fach := EinzelElement( M_, i );
        bel := IstBelegt( fach, j, j, '-ZK' );
        if bel then
          break;
      end;

      if bel then
      begin
        if Stern2( j ) then
        begin
          inc( reli_zaehler );
          continue;
        end;
      end;
  // W2_2 ohne ZK / AF belegt?
  // NEU Jan. 2014: W2_2 ohne ZK ?
//      M_ := DifferenzMenge( W2_2, W_AF);
      M_ := W2_2;
      bel := false;
      for i := 1 to AnzahlElemente( M_ ) do
      begin
        fach := EinzelElement( M_, i );
        bel := IstBelegt( fach, j, j, '-ZK' );
        if bel then
          break;
      end;
      if bel then
      begin
        if not Stern1( j ) then
          exit
        else
        begin
          inc( reli_zaehler );
          continue;
        end;
      end else
        exit;

    end;

  // Neue Folie Einschub von Herrrn Raffenberg von Anfang März 2011
    if FkeinReli = 0 then
    begin //
      M_ := Differenzmenge( W2_4, W_AF );
      for j := C_Q3 to C_Q4 do
      begin // Schleife von Q2.1 bis Q2.2 falls keinReli = 0
  //existiert mindestens ein belegtes Fach in F4 im Schleifen- Halbjahr?
        bel := GruppeBelegt( W4, j, j );
        if not bel then
        begin
  //Falls nicht: Wurde F2.4 im Schleifen- Halbjahr belegt?
          bel := GruppeBelegt( M_, j, j );
          if bel then
            FKeinReli := 1;
        end;
      end;
    end;
  finally
    if reli_zaehler >= 2 then
      Result := '';
  end;

end;

procedure TAbiturBelegPruefer.BilingualePruefung_GY_GE( const BEGINN: integer );
var
  afach, uspr, statkrz: string;
  i, j: integer;
  anzahl_bel, anzahl_schr: integer;
  err_code1, err_code2: string;
  M1: string;
  ist_abifach, schr, bel: boolean;
begin
// J: Wurde das zum biling. Bildungsgang zugehörige Fremdsprachenfach in EF.1 und Ef.2 schriftlich und von Q1.1 bis Q2.2 als LK belegt?
  M1 := W1_2;
  for i := 1 to AnzahlElemente( W1_2 ) do
  begin
    afach := Einzelelement( W1_2, i );
    statkrz := StatistikKuerzel( afach );
    if BEGINN = C_E1 then
      schr := ( statkrz[1] = FSchueler.BilingualerZweig ) and
              IstSchriftlich( afach, C_E1, C_E2 ) and
              IstLK( afach, C_Q1, C_Q4 )
    else
      schr := ( statkrz[1] = FSchueler.BilingualerZweig ) and
              IstLK( afach, C_Q1, C_Q4 );
    if schr then
      break;
  end;
//  N: Belegungsfehler BIL_10
  if not schr then
  begin
    err_code1 := 'BIL_10';
    FehlerAusgeben( err_code1, 'Im bilingualen Bildungsgang muss die bilinguale Fremdsprache in E1 und E2 schriftlich und in Q1 bis Q4 als Leistungskurs belegt werden' );
  end;

  if BEGINN = C_E1 then
  begin
    err_code1 := '';
    err_code2 := '';

    for j := C_E1 to C_E2 do
    begin
// Schleife von EF.1 bis EF.2: WUrde mindestens ein zum bilingualen Bildungsgang zugehöriges Sachfach im Schleifenhalbjahr belegt?
      anzahl_bel := 0;
      for i := 1 to AnzahlElemente( W6 ) do  // W6 die bilingualen Sachfächer
      begin
        afach := Einzelelement( W6, i );
        uspr := UnterrichtsSprache( afach );
        if ( uspr = FSchueler.BilingualerZweig ) then
          inc( anzahl_bel );
      end;
      if anzahl_bel >= 1 then
      begin
//    J : Wurden mindestens zwei zum bilingualen Bildungsgang zugehörige Sachfächer im Schleifenhalbjahr belegt?
        if anzahl_bel >= 2 then
//      J: Nichts
        else
//      N : Hinweis BIL_11
          err_code2 := 'BIL_11';
      end else
//    N: Belegungsfehler BIL_15
        err_code1 := 'BIL_15';
    end;
    if err_code1 <> '' then
      FehlerAusgeben( err_code1, 'Im bilingualen Bildungsgang muss die bilinguale Fremdsprache in E1 und E2 schriftlich und in Q1 bis Q4 als Leistungskurs belegt werden' );
    if err_code2 <> '' then
      FehlerAusgeben( err_code2, 'Im bilingualen Bildungsgang werden in EF.1 und EF.2 in der Regel zwei bilinguale Sachfächer belegt.' );
  end;

// Prüfung auf Belegung von EF.1 bis Q2.2 und Schriftlichkeit von Q1.1. bis Q2.1
  anzahl_bel := 0;
  anzahl_schr := 0;
  ist_abifach := false;

  for i := 1 to AnzahlElemente( W6 ) do  // W6 die bilingualen Sachfächer
  begin
    afach := Einzelelement( W6, i );
    uspr := UnterrichtsSprache( afach );
    if ( uspr = FSchueler.BilingualerZweig ) then
    begin
      if IstBelegt( afach, BEGINN , C_Q4 )  then
        inc( anzahl_bel );
      if IstSchriftlich( afach, C_Q1, C_Q3 ) then
        inc( anzahl_schr );
      if IstAbifach( afach, [3,4] ) then
        ist_abifach := true;
    end;
  end;

// Wurde mindestens ein zum bilingualen Bildungsgang zugehöriges Sachfach von EF.1 bis Q2.2 belegt und von Q1.1 bis Q2.1 schriftlich belegt?
  if not ( ( anzahl_bel >= 1 ) and ( anzahl_schr >= 1 ) ) then
  begin
// N: Klausrurfehler  BIL_12
    err_code1 := 'BIL_12';
    FehlerAusgeben( err_code1, 'Im bilingualen Bildungsgang muss ein bilinguales Sachfach durchgehend von Q1 bis Q3 schriftlich belegt werden' );
  end;

// Ist ein zum bilingualen Bildungsgang zugehöriges Sachfach 3. oder 4. Abifach
  if not ist_abifach then
  begin
// N: Belegungsfehler BIL_13
    err_code1 := 'BIL_13';
    FehlerAusgeben( err_code1, 'Ein bilinguales Sachfach muss unter den Abiturfächern sein' );
  end;

end; // Ende BilingualerZweig



procedure TAbiturBelegPruefer.Pruefe_Q_Phase_GY_GE( const BEGINN: integer );
var
  fnd, err, schr, bel, bel2, muendl: boolean;
  i, j: integer;
  err_code, afach, aspr, M1, statkrz,abi_1_4, lfach_bel, bilsf_hj: string;
  M_A, M_B, M_C, M_D, LK1: string;
  uspr, SprBilSF, Sprachen: string;
  beg_zk: integer;
  anzK, anzW, anzahlQ, anzahlE, anzahlPJF, anzahlEinzelPJK  : integer;
  ist_abifach, tmp_bool: boolean;
  ds_e, ds_q: double;
  spr_5_6, spr_8: string;
begin
  FBelegMeldungen.Clear;
  FKursZaehler.Phase := 'G';
//  if BEGINN = C_E1 then
  begin
    PruefeDoppelbelegung( Vereinigungsmenge( W1_2, W1_3 ), true, true );
//  Prüfung auf paraLlele Belegung in einem konkreten Abschnitt bei biling. Sachfächern
    PruefeDoppelbelegung( M1, false, false ); // Die biling. Sachfächer prüfen (z.B. ob EK_F und EK_E belegt ist)
  end;
  M1 := Vereinigungsmenge( W2_1, W6 );
  M1 := Vereinigungsmenge( W2_2, M1 );
  M1 := Vereinigungsmenge( W2_3, M1 );
  M1 := Vereinigungsmenge( W2_4, M1 );
  M1 := Vereinigungsmenge( W3, M1 );
//  if BEGINN = C_E1 then
    PruefeDoppelbelegung( M1, false, false );  // Fremdsprachen, dürfen grundsätzlich nicht gleichzeitig belegt sein

// NEU 2 Wurde Deutsch von EF.1 bis Q2.2 belegt?
  bel := GruppeBelegt( W1_1, BEGINN, C_Q4 );
  if not bel then
  begin
    err_code := 'D_10';
    FehlerAusgeben( err_code, 'Deutsch muss von E1 bis Q4 belegt werden' );
  end;

// NEU 3 Wurde Deutsch von EF.1 bis Q2.1 schriftlich belegt?
  schr := GruppeSchriftlich( W1_1, BEGINN, C_Q3, false );
  if not schr then
  begin
    err_code := 'D_11';
    FehlerAusgeben( err_code, 'Deutsch muss von E1 bis mindestens Q3 schriftlich belegt werden' );
  end;

// NEU 4 Wurde Kunst oder Musik von EF.1 bis Q1.2 belegt?
  if not FFuerAbitur then
  begin
    bel := GruppeBelegt( W1_4, C_E1, C_Q2 );
// J: Weiter

// N: Wurde Kunst oder Musik von EF.1 bis EF.2 belegt?
    if not bel then
    begin
      bel := GruppeBelegt( W1_4, C_E1, C_E2 );
      if bel then
      begin
      // J: Wurde Literatur oder ein vokalprakt. Fach oder ein instrumentalpraktisches Fach in (Q1.1 und Q1.2) oder in (Q1.2 und Q2.1) oder in (Q2.1 und Q2.2) belegt?
        bel := false;
        for i := 1 to AnzahlElemente( W1_5 ) do
        begin
          afach := Einzelelement( W1_5, i );
          bel := IstBelegt( afach, C_Q1, C_Q2 ) or IstBelegt( afach, C_Q2, C_Q3 ) or IstBelegt( afach, C_Q3, C_Q4 );
          if bel then
            break;
        end;
        // J: Weiter
        if not bel then
        begin
        // N: Belegungsfehler KU_MU_10;
          err_code := 'KU_MU_10';
          FehlerAusgeben( err_code, 'Mindestens eines der Fächer Kunst oder Musik muss von E1 bis mindestens Q2 durchgehend belegt werden. In der Qualifikationsphase kann auch alternativ Literatur, ein vokalpraktisches oder ein instrumentalpraktisches Fach belegt werden' );
        end;
      end else
      begin
    // N: Belegungsfehler KU_MU_10;
        err_code := 'KU_MU_10';
        FehlerAusgeben( err_code, 'Mindestens eines der Fächer Kunst oder Musik muss von E1 bis mindestens Q2 durchgehend belegt werden. In der Qualifikationsphase kann auch alternativ Literatur, ein vokalpraktisches oder ein instrumentalpraktisches Fach belegt werden' );
      end;
    end;
  end else
  begin
// Hier wird Fachweise W1.4 U W1.5 geprüft. Sobald ein Fach die Bedingung (in zwei aufeinanderfolgenden Hj.Punkte>0) erfüllt
//geht es zur nächsten Prüfung. Sollte kein Fach die Bedingung erfüllen, kommt es zur Fehlermeldung
    bel := false;
    M1 := Vereinigungsmenge( W1_4, W1_5 );
    for i := 1 to AnzahlElemente( M1 ) do
    begin
      afach := Einzelelement( M1, i );
      bel := IstBelegtPunkteVar( afach );
      if bel then
        break;
    end;
    if not bel then
    begin
      err_code := 'KU_MU_10';
      FehlerAusgeben( err_code, 'Mindestens eines der Fächer Kunst oder Musik muss von E1 bis mindestens Q2 durchgehend belegt werden. In der Qualifikationsphase kann auch alternativ Literatur, ein vokalpraktisches oder ein instrumentalpraktisches Fach belegt werden' );
    end;
  end;


// NEU 5 Prüfe nacheinander für Literatur, instrumentalpraktisches Fach, vokalpraktisches Fach Geschichte Zusatzkurs und Sozialwissenschaften Zusatzkurs:
// Wurde das Fach genau zweimal belegt

  M1 := Vereinigungsmenge( W1_5, W_ZK );
  err := false;
  for i := 1 to AnzahlElemente( M1 ) do // SChleife über Literatur, instrumentalpraktisches Fach, vokalpraktisches Fach, Zusatzkurse
  begin
    afach := Einzelelement( M1, i );
    j := BeginnZK( afach );
    if j = 0 then
      j := C_Q1;
    anzahlQ := AnzahlBelegteHalbjahre( afach, j, C_Q4 );
// Wurde das Fach genau zweimal belegt?
    if anzahlQ = 2 then
    begin
//  J: Wurde das Fach in (Q1.1 und Q1.2) oder in (Q1.2 und Q2.1) oder in (Q2.1 und Q2.2) belegt?
      bel := IstBelegt( afach, C_Q1, C_Q2 ) or IstBelegt( afach, C_Q2, C_Q3 ) or IstBelegt( afach, C_Q3, C_Q4 );
      if bel then
//    J: Weiter
      else
      begin
//    N:Belegungsfehler LI_IV_10
        err_code := 'LI_IV_10';
        FehlerAusgeben( err_code, 'Die Fächer Literatur, Instrumentalpraktischer bzw. vokalpraktischer Grundkurs dürfen maximal in zwei aufeinanderfolgenden Halbjahren belegt werden.' );
      end;
//  N: Wurden mehr als zwei Kurse des Fachs belegt?
    end else if anzahlQ > 2 then
    begin
// J: Belegungsfehler LI_IV_10
      err_code := 'LI_IV_10';
      FehlerAusgeben( err_code, 'Die Fächer Literatur, Instrumentalpraktischer bzw. vokalpraktischer Grundkurs dürfen maximal in zwei aufeinanderfolgenden Halbjahren belegt werden.' );
    end;
  end;

{ZUr Sicherheit Teil des alten Alg.
    if ( anzahlQ > 1 ) then
    begin // aufeinanderfolgend, nicht zwingend >0, daher FFuerAbitur abschalten
      tmp_bool := FFuerAbitur;
      FFuerAbitur := false;
      bel := ( AnzahlBelegteHalbjahre( afach, C_Q1, C_Q2 ) = 2 ) or
             ( AnzahlBelegteHalbjahre( afach, C_Q2, C_Q3 ) = 2 ) or
             ( AnzahlBelegteHalbjahre( afach, C_Q3, C_Q4 ) = 2 );
      FFuerAbitur := tmp_bool;
      err := not bel;
      if err then
        break;
    end;}


// NEU 6 Wurde mehr als ein Fach aus der Fächermenge Literatur, instrumentalpraktischer Kurs, vokalpraktischer Kurs belegt?
  anzahlQ := 0; // hier wird die Anzahl der belegten Fächer gespeichert
  for i := 1 to AnzahlElemente( W1_5 ) do
  begin
    afach := Einzelelement( M1, i );
    if AnzahlBelegteHalbjahre( afach, C_Q1, C_Q4 ) > 0 then
      inc( anzahlQ );
  end;
  err := anzahlQ > 1;

// J: Belegungsfehlter LI_IV_11
  if err then
  begin
    err_code := 'LI_IV_11';
    FehlerAusgeben( err_code, 'Es darf nur eines der Fächer LI, IP oder IV belegt werden' );
  end;


// NEU 7 Wurde Geschichte Zusatzkurs belegt
// NEU 8 Wurde Sozialwissenschaften Zusatzkurs belegt?
  err := false;
  M1 := Vereinigungsmenge( W2_1, W2_2 );
  for i := 1 to AnzahlElemente( M1 ) do
  begin
    afach := Einzelelement( M1, i );
    beg_zk := BeginnZK( afach );
    if beg_zk > 1 then
    begin
      err := IstBelegt( afach, beg_zk-1, beg_zk-1 );
      if err then
        break;
    end;
  end;

  if err then
  begin
    err_code := 'ZK_10';
    FehlerAusgeben( err_code, 'Ein Zusatzkurs in Geschichte oder Sozialwissenschaften kann nur angewählt werden, wenn das Fach im vorangegangenen Halbjahr nicht belegt wurde.' );
  end;

// NEU 9 Wurde eine fortgeführte Fremdsprache von EF.1 bis Q2.2 belegt?
  bel := GruppeBelegt( W1_2, BEGINN, C_Q4 );
  if bel then
  begin
//  J: Weiter
  end else
  begin
//  N: Wurde das Häkchen Muttersprachenprüfung aktiviert?
    if FSchueler.SPP then
    begin
//    J: Wurde eine neu einsetzende Fremdsprache von EF.1 bis Q2.2 belegt?
      bel := GruppeBelegt( W1_3, BEGINN, C_Q4 );
      if bel then
      begin
//      J: Hinweis FS_19
        err_code := 'FS_19';
        FehlerAusgeben( err_code, 'Eine erfolgreiche Feststellungsprüfung in der Muttersprache am Ende der Sekundarstufe I und am Ende von EF.2 ist notwendig, ' +
                                 'um die Fremdsprachenbedingungen zu erfüllen.' );
      end else
      begin
//      N: Belegungsfehler FS_18
        err_code := 'FS_18';
        FehlerAusgeben( err_code, 'Mindestens eine Fremdsprache muss von EF.1 bis Q2.2 belegt werden' );
      end;
    end else
    begin
//    N: Wurde eine fortgeführte Fremdsprache von EF.1 bis EF.2 und eine neu einsetzende Fremdsprache von EF.1 bis Q2.2 belegt?
      if BEGINN = C_E1 then
        bel := GruppeBelegt( W1_2, BEGINN, C_E2 ) and GruppeBelegt( W1_3, BEGINN, C_Q4 )
      else
        bel := GruppeBelegt( W1_3, BEGINN, C_Q4 );
      if bel then
      begin
//      J: Weiter
      end else
      begin
//      N: Belegungsfehler FS_10
        err_code := 'FS_10';
        FehlerAusgeben( err_code, 'Mindestens eine Fremdsprache muss von E1 bis Q4 durchgehend belegt werden.' );
      end;
    end;
  end;

//NEU 10	Wurde eine fortgeführte Fremdsprache von EF.1 bis Q2.1 schriftlich belegt?
  bel := GruppeSchriftlich( W1_2, BEGINN, C_Q3, false );
  if bel then
  begin
//  J: Weiter
  end else
  begin
//  N: Wurde das Häkchen Muttersprachenprüfung aktiviert?
    if FSchueler.SPP then
    begin
//    J: Wurde eine neu einsetzende Fremdsprache von EF.1 bis Q2.1 schriftlich belegt?
      bel := GruppeSchriftlich( W1_3, BEGINN, C_Q3, false );
      if bel then
      begin
//      J: Weiter
      end else
      begin
//      N: Belegungsfehler FS_11
        err_code := 'FS_11';
        FehlerAusgeben( err_code, 'Eine neueinsetzende Fremdsprache kann nur als Grundkurs belegt werden' );
      end;
    end else
    begin
//    N: Wurde eine neu einsetzende Fremdsprache von EF.1 bis Q2.1 schriftlich belegt?
      bel := GruppeSchriftlich( W1_3, BEGINN, C_Q3, false );
      if bel then
      begin
  //  J: Wurde eine fortgeführte Fremdsprache von EF.1 bis EF.2 schriftlich belegt?
        bel := GruppeSchriftlich( W1_2, BEGINN, C_E2, false ) or ( BEGINN = C_Q1 );
        if bel then
        begin
  //    J : Weiter
        end else
        begin
  //    N: Klausurfehler FS_16
          err_code := 'FS_16';
          FehlerAusgeben( err_code, 'Mindestens eine fortgeführte Fremdsprache muss in EF.1 und EF.2 schriftlich belegt werden.' );
        end;
      end else
      begin
  //  N: Belegungsfehler FS_11
        err_code := 'FS_11';
        FehlerAusgeben( err_code, 'Eine neueinsetzende Fremdsprache kann nur als Grundkurs belegt werden' );
      end;
    end;
  end;

//11	Wurde eine neu einsetzende Fremdsprache in EF.1 oder EF.2 oder Q1.1 oder Q1.2 oder Q2.1 mündlich belegt?
  for i := 1 to AnzahlElemente( W1_3 ) do
  begin
    afach := EinzelElement( W1_3, i );
    muendl := IstMuendlich( afach, C_E1, C_E1 ) or IstMuendlich( afach, C_E2, C_E2 ) or
              IstMuendlich( afach, C_Q1, C_Q1 ) or IstMuendlich( afach, C_Q2, C_Q2 ) or
              IstMuendlich( afach, C_Q3, C_Q3 );
    if muendl then
      break;
  end;
  if muendl then
  begin
//J:	Klausurfehler	FS_15
    err_code := 'FS_15';
    FehlerAusgeben( err_code, 'Neu einsetzende Fremdsprachen müssen in EF.1 bis Q2.1 schriftlich belegt werden.' );
  end;

// NEUNEU 12
// Wurde eine neu einsetzende Fremdsprache in Q1.1 oder Q1.2 oder Q2.1 oder Q2.2 als LK belegt?
  if not IstLeer( SchnittMenge( W1_3, W_LK ) ) then
  begin
    err_code := 'FS_17';
    FehlerAusgeben( err_code, 'Neu einsetzende Fremdsprachen dürfen nicht als Leistungskurs belegt werden.' );
  end;


// NEU 12 Wurde eine fortgeführte Fremdsprache in EF.1 oder EF.2 mündl. belegt
  muendl := false;
  if BEGINN = C_E1 then
  begin
    for i := 1 to AnzahlElemente( W1_2 ) do
    begin
      afach := EinzelElement( W1_2, i );
      muendl := IstMuendlich( afach, C_E1, C_E1 ) or IstMuendlich( afach, C_E2, C_E2 );
      if muendl then
        break;
    end;
    if muendl then
    begin
      err_code := 'FS_12';
      FehlerAusgeben( err_code, 'In EF.1 und EF.2 müssen alle gewählten Fremdsprachenfächer schriftlich belegt werden.' );
    end;
  end;

// NEU 13 Wurde das Fach Latein in der Sekundarstufe I ab Klasse 5 oder 6 belegt?
  if BEGINN = C_E1 then
  begin
    if FSchueler.LateinBeginn <> '' then
      PruefeLatein_Q;
  end;

// NEU 14: Latein für G9 fällt weg

// NEU 15
  PruefeFS2_Q;

// NEU 16 Fremdsprachenprüfung für G9 entfällt

// NEU 17 Wurde ein Fach der Gesellschaftswissenschaften von EF.1 bis Q2.2 belegt (ohne ZKs)?
  bel := GruppeBelegt( W2_1, BEGINN, C_Q4, '-ZK' ) or
         GruppeBelegt( W2_2, BEGINN, C_Q4, '-ZK' ) or
         GruppeBelegt( W2_3, BEGINN, C_Q4, '-ZK' ) or
         GruppeBelegt( W2_4, BEGINN, C_Q4, '-ZK' );

// J: WEiter
// N: Belegungsfehler GW_10
  if not bel then
  begin
    err_code := 'GW_10';
    FehlerAusgeben( err_code, 'Mindestens eine Gesellschaftswissenschaft muss von Q1 bis Q4 durchgehend belegt werden' );
  end;


// NEU 18 Schleife von EF.1 bis EF.2 Wurde ein Fach der Gesellschaftswissenschaften im Schleifenhalbjahr schriftlich belegt?
  schr := true;
  if BEGINN = C_E1 then
  begin
    for j := C_E1 to C_E2 do
      schr := schr and (
              GruppeSchriftlich( W2_1, j, j, false ) or
              GruppeSchriftlich( W2_2, j, j, false ) or
              GruppeSchriftlich( W2_3, j, j, false ) or
              GruppeSchriftlich( W2_4, j, j, false ) );
// J: WEiter
// N: Belegungsfehler GW_11
    if not schr then
    begin
      err_code := 'GW_11';
      FehlerAusgeben( err_code, 'In E1 und E2 muss mindestens eine Gesellschaftswissenschaft schriftlich belegt sein' );
    end;
  end;

// NEU 19 Wurde ein Fach der Gesellschaftswissenschaft oder Religionslehre von EF.1 bis Q2.2 belegt und von Q1.1 bis Q2.1 schriftlich belegt?
  bel := GruppeBelegt( W2_1, BEGINN, C_Q4 ) or
         GruppeBelegt( W2_2, BEGINN, C_Q4 ) or
         GruppeBelegt( W2_3, BEGINN, C_Q4 ) or
         GruppeBelegt( W2_4, BEGINN, C_Q4 ) or
         GruppeBelegt( W4, BEGINN, C_Q4 );

  schr := GruppeSchriftlich( W2_1, C_Q1, C_Q3, false ) or
         GruppeSchriftlich( W2_2, C_Q1, C_Q3, false ) or
         GruppeSchriftlich( W2_3, C_Q1, C_Q3, false ) or
         GruppeSchriftlich( W2_4, C_Q1, C_Q3, false ) or
         GruppeSchriftlich( W4, C_Q1, C_Q3, false );
// J : Weiter
// N: Klausurfehler GW_12
  if not ( bel and schr ) then
  begin
    err_code := 'GW_12';
    FehlerAusgeben( err_code, 'Mindestens eine Gesellschaftswissenschaft oder Religionslehre muss von Q1 bis wenigstens Q3 schriftlich belegt werden' );
  end;

// NEU 20 Wurde Geschichte (ohne ZK) vo EF.1 bis Q1.2 belegt?
  if not FFuerAbitur then
  begin
    bel := GruppeBelegt( W2_1, BEGINN, C_Q2, '-ZK' );
// J: Weiter
// N: Wurde Geschichte als Zusatzkurs in (Q1.2 und Q1.2) oder ( Q1.2 und Q2.1) oder (Q2.1 und Q2.2) belegt?
    if not bel then
      bel := GruppeZK( W2_1, C_Q1, C_Q2 ) or
             GruppeZK( W2_1, C_Q2, C_Q3 ) or
             GruppeZK( W2_1, C_Q3, C_Q4 );
//J : Weiter
//N: Belegungsfehler GE_10
    if not bel then
    begin
      err_code := 'GE_10';
      FehlerAusgeben( err_code, 'Geschichte muss von E1 bis wenigstens Q2 oder als Zusatzkurs (in der Regel von Q3 bis Q4) belegt werden' );
    end;
  end else
  begin
//Es folgt die Erweiterung von Folie 15 mit Fach W2.1. Das Fach W2.5 darf jedoch nicht erweitert werden.
//Hier bleibt die Bedingung so wie sie ist
    M1 := W2_1;
    bel := false;
    for i := 1 to AnzahlElemente( M1 ) do
    begin
      afach := EinzelElement( M1, i );
      bel := IstBelegtPunkteVar( afach );
      if bel then
        break;
    end;
    if not bel then
      bel := GruppeZK( W2_1, C_Q1, C_Q2 ) or
             GruppeZK( W2_1, C_Q2, C_Q3 ) or
             GruppeZK( W2_1, C_Q3, C_Q4 );

    if not bel then
    begin
      err_code := 'GE_10';
      FehlerAusgeben( err_code, 'Geschichte muss von E1 bis wenigstens Q2 oder als Zusatzkurs (in der Regel von Q3 bis Q4) belegt werden' );
    end;
  end;


// NEU 21 Wurde Sozialwissenschaften (ohen ZK) von EF.1 bis Q2.2 belegt

  if not FFuerAbitur then
  begin
    bel := GruppeBelegt( W2_2, BEGINN, C_Q2, '-ZK' );
// J: Weiter
// N: Wurde Sozialswissenschaften als Zusatzkurs in (Q1.1 und Q1.2) oder ( Q1.2 und Q2.1) oder (Q2.1 und Q2.2) belegt?
    if not bel then
      bel := GruppeZK( W2_2, C_Q1, C_Q2 ) or
             GruppeZK( W2_2, C_Q2, C_Q3 ) or
             GruppeZK( W2_2, C_Q3, C_Q4 );
//J : Weiter
//N: Belegungsfehler GE_10
    if not bel then
    begin
      err_code := 'SW_10';
      FehlerAusgeben( err_code, 'Sozialwissenschaften muss von E1 bis wenigstens Q2 oder als Zusatzkurs (in der Regel von Q3 bis Q4) belegt werden.' );
    end;
  end else
  begin
    M1 := W2_2;
    bel := false;
    for i := 1 to AnzahlElemente( M1 ) do
    begin
      afach := EinzelElement( M1, i );
      bel := IstBelegtPunkteVar( afach );
      if bel then
        break;
    end;
    if not bel then
      bel := GruppeZK( W2_2, C_Q1, C_Q2 ) or
             GruppeZK( W2_2, C_Q2, C_Q3 ) or
             GruppeZK( W2_2, C_Q3, C_Q4 );
    if not bel then
    begin
      err_code := 'SW_10';
      FehlerAusgeben( err_code, 'Sozialwissenschaften muss von E1 bis wenigstens Q2 oder als Zusatzkurs (in der Regel von Q3 bis Q4) belegt werden' );
    end;
  end;

// NEU 22 und 23 Schleife von EF.1 bis EF.2: Wurde Religionslehre im Schleifenhalbjahr belegt
  PruefeReligionNeu( BEGINN );

// NEU 24 Wurde Mathematik von EF1.1 bis Q2.2 belegt?
  bel := GruppeBelegt( W3_1, BEGINN, C_Q4 );
  if not bel then
  begin
    err_code := 'M_10';
    FehlerAusgeben( err_code, 'Mathematik muss von E1 bis Q4 belegt werden' );
  end;

// NEU 25 Wurde  Mathematik von EF1.1 bis Q2.1 schriftlich belegt?
  schr := GruppeSchriftlich( W3_1, BEGINN, C_Q3, false );
  if not schr then
  begin
    err_code := 'M_11';
    FehlerAusgeben( err_code, 'Mathematik muss von E1 bis mindestens Q3 schriftlich belegt werden' );
  end;

// NEU 26 Wurde eine klassische Naturwissenschaft von EF1.1 bis Q2.2 belegt?
  bel := GruppeBelegt( W3_2, BEGINN, C_Q4 );
  if not bel then
  begin
    err_code := 'NW_10';
    FehlerAusgeben( err_code, 'Mindestens eine klassische Naturwissenschaft (Physik, Biologie, Chemie) muss durchgehend von Q1 bis Q4 belegt werden' );
  end;

// NEU 27 Schleife von EF.1 bis EF.2 Wurde mindestens eine klassische NW im Schleifenhalbjahr schriftlich belegt?
  if BEGINN = C_E1 then
  begin
    schr := true;
    for j := C_E1 to C_E2 do
      schr := schr and GruppeSchriftlich( W3_2, j, j, false );
    if not schr then
    begin
      err_code := 'NW_11';
      FehlerAusgeben( err_code, 'In E1 und E2 muss mindestens eine klassische Naturwissenschaft (Physik, Biologie, Chemie) schriftlich belegt sein' );
    end;
  end;

// NEU 28 Wurde Sport von EF.1 bsi Q2.2. belegt?
  bel := GruppeGemischtBelegt( W5, BEGINN, C_Q4 );
  if not bel then
  begin
    err_code := 'SP_10';
    FehlerAusgeben( err_code, 'Sport muss von E1 bis Q4 belegt werden' );
  end;

// NEU 29 Schleife über alle fortgeführten Fremdsprachenfächer und neu einsetzenden Fremdsprachenfächer:
  M_A := '';
  M_B := '';
  M_C := '';
  M1 := VereinigungsMenge( W1_2, W1_3 );
  for i := 1 to AnzahlElemente( M1 ) do
  begin
// Wurde das Fach von EF.1 bis Q2.2 belegt und von EF.1 bis Q2.1 schriftlich belegt?
    afach := EinzelElement( M1, i );
    bel := IstBelegt( afach, BEGINN, C_Q4 );
    schr := IstSchriftlich( afach, BEGINN, C_Q3 );
//  J: Nimm die Unterrichtssprache, in der das Fach unterrichtet wurde, in eine Mange A auf
    if bel and schr then
      ZuMengeHinzu( M_A, Unterrichtssprache( afach ) )
    else
//  N: Nächstes Fach
      continue;
  end;

// NEU 30: Ist die Anzahl der Elemente in Menge A genau 1?
  if AnzahlElemente( M_A ) = 1 then
  begin
//  J: Filtere alle belegten bilingualen Sachfächer in einer Menge WBS. Schleife über alle Unterrichtssprachen, die in WBS vorkommen:
//     Existiert in EF.1 und EF.2 und Q1.1 und Q1.2 und Q2.1 jeweils ein schriftlich belegter Kurs und in Q2.2 ein belegter Kurs eines beliebigen
//     Sachfaches in WBS in der Unterrichtssprache?
//     Hinweis: WBS = W6
    SprBilSF := SprachenVonBilingSachf( false, C_E1, C_Q4 );
    for i := 1 to AnzahlElemente( SprBilSF ) do
    begin  // Schleife über alle Unterrchtssprachen, die in WBS vorkommen
      bilsf_hj := '';
      uspr := EinzelElement( SprBilSF, i ); // die einzelne Unterrichtssprache
      for j := 1 to AnzahlElemente( W6 ) do
      begin
        afach := EinzelElement( W6, j ); // Das einzelne Sachfach
        if Unterrichtssprache( afach ) = uspr then
        begin
          if BEGINN = C_E1 then
          begin
            if IstSchriftlich( afach, C_E1, C_E1 ) then
              ZuMengeHinzu( bilsf_hj, 'E1' );
            if IstSchriftlich( afach, C_E2, C_E2 ) then
              ZuMengeHinzu( bilsf_hj, 'E2' );
          end else
          begin
            ZuMengeHinzu( bilsf_hj, 'E1' );
            ZuMengeHinzu( bilsf_hj, 'E2' );
          end;
          if IstSchriftlich( afach, C_Q1, C_Q1 ) then
            ZuMengeHinzu( bilsf_hj, 'Q1' );
          if IstSchriftlich( afach, C_Q2, C_Q2 ) then
            ZuMengeHinzu( bilsf_hj, 'Q2' );
          if IstSchriftlich( afach, C_Q3, C_Q3 ) then
            ZuMengeHinzu( bilsf_hj, 'Q3' );
          if IstBelegt( afach, C_Q1, C_Q4 ) then
            ZuMengeHinzu( bilsf_hj, 'Q4' );
          if bilsf_hj = 'E1;E2;Q1;Q2;Q3;Q4' then
//   J: Nimm die Unterrichtssprache in eine Menge A auf
            ZuMengeHinzu( M_A, Unterrichtssprache( afach ) );
        end;
      end;
    end;
  end;

// NEU 31 Schleife über alle klassischen und modernen Naturwissenschaften:
  M1 := VereinigungsMenge( W3_2, W3_3 );
  for i := 1 to AnzahlElemente( M1 ) do
  begin
//Wurde das Fach von EF.1 bis Q2.2 belegt?
    afach := Einzelelement( M1, i );
    if IstBelegt( afach, BEGINN, C_Q4 ) then
    begin
//  J: Wurde das Fach von Q1.2 bis Q2.1 schriftlich belegt?
      if IstSchriftlich( afach, C_Q1, C_Q3 ) then
      begin
//    J : Nimm das Fach in eine Menge C und eine Menge D auf
        ZuMengeHinzu( M_C, afach );
        ZuMengeHinzu( M_D, afach );
      end else
//    N : Nimm das Fach in eine Menge C auf
        ZuMengeHinzu( M_C, afach );
    end else
//  N : Nächstes Fach
      continue;
  end;

// NEU 32 Ist die Anzahl der Elemente in Mnege A größer gleich 2?
  if AnzahlElemente( M_A ) >= 2 then
  begin
// J : Ist die Anzahl der Elemente in Menge C größer gleich 2 und ist die Anzahl der Elemente in Menge D größer gleich 1?
    if ( AnzahlElemente( M_C ) >= 2 ) and ( AnzahlElemente( M_D ) >= 1 ) then
    begin
//  J : Weiter
    end else
    begin
//  N : Hinweis NW_FS12
      err_code := 'NW_FS_12';
      FehlerAusgeben( err_code, 'Hinweis: Da weniger als zwei naturwissenschaftliche Fächer durchgehend belegt wurden, liegt ausschließlich ein Sprachenschwerpunkt vor.' );
    end;
  end else
  begin
// Ist die Anzahl der Elemente in Menge C größer gleich 2 und ist die Anzahl der Elemente in Menge D größer gleich 1?
    if ( AnzahlElemente( M_C ) >= 2 ) and ( AnzahlElemente( M_D ) >= 1 ) then
    begin
//  J : Hinweis NWFS_13
      err_code := 'NW_FS_13';
      FehlerAusgeben( err_code, 'Hinweis: Da weniger als zwei Fremdsprachen durchgehend belegt wurden, liegt ausschließlich ein naturw. Schwerpunkt vor.' );
    end else
    begin
//  N : Belegungsfehler NW_FS_10
      err_code := 'NW_FS_10';
      FehlerAusgeben( err_code, 'Von E1 bis Q4 müssen entweder zwei Naturwissenschaften oder zwei Fremdsprachen durchgehend gewählt werden. Zu letzterem zählen auch in einer zweiten Fremdsprache unterrichtete Sachfächer.' );
    end;
  end;

  // NEU: Global speichern für Abiturberechnung
  FMenge_A := M_A;
  FMenge_C := M_C;
  FMenge_D := M_D;

// NEU 33: Weitere Prüfung der Mengen A bis D (entfällt, war G9-Prüfung)

// NEU 34 Äußere Schleife über alle Fächer ohne Literatur, ohne vokalprakt. Kurs, ohne instrumentalprakt. Kurs, ohne Religion, ohne Zusatzkurese, ohne Vertiefungskurse
//        ohne Projektkurse, ohne Philosophie: Innere Schleife von EF.2 bis Q2.2: Wurder das Fach im Schleifenhalbjahr belegt?
  if BEGINN = C_E1 then
    PruefeBelegungAusE1;

// NEU 36 Schüler des bilingualen Bildungsganges?
  if FSchueler.BilingualerZweig <> '-' then
    BilingualePruefung_GY_GE( BEGINN );

// NEU 37 SChleife über die Unterrichtssprachen jedes bilingualen Sachfaches: Findet sich die Sprache in der Sprachenfolge des Schülers mit Beginn 5 oder 6 oder 8?

  if BEGINN = C_E1 then
  begin
    anzahlE := 0;
    SprBilSF := SprachenVonBilingSachf( false, BEGINN, C_Q4 );
    if ( SprBilSF <> '' ) then
    begin
  //Finden sich die Sprachen der Sachfächer in der Sprachenfolge der SI?
      for i := 1 to AnzahlElemente( SprBilSF ) do
      begin
        uspr := Einzelelement( SprBilSF, i );
        bel := InMenge( uspr, FSchueler.S1_Sprachen_5_6 ) or InMenge( uspr, FSchueler.S1_Sprachen_8 );
        if not bel then
          break;
      end;

      if not bel then
      begin
        err_code := 'BIL_14';
        FehlerAusgeben( err_code, 'Es können nur bilinguale Sachfächer belegt werden, deren Sprache in der Sekundarstufe erlernt wurde' );
      end;
    end;
  end;

// NEU 38 Schleife von EF.1 bis EF.2 Ist die Anzahl aller Fächer (ohne Projektkurs, sofern in einem der Nchbarhalbjahre kein zweiter Projektkurs belegt wurde
// und ohne Vertiefungskurse) größer gleich 10 im Schleifenhalbjaht
  if BEGINN = C_E1 then
  begin
    bel := (  FSummen[ C_E1 ].Kurse >= 10 ) and ( FSummen[ C_E2 ].Kurse >= 10 );
    if not bel then
    begin
//  N: Belegungsfehler ANZ_10
      err_code := 'ANZ_10';
      FehlerAusgeben( err_code, 'In der Einführungsphase müssen in jedem Halbjahr mindestens 10 Fächer belegt werden. Das Stundenvolumen aller Fächer muss mindestens 32 Stunden umfassen' );
    end;
  end;

// NEU 39 Schleife von EF.1 bis Q2.2: Ist die Summe aller Kursstunden im Schleifenhalbjahr größer gleich 32 und kleiner gleich 36?
  bel := true;
  for j := BEGINN to C_Q4 do
  begin
    bel := ( Schulstunden( FSummen[ j ].Stunden ) >= 32 ) and ( Schulstunden( FSummen[ j ].Stunden ) <= 36 );
    if not bel then
      break;
  end;
  if not bel then
  begin
//  N: Hinweis ANZ_11
    err_code := 'ANZ_11';
    FehlerAusgeben( err_code, 'Die Stundenbandbreite sollte pro Halbjahr 32 bis 36 Stunden betragen, um eine gleichmäßige Stundenbelastung zu gewährleisten.' );
  end;

// NEU 40 Wurden genau zwie Fächer von Q1.1 bis Q2.2 als LKs belegt?
  anzahlQ := 0;
  for i := 1 to AnzahlElemente( W_LK ) do
  begin
    afach := Einzelelement( W_LK, i );
    if IstLK( afach, C_Q1, C_Q4 ) then
      inc( anzahlQ );
  end;

  if anzahlQ <> 2 then
  begin
    err_code := 'LK_10';
    FehlerAusgeben( err_code, 'In der Qualifikationsphase müssen zwei Fächer durchgehend in Leistungskursen belegt werden' );
  end;

// NEU 41 Schleife von Q1.1 bis Q2.2: Wurden mindestens 7 Grundkurse (ohne Vertiefungskurse und ohne Projektkurse, sofern nur ein Halbjahr belegt ist) im SChleifenhalbjahr belegt?
  for i := 1 to AnzahlElemente( W_GK ) do
  begin
    afach := Einzelelement( W_GK, i );
    statkrz := StatistikKuerzel( afach );
//    if IstBelegt( afach, C_Q1, C_Q4 ) then
    if statkrz = C_VERTIEFUNGSKURS then
      bel := false
    else if statkrz = C_PROJEKTKURS then
      bel := IstBelegt( afach, C_Q1, C_Q2 ) or IstBelegt( afach, C_Q2, C_Q3 ) or IstBelegt( afach, C_Q3, C_Q3 )
    else
      bel := true;
    if bel then
    begin
      for j := C_Q1 to C_Q4 do
      begin
        if IstBelegt( afach, j, j ) then
        begin
          if IstGKS( afach, j, j ) then
            FSummen[j].AnzGKS := FSummen[j].AnzGKS + 1;
          if IstGK( afach, j, j ) then
            FSummen[j].AnzGK := FSummen[j].AnzGK + 1;
        end;
      end;
    end;
  end;

  bel := true;
  for j := C_Q1 to C_Q4 do
    bel := bel and ( FSummen[j].AnzGK >= 7 );
  if not bel then
  begin
    err_code := 'GKS_10';
    FehlerAusgeben( err_code, 'In der Qualifikationsphase sind pro Halbjahr mindestens 7 Fächer durchgehend in Grundkursen zu wählen.' );
  end;

// NEU 42: Prüfung für G9 entfällt

// NEU 43 Ist die Summe der aller belegten Vertiefungskurse in EF.1/Ef.2 kleiner gleich 4
  anzahlE := 0;
  anzahlQ := 0;
  for i := 1 to AnzahlElemente( W_VF ) do
  begin
    afach := Einzelelement( W_VF, i );
    if BEGINN = C_E1 then
      anzahlE := anzahlE + AnzahlBelegteHalbjahre( afach, C_E1, C_E2 );
    anzahlQ := anzahlQ + AnzahlBelegteHalbjahre( afach, C_Q1, C_Q4 );
  end;

  if BEGINN = C_E1 then
  begin
    if anzahlE > 4 then
    begin
      err_code := 'VF_10';
      FehlerAusgeben( err_code, 'In der Einführungsphase können maximal vier Vertiefungskurse belegt werden' );
    end;
  end;
// 39.Summiere in Q1-Q4 #VF ? 2
  if anzahlQ > 2 then
  begin
    err_code := 'VF_11';
    FehlerAusgeben( err_code, 'In der Qualifikationsphase können maximal zwei Vertiefungskurse belegt werden' );
  end;

// NEU 45 Prüfung Vertiefungskurse in G9 entfällt

//Anzahl Projektkurse
  if W_PF <> '' then
  begin
    anzahlE := 0;
    anzahlQ := 0;
    for i := 1 to AnzahlElemente( W_PF ) do
    begin
      afach := Einzelelement( W_PF, i );
      if BEGINN = C_E1 then
        anzahlE := anzahlE + AnzahlBelegteHalbjahre( afach, C_E1, C_E2 );
      anzahlQ := anzahlQ + AnzahlBelegteHalbjahre( afach, C_Q1, C_Q4 );
    end;

// NEU 46 Ist die Summe aller belgten Kurse aller Projektfächer in EF.1/EF.2 gleich NULL?
    if BEGINN = C_E1 then
    begin
      if anzahlE > 0 then
      begin
        err_code := 'PF_10';
        FehlerAusgeben( err_code, 'In der Einführungsphase können keine Projektkurse belegt werden' );
      end;
    end;

// ab hier neue Zählung, muss für vorherige Punkte auch noch angepasst weren

// NEU 48: Projektfachzähler = 0, Einzelprojektkurszähler = 0; Schleife über alle Projektfächer: Mach eine Fallunterscheidung nach der Anzahl belegter Kurse von Q1.1 bis Q2.2 im Projektfach
    anzahlPJF := 0;
    anzahlEinzelPJK := 0;
    for i := 1 to AnzahlElemente( W_PF ) do
    begin
      afach := Einzelelement( W_PF, i );
      anzahlQ := AnzahlBelegteHalbjahre( afach, C_Q1, C_Q4 );
      case anzahlQ of
      4 :
        begin
          err_code := 'PF_14';
          FehlerAusgeben( err_code, 'In der Qualifikationsphase kann maximal ein Projektkurse in zwei aufeinanderfolgenden Halbjahren belegt werden' );
        end;
      3 :
        begin
// Anzahl = 3: Wurde das Projektfach in Q1.1 und Q2.1 und Q2.2 belegt?
          bel := IstBelegt( afach, C_Q1, C_Q1 ) and IstBelegt( afach, C_Q3, C_Q3 ) and IstBelegt( afach, C_Q4, C_Q4 );
          if bel then
          begin
//        J: Projektfachzähler = Projektfachzähler + 1, nächstes Projektfach
            inc( anzahlPJF );
          end else
          begin
//        N: Belegungsfehler PF_14, nächstes Projektfach
            err_code := 'PF_14';
            FehlerAusgeben( err_code, 'In der Qualifikationsphase kann maximal ein Projektkurse in zwei aufeinanderfolgenden Halbjahren belegt werden' );
          end;
        end;
      2 :
        begin
// Anzahl = 2: Wurde das Projektfach von Q1.1 bis Q1.2 oder von Q1.2 bis Q2.1 oder von Q2.1 bis Q2.2 belegt?
          bel := IstBelegt( afach, C_Q1, C_Q2 ) or IstBelegt( afach, C_Q2, C_Q3 ) or Istbelegt( afach, C_Q3, C_Q4 );
          if bel then
//        J: Projektfachzähler = Projektfachzähler + 1
            inc( anzahlPJF )
          else
          begin
//        N: Wurde das Projektfach in Q2.2 belegt?
            bel := Istbelegt( afach, C_Q4, C_Q4 );
            if bel then
            begin
//          J: Belegungsfehler PF_14
              err_code := 'PF_14';
              FehlerAusgeben( err_code, 'In der Qualifikationsphase kann maximal ein Projektkurse in zwei aufeinanderfolgenden Halbjahren belegt werden' );
            end;
          end;
        end;
      1 :
        begin
// Anzahl = 1: Wird das Projektfach im Folgehalbjahr nicht angeboten?
          for j := C_Q1 to C_Q4 do
          begin    // erst mal das konkrete Halbjahr finden
            if IstBelegt( afach, j, j ) then
            begin // ist im betrachtene Hj. belegt, wird es im nächsten Hj. angeboten? (nur wenn j < C_Q4)
              if j < C_Q4 then
              begin
                if not PXIstBelegbar( afach, j+1 ) then
                begin
  //            J:	Belegungsfehler PF_14, Nächstes Projektfach
                  err_code := 'PF_14';
                  FehlerAusgeben( err_code, 'In der Qualifikationsphase kann maximal ein Projektkurse in zwei aufeinanderfolgenden Halbjahren belegt werden' );
                end else
                begin
  //            N:	Wurde das Projektfach in Q2.1 belegt?
                  if IstBelegt( afach, C_Q3, C_Q3 ) then
                  begin
//                J: Einzelprojektkurszähler = 1, Hinweis PF_17
                    anzahlEinzelPJK := 1;
                    err_code := 'PF_17';
                    FehlerAusgeben( err_code, 'Ein Projektkurs soll nur in Ausnahmefällen abgewählt werden. Bei einem abgewählten Projketkurs werden lediglich die Wochenstunden auf die Laufbahn angerechnet' );
                  end else
                  begin
//                N. Hinweis PF_17
                    err_code := 'PF_17';
                    FehlerAusgeben( err_code, 'Ein Projektkurs soll nur in Ausnahmefällen abgewählt werden. Bei einem abgewählten Projketkurs werden lediglich die Wochenstunden auf die Laufbahn angerechnet' );
                  end;
                end;
              end else
              begin
                if not IstBelegt( afach, C_Q3, C_Q3 ) then
                begin
                  err_code := 'PF_14';
                  FehlerAusgeben( err_code, 'In der Qualifikationsphase kann maximal ein Projektkurse in zwei aufeinanderfolgenden Halbjahren belegt werden' );
//                  err_code := 'PF_17';
//                  FehlerAusgeben( err_code, 'Ein Projektkurs soll nur in Ausnahmefällen abgewählt werden. Bei einem abgewählten Projketkurs werden lediglich die Wochenstunden auf die Laufbahn angerechnet' );
                end;
              end;
              break;
            end;
          end;
        end;
      end;
    end;

// NEU 49 Projektfachzähler > 1 oder ( Projektfachzähler = 1 und Einzelprojketkurszähler = 1) ?
    if ( anzahlPJF > 1 ) or ( ( anzahlPJF = 1 ) and ( anzahlEinzelPJK = 1 ) ) then
    begin
      err_code := 'PF_14';
      FehlerAusgeben( err_code, 'In der Qualifikationsphase kann maximal ein Projektkurse in zwei aufeinanderfolgenden Halbjahren belegt werden' );
    end;

// NEU 50 Projektfachzähler >= 1 ?
    if anzahlPJF >= 1 then
    begin
      afach := EinzelElement( W_PF, 1 );
      lfach_bel := LeitfachBelegung_GY_GE( afach );
//  J: Wurde das Projektfach von Q1.1 bis Q1.2 belegt?
      bel := IstBelegt( afach, C_Q1, C_Q2 );
      if bel then
      begin
//    J: Wurde das Leitfach von Q1.1 bis Q1.2 belegt?
        bel := AnsiContainsText( lfach_bel, '34' );
        if not bel then
        begin
//      N: Belegungsfehler PF_13
          err_code := 'PF_13';
          FehlerAusgeben( err_code, 'Ein Projektkurs kann nur belegt werden, wenn in der Qualifikationsphase auch sein Leitfach zwei Halbjahre lang belegt wurde.' );
        end;
      end else
      begin
//    N: Wurde das Projektfach in Q1.2 und Q2.1 belegt?
        bel := IstBelegt( afach, C_Q2, C_Q3 );
        if bel then
        begin
//      J: Wurde das Leitfach von Q1.1 bis Q1.2 oder von Q1.2 bis Q2.1 belegt?
          bel := AnsiContainsText( lfach_bel, '34' ) or AnsiContainsText( lfach_bel, '45' );
          if not bel then
          begin
//        N: Belegungsfehler PF_13
            err_code := 'PF_13';
            FehlerAusgeben( err_code, 'Ein Projektkurs kann nur belegt werden, wenn in der Qualifikationsphase auch sein Leitfach zwei Halbjahre lang belegt wurde.' );
          end;
        end else
        begin
//      N: Wurde das Projektfach in Q2.1 und Q2.2. belegt?
          bel := IstBelegt( afach, C_Q3, C_Q4 );
          if bel then
          begin
//        J: Wurde das Leitfach von Q1.1 bis Q1.2 oder von Q1.2 bis Q2.1 belegt oder von Q2.1 bis Q2.2 belegt?
            bel := AnsiContainsText( lfach_bel, '34' ) or AnsiContainsText( lfach_bel, '45' ) or AnsiContainsText( lfach_bel, '56' );
            if not bel then
            begin
//          N: Belegungsfehler PF_13
              err_code := 'PF_13';
              FehlerAusgeben( err_code, 'Ein Projektkurs kann nur belegt werden, wenn in der Qualifikationsphase auch sein Leitfach zwei Halbjahre lang belegt wurde.' );
            end;
          end;
        end;
      end;
    end;
  end;  // Ende W_PF

// NEU 51 Häkchen Projektfach als besondere Lernleistung aktiviert?
  if FSchueler.BLL_Art = 'P' then
  begin
// Projektfachzähler = 1?
    if anzahlPJF = 1 then
    begin
//  J: Hinweis PF_16
      err_code := 'PF_16';
      FehlerAusgeben( err_code, 'Wird der Projektkurs als besondere Lernleistung in das Abitur eingebracht, so zählt er nicht mehr zu den einbringungsfähigen Kursen in Block I.' );
    end else
    begin
//  N: Belegungsfehler PF_15
      err_code := 'PF_15';
      FehlerAusgeben( err_code, 'Es existiert kein Projektkurs, der als besondere Lernleistung eingebracht werden kann.' );
    end;
  end;


// NEU 52 Ist die Anzahl anrechenbarer Kurse größer gleich 38
  anzK := FKursZaehler.Gesamtzahl;
  bel := anzK >= 38;
  if not bel then
  begin
    err_code := 'ANZ_12';
    FehlerAusgeben( err_code, 'In der Qualifikationsphase müssen mindestens 38 anrechenbare Kurse belegt werden.' );
  end;

// NEU 53 Zählung für G9 entfällt

  FSummen[7].Kurse := anzK;
  FSummen[7].Stunden := 0;
  for i := 1 to 6 do
    with FSummen[i] do
      FSummen[7].Stunden := FSummen[7].Stunden + Stunden;
  FSummen[7].Stunden := 0.5*FSummen[7].Stunden;

// NEU 53 Summiere die Kursstunden aller belegten Kurse und dividiere die Summe durch zwei. Ist das Ergebnis größer gleich 100?
// Fällt weg lt. Herrn Raffenberg
//  if BEGINN = C_E1 then
//  begin
//    if Schulstunden( FSummen[7].Stunden ) < 100 then
//    begin
//      err_code := 'WST_10';
//      FehlerAusgeben( err_code, 'Die Summe der durchschnittlichen Jahreskursstunden von E1 bis Q4 darf 100 nicht unterschreiten.' );
//    end;
//  end;

// NEU 54 entfällt

// NEU 55 Ist die fortgeführte Fremdsprache oder eine Naturwissenschaft oder mathematik oder Deutsch erster LK?
  LK1 := '';
  for i := 1 to AnzahlElemente( W_LK ) do
  begin
    afach := Einzelelement( W_LK, i );
    if IstAbifach( afach, [ 1 ] ) then
      ZuMengeHinzu( LK1, afach );
  end;
  if AnzahlElemente( LK1 ) <> 1 then
  begin
    err_code := 'LK1_10';
    FehlerAusgeben( err_code, 'Erstes Abiturfach nicht identifizierbar.' );
  end else
  begin
    bel := InMenge( LK1, W1_2 ) or InMenge( LK1, W3_1 ) or InMenge( LK1, W3_2 ) or InMenge( LK1, W1_1 );
    if not bel then
    begin
      err_code := 'LK1_11';
      FehlerAusgeben( err_code, 'Das erste Leistungskursfach muss eine fortgeführte Fremdsprache, Mathematik, eine Naturwissenschaft oder Deutsch sein.' );
    end;
  end;

// NEU 56 entfällt

// NEU 57 Ist die Zahl der Abiturfächer 4 und decken diese alle Aufgabenfelder ab?
  abi_1_4 := '';
  for i := 1 to AnzahlElemente( W_AF ) do
  begin
    afach := EinzelElement( W_AF, i );
    statkrz := StatistikKuerzel( afach );
    FC0.Locate( 'FachInternKrz', afach, [loCaseInsensitive] );
    abi_1_4 := abi_1_4 + FC0.FieldByname( 'AbiturFach' ).AsString;
// Einschub: Prüfen ob die korrekten Kursarten in Q4 belegt sind
    if ( statkrz = 'SP' ) and (
        ( FC0.FieldByname( 'AbiturFach' ).AsString = '1' ) or
        ( FC0.FieldByname( 'AbiturFach' ).AsString = '3' ) ) then
    begin
      err_code := 'ABI_15';
      FehlerAusgeben( err_code, 'Sport kann nur als 2. oder als 4. Abiturfach gewählt werden.' );
    end;

    if FC0.FieldByname( 'AbiturFach' ).AsString = '3' then
    begin
      if not IstSchriftlich( afach, C_Q4, C_Q4 ) then
      begin
        err_code := 'ABI_12';
        FehlerAusgeben( err_code, 'In Q2.2 muss das 3.Abiturfach schriftlich belegt sein.' );
      end;
    end else if FC0.FieldByname( 'AbiturFach' ).AsString = '4' then
    begin
// Wurde das 4. Abiturfach in Q2.2 mündlich belegt?
      if IstSchriftlich( afach, C_Q4, C_Q4 ) then
      begin
        err_code := 'ABI_13';
        FehlerAusgeben( err_code, 'In Q2.2 muss das 4.Abiturfach mündlich belegt sein.' );
      end;
    end;
  end;
  bel := AnsiContainsText( abi_1_4, '1' ) and AnsiContainsText( abi_1_4, '2' ) and AnsiContainsText( abi_1_4, '3' ) and AnsiContainsText( abi_1_4, '4' );

// (AFI: Deutsch und Fremdsprachen;
// AF II: Gesellschaftswissenschaften und Religion;
// AF III: Mathematik und Naturwissenschaften; ohne AF: Kunst Musik etc., Sport)
  M1 := Vereinigungsmenge( W2, W4 ); // Temporäre Vereinigungsmenge von W2 und Religion

  bel := bel and
         ( Schnittmenge( W_AF, W1 ) <> '' ) and
//         ( Schnittmenge( W_AF, W2 ) <> '' ) and
// neu: 8.2.2011: Religion in W2 (hier temporär M1) enthalten
         ( Schnittmenge( W_AF, M1 ) <> '' ) and
         ( Schnittmenge( W_AF, W3 ) <> '' );
  if not bel then
  begin
    err_code := 'LK1_13';
    FehlerAusgeben( err_code, 'Die Abiturfächer müssen alle drei Aufgabenfelder abdecken. Insgesamt sind vier Abiturfächer zu belegen.' );
  end;

// NEU 58 Sind unter den vier Abiturfächern zwei der Fächer Deutsch, Mathematik, fortgeführte Fremdsprache oder neu einsetzende Fremdsprache
// Deutsch + Mathe
  M_A := VereinigungsMenge( W1_1, W3_1 );// Deutsch + Mathe
  M_A := VereinigungsMenge( M_A, W1_2 );// Deutsch + + Mathe + FS SekI
  M_A := VereinigungsMenge( M_A, W1_3 );// Deutsch + + Mathe + FS SekI + FS SekII
// W_AF: Die Abiturfächer
  M_A := SchnittMenge( M_A, W_AF );

  bel := ( AnzahlElemente( M_A ) >= 2 ) and ( StatKrzInMenge( 'D', M_A ) or StatKrzInMenge( 'M', M_A ) );
  if not bel then
  begin
    err_code := 'ABI_10';
    FehlerAusgeben( err_code, 'Unter den vier Abiturfächern müssen zwei der Fächer Deutsch, Mathematik oder Fremdsprache sein.' );
  end;

// NEU 59 Sind Sport und REligion Abiturfächer?
  M1 := ''; // speichert die Fachgruppen
  for i := 1 to AnzahlElemente( W_AF ) do
  begin
    afach := EinzelElement( W_AF, i );
    statkrz := FachGruppe( afach ); // nimmt hier die Fachgruppe auf
    if ( statkrz = 'RE' ) or ( statkrz = 'SP' ) then
      ZuMengeHinzu( M1, statkrz );
  end;
  if InMenge( 'RE', M1 ) and InMenge( 'SP', M1 ) then
  begin
    err_code := 'ABI_11';
    FehlerAusgeben( err_code, 'Religionslehre und Sport dürfen nicht gleichzeitig Abiturfächer sein.' );
  end;

// NEU 60 Ist Sport erstes oder drittes Abifach?
// schon weiter oben behandlet

// NEU 61 Schleife von Q1.1 bis Q2.2: Wurden im Schleifenhalbjahr mehr als zwei LKs belegt:
  for j := C_Q1 to C_Q4 do
  begin
    anzahlQ := 0;
    for i := 1 to AnzahlElemente( W_LK ) do
    begin
      afach := EinzelElement( W_LK, i );
      if IstLK( afach, j, j ) then
        inc( anzahlQ );
    end;
    if anzahlQ > 2 then
    begin
      err_code := 'LK_11';
      FehlerAusgeben( err_code, 'Es dürfen nicht mehr als zwei Fächer als Leistungskurse belegt werden.' );
      break;
    end;
  end;

// NEU 62 Wurde das dritte Abiturfach in Q2.2 schriftlich belegt?
// schon vorher abgehandelt (ABI_12)

// NEU 63: Ist das 4. Abiturfach eine enu einsetzende Fremdsprache?
// schon vorher abgehandelt (ABI_13)

// NEU 64 Schleife über alle Fächer: Ist das Fach ein Abiturfach ?
  with FC0 do
  begin
    First;
    while not Eof do
    begin
      afach := FieldByname( 'FachInternKrz' ).AsString;
      if IstSchriftlich1( afach, C_Q4, C_Q4 ) and not InMenge( afach, W_AF ) then
      begin
        err_code := 'ABI_16';
        FehlerAusgeben( err_code, 'Fächer, die keine Abiturfächer sind, müssen in Q2.2 mündlich belegt werden.' );
        break;
      end;
// Prüfen, ob sich die Position geändert hat
      if FieldByname( 'FachInternKrz' ).AsString <> afach then
        Locate( 'FachInternKrz', afach, [] );
      Next;
    end;
  end;

// NEU 65 Schleife von EF.1 bis Q2.2 Wurden im Schleifenhalbjahr zwei oder mehr Fächer mit gleichem Statistikürzel belegt (ohne Vertiefungsfächer)
  for i := C_E1 to C_Q2 do
  begin
    err := not PruefeInhaltsgleicheFaecher( i );
    if err then
      break;
  end;
  if err then
    FehlerAusgeben( 'IGF_10', 'Inhaltsgleiche Fächer dürfen in jedem Halbjahr nur einmal werden' );

// NEU 66 Ist die Kursstundensumme kleiner 102?
  if BEGINN = C_E1 then
  begin
    anzahlQ := Schulstunden( FSummen[7].Stunden );
    if anzahlQ < 102 then
    begin
      if anzahlQ < 100 then
      begin
        err_code := 'STD_10';
        FehlerAusgeben( err_code, 'Der Pflichtunterricht darf 102 Stunden nicht unterschreiten' );
      end else
      begin
        err_code := 'STD_11';
        FehlerAusgeben( err_code, 'Der Pflichtunterricht darf nur in begründeten Ausnahmefällen 102 Stunden unterschreiten.' );
      end;
    end;
// NEU 67 Ist die durchschnittliche Kursstundensumme in der Einführungsphase kleiner als 34?
    err := 0.5*( FSummen[ C_E1 ].Stunden + FSummen[ C_E2 ].Stunden ) < 34;
    if err then
    begin
      err_code := 'WST_20';
      FehlerAusgeben( err_code, 'Die durchschnittliche Wochenstundenzahl muss in der Einführungsphase mindestens 34 Stunden betragen.' );
    end;
  end;

// NEU 68 Ist die durchschnittliche Kursstundensumme in der Qualifikationsphase kleiner als 34?
  err := 0.25*( FSummen[ C_Q1 ].Stunden + FSummen[ C_Q2 ].Stunden + FSummen[ C_Q3 ].Stunden + FSummen[ C_Q4 ].Stunden ) < 34;
  if err then
  begin
    err_code := 'WST_21';
    FehlerAusgeben( err_code, 'Die durchschnittliche Wochenstundenzahl muss in der Qualifiaktionsphase mindestens 34 Stunden betragen.' );
  end;
end;

function TAbiturBelegPruefer.WBK_SprachNachweisVorhanden: boolean;
begin
  Result := false;
  with FC0 do
  begin
    First;
    while not Eof do
    begin
      Result := ( FieldByName( 'BeginnJahrgang' ).AsString = 'N' ) or ( FieldByName( 'BeginnJahrgang' ).AsString = 'P' );
      if Result then
        exit
      else
        Next;
    end;
  end;
end;

procedure TAbiturBelegPruefer.Pruefe_E_Phase_WBK;
var
  schr, bel: boolean;
  err_code: string;
  M1, afach, statkrz: string;
  cnt, cnt_FS_schr, cnt_FS_bel, i: integer;
  min_std, min_kurse: integer;
begin
  FKursZaehler.Phase := 'E';
// 1. Deutsch muss schriftlich belegt sein
  schr := GruppeSchriftlich( W1_1, FEnd_Hj, FEnd_Hj, false );
  if not schr then
  begin
    err_code := 'D_1';
    FehlerAusgeben( err_code, 'Deutsch muss in EF.1 und EF.2 schriftlich belegt werden' );
  end;

//FOLIE
//Mindestens ein Fach aus {F1.2 U F1.3} schriftlich belegt?
//Hier muss auch geprüft werden, ob alle belegten FS auch schriftlich sind
  cnt_FS_schr := 0;
  cnt_FS_bel := 0;
  M1 := Vereinigungsmenge( W1_2, W1_3 );
  for i := 1 to AnzahlElemente( M1 ) do
  begin
    afach := EinzelElement( M1, i );
    if IstBelegt1( afach, FEnd_Hj, FEnd_Hj ) then
    begin
      inc( cnt_FS_bel );
      if IstSchriftlich( afach, FEnd_Hj, FEnd_Hj ) then
        inc( cnt_FS_schr );
    end;
  end;
  schr := ( cnt_FS_bel > 0 ) and ( cnt_FS_schr = cnt_FS_bel );
  if not schr then
  begin
    err_code := 'FS_1';
    FehlerAusgeben( err_code, 'Mindestens eine Fremdsprache muss in E1 schriftlich belegt werden.' );
  end else
  begin
// Jetzt prüfen, ob durchgängig belegbar
    bel := false;
    for i := 1 to AnzahlElemente( M1 ) do
    begin
      afach := EinzelElement( M1, i );
      bel := InMenge( afach, FS_Durchg );
      if bel then
        break;
    end;
    if not bel then
    begin
      err_code := 'FS_2';
      FehlerAusgeben( err_code, 'Da die gewählte Fremdsprache in der Oberstufe nicht durchgehend angeboten wird, muss entweder zusätzlich eine neu einsetzende Fremdsprache oder eine andere in der Sekundarstufe I begonnene Fremdsprache belegt werden.' );
    end;
  end;

// Einschub von J. Richter: Fach aus F1.3 belegt? (d.h. neu einsetzende FS)
  M1 := W1_3;
  if M1 <> '' then
  begin
    bel := false;
    for i := 1 to AnzahlElemente( M1 ) do
    begin
      afach := EinzelElement( M1, i );
      bel := InMenge( afach, FS_E11_Q11_Belegbar );
      if bel then
        break;
    end;
    if not bel then
    begin
      err_code := 'FS_3';
      FehlerAusgeben( err_code, 'Eine neu einsetzende Fremdsprache muss mindestens von EF.1 bis Q1.1 belegbar sein.' );
    end;
  end;

//Hat der Studierende eine 2. FS mit Eintrag Nachweis (N) /  Prüfung (P) ?
//  bel := WBK_SprachNachweisVorhanden;

  bel := FSchueler.SPP;

// Wenn nicht: Wurde in EF.1/ EF.2 ein weiteres Fach aus {F1.2 U F1.3} schriftlich belegt?
  if not bel and ( cnt_FS_schr < 2 ) then
  begin
    err_code := 'FS_4';
    FehlerAusgeben( err_code,'Wurde bisher keine 2. Fremdsprache abschließend nachgewiesen, muss eine neu einsetzende Fremdsprache spätestens beginnend in Q1.1 belegt werden (oder nur FHR möglich).' );
  end;

// F2.1 (GW=Geschichte/SW) belegt?
  bel := GruppeBelegt( W2_1, FEnd_Hj, FEnd_Hj );
  if not bel then
  begin
    err_code := 'GW_1';
    FehlerAusgeben( err_code, 'Geschichte/Sozialwissenschaften muss in EF.1 und EF.2 belegt werden.' );
  end;

//Ein Fach aus F2.2 belegt?
  if FPruefOrd = C_APOWBK_KL then
  begin // nur bei Kolleg
    M1 := W2_2;
    M1 := VereinigungsMenge( M1, W2_3 );
    M1 := VereinigungsMenge( M1, W2_4 );
    bel := GruppeBelegt( M1, FEnd_Hj, FEnd_Hj );
    if not bel then
    begin
      err_code := 'GW_2';
      FehlerAusgeben( err_code, 'Neben Geschichte/Sozialwissenschaften muss in EF.1 und EF.2 ein weiteres gesellschaftswissenschaftliches Fach belegt werden.' );
    end;
  end;

//F4.1 belegt?
  bel := GruppeBelegt( W4, FEnd_Hj, FEnd_Hj );
  if not bel then
  begin // Reli nicht belegt, prüfen, ob Philo
    bel := GruppeBelegt( W2_4, FEnd_Hj, FEnd_Hj );
    if not bel then
    begin
      err_code := 'RE_1';
      FehlerAusgeben( err_code, 'Es wurde kein Religionskurs belegt, je nach Vorgabe der Schule kann es notwendig sein, stattdessen Philosophie zu belegen.' );
    end;
  end;

//F3.1 (M) schriftlich belegt?
  bel := GruppeSchriftlich( W3_1, FEnd_Hj, FEnd_Hj, false );
  if not bel then
  begin
    err_code := 'M_1';
    FehlerAusgeben( err_code, 'Mathematik muss in EF.1 und EF.2 schriftlich belegt werden.' );
  end;

  if FPruefOrd = C_APOWBK_AG then
  begin
// Ein Fach aus F3.2 (NW) belegt?
    bel := GruppeBelegt( W3_2, FEnd_Hj, FEnd_Hj );
    if not bel then
    begin
      err_code := 'NW_1';
      FehlerAusgeben( err_code, 'Mindestens ein Fach aus PH, BI, CH muss in EF.1 und EF.2 belegt werden.' );
    end;
  end else if FPruefOrd = C_APOWBK_KL then
  begin
    cnt := 0;
    M1 := Vereinigungsmenge( W3_2, W3_3 );
    for i := 1 to AnzahlElemente( M1 ) do
    begin
      afach := EinzelElement( M1, i );
      if IstBelegt1( afach, FEnd_Hj, FEnd_Hj ) then
        inc( cnt );
    end;
    if cnt < 2 then
    begin
      err_code := 'NW_2';
      FehlerAusgeben( err_code, 'Mindestens zwei der Fächer PH, BI, CH, IF müssen in EF.1 und EF.2 belegt werden.' );
    end;
  end;

//Anzahl Vertiefungskurse
  cnt := 0;
  for i := 1 to AnzahlElemente( W_VF ) do
  begin
    afach := Einzelelement( W_VF, i );
    if IstBelegt1( afach, FEnd_Hj, FEnd_Hj ) then
      inc( cnt );
  end;

  if cnt > 2 then
  begin
    err_code := 'VF_1';
    FehlerAusgeben( err_code, 'In EF.1 und EF.2 dürfen jeweils maximal 2 Vertiefungskurse belegt werden.' );
  end;


// Kurssumme
  if FPruefOrd = C_APOWBK_KL then
  begin  // Kolleg
    min_kurse := 7;
    err_code := 'ANZ_1_KL';
  end else if FPruefOrd = C_APOWBK_AG then
  begin // Abendgymnasium
    min_kurse := 5;
    err_code := 'ANZ_1_AG';
  end;

  bel := ( FSummen[FEnd_Hj].Kurse >= min_kurse );
  if not bel then
    FehlerAusgeben( err_code, 'In EF.1 und EF.2 müssen jeweils mindestens 7 (5) Fächer/Kurse belegt werden. Bei der Kurszählung werden Vertiefungskurse nicht mitgezählt.' );

// Stundensumme
  if FPruefOrd = C_APOWBK_KL then
  begin  // Kolleg
    min_std := 30;
    err_code := 'ANZ_2_KL';
  end else if FPruefOrd = C_APOWBK_AG then
  begin // Abendgymnasium
    min_std := 20;
    err_code := 'ANZ_2_AG';
  end;

// WBK_Gesamtstunden
  FSummen[7].Stunden := 0;
  for i := 1 to 6 do
    with FSummen[i] do
      FSummen[7].Stunden := FSummen[7].Stunden + Stunden;
  FSummen[7].Stunden := 0.5*FSummen[7].Stunden;

  if not ( Schulstunden( FSummen[FEnd_Hj].Stunden ) >= min_std ) then
    FehlerAusgeben( err_code, 'In EF.1 und EF.2 müssen jeweils mindestens 30 (20) Kursstunden belegt werden. Dabei können maximal zwei Vertiefungskurse gewählt werden.' );

end;

function TAbiturBelegPruefer.FS_als_NP: string;
// Liefert für WBK die FS zurück, bei denen als Sprachenfolge P oder N eingetragen ist
var
  i: integer;
  M1, afach: string;
begin
  Result := '';
  M1 := Vereinigungsmenge( W1_2, W1_3 );
  for i := 1 to AnzahlElemente( M1 ) do
  begin
    afach := Einzelelement( M1, i );
    if FC0.FieldByName( 'FachInternKrz' ).AsString <> afach then
      FC0.Locate( 'FachInternKrz', afach, [loCaseInsensitive] );
    if ( FC0.FieldByname( 'SprachenFolge' ).AsString = 'N' ) or
       ( FC0.FieldByname( 'SprachenFolge' ).AsString = 'P' ) then
    begin
      if Result <> '' then
        Result := Result + ';';
      Result := Result + afach;
    end;
  end;
end;

function TAbiturBelegPruefer.Ist_Erste_FS( const afach: string ): boolean;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> afach then
    FC0.Locate( 'FachInternKrz', afach, [loCaseInsensitive] );
  Result := FC0.FieldByname( 'SprachenFolge' ).AsString = '1';
end;

function TAbiturBelegPruefer.Ist_Zweite_FS( const afach: string ): boolean;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> afach then
    FC0.Locate( 'FachInternKrz', afach, [loCaseInsensitive] );
  Result := FC0.FieldByname( 'SprachenFolge' ).AsString <> '1';
end;


function TAbiturBelegPruefer.Ist_WBK_Quereinsteiger: boolean;
var
  cnt: integer;
begin
  cnt := 0;
  with FC0 do
  begin
    First;
    while not Eof do
    begin
      if ( FieldByName( 'KA_1' ).AsString <> '' ) or ( FieldByName( 'KA_2' ).AsString <> '' ) then
        inc( cnt );
      Next;
    end;
  end;
  Result := cnt <= 2; // Weil M und D aitomatsich gesetzt werden
end;

procedure TAbiturBelegPruefer.Pruefe_Q_Phase_WBK;
var
  schr, bel, bel_sw, bel_re, bel_nw: boolean;
  err_code, afach, lfach, statkrz: string;
  err_text, err_group: string;
  M1, M_A, M_B, M_C, M_D, M_E, M_F: string;
  i, j: integer;
  a_von, a_bis, err_sort: integer;
  quereinst: boolean;
  anzahlE, anzahlQ, anzK, w_std: integer;
  LK1: string;
  abi_1_4: string;
  sum: double;
begin
// Quereinsteiger?
  quereinst := Ist_WBK_Quereinsteiger;

// F1.1 (D)  von Q1.1 bis Q2.2 belegt? (GKS,GKM,LK)
  bel := GruppeBelegt( W1_1, C_Q1, C_Q4 );
  if not bel then
  begin
    err_code := 'D_10';
    FehlerAusgeben( err_code, 'Deutsch muss von Q1.1 bis Q2.2 belegt werden' );
  end;

// F1.1 (D) von Q1.1 bis Q 2.1 schriftlich belegt  als GKS ?
// Einschub: Hier muss schon im Vorfeld geprüft werden, ob Deutsch Abi-Fach ist
  for i := 1 to AnzahlElemente( W1_1 ) do
  begin
    afach := Einzelelement( W1_1, i );
    if not IstAbiFach( afach, [1, 2] ) then
    begin // FRAGE: WAS IST MIT PRÜFUNG AUF LK?
      if IstAbifach( afach, [3] ) then
      begin
        schr := IstSchriftlich( afach, C_Q1, C_Q4 );
        if not schr then
        begin
          err_code := 'D_11';
          FehlerAusgeben( err_code, 'Deutsch muss als 3. Abiturfach von Q1.1 bis Q2.2 schriftlich belegt werden.' );
        end;
      end else if IstAbifach( afach, [4] ) then
      begin
        schr := IstSchriftlich( afach, C_Q1, C_Q3 );
        if not schr then
        begin
          err_code := 'D_12';
          FehlerAusgeben( err_code, 'Deutsch muss als 4. Abiturfach von Q1.1 bis Q2.1 schriftlich belegt werden.' );
        end;
      end else
      begin
        schr := IstSchriftlich( afach, C_Q1, C_Q2 );
        if not schr then
        begin
          err_code := 'D_13';
          FehlerAusgeben( err_code, 'Deutsch muss von Q1.1 bis Q1.2 schriftlich belegt werden.' );
        end;
      end;
    end;
  end;

//Wurde mindestens ein Fach aus F1.2 U F1.3 von Q1.1 bis Q2.2 belegt?
  bel := GruppeBelegt( Vereinigungsmenge( W1_2, W1_3 ), C_Q1, C_Q4 );
  if not bel then
  begin
    err_code := 'FS_10';
    FehlerAusgeben( err_code, 'Mindestens eine Fremdsprache muss von Q1.1 bis Q2.2 durchgehend belegt werden.' );
  end else
  begin
// Prüfen, ob neueinsetzende Fremdsprache als LK belegt ist
    for i := 1 to AnzahlElemente( W1_3 ) do
    begin
      afach := Einzelelement( W1_3, i );
      if IstLK( afach, C_Q1, C_Q4 ) then
      begin
        err_code := 'FS_11';
        FehlerAusgeben( err_code, 'Eine neueinsetzende Fremdsprache kann nur als Grundkurs belegt werden.' );
      end;
    end;
  end;

//FOLIE
//F1.2 U F1.3 von Q1.1 bis Q2.1 schriftlich belegt als GKS ?
// Einschub: Hier muss schon im Vorfeld geprüft werden, ob FS Abi-Fach ist
  M1 := Vereinigungsmenge( W1_2, W1_3 );
  for i := 1 to AnzahlElemente( M1 ) do
  begin
    afach := Einzelelement( M1, i );
    if not IstAbiFach( afach, [1, 2] ) then
    begin // FRAGE: WAS IST MIT PRÜFUNG AUF LK?
      if IstAbifach( afach, [3] ) then
      begin
        schr := IstSchriftlich( afach, C_Q1, C_Q4 );
        if not schr then
        begin
          err_code := 'FS_12';
          FehlerAusgeben( err_code, 'Eine Fremdsprache muss als 3. Abiturfach von Q1.1 bis Q2.2 schriftlich belegt werden.' );
        end;
      end else if IstAbifach( afach, [4] ) then
      begin
        schr := IstSchriftlich( afach, C_Q1, C_Q3 );
        if not schr then
        begin
          err_code := 'FS_13';
          FehlerAusgeben( err_code, 'Eine Fremdsprache muss als 4. Abiturfach von Q1.1 bis Q2.1 schriftlich belegt werden.' );
        end;
      end else
      begin // Kein Abiturfach
        if Ist_Erste_FS( afach ) then
        begin // laut Herrn Hoge gilt die Schriftlichkeit (wenn nicht Abi-Fach) in Q1.1 bis Q1.2 nur für 1. FS
          schr := IstSchriftlich( afach, C_Q1, C_Q2 );
          if not schr then
          begin
            err_code := 'FS_14';
            FehlerAusgeben( err_code, 'Wenn die 1. Fremdsprache kein Abiturfach ist, muss sie von Q1.1 bis Q1.2 schriftlich belegt werden.' );
          end;
        end;
      end;
    end;
  end;

// FOLIE 10
//Hat der Studierende eine 2. FS mit Eintrag Nachweis (N) / Prüfung (P) ?
  bel := FSchueler.FS2_SekI_manuell or ( FS_als_NP <> '' ); // FS_als_NP <> '' ist "Variante 1"
  if not bel then
  begin
// Nachweisprüfung für 2. Fremdsprache (alu Antwort von Herrn Hoge vom 20.7.2010
// Neue Formulierung
// "Variante 2":
// die 2. FS wurde in EF1 und EF2 schriftlich und in Q1.1 mindestens mündlich belegt
//    	-  über die drei Semester müssen mindestens 12 SemWStd belegt worden sein
//	      	(Regelfall: 	EF1 (=1. Sem) 6. stündig schriftlich
//                  			EF2 (=2. Sem) 6 stündig schriftlich)
//                				Q1,1(=3. Sem) 2 oder 3-stündig mündlich)
// Ausnahme
// b) drei Semester a´ 4  Stunden (kommt häufig im Bildungsgang AG vor)

// Erst mal alle Fremdsprachen ermitteln
    M1 := VereinigungsMenge( W1_2, W1_3 );
// Nun die zweite FS ermitteln
    for i := 1 to AnzahlElemente( M1 ) do
    begin
      afach := EinzelElement( M1, i );
//      if Ist_Erste_FS( afach ) then
      if not Ist_Zweite_FS( afach ) then
        AusMengeLoeschen( M1, afach );
    end;
    schr := false;
    for i := 1 to AnzahlElemente( M1 ) do
    begin // Schleife über alle potentiellen 2. Fs
      afach := EinzelElement( M1, i );
// Die 2. FS muss in EF1 und EF2 schriftlich und in Q1.1 mindestens mündl. belegt sein (einschl. der Wochenstunden)
      schr := IstSchriftlich( afach, C_E1, C_E2 ) and IstBelegt( afach, C_Q1, C_Q1 )
              and ( SChulstunden( GesamtWochenstunden( afach, C_E1, C_Q4 ) ) >= 12 );
// Ausnahmefall möglich: Die Einführung beginnt erst in Q1.1 und wird bis Q2.2 in 3-stündigen GKs fortgeführt
// Oder drei Semester a´ 4  Stunden (kommt häufig im Bildungsgang AG vor)

      if not schr then
// Die Einführung beginnt erst in Q1.1 und wird bis Q2.2 in 3-stündigen GKs fortgeführt
        schr := IstBelegt( afach, C_Q1, C_Q4 ) and ( Schulstunden( GesamtWochenstunden( afach, C_Q1, C_Q4 ) ) >= 12 );

      if not schr then
// Die Einführung beginnt in EF.1 und wird bis Q1.1 ( 3 Semester) in 4-stündigen GKs fortgeführt
        schr := IstBelegt( afach, C_E1, C_Q1 ) and ( Schulstunden( GesamtWochenstunden( afach, C_E1, C_Q1 ) ) >= 12 );

      if not schr then
// Die Einführung beginnt in EF.2 und wird bis Q1.2 ( 3 Semester) in 4-stündigen GKs fortgeführt
        schr := IstBelegt( afach, C_E2, C_Q2 ) and ( Schulstunden( GesamtWochenstunden( afach, C_E2, C_Q2 ) ) >= 12 );

      if not schr then
// Die Einführung beginnt in Q1.1 und wird bis Q2.1 ( 3 Semester) in 4-stündigen GKs fortgeführt
        schr := IstBelegt( afach, C_Q1, C_Q3 ) and ( Schulstunden( GesamtWochenstunden( afach, C_Q1, C_Q3 ) ) >= 12 );

      if not schr then
// Die Einführung beginnt in Q1.2 und wird bis Q2.2 ( 3 Semester) in 4-stündigen GKs fortgeführt
        schr := IstBelegt( afach, C_Q2, C_Q4 ) and ( Schulstunden( GesamtWochenstunden( afach, C_Q2, C_Q4 ) ) >= 12 );
      if schr then
        break;
    end;
    schr := schr or FSchueler.SPP;
    if not schr then
    begin
      err_code := 'FS_15';
      FehlerAusgeben( err_code, 'Es wurde bisher weder eine Einf. in eine 2. Fremdspr. nachgewiesen noch ist die Belegungsverpflichtung für die Einführung in eine 2. Fremdspr. erfüllt (oder nur FHR möglich).' );
    end;
// Hinweis: FS_16 wird derzeit nicht benutzt
  end;

//FOLIE
//Schleife über alle belegte  Fächer aus F1.1 U F1.2 U F1.3 U F1.4
//(Deutsch) U (Fremdsprache S1) U ( Fremdsprache S2) U (künstl.-literarisch)
  M_A := '';
  M_B := '';
  M_C := '';
  M_D := '';
  M_E := '';
  M_F := '';
  M1 := VereinigungsMenge( W1_1, W1_2 );
  M1 := VereinigungsMenge( M1, W1_3 );
  M1 := VereinigungsMenge( M1, W1_4 );
  for i := 1 to AnzahlElemente( M1 ) do
  begin
//Wenn das Fach durchgehend von Q1.1 bis Q2.2 belegt wurde, dann nimm das Fach in einer Menge A auf.
    afach := Einzelelement( M1, i );
    if IstBelegt1( afach, C_Q1, C_Q4 ) then
    begin
      ZuMengeHinzu( M_A, afach );
//Wenn das Fach durchgehend von Q1.1 bis Q2.2 belegt wurde und von Q1.1 bis Q2.1 schriftlich belegt wurde, dann nimm das Fach in einer Menge B auf.
      if IstSchriftlich( afach, C_Q1, C_Q3 ) then
        ZuMengeHinzu( M_B, afach );
    end;
  end;

//FOLIE 12
// not (#A ≥ 2  und #B ≥ 1 ) ?
// ERGÄNZUNG
// #A<2 => Meldung I: Mindestens D und 1. FS müssen durchgehend von Q1.1 bis Q2.2 belegt sein(ANT_AGF1_A)
// #B<1 => Meldung II: Mindestens ein Fach aus Aufgabenfeld 1 muss von Q1.1 bis mindestens Q2.1 schriftlich belegt werden(ANT_AGF1_B)
// #A<2  UND   #B<1    Meldung I + Meldung II

  if ( AnzahlElemente( M_A ) < 2 ) and ( AnzahlElemente( M_B ) < 1 ) then
  begin
    err_code := 'ANZ_AGF1_A';
    FehlerAusgeben( err_code, 'Mindestens D und 1. FS müssen durchgehend von Q1.1 bis Q2.2 belegt sein.' );
    err_code := 'ANZ_AGF1_B';
    FehlerAusgeben( err_code, 'Mindestens ein Fach aus Aufgabenfeld 1 muss von Q1.1 bis mindestens Q2.1 schriftlich belegt werden' );
  end else if AnzahlElemente( M_B ) < 1 then
  begin
    err_code := 'ANZ_AGF1_B';
    FehlerAusgeben( err_code, 'Mindestens ein Fach aus Aufgabenfeld 1 muss von Q1.1 bis mindestens Q2.1 schriftlich belegt werden' );
  end else if AnzahlElemente( M_A ) < 2 then
  begin
    err_code := 'ANZ_AGF1_A';
    FehlerAusgeben( err_code, 'Mindestens D und 1. FS müssen durchgehend von Q1.1 bis Q2.2 belegt sein.' );
  end;

//FOLIE
  if not quereinst then
  begin //Belegung in EF.1 und/oder EF.2 existiert ?
// Schleife über alle Fächer aus der Menge B
    for i := 1 to AnzahlElemente( M_B ) do
    begin
      afach := Einzelelement( M_B, i );
      if IstAbiFach( afach, [1,2,3,4] ) then
      begin
        bel := IstBelegt1( afach, C_E1, C_E1 ) or IstBelegt1( afach, C_E2, C_E2 );
        if not bel then
        begin
          err_code := 'ABI_10';
          LupoMessenger.GetMessageText( err_code, err_text, err_group, err_sort );
          if FBeratung and Assigned( FConABP ) then
{$IFDEF UNIDAC}
            FConABP.ExecSQL( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext, Fehlergruppe, Sortierung) values (%d,%s,%s,%s,%d)',
                            [ FSchueler.ID,
                              QuotedStr( err_code ),
                              QuotedStr( Format( 'Das Fach "%s" kann nicht Abiturfach sein, da es nicht in der E-Phase belegt wurde.', [ afach ] ) ),
                              QuotedStr( err_group ),
                              err_sort ] ) );
{$ELSE}
            FConABP.Execute( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext, Fehlergruppe, Sortierung) values (%d,%s,%s,%s,%d)',
                            [ FSchueler.ID,
                              QuotedStr( err_code ),
                              QuotedStr( Format( 'Das Fach "%s" kann nicht Abiturfach sein, da es nicht in der E-Phase belegt wurde.', [ afach ] ) ),
                              QuotedStr( err_group ),
                              err_sort ] ) );
{$ENDIF}
        end;
      end;
    end;
  end;

//FOLIE
//Eine Gesellschaftswiisenschaft von Q1.1 bis Q2.2 durchgehend belegt?
//
  M1 := VereinigungsMenge( W2_1, W2_2 ); // Geschichte/SW vereinigt Sozialwissenschaften
  M1 := VereinigungsMenge( M1, W2_3 ); // zusätzlich EK usw.
  M1 := VereinigungsMenge( M1, W2_4 ); // zusätzlich Philosophie
// Durchgehend belegt??
  bel := GruppeBelegt( M1, C_Q1, C_Q4 );
// oder : In einem Fach aus M1 und in einem Fach aus F4 je zwei Kurse in zwei aufeinander folgenden Semestern belegt

  for i := 1 to AnzahlElemente( M1 ) do
  begin // Für Sozialwiss,
    afach := EinzelElement( M1, i );
    bel_sw := FachIn2HjBelegt( afach, C_Q1, C_Q4 );
  end;

  for i := 1 to AnzahlElemente( W4 ) do
  begin // Für Religion
    afach := EinzelElement( W4, i );
    bel_re := FachIn2HjBelegt( afach, C_Q1, C_Q4 );
  end;

// Hier prüfebn: Durchgehend belegt?? oder : In einem Fach aus M1 und in einem Fach aus F4 je zwei Kurse in zwei aufeinanderfolgenden Semestern belegt
  bel := bel or ( bel_sw and bel_re );
  if not bel then
  begin
    err_code := 'SW_RE_10';
    FehlerAusgeben( err_code, 'Eine Gesellschaftswissenschaft muss von Q1.1 bis Q2.2 durchgehend belegt werden ODER ' +
                  'In einer Gesellschaftswissenschaft und in Religionslehre müssen in der Q-Phase je zwei Kurse in zwei aufeinander folgenden Semestern belegt werden.' );
  end;

//FOLIE
//Mindestens ein Fach aus F2.1 oder F4.1 von Q1.1 bis Q2.2  durchgehend belegt
//UND mindestens von Q1.1 bis Q2.1 schriftlich belegt?

  bel_sw := GruppeBelegt( M1, C_Q1, C_Q4 ) and GruppeSchriftlich( M1, C_Q1, C_Q3, false );
  bel_re := GruppeBelegt( W4, C_Q1, C_Q4 ) and GruppeSchriftlich( W4, C_Q1, C_Q3, false );

  bel := bel_sw or bel_re;
  if not bel then
  begin
    err_code := 'SW_RE_11';
    FehlerAusgeben( err_code, 'Mindestens eine Gesellschaftswissenschaft ODER Religionslehre muss in Q1.1 bis Q2.2 durchgehend belegt UND von Q1.1 bis wenigstens Q2.1 schriftlich belegt werden.' );
  end;

//FOLIE
//Schleife über alle belegte Fächer aus M1 (Gesellschaftswissenschaften) und F4 (Religionslehre)
  M1 := VereinigungsMenge( M1, W4 );
  for i := 1 to AnzahlElemente( M1 ) do
  begin
    afach := EinzelElement( M1, i );
//Wenn das Fach durchgehend von Q1.1 bis Q2.2 belegt wurde, dann nimm das Fach in einer Menge C auf.
    if IstBelegt1( afach, C_Q1, C_Q4 ) then
    begin
      ZuMengeHinzu( M_C, afach );
//Wenn das Fach durchgehend von Q1.1 bis Q2.2 belegt wurde und von Q1.1 bis Q2.1 schriftlich belegt wurde, dann nimm das Fach in einer Menge D auf.
      if IstSchriftlich( afach, C_Q1, C_Q3 ) then
        ZuMengeHinzu( M_D, afach );
    end;
  end;

//FOLIE
//# C ≥ 1  und # D ≥ 1
  bel := ( AnzahlElemente( M_C ) >= 1 ) and ( AnzahlElemente( M_D ) >= 1 );
  if not bel then
  begin
    err_code := 'SW_RE_12';
    FehlerAusgeben( err_code, 'Mindestens ein Fach aus Aufgabenfeld II ODER Religionslehre muss von Q1.1 bis wenigstens Q2.1 schriftlich belegt werden.' );
  end;

//FOLIE 18
  if not quereinst then
  begin //Belegung in EF.1 und/oder EF.2 existiert ?
// Schleife über alle Fächer aus der Menge D
    for i := 1 to AnzahlElemente( M_D ) do
    begin
      afach := Einzelelement( M_D, i );
      statkrz := StatistikKuerzel( afach );
      if IstAbiFach( afach, [1,2,3,4] ) then
      begin
// Existiert das Fach in EF.1 oder EF.2
        bel := IstBelegt1( afach, C_E1, C_E1 ) or IstBelegt1( afach, C_E2, C_E2 );
        if not bel then
          bel := WBK_AffinesFachBelegt( statkrz );
//ODER ist das Fach affines Fach zu GW bzw PA ( F2.A)  in EF.1 oder EF.2
// Was bedeutet das?????
// affine Fächer
// Für VWL und Soziologie (in Q-Phase) sind Geschichte/Sozialwissenschaften aus E-Phase affin
// Für Psychologie (in Q-Phase) ist Erziehungswissenschaft aus E-Phase affin
// EF(GW)  => Q(GW,SL,VW) ;		affine Fächer zu GW bzw. PA 	
// EF(PA)  => Q(PA,PS)}
        if not bel then
        begin
          err_code := 'ABI_10';
          LupoMessenger.GetMessageText( err_code, err_text, err_group, err_sort );
          if FBeratung and Assigned( FConABP ) then
{$IFDEF UNIDAC}
            FConABP.ExecSQL( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext, Fehlergruppe, Sortierung) values (%d,%s,%s,%s,%d)',
                            [ FSchueler.ID,
                              QuotedStr( err_code ),
                              QuotedStr( Format( 'Das Fach "%s" kann nicht Abiturfach sein, da es nicht in der E-Phase belegt wurde.', [ afach ] ) ),
                              QuotedStr( err_group ),
                              err_sort ] ) );
{$ELSE}
            FConABP.Execute( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext, Fehlergruppe, Sortierung) values (%d,%s,%s,%s,%d)',
                            [ FSchueler.ID,
                              QuotedStr( err_code ),
                              QuotedStr( Format( 'Das Fach "%s" kann nicht Abiturfach sein, da es nicht in der E-Phase belegt wurde.', [ afach ] ) ),
                              QuotedStr( err_group ),
                              err_sort ] ) );
{$ENDIF}
        end;
      end;
    end;
  end;

//FOLIE
//F3.1 (M) von Q1.1 bis Q2.2  belegt?
  bel := GruppeBelegt( W3_1, C_Q1, C_Q4 );
  if not bel then
  begin
    err_code := 'M_10';
    FehlerAusgeben( err_code, 'Mathematik muss von Q1.1 bis Q2.2 belegt werden.');
  end;

//FOLIE
// F3.1 (M) von Q1.1 bis Q 2.1 schriftlich belegt  als GKS ?
// Einschub: Hier muss schon im Vorfeld geprüft werden, ob Deutsch Abi-Fach ist
  for i := 1 to AnzahlElemente( W3_1 ) do
  begin
    afach := Einzelelement( W3_1, i );
    if not IstAbiFach( afach, [1, 2] ) then
    begin // FRAGE: WAS IST MIT PRÜFUNG AUF LK?
      if IstAbifach( afach, [3] ) then
      begin
        schr := IstSchriftlich( afach, C_Q1, C_Q4 );
        if not schr then
        begin
          err_code := 'M_11';
          FehlerAusgeben( err_code, 'Mathematik muss als 3. Abiturfach von Q1.1 bis Q2.2 schriftlich belegt werden.' );
        end;
      end else if IstAbifach( afach, [4] ) then
      begin
        schr := IstSchriftlich( afach, C_Q1, C_Q3 );
        if not schr then
        begin
          err_code := 'M_12';
          FehlerAusgeben( err_code, 'Mathematik muss als 4. Abiturfach von Q1.1 bis Q2.1 schriftlich belegt werden.' );
        end;
      end else
      begin
        schr := IstSchriftlich( afach, C_Q1, C_Q2 );
        if not schr then
        begin
          err_code := 'M_13';
          FehlerAusgeben( err_code, 'Mathematik muss von Q1.1 bis Q1.2 schriftlich belegt werden.' );
        end;
      end;
    end;
  end;

//FOLIE
//Mindestens ein Fach aus F3.2 in Q1.1 bis Q2. 2 in zwei aufeinander folgenden Semestern belegt?
  for i := 1 to AnzahlElemente( W3_2 ) do
  begin // Für Nat-Wiss.
    afach := EinzelElement( W3_2, i );
    bel_nw := FachIn2HjBelegt( afach, C_Q1, C_Q4 );
    if bel_nw then
      break;
  end;
  if not bel_nw then
  begin
    err_code := 'NW_10';
    FehlerAusgeben( err_code, 'Mindestens eine klassische Naturwissenschaft (Physik, Biologie, Chemie) muss in Q1.1 bis Q2.2 in zwei aufeinander folgenden Semestern belegt werden.' );
  end;

//FOLIE
//Schleife über alle belegte  Fächer aus F3.1 U F3.2 U F3.4 (Mathematik) (Naturwissenschaften) (Informatik)
  M1 := Vereinigungsmenge( W3_1, W3_2 );
  M1 := Vereinigungsmenge( M1, W3_3 );
  for i := 1 to AnzahlElemente( M1 ) do
  begin
    afach := Einzelelement( M1, i );
//Wenn das Fach durchgehend von Q1.1 bis Q2.2 belegt wurde, dann nimm das Fach in einer Menge E auf.
    if IstBelegt1( afach, C_Q1, C_Q4 ) then
    begin
      ZuMengeHinzu( M_E, afach );
//Wenn das Fach durchgehend von Q1.1 bis Q2.2 belegt wurde und von Q1.1 bis Q2.1 schriftlich belegt wurde, dann nimm das Fach in einer Menge F auf.
      if IstSchriftlich( afach, C_Q1, C_Q3 ) then
        ZuMengeHinzu( M_F, afach );
    end;
  end;

//FOLIE
//# E ≥ 1  und # F ≥ 1
  bel := ( AnzahlElemente( M_C ) >= 1 ) and ( AnzahlElemente( M_D ) >= 1 );
  if not bel then
  begin
    err_code := 'M_NW_10';
    FehlerAusgeben( err_code, 'Mindestens ein Fach aus Aufgabenfeld III muss von Q1.1 bis wenigstens Q2.1 schriftlich belegt werden.' );
  end;

//FOLIE
  if not quereinst then
  begin //Belegung in EF.1 und/oder EF.2 existiert ?
// Schleife über alle Fächer aus der Menge F
    for i := 1 to AnzahlElemente( M_F ) do
    begin
      afach := Einzelelement( M_F, i );
      if IstAbiFach( afach, [1,2,3,4] ) then
      begin
        bel := IstBelegt1( afach, C_E1, C_E1 ) or IstBelegt1( afach, C_E2, C_E2 );
        if not bel then
        begin
          err_code := 'ABI_10';
          LupoMessenger.GetMessageText( err_code, err_text, err_group, err_sort );
          if FBeratung and Assigned( FConABP ) then
{$IFDEF UNIDAC}
            FConABP.ExecSQL( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext, Fehlergruppe, Sortierung) values (%d,%s,%s,%s,%d)',
                            [ FSchueler.ID,
                              QuotedStr( err_code ),
                              QuotedStr( Format( 'Das Fach "%s" kann nicht Abiturfach sein, da es nicht in der E-Phase belegt wurde.', [ afach ] ) ),
                              QuotedStr( err_group ),
                              err_sort ] ) );
{$ELSE}
            FConABP.Execute( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext, Fehlergruppe, Sortierung) values (%d,%s,%s,%s,%d)',
                            [ FSchueler.ID,
                              QuotedStr( err_code ),
                              QuotedStr( Format( 'Das Fach "%s" kann nicht Abiturfach sein, da es nicht in der E-Phase belegt wurde.', [ afach ] ) ),
                              QuotedStr( err_group ),
                              err_sort ] ) );
{$ENDIF}
        end;
      end;
    end;
  end;

{//FOLIE Hinweis: Behandlung wie bei GY GE
//Anzahl Projektkurse, hier rauskommentiert, kommt unten
  if W_PF <> '' then
  begin
    anzahlE := 0;
    anzahlQ := 0;
    for i := 1 to AnzahlElemente( W_PF ) do
    begin
      afach := Einzelelement( W_PF, i );
      anzahlE := anzahlE + AnzahlBelegteHalbjahre( afach, C_E1, C_E2 );
      anzahlQ := anzahlQ + AnzahlBelegteHalbjahre( afach, C_Q1, C_Q4 );
    end;

    if anzahlE > 0 then
    begin
      err_code := 'PF_10';
      FehlerAusgeben( err_code, 'In der Einführungsphase können keine Projektkurse belegt werden' );
    end;

  // 39.Maximal zwei zusammenhängende Kurse in einem Projektfach in Q1 bis Q4?

  // Zusatz: Prüfen ob Leitfach vorhanden

    for i := 1 to AnzahlElemente( W_PF ) do
    begin
      afach := Einzelelement( W_PF, i );
      FC0.Locate( 'FachInternKrz', afach, [loCaseInsensitive] );
      lfach := FC0.FieldByname( 'Leitfach1Krz' ).AsString;
      if ( lfach = '' ) and Assigned( FConABP ) then
        FConABP.Execute( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext) values (%d,%s,%s)',
                      [ FSchueler.ID,
                        QuotedStr( 'PF_LEITFACH' ),
                        QuotedStr( Format( 'Der Projetkurs "%s" hat kein 1. Leitfach', [ afach ] ) )
                         ] ) );
    end;

  // Also in Q1/Q2 oder Q2/Q3 oder Q3/Q4.
    anzahlQ := 0;
    for i := 1 to AnzahlElemente( W_PF ) do
    begin
      afach := Einzelelement( W_PF, i );
      if IstBelegt( afach, C_Q1, C_Q2 ) or IstBelegt( afach, C_Q2, C_Q3 ) or IstBelegt( afach, C_Q3, C_Q4 ) then
        inc( anzahlQ );
    end;
    if anzahlQ >= 2 then
    begin
      err_code := 'PF_11';
      FehlerAusgeben( err_code, 'In der Qualifikationsphase kann maximal ein Projektkurs belegt werden.' );
    end;

  // 40. Projektkurs belegt?
    schr := true; // wird hier für die Belegung aller Leitfächer verwendet
    for i := 1 to AnzahlElemente( W_PF ) do
    begin
      afach := Einzelelement( W_PF, i );
      schr := schr and LeitfachBelegt( afach );
      if not schr then
        break;
    end;
  end;  // Ende W_PF }

//FOLIE
//32. # durchgehend belegter LKs von Q1 bis Q4 = 2
  anzahlQ := 0;

  for i := 1 to AnzahlElemente( W_LK ) do
  begin
    afach := Einzelelement( W_LK, i );
    if IstLK( afach, C_Q1, C_Q4 ) then
      inc( anzahlQ );
  end;

// Einschub: 51 (neue Zählung) Prüfe für jedes Halbjahr: Wurden mehr als zwei LKs belegt?
  if AnzahlElemente( W_LK ) > 2 then
  begin
    err_code := 'LK_11';
    FehlerAusgeben( err_code, 'Es dürfen nicht mehr als zwei Fächer als Leistungskurse belegt werden.' );
  end else if anzahlQ <> 2 then
  begin
    err_code := 'LK_10';
    FehlerAusgeben( err_code, 'In der Qualifikationsphase müssen zwei Fächer durchgehend in Leistungskursen belegt werden' );
  end;

//FOLIE
// Anzahl durchgehender GK
  for i := 1 to AnzahlElemente( W_GK ) do
  begin
    afach := Einzelelement( W_GK, i );
//    if IstBelegt( afach, C_Q1, C_Q4 ) then
    begin
      for j := C_Q1 to C_Q4 do
      begin
        if IstBelegt( afach, j, j ) then
        begin
          if IstGKS( afach, j, j ) then
            FSummen[j].AnzGKS := FSummen[j].AnzGKS + 1;
          if IstGK( afach, j, j ) then
            FSummen[j].AnzGK := FSummen[j].AnzGK + 1;
        end;
      end;
    end;
  end;

//FOLIE
  if FPruefOrd = C_APOWBK_KL then
  begin
//Je min. 5xGKs (ohne VF) und Anzahl der Kursstunden min. 30 (mit VF)
    bel := true;
    for j := C_Q1 to C_Q4 do
      bel := bel and ( FSummen[j].AnzGK >= 5 );
    if not bel then
    begin
      err_code := 'GKS_10_KL';
      FehlerAusgeben( err_code, 'In der Qualifikationsphase sind pro Halbjahr mindestens 5 Fächer in Grundkursen zu wählen. Bei der Kurszählung werden Vertiefungskurse nicht mitgezählt.' );
    end;
    bel := true;

// Neu: In der Q-Phase müssen durchschnittlich 30 WStd belegt werden und die durchschnittliche WStd-Zahl 30
// darf in einem Semester um höchstens zwei Stunden unterschritten werden
    sum := 0;
    for j := C_Q1 to C_Q4 do
      sum := sum + FSummen[j].Stunden;
    sum := Schulstunden( sum ) / 4;
    bel := sum >= 30;
    if bel then
    begin
      for j := C_Q1 to C_Q4 do
        bel := bel and ( Schulstunden( FSummen[j].Stunden ) >= 28 );
    end;
    if not bel then
    begin
      err_code := 'GKS_11_KL';
      FehlerAusgeben( err_code, 'In der Qualifikationsphase müssen durchschnittlich 30 WStd. belegt werden und die durchschnittliche WStd-Zahl 30' +
                                ' darf in einem Semester um höchstens zwei Stunden unterschritten werden' );
    end;

  end else if FPruefOrd = C_APOWBK_AG then
  begin
//Je min. 3xGKs (ohne VF) und Anzahl der Kursstunden min. 20 (mit VF)
    bel := true;
    for j := C_Q1 to C_Q4 do
      bel := bel and ( FSummen[j].AnzGK >= 3 );
    if not bel then
    begin
      err_code := 'GKS_10_AG';
      FehlerAusgeben( err_code, 'In der Qualifikationsphase sind pro Halbjahr mindestens 3 Fächer in Grundkursen zu wählen. Bei der Kurszählung werden Vertiefungskurse nicht mitgezählt.' );
    end;

// Neu: In der Q-Phase müssen durchschnittlich 20 WStd belegt werden und die durchschnittliche WStd-Zahl 20
// darf in einem Semester um höchstens zwei Stunden unterschritten werden
    sum := 0;
    for j := C_Q1 to C_Q4 do
      sum := sum + FSummen[j].Stunden;
    sum := Schulstunden( sum ) / 4;
    bel := sum >= 20;

    if bel then
    begin
      for j := C_Q1 to C_Q4 do
        bel := bel and ( Schulstunden( FSummen[j].Stunden ) >= 18 );
    end;
    if not bel then
    begin
      err_code := 'GKS_11_AG';
      FehlerAusgeben( err_code, 'In der Qualifikationsphase müssen durchschnittlich 20 WStd. belegt werden und die durchschnittliche WStd-Zahl 20' +
                                ' darf in einem Semester um höchstens zwei Stunden unterschritten werden' );
    end;

{   ALT
    if not bel then
    begin
      err_code := 'GKS_11_AG';
      FehlerAusgeben( err_code, 'In der Qualifikationsphase müssen pro Halbjahr mindestens 20 Kursstunden belegt werden. Dabei können maximal zwei Vertiefungskurse gewählt werden.' );
    end;}
  end;

//FOLIE
//Anzahl Vertiefungskurse, hier pro Semester!!!!
  for j := C_Q1 to C_Q4 do
  begin
    anzahlQ := 0;
    for i := 1 to AnzahlElemente( W_VF ) do
    begin
      afach := Einzelelement( W_VF, i );
      if IstBelegt1( afach, j, j ) then
        inc( anzahlQ );
    end;
//In der Qualifikationsphase können pro Semester maximal zwei Vertiefungskurse belegt werden.
    if anzahlQ > 2 then
    begin
      err_code := 'VF_10';
      FehlerAusgeben( err_code, 'In der Qualifikationsphase können pro Semester maximal zwei Vertiefungskurse belegt werden.' );
      break;
    end;
  end;

// FOLIE Kurssummierung
//erst mal Anzahl Projektkurse ermitteln
  if W_PF <> '' then
  begin
    anzahlE := 0;
    anzahlQ := 0;
    for i := 1 to AnzahlElemente( W_PF ) do
    begin
      afach := Einzelelement( W_PF, i );
      anzahlE := anzahlE + AnzahlBelegteHalbjahre( afach, C_E1, C_E2 );
      anzahlQ := anzahlQ + AnzahlBelegteHalbjahre( afach, C_Q1, C_Q4 );
    end;

  // 38.Summiere in E1/E2: #PK = 0
    if anzahlE > 0 then
    begin
      err_code := 'PF_10';
      FehlerAusgeben( err_code, 'In der Einführungsphase können keine Projektkurse belegt werden' );
    end;

  // 39.Maximal zwei zusammenhängende Kurse in einem Projektfach in Q1 bis Q4?

  // Zusatz: Prüfen ob Leitfach vorhanden

    for i := 1 to AnzahlElemente( W_PF ) do
    begin
      afach := Einzelelement( W_PF, i );
      FC0.Locate( 'FachInternKrz', afach, [loCaseInsensitive] );
      lfach := FC0.FieldByname( 'Leitfach1Krz' ).AsString;
      if ( lfach = '' ) and Assigned( FConABP ) then
{$IFDEF UNIDAC}
        FConABP.ExecSQL( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext) values (%d,%s,%s)',
                      [ FSchueler.ID,
                        QuotedStr( 'PF_LEITFACH' ),
                        QuotedStr( Format( 'Der Projetkurs "%s" hat kein 1. Leitfach', [ afach ] ) )
                         ] ) );
{$ELSE}
        FConABP.Execute( Format( 'insert into ABP_SchuelerFehlerMeldungen (Schueler_ID, Fehlercode, Fehlertext) values (%d,%s,%s)',
                      [ FSchueler.ID,
                        QuotedStr( 'PF_LEITFACH' ),
                        QuotedStr( Format( 'Der Projetkurs "%s" hat kein 1. Leitfach', [ afach ] ) )
                         ] ) );
{$ENDIF}

    end;

  // Also in Q1/Q2 oder Q2/Q3 oder Q3/Q4.
    anzahlQ := 0;
    for i := 1 to AnzahlElemente( W_PF ) do
    begin
      afach := Einzelelement( W_PF, i );
      if IstBelegt( afach, C_Q1, C_Q2 ) or IstBelegt( afach, C_Q2, C_Q3 ) or IstBelegt( afach, C_Q3, C_Q4 ) then
        inc( anzahlQ );
    end;
    if anzahlQ >= 2 then
    begin
      err_code := 'PF_11';
      FehlerAusgeben( err_code, 'In der Qualifikationsphase kann maximal ein Projektkurs belegt werden.' );
    end;

  // 40. Projektkurs belegt?
    schr := true; // wird hier für die Belegung aller Leitfächer verwendet
    for i := 1 to AnzahlElemente( W_PF ) do
    begin
      afach := Einzelelement( W_PF, i );
      schr := schr and LeitfachBelegt_WB( afach );
      if not schr then
        break;
    end;
  end;  // Ende W_PF

// Kursummen
  anzK := FKursZaehler.Gesamtzahl;

  if FPruefOrd = C_APOWBK_KL then
  begin
// # aller Kurse ≥ 28 und <= 34?
    if anzK < 28 then
    begin
      err_code := 'ANZ_KL_1';
      FehlerAusgeben( err_code, 'In der Qualifikationsphase müssen zwischen 28 und 34 anrechenbare Kurse belegt werden. Dabei werden Vertiefungskurse nicht mitgezählt.' );
    end else if anzK > 34 then
    begin
// Laut Hoge nur eine Info-Anzeige
      err_code := 'ANZ_KL_2';
      FehlerAusgeben( err_code, 'In der Qualifikationsphase wurden mehr als 34 Kurse belegt, es können aber nur max. 34 Kurse gewertet werden (Vertiefungskurse werden nicht mitgezählt).' );
    end;
  end else if FPruefOrd = C_APOWBK_AG then
  begin
// # aller Kurse ≥ 16 und <= 24?
    if anzK < 16 then
    begin
      err_code := 'ANZ_AG_1';
      FehlerAusgeben( err_code, 'In der Qualifikationsphase müssen zwischen 16 und 24 anrechenbare Kurse belegt werden. Dabei werden Vertiefungskurse nicht mitgezählt.' );
    end else if anzK > 24 then
    begin
      err_code := 'ANZ_AG_2';
      FehlerAusgeben( err_code, 'In der Qualifikationsphase wurden mehr als 24 anrechenbare Kurse belegt, es können aber nur max. 24 Kurse gewertet werden (Vertiefungskurse werden nicht mitgezählt).' );
    end;
  end;

  FSummen[7].Kurse := anzK;
  FSummen[7].Stunden := 0;
  for i := 1 to 6 do
    with FSummen[i] do
      FSummen[7].Stunden := FSummen[7].Stunden + Stunden;
  FSummen[7].Stunden := 0.5*FSummen[7].Stunden;

//FOLIE
//Mindestwochenstd.-Zahl im Aufgabenfeld I, nur bei Kolleg
  if FPruefOrd = C_APOWBK_KL then
  begin
    anzahlQ := 0;
    for i := 1 to AnzahlElemente( W1 ) do
    begin //Schleife über alle belegte Fächer aus Aufgabenfeld I
      afach := Einzelelement( W1, i );
      FC0.Locate( 'FachInternKrz', afach, [loCaseInsensitive] );
      for j := C_Q1 to C_Q4 do
        if IstBelegt1( afach, j, j ) then
          anzahlQ := anzahlQ + FC0.FieldByname( Format( 'WS_%d', [ j ] ) ).AsInteger
    end;
    anzahlQ := Schulstunden( anzahlQ );
    if anzahlQ < 24 then
    begin
      err_code := 'AGF1_SUMME';
      FehlerAusgeben( err_code, 'Im Aufgabenfeld I müssen mindestens 24 Sem.-WStd. in der Q-Phase belegt werden.' );
    end;

    anzahlQ := 0;
    for i := 1 to AnzahlElemente( W2 ) do
    begin //Schleife über alle belegte Fächer aus Aufgabenfeld II
      afach := Einzelelement( W2, i );
      FC0.Locate( 'FachInternKrz', afach, [loCaseInsensitive] );
      for j := C_Q1 to C_Q4 do
        if IstBelegt1( afach, j, j ) then
          anzahlQ := anzahlQ + FC0.FieldByname( Format( 'WS_%d', [ j ] ) ).AsInteger
    end;
    anzahlQ := Schulstunden( anzahlQ );
    if anzahlQ < 16 then
    begin
      err_code := 'AGF2_SUMME';
      FehlerAusgeben( err_code, 'Im Aufgabenfeld II müssen mindestens 16 Sem.-WStd. in der Q-Phase belegt werden.' );
    end;

    anzahlQ := 0;
    for i := 1 to AnzahlElemente( W3 ) do
    begin //Schleife über alle belegte Fächer aus Aufgabenfeld II
      afach := Einzelelement( W3, i );
      FC0.Locate( 'FachInternKrz', afach, [loCaseInsensitive] );
      for j := C_Q1 to C_Q4 do
        if IstBelegt1( afach, j, j ) then
        begin
          w_std := FC0.FieldByname( Format( 'WS_%d', [ j ] ) ).AsInteger;
          anzahlQ := anzahlQ + w_std;
        end;
    end;
    anzahlQ := Schulstunden( anzahlQ );
    if anzahlQ < 22 then
    begin
      err_code := 'AGF3_SUMME';
      FehlerAusgeben( err_code, 'Im Aufgabenfeld III müssen mindestens 22 Sem.-WStd. in der Q-Phase belegt werden.' );
    end;
  end;


//FOLIE
//Ist D ODER ein Fach aus F1.2 (fortgeführte (!) Fremdsprache)
//ODER  M  ODER ein Fach aus F3.2 (Naturwissenschaft) erstes Leistungskursfach?
// Gibt es überhaupt 1. Abifach?
  LK1 := '';
  for i := 1 to AnzahlElemente( W_LK ) do
  begin
    afach := Einzelelement( W_LK, i );
    if IstAbifach( afach, [ 1 ] ) then
      ZuMengeHinzu( LK1, afach );
  end;
  if AnzahlElemente( LK1 ) <> 1 then
  begin
    err_code := 'LK1_10';
    FehlerAusgeben( err_code, 'Erstes Abiturfach nicht identifizierbar.' );
  end else
  begin
    bel := InMenge( LK1, W1_2 ) or InMenge( LK1, W3_1 ) or InMenge( LK1, W3_2 ) or InMenge( LK1, W1_1 );
    if not bel then
    begin
      err_code := 'LK1_11';
      FehlerAusgeben( err_code, 'Das erste Leistungskursfach muss Deutsch oder eine fortgeführte Fremdsprache oder Mathematik oder eine Naturwissenschaft sein.' );
    end;
  end;

//FOLIE
// Ist die Zahl der Abiturfächer 4 und decken diese alle Aufgabenfelder ab?
// Zusatz: Prüfen, ob 1,2,3 und 4
  abi_1_4 := '';
  for i := 1 to AnzahlElemente( W_AF ) do
  begin
    afach := EinzelElement( W_AF, i );
    FC0.Locate( 'FachInternKrz', afach, [loCaseInsensitive] );
    abi_1_4 := abi_1_4 + FC0.FieldByname( 'AbiturFach' ).AsString;
  end;
  bel := AnsiContainsText( abi_1_4, '1' ) and AnsiContainsText( abi_1_4, '2' ) and AnsiContainsText( abi_1_4, '3' ) and AnsiContainsText( abi_1_4, '4' );

// (AFI: Deutsch und Fremdsprachen;
// AF II: Gesellschaftswissenschaften und Religion;
// AF III: Mathematik und Naturwissenschaften; ohne AF: Kunst Musik etc., Sport)

  bel := bel and
         ( Schnittmenge( W_AF, W1 ) <> '' ) and
         ( Schnittmenge( W_AF, Vereinigungsmenge( W2, W4 ) ) <> '' ) and
         ( Schnittmenge( W_AF, W3 ) <> '' );
  if not bel then
  begin
    err_code := 'ABIF_10';
    FehlerAusgeben( err_code, 'Die Abiturfächer müssen alle drei Aufgabenfelder abdecken. Insgesamt sind vier Abiturfächer zu belegen.' );
  end;

//FOLIE
//Sind unter den vier Abiturfächern zwei der Fächer Deutsch, Fremdsprache oder Mathematik?
  M_A := VereinigungsMenge( W1_1, W3_1 );// Deutsch + Mathe
  M_A := VereinigungsMenge( M_A, W1_2 );// Deutsch + + Mathe + FS SekI
  M_A := VereinigungsMenge( M_A, W1_3 );// Deutsch + + Mathe + FS SekI + FS SekII
// W_AF: Die Abiturfächer
  M_A := SchnittMenge( M_A, W_AF );

  bel := ( AnzahlElemente( M_A ) >= 2 ) and ( StatKrzInMenge( 'D', M_A ) or StatKrzInMenge( 'M', M_A ) );
  if not bel then
  begin
    err_code := 'ABIF_11';
    FehlerAusgeben( err_code, 'Unter den vier Abiturfächern müssen zwei der Fächer Deutsch, Mathematik oder Fremdsprache sein.' );
  end;

//FOLIE
//Wurden gleichzeitig Religionslehre und Sport als Abiturfächer gewählt?
  M1 := ''; // speichert die Fachgruppen
  for i := 1 to AnzahlElemente( W_AF ) do
  begin
    afach := EinzelElement( W_AF, i );
    statkrz := FachGruppe( afach ); // nimmt hier die Fachgruppe auf
    if ( statkrz = 'RE' ) or ( statkrz = 'SP' ) then
      ZuMengeHinzu( M1, statkrz );
  end;
  if InMenge( 'RE', M1 ) and InMenge( 'SP', M1 ) then
  begin
    err_code := 'ABIF_12';
    FehlerAusgeben( err_code, 'Religionslehre und Sport dürfen nicht gleichzeitig Abiturfächer sein.' );
  end;

//FOLIE
//Ist Sport 1. oder 3. oder 4. Abiturfach?
  for i := 1 to AnzahlElemente( W_AF ) do
  begin
    afach := EinzelElement( W_AF, i );
    statkrz := StatistikKuerzel( afach );
    if ( statkrz = 'SP' ) and IstAbifach( afach, [ 1, 3, 4 ] ) then
    begin
      err_code := 'ABIF_13';
      FehlerAusgeben( err_code, 'Sport kann nur als 2. Abiturfach gewählt werden.' );
      break;
    end;
  end;

//FOLIE
//Prüfe für jedes Semester aus Q1.1 bis Q2.2: Wurden mehr als zwei LKs belegt?
// Wurde schon vorher erledigt, LK_11

//FOLIE 54
//Wurde das 3. Abiturfach in Q2.2 schriftlich belegt?
  for i := 1 to AnzahlElemente( W_AF ) do
  begin
    afach := EinzelElement( W_AF, i );
    if IstAbifach( afach, [ 3 ] ) then
    begin
      if not IstSchriftlich( afach, C_Q4, C_Q4 ) then
      begin
        err_code := 'ABIF_14';
        FehlerAusgeben( err_code, 'In Q2.2 muss das 3.Abiturfach schriftlich belegt sein.' );
      end;
      break;
    end;
  end;

end;

function TAbiturBelegPruefer.WBK_AffinesFachBelegt( const statkrz: string; const hj: integer = 0 ): boolean;
// Für VWL und Soziologie (in Q-Phase) sind Geschichte/Sozialwissenschaften aus E-Phase affin
// Für Psychologie (in Q-Phase) ist Erziehungswissenschaft aus E-Phase affin
// EF(GW)  => Q(GW,SL,VW) ;		affine Fächer zu GW bzw. PA
// EF(PA)  => Q(PA,PS)}
var
  af: string;
begin
  Result := false;
  if ( statkrz = 'SL' ) or ( statkrz = 'VW' ) then
    af := 'GW'
  else if statkrz = 'PS' then
    af := 'PA'
  else
    af := '';
  if af = '' then
    exit;
  with FC0 do
  begin
    First;
    while not Eof do
    begin
      if AnsiSameText( FieldByName( 'FachStatKrz' ).AsString, af ) then
      begin
        if hj = 0 then
          Result := ( Trim( FieldByName( 'KA_1' ).AsString ) <> '' ) or ( Trim( FieldByName( 'KA_2' ).AsString ) <> '' )
        else
          Result := Trim( FieldByName( Format( 'KA_%d', [ hj ] ) ).AsString ) <> '';
        if Result then
          exit;
      end;
      Next;
    end;
  end;
end;

procedure TAbiturBelegPruefer.WesensgleicheFaecherErsetzen;
var
  slF, slHF, slEF: TStringList;
  currNr: integer;
  fach_i, fach_j, HF, EF: string;
  currStatKrz: string;
  currSprache: string;
  i, j: integer;
  ka: array[ C_Q1..C_Q4 ] of string;
  ma: array[ C_Q1..C_Q4 ] of string;
  ws: array[ C_Q1..C_Q4 ] of integer;
  pu: array[ C_Q1..C_Q4 ] of integer;
begin
  if FSchulform = 'BK' then
    exit;
  slHF := TStringList.Create;
  slEF := TStringList.Create;
  slF := TStringList.Create;

  try

    FC0.First;
    while not FC0.Eof do
    begin
      slF.Add( FC0.FieldByName( 'FachInternKrz' ).AsString );
      FC0.Next;
    end;

    for i := 0 to slF.Count - 2 do
    begin
      fach_i := slF[i];
      FC0.Locate( 'FachInternKrz', fach_i , [] );
      currSprache := FC0.FieldByName( 'Unterrichtssprache' ).AsString;
      currStatKrz := FC0.FieldByname( 'FachStatKrz' ).AsString;
      for j := i + 1 to slF.Count - 1 do
      begin
        fach_j := slF[j];
        FC0.Locate( 'FachInternKrz', fach_j , [] );
        if FC0.FieldByname( 'FachStatKrz' ).AsString = currStatKrz then
        begin // Wesensgleich
          if currSprache = 'D' then
          begin
            slHF.Add( fach_i );
            slEF.Add( fach_j );
          end else
          begin
            slHF.Add( fach_j );
            slEF.Add( fach_i );
          end;
        end;
      end;
    end;
    for i := 0 to slHF.Count - 1 do
    begin
      HF := slHF[i];
      EF := slEF[i];
      FC0.Locate( 'FachInternKrz', EF, [] ); // zu ersetzendes Fach suchen und Daten sichern
      for j := C_Q1 to C_Q4 do
      begin
        pu[j] := FC0.FieldByName( Format( 'PU_%d', [ j ] ) ).AsInteger;
        ws[j] := FC0.FieldByName( Format( 'WS_%d', [ j ] ) ).AsInteger;
        ka[j] := FC0.FieldByName( Format( 'KA_%d', [ j ] ) ).AsString;
        ma[j] := FC0.FieldByName( Format( 'MA_%d', [ j ] ) ).AsString;
      end;
      FC0.Delete; // Fach löschen
      FC0.Locate( 'FachInternKrz', HF, [] ); // "Hauptfach" suchen
      FC0.Edit;
      for j := C_Q1 to C_Q4 do
      begin
        if ( FC0.FieldByName( Format( 'KA_%d', [ j ] ) ).AsString = '' ) and ( ka[j] <> '' ) then
        begin
          FC0.FieldByName( Format( 'KA_%d', [ j ] ) ).AsString := ka[j];
          FC0.FieldByName( Format( 'MA_%d', [ j ] ) ).AsString := ma[j];
          FC0.FieldByName( Format( 'PU_%d', [ j ] ) ).AsInteger := pu[j];
          FC0.FieldByName( Format( 'WS_%d', [ j ] ) ).AsInteger := ws[j];
        end;
      end;
      FC0.Post;
    end;
  finally
    FreeAndNil( slEF );
    FreeAndNil( slHF );
    FreeAndNil( slF );
  end;
end;

procedure TAbiturBelegPruefer.KurseMarkieren;
var
  markierung: string;
  node_id, rootnode_id, fach_id: integer;

  procedure FachMarkieren;
  var
    i: integer;
    fach, statkrz: string;
    aktmark: string;
  begin
    fach := FachKuerzel_aus_ID( fach_id );
    statkrz := StatistikKuerzel( fach );
    if statkrz = 'PX' then
      statkrz := 'PX';
// Hier alle Fächer mit gleichem Stat-Krz abarbeiten
    with FC0 do
    begin
      Locate( 'FachInternKrz', fach, [] );
      if statkrz = 'PX' then
      begin
        Edit;
        for i := C_Q1 to C_Q4 do
          FieldByname( Format( 'MA_%d', [i] ) ).AsString := '-';
        Post;
      end;

      for i := 1 to length( markierung ) do
      begin
        aktmark := FieldByname( Format( 'MA_%d', [i+2] ) ).AsString;
        if ( markierung[i] = '+' ) and ( aktmark <> '' ) then
        begin
          Edit;
          FieldByname( Format( 'MA_%d', [i+2] ) ).AsString := '+';
          Post;
        end;
      end;
    end;
  end;

  procedure ProjektkursBelegungPruefen;
  var
    i: integer;
    fach: string;
    bel: boolean;
  begin
    bel := false;
    for i := 1 to AnzahlElemente( W_PF ) do
    begin
      fach := EinzelElement( W_PF, i );
      bel := IstBelegt( fach, C_Q1, C_Q2 ) or IstBelegt( fach, C_Q2, C_Q3 ) or Istbelegt( fach, C_Q3, C_Q4 );
      if bel then
        break;
    end;
    if ( FSchueler.BLL_Art = 'P' ) then
    begin
      HatProjektkurs := false;
      ProjBLL := true;
    end else
    begin
      HatProjektkurs := bel;
      ProjBLL := false;
    end;
  end;

var
  i, ires: integer;
  fach, statkrz: string;


begin
  FAbbruch := false;
  FMeldungen.Clear;
  FAbiErgebnisVerwalter.Pruefungsordnung := FPO_Krz;
  if ( FSchulform = 'BK' ) then
  begin
    KurseMarkieren_BK;
    exit;
  end;

  WesensgleicheFaecherErsetzen;

// Defaults setzen
  AbiSP := false;
  AbiRE := false;
  AbiMNW := false;
  AbiNW := false;
  AbiM := false;
  AbiPL := false;
  AbiGW := false;
  AbiSW := false;
  AbiGE := false;
  AbiMuKu := false;
  AbiNFS := false;
  AbiFS := false;
//  AbiReErsatz := false;
  AbiD := false;
  ProjZwang := false;
  ProjBLL := false;
  Nur_PL_AF := false;

  if ( FSchulform = 'WB' ) then
  begin
    HatProjektkurs := W_PF <> '';
    if ( FSchueler.BLL_Art = 'P' ) then
    begin
      HatProjektkurs := false;
      ProjBLL := true;
    end;
  end else
  begin
    ProjektkursBelegungPruefen;
  end;
  MURest := 5;
  VPIP := 2;
  VILI := 2;
  AnzAbiFS := 0;

  slZwangsFaecher.Clear;

// 5. Schleife über alle Abiturfächer

  for i := 1 to AnzahlElemente( W_AF ) do
  begin
    fach := EinzelElement( W_AF, i );
    statkrz := StatistikKuerzel( fach );

    if InMenge( fach, W1_1 ) then
    begin
      AbiD := true;
      continue;
    end;
    if InMenge( fach, Vereinigungsmenge( W1_2, W1_3 ) ) then
      inc( AnzAbiFS );

    if InMenge( fach, W1_3 ) then
    begin
      AbiNFS := true;
      continue;
    end;

    if InMenge( fach, W1_4 ) then
    begin
      AbiMuKu := true;
// Ist das Fach Musik LK?
      if statkrz = 'MU' then
      begin
        if InMenge( fach, W_LK ) then
        begin
          MURest := 0;
          VPIP := 0;
        end else if InMenge( fach, W_AF ) then // d.g. 3. oder 4. Abifach
        begin
          MURest := 2;
        end;
      end;
      continue;
    end;

// GEschichte
    if InMenge( fach, W2_1 ) then
    begin
      AbiGE := true;
      AbiGW := true;
      continue;
    end;

// Sozialwissenschaften
    if InMenge( fach, W2_2 ) then
    begin
      AbiSW := true;
      AbiGW := true;
      continue;
    end;

// Gesellschaftswissenschaften
    if InMenge( fach, W2_3 ) then
    begin
      AbiGW := true;
      continue;
    end;

// Philosophie
    if InMenge( fach, W2_4 ) then
    begin
      AbiPL := true;
      continue;
    end;

    if InMenge( fach, W3_1 ) then
    begin
      AbiM := true;
      continue;
    end;

    if InMenge( fach, W3_2 ) then
    begin
      AbiNW := true;
      continue;
    end;
    if InMenge( fach, W3_3 ) then
    begin
      AbiMNW := true;
      continue;
    end;
    if InMenge( fach, W4 ) then
    begin
      AbiRE := true;
      continue;
    end;

    if InMenge( fach, W5 ) then
    begin
      AbiSP := true;
      continue;
    end;

  end;

  if ( FSchulform = 'GY' ) or ( FSchulform = 'GE' ) or ( FSchulform = '' ) then
    KurseMarkieren_GY_GE
  else if FSchulform = 'WB' then
    KurseMarkieren_WBK;

// Jetzt die Markierunge holen, dazu
  ires := FAbiErgebnisVerwalter.BestesErgebnisSuchen( rootnode_id, fach_id, markierung );
  if ires <> 0 then
  begin // Bei Erfolg Fächer markieren
    while fach_id > 0 do
    begin
      FachMarkieren;
      node_id := rootnode_id;
      FAbiErgebnisVerwalter.NaechstHoehereEbene( node_id, rootnode_id, fach_id, markierung );
{      if rootnode_id >= 0 then
        FachMarkieren;
      node_id := rootnode_id;}
    end;
  end;

//  if ( FSchulform = 'WB' ) and ( ires = -1 ) then
//    ires := 0;

  case ires of
  0 :
    begin
      FAbbruch := true;
      FMeldungen.Add( 'Keine Abiturzulassung! Falsche Belegung oder zu viele Defizite in Block I' );
    end;
  1 :
    begin
      FAbbruch := false;
    end;
  -1 :
    begin
      FAbbruch := false;
      FMeldungen.Add( 'Keine Abiturzulassung! Falsche Belegung oder zu viele Defizite in Block I' );
    end;
  end;


  FAbiErgebnisVerwalter.Reset;

end;

procedure TAbiturBelegPruefer.MarkierungenPruefen;
begin
  FAbbruch := false;
  FMeldungen.Clear;
  FAbiErgebnisVerwalter.Pruefungsordnung := FPO_Krz;
  WesensgleicheFaecherErsetzen;
  GruppenBilden;
  if ( FSchulform = 'GY' ) or ( FSchulform = 'GE' ) or ( FSchulform = '' ) then
    MarkierungenPruefen_GY_GE
  else if ( FSchulform = 'BK' ) then
    MarkierungenPruefen_BK;

//  if not FAbbruch then
//    FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [ aeZugelassen ]
//  else
  if FAbbruch then
    FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [ aeNichtZugelassen ];

  FAbiErgebnisVerwalter.Reset;

end;

procedure TAbiturBelegPruefer.AbschnitteMarkieren( const fach: string; const istart, iend: integer; const mark: char );
var
  i: integer;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  FC0.Edit;
  if istart > 0 then
  begin // normaler Abschnitt und Fach
    for i := istart to iend do
    begin
      if FFuerAbitur then
      begin
        if PunktzahlNum( FC0.FieldByName( Format( 'PU_%d', [ i ] ) ).AsString ) > 0 then
          FC0.FieldByName( Format( 'MA_%d', [ i ] ) ).AsString := mark
        else
          FC0.FieldByName( Format( 'MA_%d', [ i ] ) ).AsString := '-';
      end else
        FC0.FieldByName( Format( 'MA_%d', [ i ] ) ).AsString := mark; // Bescheuerte Sonderrregelung für BK, damit die ZAA-Formulare gedruckt werden können
    end;
  end else
  begin // Facharbeit
    FC0.FieldByName( 'MA_FA' ).AsString := mark;
  end;
  FC0.Post;
end;

procedure TAbiturBelegPruefer.AbschnitteMarkieren( const fach_id: integer; const istart, iend: integer; const mark: char );
var
  i: integer;
begin
  if istart > 0 then
  begin // normaler Abschnitt und Fach
    if FC0.FieldByName( 'Fach_ID' ).AsInteger <> fach_id then
      FC0.Locate( 'Fach_ID', fach_id, [] );
    FC0.Edit;
    for i := istart to iend do
      FC0.FieldByName( Format( 'MA_%d', [ i ] ) ).AsString := mark;
    FC0.Post;
  end else
  begin // Facharbeit
    if FC0.FieldByName( 'Fach_ID' ).AsInteger <> fach_id then
      FC0.Locate( 'Fach_ID', fach_id, [] );
    FC0.Edit;
    FC0.FieldByName( 'MA_FA' ).AsString := mark;
    FC0.Post;
  end;
end;

procedure TAbiturBelegPruefer.Markieren( const fach: string; const abschnitt: integer; const mark: char );
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  FC0.Edit;
  FC0.FieldByName( Format( 'MA_%d', [ abschnitt ] ) ).AsString := mark;
  FC0.Post;
end;

procedure TAbiturBelegPruefer.Markieren( const fach_id: integer; const abschnitt: integer; const mark: char );
begin
  if FC0.FieldByName( 'Fach_ID' ).AsInteger <> fach_id then
    FC0.Locate( 'Fach_ID', fach_id, [] );
  FC0.Edit;
  FC0.FieldByName( Format( 'MA_%d', [ abschnitt ] ) ).AsString := mark;
  FC0.Post;
end;


function TAbiturBelegPruefer.MarkierungenHolenStatKrz( const statkrz: string; var m3, m4, m5, m6: boolean ): boolean;
begin
  Result := true;
  if FC0.FieldByName( 'FachStatKrzOrig' ).AsString <> AnsiUppercase( statkrz ) then
    Result := FC0.Locate( 'FachStatKrzOrig', AnsiUpperCase( statkrz ), [] );
  if not Result then
    exit;
  m3 := FC0.FieldByName( 'MA_3' ).AsString = '+';
  m4 := FC0.FieldByName( 'MA_4' ).AsString = '+';
  m5 := FC0.FieldByName( 'MA_5' ).AsString = '+';
  m6 := FC0.FieldByName( 'MA_6' ).AsString = '+';
end;

function TAbiturBelegPruefer.MarkierungenHolenInternKrz( const internkrz: string; var m3, m4, m5, m6, m_fa: boolean ): boolean;
begin
  Result := true;
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> internkrz then
    Result := FC0.Locate( 'FachInternKrz', internkrz, [] );
  if not Result then
    exit;
  m3 := FC0.FieldByName( 'MA_3' ).AsString = '+';
  m4 := FC0.FieldByName( 'MA_4' ).AsString = '+';
  m5 := FC0.FieldByName( 'MA_5' ).AsString = '+';
  m6 := FC0.FieldByName( 'MA_6' ).AsString = '+';
  m_fa := FC0.FieldByName( 'MA_FA' ).AsString = '+';
end;


function TAbiturBelegPruefer.Punkte( const fach: string; abschnitt: integer ): integer;
begin
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  if FC0.FieldByName( Format( 'PU_%d', [ abschnitt ] ) ).AsString <> '' then
    try
      Result := FC0.FieldByName( Format( 'PU_%d', [ abschnitt ] ) ).AsInteger
    except
      Result := -1;
    end;
end;


function TAbiturBelegPruefer.Beste2QKurse( const fach: string; var punktsumme: integer; const kursart: string = ''  ): string;
var
  pkt, pkt1, pkt2: integer;
  ab1, ab2: integer;
  i: integer;
  ka, ka_akt: string;
  ka_ignore, go_on: boolean;
begin
  ka := '';
  if kursart <> '' then
  begin
    ka := copy( kursart, 2, 2 );
    ka_ignore := kursart[1] = '-';
  end;

  Result := '----';
  if FC0.FieldByName( 'FachInternKrz' ).AsString <> fach then
    FC0.Locate( 'FachInternKrz', fach, [loCaseInsensitive] );
  pkt1 := 0;
  pkt2 := 0;
  ab1 := 0;
  ab2 := 0;
  for i := C_Q4 downto C_Q1 do
  begin
    go_on := true;
    if ka <> '' then
    begin // falls eine Kursart eingetragen ist, prüfen, wie zu behandeln
      ka_akt := FC0.FieldByname( Format( 'KA_%d', [ i ] ) ).AsString; // die aktuelle Kursart des Faches
      if ka_akt = '' then
        go_on := false
      else if ka_ignore then
        go_on := ka_akt <> ka
      else
        go_on := ka_akt = ka;
    end;
    if not go_on then
      continue;
    pkt := FC0.FieldByname( Format( 'PU_%d', [ i ] ) ).AsInteger;
    if pkt > pkt1 then
    begin
      if ab1 > 0 then
      begin
        ab2 := ab1;
        pkt2 := pkt1;
      end;
      pkt1 := pkt;
      ab1 := i;
    end;
    if ( pkt > pkt2 ) and ( i <> ab1 ) then
    begin
      pkt2 := pkt;
      ab2 := i;
    end;
  end;
  if ( ab1 <> 0 ) and ( ab2 <> 0 ) then
  begin
    Result[ab1-2] := '+';
    Result[ab2-2] := '+';
    punktsumme := pkt1 + pkt2;
  end;
end;


function TAbiturBelegPruefer.NeuerKnoten( statkrz, markier_muster: string; const knoten_ebene, root_id: integer ): boolean;
var
  iroot, i, istart, itmp: integer;
begin
  Result := not FAbbruch;
  if not Result then
    exit;
// Wichtig: FC0 muss schon auf dem richtigen Datensatz stehen!!!!

  with FC0 do
    iroot := FAbiErgebnisVerwalter.NeuenKnotenErzeugen( statkrz,
                    MarkierBemerkungen[ knoten_ebene ],
                    knoten_ebene,
                    root_id,
                    FieldByname( 'Fach_ID' ).AsInteger,
                    FieldByName( 'PU_3' ).AsInteger,
                    FieldByName( 'PU_4' ).AsInteger,
                    FieldByName( 'PU_5' ).AsInteger,
                    FieldByName( 'PU_6' ).AsInteger,
                    markier_muster );

  if FAbiErgebnisVerwalter.Zeilen > C_MAX_LOOPS then
  begin
    FAbbruch := true;
    FMeldungen.Add( Format( 'Maximale Anzahl von Iterationen (%d) erreicht', [ C_MAX_LOOPS ] ) );
    Result := false;
    exit;
  end;

//  if not go_on then
//    exit;

{  case knoten_ebene of
  C_EBENE_NW_FS  : Knotenebene_2_GY_GE;
  C_EBENE_MU_KU  : Knotenebene_3_GY_GE;
  C_EBENE_GE     : Knotenebene_4_GY_GE;
  C_EBENE_SW     : Knotenebene_5_GY_GE;
  C_EBENE_EINSPR : Knotenebene_6_GY_GE; // RE
//C_EBENE_RE   : Knotenebene_7_GY_GE; Beim RE-Knoten kein Aufruf der naächetn Ebene, da es im RE-Knoten mehrere Aufrufe geben kann, die aber nicht
// aber innerhalb des RE-Knoten bleiben müssen
  C_EBENE_GW     : Knotenebene_8_GY_GE;
  end;}
end;

function TAbiturBelegPruefer.SchriftlicheFaecher( const M: string; von_hj, bis_hj: integer ): string;
var
  i: integer;
  fach: string;
begin
  Result := '';
  for i := 1 to AnzahlElemente( M ) do
  begin
    fach := EinzelElement( M, i );
    if IstSchriftlich( fach, von_hj, bis_hj ) then
      ZuMengeHinzu( Result, fach );
  end;
end;

procedure TAbiturBelegPruefer.Knotenebene_1_GY_GE;
// FS/ NW -Belegung
var
  anzFS, anzNW, cntNode: integer;

{  function FS_Sprachen( m: string ): string;
  var
    i: integer;
    fach, statkrz: string;
  begin
    Result := '';
    if m = '' then
      exit;

    for i := 1 to AnzahlElemente( m ) do
    begin
      fach := EinzelElement( m, i );
      statkrz := StatistikKuerzel( fach );
      ZuMengeHinzu( Result, copy( statkrz, 1, 1 ) );
    end;

  end;

  function FaecherAusW6( const sprachen: string ): string;
  var
    i: integer;
    fach, uspr: string;
  begin
    Result := '';
    for i := 1 to AnzahlElemente( W6 ) do
    begin
      fach := EinzelElement( W6, i );
      uspr := Unterrichtssprache( fach );
      if ( uspr <> 'D' ) and not InMenge( uspr, sprachen ) then
        ZuMengeHinzu( Result, fach );
    end;
  end;}

// NEU: Ersetzt die bisherigen Fälle 9 a, b und c
  procedure Fall_9;
  var
    i, j, k: integer;
    M0_, M1_, M2_, MS_, Mtmp_: string;
    markier_muster0, markier_muster1, markier_muster2: string;
    fach0, fach1, fach2: string;
    statkrz, fs_des_faches, w6_andere_fs, w12_w13_w6: string;
    f0_id, f1_id, f2_id: integer;
    cntNode, root_id0, root_id1, root_id2: integer;
  begin

    w12_w13_w6 := Vereinigungsmenge( W1_2, W1_3 );
    w12_w13_w6 := Vereinigungsmenge( w12_w13_w6, W6 );

// Fall a) markiere vier Kurse Q1.1 bis Q2.2 eines durchgehend belegten Faches (1) aus W1_2 U W1_3
    M0_ := Vereinigungsmenge( W1_2, W1_3 );
//    M0_ := Differenzmenge( M0_, W_AF );

    if M0_ = '' then
    begin
      Knotenebene_2_GY_GE;
      exit;
    end;

    root_id0 := FAbiErgebnisVerwalter.WurzelKnoten;
    for i := 1 to AnzahlElemente( M0_ ) do
    begin // 1.Schleife
      MarkierBemerkungen[1] := 'NW und FS';
      FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1 ); // wieder auf Anfang
      fach0 := EinzelElement( M0_, i );
      fs_des_faches := Fremdsprachen_Suffix_Ermitteln( fach0 );
      f0_id := Fach_ID_Von( fach0 );
      statkrz := StatistikKuerzel( fach0 );
      markier_muster0 := '++++';
      if IstBelegtPunkte( fach0, C_Q1, C_Q4, markier_muster0 ) then
      begin // durchgehend belegtes Fach
        MarkierBemerkungen[1] := 'NW und FS: Fall 9a';
        if not NeuerKnoten( statkrz, markier_muster0, 1, root_id0 ) then
          exit;
        inc( cntNode );
      end else
        continue;

// Fall b) markiere vier Kurse Q1.1 bis Q2.2 eines durchgehend belegten Faches(2) aus W3_2
      M1_ := W3_2;
  //    M1_ := Differenzmenge( M1_, W_AF );

      if M1_ = '' then
      begin
        Knotenebene_2_GY_GE;
        exit;
      end;

      root_id1 := FAbiErgebnisVerwalter.WurzelKnoten;
      for j := 1 to AnzahlElemente( M1_ ) do
      begin // 2. Schleife
        FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0 );
        fach1 := EinzelElement( M1_, j );
        f1_id := Fach_ID_Von( fach1 );
        statkrz := StatistikKuerzel( fach1 );
        markier_muster1 := '++++';
        if IstBelegtPunkte( fach1, C_Q1, C_Q4, markier_muster1 ) then
        begin
          MarkierBemerkungen[1] := 'NW und FS: Fall 9b';
          if not NeuerKnoten( statkrz, markier_muster1, 1, root_id1 ) then
            exit;
          inc( cntNode );
        end else
          continue;

// für Fall c)
//c)  KNOTEN: markiere zwei Kurse Q2.1 bis Q2.2 eines durchgehend belegten (bzw. falls Fach aus W1.2, W1.3 und W6, dann durchgehend schriftlich belegten) Faches aus
//a.	NWSP = True & SprachenSP = True :W1.2 U W1.3 U W6 falls andere Sprache U W3.2 U W3.3 / Fach(1) /Fach(2) aus a) und b)
//b.	NWSP = True : W3.2 U W3.3 /Fach(2) aus b)
//c.	SprachenSP = True: W1.2 U W1.3 U W6 falls andere Sprache / Fach(1) aus a) und b)

        if NW_SP and Sprachen_SP then
        begin
          MarkierBemerkungen[1] := 'NW und FS: Fall 9c a';
          M2_ := Vereinigungsmenge( W1_2, W1_3 );
          w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches );
          M2_ := Vereinigungsmenge( M2_, w6_andere_fs );
          M2_ := Vereinigungsmenge( M2_, W3_2 );
          M2_ := Vereinigungsmenge( M2_, W3_3 );
//          M2_ := Differenzmenge( M2_, W_AF );
          M2_ := Differenzmenge( M2_, fach0 );
          M2_ := Differenzmenge( M2_, fach1 );
        end else if NW_SP then
        begin
          MarkierBemerkungen[1] := 'NW und FS: Fall 9c b';
          M2_ := Vereinigungsmenge( W3_2, W3_3 );
//          M2_ := Differenzmenge( M2_, W_AF );
          M2_ := Differenzmenge( M2_, fach1 );
        end else if Sprachen_SP then
        begin
          MarkierBemerkungen[1] := 'NW und FS: Fall 9c c';
          M2_ := Vereinigungsmenge( W1_2, W1_3 );
          w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches );
          M2_ := Vereinigungsmenge( M2_, w6_andere_fs );
//          M2_ := Differenzmenge( M2_, W_AF );
          M2_ := Differenzmenge( M2_, fach0 );
          M2_ := Differenzmenge( M2_, fach1 );
        end;

//falls Fach aus W1.2, W1.3 und W6, dann durchgehend schriftlich belegten
        MS_ := SchriftlicheFaecher( M2_, C_Q1, C_Q3 );
        Mtmp_ := '';
        for k := 1 to AnzahlElemente( M2_ ) do
        begin
          fach2 := EinzelElement( M2_, k );
          if not InMenge( fach2, w12_w13_w6 ) then
            ZuMengeHinzu( Mtmp_, fach2 )
          else if InMenge( fach2, MS_ ) then
            ZuMengeHinzu( Mtmp_, fach2 );
        end;

        M2_ := Mtmp_;

// Alte Version
{        MS_ := SchriftlicheFaecher( M2_, C_Q1, C_Q3 );
        for k := 1 to AnzahlElemente( M2_ ) do
        begin
          fach2 := EinzelElement( M2_, k );
          if InMenge( fach2, w12_w13_w6 ) and not InMenge( fach2, MS_ ) then
            AusMengeLoeschen( M2_, fach2 );
        end;}

        if M2_ = '' then
        begin
          Knotenebene_2_GY_GE; // ????
          exit;
        end;

        root_id2 := FAbiErgebnisVerwalter.WurzelKnoten;
        for k := 1 to AnzahlElemente( M2_ ) do
        begin // 3. Schleife
          FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0, f1_id, markier_muster1 );
          fach2 := EinzelElement( M2_, k );
          f2_id := Fach_ID_Von( fach2 );
          statkrz := StatistikKuerzel( fach2 );
          markier_muster2 := '--++';
          if IstBelegtPunkte( fach2, C_Q1, C_Q4, markier_muster2 ) then
          begin
            if not NeuerKnoten( statkrz, markier_muster2, 1, root_id2 ) then
              exit;
            inc( cntNode );
            Knotenebene_2_GY_GE; // ????
          end;
        end;
      end;  // 2.Schleife
    end; // 1. Schleife
  end;

  procedure Fall_9a;
  var
    M0_, M1_, M2_, MS_, w12_w13_w6: string;
    root_id0, root_id1, root_id2: integer;
    f0_id, f1_id, f2_id, i, j, k: integer;
    fach0, statkrz, fach1, fach2: string;
    markier_muster0, markier_muster1, markier_muster2: string;
    w6_andere_fs, fs_des_faches: string;
  begin
// Fallunterscheidungen

    w12_w13_w6 := Vereinigungsmenge( W1_2, W1_3 );
    w12_w13_w6 := Vereinigungsmenge( w12_w13_w6, W6 );

    if AnzAbiFS = 2 then    // 9a i
    begin // markiere vier Kurse Q1.1 bis Q2.2 eines durchgehend belegten Faches aus W3_2 U W3_3 \ AF
      M0_ := W3_2;      // NW-Fächer
      M0_ := Differenzmenge( M0_, W_AF ); // ohne Abifächer

      if M0_ = '' then
      begin
        Knotenebene_2_GY_GE;
        exit;
      end;

      root_id0 := FAbiErgebnisVerwalter.WurzelKnoten;
      for i := 1 to AnzahlElemente( M0_ ) do
      begin
        MarkierBemerkungen[1] := 'NW und FS: Fall 9a i';
        FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1 ); // alles wiederherstellen
        fach0 := EinzelElement( M0_, i );
        f0_id := Fach_ID_Von( fach0 );
        statkrz := StatistikKuerzel( fach0 );
        markier_muster0 := '++++';
        if IstBelegtPunkte( fach0, C_Q1, C_Q4, markier_muster0 ) then
        begin
          if not NeuerKnoten( statkrz, markier_muster0, 1, root_id0 ) then
            exit;
          inc( cntNode );
          Knotenebene_2_GY_GE;
        end;
      end;

    end else if ( AnzAbiFS = 1 ) and AbiMNW then // 9a ii
    begin // markiere vier Kurse Q1.1 bis Q2.2 eines durchgehend belegten Faches aus W3_2 \ AF

      M0_ := Differenzmenge( W3_2, W_AF ); // klass. NW ohne Abifächer

      if M0_ = '' then
      begin
        Knotenebene_2_GY_GE;
        exit;
      end;

      root_id0 := FAbiErgebnisVerwalter.WurzelKnoten;
      for i := 1 to AnzahlElemente( M0_ ) do
      begin
        MarkierBemerkungen[1] := 'NW und FS: Fall 9a ii';
        FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1 ); // alles wiederherstellen
        fach0 := EinzelElement( M0_, i );
        f0_id := Fach_ID_Von( fach0 );
        statkrz := StatistikKuerzel( fach0 );
        markier_muster0 := '++++';
        if IstBelegtPunkte( fach0, C_Q1, C_Q4, markier_muster0 ) then
        begin
          if not NeuerKnoten( statkrz, markier_muster0, 1, root_id0 ) then
            exit;
            inc( cntNode );
          Knotenebene_2_GY_GE;
        end;
      end;

    end else if ( AnzAbiFS = 1 ) and AbiNW then // 9a iii
    begin //a)	KNOTEN: markiere zwei Kurse Q2.1 bis Q2.2 eines durchgehend belegten Faches aus nachfolgenden Fällen

// merk dir die Sprache von AbiFS
      M0_ := Vereinigungsmenge( W1_2, W1_3 );
      M0_ := Differenzmenge( M0_, W_AF ); // das sind die FS im Abi
      fs_des_faches := Fremdsprachen_Suffix_Ermitteln( M0_ );

      if NW_SP and Sprachen_SP then
      begin
//a.	NWSP = True & SprachenSP = True :W1.2 U W1.3 U W3.2 U W3.3 / AF
        M0_ := Vereinigungsmenge( W1_2, W1_3 );
        M0_ := Vereinigungsmenge( M0_, W3_2 );
        M0_ := Vereinigungsmenge( M0_, W3_3 );
// U W6 falls andere Sprache
        w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches );
        M0_ := Vereinigungsmenge( M0_, w6_andere_fs );
        M0_ := Differenzmenge( M0_, W_AF );
      end else if NW_SP then
      begin
//b.	NWSP = True : W3.2 U W3.3 / AF
        M0_ := Vereinigungsmenge( W3_2, W3_3 );
        M0_ := Differenzmenge( M0_, W_AF );
      end else if Sprachen_SP then
      begin
//c.	SprachenSP = True: W1.2 U W1.3 / AF
        M0_ := Vereinigungsmenge( W1_2, W1_3 );
        w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches );
        M0_ := Vereinigungsmenge( M0_, w6_andere_fs );
        M0_ := Differenzmenge( M0_, W_AF );
      end;

// hier NEU (oder alt?) falls Fach in W1.2 U W1.3 U W6 dann muss es durchgehend scgriftlich sein
      MS_ := SchriftlicheFaecher( M0_, C_Q1, C_Q3 );
      for i := 1 to AnzahlElemente( M0_ ) do
      begin
        fach0 := EinzelElement( M0_, i );
        if InMenge( fach0, w12_w13_w6 ) and not InMenge( fach0, MS_ ) then
          AusMengeLoeschen( M0_, fach0 );
      end;

      if M0_ = '' then
      begin
        Knotenebene_2_GY_GE;
        exit;
      end;

      root_id0 := FAbiErgebnisVerwalter.WurzelKnoten;
      for i := 1 to AnzahlElemente( M0_ ) do
      begin
        MarkierBemerkungen[1] := 'NW und FS: Fall 9a iii';
        FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1 );  // Nach Abschluss alles wiederherstellellen
        fach0 := EinzelElement( M0_, i );
        f0_id := Fach_ID_Von( fach0 );
        statkrz := StatistikKuerzel( fach0 );
        markier_muster0 := '--++';
        if IstBelegtPunkte( fach0, C_Q1, C_Q4, markier_muster0 ) then
        begin
          if not NeuerKnoten( statkrz, markier_muster0, 1, root_id0 ) then
            exit;
          inc( cntNode );
          Knotenebene_2_GY_GE;
        end;

      end;

    end else if AnzAbiFS = 1 then // 9a iv
    begin

// merk dir die Sprache von AbiFS
      M0_ := Vereinigungsmenge( W1_2, W1_3 );
      M0_ := Differenzmenge( M0_, W_AF );
      fs_des_faches := Fremdsprachen_Suffix_Ermitteln( M0_ );

// Fall a) markiere vier Kurse Q1.1 bis Q2.2 eines durchgehend belegten Faches (1) aus W3_2
      M0_ := Differenzmenge( W3_2, W_AF ); // klass. NW ohne Abifächer

      if M0_ = '' then
      begin
        Knotenebene_2_GY_GE;
        exit;
      end;

      root_id0 := FAbiErgebnisVerwalter.WurzelKnoten;
      for i := 1 to AnzahlElemente( M0_ ) do
      begin //
        MarkierBemerkungen[1] := 'NW und FS: Fall 9a iv a)';
        FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1 );
        fach0 := EinzelElement( M0_, i );
        f0_id := Fach_ID_Von( fach0 );
        statkrz := StatistikKuerzel( fach0 );
        markier_muster0 := '++++';
        if IstBelegtPunkte( fach0, C_Q1, C_Q4, markier_muster0 ) then
        begin
          if not NeuerKnoten( statkrz, markier_muster0, 1, root_id0 ) then
            exit;
          inc( cntNode );
          root_id1 := FAbiErgebnisVerwalter.WurzelKnoten;
        end else
          continue;

// für zweite Schleife
//b)	KNOTEN: markiere zwei Kurse Q2.1 bis Q2.2 eines durchgehend belegten Faches aus
//a.	NWSP = True & SprachenSP = True :W1.2 U W1.3 U W6 falls andere Sprache U W3.2 U W3.3 / AF / Fach(1) aus a) erledigt
//b.	NWSP = True : W3.2 U W3.3 / AF / Fach(1) aus a)
//c.	SprachenSP = True: W1.2 U W1.3 U W6 falls andere Sprache / AF

        if NW_SP and Sprachen_SP then
        begin
          M1_ := Vereinigungsmenge( W1_2, W1_3 );
          w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches );
          M1_ := Vereinigungsmenge( M1_, w6_andere_fs );
//          M1_ := Vereinigungsmenge( M1_, FaecherAusW6( fremdsprachen ) );
          M1_ := Vereinigungsmenge( M1_, W3_2 );
          M1_ := Vereinigungsmenge( M1_, W3_3 );
          M1_ := Differenzmenge( M1_, W_AF );
          M1_ := Differenzmenge( M1_, fach0 );
        end else if NW_SP then
        begin
          M1_ := Vereinigungsmenge( W3_2, W3_3 );
          M1_ := Differenzmenge( M1_, W_AF );
          M1_ := Differenzmenge( M1_, fach0 );
        end else if Sprachen_SP then
        begin
          M1_ := Vereinigungsmenge( W1_2, W1_3 );
          w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches );
          M1_ := Vereinigungsmenge( M1_, w6_andere_fs );
//          M1_ := Vereinigungsmenge( M1_, FaecherAusW6( fremdsprachen ) );
          M1_ := Differenzmenge( M1_, W_AF );
        end;

// hier NEU (oder alt?) falls Fach in W1.2 U W1.3 U W6 dann muss es durchgehend scgriftlich sein
        MS_ := SchriftlicheFaecher( M1_, C_Q1, C_Q3 );
        for j := 1 to AnzahlElemente( M1_ ) do
        begin
          fach1 := EinzelElement( M1_, j );
          if InMenge( fach1, w12_w13_w6 ) and not InMenge( fach1, MS_ ) then
            AusMengeLoeschen( M1_, fach1 );
        end;

        if M1_ = '' then
        begin
          Knotenebene_2_GY_GE;
          exit;
        end;
        for j := 1 to AnzahlElemente( M1_ ) do
        begin // innere Schleife
          MarkierBemerkungen[1] := 'NW und FS: Fall 9a iv b)';
          FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0 );
          fach1 := EinzelElement( M1_, j );
          f1_id := Fach_ID_Von( fach1 );
          statkrz := StatistikKuerzel( fach1 );
          markier_muster1 := '--++';
          if IstBelegtPunkte( fach1, C_Q1, C_Q4, markier_muster1 ) then
          begin
            if not NeuerKnoten( statkrz, markier_muster1, 1, root_id1 ) then
              exit;
            inc( cntNode );
            Knotenebene_2_GY_GE;
          end;
        end;
      end;

    end else if AbiMNW then  // 9a v
    begin

// Fall a) markiere vier Kurse Q1.1 bis Q2.2 eines durchgehend belegten Faches (1) aus W3_2
      M0_ := W3_2;

      if M0_ = '' then
      begin
        Knotenebene_2_GY_GE;
        exit;
      end;

      root_id0 := FAbiErgebnisVerwalter.WurzelKnoten;
      for i := 1 to AnzahlElemente( M0_ ) do
      begin // äußere Schleife
        MarkierBemerkungen[1] := 'NW und FS: Fall 9a v a)';
        FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1 );
        fach0 := EinzelElement( M0_, i );
        f0_id := Fach_ID_Von( fach0 );
        statkrz := StatistikKuerzel( fach0 );
        markier_muster0 := '++++';
        if IstBelegtPunkte( fach0, C_Q1, C_Q4, markier_muster0 ) then
        begin
           if not NeuerKnoten( statkrz, markier_muster0, 1, root_id0 ) then
            exit;
          inc( cntNode );
          root_id1 := FAbiErgebnisVerwalter.WurzelKnoten;
        end else
          continue;

        M1_ := Vereinigungsmenge( W1_2, W1_3 );
        if M1_ = '' then
        begin
          Knotenebene_2_GY_GE;
          exit;
        end;

// Fall b) markiere vier Kurse Q1.1 bis Q2.2 eines durchgehend belegten Faches(1) W1_2 U W1_3
        for j := 1 to AnzahlElemente( M1_ ) do
        begin  // innere Schleife
          MarkierBemerkungen[1] := 'NW und FS: Fall 9a v b)';
          FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0 );
          fach1 := EinzelElement( M1_, j );
          f1_id := Fach_ID_Von( fach1 );
          statkrz := StatistikKuerzel( fach1 );
          markier_muster1 := '--++';
          if IstBelegtPunkte( fach1, C_Q1, C_Q4, markier_muster1 ) then
          begin
            if not NeuerKnoten( statkrz, markier_muster1, 1, root_id1 ) then
              exit;
            inc( cntNode );
            Knotenebene_2_GY_GE;
          end;

        end;
      end;

    end else if AbiNW then // 9a vi
    begin

//a)	KNOTEN: markiere vier Kurse Q1.1 bis Q2.2 eines durchgehend belegten Faches(1) aus W1.2 U W1.3
      M0_ := Vereinigungsmenge( W1_2, W1_3 );

      if M0_ = '' then
      begin
        Knotenebene_2_GY_GE;
        exit;
      end;

      root_id0 := FAbiErgebnisVerwalter.WurzelKnoten;
      for i := 1 to AnzahlElemente( M0_ ) do
      begin //
        MarkierBemerkungen[1] := 'NW und FS: Fall 9a vi a)';
        FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1 );
        fach0 := EinzelElement( M0_, i );
        fs_des_faches := Fremdsprachen_Suffix_Ermitteln( fach0 );
        f0_id := Fach_ID_Von( fach0 );
        statkrz := StatistikKuerzel( fach0 );
        markier_muster0 := '++++';
        if IstBelegtPunkte( fach0, C_Q1, C_Q4, markier_muster0 ) then
        begin
          if not NeuerKnoten( statkrz, markier_muster0, 1, root_id0 ) then
            exit;
          inc( cntNode );
          root_id1 := FAbiErgebnisVerwalter.WurzelKnoten;
        end else
          continue;

//b)	KNOTEN: markiere zwei Kurse Q2.1 bis Q2.2 eines durchgehend belegten Faches aus
//a.	NWSP = True & SprachenSP = True :W1.2 U W1.3 U W6 falls andere Sprache U W3.2 U W3.3 / AF / Fach(1) aus a)
//b.	NWSP = True : W3.2 U W3.3 / AF
//c.	SprachenSP = True: W1.2 U W1.3 U W6 falls andere Sprache / AF/ Fach(1) aus a)

        if NW_SP and Sprachen_SP then
        begin
          M1_ := Vereinigungsmenge( W1_2, W1_3 );
          w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches );
          M1_ := Vereinigungsmenge( M1_, w6_andere_fs );
//          M1_ := Vereinigungsmenge( M1_, FaecherAusW6( fremdsprachen ) );
          M1_ := Vereinigungsmenge( M1_, W3_2 );
          M1_ := Vereinigungsmenge( M1_, W3_3 );
          M1_ := Differenzmenge( M1_, W_AF );
          M1_ := Differenzmenge( M1_, fach0 );
        end else if NW_SP then
        begin
          M1_ := Vereinigungsmenge( W3_2, W3_3 );
          M1_ := Differenzmenge( M1_, W_AF );
        end else if Sprachen_SP then
        begin
          M1_ := Vereinigungsmenge( W1_2, W1_3 );
          w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches );
          M1_ := Vereinigungsmenge( M1_, w6_andere_fs );
//          M1_ := Vereinigungsmenge( M1_, FaecherAusW6( fremdsprachen ) );
          M1_ := Differenzmenge( M1_, W_AF );
          M1_ := Differenzmenge( M1_, fach0 );
        end;

        MS_ := SchriftlicheFaecher( M1_, C_Q1, C_Q3 );
        for j := 1 to AnzahlElemente( M1_ ) do
        begin
          fach1 := EinzelElement( M1_, j );
          if InMenge( fach1, w12_w13_w6 ) and not InMenge( fach1, MS_ ) then
            AusMengeLoeschen( M1_, fach1 );
        end;

        if M1_ = '' then
        begin
          Knotenebene_2_GY_GE;
          exit;
        end;

        for j := 1 to AnzahlElemente( M1_ ) do
        begin
          MarkierBemerkungen[1] := 'NW und FS: Fall 9a vi b)';
          FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0 );
          fach1 := EinzelElement( M1_, j );
          f1_id := Fach_ID_Von( fach1 );
          statkrz := StatistikKuerzel( fach1 );
          markier_muster1 := '--++';
          if IstBelegtPunkte( fach1, C_Q1, C_Q4, markier_muster1 ) then
          begin
            if not NeuerKnoten( statkrz, markier_muster1, 1, root_id1 ) then
              exit;
            inc( cntNode );
            Knotenebene_2_GY_GE;
          end;
        end;
      end;

    end else
    begin // vii sonst

// Fall a) markiere vier Kurse Q1.1 bis Q2.2 eines durchgehend belegten Faches (1) aus W1_2 U W1_3
      M0_ := Vereinigungsmenge( W1_2, W1_3 );

      if M0_ = '' then
      begin
        Knotenebene_2_GY_GE;
        exit;
      end;

      root_id0 := FAbiErgebnisVerwalter.WurzelKnoten;
      for i := 1 to AnzahlElemente( M0_ ) do
      begin // 1.Schleife
        MarkierBemerkungen[1] := 'NW und FS: Fall 9a vii a)';
        FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1 ); // wieder auf Anfang
        fach0 := EinzelElement( M0_, i );
        fs_des_faches := Fremdsprachen_Suffix_Ermitteln( fach0 );
        f0_id := Fach_ID_Von( fach0 );
        statkrz := StatistikKuerzel( fach0 );
        markier_muster0 := '++++';
        if IstBelegtPunkte( fach0, C_Q1, C_Q4, markier_muster0 ) then
        begin // durchgehend belegtes Fach
          MarkierBemerkungen[1] := 'NW und FS: Fall 9a vii a';
          if not NeuerKnoten( statkrz, markier_muster0, 1, root_id0 ) then
            exit;
          inc( cntNode );
          root_id1 := FAbiErgebnisVerwalter.WurzelKnoten;
        end else
          continue;

// Fall b) markiere vier Kurse Q1.1 bis Q2.2 eines durchgehend belegten Faches(2) aus W3_2
        M1_ := W3_2;

        if M1_ = '' then
        begin
          Knotenebene_2_GY_GE;
          exit;
        end;

        for j := 1 to AnzahlElemente( M1_ ) do
        begin // 2. Schleife
          MarkierBemerkungen[1] := 'NW und FS: Fall 9a vii b)';
          FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0 );
          fach1 := EinzelElement( M1_, j );
          f1_id := Fach_ID_Von( fach1 );
          statkrz := StatistikKuerzel( fach1 );
          markier_muster1 := '++++';
          if IstBelegtPunkte( fach1, C_Q1, C_Q4, markier_muster1 ) then
          begin
            MarkierBemerkungen[1] := 'NW und FS: Fall 9a vii b)';
            if not NeuerKnoten( statkrz, markier_muster1, 1, root_id1 ) then
              exit;
            inc( cntNode );
            root_id2 := FAbiErgebnisVerwalter.WurzelKnoten;
          end else
            continue;

// für Fall c)
//c)	KNOTEN: markiere zwei Kurse Q2.1 bis Q2.2 eines durchgehend belegten Faches aus
//a.	NWSP = True & SprachenSP = True :W1.2 U W1.3 U W6 falls andere Sprache U W3.2 U W3.3 / AF / Fach(1) /Fach(2) aus a) und b)
//b.	NWSP = True : W3.2 U W3.3 / AF /Fach(2) aus b)
//c.	SprachenSP = True: W1.2 U W1.3 U W6 falls andere Sprache / AF / Fach(1) aus a) und b)

          if NW_SP and Sprachen_SP then
          begin
            M2_ := Vereinigungsmenge( W1_2, W1_3 );
            w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches );
            M2_ := Vereinigungsmenge( M2_, w6_andere_fs );
//            M2_ := Vereinigungsmenge( M2_, FaecherAusW6( fremdsprachen ) );
            M2_ := Vereinigungsmenge( M2_, W3_2 );
            M2_ := Vereinigungsmenge( M2_, W3_3 );
            M2_ := Differenzmenge( M2_, W_AF );
            M2_ := Differenzmenge( M2_, fach0 );
            M2_ := Differenzmenge( M2_, fach1 );
          end else if NW_SP then
          begin
            M2_ := Vereinigungsmenge( W3_2, W3_3 );
            M2_ := Vereinigungsmenge( M2_, W3_2 );
            M2_ := Differenzmenge( M2_, W_AF );
            M2_ := Differenzmenge( M2_, fach1 );
          end else if Sprachen_SP then
          begin
            M2_ := Vereinigungsmenge( W1_2, W1_3 );
            w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches );
            M2_ := Vereinigungsmenge( M2_, w6_andere_fs );
//            M2_ := Vereinigungsmenge( M2_, FaecherAusW6( fremdsprachen ) );
            M2_ := Differenzmenge( M2_, W_AF );
            M2_ := Differenzmenge( M2_, fach0 );
            M2_ := Differenzmenge( M2_, fach1 );
          end;

          MS_ := SchriftlicheFaecher( M2_, C_Q1, C_Q3 );
          for k := 1 to AnzahlElemente( M2_ ) do
          begin
            fach2 := EinzelElement( M2_, k );
            if InMenge( fach2, w12_w13_w6 ) and not InMenge( fach2, MS_ ) then
              AusMengeLoeschen( M2_, fach2 );
          end;

          if M2_ = '' then
          begin
            Knotenebene_2_GY_GE; // ????
            exit;
          end;

          for k := 1 to AnzahlElemente( M2_ ) do
          begin // 3. Schleife
            MarkierBemerkungen[1] := 'NW und FS: Fall 9a vii c)';
            FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0, f1_id, markier_muster1 );
            fach2 := EinzelElement( M2_, k );
            f2_id := Fach_ID_Von( fach2 );
            statkrz := StatistikKuerzel( fach2 );
            markier_muster2 := '--++';
            if IstBelegtPunkte( fach2, C_Q1, C_Q4, markier_muster2 ) then
            begin
              MarkierBemerkungen[1] := 'NW und FS: Fall 9a vii c';
              if not NeuerKnoten( statkrz, markier_muster2, 1, root_id2 ) then
                exit;
              inc( cntNode );
              Knotenebene_2_GY_GE; // ????
            end;
          end;
        end;  // 2.Schleife
      end; // 1. Schleife
    end;
  end;

  procedure Fall_9b;
  var
    M0_, M1_, M2_, fach0, fach1, fach2, statkrz: string;
    f0_id, f1_id, root_id0, root_id1, root_id2, i, j, k: integer;
    markier_muster0, markier_muster1, markier_muster2: string;
    schr1: boolean;
  begin
// markiere vier Kurse Q1.1 bis Q2.2 des durchgehend belegten Faches aus W1_2 U W1_3
// Wir erzeugen hier eine Pseudo-Schleife mit einem Durchgang
    M0_ := Vereinigungsmenge( W1_2, W1_3 );
    M0_ := EinzelElement( M0_, 1 );

    if M0_ = '' then
    begin
      Knotenebene_2_GY_GE;
      exit;
    end;

    for i := 1 to AnzahlElemente( M0_ ) do
    begin
      MarkierBemerkungen[1] := 'NW und FS: Fall 9b';
      FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1 );
      root_id0 := FAbiErgebnisVerwalter.WurzelKnoten;
      fach0 := EinzelElement( M0_, i );
      f0_id := Fach_ID_Von( fach0 );
      statkrz := StatistikKuerzel( fach0 );
      markier_muster0 := '++++';
      if IstBelegtPunkte( fach0, C_Q1, C_Q4, markier_muster0 ) then
      begin
        if not NeuerKnoten( statkrz, markier_muster0, 1, root_id0 ) then
          exit;
        inc( cntNode );
        root_id1 := FAbiErgebnisVerwalter.WurzelKnoten;
      end else
        continue;

      if AbiMNW then
      begin // 9b i
        M1_ := W3_2;
// markiere vier Kurse Q1.1 bis Q2.2 eines durchgehend belegten Faches aus W3_2
        if M1_ = '' then
        begin
          Knotenebene_2_GY_GE;
          exit;
        end;

        for j := 1 to AnzahlElemente( M1_ ) do
        begin
          MarkierBemerkungen[1] := 'NW und FS: Fall 9b i';
          FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0 );
          fach1 := EinzelElement( M1_, j );
          f1_id := Fach_ID_Von( fach1 );
          statkrz := StatistikKuerzel( fach1 );
          markier_muster1 := '++++';
          if IstBelegtPunkte( fach1, C_Q1, C_Q4, markier_muster1 ) then
          begin
            if not NeuerKnoten( statkrz, markier_muster1, 1, root_id1 ) then
              exit;
            inc( cntNode );
            Knotenebene_2_GY_GE; // ????
          end;

        end;

      end else if AbiNW then
      begin // ii
        M1_ := Vereinigungsmenge( W3_2, W3_3 );
        M1_ := Differenzmenge( M1_, W_AF );
// markiere zwei Kurse Q2.1 bis Q2.2 eines durchgehend belegten Faches aus W3_2 U W3_2 \ AF
        if M1_ = '' then
        begin
          Knotenebene_2_GY_GE;
          exit;
        end;

        for j := 1 to AnzahlElemente( M1_ ) do
        begin
          MarkierBemerkungen[1] := 'NW und FS: Fall 9b ii';
          FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0 );
          fach1 := EinzelElement( M1_, j );
          f1_id := Fach_ID_Von( fach1 );
          statkrz := StatistikKuerzel( fach1 );
          markier_muster1 := '--++';
          if IstBelegtPunkte( fach1, C_Q1, C_Q4, markier_muster1 ) then
          begin
            if not NeuerKnoten( statkrz, markier_muster1, 1, root_id1 ) then
              exit;
            inc( cntNode );
            Knotenebene_2_GY_GE; // ????
          end;
        end;

      end else
      begin // iii sonst

// markiere vier Kurse Q1.1 bis Q2.2 eines durchgehend belegten Faches aus W3_2
// Die Fächer aus W3.2, W3.3 in 9a. iv. a) und b) müssen auf Schriftlichkeit überprüft werden (also entweder ist das Fach in a) oder das Fach in b) schriftlich. Natürlich gehen auch beide schriftlich)
// Das gleiche für 9b iii. a) und b)
        M1_ := W3_2; // für iii

        if M1_ = '' then
        begin
          Knotenebene_2_GY_GE;
          exit;
        end;

        for j := 1 to AnzahlElemente( M1_ ) do
        begin
          MarkierBemerkungen[1] := 'NW und FS: Fall 9b iii a)';
          FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0 );
          fach1 := EinzelElement( M1_, j );
          f1_id := Fach_ID_Von( fach1 );
          schr1 := IstSchriftlich( fach1, C_Q1, C_Q4 );
          statkrz := StatistikKuerzel( fach1 );
          markier_muster1 := '++++';
          if IstBelegtPunkte( fach1, C_Q1, C_Q4, markier_muster1 ) then
          begin
            if not NeuerKnoten( statkrz, markier_muster1, 1, root_id1 ) then
              exit;
            inc( cntNode );
            root_id2 := FAbiErgebnisVerwalter.WurzelKnoten;
          end else
            continue;


          M2_ := Vereinigungsmenge( W3_2, W3_3 );
          M2_ := Differenzmenge( M2_, fach1 ); // für interne Schleife

          if M2_ = '' then
          begin
            Knotenebene_2_GY_GE; // ????
            exit;
          end;

// Markiere zwei Kurse Q2.1 bis Q2.2 eines durchgehend belegten Faches aus W3_2 U W3_3 \ Fach(1)
          for k := 1 to AnzahlElemente( M2_ ) do
          begin
            MarkierBemerkungen[1] := 'NW und FS: Fall 9b iii b)';
            FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0, f1_id, markier_muster1 );
            fach2 := EinzelElement( M2_, k );
            statkrz := StatistikKuerzel( fach2 );
            markier_muster2 := '--++';
            if IstBelegtPunkte( fach2, C_Q1, C_Q4, markier_muster2 ) then
            begin
              if not NeuerKnoten( statkrz, markier_muster2, 1, root_id2 ) then
                exit;
              inc( cntNode );
              Knotenebene_2_GY_GE; // ????
            end;
          end;
        end;
      end;
    end;
  end;

  procedure Fall_9c;
  var
    M0_, M1_, M2_, fach0, fach1, fach2, statkrz: string;
    root_id0, root_id1, root_id2, f0_id, f1_id: integer;
    markier_muster0, markier_muster1, markier_muster2: string;
    i, j, k: integer;
    w6_andere_fs, fs_des_faches: string;
  begin
// Markiere vier Kurse Q1.1 bis Q2.2 des durchgehend belegten Faches aus W3_2
// Wir erzeugen hier eine Pseudo-Schleife mit einem Durchgang
//    M0_ := Differenzmenge( W3_2, W_AF );
    M0_ := W3_2;
    M0_ := EinzelElement( M0_, 1 );

    if M0_ = '' then
    begin
      Knotenebene_2_GY_GE;
      exit;
    end;

    root_id0 := FAbiErgebnisVerwalter.WurzelKnoten;
    for i := 1 to AnzahlElemente( M0_ ) do
    begin
      MarkierBemerkungen[1] := 'NW und FS: Fall 9c';
      FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1 );
      fach0 := EinzelElement( M0_, i );
      f0_id := Fach_ID_Von( fach0 );
      statkrz := StatistikKuerzel( fach0 );
      markier_muster0 := '++++';
      if IstBelegtPunkte( fach0, C_Q1, C_Q4, markier_muster0 ) then
      begin
        if not NeuerKnoten( statkrz, markier_muster0, 1, root_id0 ) then
          exit;
        inc( cntNode );
        root_id1 := FAbiErgebnisVerwalter.WurzelKnoten;
      end else
        continue;

      if AnzAbiFS >= 1 then
      begin // 9c i

// merk dir die Sprache von AbiFS
        M0_ := Vereinigungsmenge( W1_2, W1_3 );
        M0_ := Differenzmenge( M0_, W_AF );
        fs_des_faches := Fremdsprachen_Suffix_Ermitteln( M0_ );

// Markiere zwei Kurse Q2.1 bis Q2.1 eines durchgehend schriftlich belegten Faches aus W1_2 U W1_3 \ AF
        M1_ := Vereinigungsmenge( W1_2, W1_3 );
        w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches );
        M1_ := Vereinigungsmenge( M1_, w6_andere_fs );
//        M1_ := Vereinigungsmenge( M1_, FaecherAusW6( fremdsprachen ) );
        M1_ := Differenzmenge( M1_, W_AF );
        M1_ := SchriftlicheFaecher( M1_, C_Q1, C_Q3 );

        if M1_ = '' then
        begin
          Knotenebene_2_GY_GE;
          exit;
        end;

        for j := 1 to AnzahlElemente( M1_ ) do
        begin
          MarkierBemerkungen[1] := 'NW und FS: Fall 9c i';
          FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0 );
//            FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1 );
          fach1 := EinzelElement( M1_, j );
          f1_id := Fach_ID_Von( fach1 );
          statkrz := StatistikKuerzel( fach1 );
          markier_muster1 := '--++';
          if IstBelegtPunkte( fach1, C_Q1, C_Q4, markier_muster1 ) then
          begin
            if not NeuerKnoten( statkrz, markier_muster1, 1, root_id1 ) then
              exit;
            inc( cntNode );
            Knotenebene_2_GY_GE;
          end;
        end;

      end else if AnzAbiFS = 0 then
      begin // 9c ii

// Markiere vier Kurse Q1.1 bis Q2.1 eines durchgehend belegten Faches aus W1_2 U W1_3

        M1_ := Vereinigungsmenge( W1_2, W1_3 );

        if M1_ = '' then
        begin
          Knotenebene_2_GY_GE;
          exit;
        end;

// merk dir die Sprache

        for j := 1 to AnzahlElemente( M1_ ) do
        begin
          MarkierBemerkungen[1] := 'NW und FS: Fall 9c ii a)';
          FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0 );
          fach1 := EinzelElement( M1_, j );
          fs_des_faches := Fremdsprachen_Suffix_Ermitteln( fach1 );
          f1_id := Fach_ID_Von( fach1 );
          statkrz := StatistikKuerzel( fach1 );
          markier_muster1 := '++++';

          if IstBelegtPunkte( fach1, C_Q1, C_Q4, markier_muster1 ) then
          begin
            if not NeuerKnoten( statkrz, markier_muster1, 1, root_id1 ) then
              exit;
            inc( cntNode );
            root_id2 := FAbiErgebnisVerwalter.WurzelKnoten;
          end else
            continue;

// Markiere zwei Kurse Q2.1 bis Q2.2 eines durchgehend schriftlich belegten Faches aus W1_2 U W1_3 \ Fach(1)

          M2_ := Vereinigungsmenge( W1_2, W1_3 );
          w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches );
          M2_ := Vereinigungsmenge( M2_, w6_andere_fs );
//          M2_ := Vereinigungsmenge( M2_, FaecherAusW6( fremdsprachen ) );
          M2_ := Differenzmenge( M2_, fach1 );
          M2_ := SchriftlicheFaecher( M2_, C_Q1, C_Q3 );

// Hier SChriftlichkeit rein

          if M2_ = '' then
          begin
            Knotenebene_2_GY_GE; // ????
            exit;
          end;

//          root_id2 := FAbiErgebnisVerwalter.WurzelKnoten;
          for k := 1 to AnzahlElemente( M2_ ) do
          begin
            MarkierBemerkungen[1] := 'NW und FS: Fall 9c ii b)';
            FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1, f0_id, markier_muster0, f1_id, markier_muster1 );
            fach2 := EinzelElement( M2_, k );
            markier_muster2 := '--++';
            if IstBelegtPunkte( fach2, C_Q1, C_Q4, markier_muster2 ) and IstSChriftlich1( fach2, C_Q1, C_Q3 ) then
            begin
              statkrz := StatistikKuerzel( fach2 );
              if not NeuerKnoten( statkrz, markier_muster2, 1, root_id2 ) then
                exit;
              inc( cntNode );
              Knotenebene_2_GY_GE; // ????
            end;
          end;
        end;
      end;
    end;

  end;

begin

// Hier werden die Fremdsprachen und Naturwissenschaften markiert (Ebene 1)
// Es wird in jedem Schleifendurchlauf die tiefer liegenden Knotenebenen aufgerufen
// Fallunterscheidungen
  cntNode := 0;
  RootNode_ID := 0;
  anzNW := AnzahlElemente( Vereinigungsmenge( W3_2, W3_3 ) );
  anzFS := AnzahlElemente( Vereinigungsmenge( W1_2, W1_3 ) );
// NEU: Die einzelnen Fälle 9 a, b und c sind "stillgelegt"
  Fall_9;

{  if ( anzFS > 1 ) and ( anzNW > 1 ) then
    Fall_9a
  else if anzNW > 1 then
    Fall_9b
  else if anzFS > 1 then
    Fall_9c;}
end;

procedure TAbiturBelegPruefer.Knotenebene_2_GY_GE;
// Berechnung von KU MU usw.
var
  fach, statkrz, M_, markier_muster: string;
  root_id, i, cntNode, pktsum: integer;
begin
  cntNode := 0;

  if AbiMuKu then
  begin
    Knotenebene_3_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 2 );
    exit;
  end;

// Markiere die zwei besten Kurse eines Faches aus W1.4U W1.5
// Wie ist das zu vesr
  root_id := FAbiErgebnisVerwalter.WurzelKnoten;
// Markiere die zwei besten Kurse eines Faches aus W1.4 U W1.5, sofern mindestens zwei Kurse beölegt wurden
  M_ := Vereinigungsmenge( W1_4, W1_5 );
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    MarkierBemerkungen[2] := 'MU KU: Fall 10 a';
    fach := EinzelElement( M_, i );
    if AnzahlBelegteHalbjahre( fach, C_Q1, C_Q4 ) >= 2 then
    begin
      statkrz := StatistikKuerzel( fach );
      VPIP := 2;
      VILI := 2;
      MURest := 5;
      if InMenge( fach, W1_5 ) then
      begin
        VPIP := 0;
        VILI := 0;
      end;
      if ( statkrz = 'MU' ) or ( statkrz = 'IV' ) then
        MURest := 3;

      markier_muster := Beste2QKurse( fach, pktsum );

      if markier_muster <> '----' then
      begin
        if not NeuerKnoten( statkrz, markier_muster, 2, root_id ) then
          exit;
{            VPIP := 2;
          VILI := 2;
          MURest := 5;
          if InMenge( fach, W1_5 ) then
          begin
            VPIP := 0;
            VILI := 0;
          end;
          if ( statkrz = 'MU' )  or ( statkrz = 'IV' ) then
            MURest := 3;}
        inc( cntNode );
        Knotenebene_3_GY_GE;
        FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 2 );
      end;

    end;
  end;

{  if cntNode = 0 then
  begin
    Knotenebene_3_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 2 );
  end;}
end;

procedure TAbiturBelegPruefer.Knotenebene_3_GY_GE;
// Berechnung von GE
var
  fach, statkrz, markier_muster, fach_max, muster_max: string;
  root_id, i, cntNode, pktsum, pktsum_max, anz_g: integer;
  ge_schon_markiert: boolean;
begin

  if AbiGE then
  begin
    Knotenebene_4_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 3 );
    exit;
  end;

  cntNode := 0;
  anz_g := 0; // Anzahl grundkurse

  root_id := FAbiErgebnisVerwalter.WurzelKnoten;

  MarkierBemerkungen[3] := 'GE';

// NEU 8.4.2015: Prüfen, ob GE schon infolge bili markiert ist
  ge_schon_markiert := false;
  for i := 1 to AnzahlElemente( W2_1 ) do
  begin
    fach := EinzelElement( W2_1, 1 );
    statkrz := StatistikKuerzel( fach );
    if not ge_schon_markiert and ( FAbiErgebnisVerwalter.AnzahlMarkierungenFuerFach( statkrz ) >= 2 ) then
      ge_schon_markiert := true;
  // Wenn die Anzahl belegter Kurse in W2_1 > 1 (  ZK egal )dann
    anz_g := anz_g + AnzahlBelegteHalbjahre( fach, C_Q1, C_Q4 );
  end;

  if ge_schon_markiert then
  begin
    Knotenebene_4_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 3 );
    exit;
  end;

  pktsum_max := 0;
  muster_max := '----';

  for i := 1 to AnzahlElemente( W2_1 ) do
  begin
    fach := EinzelElement( W2_1, i );
    if AnzahlBelegteHalbjahre( fach, C_Q1, C_Q4 ) >= 2 then
    begin
      markier_muster := Beste2QKurse( fach, pktsum );
      if pktsum > pktsum_max then
      begin
        pktsum_max := pktsum;
        fach_max := fach;
        muster_max := markier_muster;
      end;
    end;
  end;

  if muster_max <> '----' then
  begin
    statkrz := StatistikKuerzel( fach_max );
    if not NeuerKnoten( statkrz, muster_max, 3, root_id ) then
      exit;
    inc( cntNode );
    Knotenebene_4_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 3 );
  end;

end;

procedure TAbiturBelegPruefer.Knotenebene_4_GY_GE;
// Berechnung von SW
var
  fach, statkrz, markier_muster, fach_max, muster_max: string;
  root_id, i, cntNode, pktsum, pktsum_max, anz_g: integer;
  sw_schon_markiert: boolean;
begin
  if AbiSW then
  begin
    Knotenebene_5_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 4 );
    exit;
  end;

  anz_g := 0; // Anzahl grundkurse
  cntNode := 0;

// Wenn die Anzahl belegter Kurse in W2_2 > 1 dann
  root_id := FAbiErgebnisVerwalter.WurzelKnoten;

  MarkierBemerkungen[4] := 'SW';

// NEU 8.4.2015: Prüfen, ob SW schon infolge bili markiert ist
  sw_schon_markiert := false;
  for i := 1 to AnzahlElemente( W2_2 ) do
  begin
    fach := EinzelElement( W2_2, 1 );
    statkrz := StatistikKuerzel( fach );
    if not sw_schon_markiert and ( FAbiErgebnisVerwalter.AnzahlMarkierungenFuerFach( statkrz ) >= 2 ) then
      sw_schon_markiert := true;
  // Wenn die Anzahl belegter Kurse in W2_1 > 1 ( ohne ZK )dann
    anz_g := anz_g + AnzahlBelegteHalbjahre( fach, C_Q1, C_Q4, '-ZK' );
  end;

  if sw_schon_markiert then
  begin
    Knotenebene_5_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 4 );
    exit;
  end;

  pktsum_max := 0;
  muster_max := '----';

// Es werden nur die zwei besten Kurse markiert
  for i := 1 to AnzahlElemente( W2_2 ) do
  begin
    fach := EinzelElement( W2_2, i );
    if AnzahlBelegteHalbjahre( fach, C_Q1, C_Q4 ) >= 2 then
    begin
      markier_muster := Beste2QKurse( fach, pktsum );
      if pktsum > pktsum_max then
      begin
        pktsum_max := pktsum;
        fach_max := fach;
        muster_max := markier_muster;
      end;
    end;
  end;

  if muster_max <> '----' then
  begin
    statkrz := StatistikKuerzel( fach_max );
    if not NeuerKnoten( statkrz, muster_max, 4, root_id ) then
      exit;
    inc( cntNode );
    Knotenebene_5_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 4 );
  end;

{  if cntNode = 0 then
  begin
    Knotenebene_5_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 4 );
  end;}
end;


procedure TAbiturBelegPruefer.Knotenebene_5_GY_GE;
// Berechnung von Einsprachler
var
  fach, statkrz, M_, markier_muster: string;
  root_id, i, cntNode: integer;
begin
  cntNode := 0;

  if not FSchueler.Einsprachler or AbiNFS then
  begin
    Knotenebene_6_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 5 );
    exit;
  end;

// Markiere zwei Kurse Q2.1 bis Q2.2 eines durchgehend belegten Faches aus w1_3
  M_ := W1_3;

  root_id := FAbiErgebnisVerwalter.WurzelKnoten;
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    MarkierBemerkungen[5] := 'Einsprachler: Fall 13';
    fach := EinzelElement( W1_3, i );
    statkrz := StatistikKuerzel( fach );
    markier_muster := '--++';
    if IstBelegtPunkte( fach, C_Q3, C_Q4, markier_muster ) then
    begin
      if not NeuerKnoten( statkrz, markier_muster, 5, root_id ) then
        exit;
      inc( cntNode );
      Knotenebene_6_GY_GE;
      FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 5 );
    end;
  end;
{  if cntNode = 0 then
  begin
    Knotenebene_6_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 5 );
  end;}
end;

procedure TAbiturBelegPruefer.Knotenebene_6_GY_GE;
// Berechnung RE

var
  Hj, Hj_ges: TStringList;
  root_id, reli_rest: integer;
  fach, statkrz, markier_muster: string;

  function BesterKurs( var punkte: integer ): integer;
  var
    i, ia, pktmax, pkt, iamax: integer;
  begin
    iamax := 0;
    pktmax := 0;
    for i := 0 to Hj.Count - 1 do
    begin
      ia := StrToInt( Hj[i] );
      if ( ia > 0 ) and FAbiErgebnisVerwalter.FachAbschnittVorhanden( FC0.FieldByName( 'Fach_ID' ).AsInteger, ia ) then
      begin
        pkt := FC0.FieldByname( Format( 'PU_%d', [ ia ] ) ).AsInteger;
        if pkt > pktmax then
        begin
          pktmax := pkt;
          iamax := ia;
        end;
      end;
    end;
    Result := iamax;
    punkte := pktmax;
  end;

{  procedure Aufraeumen;
  var
    i: integer;
  begin
    Hj_save.Clear;
    for i := 0 to Hj.Count - 1 do
      Hj_save.Add( Hj[i] );
    Hj.Clear;
    for i := 0 to Hj_save.Count - 1 do
    begin
      if Hj_save[i] <> '0' then
        Hj.Add( Hj_save[i] );
    end;
  end;}

  procedure FachInMengeRein( const fach: string; const abschnitt: integer; const wichtung: integer = 1);
  begin
    FReliTemp.Append;
    FReliTemp.FieldByName( 'Fach' ).AsString := fach;
    FReliTemp.FieldByName( 'Wichtung' ).AsInteger := wichtung;
    FReliTemp.FieldByName( 'Abschnitt' ).AsInteger := abschnitt;
    FReliTemp.FieldByName( 'Punkte' ).AsInteger := Punkte( fach, abschnitt );
    FReliTemp.Post;
  end;

  procedure EintragInMengeRein( tmp_tbl: TMemTableEh; const fach: string; const abschnitt: integer; const wichtung: integer );
  begin
    tmp_tbl.Append;
    tmp_tbl.FieldByName( 'Fach' ).AsString := fach;
    tmp_tbl.FieldByName( 'Wichtung' ).AsInteger := wichtung;
    tmp_tbl.FieldByName( 'Abschnitt' ).AsInteger := abschnitt;
    tmp_tbl.FieldByName( 'Punkte' ).AsInteger := Punkte( fach, abschnitt );
    tmp_tbl.Post;
  end;



  procedure InDieMenge( const M_: string; HJ_: TStringList; const kursart: string = '' );
  var
    i, j, j_hj, icnt: integer;
    fach: string;
    fach_id: integer;
    anz_nichtmark: integer;
  begin
    if M_ = '' then
      exit;
    FReliTemp.EmptyTable;
    for i := 1 to AnzahlElemente( M_ ) do
    begin
      fach := EinzelElement( M_, i );
      fach_id := Fach_ID_Von( fach );
      anz_nichtmark := 0;
      for j := 0 to HJ_.Count - 1 do
      begin
        j_hj := StrToInt( HJ_[j] ); // der jeweilige Abschnitt
        if AnzahlNichtMarkiert( fach, j_hj, j_hj, '-ZK' ) = 1 then
          inc( anz_nichtmark );
      end;

      if anz_nichtmark < reli_rest then
        continue;

      for j := 0 to HJ_.Count - 1 do
      begin
        j_hj := StrToInt( HJ_[j] ); // der jeweilige Abschnitt
        if AnzahlNichtMarkiert( fach, j_hj, j_hj, '-ZK' ) = 1 then
        begin
          if FAbiErgebnisVerwalter.FachAbschnittVorhanden( fach_id, j_hj ) then
            FachInMengeRein( fach, j_hj, 1 );
        end;
      end;
    end;
// Es müssen mindestens reli_rest Einträge vorhanden sein.
    if FReliTemp.RecordCount < reli_rest then
      exit;
// Nach absteigenden Noten sortieren
    FReliTemp.SortByFields( 'Punkte DESC' );

    if FReliTemp.RecordCount >= reli_rest then
      icnt := reli_rest
    else
      icnt := FReliTemp.RecordCount;

// Jetzt die besten Noten des Faches in die Restmenge übernehmen
    FReliTemp.First;
    for i := 1 to icnt do
    begin
      if not FReliRest.Locate( 'Fach', FReliTemp.FieldByName( 'Fach' ).AsString, [] ) then
      begin
        FReliRest.Append;
        FReliRest.FieldByName( 'Fach' ).AsString := FReliTemp.FieldByName( 'Fach' ).AsString;
      end else
        FReliRest.Edit;
      j_hj := FReliTemp.FieldByName( 'Abschnitt' ).AsInteger;
      FReliRest.FieldByName( Format( 'Punkte_%d', [ j_hj ] ) ).AsInteger := FReliTemp.FieldByName( 'Punkte' ).AsInteger;
      FReliRest.Post;
      FReliTemp.Next;
    end;
    FReliTemp.EmptyTable;
  end;

  function ReliRestMarkierung: boolean;
  var
    ix, i, pktsum, bk: integer;
    M_: string;
  begin
    Result := true;
    markier_muster := '----';
//a)	Fülle eine neue Menge M mit Fächern und Noten aus W2.1 (ohne ZK ) U W2.2 (ohne ZK ) U W2.3 \ AF
// Es kommen nur Fächer in die Menge, die nicht markierte Noten der Anzahl ≥ Relirest haben.
//Zudem müssen diese Noten aus bestimmten Halbjahren stammen  (s.u.).
//Ist die Anzahl der nicht markierten Noten eines Faches aus der geforderten Halbjahresmenge > Relirest,
//so wird lediglich die benötigte Anzahl mit den besten Noten gewählt.
    FReliRest.EmptyTable;

//Fächer und Noten aus W2.3 gelangen in die Menge, sofern nicht markierte Noten aus der
//Halbjahresmenge Hj existieren
    M_ := Differenzmenge( W2_3, W_AF );
    if M_ <> '' then
      InDieMenge( M_, Hj );

//Wenn GEZK = True: Fächer und Noten aus W2.1 gelangen in die Menge, sofern nicht markierte Noten
//aus der Halbjahresmenge Hj existieren
    M_ := Differenzmenge( W2_1, W_AF );
    if M_ <> '' then
    begin
//      if GE_ZK then
//        InDieMenge( M_, Hj )
// Wenn GEZK = False: Fächer und Noten aus W2.1 gelangen in die Menge, sofern nicht markierte Noten
//in Q1.1 bis Q2.2 existieren
//      else
        InDieMenge( M_, Hj_ges );
    end;

// Wenn SWZK = True: Fächer und Noten aus W2.2 gelangen in die Menge, sofern nicht markierte Noten
//aus der Halbjahresmenge Hj existieren
    M_ := Differenzmenge( W2_2, W_AF );
    if M_ <> '' then
    begin
//      if SW_ZK then
//        InDieMenge( M_, Hj )
// Wenn SWZK = False: Fächer und Noten aus W2.2 gelangen in die Menge, sofern nicht markierte Noten
// in Q1.1 bis Q2.2 existieren
//      else
        InDieMenge( M_, Hj_ges );
    end;

//	Bilde für jedes Fach aus M die Summe der Notenpunkte (Nur notwendig, wenn Relirest = 2)
// Hier
    with FreliRest do
    begin
      First;
      while not Eof do
      begin
        pktsum := 0;
        for i := C_Q1 to C_Q4 do
        begin
          if reli_rest = 2 then
            pktsum := pktsum + FieldByName( Format( 'Punkte_%d', [ i ] ) ).AsInteger
          else
            pktsum := Max( pktsum, FieldByName( Format( 'Punkte_%d', [ i ] ) ).AsInteger );
        end;
        Edit;
        FieldByName( 'PunktSumme' ).AsInteger := pktsum;
        Post;
        Next;
      end;
      SortByFields( 'PunktSumme DESC' );
      First;
// Wir sind jetzt beim besten fach
      fach := FieldByName( 'Fach' ).AsString;
      statkrz := StatistikKuerzel( fach );
{      Hj.Clear;// Damit bei BesterKurs alle Hj. zur Verfügung stehen
      for i := 3 to 6 do
        Hj.Add( IntToStr( i ) );}
      pktsum := 0;
      bk := 0;
      for i := 3 to 6 do
      begin
        if FieldByName( Format( 'Punkte_%d', [ i ] ) ).AsInteger > pktsum then
        begin
          pktsum := FieldByName( Format( 'Punkte_%d', [ i ] ) ).AsInteger;
          bk := i;
        end;
      end;

//      bk := BesterKurs( pktsum );
      if bk > 0 then
      begin
        markier_muster[ bk - 2 ] := '+';
//        ix := Hj.IndexOf( IntToStr( bk ) );
//        HJ.Delete( ix );
        if reli_rest = 2 then
        begin // noch einen Eintrag holen
// Lösche den benutzten Eintrag aus der Halbjahresmenge
          Edit;
          FieldByname( 'PunktSumme' ).AsInteger := FieldByname( 'PunktSumme' ).AsInteger - pktsum;
          FieldByName( Format( 'Punkte_%d', [ bk ] ) ).Clear;
          Post;
          SortByFields( 'PunktSumme DESC' );
          First;
          pktsum := 0;
          bk := 0;
          for i := 3 to 6 do
          begin
            if FieldByName( Format( 'Punkte_%d', [ i ] ) ).AsInteger > pktsum then
            begin
              pktsum := FieldByName( Format( 'Punkte_%d', [ i ] ) ).AsInteger;
              bk := i;
            end;
          end;
//          bk := BesterKurs( pktsum );
          if bk > 0 then
            markier_muster[ bk - 2 ] := '+';
        end;
      end;
      if markier_muster <> '----' then
      begin
        root_id := FAbiErgebnisVerwalter.WurzelKnoten;
        Result := NeuerKnoten( statkrz, markier_muster, 6, root_id );
      end;
    end;
  end;


  procedure EinzelkursMarkieren( tmp_tbl: TMemTableEh );
  var
    ia: integer;
    fach, statkrz: string;
  begin
    markier_muster := '----';
    ia := tmp_tbl.FieldByName( 'Abschnitt' ).AsInteger;
    markier_muster[ia-2] := '+';
    root_id := FAbiErgebnisVerwalter.WurzelKnoten;
    fach := tmp_tbl.FieldByName( 'Fach' ).AsString;
    statkrz := StatistikKuerzel( fach );
    NeuerKnoten( statkrz, markier_muster, 6, root_id );
  end;


  procedure MengeBilden( const tmp_tbl: TMemTableEh; const M_: string );
  var
    fach, statkrz: string;
    fach_id, i, j: integer;

  begin
    tmp_tbl.EmptyTable;
    if M_ = '' then
      exit;

    for i := 1 to AnzahlElemente( M_ ) do
    begin
      fach := EinzelElement( M_, i );
      fach_id := Fach_ID_Von( fach );
      for j := C_Q1 to C_Q4 do
      begin
        if IstBelegtPunkte1( fach, j, j ) and not IstMarkiert( fach, j ) then
        begin
          if FAbiErgebnisVerwalter.FachAbschnittVorhanden( fach_id, j ) then
            EintragInMengeRein( tmp_tbl, fach, j, 1 );
        end;
      end;
    end;
    if tmp_tbl.IsEmpty then
      exit;
    tmp_tbl.SortByFields( 'Punkte DESC' );
  end;

var
  M_: string;
  reli_gefunden, bel: boolean;
  i, j, ix, bk, bk_alt, maxpkt, bkmax: integer;
//  fach, abiW2: string;
begin

//  if AbiRE or AbiPL then
//  begin
//// Hier die neue Prüfung:
//// wenn W2.4 einziges Abifach in W2 ist, dann ebenfalls keine weitere RE-Prüfung (W2.4 = Philosophie
//  end else

  if not AbiRE and not AbiPL then
  begin
// Bilde eine Menge mit allen Religionskursen und Philosophiekursen. Markiere die beiden besten Kurse (egal welches Halbjahr, egal welches Fach)
    MarkierBemerkungen[6] := 'RE: Fall 15';
    MengeBilden( FTemp1, Vereinigungsmenge( W2_4, W4 ) );
    FTemp1.First;
    EinzelkursMarkieren( FTemp1 );
    if FTemp1.RecordCount > 1 then
    begin
      FTemp1.Next;
      EinzelkursMarkieren( FTemp1 );
    end;
  end else if not AbiRE and AbiPL and not AbiGW then
  begin
// 16 a Wurde eine beliebige Religion in Q1.1 belegt und wurde eine beliebige Religion in Q1.2 belegt
    MarkierBemerkungen[6] := 'RE: Fall 16';
    if GruppeGemischtBelegt( W4, C_Q1, C_Q2 ) then
    begin
// 16 a i J: Bilde eine Menge mit allen Religionskursen, markier die beiden besten Kurse (egal welches Jalbjahr, egal welches Fach)
      MengeBilden( FTemp1, W4 );
      FTemp1.First;
      EinzelkursMarkieren( FTemp1 );
      if FTemp1.RecordCount > 1 then
      begin
        FTemp1.Next;
        EinzelkursMarkieren( FTemp1 );
      end;
    end else
    begin
// 16 a ii.	Nein: Wurde eine beliebige Religion in Q1.1 belegt oder wurde eine beliebige Religion in Q1.2 belegt
      bel := GruppeGemischtBelegt( W4, C_Q1, C_Q1 ) or GruppeGemischtBelegt( W4, C_Q2, C_Q2 );
      if bel then
      begin
//16 a ii 1) Ja: Bilde eine Menge R mit allen Religionskursen und dem besten noch nicht markierten Kurs (also lediglich einen Kurs) aus den Gesellschafts-wissen¬schaften W2 (auch Zusatzkurse).
//Markiere die zwei besten Noten aus R.
        MengeBilden( FTemp1, W4 );
        MengeBilden( FTemp2, W2 );
        FTemp2.First;
        EintragInMengeRein( FTemp1,
                            FTemp2.FieldByName( 'Fach' ).AsString,
                            FTemp2.FieldByName( 'Abschnitt' ).AsInteger,
                            FTemp2.FieldByName( 'Wichtung' ).AsInteger );
        FTemp1.SortByFields( 'Punkte DESC' );
        FTemp1.First;
        EinzelkursMarkieren( FTemp1 );
        if FTemp1.RecordCount > 1 then
        begin
          FTemp1.Next;
          EinzelkursMarkieren( FTemp1 );
        end;
      end else
      begin
//16 a ii 2) Nein: Bilde eine Menge R mit allen Religionskursen und den zwei besten noch nicht markierten Kurs (also zwei Kurse) aus den Gesellschaftswissenschaften W2 (auch Zusatzkurse). Markiere die zwei besten Noten	 aus R.
        MengeBilden( FTemp1, W4 );
        MengeBilden( FTemp2, W2 );
        FTemp2.First;
        EintragInMengeRein( FTemp1,
                            FTemp2.FieldByName( 'Fach' ).AsString,
                            FTemp2.FieldByName( 'Abschnitt' ).AsInteger,
                            FTemp2.FieldByName( 'Wichtung' ).AsInteger );
        if FTemp2.RecordCount > 1 then
        begin
          FTemp2.Next;
          EintragInMengeRein( FTemp1,
                              FTemp2.FieldByName( 'Fach' ).AsString,
                              FTemp2.FieldByName( 'Abschnitt' ).AsInteger,
                              FTemp2.FieldByName( 'Wichtung' ).AsInteger );
        end;
        FTemp1.SortByFields( 'Punkte DESC' );
        FTemp1.First;
        EinzelkursMarkieren( FTemp1 );
        if FTemp1.RecordCount > 1 then
        begin
          FTemp1.Next;
          EinzelkursMarkieren( FTemp1 );
        end;
      end;
    end;
  end;

  Knotenebene_7_GY_GE;
  FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 6 );

end;

procedure TAbiturBelegPruefer.Knotenebene_7_GY_GE;
// Berechnung GW
var
  fach, statkrz, M_, markier_muster: string;
  root_id, i, cntNode: integer;
begin
//  ProjZwang := false; // Ist das hier wirklich richtig?????
  cntNode := 0;

  if AbiGW or AbiPL then
  begin
    Knotenebene_8_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 7 );
    exit;
  end;

// Markiere vier Kurse Q1.1 bis Q2.2 eines durchgehend belegten Faches aus W2_1 U W2_2 U W2_3 U W2_4
  M_ := W2_1;
  M_ := Vereinigungsmenge( M_, W2_2 );
  M_ := Vereinigungsmenge( M_, W2_3 );
  M_ := Vereinigungsmenge( M_, W2_4 );

  root_id := FAbiErgebnisVerwalter.WurzelKnoten;
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    MarkierBemerkungen[7] := 'GW: Fall 15';
    fach := EinzelElement( M_, i );
    statkrz := StatistikKuerzel( fach );
    markier_muster := '++++';
    if IstBelegtPunkte( fach, C_Q1, C_Q4, markier_muster, '-ZK' ) then
    begin
      if not NeuerKnoten( statkrz, markier_muster, 7, root_id ) then
        exit;
      inc( cntNode );
// Besonderheit an dieser Stelle?
      Knotenebene_8_GY_GE;
      FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 7 );
    end;
  end;
{  if cntNode = 0 then
  begin
    Knotenebene_8_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 7 );
  end;}
end;

procedure TAbiturBelegPruefer.Knotenebene_8_GY_GE;
// Berechnung Projektkusr
var
  root_id: integer;
  fach, statkrz, markier_muster: string;
  i: integer;
var
  cntNode: integer;
begin
  ProjZwang := false;

  if not HatProjektkurs then
  begin
    Knotenebene_9_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 8 );
    exit;
  end;

  if not ProjZwang then
  begin  // arbeite die noch folgenden markierungen einmal gänzlich ohne Projektkurs( ProjMark = false) und einmal mit markiertem Projektkurs (ProjMark=True) ab
// Aufruf ohne Projektkurs
    ProjMark := false;
//      FAbiErgebnisVerwalter.ZwischenstandSpeichern;
    root_id := FAbiErgebnisVerwalter.WurzelKnoten;
    Knotenebene_9_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 8 );
    if not FAbbruch then
    begin
// Jetzt mit Projektkurs
      ProjMark := true;
//        FAbiErgebnisVerwalter.ZwischenstandWiederherstellen;
      fach := EinzelElement( W_PF, 1 );
      markier_muster := '????';
      if IstBelegtPunkte( fach, C_Q1, C_Q4, markier_muster ) then
      begin
        for i := 1 to 4 do
          if markier_muster[i] = '?' then
            markier_muster[i] := '-';
        if markier_muster <> '----' then
        begin
          MarkierBemerkungen[8] := 'Projektkurs: Fall 17';
          statkrz := StatistikKuerzel( fach );
          if not NeuerKnoten( statkrz, markier_muster, 8, root_id ) then
            exit;
        end;
      end;
      Knotenebene_9_GY_GE;
      FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 8 );
    end;
  end else // markiere die zwei Halbjahre des Projektkurses
  begin
    fach := EinzelElement( W_PF, 1 );
    markier_muster := '????';
    if IstBelegtPunkte( fach, C_Q1, C_Q4, markier_muster ) then
    begin
      for i := 1 to 4 do
        if markier_muster[i] = '?' then
          markier_muster[i] := '-';
      root_id := FAbiErgebnisVerwalter.WurzelKnoten;
      if markier_muster <> '----' then
      begin
        MarkierBemerkungen[8] := 'Projektkurs: Fall 17';
        statkrz := StatistikKuerzel( fach );
        if not NeuerKnoten( statkrz, markier_muster, 8, root_id ) then // autom. Sprinbgen in nächsten Knoten unterdrücken
          exit;
      end;
    end;
  end;

end;

procedure TAbiturBelegPruefer.Knotenebene_9_GY_GE;
begin
   FAbiErgebnisVerwalter.RestarbeitenVorbereiten( VPIP, 9 );

// Wichtig: Da hier keine Knoten erzeugt werden, muss auf Ebene 8 zu
  if AbiMUKU or ( FAbiErgebnisVerwalter.AnzahlW1_6 <> 2 ) then
  begin
    Knotenebene_10_GY_GE;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 9 ); // Ist das richtig??

// NEU Jan. 2017
//    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 8 ); // Ist das richtig??
    exit;
  end;

// Durchlaufe die restlichen Punkte zunächst normal. Entferne dann den schlechteren
// der beiden Kurse aus W1_6 und durchlaufe die restlichen Punkte nochmals
  Knotenebene_10_GY_GE;
  FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 9 ); // Ist das richtig??

  FAbiErgebnisVerwalter.W1_6Loeschen( 9 );
//  Knotenebene_10_GY_GE;
//  FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 9 ); // Ist das richtig??

end;

procedure TAbiturBelegPruefer.Knotenebene_10_GY_GE;
var
  MarkKurse: integer;
  fach_id, abschnitt : integer;

  procedure Fallunterscheidung;
  var
    fach, statkrz, markier_muster: string;
    root_id: integer;
  begin
    markier_muster := '----';
    fach := FachKuerzel_aus_ID( fach_id );
    statkrz := StatistikKuerzel( fach );
    root_id := FAbiErgebnisVerwalter.WurzelKnoten;
    if InMenge( fach, W1_6 ) then
    begin
      if ( VPIP = 0 ) or ( MuRest = 0 ) or ( VILI = 0 ) then
// Streiche den Kusr aus der Liste
        FAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen
      else
      begin
        dec( VPIP );
        dec( VILI );
//        MuRest := 0;
// Oder
        MuRest := MuRest - 1;
        inc( MarkKurse );
        markier_muster[ abschnitt - 2 ] := '+';
        NeuerKnoten( statkrz, markier_muster, 10, root_id ); // 10?
      end;
    end else if statkrz = 'LI' then
    begin
      if VILI = 0 then
        FAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen
      else
      begin
        dec( VILI );
        inc( MarkKurse );
        markier_muster[ abschnitt - 2 ] := '+';
        NeuerKnoten( statkrz, markier_muster, 10, root_id ); // 10?
      end;
    end else if statkrz = 'MU' then
    begin
      if MuRest = 0 then
// Streiche den KuRS aus der Liste
        FAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen
      else
      begin
        dec( MuRest );
        inc( MarkKurse );
        markier_muster[ abschnitt - 2 ] := '+';
        NeuerKnoten( statkrz, markier_muster, 10, root_id ); //10?
      end;
    end else
    begin
      inc( MarkKurse );
      markier_muster[ abschnitt - 2 ] := '+';
      NeuerKnoten( statkrz, markier_muster, 10, root_id ); //10?
    end;
  end;

var
  minKurse, maxKurse, punkte, defizite: integer;
  D_I : double;

begin
  with MuRestRec do
  begin
    _MuRest := MuRest;
    _VPIP := VPIP;
    _VILI := VILI;
  end;

  MarkierBemerkungen[10] := 'Restarbeiten: Fall 22';

// Zähle die markierten Kurse
  MarkKurse := FAbiErgebnisVerwalter.AnzahlMarkierteKurse;
  minKurse := C_MIN_KURSE_GY_G8;

  if not FAbbruch then
  begin
    while ( MarkKurse < minKurse ) do
    begin
      if FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fach_id, abschnitt, punkte ) then
      begin
        Fallunterscheidung;
      end else
      begin
        if not HatProjektkurs or ProjMark then
        begin
          FAbbruch := true;
          FMeldungen.Add( 'Keine Abiturzulassung! Zu wenig Kurse in Block I' );
          break;
        end else
        begin
          ProjZwang := true;
          break;
        end;
      end;
    end;
  end;

  if not FAbbruch and ProjZwang then
  begin

    KnotenStrukturenErzeugen // wieder auf Start

  end else
  begin

  // Durchschnitt berechnen
//    DS := FAbiErgebnisVerwalter.Durchschnitt;
    maxKurse := C_MAX_KURSE_GY_G8;

    MarkierBemerkungen[10] := 'Restarbeiten: Fall 24';
//    D_I := FAbiErgebnisVerwalter.Durchschnitt;
    while true do
    begin
      if MarkKurse >= maxKurse then
        break;
      if not FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fach_id, abschnitt, punkte ) then
      begin
        if Debughook <> 0 then
          defizite := FAbiErgebnisVerwalter.DefizitSumme;    // nur für Breakpoint
        break;
      end;
      D_I := FAbiErgebnisVerwalter.Durchschnitt;
      if D_I >= punkte then
        break;
      Fallunterscheidung;
      if MarkKurse >= maxKurse then
        break;
    end;

    defizite := FAbiErgebnisVerwalter.DefizitSumme;
    MarkierBemerkungen[10] := 'Restarbeiten: Fall 26';
    while ( MarkKurse < maxKurse ) and FAbiErgebnisVerwalter.RestelisteBelegt and ( defizite / MarkKurse > 0.214 ) do
    begin
      if FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fach_id, abschnitt, punkte ) then
        Fallunterscheidung
      else
        break;
    end;

    FAbiErgebnisVerwalter.EinzelErgebnisBerechnen;

    with MuRestRec do
    begin
      MuRest := _MuRest;
      VPIP := _VPIP;
      VILI := _VILI;
    end;


  end;

end;

procedure TAbiturBelegPruefer.WBK_AnrechenbarkeitPruefen( const fach: string; var ar_q1, ar_q2, ar_q3, ar_q4: boolean );
var
  p_e2, p_q1, p_q2, p_q3, p_q4: integer;
begin
  ar_q1 := false;
  ar_q2 := false;
  ar_q3 := false;
  ar_q4 := false;

  with FC0 do
  begin
    p_e2 := 0;
    if FieldByname( 'KA_2' ).AsString <> '' then
      p_e2 := 5; // Dummy, da PU_2 nicht existiert
    p_q1 := Punkte( fach, C_Q1 );
    p_q2 := Punkte( fach, C_Q2 );
    p_q3 := Punkte( fach, C_Q3 );
    p_q4 := Punkte( fach, C_Q4 );
  end;

  if p_q1 > 0 then
    ar_q1 := ( p_e2 > 0 ) or ( p_q2 > 0);

  ar_q1 := ( p_q1 > 0 ) and ( ( p_e2 > 0 ) or ( p_q2 > 0 ) );
  ar_q2 := ( p_q2 > 0 ) and ( ( p_q1 > 0 ) or ( p_q3 > 0 ) );
  ar_q3 := ( p_q3 > 0 ) and ( ( p_q2 > 0 ) or ( p_q4 > 0 ) );
  ar_q4 := ( p_q4 > 0 ) and ( p_q3 > 0 );
end;

procedure TAbiturBelegPruefer.KnotenStrukturenErzeugen;
var
  i: integer;
  ar_q1, ar_q2, ar_q3, ar_q4: boolean;
  fach: string;
begin
  FAbbruch := false;
  FMeldungen.Clear;

// Jetzt alle Nicht-Zwangsfächer speichern, dami aus diesen später die Auffüllung stattfinden kann
  FAbiErgebnisVerwalter.Spezial_IDs.Clear;
  with FC0 do
  begin
    First;
    while not Eof do
    begin
      if slZwangsFaecher.IndexOf( FieldByName( 'FachInternKrz' ).AsString ) < 0 then
      begin
        if FieldByName( 'FachStatKrz' ).AsString = C_PROJEKTKURS then
          FAbiErgebnisVerwalter.Spezial_IDs.Add( 'PX=' + FieldByName( 'Fach_ID' ).AsString )
        else if FieldByName( 'FachStatKrz' ).AsString = 'MU' then
          FAbiErgebnisVerwalter.Spezial_IDs.Add( 'MU=' + FieldByName( 'Fach_ID' ).AsString )
        else if FieldByName( 'FachStatKrz' ).AsString = 'LI' then
          FAbiErgebnisVerwalter.Spezial_IDs.Add( 'LI=' + FieldByName( 'Fach_ID' ).AsString )
        else if FieldByName( 'FachStatKrz' ).AsString = 'IV' then
          FAbiErgebnisVerwalter.Spezial_IDs.Add( 'IV=' + FieldByName( 'Fach_ID' ).AsString );

        fach := FieldByName( 'FachInternKrz' ).AsString;
        if FSchulform <> 'WB' then
        begin
          for i := C_Q1 to C_Q4 do
          begin
            if FieldByName( Format( 'PU_%d', [ i ] ) ).AsInteger > 0 then
              FAbiErgebnisVerwalter.FachAbschnittHinzu( FieldByName( 'Fach_ID' ).AsInteger, i,
                                                        FieldByName( Format( 'PU_%d', [ i ] ) ).AsInteger );
          end;
        end else
        begin

          WBK_AnrechenbarkeitPruefen( fach, ar_q1, ar_q2, ar_q3, ar_q4 );
          if ar_q1 then
            FAbiErgebnisVerwalter.FachAbschnittHinzu( FieldByName( 'Fach_ID' ).AsInteger, 3, FieldByName( 'PU_3' ).AsInteger );
          if ar_q2 then
            FAbiErgebnisVerwalter.FachAbschnittHinzu( FieldByName( 'Fach_ID' ).AsInteger, 4, FieldByName( 'PU_4' ).AsInteger );
          if ar_q3 then
            FAbiErgebnisVerwalter.FachAbschnittHinzu( FieldByName( 'Fach_ID' ).AsInteger, 5, FieldByName( 'PU_5' ).AsInteger );
          if ar_q4 then
            FAbiErgebnisVerwalter.FachAbschnittHinzu( FieldByName( 'Fach_ID' ).AsInteger, 6, FieldByName( 'PU_6' ).AsInteger );
        end;
      end;
      Next;
    end;
  end;
  if ( FSchulform = 'GY' ) or ( FSchulform = 'GE' ) or ( FSchulform = '' ) then
    Knotenebene_1_GY_GE
  else if FSchulform = 'WB' then
  begin
    FAbiErgebnisVerwalter.FachAbschnitteSortieren;
    Knotenebene_1_WBK;
  end;


end;

procedure TAbiturBelegPruefer.KurseMarkieren_GY_GE;
var
  i, j, pkt: integer;
  fach, statkrz, M_, BiliSprache: string;
  pkt_sum_zb, anz_def_zb, anz_markiert_zb: integer; // Für die "Zwangsbedingungen"
begin
// Prüfe für alle Sachfächer, ob ein bilinguales Sachfach belegt wurde
  M_ := Vereinigungsmenge( W1_2, W1_3 ); // Sprachmenge
  for i := 1 to AnzahlElemente( W6 ) do
  begin
    fach := EinzelElement( W6, i );
    if IstBelegt1( fach, C_Q1, C_Q4 ) then
    begin
      BiliSprache := UnterrichtsSprache( fach );
      if BiliSprache <> 'D' then
      begin
        FBilSF_Belegt := Differenzmenge( M_, BiliSprache ) <> '';
        if FBilSF_Belegt then
          break;
      end;
    end;
  end;


// 4. Neu: Ermittlung of NW- oder Sprach-Schwerpunkt
  Sprachen_SP := ( AnzahlElemente( FMenge_A ) >= 2 );
  NW_SP := ( AnzahlElemente( FMenge_C ) >= 2 ) and ( AnzahlElemente( FMenge_D ) >= 1 );

// 5. Schleife über alle Abiturfächer
  for i := 1 to AnzahlElemente( W_AF ) do
  begin
    fach := EinzelElement( W_AF, i );
    statkrz := StatistikKuerzel( fach );

// Jetzt die Abiturfaecher markieren
    slZwangsFaecher.Add( fach );
    AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
  end;

  M_ := SchnittMenge( W_AF, W2 ); // die Abi-Fächer aus W2
  Nur_PL_AF := ( Schnittmenge( W2_4, M_ ) <> '' ) // W2_4 in Abi-Fächern
                and ( AnzahlElemente( M_ ) = 1 ); // nur ein Fach aus W2 in Abi, das muss dann W2_4 sein

// LK Defizite ermitteln
  FAnzLKDefizit := 0;
  pkt_sum_zb := 0;
  anz_def_zb := 0;
  anz_markiert_zb := 0;
  for i := 1 to AnzahlElemente( W_LK ) do
  begin
    fach := EinzelElement( W_LK, i );
    for j := C_Q1 to C_Q4 do
    begin
      pkt := Punkte( fach, j );
      pkt_sum_zb := pkt_sum_zb + 2*pkt; // LK zählen doppelt
      if pkt < 5 then
      begin
        Inc( FAnzLKDefizit );
        Inc( anz_def_zb );
      end;
      inc( anz_markiert_zb );
      AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
    end;
  end;

  if FAnzLKDefizit > 3 then
  begin
    FMeldungen.Add( 'Keine Zulassung, da die Anzahl der Defizite im Leistungskursbereich überschritten ist.' );
    inc( FFehlerZahl );
    FAbbruch := true;
    FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeLK_Defizite_I];
    exit;
  end;

// Hier noch DEefizite der Abi-GK's?
  M_ := Differenzmenge( W_AF, W_LK );
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    fach := EinzelElement( M_ , i );
    for j := C_Q1 to C_Q4 do
    begin
      pkt := Punkte( fach, j );
      pkt_sum_zb := pkt_sum_zb + pkt;
      if pkt < 5 then
        Inc( anz_def_zb );
      inc( anz_markiert_zb );
      AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
    end;
  end;

// D markieren
  if not AbiD then
  begin
    for i := 1 to AnzahlElemente( W1_1 ) do
    begin
      fach := EinzelElement( W1_1, i );
      slZwangsFaecher.Add( fach );
      AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
      for j := C_Q1 to C_Q4 do
      begin
        pkt := Punkte( fach, j );
        pkt_sum_zb := pkt_sum_zb + pkt;
        if pkt < 5 then
          Inc( anz_def_zb );
      end;
      inc( anz_markiert_zb, 4 );
    end;
  end;

// M markieren
  if not AbiM then
  begin
    for i := 1 to AnzahlElemente( W3_1 ) do
    begin
      fach := EinzelElement( W3_1, i );
      slZwangsFaecher.Add( fach );
      AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
      for j := C_Q1 to C_Q4 do
      begin
        pkt := Punkte( fach, j );
        pkt_sum_zb := pkt_sum_zb + pkt;
        if pkt < 5 then
          Inc( anz_def_zb );
      end;
      inc( anz_markiert_zb, 4 );
    end;
  end;

  FAbiErgebnisVerwalter.WurzelKnotenErzeugen( pkt_sum_zb, anz_def_zb, anz_markiert_zb );

// KNOTEN Ausgabgspunkt
  KnotenStrukturenErzeugen;

  FAbiErgebnisVerwalter.Save( slAbiErgebnisListe );

end;

procedure TAbiturBelegPruefer.MarkierungenPruefen_GY_GE;
var
  anzahl_markiert, anzahl_markiert_def, anzahl_unmarkiert_g4, reli_rest, punkte_markiert: integer;
  durchschnitt: double;

  procedure AnzahlMarkiertBerechnen;
  var
    i, anz, pkt: integer;
    fach: string;
  begin
    anzahl_markiert := 0;
    anzahl_markiert_def := 0;
    anzahl_unmarkiert_g4 := 0;
    durchschnitt := 0;
    anz := 0;
    with FC0 do
    begin
      First;
      while not Eof do
      begin
        fach := FieldByName( 'FachInternKrz' ).AsString;
        for i := C_Q1 to C_Q4 do
        begin
          pkt := FieldByName( Format( 'PU_%d', [i] ) ).AsInteger;
          if FieldByName( Format( 'MA_%d', [i] ) ).AsString = '+' then
          begin
            if InMenge( fach, W_LK ) then
            begin // LK, Punkte doppelt
              inc( anzahl_markiert );
              inc( anz, 2 );
              durchschnitt := durchschnitt + 2*pkt;
            end else
            begin
              inc( anzahl_markiert );
              inc( anz );
              durchschnitt := durchschnitt + pkt;
            end;
            if pkt < 5 then
              inc( anzahl_markiert_def );
          end else
          begin
            if pkt > 4 then
              inc( anzahl_unmarkiert_g4 );
          end;
        end;
        Next;
      end;
    end;

    FAbiturErgebnisse.SummeAnzahlMarkiert := anz;
    FAbiturErgebnisse.SummePunkteMarkiert := trunc( durchschnitt );

    if anzahl_markiert > 0 then
      durchschnitt := durchschnitt / anz;//anzahl_markiert;

  end;

  function KursBesserDurchschnittVorhanden: boolean;
  var
    i, pkt: integer;
    do_check: boolean;
  begin
    Result := false;
    FAbiErgebnisVerwalter.FachAbschnitteLeeren;
    with FC0 do
    begin
      First;
      while not Eof do
      begin
        do_check := true;
// Falls der Projektkurs nicht einerechnet werden darf, muss er ignoriert werden
        if not HatProjektkurs and ( FieldByname( 'FachStatKrz' ).AsString = C_PROJEKTKURS ) then
          do_check := false;
        if do_check then
        begin
          for i := C_Q1 to C_Q4 do
          begin
            do_check := FieldByName( Format( 'MA_%d', [i] ) ).AsString = '-';
            if do_check then
              FAbiErgebnisVerwalter.FachAbschnittHinzu( FieldByName( 'Fach_ID' ).AsInteger, i,
                                                        FieldByName( Format( 'PU_%d', [ i ] ) ).AsInteger );
          end;
        end;
        Next;
      end;
    end;
    FAbiErgebnisVerwalter.KursBesserDurchschnittPruefen( durchschnitt, MuRest, VILI, VPIP );

  end;

  procedure ReliBelegungUndMarkierung( const hjv, hjb: integer; var anz_b, anz_m: integer );
  var
    i,j : integer;
    fach: string;
  begin
    anz_b := 0;
    anz_m := 0;
    for i := 1 to AnzahlElemente( W4 ) do
    begin
      fach := EinzelElement( W4, i );
//      FFuerAbitur := false; // Abschalten, damit 0 Punkte auch als Belegt genommen werden
      for j := hjv to hjb do
      begin
        if IstBelegt1( fach, j, j ) then
          inc( anz_b );
        if IstMarkiert( fach, j ) then
          inc( anz_m );
      end;
//      FFuerAbitur := true;
    end;
  end;

  procedure GSBelegungUndMarkierung( const hjv, hjb: integer; var anz_b, anz_m: integer );
  var
    i,j : integer;
    fach: string;
  begin
    anz_b := 0;
    anz_m := 0;
    for i := 1 to AnzahlElemente( W2 ) do
    begin
      fach := EinzelElement( W2, i );
      for j := hjv to hjb do
      begin
        if IstBelegt( fach, j, j ) then
          inc( anz_b );
        if IstMarkiert( fach, j ) then
          inc( anz_m );
      end;
    end;
  end;


  procedure ReligionsmarkierungPruefen2017;
  var
    M_, fach: string;
    go_on, reli_af, philo_af, gs_af, bel, frage1, frage2, frage3: boolean;
    i, j, anz_rel_b, anz_rel_m, anz_gs_b, anz_gs_m, anz_bel, dummy: integer;

  begin

    M_ := SchnittMenge( W4, W_AF );
    reli_af := not IstLeer( M_ );

    M_ := SchnittMenge( W2_4, W_AF );
    philo_af := not IstLeer( M_ );

    M_ := Vereinigungsmenge( W2_1, W2_2 );
    M_ := Vereinigungsmenge( M_, W2_3 );
    M_ := SchnittMenge( M_, W_AF );
    gs_af := not IstLeer( M_ );

//14	Ist Religionslehre kein Abiturfach und ist Philosophie kein Abiturfach?
    if not reli_af and not philo_af then
    begin
//    J: Wurden zwei Kurse aus der Fächermenge Religionslehre und Philosophie in Q1.1 bis Q2.2 markiert?
      M_ := Vereinigungsmenge( W2_4, W4 );
      anz_bel := 0;
      for i := 1 to AnzahlElemente( M_ ) do
      begin
        fach := EinzelElement( M_, i );
        anz_bel := anz_bel + AnzahlMarkiert( fach, C_Q1, C_Q4 );
      end;
      if anz_bel < 2 then
      begin
        FMeldungen.Add( 'Es müssen zwei Kurse aus der Fächergruppe Religionslehre und Philosophie markiert werden.' );
        FAbbruch := true;
        exit;
      end;
    end;

// Ist Religion kein Abiturfach und ist Philosophie Abiturfach und jedes andere geselschaftswissenschaftliche Fach kein Abiturfach
    go_on := not reli_af and philo_af and not gs_af;
    if not go_on then
      exit;


// Prüfe Belegung Reli in Q1.1 bis Q1.2
    ReliBelegungUndMarkierung( C_Q1, C_Q2, anz_rel_b, dummy );
    ReliBelegungUndMarkierung( C_Q1, C_Q4, dummy, anz_rel_m );


//  J: Wurde Religion in Q1.1 und Q1.2 belegt?
    if anz_rel_b = 2 then
    begin
//    J: Wurden mindestens zwei Reli-Kurse in Q1.1 bis Q2.2 markiert?
      if anz_rel_m >= 2 then
      begin
//      J: Weiter
        exit;
      end else
      begin
//      N: Es müssen zwei Kurse Religionslehre markiert werden
        FMeldungen.Add( 'Es müssen zwei Kurse Religionslehre markiert werden.' );
        FAbbruch := true;
        exit;
      end;
    end else
    begin
//  N: Wurde ein Kurs Religionslehre in Q1.1 oder Q1.2 belegt
      if anz_rel_b = 1 then
      begin
//      J: Wurden mindestens zwei Kurse Religionslehre in Q1.1 bis Q2.2 markiert? oder
//         Wurde ein Kurs Religionslehre in Q1.1 bis Q2.2 und wurden mindestens 9 Kurse aller gesellschaftswissenschaftlichen Fächer (auch Zusatzkurse),
//         in Q1.1. bis Q2.2 markiert?
        ReliBelegungUndMarkierung( C_Q1, C_Q4, anz_rel_b, anz_rel_m );
        GSBelegungUndMarkierung( C_Q1, C_Q4, anz_gs_b, anz_gs_m );
        if ( anz_rel_m >= 2 ) or ( ( anz_rel_m >= 1 ) and ( anz_gs_m >= 9 ) ) then
        begin
//        J: Weiter
          exit;
        end else
        begin
//        N:
          FMeldungen.Add( 'Es müssen zwei Kurse Religionslehre oder ein Kurs Religionslehre und ein Kurs des Ersatzfaches markiert werden.' );
          FAbbruch := true;
        end;
      end else
      begin
//      15a ii 2
//      N: Wurden zwei Kurse Religionslehre in Q2.1 bis Q2.2 markiert? oder
//      Wurden ein Kurs Religionslehre in Q2.1 bis Q2.2 und wurden mindestens 9 Kurse aller gesellschaftswissenschaftlichen Fächer (auch zusatzkurse)
//      markiert? oder
//      Wurden mindestens 10 Kurse aller gesellschaftswissenschaftlichen Fächer (auch Zusatzkurse) markiert?
        ReliBelegungUndMarkierung( C_Q3, C_Q4, anz_rel_b, anz_rel_m );
        GSBelegungUndMarkierung( C_Q1, C_Q4, anz_gs_b, anz_gs_m );
        frage1 := anz_rel_m >= 2;
        frage2 := ( anz_rel_m >= 1 ) and ( anz_gs_m >= 9 );
        frage3 := anz_gs_m >= 10;
        if frage1 or frage2 or frage3 then
        begin
//        J: Weiter
          exit;
        end else
        begin
          FMeldungen.Add( 'Es müssen zwei Kurse Religionslehre oder ein Kurs Religionslehre und ein Kurs des Ersatzfaches oder zwei Kurse des Ersatzfaches markiert werden.' );
          FAbbruch := true;
        end;
      end;
    end;
  end;




var
  i, j, pkt, anzahl, anzahl_ges: integer;
  M_, M1_, M2_, FS_, FS_fach, NW_, fach, fach1, statkrz, fs_des_faches: string;
  is_ok, is_b, is_m, mu_abi12, mu_abi34: boolean;
  keineWeitereFS, keineWeitereNW, schr: boolean;
  w6_andere_FS: string;
begin
//1.	Zähle die Anzahl an markierten Kursen aus {LK} mit Punkten <5. Ist die Anzahl >3?
// LK Defizite ermitteln
  FAnzLKDefizit := 0;
  for i := 1 to AnzahlElemente( W_LK ) do
  begin
    fach := EinzelElement( W_LK, i );
    for j := C_Q1 to C_Q4 do
    begin
      pkt := Punkte( fach, j );
      if pkt < 5 then
        Inc( FAnzLKDefizit );
    end;
  end;

  if FAnzLKDefizit > 3 then
  begin
    FMeldungen.Add( 'Die Anzahl der Defizite im Leistungskursbereich ist überschritten.' );
    FAbbruch := true;
    exit;
  end;

//2.	Schleife über alle {AF}: Existiert ein AF-Kurs mit 0 Punkten
  for i := 1 to AnzahlElemente( W_AF ) do
  begin
    fach := EinzelElement( W_AF, i );
    for j := C_Q1 to C_Q4 do
    begin
      pkt := Punkte( fach, j );
      if pkt = 0 then
      begin
        FMeldungen.Add( 'Abitur-Kurse mit Null Punkten gelten als nicht belegte Kurse.' );
        FAbbruch := true;
        exit;
      end;
    end;
  end;

//3.	Schleife über alle {AF}: Wurden jeweils vier Kurse in Q1.1 bis Q2.2 markiert
  is_ok := true;
  for i := 1 to AnzahlElemente( W_AF ) do
  begin
    fach := EinzelElement( W_AF, i );
    is_ok := is_ok and ( AnzahlMarkiert( fach, C_Q1, C_Q4 ) = 4 );
    if not is_ok then
    begin
      FMeldungen.Add( 'Es müssen alle Abiturfächer durchgehend markiert werden.' );
      FAbbruch := true;
      break;
    end;
  end;

//4.	Suche in {W1.1}: Wurden vier Kurse in Q1.1 bis Q2.2 markiert?
  anzahl := 0;
  for i := 1 to AnzahlElemente( W1_1 ) do
  begin
    fach := EinzelElement( W1_1, i );
    anzahl := anzahl + AnzahlMarkiert( fach, C_Q1, C_Q4 );
  end;

  if anzahl < 4 then
  begin
    FMeldungen.Add( 'Deutsch muss durchgehend markiert werden.' );
    FAbbruch := true;
  end;

//5.  Suche in {W1.2 und W1.3}: Wurde ein Fach FS durchgehend in Q1.1 bis Q2.2 markiert?
// NEU: Alle Fächer in FS_ speoichern
  M_ := Vereinigungsmenge( W1_2, W1_3 );
  is_b := false;
  is_m := false;
  FS_ := '';
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    fach := EinzelElement( M_, i );
    is_ok := ( AnzahlMarkiert( fach, C_Q1, C_Q4 ) = 4 );
    if is_ok then
      ZuMengeHinzu( FS_, fach );
  end;

  if FS_ = '' then
  begin
    FMeldungen.Add( 'Es muss eine Fremdsprache durchgehend markiert werden.' );
    FAbbruch := true;
  end;

//6.	Wurde ein Fach1 aus {W1.2 und W1.3} durchgehend belegt und von Q1.1 bis Q2.1 schriftlich belegt
//und ein weiteres Fach aus {W1.2 U W1.3 U W6 einer anderen Sprache als Fach1 / Fach1}
//durchgehend belegt und von Q1.1 bis Q2.1 schriftlich belegt?
//a.	Ja:   Schleife über alle FS: Suche in {W1.2 und W1.3 und W6 einer anderen Sprache
//          als FS / FS}: Wurde ein durchgeend schriftlich belegtes Fach in Q2.1 und Q2.2
//          markiert?
//              i: Ja: Weiter (JR: d.h. Schleifenabbruch)
//              ii: Nein: Schleifenschritt weiter. Falls Ende der Schleife: Setze Variable "keineWeitereFS=true"
//b.  Nein: Setze "keineWeitereFS=true"

  keineWeitereFS := false;
  M_ := Vereinigungsmenge( W1_2, W1_3 ); // Die Fremdsprachen
  is_ok := false;
  for i := 1 to AnzahlElemente( M_ ) do
  begin // Schleife über die Fremdsprachen
    fach1 := EinzelElement( M_, i );

//1. Prüfung: Wurde ein Fach1 aus {W1.2 und W1.3} durchgehend belegt und von Q1.1 bis Q2.1 schriftlich belegt?
    if IstBelegtPunkte1( fach1, C_Q1, C_Q4 ) and IstSchriftlich1( fach1, C_Q1, C_Q3 ) then
    begin
// 2. Prüfung: und ein weiteres Fach aus {W1.2 U W1.3 U W6 einer anderen Sprache als Fach1 / Fach1}
//durchgehend belegt und von Q1.1 bis Q2.1 schriftlich belegt?
      fs_des_faches := Fremdsprachen_Suffix_Ermitteln( fach1 );// das "neutrale" Sprachkürzel
      w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches ); // die Fremdsprachen der Sachfächer ohne fach1

      M1_ := VereinigungsMenge( M_, w6_andere_fs );
      M1_ := Differenzmenge( M1_, fach1 );
      for j := 1 to AnzahlElemente( M1_ ) do
      begin
        fach := EinzelElement( M1_, j );
        if IstBelegtPunkte1( fach, C_Q1, C_Q4 ) and IstSchriftlich1( fach, C_Q1, C_Q3 ) then
        begin
          is_ok := true; //AnzahlMarkiert( fach, C_Q3, C_Q4 ) = 2;
          if is_ok then
            break;
        end;
      end;
    end;
    if is_ok then
      break;
  end;


  if is_ok then
  begin
//a.	Ja:   Schleife über alle FS: Suche in {W1.2 und W1.3 und W6 einer anderen Sprache
//          als FS / FS}: Wurde ein durchgeend schriftlich belegtes Fach in Q2.1 und Q2.2
//          markiert?
//              i: Ja: Weiter (JR: d.h. Schleifenabbruch)
//              ii: Nein: Schleifenschritt weiter. Falls Ende der Schleife: Setze Variable "keineWeitereFS=true"
    is_ok := false;
    M_ := Vereinigungsmenge( W1_2, W1_3 ); // Die Fremdsprachen
    for i := 1 to AnzahlElemente( M_ ) do
    begin
      FS_fach := EinzelElement( M_, i );
// NEU 1.4.2015: Wurde das konkrete Fach in Q1 und Q2 markiert?
      if AnzahlMarkiert( FS_fach, C_Q1, C_Q4 ) <> 4  then
        continue;

      M1_ := Vereinigungsmenge( W1_2, W1_3 );
      fs_des_faches := Fremdsprachen_Suffix_Ermitteln( FS_fach );// das "neutrale" Sprachkürzel
      w6_andere_fs := W6_mit_anderer_FS_als( fs_des_faches ); // die Fremdsprachen der Sachfächer ohne fach1
      M1_ := Vereinigungsmenge( M1_, w6_andere_fs );
      M1_ := Differenzmenge( M1_, FS_fach );

      for j := 1 to AnzahlElemente( M1_ ) do
      begin
        fach := EinzelElement( M1_, j );

        if IstSchriftlich1( fach, C_Q1, C_Q3 ) and ( AnzahlMarkiert( fach, C_Q3, C_Q4 ) = 2 ) then
// NEU: 8.4.2015: Anzahl Markiert von C_Q1, bis C_Q2
//        if IstSchriftlich1( fach, C_Q1, C_Q3 ) and ( AnzahlMarkiert( fach, C_Q1, C_Q2 ) = 2 ) then
        begin
          is_ok := true;
          break;
        end;
      end;
      if is_ok then
        break;
    end;
    if not is_ok then
      keineWeitereFS := true;
  end else
//b.  Nein: Setze "keineWeitereFS=true"
    keineWeitereFS := true;

//7.	Wurde in der Sek I eine 2. Fremdsprache ab Klasse G8:5/6 ?
  is_ok := FSchueler.FS2_SekI_manuell or ( AnzahlElemente( FSchueler.S1_Sprachen_5_6 ) > 1 );
  if not is_ok then
  begin
//b.	Nein: Wurde in der Sek I eine 2. Fremdsprache ab Klasse G8:8 belegt und
//diese Fremdsprache in EF.1 und EF.2 schriftlich belegt?
//    if FSchueler.S1_Sprachen_8 <> '' then
    begin
      for i := 1 to AnzahlElemente( FSchueler.S1_Sprachen_8 ) do
      begin
        fach := FremdspracheFinden( Einzelelement( FSchueler.S1_Sprachen_8, i ) );
        if fach <> '' then
        begin
          is_ok := IstSchriftlich( fach, 1, 2 );
          if is_ok then
            break;
        end;
      end;
//ii.	Fall Nein: Suche in {W1.3}: Wurde ein "durchgehend schriftlich belegtes" Fach in Q2.1 und Q2.2 markiert?
      if not is_ok and ( W1_3 <> '' ) then  // Fremdsprache aus 8 nicht schriftlich, prüfe neu einsetzende FS
      begin
        is_ok := GruppeSchriftlich( W1_3, C_Q1, C_Q3, false ); // durchgehend schriftlich?
        if is_ok then
        begin
          for i := 1 to AnzahlElemente( W1_3 ) do
          begin
            fach := EinzelElement( W1_3, i );
            is_ok := AnzahlMarkiert( fach, C_Q3, C_Q4 ) = 2; // Markierung in Q2.1 und Q2.2 vorhanden?
            if is_ok then
              break;
          end;
        end;
      end;
    end;

    if not is_ok then
    begin
      FMeldungen.Add( 'Um die zweite Fremdsprache nachzuweisen, müssen zwei Kurse einer neueinsetzenden Fremdsprache in Q2 markiert werden.' );
      FAbbruch := true;
    end;
  end;

//8.	Suche in {W1.4 und W1.5}: Wurden zwei Kurse "eines Faches" in Q1.1 bis Q2.2 markiert?
  anzahl := 0;
  M_ := Vereinigungsmenge( W1_4, W1_5 );
  is_ok := false;
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    fach := EinzelElement( M_, i );
    anzahl := AnzahlMarkiert( fach, C_Q1, C_Q4 );
    is_ok := is_ok or ( anzahl >= 2 );
  end;

  if not is_ok then
  begin
    FMeldungen.Add( 'Es müssen zwei Kurse Musik oder Kunst oder Literatur oder instrumentalpraktischer bzw. vokalpraktischer Grundkurs markiert werden.' );
    FAbbruch := true;
  end;

// NEU 23.11.2012
//  9. Suche in W1.5: Wurden mehr als zwei Kurse markiert?
  M_ := W1_5;
  anzahl := 0;
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    fach := EinzelElement( M_, i );
    anzahl := anzahl + AnzahlMarkiert( fach, C_Q1, C_Q4 );
  end;
  if anzahl > 2 then
  begin
    FMeldungen.Add( 'Es dürfen insgesamt maximal zwei Kurse der Fächer Literatur, vokalpraktisches Fach, instrumentalpraktisches Fach markiert werden.' );
    FAbbruch := true;
  end;

//10.	Zähle die Anzahl der markierten Kurse in dem Fach Musik, IV
  M_ := Vereinigungsmenge( W1_4, W1_6 );// kann MU, KU und IV enthalten
// Erst mal eine Menge bilden, die nur MU und IV enthält
  mu_abi12 := false;
  mu_abi34 := false;
  anzahl := 0;
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    fach := EinzelElement( M_, i );
    statkrz := StatistikKuerzel( fach );
    if ( statkrz = 'LI' ) or ( statkrz = 'KU' ) then
      AusMengeLoeschen( M_, fach )
    else
    begin
      if statkrz = 'MU' then
      begin
        if InMenge( fach, W_LK ) then
          mu_abi12 := true
        else if InMenge( fach, W_AF ) then
          mu_abi34 := true;
      end;
      anzahl := anzahl + AnzahlMarkiert( fach, C_Q1, C_Q4 );
    end;
  end;

  if mu_abi12 then
  begin
    if ( anzahl > 4 ) then
    begin
      FMeldungen.Add( 'Wenn Musik als Leistungskurs belegt wurde, dürfen keine weiteren Kurse vokalpraktisches Fach oder instrumentalpraktisches Fach markiert werden.' );
      FAbbruch := true;
    end;
  end else if mu_abi34 then
  begin
    if ( anzahl > 6 ) then
    begin
      FMeldungen.Add( 'Wenn Musik als drittes oder viertes Abiturfach belegt wurde, dürfen nicht mehr als zwei Kurse vokalpraktisches Fach oder instrumentalpraktisches Fach markiert werden.' );
      FAbbruch := true;
    end;
  end else if anzahl > 5 then
  begin
    FMeldungen.Add( 'Es dürfen nicht mehr als fünf Kurse Musik, vokalpraktisches Fach oder instrumentalpraktisches Fach markiert werden.' );
    FAbbruch := true;
  end;


//11. Suche in {W2.1 inkl ZK}: Wurden zwei Kurse Geschichte in Q1.1 bis Q2.2 markiert?
  is_m := false;
  for i := 1 to AnzahlElemente( W2_1 ) do
  begin
    fach := EinzelElement( W2_1, i );
    is_m := is_m or ( AnzahlMarkiert( fach, C_Q1, C_Q4 ) >= 2 );
  end;

  if not is_m then
  begin
    FMeldungen.Add( 'Es müssen zwei Kurse Geschichte markiert werden.' );
    FAbbruch := true;
  end;

//12. Suche in {W2.2 inkl ZK}: Wurden zwei Kurse Sowi in Q1.1 bis Q2.2 markiert?
  is_m := false;
  for i := 1 to AnzahlElemente( W2_2 ) do
  begin
    fach := EinzelElement( W2_2, i );
    is_m := is_m or ( AnzahlMarkiert( fach, C_Q1, C_Q4 ) >= 2 );
  end;

  if not is_m then
  begin
    FMeldungen.Add( 'Es müssen zwei Kurse Sozialwissenschaften markiert werden.' );
    FAbbruch := true;
  end;

//13.	Suche in {W2}: Wurde ein Fach durchgehend von Q1.1 bis Q2.2 markiert
  is_ok := false;
  for i := 1 to AnzahlElemente( W2 ) do
  begin
    fach := EinzelElement( W2, i );
    is_ok := is_ok or ( AnzahlMarkiert( fach, C_Q1, C_Q4 ) = 4 );
  end;

  if not is_ok then
  begin
    FMeldungen.Add( 'Es muss ein gesellschaftswissenschaftliches Fach durchgehend markiert werden.' );
    FAbbruch := true;
  end;

// REli
// 14. und 15
  ReligionsmarkierungPruefen2017;

//14.	Suche in {W3.1}: Wurden vier Kurse in Q1.1 bis Q2.2 markiert?
  anzahl := 0;
  for i := 1 to AnzahlElemente( W3_1 ) do
  begin
    fach := EinzelElement( W3_1, i );
    anzahl := anzahl + AnzahlMarkiert( fach, C_Q1, C_Q4 );
  end;

  if anzahl < 4 then
  begin
    FMeldungen.Add( 'Mathematik muss durchgehend markiert werden.' );
    FAbbruch := true;
  end;

//15.	Suche in {W3.2}: Wurde ein Fach NW durchgehend von Q1.1 bis Q2.2 markiert?
  M_ := W3_2;
  is_ok := false;
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    fach := EinzelElement( M_, i );
    is_ok := ( AnzahlMarkiert( fach, C_Q1, C_Q4 ) = 4 );
    if is_ok then
    begin
      NW_ := fach;
      break;
    end;
  end;

  if not is_ok then
  begin
    FMeldungen.Add( 'Es muss ein klassisches naturwissenschaftliches Fach durchgehend markiert werden.' );
    FAbbruch := true;
  end;

//18.	Wurde ein Fach1 in {W3.2 U W3.3} durchgehend belegt und von Q1.1 bis Q2.1 durchgehend schriftlich belegt
//    und wurde ein weiteres Fach in {W3.2 U W3.3 / Fach1} durchgehend belegt?
//a.	Ja: Suche in {W3.2 und W3.3 / NW} : Wurde ein Fach in Q2.1 und Q2.2 markiert?
//i.	Ja: Weiter
//ii.	Nein: Setze Variable „keineWeitereNW = True“
//b.	Nein: Setze Variable „keineWeitereNW = True“
  keineWeitereNW := false;

  M_ := Vereinigungsmenge( W3_2, W3_3 );
  is_ok := false;
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    fach := EinzelElement( M_, i );
//Wurde ein Fach1 aus {W3.2 und W3.3} durchgehend belegt und von Q1.1 bis Q2.1 schriftlich belegt
    if IstBelegtPunkte1( fach, C_Q1, C_Q4 ) and IstSchriftlich1( fach, C_Q1, C_Q3 ) then
    begin
//und ein weiteres Fach aus {W3.2 U W3.3 / Fach1} durchgehend belegt
      M1_ := Differenzmenge( M_, fach );
      for j := 1 to AnzahlElemente( M1_ ) do
      begin
        fach := EinzelElement( M1_, j );
        if IstBelegtPunkte1( fach, C_Q1, C_Q4 ) then
        begin
          is_ok := true;
          break;
        end;
      end;
    end;
    if is_ok then
      break;
  end;

  if is_ok then
  begin // a) Suche in  {W3.2 und W3.3 / NW}: Wurde ein Fach in Q2.1 und Q2.2 markiert?
    is_ok := false;
    M_ := Vereinigungsmenge( W3_2, W3_3 );
    M_ := Differenzmenge( M_, NW_ );
    for i := 1 to AnzahlElemente( M_ ) do
    begin
      fach := EinzelElement( M_, i );
      if AnzahlMarkiert( fach, C_Q3, C_Q4 ) = 2 then
      begin
        is_ok := true;
        break;
      end;
    end;
    if not is_ok then
      keineWeitereNW := true;
  end else
    keineWeitereNW := true;


//19.	Ist keineWeitereFS = True und keineWeitereNW = True?
  if keineWeitereFS and keineWeitereNW then
  begin
    FMeldungen.Add( 'Es müssen zwei Kurse einer Naturwissenschaft oder einer schriftlich belegten weitere Fremdsprache in Q2.1 und Q2.2 markiert werden.' );
    FAbbruch := true;
  end;

  if ( FSchueler.BLL_Art = 'P' ) and ( W_PF = '' ) then
  begin
    FMeldungen.Add( 'Ein Projektkurs soll als besondere Lernleistung in das Abitur eingebracht werden, es wurde aber kein Projektkurs belegt' );
    FAbbruch := true;
  end;


  if W_PF <> '' then
  begin
// Hier vorgezogen: 29.	Soll der Projektkurs als besondere Lernleistung eingehen und wurde der Projektkurs markiert?
    if ( FSchueler.BLL_Art = 'P' ) then
    begin // Projektkurs soll al besondere LL gerechnet werden
      M_ := W_PF;
      anzahl := 0;
      for i := 1 to AnzahlElemente( M_ ) do
      begin
        fach := EinzelElement( M_, i );
        anzahl := anzahl + AnzahlMarkiert( fach, C_Q1, C_Q4 );
      end;
      if anzahl > 0 then
      begin
        FMeldungen.Add( 'Wenn der Projektkurs als besondere Lernleistung in das Abitur eingebracht werden soll, so darf er nicht für Block I markiert werden.' );
        FAbbruch := true;
      end;
    end else
    begin
  //18.	Wurde genau ein Projektkurs in Q1.1 bis Q2.2 markiert?
      anzahl := 0;
      for i := 1 to AnzahlElemente( W_PF ) do
      begin
        fach := EinzelElement( W_PF, i );
        anzahl := anzahl + AnzahlMarkiert( fach, C_Q1, C_Q4 );
      end;
      if not ( anzahl in [ 0, 2 ] ) then
      begin
        FMeldungen.Add( 'Es müssen immer beide Halbjahre des Projektkurses markiert werden.' );
        FAbbruch := true;
      end;
    end;
  end;

  AnzahlMarkiertBerechnen;

// 19.	G8: Wurden 35 bis 40 Kurse markiert?
//    if not Between( anzahl_markiert, 35, 40 ) then
  if not Between( anzahl_markiert, C_MIN_KURSE_GY_G8, C_MAX_KURSE_GY_G8 ) then
  begin
    FMeldungen.Add( 'Es müssen mindestens 35 und dürfen höchstens 40 Kurse markiert werden.' );
    FAbbruch := true;
  end;
  if Between( anzahl_markiert, 35, 37 ) then
  begin // 21.	G8: Wurden 35-37 Kurse markiert?
//a.	Ja:  Zähle die Anzahl an markierten Kursen mit Punkten <5. Ist die Anzahl >7?
    if anzahl_markiert_def > 7 then
    begin
      if anzahl_markiert_def = 8 then
      begin // Existiert ein weiterer nicht markierter Kurs mit mehr als 4 Punkten?
        if anzahl_unmarkiert_g4 > 0 then
        begin // Bei acht markierten Defiziten muss ein weiterer Kurs ohne Defizit markiert werden
          FMeldungen.Add( 'Bei acht markierten Defiziten muss ein weiterer Kurs ohne Defizit markiert werden.' );
          FAbbruch := true;
        end else
        begin
          FMeldungen.Add( 'Es wurden zu viele Kurse mit Defizit markiert.' );
          FAbbruch := true;
        end;
      end else
      begin
        FMeldungen.Add( 'Es wurden zu viele Kurse mit Defizit markiert.' );
        FAbbruch := true;
      end;
    end;
  end else if Between( anzahl_markiert, 38, 40 ) then
  begin // 22.	G8: Wurden 38-40 Kurse markiert?
//a.	Ja:  Zähle die Anzahl an markierten Kursen mit Punkten <5. Ist die Anzahl >8?
    if anzahl_markiert_def > 8 then
    begin
      FMeldungen.Add( 'Es wurden zu viele Kurse mit Defizit markiert.' );
      FAbbruch := true;
    end;
  end;
  if ( anzahl_markiert < 40 ) and not FAbbruch then
  begin
// Berechne die Durchschnittspunkte D aller markierten Kurse. Zähle LK-Kurse und LK-Punkte dabei doppelt.
// Existiert unter den nicht markierten Kursen ein Kurs mit Punkten > D?
    if KursBesserDurchschnittVorhanden then
    begin
      FMeldungen.Add( 'Es existieren eventuell nicht markierte Kurse, die durch Markierung die Gesamtpunktzahl in Block I verbessern könnten.' );
    end;
  end;
end;

procedure TAbiturBelegPruefer.MarkierungenPruefen_BK;
begin
  FAbbruch := false;
end;

procedure TAbiturBelegPruefer.Block_I_Berechnen;
var
  i: integer;
  pfld, kfld, mark: string;
  pkt, pkt_sum, anz_sum: integer;
  minKurse, maxKurse: integer;
  fach: string;
begin
  pkt_sum := 0;
  anz_sum := 0;
// Aufsummieren
  with FC0 do
  begin
    First;
    while not Eof do
    begin
      fach := FieldByname( 'FachInternKrz' ).AsString;
      for i := C_Q1 to C_Q4 do
      begin
        pfld := Format( 'PU_%d', [ i ] );
        mark := FieldByname( Format( 'MA_%d', [ i ] ) ).AsString;
        pkt := PunktzahlNumEx( FieldByName( pfld ).AsString );
        if pkt = 0 then
          inc( FAbiturErgebnisse.Kurszahl_I_0_Pkt );
        if mark <> '-' then
        begin // Ist markiert
          inc( FAbiturErgebnisse.Kurszahl_I );
          kfld := Format( 'KA_%d', [ i ] );
//          kfld := 'KA_6'; // NEU: nehme als Kursart nur noch den letzten Abschnitt
          if ( FieldByName( kfld ).AsString = 'LK' ) then
          begin
            inc( FAbiturErgebnisse.Kurszahl_I_LK, 2 );
            inc( anz_sum, 2 );
            pkt_sum := pkt_sum + 2*pkt;
            inc( FAbiturErgebnisse.Punktsumme_LK, 2*pkt);
            if pkt < C_DEFIZIT_GRENZE then
              inc( FAbiturErgebnisse.LK_Defizite_I );
          end else
          begin
            inc( FAbiturErgebnisse.Kurszahl_I_GK );
            inc( anz_sum );
            pkt_sum := pkt_sum + pkt;
            inc( FAbiturErgebnisse.Punktsumme_GK, pkt );
          end;
          if pkt < C_DEFIZIT_GRENZE then
            inc( FAbiturErgebnisse.Defizite_I );
        end;
      end;
      if ( FSchulform = 'BK' ) then
      begin
        if FieldByName( 'MA_FA' ).AsString = '+' then
        begin
//          inc( FAbiturErgebnisse.Kurszahl_I, 2 );
//          inc( FAbiturErgebnisse.Kurszahl_I_GK, 2 );
// NEU: Zahl nur um 1 erhöhen
          inc( FAbiturErgebnisse.Kurszahl_I );
          inc( FAbiturErgebnisse.Kurszahl_I_GK );

          pkt := FieldByName( 'PU_FA' ).AsInteger;
          inc( anz_sum, 2 );
          pkt_sum := pkt_sum + 2*pkt;
          if pkt = 0 then
            inc( FAbiturErgebnisse.Kurszahl_I_0_Pkt );
        end;
      end;
      Next;
    end;
  end;

  if ( FSchulform = 'GY' ) or ( FSchulform = 'GE' ) then
  begin
    minKurse := C_MIN_KURSE_GY_G8;
    maxKurse := C_MAX_KURSE_GY_G8;
  end else if ( FSchulform = 'BK' ) then
  begin
    minKurse := C_MIN_KURSE_BK;
    maxKurse := C_MAX_KURSE_BK;
  end else if FSchulform = 'WB' then
  begin
    if FGliederung = 'KL' then
    begin
      minKurse := C_MIN_KURSE_WB_KL;
      maxKurse := C_MAX_KURSE_WB_KL;
    end else
    begin
      minKurse := C_MIN_KURSE_WB_AG;
      maxKurse := C_MAX_KURSE_WB_AG;
    end;
  end;

  if Between( FAbiturErgebnisse.Kurszahl_I, minKurse, maxKurse ) and ( anz_sum > 0 ) then
  begin
    FAbiturErgebnisse.Punktsumme_I := Trunc( Runden( 40*pkt_sum / anz_sum ) );
//    if FBLL_Punkte > 0 then
//      FAbiturErgebnisse.Punktsumme_I := FAbiturErgebnisse.Punktsumme_I + 4*FBLL_Punkte;
    FAbiturErgebnisse.Durchschnitt_I := Runden( pkt_sum / anz_sum, 2 );//Abrunden( pkt_sum / anz_sum, 2 );//RoundTo( pkt_sum / anz_sum, -2 );
  end else if ( FSchulform = 'BK' ) then
  begin
    if anz_sum > 0 then
      FAbiturErgebnisse.Punktsumme_I := Trunc( Runden( 40*pkt_sum / anz_sum ) )
    else
      FAbiturErgebnisse.Punktsumme_I := 0;
  end;


  if FAbiturErgebnisse.Punktsumme_I = 0 then
    FAbiturErgebnisse.Farbe_Punktsumme_I := C_ABBRUCH_FARBE
  else if Between( FAbiturErgebnisse.Punktsumme_I, 1, 199 ) then
  begin
    FAbiturErgebnisse.Farbe_Punktsumme_I := C_FEHLER_FARBE;
    FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeZuWenigPunkte_I];
    FMeldungen.Add( 'Die Punktsumme der markierten Kurse muss >= 200 sein.' );
  end;

  if not Between( FAbiturErgebnisse.Kurszahl_I, minKurse, maxKurse ) then
  begin
    FAbiturErgebnisse.Farbe_Anzahl_I := C_FEHLER_FARBE;
    FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeZuWenigKurse_I];
  end;

  if FAbiturErgebnisse.LK_Defizite_I > 3 then
  begin
    FAbiturErgebnisse.Farbe_LK_Defizite_I := C_FEHLER_FARBE;
    FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeLK_Defizite_I];
  end else if FAbiturErgebnisse.LK_Defizite_I > 0 then
    FAbiturErgebnisse.Farbe_LK_Defizite_I := C_WARN_FARBE;


  if ( FSchulform = 'GY' ) or ( FSchulform = 'GE' ) then
  begin // Defizite in Abh von der Kurszahl
    if Between( FAbiturErgebnisse.Kurszahl_I, 35, 37 ) then
    begin // G8: Wurden 35-37 Kurse markiert?
//a.	Ja:  Zähle die Anzahl an markierten Kursen mit Punkten <5. Ist die Anzahl >7?
      if FAbiturErgebnisse.Defizite_I > 7 then
      begin
        FAbiturErgebnisse.Farbe_Defizite_I := C_FEHLER_FARBE;
        FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeDefizite_I];
        FMeldungen.Add( 'Defizitanzahl in Block I überschritten.' );
      end else if FAbiturErgebnisse.Defizite_I > 0 then
        FAbiturErgebnisse.Farbe_Defizite_I := C_WARN_FARBE;
    end else if Between( FAbiturErgebnisse.Kurszahl_I, 38, 40 ) then
    begin // 24.	G8: Wurden 38-40 Kurse markiert?
//a.	Ja:  Zähle die Anzahl an markierten Kursen mit Punkten <5. Ist die Anzahl >8?
      if FAbiturErgebnisse.Defizite_I > 8 then
      begin
        FAbiturErgebnisse.Farbe_Defizite_I := C_FEHLER_FARBE;
        FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeDefizite_I];
        FMeldungen.Add( 'Defizitanzahl in Block I überschritten.' );
      end else if FAbiturErgebnisse.Defizite_I > 0 then
        FAbiturErgebnisse.Farbe_Defizite_I := C_WARN_FARBE;
    end;

  end else if ( FSchulform = 'BK' ) then
  begin
    if FMarkiert_FA then
    begin
      FAbiturErgebnisse.Kurszahl_I := FAbiturErgebnisse.Kurszahl_I - 1;
      if ( FPunkte_FA < C_DEFIZIT_GRENZE ) and ( FAbiturErgebnisse.Defizite_I > 0 ) then
        FAbiturErgebnisse.Defizite_I := FAbiturErgebnisse.Defizite_I - 1;
    end;
    if not Defizite_OK_BK( FAbiturErgebnisse.Kurszahl_I, FAbiturErgebnisse.Defizite_I, FAbiturErgebnisse.LK_Defizite_I ) then
    begin
      FAbiturErgebnisse.Farbe_Defizite_I := C_FEHLER_FARBE;
      FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeDefizite_I];
      FMeldungen.Add( 'Defizitanzahl in Block I überschritten.' );
    end;
    if FAnzahl_0_Punkte > 0 then
      FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse - [aeZugelassen] + [ aeNichtZugelassen];

  end else if ( FSchulform = 'WB' ) then
  begin // Defizite in Abh von der Kurszahl
    if Between( FAbiturErgebnisse.Kurszahl_I, 28, 32 ) then
    begin // Wurden 28-32 Kurse markiert?
//a.	Ja:  Zähle die Anzahl an markierten Kursen mit Punkten <5. Ist die Anzahl >7?
      if FAbiturErgebnisse.Defizite_I > 6 then
      begin
        FAbiturErgebnisse.Farbe_Defizite_I := C_FEHLER_FARBE;
        FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeDefizite_I];
        FMeldungen.Add( 'Defizitanzahl in Block I überschritten.' );
      end else if FAbiturErgebnisse.Defizite_I > 0 then
        FAbiturErgebnisse.Farbe_Defizite_I := C_WARN_FARBE;
    end else if Between( FAbiturErgebnisse.Kurszahl_I, 33, 34 ) then
    begin //  Wurden 33-34 Kurse markiert?
//a.	Ja:  Zähle die Anzahl an markierten Kursen mit Punkten <5. Ist die Anzahl >7?
      if FAbiturErgebnisse.Defizite_I > 7 then
      begin
        FAbiturErgebnisse.Farbe_Defizite_I := C_FEHLER_FARBE;
        FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeDefizite_I];
        FMeldungen.Add( 'Defizitanzahl in Block I überschritten.' );
      end else if FAbiturErgebnisse.Defizite_I > 0 then
        FAbiturErgebnisse.Farbe_Defizite_I := C_WARN_FARBE;
    end;
  end;

  if FAbiturErgebnisse.Ergebnisse = [] then
    FAbiturErgebnisse.Ergebnisse := [aeZugelassen];

{  if aeZugelassen in FAbiturErgebnisse.Ergebnisse then
    FMeldungen.Add( 'Ergebnis: Zur Abiturprüfung zugelassen' )
  else
    FMeldungen.Add( 'Ergebnis: Keine Zulassung zur Abiturprüfung' );}

end;


procedure TAbiturBelegPruefer.Block_II_Berechnen;
var
  sum_ber: double;
  abinote: double;

  function Abiturformel( const psum: integer ): double;
  begin
    if psum = 300 then
      Result := 4
    else if psum < 300 then
      Result := 4.1
    else if psum >= 823 then
      Result := 1
    else
      Result := Abrunden( 17/3 - psum/180, 1 );
  end;

  function PunktSprung( const abi_note, diff: double; psum: Integer ): integer;
  var
    pkt: integer;
    an: Double;
  begin
    if psum = 300 then
    begin
      Result := 1;
      exit;
    end else if psum < 300 then
    begin
      Result := 300 - psum;
      exit;
    end;

    Result := psum;
    repeat
      if diff < 0 then
        inc( Result ) // bei Notenänderung in bessere Richtung punkte erhöhen
      else
        dec( Result ); // sonst Punkte erniedrigen
      an := Abiturformel( Result );
    until
      an <> abi_note;
    Result := Result - psum;
  end;

  function AbiLeistungenVollstaendig: boolean;
  begin
    Result := not ( aeFehlendeAbiLeistungen in FAbiturErgebnisse.Ergebnisse ) and
              not ( aeFehlendeZusAbiLeistungen in FAbiturErgebnisse.Ergebnisse );
  end;

  procedure MdlPruefungAuswirkungTesten( const alle: boolean );
  var
    pkt_sum, pkt: double;
    abif, mdl_pkt: integer;
  begin
    pkt_sum := 0;
    with FAbiturdaten do
    begin
      First;
      while not Eof do
      begin
        pkt := FachAbiPunktSumme( FieldByname( 'Fach_ID' ).AsInteger, alle or ( FieldByName( 'MdlZusatzPruefung' ).AsString = 'A' ){true} );
        pkt_sum := pkt_sum + pkt;
        Next;
      end;
      First;
    end;
    if FSchueler.BLL_Art <> 'K' then// BLL geht ein
      pkt_sum := pkt_sum + 4*FSchueler.BLL_Punkte;

    if pkt_sum < 100 then
    begin
      FAbiturErgebnisse.Bestehenspruefung := true;
      with FAbiturdaten do
      begin
        First;
        while not Eof do
        begin
          if ( FieldByname( 'AbiturFach' ).AsInteger in [ 1, 2, 3 ] ) and ( FieldByName( 'MDLZusatzPruefung' ).AsString <> 'A' ) then
          begin
            Edit;
            FieldByname( 'MdlZusatzPruefung' ).AsString := 'B';
            if FieldByname( 'MdlPruefErgebnis' ).IsNull then
              FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [ aeFehlendeZusAbiLeistungen ];
            Post;
          end;
          Next;
        end;
        First;
      end;
    end;
  end;


var
  fehler, ignoriere_sprung: boolean;
  fach: string;
  ds: double;
  ber : double;
  abi_fach, anderes_abi_fach, pkt, pkt1, pkt2: integer;
  anz_25, anz_lk_25: integer;


begin
  sum_ber := 0;
// NEU: Es müssen 2 Abiturfächer mit mindestens 25 Punkten abgeschlossen werden. Dabei muss mindestens ein LK sein
  anz_25 := 0;
  anz_lk_25 := 0;

  with FAbiturdaten do
  begin
    if RecordCount = 0 then
    begin
      FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeFehlendeAbiLeistungen];
      exit;
    end;
    First;
    while not Eof do
    begin
// Erst mal evtl. Zusatzprüfungen löschen
      if ( FieldByname( 'MdlZusatzPruefung' ).AsString = 'B' ) or ( FieldByname( 'MdlZusatzPruefung' ).AsString = 'A' ) then
      begin // eine evetl. vorhanden Bestehensprüfung lsöchen
        Edit;
        FieldByname( 'MdlZusatzPruefung' ).Clear;
        Post;
      end;
      if FieldByname( 'Fehler' ).AsInteger > 0 then
      begin // eine Hauptleistung fehlt
        FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeFehlendeAbiLeistungen];
        if FieldByName( 'Abiturfach' ).AsInteger in [ 1, 2, 3 ] then
        begin
          FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeFehlendeSchrAbiLeistungen];
          if FieldByName( 'Abiturfach' ).AsInteger in [ 1, 2 ] then
            FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeFehlendeLKAbiLeistungen];
        end else if FieldByName( 'Abiturfach' ).AsInteger = 4 then
          FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeFehlendeMdlAbiLeistungen];
      end;
      if aeFehlendeLKAbileistungen in FAbiturErgebnisse.Ergebnisse then
        FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeFehlendeAbiLeistungen];
      if aeFehlendeSchrAbileistungen in FAbiturErgebnisse.Ergebnisse then
        FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeFehlendeAbiLeistungen];
      if aeFehlendeMdlAbileistungen in FAbiturErgebnisse.Ergebnisse then
        FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeFehlendeAbiLeistungen];

      fehler := not AbiLeistungenVollstaendig;
      fehler := false;
      ber := FieldByName( 'Berechnung' ).AsFloat;
      if ber > 0 then
        sum_ber := sum_ber + trunc( ber );
      abi_fach := FieldByname( 'AbiturFach' ).AsInteger;
      if not fehler then
      begin
        if FSchueler.BLL_Art = 'K' then
        begin // keine BLL
          if Between( ber, 0, 24 ) then
          begin
            inc( FAbiturErgebnisse.Defizite_II );
            if abi_fach in [ 1,2 ] then
              inc( FAbiturErgebnisse.LK_Defizite_II );
          end else
          begin
            inc( anz_25 );
            if abi_fach in [ 1,2 ] then
              inc( anz_lk_25 );
          end;
        end else
        begin
          if Between( ber, 0 , 19 ) then
          begin
            inc( FAbiturErgebnisse.Defizite_II );
            if abi_fach in [ 1,2 ] then
              inc( FAbiturErgebnisse.LK_Defizite_II );
          end else
          begin
            inc( anz_25 );
            if abi_fach in [ 1,2 ] then
              inc( anz_lk_25 );
          end;
        end;
      end;
      if ( abi_fach in [ 1, 2, 3 ] ) and not FieldByName( 'AbiPruefErgebnis' ).IsNull then
      begin
        FC0.Locate( 'Fach_ID', FieldByName( 'Fach_ID' ).AsInteger, [] );
        fach := FC0.FieldByName( 'FachInternKrz' ).AsString;
        ds := ( Punkte( fach, C_Q1 ) + Punkte( fach, C_Q2 ) + Punkte( fach, C_Q3 ) + Punkte( fach, C_Q4 ) ) / 4;
        if ( abs( ds - FieldByName( 'AbiPruefErgebnis' ).AsInteger ) > 3.75 ) {and FieldByName( 'MdlPruefErgebnis' ).IsNull} then
        begin
          Edit;
          FieldByName( 'MdlZusatzPruefung' ).AsString := 'A';
          Post;
          FAbiturErgebnisse.Abweichungspruefung := true;
          if FieldByName( 'MdlPruefErgebnis' ).IsNull then
            FAbiturErgebnisse.AbweichungspruefungOhnePunkte := true;
//          FAbiturErgebnisse.Abweichungspruefung := FAbiturErgebnisse.Abweichungspruefung or FieldByName( 'MdlPruefErgebnis' ).IsNull;
        end;
      end;
      Next;
    end;
  end;

  FAbiturErgebnisse.AbiturAbbruch := false;
  if FAbiturErgebnisse.Defizite_II > 2 then
  begin
    FAbiturErgebnisse.Farbe_Defizite_II := C_FEHLER_FARBE;
    FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [ aeDefizite_II ];
    FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [ aeNichtBestanden ];
  end else if FAbiturErgebnisse.Defizite_II >= 1 then
    FAbiturErgebnisse.Farbe_Defizite_II := C_WARN_FARBE;

  if FAbiturErgebnisse.LK_Defizite_II > 1 then
  begin
    FAbiturErgebnisse.Farbe_LK_Defizite_II := C_FEHLER_FARBE;
    FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [ aeLK_Defizite_II ];
    FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [ aeNichtBestanden ];
  end else if FAbiturErgebnisse.LK_Defizite_II = 1 then
    FAbiturErgebnisse.Farbe_LK_Defizite_II := C_WARN_FARBE;

  FAbiturErgebnisse.Punktsumme_II := trunc( sum_ber );
  if FSchueler.BLL_Art <> 'K' then
  begin // BLL geht ein
    FAbiturErgebnisse.Punktsumme_II := FAbiturErgebnisse.Punktsumme_II + 4*FSchueler.BLL_Punkte;
    if FSchueler.BLL_Punkte = 0 then
      FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [aeFehlendeAbiLeistungen];
  end;

//  if FAbiturErgebnisse.Abweichungspruefung and ( aeNichtBestanden in FAbiturErgebnisse.Ergebnisse ) then
//    FAbiturErgebnisse.Abweichungspruefung := false;

  if ( FAbiturErgebnisse.Punktsumme_II < 100 ) then
    FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [ aeZuWenigPunkte_II ];

//  if {( aeZuWenigPunkte_II in FAbiturErgebnisse.Ergebnisse )
//      and not ( aeNichtBestanden in FAbiturErgebnisse.Ergebnisse )
//      and not ( aeFehlendeSchrAbiLeistungen in FAbiturErgebnisse.Ergebnisse )} then
  begin
// Bestehensprüfung ansetzen?
    with FAbiturdaten do
    begin
      First;
      while not Eof do
      begin
        abi_fach := FieldByname( 'AbiturFach' ).AsInteger;
        if ( abi_fach in [ 1, 2, 3 ] ) then
        begin
          if FieldByname( 'MdlZusatzPruefung' ).AsString = 'A' then
          begin // Es liegt schon eine Abweichnungsprüfung vor, also
            if FieldByname( 'MdlPruefErgebnis' ).IsNull then
              fAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [ aeFehlendeZusAbiLeistungen ];

            if abi_fach in [ 1, 2 ] then
            begin
              if abi_fach = 1 then
                anderes_abi_fach := 2
              else
                anderes_abi_Fach := 1;

{b) muss ein Schüler in einem LK in die Abweichungsprüfung, so muss das Gesamtergebnis des entsprechenden LKs mit einem
prognostizierten mündlichen Prüfungsergebnis von 0 Punkten vorausberechnet werden. Entstehen auf diese weise wieder zwei LK-Defizite,
muss eine Bestehensprüfung in dem zweiten LK angesetzt werden.}
// Nur machen, wenn die LKLeistungen schon da sind und ein LK-Defizit (bei 0 LK-Defizit kann es ja nicht passieren)
              if not ( aeFehlendeLKAbileistungen in FAbiturErgebnisse.Ergebnisse ) and
                     ( FAbiturErgebnisse.LK_Defizite_II = 1 ) then
              begin
// Hier wird nicht 0 als MdlPruefErgebnis gesetzt, sondern der Inhalt von  MdlPruefErgebnis, so kann bei vorhandenen Einträgen vermieden werden
// dass das immer wieder angesetzt wird

                if FSchueler.BLL_Art = 'K' then // keine BLL
                  pkt1 := Trunc( Runden( 5/3*(2*FieldByName( 'AbiPruefErgebnis' ).AsInteger + FieldByname( 'MdlPruefErgebnis' ).AsInteger ) ) ) // die 0 Punkte der mdl. Prf
                else // BLL
                  pkt1 := Trunc( Runden( 4/3*(2*FieldByName( 'AbiPruefErgebnis' ).AsInteger + FieldByname( 'MdlPruefErgebnis' ).AsInteger ) ) );


// TEmporör aktiviert, d.h. es wird schon hier auf das andere Abi-Fach gewechselt
                Locate( 'AbiturFach', anderes_abi_fach, [] ); // zum anderen Abiturfach

                if FSchueler.BLL_Art = 'K' then // keine BLL
                  pkt2 := Trunc( Runden( 5/3*(2*FieldByName( 'AbiPruefErgebnis' ).AsInteger + FieldByname( 'MdlPruefErgebnis' ).AsInteger ) ) ) // die 0 Punkte der mdl. Prf
                else // BLL
                  pkt2 := Trunc( Runden( 4/3*(2*FieldByName( 'AbiPruefErgebnis' ).AsInteger + FieldByname( 'MdlPruefErgebnis' ).AsInteger ) ) );

                if ( pkt1 < 25 ) and ( pkt2 < 25 )  then
//                if ( pkt < 25 ) then
                begin
// Temporär deaktiviert
//                  Locate( 'AbiturFach', anderes_abi_fach, [] ); // zum anderen Abiturfach

                  if FieldByname( 'MdlZusatzPruefung' ).AsString <> 'A' then
                  begin // Nur was tun, Falls noch keine Abweichungsprüfung eingetragen ist
                    Edit;
                    FieldByname( 'MdlZusatzPruefung' ).AsString := 'B';
                    Post;
                  end;
//                  Locate( 'AbiturFach', abi_fach, [] ); // wieder zurück finden
                end;
              end;

// Sicherheitshalber wieder zurück
              Locate( 'AbiturFach', abi_fach, [] ); // zum anderen Abiturfach

            end;


          end else if not ( aeFehlendeSchrAbileistungen in FAbiturErgebnisse.Ergebnisse ) and
                      not ( aeFehlendeMdlAbileistungen in FAbiturErgebnisse.Ergebnisse ) and
                          ( aeZuWenigPunkte_II in FAbiturErgebnisse.Ergebnisse ) then
          begin // Bestehensprüfung wird gesetzt, wenn die Punktsumme zu niedrig ist, und alle Pflichtprüfungen gemacht
            Edit;
            FieldByname( 'MdlZusatzPruefung' ).AsString := 'B';
            if FieldByname( 'MdlPruefErgebnis' ).IsNull then
              FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [ aeFehlendeZusAbiLeistungen ];
            Post;
            FAbiturErgebnisse.Bestehenspruefung := true;
          end else if not ( aeFehlendeLKAbileistungen in FAbiturErgebnisse.Ergebnisse ) and ( FAbiturErgebnisse.LK_Defizite_II = 2 ) then
          begin //a) in beiden LKs muss eine Bestehensprüfung angesetzt werden, wenn in beiden LKs weniger als 5 Punkte erreicht wurden.
            if abi_fach in [ 1, 2 ] then
            begin
              Edit;
              FieldByname( 'MdlZusatzPruefung' ).AsString := 'B';
              if FieldByname( 'MdlPruefErgebnis' ).IsNull then
                FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [ aeFehlendeZusAbiLeistungen ];
              Post;
              FAbiturErgebnisse.Bestehenspruefung := true;
            end;
          end;


//c) Sobald der Schüler alle zwingend notwendigen Abweichungsprüfungen absolviert hat, keine zwei LK-Defizite hat und mehr als 99 Punkte in Block II hat, werden alle noch angesetzten und nicht durchgeführten Bestehensprüfungen deaktiviert (wenn er durch ist ist er durch).}
        end;
        Next;
      end;
      First;
    end;

// NEU hier wird geprüft, ob bei Abweichungsprüfungen auch eine Bestehensprüfung angesetzt werdn muss
// Das kann dann der Fall sein, wenn in der Prüfug potentiell 0 Punkte erzielt werden
    if  not ( aeFehlendeAbiLeistungen in FAbiturErgebnisse.Ergebnisse )  then
    begin
// Falls schon zu wenige Punkte erzielt wurden, ist die Bestehsnprüfung schon gesetzt
//        not FAbiturErgebnisse.Bestehenspruefung and FAbiturErgebnisse.Abweichungspruefung then
//      if not FAbiturErgebnisse.Bestehenspruefung  then
      begin
        fehler := not( ( anz_25 >= 2 ) and ( anz_lk_25 >= 1 ) );
        if fehler or FAbiturErgebnisse.Abweichungspruefung then
          MdlPruefungAuswirkungTesten( fehler );
      end;
    end;

    FAbiturErgebnisse.LeistungenVollstaendig := not ( aeFehlendeAbiLeistungen in FAbiturErgebnisse.Ergebnisse ) and
                                                not ( aeFehlendeZusAbiLeistungen in FAbiturErgebnisse.Ergebnisse );
    FAbiturErgebnisse.AbiturAbbruch := not FAbiturErgebnisse.LeistungenVollstaendig;
    if not FAbiturErgebnisse.AbiturAbbruch then
    begin
      if aeZuWenigPunkte_II in FAbiturErgebnisse.Ergebnisse then
        FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [ aeNichtBestanden ];
    end;
  end;

{  if aeNichtBestanden in FAbiturErgebnisse.Ergebnisse then
  begin // Wenn definitiv nicht bestanden, werden auch keine zus. mündl. Prüfungen mehr benötigt
    with FAbiturdaten do
    begin
      First;
      while not Eof do
      begin
        if FieldByname( 'MdlZusatzPruefung' ).AsString <> '' then
        begin
          Edit;
          FieldByname( 'MdlZusatzPruefung' ).Clear;
          Post;
        end;
        Next;
      end;
      First;
    end;
  end;}

  if ( aeZuWenigPunkte_II in FAbiturErgebnisse.Ergebnisse ) {or ( aeFehlendeAbiLeistungen in FAbiturErgebnisse.Ergebnisse )} then
    FAbiturErgebnisse.Farbe_Punktsumme_II := C_FEHLER_FARBE;

  FAbiturErgebnisse.Durchschnitt_II := Runden( FAbiturErgebnisse.Punktsumme_II / 20, 2 ); // Abrunden( FAbiturErgebnisse.Punktsumme_II / 20, 2 );

  if FAbiturErgebnisse.AbweichungspruefungOhnePunkte then
    FAbiturErgebnisse.AbiturAbbruch := true;

  if not FAbiturErgebnisse.AbiturAbbruch then
  begin
    FAbiturErgebnisse.LeistungenVollstaendig := not ( aeFehlendeAbiLeistungen in FAbiturErgebnisse.Ergebnisse );
    FAbiturErgebnisse.AbiturAbbruch := aeFehlendeAbiLeistungen in FAbiturErgebnisse.Ergebnisse;
  end;


  if FAbiturErgebnisse.AbiturAbbruch then
  begin
//    FAbiturErgebnisse.Farbe_Defizite_II := C_ABBRUCH_FARBE;
//    FAbiturErgebnisse.Farbe_LK_Defizite_II := C_ABBRUCH_FARBE;
//    FAbiturErgebnisse.Farbe_Punktsumme_II := C_ABBRUCH_FARBE;
  end;

  FAbiturErgebnisse.BlockIIDefizite := ( aeDefizite_II in FAbiturErgebnisse.Ergebnisse ) or ( aeLK_Defizite_II in FAbiturErgebnisse.Ergebnisse );

  if not FAbiturErgebnisse.Bestehenspruefung and not FAbiturErgebnisse.Abweichungspruefung then
    FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse - [ aeFehlendeZusAbiLeistungen ];

  if not FAbiturErgebnisse.AbiturAbbruch and not( aeNichtBestanden in FAbiturErgebnisse.Ergebnisse ) then
    FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse + [ aeBestanden ];

  FAbiturErgebnisse.Punktsumme_Abi := FAbiturErgebnisse.Punktsumme_I + FAbiturErgebnisse.Punktsumme_II;

//  if aeBestanden in FAbiturergebnisse.Ergebnisse then
    FAbiturErgebnisse.Durchschnitt_Abi := Abrunden( FAbiturErgebnisse.Punktsumme_Abi / 60, 2 );

  FAbiturErgebnisse.Abiturnote := Abiturformel( FAbiturErgebnisse.Punktsumme_Abi );
  ignoriere_sprung := ( FAbiturErgebnisse.Punktsumme_Abi >= 823 );// or ( FAbiturErgebnisse.Punktsumme_Abi < 300 );
  if FAbiturErgebnisse.Abiturnote < 1 then
    FAbiturErgebnisse.Abiturnote := 1;

  if not ignoriere_sprung then
  begin
    FAbiturErgebnisse.Abiturnote_Besser := FAbiturErgebnisse.Abiturnote - 0.1;
    FAbiturErgebnisse.Abiturnote_Schlechter := FAbiturErgebnisse.Abiturnote + 0.1;

    FAbiturErgebnisse.Punktabstand_Schlechter := Punktsprung( FAbiturErgebnisse.Abiturnote, 0.1, FAbiturErgebnisse.Punktsumme_Abi );
    FAbiturErgebnisse.Punktabstand_Besser := Punktsprung( FAbiturErgebnisse.Abiturnote, -0.1, FAbiturErgebnisse.Punktsumme_Abi );
  end else
  begin
    FAbiturErgebnisse.Abiturnote_Besser := 0;
    FAbiturErgebnisse.Abiturnote_Schlechter := 0;
  end;



{  if aeBestanden in FAbiturErgebnisse.Ergebnisse then
  begin // Prüfung nur notwendig, wenn bisher bestanden
    with FAbiturdaten do
    begin
      First;
      while not Eof do
      begin
        pkt := FachAbiPunktSumme( FieldByName( 'Fach_ID' ).AsInteger );
        abi_fach := FieldByname( 'AbiturFach' ).AsInteger;
        if pkt >= 25 then
        begin
          inc( anz_25 );
          if ( abi_fach in [ 1, 2 ] ) then
            inc( anz_lk_25 );
        end;
        Next;
      end;
    end;
    if not ( ( anz_25 >= 2 ) and ( anz_lk_25 >= 1 ) ) then
      FAbiturErgebnisse.Ergebnisse := FAbiturErgebnisse.Ergebnisse - [ aeBestanden ] + [ aeNichtBestanden ];
  end;}
end;

function TAbiturBelegPruefer.MuendlichePruefungNotwendig( const p_q1, p_q2, p_q3, p_q4: string; const p_abi: integer ): char;
var
  ds: double;
  pq1, pq2, pq3, pq4: integer;
begin
  Result := '?';
  try
    pq1 := StrToInt( p_q1 );
    pq2 := StrToInt( p_q2 );
    pq3 := StrToInt( p_q3 );
    pq4 := StrToInt( p_q4 );
  except
    exit;
  end;

  ds := ( pq1 + pq2 + pq3 + pq4 )/4;
  if abs( ds - p_abi ) > 3.75 then
    Result := '+'
  else
    Result := '-';
end;

function TAbiturBelegPruefer.GetAbweichungsFaecher: string;
begin
  Result := '';
  with FAbiturDaten do
  begin
    First;
    while not Eof do
    begin
      if FieldByName( 'MdlZusatzPruefung' ).AsString = 'A' then
      begin
        if Result <> '' then
          Result := Result + ',';
        Result := Result + FieldByName( 'Fach_ID' ).AsString;
      end;
      Next;
    end;
    First;
  end;
end;

function TAbiturBelegPruefer.GetBestehensFaecher: string;
begin
  Result := '';
  with FAbiturDaten do
  begin
    First;
    while not Eof do
    begin
      if FieldByName( 'MdlZusatzPruefung' ).AsString = 'B' then
      begin
        if Result <> '' then
          Result := Result + ',';
        Result := Result + FieldByName( 'Fach_ID' ).AsString;
      end;
      Next;
    end;
    First;
  end;
end;


procedure TAbiturBelegPruefer.AktivLevelAendern( const iv: integer );
begin
  if iv >0 then
  begin
    inc( FAktivLevel );
    if FAktivLevel > 2 then
      FAktivLevel := 2;
  end else
  begin
    dec( FAktivLevel );
    if FAktivLevel < 0 then
      FAktivLevel := 0;
  end;
end;


procedure TAbiturBelegPruefer.PunktsummeFuerFachBerechnen( const fach_id: integer; const ps_modus: TPunktSummenModus; var punktsumme: integer; var durchschnitt: double );
var
  i, pkt_sum, pkt_s, pkt: integer;
  fach: string;
begin
  punktsumme := -1;
  durchschnitt := -1;

  if FC0.FieldByname( 'Fach_ID' ).AsInteger <> fach_id then
    if not FC0.Locate( 'Fach_ID', fach_id, [] ) then
      exit;

  fach := FC0.FieldByname( 'FachInternKrz' ).AsString;

  if ( ps_modus in [ psmZwischenstand, psmEndstand ] ) and ( FC0.FieldByName( 'Abiturfach' ).AsInteger = 0 ) then
    exit;

  pkt_sum := 0;
  pkt_s := 0;

// Erst mal die Abschnitte
  if ps_modus <> psmZwischenstand then
  begin
    for i := C_Q1 to C_Q4 do
    begin
      if FC0.FieldByName( Format( 'MA_%d', [i] ) ).AsString = '+' then
      begin
        pkt := FC0.FieldByName( Format( 'PU_%d', [i] ) ).AsInteger;
        pkt_s := pkt_s + pkt;
        if FC0.FieldByName( 'Abiturfach' ).AsInteger in [ 1, 2 ] then// LK, Punkte doppelt
          pkt := pkt * 2;
        pkt_sum := pkt_sum + pkt;
      end;
    end;
    punktsumme := pkt_sum;
    if FC0.FieldByname( 'Abiturfach' ).AsInteger in [ 1, 2, 3 ] then
      durchschnitt := pkt_s / 4;
  end;

  if ps_modus = psmZulassung then
    exit;

  if not FAbiturDaten.Locate( 'Fach_ID', fach_id, [] ) then
    exit;

  if FAbiturDaten.FieldByName( 'AbiPruefErgebnis' ).IsNull then
  begin
    punktsumme := 0;
    exit;
  end;
// Ab hier nur Abi-Fächer
  case ps_modus of
  psmZwischenstand:
    begin
      if FSchueler.BLL_Art = 'K' then
        pkt_sum := 5*FAbiturDaten.FieldByName( 'AbiPruefErgebnis' ).AsInteger
      else
        pkt_sum := 4*FAbiturdaten.FieldByName( 'AbiPruefErgebnis' ).AsInteger;
    end;
  psmEndstand:
    begin
      pkt_sum := FachAbiPunktSumme( fach_id );
    end;
  end;

  punktsumme := pkt_sum;

end;


procedure TAbiturBelegPruefer.Pruefe_Q_Phase_BK;
var
	M, fach, statkrz, fachgr, nw, aufgabenfeld: string;
	i, j, jmax, p: integer;
	cntLK, cntGK: integer;
	cntD, cntFS_n, cntFS_f, cntM, cntGG, cntGA, cntNW, cntNull: integer;
  slNW: TStringList;
  slAF: TStringList;
  ist_belegt, tmp_abi: boolean;
begin
  tmp_abi := FFuerAbitur;
  slNW := TStringList.Create;
  slAF := TStringList.Create;
// Die Kurse zählen
  try
    cntLK := 0;
    cntGK := 0;
    cntD := 0;
    cntFS_n := 0;
    cntFS_f := 0;
    cntM := 0;
    cntGG := 0;
    cntGA := 0;
    cntNW := 0;
    cntNull := 0;;
    with fC0 do
    begin
      First;
      while not Eof do
      begin
        fach := FieldByname( 'FachInternKrz' ).AsString;
        statkrz := FieldByname( 'FachStatKrz' ).AsString;
        aufgabenfeld := FieldByname( 'Aufgabenfeld' ).AsString;
        fachgr := FieldByName( 'Fachgruppe' ).AsString;
        if fachgr = 'RE' then
          aufgabenfeld := '2'; // RE gilt im BK als belegung für AGF II
        if ( aufgabenfeld <> '' ) and ( FieldByname( 'Abiturfach' ).AsInteger > 0 ) then
        begin
          if slAF.IndexOf( aufgabenfeld ) < 0 then
            slAF.Add( aufgabenfeld );
        end;
        for i := C_Q1 to C_Q4 do
        begin
// Hier erst mal nur Belegung
          FFuerAbitur := false;
          ist_belegt := Istbelegt1( fach, i, i );
//          FFuerAbitur := tmp_abi;
          if ist_belegt then
          begin
            if PunktzahlNumEx( FieldByname( Format( 'PU_%d', [ i ] ) ).AsString ) = 0 then
            begin
              inc( cntNull );
              continue;
            end;
          end;

          if FieldByName( Format( 'KA_%d', [ i ] ) ).AsString = 'LK' then
            inc( cntLK )
          else
            inc( cntGK );

          if statkrz = 'D' then		// Deutsch
            inc( cntD )
          else if fachgr = 'FS' then	// Fremdsprache
          begin
            if InMenge( fach, W1_2 ) then
              inc( cntFS_f )
            else
              inc( cntFS_n );
          end else if statkrz = 'M' then		// Mathe
            inc( cntM )
          else if statkrz = 'GL' then // or
//                    ( FieldByName( 'Fach' ).AsString = 'GE' ) then	// Gesellschaftslehre bzw. Geschichte
          begin
            inc( cntGG );
            inc( cntGA );
          end else if InMenge( fach, W2 ) then
            inc( cntGA )
          else if fachgr = 'NW' then
          begin
            inc( cntNW );
// Klute: NW heißt ein! aus der 11 fortgeführtes Fach aus der Fächergruppe NW, daher die versch. NW's sammeln
            if slNW.IndexOf ( fach ) < 0 then
              slNW.Add( fach );
          end;
        end;
        Next;
      end;
    end;

    FFuerAbitur := true;

    if cntNull > 0 then
    begin
      FehlerAusgeben( 'BK_00', 'Es wurden Kurse mit 0 Punkten gefunden' );
//      exit;
    end;

    if slNW.Count= 0 then
    begin
      FehlerAusgeben( 'BK_00', 'Ungültige Anzahl von Naturwissenschaften' );
//      exit;
    end;
// Wenn Reli Abifach ist, ersetzt das
    if ( cntLK < 8 ) or ( cntGK < 24 ) then
    begin
      if ( cntGK < 24 ) then
        FehlerAusgeben( 'BK_00', 'Zu wenig Grundkurse belegt' );
      if ( cntLK < 8 ) then
        FehlerAusgeben( 'BK_00', 'Zu wenig Leistungskurse belegt' );
//      exit;
    end;
// Ermittlung der Anzahl der fächerrelevanten Grund- und Leistungskurse
    if cntD < 4 then
      FehlerAusgeben( 'BK_00', 'Zu wenig Deutsch-Kurse' );

    if W1_2 = '' then
    begin
      FehlerAusgeben( 'BK_00', 'Keine fortgeführte Fremdsprache aus Sek. I gefunden' );
    end else
    begin
      if not FSChueler.Einsprachler then
      begin
        if ( cntFS_n < 4 ) and ( cntFS_f < 4 ) then
          FehlerAusgeben( 'BK_00', 'Zu wenig Fremdsprachen-Kurse' );
      end else
      begin // Wenn nur eine FS in S1 dann 2 Kurse Neue FS + 4 Kurse fortgeführte FS
          if ( cntFS_n < 2 ) or ( cntFS_f < 4 ) then
          FehlerAusgeben( 'BK_00', 'Zu wenig Fremdsprachen-Kurse' );
      end;
    end;

    if cntM < 4 then
      FehlerAusgeben( 'BK_00', 'Zu wenig Mathematik-Kurse' );

    if ( cntGG < 2 ) and ( cntGA < 4 ) then
      FehlerAusgeben( 'BK_00', 'Zu wenig gesellschaftwissenschaftliche Kurse' );

    if cntNW < 4 then
      FehlerAusgeben( 'BK_00', 'Zu wenig naturwissenschaftliche Kurse' );

    if slAF.Count > 0 then
    begin // nur prüfen, wenn Aufgabenfelder gepflegt wurden
      if ( slAF.IndexOf( '1' ) < 0 ) or ( slAF.IndexOf( '2' ) < 0 ) or ( slAF.IndexOf( '3' ) < 0 ) then
        FehlerAusgeben( 'BK_00', 'Durch die Abiturfächer müssen alle drei Aufgabenfelder abgedeckt werden' );
    end;

    if FAnzahl_FA > 1 then
      FehlerAusgeben( 'BK_00', 'Es darf nur eine Facharbeit eingebracht werden' );

  finally
    FreeAndNil( slNW );
    FreeAndNil( slAF );
  end;

end;

function TAbiturBelegPruefer.Defizite_OK_BK( const mark_kurse, defizite, lk_defizite: integer ): boolean;
begin
  Result := lk_defizite <= 3;
  if not Result then
    exit;

  if ( 32 <= mark_kurse ) and (  mark_kurse <= 34 ) then
    Result := ( defizite <= 6 )
  else if ( 35 <= mark_kurse ) and (  mark_kurse <= 39 ) then
    Result := ( defizite <= 7 )
  else if ( 40 <= mark_kurse ) and (  mark_kurse <= 44 ) then
    Result := ( defizite <= 8 )
  else if ( 45 <= mark_kurse ) and (  mark_kurse <= 49 ) then
    Result := ( defizite <= 9 )
  else if ( 50 <= mark_kurse ) and (  mark_kurse <= 54 ) then
    Result := ( defizite <= 10 )
  else if ( 55 <= mark_kurse ) and (  mark_kurse <= 59 ) then
    Result := ( defizite <= 11 )
  else
    Result := true;
end;


procedure TAbiturBelegPruefer.BestesFachSuchen( const M: string; var fach_max: string; var pkt_max: integer );
var
  i, j, pkt: integer;
  fach: string;
begin
  fach_max := '';
  pkt_max := 0;

  for i := 1 to AnzahlElemente( M ) do
  begin
    fach := EinzelElement( M, i );
    pkt := 0;
    for j := C_Q1 to C_Q4 do
      pkt := pkt + Punkte( fach, j );
    if pkt > pkt_max then
    begin
      pkt_max := pkt;
      fach_max := fach;
    end;
  end;
end;

procedure TAbiturBelegPruefer.KurseMarkieren_BK;
var
  n1, i, j, pkt, pkt_sum_zb, anz_def_zb, anz_markiert_zb, fach_id, pkt1_max, pkt2_max : integer;
  M_, M1_, fach, FS1_max, FS2_max, mark, kursart: string;

  MarkKurse, abschnitt, fs_anz, fs2_id1, fs2_id2, fs2_abs1, fs2_abs2: integer;
  durchschnitt, durchschnitt_neu: double;

  fs_notw, abi_fs, _4FS_2neueFS: boolean;
  ds_1, ds_2: double;
  sum_1, sum_2, sum_2a: integer;

begin
  slZwangsFaecher.Clear;
// Die LK's markieren
  anz_markiert_zb := 0;
  pkt_sum_zb := 0;
  anz_def_zb := 0;
  FAnzLKDefizit := 0;
  _4FS_2neueFS := false;
  FFuerAbitur := false; // temporär, um 0 Punkte zu berücksichtigen

  for i := 1 to AnzahlElemente( W_LK ) do
  begin
    fach := EinzelElement( W_LK, i );
    for j := C_Q1 to C_Q4 do
    begin
      pkt := Punkte( fach, j );
      pkt_sum_zb := pkt_sum_zb + 2*pkt; // LK zählen doppelt
      inc( anz_markiert_zb );
      if pkt < 5 then
      begin
        Inc( FAnzLKDefizit );
        Inc( anz_def_zb );
      end;
    end;
    AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
  end;

// Die Abi GK's
  M_ := Differenzmenge( W_AF, W_LK );
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    fach := EinzelElement( M_ , i );
    for j := C_Q1 to C_Q4 do
    begin
      pkt := Punkte( fach, j );
      pkt_sum_zb := pkt_sum_zb + pkt;
      inc( anz_markiert_zb );
      if pkt < 5 then
        Inc( anz_def_zb );
    end;
    AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
  end;

// D markieren
  M_ := DifferenzMenge( W1_1, W_AF );
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    fach := EinzelElement( M_, i );
//    slZwangsFaecher.Add( fach );
    for j := C_Q1 to C_Q4 do
    begin
      pkt := Punkte( fach, j );
      pkt_sum_zb := pkt_sum_zb + pkt;
      inc( anz_markiert_zb );
      if pkt < 5 then
        Inc( anz_def_zb );
    end;
    AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
  end;

// M markieren
  M_ := DifferenzMenge( W3_1, W_AF );
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    fach := EinzelElement( M_, i );
//    slZwangsFaecher.Add( fach );
    for j := C_Q1 to C_Q4 do
    begin
      pkt := Punkte( fach, j );
      pkt_sum_zb := pkt_sum_zb + pkt;
      inc( anz_markiert_zb );
      if pkt < 5 then
        Inc( anz_def_zb );
    end;
    AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
  end;

// Fremdsprachen
// Wenn der Schüler kein Einsprachler ist, wird entweder die fortgeführte oder die neu einsetzende FS in 4 Kursen markiert

  fs_notw := false;
  if not FSchueler.Einsprachler then
  begin
    M_ := VereinigungsMenge( W1_2, W1_3 );
    M_ := SchnittMenge( M_, W_AF );
    fs_notw := M_ = ''; // Markierung nur notwendig, wenn keine FS Abifach ist
  end else
  begin
    M_ := SchnittMenge( W1_3, W_AF );
    fs_notw := M_ = ''; // Wenn neue FS Abifach, daan keine weitere Zwngsmarkierung notw.
  end;

  if fs_notw then
  begin
    if not FSchueler.Einsprachler then
    begin // bestes Fach aus W1_2 U W1_3 suchen
      BestesFachSuchen( Vereinigungsmenge( W1_2, W1_3 ), FS1_max, pkt1_max );
      if FS1_max <> '' then
      begin
        AbschnitteMarkieren( FS1_max, C_Q1, C_Q4, '+' );
        for j := C_Q1 to C_Q4 do
        begin
          pkt := Punkte( FS1_max, j );
          pkt_sum_zb := pkt_sum_zb + pkt;
          inc( anz_markiert_zb );
          if pkt < 5 then
            Inc( anz_def_zb );
        end;
      end;
    end else
    begin // Einsprachler

      if Schnittmenge( W1_2, W_AF ) <> '' then
        pkt1_max := 1000 // dann ist ein Fach aus W1_2 Abifach
      else
        BestesFachSuchen( W1_2, FS1_max, pkt1_max );
      BestesFachSuchen( W1_3, FS2_max, pkt2_max );
      if pkt1_max >= pkt2_max  then
      begin // die 4 Kurse aus W1_2 markieren, zusätzlich zwei aus W1_3

        _4FS_2neueFS := pkt1_max < 1000; // kein Abifach

        if FS1_max <> '' then
        begin
          AbschnitteMarkieren( FS1_max, C_Q1, C_Q4, '+' );
          for j := C_Q1 to C_Q4 do
          begin
            pkt := Punkte( FS1_max, j );
            pkt_sum_zb := pkt_sum_zb + pkt;
            inc( anz_markiert_zb );
            if pkt < 5 then
              Inc( anz_def_zb );
          end;
        end;

// Hier noch die beiden besten aus W1_2 holen
        FAbiErgebnisVerwalter.FachAbschnitteLeeren;
        fach_id := Fach_ID_Von( FS2_max );
        for j := C_Q1 to C_Q4 do
        begin
          pkt := Punkte( FS2_max, j );
          if pkt > 0 then
            FAbiErgebnisVerwalter.FachAbschnittHinzu( fach_id, j, pkt );
        end;
        FAbiErgebnisVerwalter.FachAbschnitteSortieren;

        for i := 1 to 2 do
        begin
          if not FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fach_id, abschnitt, pkt ) then
            break;
          AbschnitteMarkieren( fach_id, abschnitt, abschnitt, '+' );
          FAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen;
          pkt_sum_zb := pkt_sum_zb + pkt;
          if pkt < 5 then
            Inc( anz_def_zb );
          inc( anz_markiert_zb );
        end;

      end else
      begin // neue FS besser, nur diese markieren
        AbschnitteMarkieren( FS2_max, C_Q1, C_Q4, '+' );
        for j := C_Q1 to C_Q4 do
        begin
          pkt := Punkte( FS2_max, j );
          pkt_sum_zb := pkt_sum_zb + pkt;
          if pkt < 5 then
            Inc( anz_def_zb );
        end;
        inc( anz_markiert_zb, 4 );

      end;
    end;
  end;

// NW
  M_ := DifferenzMenge( W3_2, W_AF );
  M1_ := '';
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    fach := EinzelElement( M_, i );
//    slZwangsFaecher.Add( fach );
    if IstBelegt1( fach, C_Q1, C_Q4 ) then
      ZuMengeHinzu( M1_, fach );
  end;

  if M1_ <> '' then
  begin
    BestesFachSuchen( M1_, fach, pkt1_max );
    AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
    for j := C_Q1 to C_Q4 do
    begin
      pkt := Punkte( fach, j );
      pkt_sum_zb := pkt_sum_zb + pkt;
      if pkt < 5 then
        Inc( anz_def_zb );
    end;
    inc( anz_markiert_zb, 4 );
  end;

// 4 Kurse aus W2, davin 2 Kurse GL
  M_ := SchnittMenge( W2_1, W_AF ); // falls GL Abifach ist, ist schon alles notwendige Markiert
  if M_ = '' then
  begin
// wenn wir hier sind, müüsen auf jeden fall 2 GL-Fächer markiert werden
// Erst mal alle in Liste rein
    FAbiErgebnisVerwalter.FachAbschnitteLeeren;
    for i := 1 to AnzahlElemente( W2_1 ) do
    begin
      fach := EinzelElement( W2_1, i );
      fach_id := Fach_ID_Von( fach );
      for j := C_Q1 to C_Q4 do
      begin
        pkt := Punkte( fach, j );
        if pkt > 0 then
          FAbiErgebnisVerwalter.FachAbschnittHinzu( fach_id, j, pkt );
      end;
    end;
    FAbiErgebnisVerwalter.FachAbschnitteSortieren;
    for i := 1 to 2 do
    begin
      if not FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fach_id, abschnitt, pkt ) then
        break;
      AbschnitteMarkieren( fach_id, abschnitt, abschnitt, '+' );
      FAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen;
      pkt_sum_zb := pkt_sum_zb + pkt;
      if pkt < 5 then
        Inc( anz_def_zb );
      inc( anz_markiert_zb );
    end;

// Nun noch die übrigen W2-Fächer
    M_ := Differenzmenge( W2, W2_1 );
    if M_ <> '' then
    begin
      for i := 1 to AnzahlElemente( M_ ) do
      begin
        fach := EinzelElement( M_, i );
        fach_id := Fach_ID_Von( fach );
        for j := C_Q1 to C_Q4 do
        begin
          pkt := Punkte( fach, j );
          if pkt > 0 then
            FAbiErgebnisVerwalter.FachAbschnittHinzu( fach_id, j, pkt );
        end;
      end;
      FAbiErgebnisVerwalter.FachAbschnitteSortieren; // nochmal sortieren
      for i := 1 to 2 do
      begin
        if not FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fach_id, abschnitt, pkt ) then
          break;
        AbschnitteMarkieren( fach_id, abschnitt, abschnitt, '+' );
        FAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen;
        pkt_sum_zb := pkt_sum_zb + pkt;
        if pkt < 5 then
          Inc( anz_def_zb );
        inc( anz_markiert_zb );
      end;
    end;
  end;

// NEU: Facharbeit hier rein, nur wenn dadurch der Durchsschnitt angehoben wird
  if FAnzahl_FA > 0 then
  begin
    durchschnitt := pkt_sum_zb / ( anz_markiert_zb + 8 );
    with FC0 do
    begin
      First;
      while not Eof do
      begin
        if FieldByname( 'PU_FA' ).AsString <> '' then
        begin // Facharbeit suchen
          pkt := FC0.FieldByName( 'PU_FA' ).AsInteger;
          if pkt > durchschnitt then
          begin
            AbschnitteMarkieren( FieldByname( 'Fach_ID' ).AsInteger, 0, 0, '+' );
            pkt_sum_zb := pkt_sum_zb + pkt;
//          inc( anz_markiert_zb, 2 );
            inc( anz_markiert_zb );
          end;
          break;
        end;
        Next;
      end;
    end;
  end;

  MarkKurse := anz_markiert_zb;

// Nun die Resterampe füllen
  FAbiErgebnisVerwalter.FachAbschnitteLeeren;
  with FC0 do
  begin
    First;
    while not Eof do
    begin
      fach := FieldByName( 'FachInternKrz' ).AsString;
      for j := C_Q1 to C_Q4 do
      begin
        pkt := Punkte( fach, j );
        mark := FieldByname( Format( 'MA_%d', [ j ] ) ).AsString;
        kursart := FieldByname( Format( 'KA_%d', [ j ] ) ).AsString;
        if ( pkt > 0 ) and ( mark = '-' ) and ( kursart <> '' ) and ( kursart <> 'AT' ) then
          FAbiErgebnisVerwalter.FachAbschnittHinzu( FieldByname( 'Fach_ID' ).AsInteger, j, pkt );
      end;
      Next;
    end;
  end;
  FAbiErgebnisVerwalter.FachAbschnitteSortieren;

// Auf 32 Kurse auffüllen
  while ( MarkKurse < C_MIN_KURSE_BK ) do
  begin
    if FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fach_id, abschnitt, pkt ) then
    begin
      fach := FachKuerzel_aus_ID( fach_id );
      AbschnitteMarkieren( fach, abschnitt, abschnitt, '+' );
      pkt_sum_zb := pkt_sum_zb + pkt;
      inc( MarkKurse );
      FAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen;
    end else
      break;
  end;


//Wenn Schüler Einsprachler Sek1 und die gefundene Markierung 4 Kurse fortgeführte mit 2 Kursen neue FS ist
//und keine Abiturfächer unter den FS !!!, dann prüfe, ob sich durch Weglassen der 4 fortgeführten FS und nur
//markieren der  4 neuen FS eine höhere Punktzahl ergibt.
//
// Das kann folgendermaßen funktionieren:
//
//   Wenn Kombination 4 FS + 2 neuFS vorliegt und keine FS Abiturfach, dann
//        1) Bilde den Durchschnitt der 6 markierten FS-Kurse.
//        2) Und bilde den Durchschnitt der 4 NeueFS+2 der besten nicht markierten Kurse.
//           Dann markiere den besseren Fall.
//
//Diese Prüfung müsste nach der Markierung der 32 Pflichtkurse stattfinden,
  if _4FS_2neueFS and ( FS1_max <> '' ) and ( FS2_max <> '' ) and ( FAbiErgebnisVerwalter.RestelisteAnzahl >= 2 ) then
  begin
// Durchschnitt
    sum_1 := 0; // für die bisherige Markierung
    sum_2 := 0; // für die alternative Markierung
    n1 := 0;
// 1) Bilde den Durchschnitt der 6 markierten FS-Kurse.
    for j := C_Q1 to C_Q4 do
    begin // die 4 fortgeführten FS Fächer für DS1
      if IstMarkiert( FS1_max, j ) then
      begin
        sum_1 := sum_1 + Punkte( FS1_max, j );
        inc( n1 );
      end;
      if IstMarkiert( FS2_max, j ) then
      begin
        sum_1 := sum_1 + Punkte( FS2_max, j );  // und die zwei neuen FS
        inc( n1 );
      end;
      sum_2 := sum_2 + Punkte( FS2_max, j ); // für die 4 neuen FS
    end;
    FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fs2_id1, fs2_abs1, pkt );
    sum_2a := pkt;

    FAbiErgebnisVerwalter.NaechstenEintragAusRestelisteHolen( fs2_id2, fs2_abs2, pkt );
    sum_2a := sum_2a + pkt;

    ds_1 := sum_1 / n1;
    ds_2 := ( sum_2 + sum_2a ) / 6;
// Test
//    ds_2 := sum_2 / 4;

    if ds_2 > ds_1 then
    begin // die 4 neuen FS markieren (die beiden Auffüllkurse werden später sowieso markiert)

      pkt_sum_zb := pkt_sum_zb - sum_1 + sum_2;
// Erst mal die 4 fortgeführten FS-Kurse entmarkieren
      for j := C_Q1 to C_Q4 do
      begin
        if IstMarkiert( FS1_max, j ) then
        begin
          AbschnitteMarkieren( FS1_max, j, j, '-' );
          dec( MarkKurse );
        end;
        if IstMarkiert( FS2_max, j ) then
        begin
          AbschnitteMarkieren( FS2_max, j, j, '-' );
          dec( MarkKurse );
        end;
      end;

      AbschnitteMarkieren( FS2_max, C_Q1, C_Q4, '+' );
      inc( MarkKurse, 4 );

  // Nun die Resterampe erneut füllen
      FAbiErgebnisVerwalter.FachAbschnitteLeeren;
      with FC0 do
      begin
        First;
        while not Eof do
        begin
          fach := FieldByName( 'FachInternKrz' ).AsString;
          for j := C_Q1 to C_Q4 do
          begin
            pkt := Punkte( fach, j );
            mark := FieldByname( Format( 'MA_%d', [ j ] ) ).AsString;
            kursart := FieldByname( Format( 'KA_%d', [ j ] ) ).AsString;
            if ( pkt > 0 ) and ( mark = '-' ) and ( kursart <> '' ) and ( kursart <> 'AT' ) then
              FAbiErgebnisVerwalter.FachAbschnittHinzu( FieldByname( 'Fach_ID' ).AsInteger, j, pkt );
          end;
          Next;
        end;
      end;
      FAbiErgebnisVerwalter.FachAbschnitteSortieren;
// Jetzt die beiden bresten "Restkurse" hinzu
      for j := 1 to 2 do
      begin
        if FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fach_id, abschnitt, pkt ) then
        begin
          fach := FachKuerzel_aus_ID( fach_id );
          if abschnitt > 0 then
          begin // normales Fach
            AbschnitteMarkieren( fach, abschnitt, abschnitt, '+' );
            pkt_sum_zb := pkt_sum_zb + pkt;
            inc( MarkKurse );
          end;
          FAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen;
        end;
      end;
    end;

  end;

  FFuerAbitur := true;

  if FAnzahl_0_Punkte > 0 then
    exit;


//// Durchschnitt berechnen für spätere Auffüllung
//  durchschnitt := pkt_sum_zb / ( MarkKurse + 8 );

// Defizite prüfen
  while true do
  begin
    if Defizite_OK_BK( MarkKurse, anz_def_zb, FAnzLKDefizit ) then
      break;
    if not FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fach_id, abschnitt, pkt ) then
      break;
    if pkt < 5 then
      break;
    fach := FachKuerzel_aus_ID( fach_id );
    AbschnitteMarkieren( fach, abschnitt, abschnitt, '+' );
    pkt_sum_zb := pkt_sum_zb + pkt;
    inc( MarkKurse );
    FAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen;
  end;

// NEU APR. 2017: Hier erst die DS-Berechnung
  // Durchschnitt berechnen für spätere Auffüllung
  durchschnitt := pkt_sum_zb / ( MarkKurse + 8 );

{// Die Facharbeit kann für die Erhöhung des Durchschnittes eingebracht werden
// also in die Resterampe rein
// NEU: ist nun weiter oben bei den Pflichtbelegungen
  if FAnzahl_FA > 0 then
  begin
    with FC0 do
    begin
      First;
      while not Eof do
      begin
        fach := FieldByName( 'FachInternKrz' ).AsString;
        if FieldByname( 'PU_FA' ).AsString <> '' then
        begin
          pkt := FC0.FieldByName( 'PU_FA' ).AsInteger;
          FAbiErgebnisVerwalter.FachAbschnittHinzu( FieldByname( 'Fach_ID' ).AsInteger, 0, pkt );
          break;
        end;
        Next;
      end;
    end;
    FAbiErgebnisVerwalter.FachAbschnitteSortieren;
  end;}

// Durchscnitt erhöhen
  while true do
  begin
    if MarkKurse >= C_MAX_KURSE_BK then
      break;

    if FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fach_id, abschnitt, pkt ) then
    begin
      durchschnitt_neu := ( pkt_sum_zb + pkt )/ ( MarkKurse + 8 + 1 );
//      if pkt <= durchschnitt then
//        break;
      if durchschnitt_neu <= durchschnitt then
        break;
      fach := FachKuerzel_aus_ID( fach_id );
      if abschnitt > 0 then
      begin // normales Fach
        AbschnitteMarkieren( fach, abschnitt, abschnitt, '+' );
        pkt_sum_zb := pkt_sum_zb + pkt;
        inc( MarkKurse );
      end else
      begin // facharbeit, zählt doppelt
        AbschnitteMarkieren( fach, 0, 0, '+' );
        pkt_sum_zb := pkt_sum_zb + 2*pkt;
        inc( MarkKurse, 2 );
      end;
      durchschnitt := durchschnitt_neu;
      FAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen;
    end else
      break;
  end;
end;


///////////////////////////////// WBK ////////////////////////////////////////

function TAbiturBelegPruefer.Schulstunden( const std: double ): integer;
begin
  if FDauerUnterrichtseinheit = 45 then
    Result := trunc( std )
  else
    Result := Trunc( Runden( std*FDauerUnterrichtseinheit/45 ) );
end;

procedure TAbiturBelegPruefer.KurseMarkieren_WBK;

  function IstQuereinsteiger: boolean;
  var
    j: integer;
  begin
    Result := true;
    with FC0 do
    begin
      First;
      while not Eof do
      begin
        Result := Result and not IstBelegt1( FieldByName( 'FachInternKrz' ).AsString, C_E1, C_E2 );
        if not Result then
          exit
        else
          Next;
      end;
    end;
  end;

var
  i, j, k, pkt, anz: integer;
  fach, statkrz, M_, FS_1: string;
  pkt_sum_zb, anz_def_zb, anz_markiert_zb: integer; // Für die "Zwangsbedingungen"
  bel_flag, ok, muss_schr: boolean;
//  pkt_ar: array[1..4] of integer;
//  psum, psum_max: integer;
//  fach_max: string;
//  muster_max: string;

begin

  for i := 1 to 3 do
    Sum_Ust_AF[i] := 0;
// ================================= FOLIE 4 ===================================

// 2 Fächer aus D, M , FS unter den  Abiturfächern ?
  M_ := W1_1;
  M_ := Vereinigungsmenge( M_, W1_2 );
  M_ := Vereinigungsmenge( M_, W1_3 );
  M_ := Vereinigungsmenge( M_, W3_1 );
  M_ := Schnittmenge( M_, W_AF );

  ok := AnzahlElemente( M_ ) >= 2;
	if not ok then
	begin
    FMeldungen.Add( 'Fehler: Nicht 2 Fächer aus D, M, FS unter den Abifächern (§37. 2)' );
    FAbbruch := true;
    exit;
  end;

// Religion Abiturfach?
  if Schnittmenge( W4, W_AF ) <> '' then
  begin // Ja, Religion ist Abi-Fach
    if InMenge( 'SP', W_AF ) then
    begin
      FMeldungen.Add( 'Fehler: Sport und Religion dürfen nicht beide Abiturfächer sein (§37.2, 5.Satz)' );
      FAbbruch := true;
      exit;
    end else
    begin
      ok := InMenge( '1', W_AGF ) and InMenge( '3', W_AGF );
      if not ok then
      begin
        FMeldungen.Add( 'Fehler: Nicht alle Aufgabenfelder im Abitur belegt' );
        FAbbruch := true;
    		exit;
      end;
    end;
  end else
  begin // Nein, REligion ist nicht Abifach
//  Alle Aufgabenfelder abgedeckt?
    ok := InMenge( '1', W_AGF ) and InMenge( '2', W_AGF ) and InMenge( '3', W_AGF );
    if not ok then
    begin
      FMeldungen.Add( 'Fehler: Nicht alle Aufgabenfelder im Abitur belegt' );
      FAbbruch := true;
      exit;
    end;
  end;

// Wenn Sport Abiturfach ist, muss es LK sein
  if InMenge( 'SP', W_AF ) and not InMenge( 'SP', W_LK ) then
  begin
    FMeldungen.Add( 'Fehler: Sport als Abiturfach muss Leistungskurs sein (VV zu §37.1)' );
    FAbbruch := true;
    exit;
  end;

// ================================= Einschub ===================================
// Einschub aus GY-Algorithmus: LK Defizite ermitteln
// Gibt es das am WBK?
  FAnzLKDefizit := 0;
  pkt_sum_zb := 0;
  anz_def_zb := 0;
  anz_markiert_zb := 0;
  for i := 1 to AnzahlElemente( W_LK ) do
  begin
    fach := EinzelElement( W_LK, i );
    for j := C_Q1 to C_Q4 do
    begin
      pkt := Punkte( fach, j );
      if pkt < 5 then
      begin
        Inc( FAnzLKDefizit );
        Inc( anz_def_zb );
      end;
    end;
  end;

  if FAnzLKDefizit > 3 then
  begin
    FMeldungen.Add( 'Keine Zulassung, da die Anzahl der Defizite im Leistungskursbereich überschritten ist.' );
    FAbbruch := true;
    exit;
  end;

// Hier noch DEefizite der Abi-GK's?
  M_ := Differenzmenge( W_AF, W_LK );
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    fach := EinzelElement( M_ , i );
    for j := C_Q1 to C_Q4 do
    begin
      pkt := Punkte( fach, j );
      if pkt < 5 then
        Inc( anz_def_zb );
    end;
  end;
// ================================= Ende Einschub =============================


// ================================= FOLIE 5 ABITURFÄCHER ======================
  Abi1FS := false; // hier neu ermitteln
	for i := 1 to 4 do
	begin   // Schleife über Abi-Fächer
		if not fC0.Locate( 'AbiturFach', i , [] ) then  // den Datensatz mit dem i-ten Abifach suchen
		begin
			FMeldungen.Add( Format( 'Fehler: %d. Abiturfach nicht gefunden', [ i ] ) );
      FAbbruch := true;
      exit;
		end;
    fach := fC0.FieldByname( 'FachInternKrz' ).AsString;
// 1. FS ermitteln
    if Ist_Erste_FS( fach ) then
    begin
      FS_1 := fach;
      Abi1FS := true;
    end;

		for j := C_Q1 to C_Q4 do
		begin  // Schleife über Semester
			pkt := Punkte( fach, j );
			if pkt = 0 then
			begin   // Note ist 6 (Punkte=0)
				FMeldungen.Add( Format( 'Fehler: Abiturfach nicht durchgehend belegt oder kein Eintrag im %d. Abiturfach (%s) im %s (§44 2.1(AG) bzw. §44 3.1 (KL))',
                                [ i, Fachname( fach ), HalbjahrText( j ) ] ) );
        FAbbruch := true;
        exit;
			end;
       // Note ungleich 6
      muss_schr := true;
      if ( i = 4 ) and ( j = C_Q4 ) then
        muss_schr := false; // 4.Abifach muss in Q2.2 nicht schriftlich sein
      if muss_schr and not IstSchriftlich1( fach, j, j  ) then // Kein schriftlicher Kurs
      begin
        FMeldungen.Add( Format( 'Fehler: Kein schriftlicher Kurs im %d. Abiturfach (%s) im %s (§37.1)',
                                [ i, FachName( fach ), HalbjahrText( j ) ] ) );
        exit;
			end;
    end;

// Das Aufgabenfeld ermitteln
    k := 0;
    if InMenge( fach, W1 ) then
      k := 1
    else if InMenge( fach, W2 ) then
      k := 2
    else if InMenge( fach, W3 ) then
      k := 3;
    if k > 0 then
      Sum_Ust_AF[ k ] := Sum_Ust_AF[ k ] + GesamtWochenstunden( fach, C_Q1, C_Q4 );

  end;

// ================================= FOLIE 10 ==================================
// Zwei Sprachen  - zwei GW – Überprüfung von Abiturfachwahlen für konkrete Fehlermeldungen
// Sinngemaäß besser hier
//Sind 2 Fremdsprachen unter den Abiturfächern? A_2FS=TRUE ?
  M_ := Vereinigungsmenge( W1_2, W1_3 ); // die FS
  M_ := Schnittmenge( M_, W_AF ); // die FS unter den Abifächern
  if ( AnzahlElemente( M_ ) >= 2 ) and ( SchnittMenge( W3_1, W_AF ) = '' ) then
  begin
    FMeldungen.Add( 'Fehler: 2 Fremdsprachen können nur zusammen mit Mathematik Abiturfächer sein' );
    FAbbruch := true;
    exit;
  end;

//Sind zwei Gesellschaftswissenschaften unter den Abiturfächern?
//#(AF geschnitten(F2.1 U F2.2) >= 2
  M_ := Vereinigungsmenge( W2_1, W2_2 );
  M_ := Schnittmenge( W_AF, M_ );
  if ( AnzahlElemente( M_ ) >= 2 ) and ( SchnittMenge( W3_1, W_AF ) = '' ) then
  begin
    FMeldungen.Add( 'Fehler: 2 Gesellschaftswissenschaften können nur zusammen mit Mathematik Abiturfächer sein' );
    FAbbruch := true;
    exit;
  end;

// ================================= FOLIE 11 ==================================
//Ku,  Li,  Mu,  Sp   oder   zwei  NW (klass. NW bzw.  IF) – Überprüfung von Abiturfachwahlen für konkrete Fehlermeldungen !
  M_ := Vereinigungsmenge( W1_4, W1_5 ); // musische Fächer
  M_ := Vereinigungsmenge( M_, W5 );
  M_ := Schnittmenge( W_AF, M_ );
  if ( AnzahlElemente( M_ ) >= 1 ) and ( SchnittMenge( W3_1, W_AF ) = '' ) then
  begin
    FMeldungen.Add( 'Fehler: Kunst, Literatur, Musik oder Sport können nur zusammen mit Mathematik Abiturfächer sein' );
    FAbbruch := true;
    exit;
  end;

//Sind zwei klass. Naturwissenschaften  oder eine klass.NW+IF unter den Abiturfächern?
// #(AF geschnitten(F3.2 U F3.3) >= 2
  M_ := Vereinigungsmenge( W3_2, W3_3 );
  M_ := Schnittmenge( W_AF, M_ );
  if AnzahlElemente( M_ ) >= 2 then
  begin
    FMeldungen.Add( 'Fehler: 2 Naturwissenschaften oder eine Naturwissenschaft und Informatik können nicht zusammen Abifächer sein');
    FAbbruch := true;
    exit;
  end else
  begin

// ================================= FOLIE 12 ==================================
//Ku, Li, Mu, Sp in Kombination mit einer  NW/techn. Fach– Überprüfung von Abiturfachwahlen für konkrete Fehlermeldungen
// #(AF geschnitten(F1.4 U F3.2 U F3.3) >= 2
    M_ := Vereinigungsmenge( W1_4, W1_5 );
    M_ := Vereinigungsmenge( M_, W5 );
    M_ := Vereinigungsmenge( M_, W3_2 );
    M_ := Vereinigungsmenge( M_, W3_3 );
    M_ := Schnittmenge( W_AF, M_ );
    if AnzahlElemente( M_ ) >= 2 then
    begin
      FMeldungen.Add( 'Fehler: Ein Fach aus Kunst, Literatur, Musik oder Sport kann nicht mit einer  klass. Naturwissenschaft oder Informatik zusammen Abiturfach sein' );
      FAbbruch := true;
      exit;
    end;
  end;

// ================================= FOLIE 13 ==================================
//Überprüfung, ob jedes Abiturfach in EF2 oder EF1 belegt wurde? (gilt nicht für Quereinsteiger ins III. Semester (Q1.1))
// Prüfung derzeit nicht möglich!!!!!
  if not IstQuereinsteiger then
  begin
    for i := 1 to AnzahlElemente( W_AF ) do
    begin // Schleife über AbiFächer
      fach := EinzelElement( W_AF, i );
      statkrz := StatistikKuerzel( fach );

//Prüfen: i-tes Abifach ODER affines Fach VV 37.12 befindet sich unter der Fachbelegung des 2. Semesters
      if not ( IstBelegt1( fach, C_E2, C_E2  ) or WBK_AffinesFachBelegt( statkrz, C_E2 ) ) then
      begin
// Wenn nicht: i-tes Abifach ODER affines Fach VV 37.12 befindet sich unter der Fachbelegung des 1. Semesters?
        if not ( IstBelegt1( fach, C_E1, C_E1 ) or WBK_AffinesFachBelegt( statkrz, C_E1 ) ) then
        begin
          FMeldungen.Add( 'Fehler: Unzulässige Wahl der Abiturfächer: Ein Fach kann nur dann Abiturfach sein, wenn es in der E-Phase mindestens ein Semester belegt wurde (§ 37 Abs. 1)' );
          FAbbruch := true;
          exit;
        end;
      end;
    end;
  end;


// ================================= FOLIE 14 ==================================
// Klass. NW
// Ist eine klassische NW, sofern nicht Abi-Fach, in zwei Aufeinanderfolgenden Halbjahren belegt?Ist eine  kl. Naturwissenschaft ein Abiturfach: #(AF geschnitten(F3.2)) =1
  if not AbiNW then
  begin
    bel_flag := false;
    for i := 1 to AnzahlElemente( W3_2 ) do
    begin
      fach := EinzelElement( W3_2, i );
      for j := C_Q1 to C_Q3 do
      begin
        bel_flag := IstBelegtPunkte1( fach, j, j+1 );
        if bel_flag then
          break;
      end;
      if bel_flag then
        break;
    end;
    if not bel_flag then
    begin
      FMeldungen.Add( 'Fehler: keine  klass. Naturwissenschaft (PH, BI, CH) in mindestens zwei aufeinanderfolgenden Semestern der Q-Phase belegt' );
      FAbbruch := true;
      exit;
    end;
  end;

// Ab hier markieren
// Die LK's
  for i := 1 to AnzahlElemente( W_LK ) do
  begin
    fach := EinzelElement( W_LK, i );
    for j := C_Q1 to C_Q4 do
    begin
      pkt := Punkte( fach, j );
      pkt_sum_zb := pkt_sum_zb + 2*pkt
    end;
    slZwangsFaecher.Add( fach );
    AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
    inc( anz_markiert_zb, 4 );
  end;

// Die Abi GK's
  M_ := DifferenzMenge( W_AF, W_LK );
  for i := 1 to AnzahlElemente( M_ ) do
  begin
    fach := EinzelElement( M_, i );
    for j := C_Q1 to C_Q4 do
    begin
      pkt := Punkte( fach, j );
      pkt_sum_zb := pkt_sum_zb + pkt
    end;
    slZwangsFaecher.Add( fach );
    AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
    inc( anz_markiert_zb, 4 );
  end;


// ================================= FOLIE 6 DEUTSCH ===========================
// falls D nicht AF, dann  D mit 4 Kursen in die Gesamtqualifikation
	if not AbiD then
	begin		// D nicht Abi-Fach
    for i := 1 to AnzahlElemente( W1_1 ) do
    begin
      fach := EinzelElement( W1_1, i );
      for j := C_Q1 to C_Q4 do
      begin   // Schleife über Halbjahre
        pkt := Punkte( fach, j );
        pkt_sum_zb := pkt_sum_zb + pkt;
        if pkt < 5 then
          Inc( anz_def_zb );
        if pkt = 0 then
        begin   // Note ist 6 (Punkte=0)
          FMeldungen.Add( Format( 'Fehler: %s ist im %s 6 oder nicht belegt',
                                  [  FachName( fach ), HalbjahrText( j ) ] ) );
          FAbbruch := true;
          exit;
        end;
      end;
      Sum_Ust_AF[ 1 ] := Sum_Ust_AF[ 1 ] + GesamtWochenstunden( fach, C_Q1, C_Q4 );

      slZwangsFaecher.Add( fach );
      AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
      inc( anz_markiert_zb, 4 );
    end;
  end;

// ================================= FOLIE 7 MATHE ===========================
// falls M nicht AF, dann  M mit 4 Kursen in die Gesamtqualifikation
	if not AbiM then
	begin		// DMnicht Abi-Fach
    for i := 1 to AnzahlElemente( W3_1 ) do
    begin
      fach := EinzelElement( W3_1, i );
      for j := C_Q1 to C_Q4 do
      begin   // Schleife über Halbjahre
        pkt := Punkte( fach, j );
        pkt_sum_zb := pkt_sum_zb + pkt;
        if pkt < 5 then
          Inc( anz_def_zb );
        if pkt = 0 then
        begin   // Note ist 6 (Punkte=0)
          FMeldungen.Add( Format( 'Fehler: %s ist im %s 6 oder nicht belegt',
                                  [  FachName( fach ), HalbjahrText( j ) ] ) );
          FAbbruch := true;
          exit;
        end;
      end;
      Sum_Ust_AF[ 3 ] := Sum_Ust_AF[ 3 ] + GesamtWochenstunden( fach, C_Q1, C_Q4 );

      slZwangsFaecher.Add( fach );
      AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
      inc( anz_markiert_zb, 4 );
    end;
  end;

// ================================= FOLIE 8 ===================================
// falls 1. FS nicht AF, dann mit 4 Kursen in die Gesamtqualifikation
//Bemerkung:  Die erste Fremdsprache wurde nicht auf Grund der besten Notenpunkte ausgewählt,
//sondern aufgrund der Sprachenfolge in SchildNRW.

	if not Abi1FS then
	begin		// 1. FS nicht Abi-Fach
    M_ := W1_2;
    FS_1 := '';
    for i := 1 to AnzahlElemente( M_ ) do
    begin
      fach := EinzelElement( M_, i );
      if Ist_Erste_FS( fach ) then
      begin
        FS_1 := fach;
        break;
      end;
    end;

    if FS_1 <> '' then
    begin
      fach := FS_1;
      for j := C_Q1 to C_Q4 do
      begin   // Schleife über Halbjahre
        pkt := Punkte( fach, j );
        pkt_sum_zb := pkt_sum_zb + pkt;
        if pkt < 5 then
          Inc( anz_def_zb );
        if pkt = 0 then
        begin   // Note ist 6 (Punkte=0)
          FMeldungen.Add( Format( 'Fehler: 1. Fremdsprache %s ist im %s 6 oder nicht belegt',
                                    [  FachName( fach ), HalbjahrText( j ) ] ) );
          FAbbruch := true;
          exit;
        end;
      end;
      Sum_Ust_AF[ 1 ] := Sum_Ust_AF[ 1 ] + GesamtWochenstunden( fach, C_Q1, C_Q4 );

      slZwangsFaecher.Add( fach );
      AbschnitteMarkieren( fach, C_Q1, C_Q4, '+' );
      inc( anz_markiert_zb, 4 );
    end else
    begin
      FMeldungen.Add( 'Fehler: 1. Fremdsprache konnte nicht ermittelt werden' );
      FAbbruch := true;
      exit;
    end;
  end;

// bis hier Zwangsbelegung
  FAbiErgebnisVerwalter.WurzelKnotenErzeugen( pkt_sum_zb, anz_def_zb, anz_markiert_zb );

// KNOTEN Ausgabgspunkt
  KnotenStrukturenErzeugen;

  FAbiErgebnisVerwalter.Save( slAbiErgebnisListe );

end;

function TAbiturBelegPruefer.PunktsummeBeste2KurseEinesFaches( const fach: string ): integer;
var
  pkt_ar: array[1..4] of integer;
  i, j: integer;
begin
  Result := 0;
  pkt_ar[1] := Punkte( fach, C_Q1 );
  pkt_ar[2] := Punkte( fach, C_Q2 );
  pkt_ar[3] := Punkte( fach, C_Q3 );
  pkt_ar[4] := Punkte( fach, C_Q4 );
  for i := 1 to 3 do
  begin
    for j := i+1 to 4 do
    begin
      if pkt_ar[i] + pkt_ar[j] > Result then
        Result := pkt_ar[i] + pkt_ar[j];
    end;
  end;
end;

function TAbiturBelegPruefer.MarkiermusterBeste2KurseEinesFaches( const fach: string ): string;
var
  pkt_ar: array[1..4] of integer;
  i, j, imax, jmax, pmax: integer;
begin
  Result := '----';
  pmax := 0;
  imax := 0;
  jmax := 0;
  pkt_ar[1] := Punkte( fach, C_Q1 );
  pkt_ar[2] := Punkte( fach, C_Q2 );
  pkt_ar[3] := Punkte( fach, C_Q3 );
  pkt_ar[4] := Punkte( fach, C_Q4 );
  for i := 1 to 3 do
  begin
    for j := i+1 to 4 do
    begin
      if ( pkt_ar[i] > 0 ) and ( pkt_ar[j] > 0 ) and ( pkt_ar[i] + pkt_ar[j] > pmax ) then
      begin
        pmax := pkt_ar[i] + pkt_ar[j];
        imax := i;
        jmax := j;
      end;
    end;
  end;
  if imax > 0 then
    Result[ imax ] := '+';
  if jmax > 0 then
    Result[ jmax ] := '+';
end;



procedure TAbiturBelegPruefer.Knotenebene_1_WBK;
var
  fach, fach_max, statkrz, muster_max: string;
  root_id, anz, i, j, psum, psum_max, pkt, reli_id: integer;
  pkt_ar: array[1..4] of integer;
begin

// Falls Religion AF ist, dann wurden die Kurse schon markiert (Folie 4))
// Wenn RE nicht belegt, dann braucht auch nichts getan zu werden
  if ( FGliederung <> 'KL' ) or AbiRE or ( W4 = '' ) then
  begin
    Knotenebene_2_WBK;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1 );
    exit;
  end;

  root_id := FAbiErgebnisVerwalter.WurzelKnoten;
  MarkierBemerkungen[1] := 'Religion';

// ================================= FOLIE 9 ===================================
 //#(Kurse zu Elementen von W4) ? 2? Religion
  anz := 0;
  for i := 1 to AnzahlElemente( W4 ) do
  begin
    fach := EinzelElement( W4, i );
    anz := AnzahlBelegtPunkte( fach, C_Q1, C_Q4 );
  end;

//Keine Überprüfung des Ersatzfaches lt. VV zu §36 vorgesehen.
// Die Schule soll Religion als Fach vorhalten.
// M.E. muss bei einer Belegung Religion dann aber in die Wertung eingehen,so wie durch §36.3  für KL vorgesehen.
//Wenn die belegten aufeinanderfolgenden Rel-Kurse nicht eingebracht werden sollen,
//dann müssen  sie praktisch  aus den Datensätzen gelöscht werden.

  if anz < 2 then
  begin
    for i := 1 to AnzahlElemente( W4 ) do
    begin
      fach := EinzelElement( W4, i );
      fC0.Locate( 'FachInternKrz', fach , [] );  // den Datensatz  suchen
      reli_id := FC0.FieldByName( 'Fach_ID' ).AsInteger;
      fC0.Delete;// Streiche alle RE-Kurse
      FAbiErgebnisVerwalter.FachAbschnitteFachLoeschen( reli_id );
    end;
    W4 := '';
  end else
  begin
//Suche die  zwei aufeinanderfolgende  Rel.-Kurse  mit den besten Noten
// Semester  j1 und j2 aus Q1.1 bis Q2.2
// $AUFEINANDERFOLGEND$
    psum_max := 0;
    muster_max := '----';
    fach_max := '';
    for i := 1 to AnzahlElemente( W4 ) do
    begin
      fach := EinzelElement( W4, i );
      psum := PunktsummeBeste2KurseEinesFaches( fach );
      if psum > psum_max then
      begin
        psum_max := psum;
        fach_max := fach;
      end;
    end;

    if fach_max <> '' then
    begin
      muster_max := MarkiermusterBeste2KurseEinesFaches( fach_max );
      for j := 1 to length( muster_max ) do
      begin
        if muster_max[j] = '-' then
          continue;
        pkt := Punkte( fach_max, j+2 );
        if pkt = 0 then
        begin   // Note ist 6 (Punkte=0)
          FMeldungen.Add( Format( 'Fehler: %s: Anrechenbare Kurse müssen mit mind. einem Punkt abgeschlossen sein',
                                [  FachName( fach ) ] ) );
          FAbbruch := true;
          exit;
        end;
      end;
      statkrz := StatistikKuerzel( fach_max );
      if not NeuerKnoten( statkrz, muster_max, 1, root_id ) then
        exit;
    end;
  end;
  Knotenebene_2_WBK;
  FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 1 );

end;

procedure TAbiturBelegPruefer.Knotenebene_2_WBK;
var
  fach, fach_max, statkrz, muster_max: string;
  root_id, anz, i, j, psum, psum_max, pkt: integer;
  pkt_ar: array[1..4] of integer;
begin
// ================================= FOLIE 15 ==================================
//Bearbeitung Naturwissenschaft ( Naturwissenschaft nicht Abiturfach)
//mind. eine  klass. Naturwissenschaft in zwei aufeinanderfolgenden Semestern
  if AbiNW then
  begin
    Knotenebene_3_WBK;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 2 );
    exit;
  end;

  MarkierBemerkungen[2] := 'Naturwissenschaften';
  root_id := FAbiErgebnisVerwalter.WurzelKnoten;

//Suche  das klass. NW-Fach (GKS/GKM) mit der größeren
//Punktsumme  in zwei aufeinanderfolgenden Semestern  k, k+1 von Q1.1 bis Q2.2
// $AUFEINANDERFOLGEND$
  if not AbiNW then
  begin
    psum_max := 0;
    muster_max := '----';
    fach_max := '';
    for i := 1 to AnzahlElemente( W3_2 ) do
    begin
      fach := EinzelElement( W3_2, i );
      psum := PunktsummeBeste2KurseEinesFaches( fach );
      if psum > psum_max then
      begin
        psum_max := psum;
        fach_max := fach;
      end;
    end;

    if fach_max <> '' then
    begin
      muster_max := MarkiermusterBeste2KurseEinesFaches( fach_max );
      for j := 1 to length( muster_max ) do
      begin
        if muster_max[j] = '-' then
          continue;
        pkt := Punkte( fach_max, j+2 );
        if pkt = 0 then
        begin   // Note ist 6 (Punkte=0)
          FMeldungen.Add( Format( 'Fehler: %s: Anrechenbare Kurse müssen mit mind. einem Punkt abgeschlossen sein',
                                [  FachName( fach ) ] ) );
          FAbbruch := true;
          exit;
        end;
        Sum_Ust_AF[ 3 ] := Sum_Ust_AF[ 3 ] + FC0.FieldByName( Format( 'WS_%d', [ j+2 ] ) ).AsInteger;
      end;

      statkrz := StatistikKuerzel( fach_max );
      if not NeuerKnoten( statkrz, muster_max, 2, root_id ) then
        exit;
      Knotenebene_3_WBK;
      FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 2 );
    end;
  end;
end;

procedure TAbiturBelegPruefer.Knotenebene_3_WBK;
var
  grp_ids, M_, fach, statkrz, markier_muster: string;
  fach_id, abschnitt, punkte, root_id, w_std: integer;
begin
  if ( FGliederung <> 'KL' ) or ( Schulstunden( Sum_Ust_AF[ 3 ] ) >= 22 ) then
  begin
    Knotenebene_4_WBK;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 3 );
    exit;
  end;

// ================================= FOLIE 17 ==================================
//Bearbeitung  Aufgabenfeld III   (M bereits berücksichtigt)
//Auffüllen der Kurse bis 22 Wochenstunden  (Bildungsgang Kolleg)

  M_ := VereinigungsMenge( W3_2, W3_3 );
  grp_ids := Fach_IDs_VonGruppe( M_ );

  MarkierBemerkungen[3] := 'Aufgabenfeld III: Auffüllen auf 22 WStd.';

  while true do
  begin
    markier_muster := '----';
    if not FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( grp_ids, fach_id, abschnitt, punkte ) then
      break;

    fach := FachKuerzel_aus_ID( fach_id );
    statkrz := StatistikKuerzel( fach );
    root_id := FAbiErgebnisVerwalter.WurzelKnoten;
    markier_muster[ abschnitt - 2 ] := '+';
    if not NeuerKnoten( statkrz, markier_muster, 3, root_id ) then
      exit;
    w_std := GesamtWochenstunden( fach, abschnitt, abschnitt );
    Sum_Ust_AF[ 3 ] := Sum_Ust_AF[ 3 ] + w_std;

//    FAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen( fach_id, abschnitt, 3 ); // Oder 2???

    if Schulstunden( Sum_Ust_AF[ 3 ] ) >= 22 then
      break;
  end;

  if Schulstunden( Sum_Ust_AF[ 3 ] ) < 22 then
  begin
    FMeldungen.Add( 'Zu wenig belegte Kurse in Aufgabenfeld III' );
    FAbbruch := true;
  end else
  begin
    Knotenebene_4_WBK;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 3 );
  end;

end;

procedure TAbiturBelegPruefer.Knotenebene_4_WBK;
var
  grp_ids, M_, fach, statkrz, markier_muster: string;
  fach_id, abschnitt, punkte, root_id, w_std: integer;
begin
  if ( FGliederung <> 'KL' ) or ( Schulstunden( Sum_Ust_AF[ 2 ] ) >= 16 ) then
  begin
    Knotenebene_5_WBK;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 4 );
    exit;
  end;

// ================================= FOLIE 18 ==================================
//Bearbeitung  Aufgabenfeld II
//Auffüllen der Kurse bis 16 Wochenstunden  (Bildungsgang Kolleg)

  M_ := VereinigungsMenge( W2_1, W2_2 );
  M_ := VereinigungsMenge( M_, W2_3 );
  M_ := VereinigungsMenge( M_, W2_4 );
  grp_ids := Fach_IDs_VonGruppe( M_ );

  MarkierBemerkungen[4] := 'Aufgabenfeld II: Auffüllen auf 16 WStd.';

  while true do
  begin
    markier_muster := '----';
    if not FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( grp_ids, fach_id, abschnitt, punkte ) then
      break;

    fach := FachKuerzel_aus_ID( fach_id );
    statkrz := StatistikKuerzel( fach );
    root_id := FAbiErgebnisVerwalter.WurzelKnoten;
    markier_muster[ abschnitt - 2 ] := '+';
    if not NeuerKnoten( statkrz, markier_muster, 4, root_id ) then
      exit;
    w_std := GesamtWochenstunden( fach, abschnitt, abschnitt );
    Sum_Ust_AF[ 2 ] := Sum_Ust_AF[ 2 ] + w_std;

//    FAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen( fach_id, abschnitt, 4 ); // Oder 3???

    if Schulstunden( Sum_Ust_AF[ 2 ] ) >= 16 then
      break;
  end;

  if Schulstunden( Sum_Ust_AF[ 2 ] ) < 16 then
  begin
    FMeldungen.Add( 'Zu wenig belegte Kurse in Aufgabenfeld II' );
    FAbbruch := true;
  end else
  begin
    Knotenebene_5_WBK;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 4 );
  end;

end;

procedure TAbiturBelegPruefer.Knotenebene_5_WBK;
var
  grp_ids, M_, fach, statkrz, markier_muster: string;
  fach_id, abschnitt, punkte, root_id, w_std: integer;
begin
  if ( FGliederung <> 'KL' ) or ( Schulstunden( Sum_Ust_AF[ 1 ] ) >= 24 ) then
  begin
    Knotenebene_6_WBK;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 5 );
    exit;
  end;

// ================================= FOLIE 19 ==================================
//Bearbeitung  Aufgabenfeld I
//Auffüllen der Kurse bis 24 Wochenstunden  (Bildungsgang Kolleg)

  M_ := VereinigungsMenge( W1_1, W1_2 );
  M_ := VereinigungsMenge( M_, W1_3 );
  M_ := VereinigungsMenge( M_, W1_4 );

  grp_ids := Fach_IDs_VonGruppe( M_ );

  MarkierBemerkungen[5] := 'Aufgabenfeld I: Auffüllen auf 24 WStd.';

  while true do
  begin
    markier_muster := '----';
    if not FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( grp_ids, fach_id, abschnitt, punkte ) then
      break;

    fach := FachKuerzel_aus_ID( fach_id );
    statkrz := StatistikKuerzel( fach );
    root_id := FAbiErgebnisVerwalter.WurzelKnoten;
    markier_muster[ abschnitt - 2 ] := '+';
    if not NeuerKnoten( statkrz, markier_muster, 5, root_id ) then
      exit;
    w_std := GesamtWochenstunden( fach, abschnitt, abschnitt );
    Sum_Ust_AF[ 1 ] := Sum_Ust_AF[ 1 ] + w_std;

//    FAbiErgebnisVerwalter.OberstenEintragAusRestelisteLoeschen( fach_id, abschnitt, 5 ); // Oder 4???

    if Schulstunden( Sum_Ust_AF[ 1 ] ) >= 24 then
      break;
  end;

  if Schulstunden( Sum_Ust_AF[ 1 ] ) < 24 then
  begin
    FMeldungen.Add( 'Zu wenig belegte Kurse in Aufgabenfeld I' );
    FAbbruch := true;
  end else
  begin
    Knotenebene_6_WBK;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 5 );
  end;

end;

procedure TAbiturBelegPruefer.Knotenebene_6_WBK;
// Berechnung Projektkusr
var
  root_id: integer;
  fach, statkrz, markier_muster: string;
  i: integer;
var
  cntNode: integer;
begin
  ProjZwang := false;

//  if DebugHook <> 0 then
//    HatProjektkurs := false;

  if not HatProjektkurs then
  begin
    Knotenebene_7_WBK;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 6 );
    exit;
  end;

  MarkierBemerkungen[6] := 'Projektkurs';

  if not ProjZwang then
  begin  // arbeite die noch folgenden markierungen einmal gänzlich ohne Projektkurs( ProjMark = false) und einmal mit markiertem Projektkurs (ProjMark=True) ab
// Aufruf ohne Projektkurs
    ProjMark := false;
//      FAbiErgebnisVerwalter.ZwischenstandSpeichern;
    root_id := FAbiErgebnisVerwalter.WurzelKnoten;
    Knotenebene_7_WBK;
    FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 6 );
//    FAbiErgebnisVerwalter.FachAbschnitteSortieren;

    if not FAbbruch then
    begin
// Jetzt mit Projektkurs
      ProjMark := true;
//        FAbiErgebnisVerwalter.ZwischenstandWiederherstellen;
      fach := EinzelElement( W_PF, 1 );
      markier_muster := '????';
      if IstBelegtPunkte( fach, C_Q1, C_Q4, markier_muster ) then
      begin
        for i := 1 to 4 do
          if markier_muster[i] = '?' then
            markier_muster[i] := '-';
        if markier_muster <> '----' then
        begin
          statkrz := StatistikKuerzel( fach );
          if not NeuerKnoten( statkrz, markier_muster, 6, root_id ) then
            exit;
        end;
      end;
      Knotenebene_7_WBK;
      FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 6 );
//      FAbiErgebnisVerwalter.FachAbschnitteSortieren;
    end;
  end else // markiere die zwei Halbjahre des Projektkurses
  begin
    fach := EinzelElement( W_PF, 1 );
    markier_muster := '????';
    if IstBelegtPunkte( fach, C_Q1, C_Q4, markier_muster ) then
    begin
      for i := 1 to 4 do
        if markier_muster[i] = '?' then
          markier_muster[i] := '-';
      root_id := FAbiErgebnisVerwalter.WurzelKnoten;
      if markier_muster <> '----' then
      begin
        MarkierBemerkungen[6] := 'Projektkurs';
        statkrz := StatistikKuerzel( fach );
        if not NeuerKnoten( statkrz, markier_muster, 6, root_id ) then // autom. Sprinbgen in nächsten Knoten unterdrücken
          exit;
      end;
    end;
  end;

end;


procedure TAbiturBelegPruefer.Knotenebene_7_WBK;
var
  MarkKurse, defizite: integer;
  fach_id, abschnitt : integer;

  procedure Auffuellen;
  var
    fach, statkrz, markier_muster: string;
    root_id: integer;
  begin
    markier_muster := '----';
    fach := FachKuerzel_aus_ID( fach_id );
    statkrz := StatistikKuerzel( fach );
    root_id := FAbiErgebnisVerwalter.WurzelKnoten;
    inc( MarkKurse );
    markier_muster[ abschnitt - 2 ] := '+';
    NeuerKnoten( statkrz, markier_muster, 7, root_id ); // Hier wird auch der Eintrag gelöscht!!!
  end;

  function DefiziteUeberschritten: boolean;
  begin
    Result := false;
    if FGliederung = 'KL' then
    begin
      if Between( MarkKurse, 28, 32 ) then
        Result := defizite > 6
      else if Between( MarkKurse, 33, 34 ) then
        Result := defizite > 7;
    end else
    begin
      if Between( MarkKurse, 16, 17 ) then
        Result := defizite > 3
      else if Between( MarkKurse, 18, 22 ) then
        Result := defizite > 4
      else if Between( MarkKurse, 23, 24 ) then
        Result := defizite > 5;
    end;

  end;

var
  minKurse, maxKurse, punkte: integer;
  DS, DS_neu : double;
  markier_muster: string;
begin

  MarkierBemerkungen[7] := 'Auffüllen auf Mindestkurszahl';

  FAbiErgebnisVerwalter.ProjektkurseLoeschen( 7 );

  FAbiErgebnisVerwalter.FachAbschnitteSortieren;

// Zähle die markierten Kurse
  MarkKurse := FAbiErgebnisVerwalter.AnzahlMarkierteKurse;
  if FGliederung = 'KL' then
    minKurse := C_MIN_KURSE_WB_KL
  else
    minKurse := C_MIN_KURSE_WB_AG;

  while ( MarkKurse < minKurse ) do
  begin
    if FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fach_id, abschnitt, punkte ) then
      Auffuellen
    else
    begin
      if not HatProjektkurs or ProjMark then
      begin
        FAbbruch := true;
        FMeldungen.Add( 'Keine Abiturzulassung! Zu wenig Kurse in Block I' );
        break;
      end else
      begin
        ProjZwang := true;
        break;
      end;
    end;
  end;

  if not FAbbruch and ProjZwang then
  begin

    KnotenStrukturenErzeugen // wieder auf Start

  end else
  begin

// Durchschnitt berechnen
//
    MarkierBemerkungen[7] := 'Auffüllen zur Durchschnittsverbesserung';
    DS := FAbiErgebnisVerwalter.Durchschnitt;
    if FGliederung = 'KL' then
      maxKurse := C_MAX_KURSE_WB_KL
    else
      maxKurse := C_MAX_KURSE_WB_AG;

    while true do
    begin
      if MarkKurse >= maxKurse then
        break;
      if not FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fach_id, abschnitt, punkte ) then
      begin
        if Debughook <> 0 then
          defizite := FAbiErgebnisVerwalter.DefizitSumme;    // nur für Breakpoint
        break;
      end;

      if DS >= punkte then
        break;
      Auffuellen;
      if MarkKurse >= maxKurse then
        break;
    end;

    MarkierBemerkungen[7] := 'Auffüllen zum Defizitausgleich';
    defizite := FAbiErgebnisVerwalter.DefizitSumme;
    while ( MarkKurse < maxKurse ) and FAbiErgebnisVerwalter.RestelisteBelegt and DefiziteUeberschritten do
    begin
      if FAbiErgebnisVerwalter.OberstenEintragAusRestelisteHolen( fach_id, abschnitt, punkte ) then
      begin
        if punkte >= 5 then
          Auffuellen
        else
          break;
      end else
        break;
    end;

    if DefiziteUeberschritten then
    begin
      FAbbruch := true;
      FMeldungen.Add( 'Keine Abiturzulassung! Zu viele Defizite in Block I' );
    end;

    FAbiErgebnisVerwalter.EinzelErgebnisBerechnen;

  end;

end;

end.



Bei den Abweichungsprüfungen und Bestehensprüfungen gibt es noch verbesserungsbedarf in LuPO und Schild. Folgende Regeln fehlen noch
a) in beiden LKs muss eine Bestehensprüfung angesetzt werden, wenn in beiden LKs weniger als 5 Punkte erreicht wurden.
b) muss ein Schüler in einem LK in die Abweichungsprüfung, so muss das Gesamtergebnis des entsprechenden LKs mit einem prognostizierten mündlichen Prüfungsergebnis von 0 Punkten vorausberechnet werden. Entstehen auf diese weise wieder zwei LK-Defizite, muss eine Bestehensprüfung in dem zweiten LK angesetzt werden.
c) Sobald der Schüler alle zwingend notwendigen Abweichungsprüfungen absolviert hat, keine zwei LK-Defizite hat und mehr als 99 Punkte in Block II hat, werden alle noch angesetzten und nicht durchgeführten Bestehensprüfungen deaktiviert (wenn er durch ist ist er durch).



  procedure ReligionsmarkierungPruefen;
  // Berechnung RE
  var
    Hj: TStringList;
    Hj_belegt: TStringList;
    bAnzahl: integer;

    procedure GruppePruefen( const gruppe, gruppen_name: string );
    var
      i, j, ja, anzahl: integer;
      markier_muster, fach: string;

    begin
      for i := 1 to AnzahlElemente( gruppe ) do
      begin
        fach := EinzelElement( gruppe, i );
        for j := 0 to Hj.Count - 1 do
        begin // Schleife über verbleibende Hj
          ja := StrToInt( Hj[j] );
          markier_muster := '';
          if IstBelegtPunkte( fach, ja, ja, markier_muster ) then
          begin
            Hj_belegt.Add( Hj[ j ] );
            Hj[ j ] := '0'; // Entferne das Halbjahr aus {Hj} und füge es in {HjBelegt} ein
            if bAnzahl < 2 then
              inc( bAnzahl );
          end;
        end;
      end;
// Am Ende der Schleife:
// Suche in {Gruppe} in allen Halbjahren aus {HjBelegt}: Wurden bAnzahl Kurse markiert?
      anzahl := 0;
      for i := 1 to AnzahlElemente( gruppe ) do
      begin
        fach := EinzelElement( gruppe, i );
        for j := 0 to Hj_belegt.Count - 1 do
        begin
          ja := StrToInt( Hj_belegt[j] );
          markier_muster := '';
          if IstBelegtPunkte( fach, ja, ja, markier_muster ) then
            inc( anzahl );
        end;
      end;
      if anzahl < bAnzahl then
      begin
        FMeldungen.Add( Format( 'Es müssen %d Kurse %s markiert werden.', [ bAnzahl, gruppen_name ] ) );
        FAbbruch := true;
      end;
//      Aufraeumen;
    end;

    function ReliErsatzPruefen( const M_: string; const nur_hj: boolean ): boolean;
    var
      i, j, ja, iAnz1, iAnz2: integer;
      fach: string;
    begin
      Result := false;
      iAnz1 := 0;
      iAnz2 := 0;
      for i := 1 to AnzahlElemente( M_ ) do
      begin
        fach := EinzelElement( M_, i );
        iAnz1 := iAnz1 + AnzahlMarkiert( fach, C_Q1, C_Q4, '-ZK' );
        for j := 0 to Hj.Count - 1 do
        begin
          ja := StrToInt( Hj[j] );
          iAnz2 := iAnz2 + AnzahlMarkiert( fach, ja, ja, '-ZK' );
        end;
        if nur_hj then
          Result := iAnz2 >= reli_rest
        else
          Result := ( iAnz1 >= 2 + reli_rest ) and ( iAnz2 >= reli_rest );
        if Result then
          exit;
      end;
    end;

  var
    markier_muster, fach, M_: string;
    i, j, ix, iMarkiert, iBelegt, fgr: integer;
    is_ok, bel: boolean;
  begin
    Hj := TStringList.Create;
    Hj_belegt := TStringList.Create;
    try
// 14. Setze Hj={Q1.1, Q1.2, Q2.1, Q2.2}, iBelegt=0,iMarkiert=0, ReliRest=2
      Hj.Add( '3' );
      Hj.Add( '4' );
      Hj.Add( '5' );
      Hj.Add( '6' );

      iMarkiert := 0;
      iBelegt := 0;
      reli_rest := 2;
      markier_muster := '';

      for fgr := 1 to 3 do
      begin
        M_ := '';
        case fgr of
        1 : M_ := W4eigen;
        2 : M_ := VereinigungsMenge( M_, W4 );
// NEU Jan. 2014 W2_4 auch wenn nicht Abifach
//        3 : if Schnittmenge( W2_4, W_AF ) = '' then  // und W2.4, wenn W2.4 nicht Abifach
//              M_ := Vereinigungsmenge( M_, W2_4 );
        3 : M_ := Vereinigungsmenge( M_, W2_4 );
        end;


// 14.a Schleife über alle Halbjahre aus Hj
        for i := C_Q1 to C_Q4 do
        begin // Schleife über alle Halbjahre
  // iBelegt = 2 ?
          if iMarkiert = 2 then
            break;
  // Schleife über alle Fächer in W4Eigen, W4 (und W2.4, wenn W2.4 nicht einziges Abifach aus W2)
  //NEU Jan. 2014: Schleife über alle Fächer in W4Eigen, W4 und W2_4
          for j := 1 to AnzahlElemente( M_ ) do
          begin
            fach := EinzelElement( M_, j );
  // Gibt es eine Note ? NEU: Hier gilt auch 0 Punkte als Note
            FFuerAbitur := false; // Abschalten, damit 0 Punkte auch als Belegt genommen werden
            bel := IstBelegt1( fach, i, i );
            FFuerAbitur := true;
            if bel then
              bel := Punkte( fach, i ) >= 0;
            if bel then
            begin
  // Wurde das Fach markiert?
              if AnzahlMarkiert( fach, i, i ) = 1 then
              begin
                inc( iMarkiert );
                if iBelegt < 2 then
                  inc( iBelegt );
  // Brich die Schleife ab
                break;
              end else
              begin // nein
                if iBelegt < 2 then
                  inc( iBelegt );
                ix := Hj.IndexOf( IntToStr( i ) );
                HJ.Delete( ix );
                break;
              end;
            end;
          end;

        end; // Schleife über Halbjahre
// 14.b
        if ( iMarkiert  < 2 ) and ( iBelegt > iMarkiert ) then
        begin
          if iBelegt-iMarkiert > 1 then
            FMeldungen.Add( Format( 'Es müssen noch %d Religionskurse (oder Philosphie) markiert werden.', [ iBelegt-iMarkiert ] ) )
          else
            FMeldungen.Add( 'Es muss noch 1 Religionskurs (oder Philosphie) markiert werden.' );
          FAbbruch := true;
          break;
        end;
      end;

//15.	Wenn iBelegt < 2

      reli_rest := reli_rest - iBelegt;

      if not FAbbruch and ( iBelegt < 2 ) then
      begin
        is_ok := false;

//  a.	GEZK = False: Wurden 2+Relirest Kurse aus W2.1 \ AF in Q1.1 bis Q2.2 markiert und
//                    Relirest Kurse aus W2.1 ohne ZK/AF in {Hj} markiert?
        if not is_ok {and not GE_ZK }then
        begin
          M_ := Differenzmenge( W2_1, W_AF );
          if M_ <> '' then
            is_ok := ReliErsatzPruefen( M_, false ) and
                     ReliErsatzPruefen( M_, true );
        end;

//  Oder: SWZK = False: Wurden 2+Relirest Kurse aus W2.2/AF in Q1.1 bis Q2.2 markiert und
//                      Relirest Kurse aus W2.2 ohne ZK /AF in {Hj} markiert
        if not is_ok {and not SW_ZK }then
        begin
          M_ := Differenzmenge( W2_2, W_AF );
          if M_ <> '' then
            is_ok := ReliErsatzPruefen( M_, false ) and
                     ReliErsatzPruefen( M_, true );
        end;

//  Oder: GEZK = True: Wurden Relirest Kurse aus W2.1 ohne ZK /AF in {Hj} markiert?
        if not is_ok {and GE_ZK} then
        begin
          M_ := Differenzmenge( W2_1, W_AF );
          if M_ <> '' then
            is_ok := ReliErsatzPruefen( M_, true );
        end;

//  Oder: SWZK = True: Wurden Relirest Kurse aus W2.2 ohne ZK/AF in {Hj} markiert?
        if not is_ok {and SW_ZK} then
        begin
          M_ := Differenzmenge( W2_2, W_AF );
          if M_ <> '' then
            is_ok := ReliErsatzPruefen( M_, true );
        end;

//  Oder wurden Relirest Kurse aus W2.3/AF in {Hj} markiert
        if not is_ok then
        begin
          M_ := Differenzmenge( W2_3, W_AF );
          if M_ <> '' then
            is_ok := ReliErsatzPruefen( M_, true );
        end;

        if not is_ok then
        begin
          FMeldungen.Add( Format( 'Es müssen %d Halbjahres-Kurse in einem Religionsersatzfach aus dem gesellschaftswissenschaftlichen Aufgabenfeld markiert werden.' +
                                  ' Abiturfächer oder Pflichtfächer sind keine Religionsersatzfächer',
                                  [ reli_rest ] ) );
          FAbbruch := true;
        end;
      end;

    finally
      FreeAndNil( Hj );
      FreeAndNil( Hj_belegt );
    end;

  end;







  end else
  begin

  Hj := TStringList.Create;
  Hj_ges := TStringList.Create;

  try

    for i := 3 to 6 do
    begin
      Hj.Add( IntToStr( i ) );
      Hj_ges.Add( IntToStr( i ) );
    end;

// Fülle zuesrt die Menge MReli (=FREliTemp )
    reli_rest := 2;

// Schleife über alle Halbjahre in W4Eigen, W4 (und 2.4 wenn kein Abifach) in dieser Reihenfolge. Ist eine Note vorhanden
// NEU Jan. 2014: Schleife über alle Halbjahre in W4Eigen, W4 und W2.4 in dieser Reihenfolge. Ist eine Note vorhanden

    FReliTemp.EmptyTable;

    for i := C_Q1 to C_Q4 do
    begin

//      if ( W4 <> '' ) and ( W4eigen <> '' ) and InMenge( W4eigen, W4 ) then
//      begin
//        FC0.Locate( 'FachStatKrz', W4Eigen, [] );
//        fach := FC0.FieldByname( 'FachInternKrz' ).AsString;
//        markier_muster := '';
//        if IstBelegtPunkte( fach, i, i, markier_muster ) then
//        begin
//          FachInMengeRein( fach, i, 3 );
//{          ix := Hj.IndexOf( IntToStr( i ) );
//          if ix >= 0 then
//            Hj.Delete( ix );}
//          continue; // Wenn eigene Religin mit Note, dann zum nächsten Halbjahr
//        end;
//      end;
 // Jetzt W4
      reli_gefunden := false;
//      M_ := Differenzmenge( W4, W4eigen );
      M_ := W4;
      for j := 1 to AnzahlElemente( M_ ) do
      begin
        fach := EinzelElement( M_, j );
        markier_muster := '';
        if IstBelegtPunkte( fach, i, i, markier_muster ) then
        begin
          reli_gefunden := true;
          FachInMengeRein( fach, i, 2 );
{          ix := Hj.IndexOf( IntToStr( i ) );
          if ix >= 0 then
            Hj.Delete( ix );}
        end;
      end;

// und W2.4 wenn Reli nicht einziges Abifach
// Frage an Raffenberg: Wurde dieser Punkt wieder rausgenommen??
{      if not Nur_PL_AF then
      begin
        M_ := W2_4;
        for j := 1 to AnzahlElemente( M_ ) do
        begin
          fach := EinzelElement( M_, j );
          markier_muster := '';
          if IstBelegtPunkte( fach, i, i, markier_muster ) then
          begin
            reli_gefunden := true;
            FachInMengeRein( fach, i );
          end;
        end;
      end;}

      if reli_gefunden then
        continue;

// wenn PL nicht Abifach
// NEU Jan. 2014:
//      if not AbiPL then
      begin
        M_ := W2_4;
        for j := 1 to AnzahlElemente( M_ ) do
        begin
          fach := EinzelElement( M_, j );
          markier_muster := '';
          if IstBelegtPunkte( fach, i, i, markier_muster ) then
            FachInMengeRein( fach, i, 1 );
        end;
      end;

    end; // Schleife über Halbjahre

// b: Suche in der Menge MReli nach der besten Note.
    bk_alt := 0;
    with FReliTemp do
    begin
      SortByFields( 'Wichtung DESC,Punkte DESC' ); // Sortieren
      First;
      while not Eof do
      begin // Schleife über alle Fächer
        fach := FieldByName( 'Fach' ).AsString;
        statkrz:= StatistikKuerzel( fach );
        markier_muster := '----';
        bk := FieldByName( 'Abschnitt' ).AsInteger;
        if bk <> bk_alt then
        begin // Nehme nur Fach aus unterscheidlichen Abschnitten
          MarkierBemerkungen[6] := 'RE: Fall 14 a';
          markier_muster[ bk - 2 ] := '+';
          root_id := FAbiErgebnisVerwalter.WurzelKnoten;
          if not NeuerKnoten( statkrz, markier_muster, 6, root_id ) then
            exit;
          ix := Hj.IndexOf( IntToStr( bk ) );
          if ix >= 0 then
            HJ.Delete( ix );
          dec( reli_rest );
          bk_alt := bk;
        end;
        if reli_rest = 0 then
          break
        else
          Next;
      end;
      EmptyTable;
    end;

    if {not AbiReErsatz and }(Reli_Rest > 0 ) then
    begin
      MarkierBemerkungen[6] := 'RE: Fall 14 d';
      if not ReliRestMarkierung then
        exit;
    end;

  finally
    FreeAndNil( Hj );
    FreeAndNil( Hj_ges );
  end;

// Besonderheit des RE-Knotens: Hier wird explizit der nächste Knoten (C_EBENE_GW) aufgerufen
  Knotenebene_7_GY_GE;
  FAbiErgebnisVerwalter.KnotenEbeneWiederherstellen( 6 );


