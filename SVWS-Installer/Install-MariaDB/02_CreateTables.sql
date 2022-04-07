--
-- Definition for table K_TXTDATEIEN: 
--

-- CREATE TABLE K_TXTDATEIEN (
--   BEZEICHNUNG varchar(32) NULL,
--   TEXT_ID int NOT NULL,
--   TEXT_BODY text NULL,
--   Sichtbar varchar(1) NULL,
--   Sortierung int NULL,
--   SchulnrEigner int NOT NULL
-- )
-- ;

--
-- Definition for table K_Adressart : 
--

CREATE TABLE K_Adressart (
  ID int NOT NULL,
  Bezeichnung varchar(30) NOT NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_Adressart_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_AllgAdresse : 
--

CREATE TABLE K_AllgAdresse (
  ID int NOT NULL,
  AllgAdrAdressArt varchar(30) NOT NULL,
  AllgAdrName1 varchar(50) NULL,
  AllgAdrName2 varchar(50) NULL,
  AllgAdrStrasse varchar(50) NULL,
  AllgAdrPLZ varchar(10) NULL,
  AllgAdrTelefon1 varchar(20) NULL,
  AllgAdrTelefon2 varchar(20) NULL,
  AllgAdrFax varchar(20) NULL,
  AllgAdrEmail varchar(100) NULL,
  AllgAdrBemerkungen varchar(255) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  AllgAdrAusbildungsBetrieb varchar(1) DEFAULT '-' NULL,
  AllgAdrBietetPraktika varchar(1) DEFAULT '-' NULL,
  AllgAdrBranche varchar(50) NULL,
  AllgAdrZusatz1 varchar(10) NULL,
  AllgAdrZusatz2 varchar(10) NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  Massnahmentraeger varchar(1) DEFAULT '-' NULL,
  BelehrungISG varchar(1) DEFAULT '-' NULL,
  GU_ID varchar(40) NULL,
  ErwFuehrungszeugnis varchar(1) DEFAULT '-' NULL,
  ExtID varchar(50) NULL,
  CONSTRAINT K_AllgAdresse_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table AllgAdrAnsprechpartner : 
--

CREATE TABLE AllgAdrAnsprechpartner (
  ID int NOT NULL,
  Adresse_ID int NULL,
  Name varchar(60) NULL,
  Vorname varchar(60) NULL,
  Anrede varchar(10) NULL,
  Telefon varchar(20) NULL,
  EMail varchar(100) NULL,
  Abteilung varchar(50) NULL,
  SchulnrEigner int NULL,
  Titel varchar(15) NULL,
  GU_ID varchar(40) NULL,
  CONSTRAINT Ansprechpartner_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table EigeneSchule : 
--

CREATE TABLE EigeneSchule (
  ID int NULL,
  SchulformNr varchar(3) NULL,
  SchulformKrz varchar(3) NULL,
  SchulformBez varchar(50) NULL,
  SchultraegerArt varchar(2) NULL,
  SchultraegerNr varchar(6) NULL,
  Schulgliederung varchar(3) NULL,
  SchulNr varchar(6) NULL,
  Bezeichnung1 varchar(50) NULL,
  Bezeichnung2 varchar(50) NULL,
  Bezeichnung3 varchar(50) NULL,
  Strasse varchar(50) NULL,
  PLZ varchar(10) NULL,
  Ort varchar(50) NULL,
  Telefon varchar(20) NULL,
  Fax varchar(20) NULL,
  Email varchar(100) NULL,
  Ganztags varchar(1) DEFAULT '+' NULL,
  Schuljahr smallint NULL,
  SchuljahrAbschnitt smallint NULL,
  AnzahlAbschnitte smallint DEFAULT 2 NULL,
  Fremdsprachen varchar(1) DEFAULT '+' NULL,
  UpdateSprachenfolge varchar(1) DEFAULT '+' NULL,
  JVAZeigen varchar(1) DEFAULT '-' NULL,
  RefPaedagogikZeigen varchar(1) DEFAULT '-' NULL,
  AnzJGS_Jahr smallint DEFAULT 1 NULL,
  AbschnittBez varchar(20) DEFAULT 'Halbjahr' NULL,
  BezAbschnitt1 varchar(10) DEFAULT '1. Hj' NULL,
  BezAbschnitt2 varchar(10) DEFAULT '2. Hj' NULL,
  IstHauptsitz varchar(1) DEFAULT '+' NULL,
  NotenGesperrt varchar(1) DEFAULT '-' NULL,
  BezAbschnitt3 varchar(10) NULL,
  BezAbschnitt4 varchar(10) NULL,
  ZurueckgestelltAnzahl int NULL,
  ZurueckgestelltWeibl int NULL,
  ZurueckgestelltAuslaender int NULL,
  ZurueckgestelltAuslaenderWeibl int NULL,
  ZurueckgestelltAussiedler int NULL,
  ZurueckgestelltAussiedlerWeibl int NULL,
  TeamTeaching varchar(1) NULL,
  AbiGruppenprozess varchar(1) NULL,
  DauerUnterrichtseinheit int NULL,
  Gruppen8Bis1 int NULL,
  Gruppen13Plus int NULL,
  InternatsplaetzeM int NULL,
  InternatsplaetzeW int NULL,
  InternatsplaetzeNeutral int NULL,
  SchulLogo longblob NULL,
  SchulnrEigner int NULL,
  SchulleiterName varchar(50) NULL,
  SchulleiterVorname varchar(30) NULL,
  SchulleiterAmtsbez varchar(30) NULL,
  SchulleiterGeschlecht int NULL,
  StvSchulleiterName varchar(50) NULL,
  StvSchulleiterVorname varchar(30) NULL,
  StvSchulleiterAmtsbez varchar(30) NULL,
  StvSchulleiterGeschlecht int NULL,
  Einstellungen text NULL,
  Fehlstundenmodell_PrS1 varchar(1) DEFAULT 'G' NULL,
  Fehlstundenmodell_S2 varchar(1) DEFAULT 'F' NULL,
  Tendenznoten_S1 varchar(1) DEFAULT '-' NULL,
  WebKL_Modus varchar(1) DEFAULT 'A' NULL,
  WebMahnungenGesperrt varchar(1) DEFAULT '-' NULL,
  WebNotenGesperrt varchar(1) DEFAULT '-' NULL,
  LogoFormat varchar(3) NULL,
  SchILDweb_Config text NULL,
  WebTeilLeistungenAnlegen varchar(1) DEFAULT '-' NULL,
  WebInfoMail varchar(1) DEFAULT '-' NULL,
  WebAdresse varchar(100) NULL,
  Land varchar(50) NULL,
  Einstellungen2 text NULL,
  SchulleiterTitel varchar(10) NULL,
  StvSchulleiterTitel varchar(10) NULL
)
;

--
-- Definition for table K_Lehrer : 
--

CREATE TABLE K_Lehrer (
  ID int NOT NULL,
  Kuerzel varchar(10) NOT NULL,
  LIDKrz varchar(4) NULL,
  Nachname varchar(30) NOT NULL,
  Vorname varchar(20) NULL,
  Anrede varchar(10) NULL,
  Titel varchar(20) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  Geburtsdatum date NULL,
  Geschlecht varchar(1) NULL,
  SerNr varchar(5) NULL,
  StaatKrz varchar(3) NULL,
  Rechtsverhaeltnis varchar(1) NULL,
  Beschaeftigungsart varchar(2) NULL,
  Einsatzstatus varchar(1) NULL,
  PflichtstdSoll float NULL,
  UnterrichtsStd float NULL,
  Strasse varchar(50) NULL,
  PLZ varchar(10) NULL,
  Tel varchar(20) NULL,
  Handy varchar(20) NULL,
  EMail varchar(100) NULL,
  Statistik varchar(1) NULL,
  StammschulNr varchar(6) NULL,
  DatumZugang date NULL,
  DatumAbgang date NULL,
  GrundZugang varchar(10) NULL,
  GrundAbgang varchar(10) NULL,
  SchulFunktion varchar(10) NULL,
  MehrleistungStd float NULL,
  EntlastungStd float NULL,
  AnrechnungStd float NULL,
  RestStd float NULL,
  Amtsbezeichnung varchar(15) NULL,
  IdentNr1 varchar(10) NULL,
  SchulnrEigner int NULL,
  GU_ID varchar(40) NULL,
  Faecher varchar(100) NULL,
  FuerExport varchar(1) DEFAULT '+' NULL,
  PersonTyp varchar(20) DEFAULT 'LEHRKRAFT' NULL,
  LPassword varchar(255) NULL,
  PWAktuell varchar(3) DEFAULT '-;5' NULL,
  SchILDweb_FL varchar(1) DEFAULT '+' NULL,
  SchILDweb_KL varchar(1) DEFAULT '+' NULL,
  SchILDweb_Config text NULL,
  EMailDienstlich varchar(100) NULL,
  KennwortTools varchar(255) NULL,
  Antwort1 varchar(255) NULL,
  Antwort2 varchar(255) NULL,
  KennwortToolsAktuell varchar(3) DEFAULT '-;5' NULL,
  PANr varchar(20) NULL,
  LBVNr varchar(15) NULL,
  VSchluessel varchar(1) NULL,
  CONSTRAINT K_Lehrer_PK PRIMARY KEY (ID)
 )
;

--
-- Definition for table Versetzung : 
--

CREATE TABLE Versetzung (
  ID int NOT NULL,
  Bezeichnung varchar(150) NULL,
  ASDKlasse varchar(6) NULL,
  Klasse varchar(6) NOT NULL,
  Jahrgang_ID int NULL,
  FKlasse varchar(6) NULL,
  VKlasse varchar(6) NULL,
  OrgFormKrz varchar(1) NULL,
  KlassenlehrerKrz varchar(10) NULL,
  StvKlassenlehrerKrz varchar(10) NULL,
  Restabschnitte smallint NULL,
  ASDSchulformNr varchar(3) NULL,
  Fachklasse_ID int NULL,
  PruefOrdnung varchar(20) NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Klassenart varchar(2) NULL,
  SommerSem varchar(1) NULL,
  NotenGesperrt varchar(1) NULL,
  SchulnrEigner int NULL,
  AdrMerkmal varchar(1) DEFAULT 'A' NULL,
  WebNotenGesperrt varchar(1) DEFAULT '-' NULL,
  KoopKlasse varchar(1) DEFAULT '-' NULL,
  Ankreuzzeugnisse varchar(1) NULL,
  CONSTRAINT Versetzung_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table EigeneSchule_Abteilungen : 
--

CREATE TABLE EigeneSchule_Abteilungen (
  ID int NOT NULL,
  Bezeichnung varchar(50) NOT NULL,
  AbteilungsLeiter varchar(10) NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  Raum varchar(20) NULL,
  EMail varchar(100) NULL,
  Durchwahl varchar(20) NULL,
  CONSTRAINT EigeneSchule_Abteilungen_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table EigeneSchule_Abt_Kl : 
--

CREATE TABLE EigeneSchule_Abt_Kl (
  ID int NOT NULL,
  Abteilung_ID int NOT NULL,
  Klasse varchar(6) NOT NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT EigeneSchule_Abt_Kl_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table EigeneSchule_Fachklassen : 
--

CREATE TABLE EigeneSchule_Fachklassen (
  ID int NOT NULL,
  BKIndex smallint NULL,
  FKS varchar(3) NULL,
  AP varchar(2) NULL,
  Bezeichnung varchar(100) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  Kennung varchar(10) NULL,
  FKS_AP_SIM varchar(5) NULL,
  BKIndexTyp varchar(3) NULL,
  Beschreibung_W varchar(100) NULL,
  Status varchar(20) NULL,
  SchulnrEigner int NULL,
  Lernfelder text NULL,
  DQR_Niveau int NULL,
  Ebene1Klartext varchar(255) NULL,
  Ebene2Klartext varchar(255) NULL,
  Ebene3Klartext varchar(255) NULL,
  CONSTRAINT EigeneSchule_Fachklassen_PK PRIMARY KEY (ID)
 )
;

--
-- Definition for table EigeneSchule_Faecher : 
--

CREATE TABLE EigeneSchule_Faecher (
  ID int NOT NULL,
  FachKrz varchar(20) NULL,
  Bezeichnung varchar(255) NULL,
  ZeugnisBez varchar(255) NULL,
  UeZeugnisBez varchar(255) NULL,
  StatistikKrz varchar(2) NULL,
  BasisFach varchar(2) NULL,
  IstSprache varchar(1) DEFAULT '-' NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  SortierungS2 smallint DEFAULT 32000 NULL,
  NachprErlaubt varchar(1) DEFAULT '+' NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  Gewichtung smallint DEFAULT 1 NULL,
  Fachgruppe_ID int NULL,
  Unterichtssprache varchar(1) NULL,
  IstSchriftlich varchar(1) NULL,
  IstSchriftlichBA varchar(1) NULL,
  AufZeugnis varchar(1) DEFAULT '+' NULL,
  Lernfelder text NULL,
  SchulnrEigner int NULL,
  LK_Moegl varchar(1) NULL,
  Abi_Moegl varchar(1) NULL,
  E1 varchar(1) NULL,
  E2 varchar(1) NULL,
  Q1 varchar(1) NULL,
  Q2 varchar(1) NULL,
  Q3 varchar(1) NULL,
  Q4 varchar(1) NULL,
  AlsNeueFSinSII varchar(1) NULL,
  Leitfach_ID int NULL,
  Leitfach2_ID int NULL,
  Aufgabenfeld varchar(2) NULL,
  AbgeschlFaecherHolen varchar(1) DEFAULT '+' NULL,
  GewichtungFHR int NULL,
  E1_WZE int NULL,
  E2_WZE int NULL,
  Q_WZE int NULL,
  E1_S varchar(1) DEFAULT '-' NULL,
  E2_S varchar(1) DEFAULT '-' NULL,
  NurMuendlich varchar(1) DEFAULT '-' NULL,
  MaxBemZeichen int NULL,
  CONSTRAINT EigeneSchule_Faecher_PK PRIMARY KEY (ID)
 )
;

--
-- Definition for table EigeneSchule_FachTeilleistungen : 
--

CREATE TABLE EigeneSchule_FachTeilleistungen (
  SchulnrEigner int NOT NULL,
  Fach_ID int NOT NULL,
  Teilleistung_ID int NOT NULL,
  Kursart varchar(5) NULL
)

;

--
-- Definition for table EigeneSchule_Jahrgaenge : 
--

CREATE TABLE EigeneSchule_Jahrgaenge (
  ID int NOT NULL,
  InternKrz varchar(20) NULL,
  ASDJahrgang varchar(2) NULL,
  ASDBezeichnung varchar(100) NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  IstChronologisch varchar(1) DEFAULT '+' NULL,
  Spaltentitel varchar(2) NULL,
  SekStufe varchar(6) NULL,
  SGL varchar(3) NULL,
  JahrgangNum smallint NULL,
  Restabschnitte int NULL,
  SchulnrEigner int NULL,
  Folgejahrgang_ID int NULL,
  CONSTRAINT EigeneSchule_Jahrgaenge_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table EigeneSchule_Kursart : 
--

CREATE TABLE EigeneSchule_Kursart (
  ID int NOT NULL,
  Bezeichnung varchar(120) NULL,
  InternBez varchar(20) NULL,
  Kursart varchar(5) NULL,
  KursartAllg varchar(5) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT EigeneSchule_Kursart_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table EigeneSchule_KursartAllg : 
--

CREATE TABLE EigeneSchule_KursartAllg (
  ID int NOT NULL,
  KursartAllg varchar(5) NULL,
  InternBez varchar(20) NULL,
  KursartASD varchar(2) NULL,
  Bezeichnung varchar(120) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT EigeneSchule_KursartAllg_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table EigeneSchule_Merkmale : 
--

CREATE TABLE EigeneSchule_Merkmale (
  ID int NOT NULL,
  Schule varchar(1) NULL,
  Schueler varchar(1) NULL,
  Kurztext varchar(10) NULL,
  Langtext varchar(100) NULL,
  SchulnrEigner int NULL
)

;

--
-- Definition for table EigeneSchule_Schulformen : 
--

CREATE TABLE EigeneSchule_Schulformen (
  ID int NOT NULL,
  SGL varchar(3) NULL,
  SF_SGL varchar(5) NULL,
  Schulform varchar(100) NULL,
  DoppelQualifikation varchar(1) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  BKIndex int NULL,
  SchulnrEigner int NULL,
  Schulform2 varchar(100) NULL,
  CONSTRAINT EigeneSchule_Schulformen_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table EigeneSchule_Teilstandorte : 
--

CREATE TABLE EigeneSchule_Teilstandorte (
  SchulnrEigner int NOT NULL,
  AdrMerkmal varchar(1) NULL,
  PLZ varchar(10) NULL,
  Ort varchar(50) NULL,
  Strasse varchar(50) NULL,
  Hausnr varchar(10) NULL,
  Bemerkung varchar(50) NULL,
  Kuerzel varchar(30) NULL
)

;

--
-- Definition for table EigeneSchule_Texte : 
--

CREATE TABLE EigeneSchule_Texte (
  ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  Kuerzel varchar(50) NULL,
  Inhalt varchar(255) NULL,
  Beschreibung varchar(100) NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  CONSTRAINT EigeneSchule_Texte_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table EigeneSchule_Zertifikate : 
--

CREATE TABLE EigeneSchule_Zertifikate (
  ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  Kuerzel varchar(20) NOT NULL,
  Bezeichnung varchar(100) NULL,
  Fach varchar(100) NULL,
  Formatvorlage varchar(255) NULL,
  CONSTRAINT EigeneSchule_Zertifikate_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table EigeneSchule_Zertifikatsfaecher : 
--

CREATE TABLE EigeneSchule_Zertifikatsfaecher (
  Zertifikat_ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  Kuerzel varchar(20) NOT NULL,
  Klartext varchar(100) NULL,
  Lernfelder text NULL,
  MaxPunkte int NULL,
  Sortierung int NULL,
  CONSTRAINT EigeneSchule_ZF_PK PRIMARY KEY (SchulnrEigner, Kuerzel)
 )
;

--
-- Definition for table Fach_Gliederungen : 
--

CREATE TABLE Fach_Gliederungen (
  Fach_ID int NOT NULL,
  Gliederung varchar(3) NOT NULL,
  SchulnrEigner int NOT NULL,
  Faechergruppe int NULL,
  GewichtungAB int NULL,
  GewichtungBB int NULL,
  SchriftlichAB varchar(1) NULL,
  SchriftlichBB varchar(1) NULL,
  GymOSFach varchar(1) NULL,
  ZeugnisBez varchar(130) NULL,
  Lernfelder text NULL,
  Fachklasse_ID int DEFAULT 0 NULL,
  Sortierung int DEFAULT 32000 NULL
)
;

--
-- Definition for table K_Schwerpunkt : 
--

CREATE TABLE K_Schwerpunkt (
  ID int NOT NULL,
  Bezeichnung varchar(50) NOT NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_Schwerpunkt_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table Fachklassen_Schwerpunkte : 
--

CREATE TABLE Fachklassen_Schwerpunkte (
  SchulnrEigner int NOT NULL,
  Fachklasse_ID int NOT NULL,
  Schwerpunkt_ID int NOT NULL,
  CONSTRAINT Fachklassen_Schwerpunkte_PK PRIMARY KEY (SchulnrEigner, Fachklasse_ID, Schwerpunkt_ID)
 )

;

--
-- Definition for table Floskelgruppen : 
--

CREATE TABLE Floskelgruppen (
  SchulnrEigner int NOT NULL,
  Kuerzel varchar(4) NOT NULL,
  Bezeichnung varchar(50) NOT NULL,
  Hauptgruppe varchar(4) NULL,
  Farbe int NULL,
  CONSTRAINT Floskelgruppen_PK PRIMARY KEY (SchulnrEigner, Kuerzel)
 )

;

--
-- Definition for table Floskeln : 
--

CREATE TABLE Floskeln (
  SchulnrEigner int NOT NULL,
  Kuerzel varchar(10) NOT NULL,
  Floskeltext text NOT NULL,
  Floskelgruppe varchar(10) NULL,
  Floskelfach varchar(20) NULL,
  Floskelniveau varchar(2) NULL,
  Floskeljahrgang varchar(2) NULL
)
;

--
-- Definition for table K_Ankreuzdaten : 
--

CREATE TABLE K_Ankreuzdaten (
  SchulnrEigner int NOT NULL,
  TextStufe1 varchar(100) NULL,
  TextStufe2 varchar(100) NULL,
  TextStufe3 varchar(100) NULL,
  TextStufe4 varchar(100) NULL,
  TextStufe5 varchar(100) NULL,
  BezeichnungSONST varchar(100) NULL
)

;

--
-- Definition for table K_Ankreuzfloskeln : 
--

CREATE TABLE K_Ankreuzfloskeln (
  ID bigint NOT NULL,
  SchulnrEigner int NOT NULL,
  Fach_ID int NOT NULL,
  Jahrgang varchar(2) NOT NULL,
  Floskeltext varchar(255) NOT NULL,
  Sortierung int NULL,
  FachSortierung int NULL,
  Abschnitt int NULL,
  CONSTRAINT K_Ankreuzfloskeln_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_BeschaeftigungsArt : 
--

CREATE TABLE K_BeschaeftigungsArt (
  ID int NOT NULL,
  Bezeichnung varchar(100) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_BeschaeftigungsArt_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_EinschulungsArt : 
--

CREATE TABLE K_EinschulungsArt (
  ID int NOT NULL,
  Bezeichnung varchar(40) NOT NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_EinschulungsArt_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_Einzelleistungen : 
--

CREATE TABLE K_Einzelleistungen (
  ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  Bezeichnung varchar(50) NULL,
  Sortierung int DEFAULT 32000 NULL,
  Sichtbar varchar(1) NULL,
  Gewichtung float NULL,
  CONSTRAINT K_Einzelleistungen_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_EntlassGrund : 
--

CREATE TABLE K_EntlassGrund (
  ID int NOT NULL,
  Bezeichnung varchar(30) NOT NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_EntlassGrund_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_ErzieherArt : 
--

CREATE TABLE K_ErzieherArt (
  ID int NOT NULL,
  Bezeichnung varchar(30) NOT NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  ExportBez varchar(20) NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_ErzieherArt_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_ErzieherFunktion : 
--

CREATE TABLE K_ErzieherFunktion (
  ID int NOT NULL,
  Bezeichnung varchar(50) NOT NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_ErzieherFunktion_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_FahrschuelerArt : 
--

CREATE TABLE K_FahrschuelerArt (
  ID int NOT NULL,
  Bezeichnung varchar(30) NOT NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_FahrschuelerArt_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_Foerderschwerpunkt : 
--

CREATE TABLE K_Foerderschwerpunkt (
  ID int NOT NULL,
  Bezeichnung varchar(50) NOT NULL,
  StatistikKrz varchar(2) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_Foerderschwerpunkt_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_Haltestelle : 
--

CREATE TABLE K_Haltestelle (
  ID int NOT NULL,
  Bezeichnung varchar(30) NOT NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  EntfernungSchule float NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_Haltestelle_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_Kindergarten : 
--

CREATE TABLE K_Kindergarten (
  ID int NOT NULL,
  Bezeichnung varchar(50) NULL,
  PLZ varchar(10) NULL,
  Ort varchar(30) NULL,
  Strasse varchar(40) NULL,
  Tel varchar(20) NULL,
  EMail varchar(40) NULL,
  Bemerkung varchar(50) NULL,
  Sichtbar varchar(1) NULL,
  Sortierung int NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_Kindergarten_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_KlassenOrgForm : 
--

CREATE TABLE K_KlassenOrgForm (
  ID int NOT NULL,
  Bezeichnung varchar(100) NOT NULL,
  StatistikKrz varchar(2) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  CONSTRAINT K_KlassenOrgForm_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_Ort : 
--

CREATE TABLE K_Ort (
  ID int NOT NULL,
  PLZ varchar(10) NOT NULL,
  Bezeichnung varchar(50) NULL,
  Kreis varchar(3) NULL,
  Sortierung smallint DEFAULT 3200 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  Land varchar(2) NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_Ort_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_Ortsteil : 
--

CREATE TABLE K_Ortsteil (
  ID int NOT NULL,
  Bezeichnung varchar(30) NOT NULL,
  PLZ varchar(10) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  OrtsteilSchluessel varchar(30) NULL,
  CONSTRAINT K_Ortsteil_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_Religion : 
--

CREATE TABLE K_Religion (
  ID int NOT NULL,
  Bezeichnung varchar(30) NOT NULL,
  StatistikKrz varchar(10) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  ExportBez varchar(20) NULL,
  ZeugnisBezeichnung varchar(50) NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_Religion_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_Schule : 
--

CREATE TABLE K_Schule (
  ID int NOT NULL,
  SchulNr varchar(6) NOT NULL,
  Name varchar(100) NULL,
  SchulformNr varchar(3) NULL,
  SchulformKrz varchar(3) NULL,
  SchulformBez varchar(50) NULL,
  Strasse varchar(50) NULL,
  PLZ varchar(10) NULL,
  Ort varchar(50) NULL,
  Telefon varchar(20) NULL,
  Fax varchar(20) NULL,
  Email varchar(40) NULL,
  Schulleiter varchar(40) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulNr_SIM varchar(6) NULL,
  Kuerzel varchar(10) NULL,
  KurzBez varchar(40) NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_Schule_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_Schulfunktionen : 
--

CREATE TABLE K_Schulfunktionen (
  ID int NOT NULL,
  Bezeichnung varchar(50) NULL,
  Sortierung int NULL,
  Sichtbar varchar(1) NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_Schulfunktionen_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_Sportbefreiung : 
--

CREATE TABLE K_Sportbefreiung (
  ID int NOT NULL,
  Bezeichnung varchar(50) NOT NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_Sportbefreiung_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_Staat : 
--

CREATE TABLE K_Staat (
  ID int NOT NULL,
  Bezeichnung varchar(80) NOT NULL,
  StatistikKrz varchar(3) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  ExportBez varchar(20) NULL,
  SchulnrEigner int NULL,
  Bezeichnung2 varchar(80) NULL,
  CONSTRAINT K_Staat_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_TelefonArt : 
--

CREATE TABLE K_TelefonArt (
  ID int NOT NULL,
  Bezeichnung varchar(30) NOT NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_TelefonArt_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_Verkehrssprachen : 
--

CREATE TABLE K_Verkehrssprachen (
  ID int NOT NULL,
  Kurztext varchar(10) NULL,
  Langtext varchar(100) NULL,
  Sichtbar varchar(1) NULL,
  Sortierung int NULL,
  SchulnrEigner int NULL
)

;

--
-- Definition for table K_Vermerkart : 
--

CREATE TABLE K_Vermerkart (
  ID int NOT NULL,
  Bezeichnung varchar(30) NOT NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Aenderbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT K_Vermerkart_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table K_Zertifikate : 
--

CREATE TABLE K_Zertifikate (
  Kuerzel varchar(5) NOT NULL,
  Bezeichnung varchar(50) NOT NULL,
  SchulnrEigner int NOT NULL,
  CONSTRAINT K_Zertifikate_PK PRIMARY KEY (Kuerzel, SchulnrEigner)
 )

;

--
-- Definition for table Kompetenzen : 
--

CREATE TABLE Kompetenzen (
  KO_ID int NOT NULL,
  KO_Gruppe int NOT NULL,
  KO_Bezeichnung varchar(64) NOT NULL,
  CONSTRAINT Kompetenzen_PK PRIMARY KEY (KO_ID, KO_Gruppe)
 )

;

--
-- Definition for table Kompetenzgruppen : 
--

CREATE TABLE Kompetenzgruppen (
  KG_Spalte int NOT NULL,
  KG_Zeile int NOT NULL,
  KG_ID int NOT NULL,
  KG_Bezeichnung varchar(50) NOT NULL,
  CONSTRAINT Kompetenzgruppen_PK PRIMARY KEY (KG_Spalte, KG_Zeile, KG_ID, KG_Bezeichnung)
 )

;

--
-- Definition for table Kurse : 
--

CREATE TABLE Kurse (
  ID int NOT NULL,
  Jahr smallint NOT NULL,
  Abschnitt smallint NOT NULL,
  KurzBez varchar(20) NOT NULL,
  Jahrgang_ID int NULL,
  ASDJahrgang varchar(2) NULL,
  Fach_ID int NOT NULL,
  KursartAllg varchar(5) NULL,
  Wochenstd smallint NULL,
  LehrerKrz varchar(10) NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Schienen varchar(20) NULL,
  Fortschreibungsart varchar(1) NULL,
  WochenstdKL float NULL,
  Schulnr int NULL,
  EpochU varchar(1) DEFAULT '-' NULL,
  SchulnrEigner int NULL,
  Zeugnisbez varchar(130) NULL,
  Jahrgaenge varchar(50) NULL,
  CONSTRAINT Kurse_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table KursKombinationen : 
--

CREATE TABLE KursKombinationen (
  Kurs1_ID int NOT NULL,
  Kurs2_ID int NOT NULL,
  CONSTRAINT KursKombi_PK PRIMARY KEY (Kurs1_ID, Kurs2_ID)
 )

;

--
-- Definition for table KursLehrer : 
--

CREATE TABLE KursLehrer (
  Kurs_ID int NOT NULL,
  Lehrer_ID int NOT NULL,
  Anteil float NULL,
  SchulnrEigner int NULL,
  CONSTRAINT PrimaryKey PRIMARY KEY (Kurs_ID, Lehrer_ID)
 )

;

--
-- Definition for table Lehrer_IMEI : 
--

CREATE TABLE Lehrer_IMEI (
  ID int NOT NULL,
  Lehrer_ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  IMEI varchar(20) NULL,
  CONSTRAINT Lehrer_IMEI_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table LehrerAbschnittsdaten : 
--

CREATE TABLE LehrerAbschnittsdaten (
  Lehrer_ID int NOT NULL,
  Jahr int NOT NULL,
  Abschnitt int NOT NULL,
  Rechtsverhaeltnis varchar(1) NULL,
  Beschaeftigungsart varchar(2) NULL,
  Einsatzstatus varchar(1) NULL,
  PflichtstdSoll float NULL,
  UnterrichtsStd float NULL,
  MehrleistungStd float NULL,
  EntlastungStd float NULL,
  AnrechnungStd float NULL,
  RestStd float NULL,
  SchulnrEigner int NULL,
  CONSTRAINT LehrerAbschnittsdaten_PK PRIMARY KEY (Lehrer_ID, Jahr, Abschnitt)
 )

;

--
-- Definition for table LehrerAnrechnung : 
--

CREATE TABLE LehrerAnrechnung (
  Lehrer_ID int NOT NULL,
  AnrechnungsgrundKrz varchar(10) NULL,
  AnrechnungStd float NULL,
  Jahr int NULL,
  Abschnitt int NULL,
  SchulnrEigner int NULL
)

;

--
-- Definition for table LehrerEntlastung : 
--

CREATE TABLE LehrerEntlastung (
  Lehrer_ID int NOT NULL,
  EntlastungsgrundKrz varchar(10) NULL,
  EntlastungStd float NULL,
  Jahr int NULL,
  Abschnitt int NULL,
  SchulnrEigner int NULL
)

;

--
-- Definition for table LehrerFotos : 
--

CREATE TABLE LehrerFotos (
  Lehrer_ID int NOT NULL,
  Foto longblob NULL,
  SchulnrEigner int NULL,
  CONSTRAINT LehrerFotos_PK PRIMARY KEY (Lehrer_ID)
 )
;

--
-- Definition for table LehrerFunktionen : 
--

CREATE TABLE LehrerFunktionen (
  Lehrer_ID int NOT NULL,
  Jahr int NULL,
  Abschnitt int NOT NULL,
  Funktion_ID int NOT NULL,
  SchulnrEigner int NULL
)

;

--
-- Definition for table LehrerLehramt : 
--

CREATE TABLE LehrerLehramt (
  Lehrer_ID int NOT NULL,
  LehramtKrz varchar(10) NULL,
  LehramtAnerkennungKrz varchar(10) NULL,
  SchulnrEigner int NULL
)

;

--
-- Definition for table LehrerLehramtFachr : 
--

CREATE TABLE LehrerLehramtFachr (
  Lehrer_ID int NOT NULL,
  LehramtKrz varchar(10) NULL,
  FachrKrz varchar(10) NULL,
  FachrAnerkennungKrz varchar(10) NULL,
  SchulnrEigner int NULL
)

;

--
-- Definition for table LehrerLehramtLehrbef : 
--

CREATE TABLE LehrerLehramtLehrbef (
  Lehrer_ID int NOT NULL,
  LehramtKrz varchar(10) NULL,
  LehrbefKrz varchar(10) NULL,
  LehrbefAnerkennungKrz varchar(10) NULL,
  SchulnrEigner int NULL
)

;

--
-- Definition for table LehrerMehrleistung : 
--

CREATE TABLE LehrerMehrleistung (
  Lehrer_ID int NOT NULL,
  MehrleistungsgrundKrz varchar(10) NULL,
  MehrleistungStd float NULL,
  Jahr int NULL,
  Abschnitt int NULL,
  SchulnrEigner int NULL
)

;

--
-- Definition for table Logins : 
--

CREATE TABLE Logins (
  LI_UserID int NOT NULL,
  LI_LoginTime datetime NULL,
  LI_LogoffTime datetime NULL,
  SchulnrEigner int NULL
)

;

--
-- Definition for table NichtMoeglAbiFachKombi : 
--

CREATE TABLE NichtMoeglAbiFachKombi (
  Fach1_ID int NOT NULL,
  Fach2_ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  Kursart1 varchar(5) NULL,
  Kursart2 varchar(5) NULL,
  PK varchar(30) NOT NULL,
  Sortierung int NULL,
  Phase varchar(10) NULL,
  Typ varchar(1) NULL,
  CONSTRAINT NichtMoeglAbiFachKombi_PK PRIMARY KEY (PK)
 )

;

--
-- Definition for table NUES_Kate;rien : 
--

CREATE TABLE NUES_Kategorien (
  KategorieKuerzel varchar(20) NOT NULL,
  KategorieText varchar(100) NOT NULL,
  KategorieArt varchar(1) NULL,
  CONSTRAINT NUES_Kategorien_PK PRIMARY KEY (KategorieKuerzel)
 )

;

--
-- Definition for table NUES_Merkmale : 
--

CREATE TABLE NUES_Merkmale (
  MerkmalKuerzel varchar(20) NOT NULL,
  MerkmalText varchar(200) NOT NULL,
  Jahrgang varchar(2) NULL,
  HauptKategorie varchar(20) NOT NULL,
  NebenKategorie varchar(20) NULL,
  CONSTRAINT NUES_Merkmale_PK PRIMARY KEY (MerkmalKuerzel)
 )

;

--
-- Definition for table Personengruppen : 
--

CREATE TABLE Personengruppen (
  ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  Gruppenname varchar(100) NOT NULL,
  Zusatzinfo varchar(100) NULL,
  SammelEMail varchar(100) NULL,
  GruppenArt varchar(20) NULL,
  XMLExport varchar(1) NULL,
  CONSTRAINT Personengruppen_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table Personengruppen_Personen : 
--

CREATE TABLE Personengruppen_Personen (
  ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  Gruppe_ID int NOT NULL,
  Person_ID int NULL,
  PersonNr int NULL,
  PersonArt varchar(1) NULL,
  PersonName varchar(50) NOT NULL,
  PersonVorname varchar(30) NULL,
  PersonPLZ varchar(10) NULL,
  PersonOrt varchar(50) NULL,
  PersonStrasse varchar(50) NULL,
  PersonTelefon varchar(20) NULL,
  PersonMobil varchar(20) NULL,
  PersonEMail varchar(100) NULL,
  Bemerkung varchar(100) NULL,
  ZusatzInfo varchar(100) NULL,
  Sortierung int NULL,
  PersonAnrede varchar(10) NULL,
  PersonAkadGrad varchar(15) NULL,
  CONSTRAINT Personengruppen_Personen_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table PrfSemAbschl : 
--

CREATE TABLE PrfSemAbschl (
  Nr varchar(2) NULL,
  Klartext varchar(30) NULL,
  StatistikKrz varchar(1) NULL,
  Sortierung smallint DEFAULT 32000 NULL
)

;

--
-- Definition for table Schild_Verwaltung : 
--

CREATE TABLE Schild_Verwaltung (
  BackupDatum datetime NULL,
  AutoBerechnung datetime NULL,
  DatumStatkue datetime NULL,
  DatumSchildIntern datetime NULL,
  Bescheinigung varchar(255) NULL,
  Stammblatt varchar(255) NULL,
  DatenGeprueft varchar(1) DEFAULT '-' NULL,
  FaecherUebernehmen varchar(1) DEFAULT '+' NULL,
  Version varchar(10) NULL,
  GU_ID varchar(40) NULL,
  StatistikJahr int NULL,
  SchulnrEigner int NULL,
  LD_Datentyp varchar(1) NULL
)

;

--
-- Definition for table SchildFilter : 
--

CREATE TABLE SchildFilter (
  ID int NOT NULL,
  Art varchar(1) NULL,
  Name varchar(50) NOT NULL,
  Beschreibung varchar(255) NULL,
  Tabellen varchar(255) NULL,
  ZusatzTabellen varchar(255) NULL,
  Bedingung text NULL,
  BedingungKlartext text NULL,
  SchulnrEigner int NULL,
  CONSTRAINT SchildFilter_PK PRIMARY KEY (ID)
 )
;

--
-- Definition for table Schueler : 
--

CREATE TABLE Schueler (
  ID int NOT NULL,
  GU_ID varchar(40) NULL,
  SrcID int NULL,
  IDext varchar(30) NULL,
  Status int NULL,
  Name varchar(60) NULL,
  Vorname varchar(60) NULL,
  Zusatz varchar(255) NULL,
  Geburtsname varchar(60) NULL,
  Strasse varchar(50) NULL,
  PLZ varchar(10) NULL,
  OrtAbk varchar(50) NULL,
  Ortsteil_ID int NULL,
  Telefon varchar(20) NULL,
  Email varchar(100) NULL,
  Fax varchar(20) NULL,
  AktSchuljahr smallint NULL,
  AktAbschnitt smallint NULL,
  Klasse varchar(6) NULL,
  Jahrgang smallint NULL,
  PruefOrdnung varchar(20) NULL,
  Geburtsdatum date NULL,
  Geburtsort varchar(70) NULL,
  Volljaehrig varchar(1) DEFAULT '-' NULL,
  Geschlecht smallint NULL,
  StaatKrz varchar(3) NULL,
  StaatKrz2 varchar(3) NULL,
  StaatAbk varchar(50) NULL,
  Aussiedler varchar(1) DEFAULT '-' NULL,
  Religion_ID int NULL,
  ReligionAbk varchar(30) NULL,
  Religionsabmeldung date NULL,
  Religionsanmeldung date NULL,
  Bafoeg varchar(1) DEFAULT '-' NULL,
  Schwerbehinderung varchar(1) DEFAULT '-' NULL,
  Foerderschwerpunkt_ID int NULL,
  Sportbefreiung_ID int NULL,
  Fahrschueler_ID int NULL,
  Haltestelle_ID int NULL,
  HaltestelleAbk varchar(30) NULL,
  ASDSchulform varchar(3) NULL,
  Jahrgang_ID int NULL,
  ASDJahrgang varchar(2) NULL,
  Fachklasse_ID int NULL,
  SchulpflichtErf varchar(1) DEFAULT '-' NULL,
  Anschreibdatum date NULL,
  Aufnahmedatum date NULL,
  Einschulungsjahr smallint NULL,
  Einschulungsart_ID int NULL,
  LSSchulNr varchar(6) NULL,
  LSSchulformSIM varchar(3) NULL,
  LSJahrgang varchar(2) NULL,
  LSSchulentlassDatum date NULL,
  LSVersetzung varchar(2) NULL,
  LSFachklKennung varchar(10) NULL,
  LSFachklSIM varchar(5) NULL,
  LSEntlassgrund varchar(50) NULL,
  LSEntlassArt varchar(2) NULL,
  LSKlassenart varchar(2) NULL,
  LSRefPaed varchar(1) NULL,
  Entlassjahrgang varchar(2) NULL,
  Entlassjahrgang_ID int NULL,
  Entlassdatum date NULL,
  Entlassgrund varchar(50) NULL,
  Entlassart varchar(2) NULL,
  SchulwechselNr varchar(6) NULL,
  Schulwechseldatum date NULL,
  Geloescht varchar(1) DEFAULT '-' NULL,
  Gesperrt varchar(1) DEFAULT '-' NULL,
  ModifiziertAm datetime NULL,
  ModifiziertVon varchar(20) NULL,
  Markiert varchar(21) DEFAULT '-' NULL,
  FotoVorhanden varchar(1) DEFAULT '-' NULL,
  JVA varchar(1) DEFAULT '-' NULL,
  RefPaed varchar(1) NULL,
  KeineAuskunft varchar(1) DEFAULT '-' NULL,
  Lehrer varchar(10) NULL,
  Beruf varchar(100) NULL,
  AbschlussDatum varchar(15) NULL,
  Bemerkungen text NULL,
  BeginnBildungsgang date NULL,
  Durchschnitt varchar(4) NULL,
  OrgFormKrz varchar(1) NULL,
  Klassenart varchar(2) NULL,
  DurchschnittsNote varchar(4) NULL,
  LSSGL varchar(5) NULL,
  LSSchulform varchar(2) NULL,
  KonfDruck varchar(1) NULL,
  DSN_Text varchar(15) NULL,
  Berufsabschluss varchar(1) NULL,
  Schwerpunkt_ID int NULL,
  LSSGL_SIM varchar(3) NULL,
  BerufsschulpflErf varchar(1) NULL,
  StatusNSJ int NULL,
  FachklasseNSJ_ID int NULL,
  Buchkonto float NULL,
  VerkehrsspracheFamilie varchar(2) NULL,
  JahrZuzug int NULL,
  DauerKindergartenbesuch varchar(1) NULL,
  VerpflichtungSprachfoerderkurs varchar(1) NULL,
  TeilnahmeSprachfoerderkurs varchar(1) NULL,
  Schulbuchgeldbefreit varchar(1) NULL,
  Autist varchar(1) NULL,
  GeburtslandSchueler varchar(10) NULL,
  GeburtslandVater varchar(10) NULL,
  GeburtslandMutter varchar(10) NULL,
  Uebergangsempfehlung_JG5 varchar(10) NULL,
  ErsteSchulform_SI varchar(10) NULL,
  JahrWechsel_SI int NULL,
  JahrWechsel_SII int NULL,
  Migrationshintergrund varchar(1) NULL,
  Foerderschwerpunkt2_ID int NULL,
  SortierungKlasse int NULL,
  ExterneSchulnr varchar(6) NULL,
  Kindergarten_ID int NULL,
  LetzterBerufsAbschluss varchar(10) NULL,
  LetzterAllgAbschluss varchar(10) NULL,
  Land varchar(2) NULL,
  AV_Leist int NULL,
  AV_Zuv int NULL,
  AV_Selbst int NULL,
  SV_Verant int NULL,
  SV_Konfl int NULL,
  SV_Koop int NULL,
  Duplikat varchar(1) DEFAULT '-' NULL,
  EinschulungsartASD varchar(2) NULL,
  Hausnr varchar(10) NULL,
  Strassenname varchar(50) NULL,
  SchulnrEigner int NULL,
  BilingualerZweig varchar(1) NULL,
  DurchschnittsnoteFHR varchar(4) NULL,
  DSN_FHR_Text varchar(15) NULL,
  Eigenanteil float NULL,
  StaatAbk2 varchar(50) NULL,
  ZustimmungFoto varchar(1) DEFAULT '-' NULL,
  BKAZVO int NULL,
  HatBerufsausbildung varchar(1) DEFAULT '-' NULL,
  Ausweisnummer varchar(30) NULL,
  AOSF varchar(1) DEFAULT '+' NULL,
  EPJahre int DEFAULT 2 NULL,
  LSBemerkung varchar(255) NULL,
  WechselBestaetigt varchar(1) DEFAULT '-' NULL,
  DauerBildungsgang int NULL,
  AnmeldeDatum date NULL,
  MeisterBafoeg varchar(1) DEFAULT '-' NULL,
  OnlineAnmeldung varchar(1) DEFAULT '-' NULL,
  Dokumentenverzeichnis varchar(255) NULL,
  Berufsqualifikation varchar(100) NULL,
  HausnrZusatz varchar(30) NULL,
  ZieldifferentesLernen varchar(1) DEFAULT '-' NULL,
  ZusatzNachname varchar(30) NULL,
  EndeEingliederung date NULL,
  SchulEmail varchar(100) NULL,
  CONSTRAINT Schueler_PK PRIMARY KEY (ID)
 )
;

--
-- Definition for table Schueler_AllgAdr : 
--

CREATE TABLE Schueler_AllgAdr (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  Adresse_ID int NOT NULL,
  Vertragsart_ID int NULL,
  Vertragsbeginn date NULL,
  Vertragsende date NULL,
  Ausbilder varchar(30) NULL,
  AllgAdrAnschreiben varchar(1) DEFAULT '-' NULL,
  Praktikum varchar(1) DEFAULT '-' NULL,
  Sortierung int NULL,
  Ansprechpartner_ID int NULL,
  Betreuungslehrer_ID int NULL,
  SchulnrEigner int NULL,
  CONSTRAINT SchuelerAllgAdr_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerAbgaenge : 
--

CREATE TABLE SchuelerAbgaenge (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  BemerkungIntern varchar(30) NULL,
  AbgangsSchulform varchar(2) NULL,
  AbgangsBeschreibung varchar(200) NULL,
  OrganisationsformKrz varchar(1) NULL,
  AbgangsSchule varchar(100) NULL,
  AbgangsSchuleAnschr varchar(100) NULL,
  AbgangsSchulNr varchar(6) NULL,
  LSJahrgang varchar(2) NULL,
  LSEntlassArt varchar(2) NULL,
  LSSchulformSIM varchar(3) NULL,
  LSSchulEntlassDatum date NULL,
  LSVersetzung varchar(2) NULL,
  LSSGL varchar(5) NULL,
  LSFachklKennung varchar(10) NULL,
  LSFachklSIM varchar(5) NULL,
  FuerSIMExport varchar(1) DEFAULT '-' NULL,
  LSBeginnDatum date NULL,
  LSBeginnJahrgang varchar(2) NULL,
  SchulnrEigner int NULL,
  CONSTRAINT SchuelerAbgaenge_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerAbiFaecher : 
--

CREATE TABLE SchuelerAbiFaecher (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  Fach_ID int NOT NULL,
  FachKrz varchar(20) NULL,
  KursartAllg varchar(5) NULL,
  AbiFach varchar(1) NULL,
  P12_1 varchar(2) NULL,
  H12_1 int NULL,
  R12_1 varchar(1) DEFAULT '-' NULL,
  S12_1 varchar(1) DEFAULT '-' NULL,
  P12_2 varchar(2) NULL,
  H12_2 int NULL,
  R12_2 varchar(1) DEFAULT '-' NULL,
  S12_2 varchar(1) DEFAULT '-' NULL,
  P13_1 varchar(2) NULL,
  H13_1 int NULL,
  R13_1 varchar(1) DEFAULT '-' NULL,
  S13_1 varchar(1) DEFAULT '-' NULL,
  P13_2 varchar(2) NULL,
  H13_2 int NULL,
  R13_2 varchar(1) DEFAULT '-' NULL,
  S13_2 varchar(1) DEFAULT '-' NULL,
  Zulassung smallint NULL,
  Durchschnitt float NULL,
  AbiPruefErgebnis smallint NULL,
  Zwischenstand smallint NULL,
  MdlPflichtPruefung varchar(1) DEFAULT '-' NULL,
  MdlFreiwPruefung varchar(1) DEFAULT '-' NULL,
  MdlPruefErgebnis smallint NULL,
  MdlPruefFolge smallint NULL,
  AbiErgebnis smallint NULL,
  MdlBestPruefung varchar(1) NULL,
  W12_1 int NULL,
  W12_2 int NULL,
  W13_1 int NULL,
  W13_2 int NULL,
  P_FA varchar(2) NULL,
  Gekoppelt varchar(1) NULL,
  Kurs_ID int NULL,
  FSortierung int NULL,
  SchulnrEigner int NULL,
  Fachlehrer varchar(10) NULL,
  P11_1 varchar(2) NULL,
  P11_2 varchar(2) NULL,
  S11_1 varchar(1) NULL,
  S11_2 varchar(1) NULL,
  R_FA varchar(1) DEFAULT '-' NULL,
  CONSTRAINT SchuelerAbiFaecher_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerAbitur : 
--

CREATE TABLE SchuelerAbitur (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  Zugelassen varchar(1) DEFAULT '-' NULL,
  SummeGK smallint NULL,
  SummeLK smallint NULL,
  SummenOK smallint NULL,
  PruefungBestanden varchar(1) DEFAULT '-' NULL,
  Note varchar(3) NULL,
  GesamtPunktzahl smallint NULL,
  Notensprung smallint NULL,
  FehlendePunktzahl smallint NULL,
  AnzRelLK smallint NULL,
  AnzRelGK smallint NULL,
  AnzRelOK smallint NULL,
  AnzDefLK smallint NULL,
  AnzDefGK smallint NULL,
  BesondereLernleistung varchar(1) DEFAULT '-' NULL,
  Latinum varchar(1) DEFAULT '-' NULL,
  KlLatinum varchar(1) DEFAULT '-' NULL,
  Graecum varchar(1) DEFAULT '-' NULL,
  Hebraicum varchar(1) DEFAULT '-' NULL,
  FranzBilingual varchar(1) DEFAULT '-' NULL,
  Jahr int NULL,
  Abschnitt int NULL,
  FehlStd int NULL,
  uFehlStd int NULL,
  SchulnrEigner int NULL,
  BLL_Art varchar(1) DEFAULT 'K' NULL,
  BLL_Punkte int NULL,
  FS2_SekI_manuell varchar(1) DEFAULT '-' NULL,
  Punktsumme_II int NULL,
  Defizite_II int NULL,
  LK_Defizite_II int NULL,
  Thema_BLL varchar(255) NULL,
  Thema_PJK varchar(255) NULL,
  Punktsumme_I int NULL,
  Defizite_I int NULL,
  LK_Defizite_I int NULL,
  Kurse_I int NULL,
  FA_Punkte int NULL,
  FA_Fach varchar(130) NULL,
  AnzahlKurse_0 int NULL,
  Durchschnitt_I float NULL,
  CONSTRAINT SchuelerAbitur_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerAnkreuzfloskeln : 
--

CREATE TABLE SchuelerAnkreuzfloskeln (
  ID bigint NOT NULL,
  Schueler_ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  Jahr int NOT NULL,
  Abschnitt int NOT NULL,
  Floskel_ID int NOT NULL,
  Stufe1 varchar(1) NULL,
  Stufe2 varchar(1) NULL,
  Stufe3 varchar(1) NULL,
  Stufe4 varchar(1) NULL,
  Stufe5 varchar(1) NULL,
  CONSTRAINT SchuelerAnkreuzfloskeln_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerBKAbschluss : 
--

CREATE TABLE SchuelerBKAbschluss (
  Schueler_ID int NOT NULL,
  Zulassung char(1) NULL,
  Bestanden char(1) NULL,
  Zeugnis char(1) NULL,
  ZertifikatBK char(1) NULL,
  ZulassungErwBK char(1) NULL,
  BestandenErwBK char(1) NULL,
  ZulassungBA char(1) NULL,
  BestandenBA char(1) NULL,
  PraktPrfNote varchar(2) NULL,
  NoteKolloquium varchar(2) NULL,
  ThemaAbschlussarbeit text NULL,
  SchulnrEigner int NULL,
  BAP_Vorhanden varchar(1) NULL,
  NoteFachpraxis varchar(2) NULL,
  CONSTRAINT SchuelerBKAbschluss_PK PRIMARY KEY (Schueler_ID)
 )
;

--
-- Definition for table SchuelerBKFaecher : 
--

CREATE TABLE SchuelerBKFaecher (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  Fach_ID int NOT NULL,
  FachKrz varchar(20) NULL,
  FachSchriftlich char(1) NULL,
  FachSchriftlichBA char(1) NULL,
  Vornote varchar(2) NULL,
  NoteSchriftlich varchar(2) NULL,
  MdlPruefung char(1) NULL,
  MdlPruefungFW char(1) NULL,
  NoteMuendlich varchar(2) NULL,
  NoteAbschluss varchar(2) NULL,
  NotePrfGesamt varchar(2) NULL,
  FSortierung int NULL,
  SchulnrEigner int NULL,
  Fachlehrer varchar(10) NULL,
  NoteAbschlussBA varchar(2) NULL,
  CONSTRAINT SchuelerBKFaecher_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerEinzelleistungen : 
--

CREATE TABLE SchuelerEinzelleistungen (
  SchulnrEigner int NOT NULL,
  ID bigint NOT NULL,
  Datum date NULL,
  Lehrer_ID int NULL,
  Art_ID int NULL,
  Bemerkung varchar(100) NULL,
  Leistung_ID bigint NULL,
  NotenKrz varchar(2) NULL,
  CONSTRAINT SchuelerEinzelleistungen_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerErzAdr : 
--

CREATE TABLE SchuelerErzAdr (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  ErzieherArt_ID int NULL,
  Anrede1 varchar(20) NULL,
  Titel1 varchar(10) NULL,
  Name1 varchar(50) NULL,
  Vorname1 varchar(50) NULL,
  Anrede2 varchar(20) NULL,
  Titel2 varchar(10) NULL,
  Name2 varchar(50) NULL,
  Vorname2 varchar(50) NULL,
  ErzStrasse varchar(50) NULL,
  ErzPLZ varchar(10) NULL,
  ErzOrtsteil_ID int NULL,
  ErzAnschreiben varchar(1) DEFAULT '+' NULL,
  ErzBemerkung varchar(255) NULL,
  Sortierung int NULL,
  ErzEMail varchar(100) NULL,
  ErzAdrZusatz varchar(50) NULL,
  SchulnrEigner int NULL,
  Erz1StaatKrz varchar(3) NULL,
  Erz2StaatKrz varchar(3) NULL,
  ErzEMail2 varchar(100) NULL,
  Erz1ZusatzNachname varchar(30) NULL,
  Erz2ZusatzNachname varchar(30) NULL,
  Bemerkungen text NULL,
  CONSTRAINT SchuelerErzAdr_PK PRIMARY KEY (ID)
 )
;

--
-- Definition for table SchuelerErzFunktion : 
--

CREATE TABLE SchuelerErzFunktion (
  ID int NOT NULL,
  Erzieher_ID int NOT NULL,
  Funktion_ID int NOT NULL,
  Person smallint NULL,
  Klasse varchar(10) NULL,
  SchulnrEigner int NULL,
  CONSTRAINT SchuelerErzFunktion_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerLernabschnittsdaten : 
--

CREATE TABLE SchuelerLernabschnittsdaten (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  Jahr smallint NOT NULL,
  Abschnitt smallint NOT NULL,
  Bildungsgang varchar(1) NOT NULL,
  WechselNr smallint NOT NULL,
  Jahrgang smallint NULL,
  Hochrechnung int NULL,
  SemesterWertung varchar(1) DEFAULT '+' NULL,
  PruefOrdnung varchar(20) NULL,
  Klasse varchar(10) NULL,
  Verspaetet smallint NULL,
  NPV_Fach_ID int NULL,
  NPV_NoteKrz varchar(2) NULL,
  NPV_Datum date NULL,
  NPAA_Fach_ID int NULL,
  NPAA_NoteKrz varchar(2) NULL,
  NPAA_Datum date NULL,
  NPBQ_Fach_ID int NULL,
  NPBQ_NoteKrz varchar(2) NULL,
  NPBQ_Datum date NULL,
  VersetzungKrz varchar(2) NULL,
  AbschlussArt smallint NULL,
  AbschlIstPrognose varchar(1) DEFAULT '-' NULL,
  Konferenzdatum date NULL,
  ZeugnisDatum date NULL,
  KlassenLehrer varchar(10) NULL,
  ASDSchulgliederung varchar(3) NULL,
  ASDJahrgang varchar(2) NULL,
  Jahrgang_ID int NULL,
  Fachklasse_ID int NULL,
  Schwerpunkt_ID int NULL,
  ZeugnisBem text NULL,
  Schwerbehinderung varchar(1) DEFAULT '-' NULL,
  Foerderschwerpunkt_ID int NULL,
  OrgFormKrz varchar(1) NULL,
  RefPaed varchar(1) DEFAULT '-' NULL,
  Klassenart varchar(2) NULL,
  SumFehlStd int NULL,
  SumFehlStdU int NULL,
  Wiederholung varchar(1) NULL,
  Gesamtnote_GS int NULL,
  Gesamtnote_NW int NULL,
  Folgeklasse varchar(10) NULL,
  Foerderschwerpunkt2_ID int NULL,
  Abschluss varchar(50) NULL,
  Abschluss_B varchar(50) NULL,
  DSNote varchar(4) NULL,
  AV_Leist int NULL,
  AV_Zuv int NULL,
  AV_Selbst int NULL,
  SV_Verant int NULL,
  SV_Konfl int NULL,
  SV_Koop int NULL,
  KN_Lehrer varchar(10) NULL,
  SchulnrEigner int NULL,
  StvKlassenlehrer_ID int NULL,
  MoeglNPFaecher text NULL,
  Zertifikate varchar(30) NULL,
  DatumFHR date NULL,
  PruefAlgoErgebnis text NULL,
  Zeugnisart varchar(5) NULL,
  DatumVon date NULL,
  DatumBis date NULL,
  FehlstundenGrenzwert int NULL,
  CONSTRAINT SchuelerLernabschnittsdaten_PK PRIMARY KEY (ID)
 )
;

--
-- Definition for table SchuelerFehlstunden : 
--

CREATE TABLE SchuelerFehlstunden (
  ID bigint NOT NULL,
  SchulnrEigner int NOT NULL,
  Abschnitt_ID int NOT NULL,
  Datum date NOT NULL,
  Fach_ID int NULL,
  Fehlstd float NOT NULL,
  VonStd int NULL,
  BisStd int NULL,
  Entschuldigt varchar(1) NULL,
  Lehrer_ID int NULL,
  CONSTRAINT SchuelerFehlstunden_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerFHR : 
--

CREATE TABLE SchuelerFHR (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  FHRErreicht varchar(1) DEFAULT '-' NULL,
  Note varchar(3) NULL,
  GesamtPunktzahl smallint NULL,
  SummeGK smallint NULL,
  SummeLK smallint NULL,
  SummenOK smallint NULL,
  AnzRelLK smallint NULL,
  AnzRelGK smallint NULL,
  AnzRelOK smallint NULL,
  AnzDefLK smallint NULL,
  AnzDefGK smallint NULL,
  AnzDefOK smallint NULL,
  JSII_2_1 smallint NULL,
  JSII_2_1_W smallint NULL,
  JSII_2_2 smallint NULL,
  JSII_2_2_W smallint NULL,
  JSII_3_1 smallint NULL,
  JSII_3_1_W smallint NULL,
  JSII_3_2 smallint NULL,
  JSII_3_2_W smallint NULL,
  ASII_2_1 smallint NULL,
  ASII_2_2 smallint NULL,
  ASII_2_1_W smallint NULL,
  ASII_2_2_W smallint NULL,
  ASII_3_1 smallint NULL,
  ASII_3_2 smallint NULL,
  ASII_3_1_W smallint NULL,
  ASII_3_2_W smallint NULL,
  WSII_2_1 varchar(1) NULL,
  WSII_2_2 varchar(1) NULL,
  WSII_2_1_W varchar(1) NULL,
  WSII_2_2_W varchar(1) NULL,
  WSII_3_1 varchar(1) NULL,
  WSII_3_2 varchar(1) NULL,
  WSII_3_1_W varchar(1) NULL,
  WSII_3_2_W varchar(1) NULL,
  SchulnrEigner int NULL,
  CONSTRAINT SchuelerFHR_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerFHRFaecher : 
--

CREATE TABLE SchuelerFHRFaecher (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  Fach_ID int NOT NULL,
  KursartAllg varchar(5) NULL,
  FachKrz varchar(20) NULL,
  PSII_2_1 varchar(2) NULL,
  HSII_2_1 int NULL,
  RSII_2_1 varchar(1) DEFAULT '-' NULL,
  PSII_2_2 varchar(2) NULL,
  HSII_2_2 int NULL,
  RSII_2_2 varchar(1) DEFAULT '-' NULL,
  PSII_2_1_W varchar(2) NULL,
  HSII_2_1_W int NULL,
  RSII_2_1_W varchar(1) DEFAULT '-' NULL,
  PSII_2_2_W varchar(2) NULL,
  HSII_2_2_W int NULL,
  RSII_2_2_W varchar(1) DEFAULT '-' NULL,
  PSII_3_1 varchar(2) NULL,
  HSII_3_1 int NULL,
  RSII_3_1 varchar(1) DEFAULT '-' NULL,
  PSII_3_2 varchar(2) NULL,
  HSII_3_2 int NULL,
  RSII_3_2 varchar(1) DEFAULT '-' NULL,
  PSII_3_1_W varchar(2) NULL,
  HSII_3_1_W int NULL,
  RSII_3_1_W varchar(1) DEFAULT '-' NULL,
  PSII_3_2_W varchar(2) NULL,
  HSII_3_2_W int NULL,
  RSII_3_2_W varchar(1) DEFAULT '-' NULL,
  KSII_2_1 varchar(5) NULL,
  KSII_2_2 varchar(5) NULL,
  KSII_2_1_W varchar(5) NULL,
  KSII_2_2_W varchar(5) NULL,
  KSII_3_1 varchar(5) NULL,
  KSII_3_2 varchar(5) NULL,
  KSII_3_1_W varchar(5) NULL,
  KSII_3_2_W varchar(5) NULL,
  FSortierung int NULL,
  SchulnrEigner int NULL,
  CONSTRAINT SchuelerFHRFaecher_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerFoerderempfehlungen : 
--

CREATE TABLE SchuelerFoerderempfehlungen (
  GU_ID varchar(40) NOT NULL,
  Schueler_ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  DatumAngelegt date NOT NULL,
  Klasse varchar(15) NULL,
  Jahr int NULL,
  Abschnitt int NULL,
  Fach_ID int NULL,
  Lehrer_ID int NULL,
  DatumAenderungSchild datetime NULL,
  DatumAenderungSchildWeb datetime NULL,
  Kurs varchar(20) NULL,
  Inhaltl_Prozessbez_Komp text NULL,
  Methodische_Komp text NULL,
  Lern_Arbeitsverhalten text NULL,
  Massn_Inhaltl_Prozessbez_Komp text NULL,
  Massn_Methodische_Komp text NULL,
  Massn_Lern_Arbeitsverhalten text NULL,
  Verantwortlichkeit_Eltern text NULL,
  Verantwortlichkeit_Schueler text NULL,
  Zeitrahmen_von_Datum date NULL,
  Zeitrahmen_bis_Datum date NULL,
  Ueberpruefung_Datum date NULL,
  Naechstes_Beratungsgespraech date NULL,
  Leistung_ID int NULL,
  Kurs_ID int NULL,
  EingabeFertig varchar(1) DEFAULT '-' NULL,
  Faecher varchar(255) NULL,
  Abgeschlossen varchar(1) DEFAULT '-' NULL,
  CONSTRAINT SchuelerFoerderempfehlungen_PK PRIMARY KEY (GU_ID)
 )
;

--
-- Definition for table SchuelerFotos : 
--

CREATE TABLE SchuelerFotos (
  Schueler_ID int NOT NULL,
  Foto longblob NULL,
  SchulnrEigner int NULL,
  CONSTRAINT SchuelerFotos_PK PRIMARY KEY (Schueler_ID)
 )
;

--
-- Definition for table SchuelerGSDaten : 
--

CREATE TABLE SchuelerGSDaten (
  Schueler_ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  Note_Sprachgebrauch int NULL,
  Note_Lesen int NULL,
  Note_Rechtschreiben int NULL,
  Note_Sachunterricht int NULL,
  Note_Mathematik int NULL,
  Note_Englisch int NULL,
  Note_KunstTextil int NULL,
  Note_Musik int NULL,
  Note_Sport int NULL,
  Note_Religion int NULL,
  Durchschnittsnote_Sprache float NULL,
  Durchschnittsnote_Einfach float NULL,
  Durchschnittsnote_Gewichtet float NULL,
  Anrede_Klassenlehrer varchar(10) NULL,
  Nachname_Klassenlehrer varchar(50) NULL,
  GS_Klasse varchar(10) NULL,
  Bemerkungen text NULL,
  Geschwisterkind varchar(1) DEFAULT '-' NULL,
  CONSTRAINT SchuelerGSDaten_PK PRIMARY KEY (Schueler_ID)
 )
;

--
-- Definition for table SchuelerLD_PSFachBem : 
--

CREATE TABLE SchuelerLD_PSFachBem (
  ID int NOT NULL,
  Abschnitt_ID int NOT NULL,
  ASV text NULL,
  LELS text NULL,
  ESF text NULL,
  SchulnrEigner int NULL,
  CONSTRAINT SchuelerLD_PSFachBem_PK PRIMARY KEY (ID)
 )
;

--
-- Definition for table SchuelerLeistungsdaten : 
--

CREATE TABLE SchuelerLeistungsdaten (
  ID int NOT NULL,
  Abschnitt_ID int NOT NULL,
  Fach_ID int NOT NULL,
  Hochrechnung int NULL,
  FachLehrer varchar(10) NULL,
  Kursart varchar(5) NULL,
  KursartAllg varchar(5) NULL,
  Kurs_ID int NULL,
  NotenKrz varchar(2) NULL,
  Warnung varchar(1) DEFAULT '-' NULL,
  Warndatum date NULL,
  AbiFach varchar(1) NULL,
  Wochenstunden smallint NULL,
  AbiZeugnis varchar(1) DEFAULT '-' NULL,
  Prognose varchar(1) NULL,
  Fehlstd smallint NULL,
  uFehlstd smallint NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Lernentw text NULL,
  Gekoppelt varchar(1) DEFAULT '-' NULL,
  VorherAbgeschl varchar(1) DEFAULT '-' NULL,
  AbschlussJahrgang varchar(2) NULL,
  HochrechnungStatus varchar(1) NULL,
  SchulNr int NULL,
  Zusatzkraft varchar(10) NULL,
  WochenstdZusatzkraft int NULL,
  Prf10Fach varchar(1) NULL,
  AufZeugnis varchar(1) DEFAULT '+' NULL,
  Gewichtung int DEFAULT 1 NULL,
  SchulnrEigner int NULL,
  NoteAbschlussBA varchar(2) NULL,
  CONSTRAINT SchuelerLeistungsdaten_PK PRIMARY KEY (ID)
 )
;

--
-- Definition for table SchuelerListe : 
--

CREATE TABLE SchuelerListe (
  ID int NOT NULL,
  Bezeichnung varchar(50) NOT NULL,
  Erzeuger varchar(20) NULL,
  Privat varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  CONSTRAINT SchuelerListe_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerListe_Inhalt : 
--

CREATE TABLE SchuelerListe_Inhalt (
  Liste_ID int NOT NULL,
  Schueler_ID int NOT NULL,
  SchulnrEigner int NULL,
  CONSTRAINT SchuelerListeInhalt_PK PRIMARY KEY (Liste_ID, Schueler_ID)
 )

;

--
-- Definition for table SchuelerMerkmale : 
--

CREATE TABLE SchuelerMerkmale (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  Kurztext varchar(10) NULL,
  SchulnrEigner int NULL,
  DatumVon date NULL,
  DatumBis date NULL
)

;

--
-- Definition for table SchuelerNUESDaten : 
--

CREATE TABLE SchuelerNUESDaten (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  Jahr int NOT NULL,
  Abschnitt int NOT NULL,
  JahrgangIst varchar(2) NULL,
  HauptMerkmal varchar(20) NOT NULL,
  NebenMerkmal varchar(20) NULL,
  CONSTRAINT SchuelerNUESDaten_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerReportvorlagen : 
--

CREATE TABLE SchuelerReportvorlagen (
  User_ID int NOT NULL,
  SchulnrEigner int NULL,
  ReportVorlage varchar(255) NULL,
  Schueler_IDs text NULL
)
;

--
-- Definition for table SchuelerSprachenfolge : 
--

CREATE TABLE SchuelerSprachenfolge (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  Fach_ID int NOT NULL,
  JahrgangVon smallint NULL,
  JahrgangBis smallint NULL,
  Reihenfolge varchar(1) NULL,
  AbschnittVon smallint NULL,
  AbschnittBis smallint NULL,
  SchulnrEigner int NULL,
  Referenzniveau varchar(5) NULL,
  CONSTRAINT SchuelerSprachenfolge_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerTelefone : 
--

CREATE TABLE SchuelerTelefone (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  TelefonArt_ID int NULL,
  Telefonnummer varchar(20) NULL,
  Bemerkung varchar(50) NULL,
  Sortierung int DEFAULT 32000 NULL,
  SchulnrEigner int NULL,
  Gesperrt varchar(1) DEFAULT '-' NULL,
  CONSTRAINT SchuelerTelefone_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerVermerke : 
--

CREATE TABLE SchuelerVermerke (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  VermerkArt_ID int NULL,
  Datum date NULL,
  Bemerkung text NULL,
  SchulnrEigner int NULL,
  AngelegtVon varchar(20) NULL,
  GeaendertVon varchar(20) NULL,
  CONSTRAINT SchuelerVermerke_PK PRIMARY KEY (ID)
 )
;

--
-- Definition for table SchuelerWiedervorlage : 
--

CREATE TABLE SchuelerWiedervorlage (
  ID int NOT NULL,
  Schueler_ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  Bemerkung varchar(255) NULL,
  AngelegtAm datetime NULL,
  WiedervorlageAm datetime NULL,
  ErledigtAm datetime NULL,
  User_ID int NULL,
  Sekretariat varchar(1) NULL,
  Typ varchar(1) NULL,
  NichtLoeschen varchar(1) NULL,
  CONSTRAINT SchuelerWiedervorlage_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table SchuelerZuweisungen : 
--

CREATE TABLE SchuelerZuweisungen (
  Abschnitt_ID int NOT NULL,
  Fach_ID int NOT NULL,
  Kursart varchar(5) NULL,
  SchulnrEigner int NULL,
  CONSTRAINT SchuelerZuweisungen_PK PRIMARY KEY (Abschnitt_ID, Fach_ID)
 )

;

--
-- Definition for table Stundentafel : 
--

CREATE TABLE Stundentafel (
  ID int NOT NULL,
  Bezeichnung varchar(50) NOT NULL,
  Jahrgang_ID int NULL,
  ASDJahrgang varchar(2) NULL,
  Klasse varchar(6) NULL,
  SGL varchar(3) NULL,
  Fachklasse_ID int NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  SchulnrEigner int NULL,
  Sortierung int DEFAULT 32000 NULL,
  CONSTRAINT Stundentafel_PK PRIMARY KEY (ID)
 )

;

--
-- Definition for table Stundentafel_Faecher : 
--

CREATE TABLE Stundentafel_Faecher (
  ID int NOT NULL,
  Stundentafel_ID int NOT NULL,
  Fach_ID int NOT NULL,
  KursartAllg varchar(5) NULL,
  WochenStd smallint NULL,
  LehrerKrz varchar(10) NULL,
  EpochenUnterricht varchar(1) DEFAULT '-' NULL,
  Sortierung smallint DEFAULT 32000 NULL,
  Sichtbar varchar(1) DEFAULT '+' NULL,
  Gewichtung int DEFAULT 1 NULL,
  SchulnrEigner int NULL,
  CONSTRAINT Stundentafel_Faecher_PK PRIMARY KEY (ID)
 )

;


--
-- Definition for table TextExportVorlagen : 
--

CREATE TABLE TextExportVorlagen (
  SchulnrEigner int NOT NULL,
  VorlageName varchar(50) NOT NULL,
  Daten text NULL,
  CONSTRAINT TextExportVorlagen_PK PRIMARY KEY (SchulnrEigner, VorlageName)
 )
;

--
-- Definition for table Usergroups : 
--

CREATE TABLE Usergroups (
  UG_ID int NOT NULL,
  UG_Bezeichnung varchar(64) NULL,
  UG_Kompetenzen varchar(255) NULL,
  UG_Nr int NULL,
  SchulnrEigner int NULL,
  CONSTRAINT Usergroups_PK PRIMARY KEY (UG_ID)
 )

;

--
-- Definition for table Users : 
--

CREATE TABLE Users (
  ID int NOT NULL,
  US_Name varchar(50) NOT NULL,
  US_LoginName varchar(20) NOT NULL,
  US_Password varchar(20) NULL,
  US_UserGroups varchar(50) NULL,
  US_Privileges varchar(255) NULL,
  SchulnrEigner int NULL,
  EMail varchar(100) NULL,
  EMailName varchar(100) NULL,
  SMTPUsername varchar(100) NULL,
  SMTPPassword varchar(100) NULL,
  EMailSignature text NULL,
  HeartbeatDate int NULL,
  ComputerName varchar(50) NULL,
  US_PasswordHash varchar(255) NULL,
  CONSTRAINT Users_PK PRIMARY KEY (ID)
 )
;

--
-- Definition for table ZuordnungReportvorlagen : 
--

CREATE TABLE ZuordnungReportvorlagen (
  ID int NOT NULL,
  SchulnrEigner int NOT NULL,
  Jahrgang_ID int NOT NULL,
  Abschluss varchar(50) NULL,
  AbschlussBB varchar(50) NULL,
  AbschlussArt int NULL,
  VersetzungKrz varchar(2) NULL,
  Fachklasse_ID int NULL,
  Reportvorlage varchar(255) NULL,
  Beschreibung varchar(255) NULL,
  Gruppe varchar(50) NULL,
  Zeugnisart varchar(5) NULL,
  CONSTRAINT ZuordnungReportvorlagen_PK PRIMARY KEY (ID)
 )
;

