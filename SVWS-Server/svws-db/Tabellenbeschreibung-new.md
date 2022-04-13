
# benutzergruppen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (255) | NOT NULL |
| IstAdmin | int (11) | NOT NULL DEFAULT 0 |



# credentials

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Benutzername | varchar (255) | NOT NULL |
| BenutzernamePseudonym | varchar (255) | DEFAULT NULL |
| Initialkennwort | varchar (255) | DEFAULT NULL |
| PasswordHash | varchar (255) | DEFAULT NULL |
| RSAPublicKey | longtext | DEFAULT NULL |
| RSAPrivateKey | longtext | DEFAULT NULL |
| AES | longtext | DEFAULT NULL |



# eigeneschule_fachklassen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| BKIndex | smallint (6) | DEFAULT NULL |
| FKS | varchar (3) | DEFAULT NULL |
| AP | varchar (2) | DEFAULT NULL |
| Bezeichnung | varchar (100) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |
| Kennung | varchar (10) | DEFAULT NULL |
| FKS_AP_SIM | varchar (5) | DEFAULT NULL |
| BKIndexTyp | varchar (3) | DEFAULT NULL |
| Beschreibung_W | varchar (100) | DEFAULT NULL |
| Status | varchar (20) | DEFAULT NULL |
| Lernfelder | longtext | DEFAULT NULL |
| DQR_Niveau | int (11) | DEFAULT NULL |
| Ebene1Klartext | varchar (255) | DEFAULT NULL |
| Ebene2Klartext | varchar (255) | DEFAULT NULL |
| Ebene3Klartext | varchar (255) | DEFAULT NULL |



# eigeneschule_faecher

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| FachKrz | varchar (20) | DEFAULT NULL |
| Bezeichnung | varchar (255) | DEFAULT NULL |
| ZeugnisBez | varchar (255) | DEFAULT NULL |
| UeZeugnisBez | varchar (255) | DEFAULT NULL |
| StatistikKrz | varchar (2) | DEFAULT NULL |
| BasisFach | varchar (1) | DEFAULT '-' |
| IstSprache | varchar (1) | DEFAULT '-' |
| Sortierung | int (11) | DEFAULT 32000 |
| SortierungS2 | int (11) | DEFAULT 32000 |
| NachprErlaubt | varchar (1) | DEFAULT '+' |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |
| Gewichtung | smallint (6) | DEFAULT 1 |
| Unterichtssprache | varchar (1) | DEFAULT 'D' |
| IstSchriftlich | varchar (1) | DEFAULT '-' |
| IstSchriftlichBA | varchar (1) | DEFAULT '-' |
| AufZeugnis | varchar (1) | DEFAULT '+' |
| Lernfelder | longtext | DEFAULT NULL |
| LK_Moegl | varchar (1) | DEFAULT '+' |
| Abi_Moegl | varchar (1) | DEFAULT '+' |
| E1 | varchar (1) | DEFAULT '+' |
| E2 | varchar (1) | DEFAULT '+' |
| Q1 | varchar (1) | DEFAULT '+' |
| Q2 | varchar (1) | DEFAULT '+' |
| Q3 | varchar (1) | DEFAULT '+' |
| Q4 | varchar (1) | DEFAULT '+' |
| AlsNeueFSInSII | varchar (1) | DEFAULT '-' |
| Leitfach_ID | bigint (20) | DEFAULT NULL |
| Leitfach2_ID | bigint (20) | DEFAULT NULL |
| E1_WZE | int (11) | DEFAULT NULL |
| E2_WZE | int (11) | DEFAULT NULL |
| Q_WZE | int (11) | DEFAULT NULL |
| E1_S | varchar (1) | DEFAULT '-' |
| E2_S | varchar (1) | DEFAULT '-' |
| NurMuendlich | varchar (1) | DEFAULT '-' |
| Aufgabenfeld | varchar (2) | DEFAULT NULL |
| AbgeschlFaecherHolen | varchar (1) | DEFAULT '+' |
| GewichtungFHR | int (11) | DEFAULT NULL |
| MaxBemZeichen | int (11) | DEFAULT NULL |



# eigeneschule_kaoadaten

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Curriculum | varchar (1) | NOT NULL DEFAULT '+' |
| Koordinator | varchar (1) | NOT NULL DEFAULT '+' |
| Berufsorientierungsbuero | varchar (1) | NOT NULL DEFAULT '+' |
| KooperationsvereinbarungAA | varchar (1) | NOT NULL DEFAULT '+' |
| NutzungReflexionsworkshop | varchar (1) | NOT NULL DEFAULT '+' |
| NutzungEntscheidungskompetenzI | varchar (1) | NOT NULL DEFAULT '+' |
| NutzungEntscheidungskompetenzII | varchar (1) | NOT NULL DEFAULT '+' |



# eigeneschule_kursart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (120) | DEFAULT NULL |
| InternBez | varchar (20) | DEFAULT NULL |
| Kursart | varchar (5) | DEFAULT NULL |
| KursartAllg | varchar (5) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |



# eigeneschule_merkmale

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schule | varchar (1) | DEFAULT '+' |
| Schueler | varchar (1) | DEFAULT '+' |
| Kurztext | varchar (10) | DEFAULT NULL |
| Langtext | varchar (100) | DEFAULT NULL |



# eigeneschule_schulformen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| SGL | varchar (3) | DEFAULT NULL |
| SF_SGL | varchar (5) | DEFAULT NULL |
| Schulform | varchar (100) | DEFAULT NULL |
| DoppelQualifikation | varchar (1) | DEFAULT '-' |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| BKIndex | int (11) | DEFAULT NULL |
| Schulform2 | varchar (100) | DEFAULT NULL |



# eigeneschule_teilstandorte

| Name | Type | Spec |
|---|---|---|
| AdrMerkmal | varchar (1) | NOT NULL |
| PLZ | varchar (10) | DEFAULT NULL |
| Ort | varchar (50) | DEFAULT NULL |
| Strassenname | varchar (55) | DEFAULT NULL |
| HausNr | varchar (10) | DEFAULT NULL |
| HausNrZusatz | varchar (30) | DEFAULT NULL |
| Bemerkung | varchar (50) | DEFAULT NULL |
| Kuerzel | varchar (30) | DEFAULT NULL |



# eigeneschule_texte

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kuerzel | varchar (50) | DEFAULT NULL |
| Inhalt | varchar (255) | DEFAULT NULL |
| Beschreibung | varchar (100) | DEFAULT NULL |
| Aenderbar | varchar (1) | DEFAULT '+' |



# eigeneschule_zertifikate

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Kuerzel | varchar (20) | NOT NULL |
| Bezeichnung | varchar (100) | DEFAULT NULL |
| Fach | varchar (100) | DEFAULT NULL |
| Formatvorlage | varchar (255) | DEFAULT NULL |



# fach_gliederungen

| Name | Type | Spec |
|---|---|---|
| Fach_ID | bigint (20) | NOT NULL |
| Gliederung | varchar (3) | NOT NULL |
| Faechergruppe | int (11) | DEFAULT NULL |
| GewichtungAB | int (11) | DEFAULT NULL |
| GewichtungBB | int (11) | DEFAULT NULL |
| SchriftlichAB | varchar (1) | DEFAULT '-' |
| SchriftlichBB | varchar (1) | DEFAULT '-' |
| GymOSFach | varchar (1) | DEFAULT '-' |
| ZeugnisBez | varchar (130) | DEFAULT NULL |
| Lernfelder | longtext | DEFAULT NULL |
| Fachklasse_ID | bigint (20) | NOT NULL DEFAULT 0 |
| Sortierung | int (11) | DEFAULT 32000 |



# floskelgruppen

| Name | Type | Spec |
|---|---|---|
| Kuerzel | varchar (10) | NOT NULL |
| Hauptgruppe | varchar (4) | DEFAULT NULL |
| Bezeichnung | varchar (50) | NOT NULL |
| Farbe | int (11) | DEFAULT NULL |



# gost_jahrgangsdaten

| Name | Type | Spec |
|---|---|---|
| Abi_Jahrgang | int (11) | NOT NULL |
| ZusatzkursGEVorhanden | int (11) | DEFAULT 1 |
| ZusatzkursGEErstesHalbjahr | varchar (4) | DEFAULT 'Q2.1' |
| ZusatzkursSWVorhanden | int (11) | DEFAULT 1 |
| ZusatzkursSWErstesHalbjahr | varchar (4) | DEFAULT 'Q2.1' |
| TextBeratungsbogen | varchar (2000) | DEFAULT NULL |
| TextMailversand | varchar (2000) | DEFAULT NULL |



# impexp_eigeneimporte

| Name | Type | Spec |
|---|---|---|
| ID | int (11) | NOT NULL DEFAULT 0 |
| Title | varchar (50) | DEFAULT NULL |
| DelimiterChar | varchar (1) | DEFAULT NULL |
| TextQuote | varchar (1) | DEFAULT NULL |
| SkipLines | smallint (6) | DEFAULT 0 |
| DateFormat | varchar (10) | DEFAULT NULL |
| BooleanTrue | varchar (10) | DEFAULT NULL |
| AbkWeiblich | varchar (10) | DEFAULT NULL |
| AbkMaennlich | varchar (10) | DEFAULT NULL |
| MainTable | varchar (50) | DEFAULT NULL |
| InsertMode | int (11) | DEFAULT NULL |
| LookupTableDir | varchar (250) | DEFAULT NULL |
| SchuelerIDMode | varchar (4) | DEFAULT NULL |



# impexp_eigeneimporte_felder

| Name | Type | Spec |
|---|---|---|
| Import_ID | int (11) | NOT NULL DEFAULT 0 |
| Field_ID | int (11) | NOT NULL DEFAULT 0 |
| TableDescription | varchar (50) | DEFAULT NULL |
| FieldDescription | varchar (50) | DEFAULT NULL |
| SrcPosition | smallint (6) | DEFAULT 0 |
| DstTable | varchar (50) | DEFAULT NULL |
| DstFieldName | varchar (50) | DEFAULT NULL |
| DstFieldType | varchar (1) | DEFAULT NULL |
| DstFieldIsIdentifier | int (11) | DEFAULT NULL |
| DstLookupDir | varchar (250) | DEFAULT NULL |
| DstLookupTable | varchar (50) | DEFAULT NULL |
| DstLookupFieldName | varchar (50) | DEFAULT NULL |
| DstLookupTableIDFieldName | varchar (50) | DEFAULT NULL |
| DstResultFieldName | varchar (50) | DEFAULT NULL |
| DstKeyLookupInsert | int (11) | DEFAULT NULL |
| DstKeyLookupNameCreateID | int (11) | DEFAULT NULL |
| DstForceNumeric | int (11) | DEFAULT NULL |



# impexp_eigeneimporte_tabellen

| Name | Type | Spec |
|---|---|---|
| Import_ID | int (11) | NOT NULL DEFAULT 0 |
| TableName | varchar (50) | NOT NULL |
| DstCreateID | int (11) | DEFAULT NULL |
| DstIDFieldName | varchar (50) | DEFAULT NULL |
| Sequence | int (11) | DEFAULT 0 |
| LookupTable | varchar (50) | DEFAULT NULL |
| LookupFields | varchar (50) | DEFAULT NULL |
| LookupFieldTypes | varchar (50) | DEFAULT NULL |
| LookupFieldPos | varchar (50) | DEFAULT NULL |
| LookupKeyField | varchar (50) | DEFAULT NULL |
| LookupResultField | varchar (50) | DEFAULT NULL |
| LookupResultFieldType | varchar (10) | DEFAULT NULL |
| DstDefaultFieldName | varchar (50) | DEFAULT NULL |
| DstDefaultFieldValue | varchar (10) | DEFAULT NULL |
| GU_ID_Field | varchar (50) | DEFAULT NULL |



# k_adressart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |



# k_ankreuzdaten

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| TextStufe1 | varchar (100) | DEFAULT NULL |
| TextStufe2 | varchar (100) | DEFAULT NULL |
| TextStufe3 | varchar (100) | DEFAULT NULL |
| TextStufe4 | varchar (100) | DEFAULT NULL |
| TextStufe5 | varchar (100) | DEFAULT NULL |
| BezeichnungSONST | varchar (100) | DEFAULT NULL |



# k_beschaeftigungsart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (100) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |



# k_datenschutz

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (250) | DEFAULT NULL |
| Sichtbar | varchar (1) | NOT NULL DEFAULT '+' |
| Schluessel | varchar (20) | DEFAULT NULL |
| Sortierung | int (11) | NOT NULL DEFAULT 32000 |
| Beschreibung | longtext | DEFAULT NULL |



# k_einschulungsart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (40) | NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |



# k_einzelleistungen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Gewichtung | float | DEFAULT NULL |



# k_entlassgrund

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |



# k_erzieherart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |
| ExportBez | varchar (20) | DEFAULT NULL |



# k_erzieherfunktion

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |



# k_fahrschuelerart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |



# k_foerderschwerpunkt

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | NOT NULL |
| StatistikKrz | varchar (2) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |



# k_haltestelle

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |
| EntfernungSchule | float | DEFAULT NULL |



# k_kindergarten

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (100) | DEFAULT NULL |
| PLZ | varchar (10) | DEFAULT NULL |
| Ort | varchar (30) | DEFAULT NULL |
| Strassenname | varchar (55) | DEFAULT NULL |
| HausNr | varchar (10) | DEFAULT NULL |
| HausNrZusatz | varchar (30) | DEFAULT NULL |
| Tel | varchar (20) | DEFAULT NULL |
| Email | varchar (40) | DEFAULT NULL |
| Bemerkung | varchar (50) | DEFAULT NULL |
| Sichtbar | varchar (1) | DEFAULT '-' |
| Sortierung | int (11) | DEFAULT NULL |



# k_ort

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| PLZ | varchar (10) | NOT NULL |
| Bezeichnung | varchar (50) | NOT NULL |
| Kreis | varchar (3) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |
| Land | varchar (2) | DEFAULT NULL |



# k_religion

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | NOT NULL |
| StatistikKrz | varchar (10) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |
| ExportBez | varchar (20) | DEFAULT NULL |
| ZeugnisBezeichnung | varchar (50) | DEFAULT NULL |



# k_schule

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| SchulNr | varchar (6) | NOT NULL |
| Name | varchar (120) | DEFAULT NULL |
| SchulformNr | varchar (3) | DEFAULT NULL |
| SchulformKrz | varchar (3) | DEFAULT NULL |
| SchulformBez | varchar (50) | DEFAULT NULL |
| Strassenname | varchar (55) | DEFAULT NULL |
| HausNr | varchar (10) | DEFAULT NULL |
| HausNrZusatz | varchar (30) | DEFAULT NULL |
| PLZ | varchar (10) | DEFAULT NULL |
| Ort | varchar (50) | DEFAULT NULL |
| Telefon | varchar (20) | DEFAULT NULL |
| Fax | varchar (20) | DEFAULT NULL |
| Email | varchar (40) | DEFAULT NULL |
| Schulleiter | varchar (40) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |
| SchulNr_SIM | varchar (6) | DEFAULT NULL |
| Kuerzel | varchar (10) | DEFAULT NULL |
| KurzBez | varchar (40) | DEFAULT NULL |



# k_schulfunktionen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT NULL |
| Sichtbar | varchar (1) | DEFAULT '+' |



# k_schwerpunkt

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |



# k_sportbefreiung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |



# k_telefonart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |



# k_textdateien

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (32) | DEFAULT NULL |
| Text_ID | bigint (20) | NOT NULL |
| Text_Body | longtext | DEFAULT NULL |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Sortierung | smallint (6) | DEFAULT NULL |



# k_vermerkart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |



# k_zertifikate

| Name | Type | Spec |
|---|---|---|
| Kuerzel | varchar (5) | NOT NULL |
| Bezeichnung | varchar (50) | NOT NULL |



# katalog_aufsichtsbereich

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Kuerzel | varchar (20) | NOT NULL |
| Beschreibung | varchar (1000) | NOT NULL |



# katalog_pausenzeiten

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Tag | int (11) | NOT NULL |
| Beginn | time | NOT NULL DEFAULT current_timestamp() |
| Ende | time | NOT NULL DEFAULT current_timestamp() |



# katalog_raeume

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Kuerzel | varchar (20) | NOT NULL |
| Beschreibung | varchar (1000) | NOT NULL |
| Groesse | int (11) | NOT NULL DEFAULT 40 |



# katalog_zeitraster

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Tag | int (11) | NOT NULL |
| Stunde | int (11) | NOT NULL |
| Beginn | time | NOT NULL DEFAULT current_timestamp() |
| Ende | time | NOT NULL DEFAULT current_timestamp() |



# kompetenzgruppen

| Name | Type | Spec |
|---|---|---|
| KG_Spalte | bigint (20) | NOT NULL |
| KG_Zeile | bigint (20) | NOT NULL |
| KG_ID | bigint (20) | NOT NULL |
| KG_Bezeichnung | varchar (50) | NOT NULL |



# lernplattformen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (255) | NOT NULL |
| BenutzernameSuffixLehrer | varchar (255) | DEFAULT NULL |
| BenutzernameSuffixErzieher | varchar (255) | DEFAULT NULL |
| BenutzernameSuffixSchueler | varchar (255) | DEFAULT NULL |
| Konfiguration | longtext | DEFAULT NULL |



# personengruppen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Gruppenname | varchar (100) | NOT NULL |
| Zusatzinfo | varchar (100) | DEFAULT NULL |
| SammelEmail | varchar (100) | DEFAULT NULL |
| GruppenArt | varchar (20) | DEFAULT NULL |
| XMLExport | varchar (1) | DEFAULT '+' |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | DEFAULT '+' |



# schildfilter

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Art | varchar (1) | DEFAULT NULL |
| Name | varchar (50) | NOT NULL |
| Beschreibung | varchar (255) | DEFAULT NULL |
| Tabellen | varchar (255) | DEFAULT NULL |
| ZusatzTabellen | varchar (255) | DEFAULT NULL |
| Bedingung | longtext | DEFAULT NULL |
| BedingungKlartext | longtext | DEFAULT NULL |



# schildintern_abiturinfos

| Name | Type | Spec |
|---|---|---|
| PrfOrdnung | varchar (20) | NOT NULL |
| AbiFach | varchar (1) | NOT NULL |
| Bedingung | varchar (3) | NOT NULL |
| AbiInfoKrz | varchar (20) | NOT NULL |
| AbiInfoBeschreibung | varchar (255) | DEFAULT NULL |
| AbiInfoText | longtext | DEFAULT NULL |



# schildintern_berufsebene

| Name | Type | Spec |
|---|---|---|
| Berufsebene | int (11) | NOT NULL |
| Kuerzel | varchar (2) | NOT NULL |
| Klartext | varchar (255) | DEFAULT NULL |



# schildintern_datenart

| Name | Type | Spec |
|---|---|---|
| DatenartKrz | varchar (10) | NOT NULL |
| Datenart | varchar (50) | DEFAULT NULL |
| Tabellenname | varchar (30) | DEFAULT NULL |
| Reihenfolge | int (11) | DEFAULT NULL |



# schildintern_dqr_niveaus

| Name | Type | Spec |
|---|---|---|
| Gliederung | varchar (4) | NOT NULL |
| FKS | varchar (8) | NOT NULL |
| DQR_Niveau | int (11) | NOT NULL |



# schildintern_fachgruppen

| Name | Type | Spec |
|---|---|---|
| FG_ID | bigint (20) | NOT NULL |
| FG_SF | varchar (50) | DEFAULT NULL |
| FG_Bezeichnung | varchar (50) | DEFAULT NULL |
| FG_Farbe | int (11) | DEFAULT NULL |
| FG_Sortierung | int (11) | DEFAULT NULL |
| FG_Kuerzel | varchar (5) | DEFAULT NULL |
| FG_Zeugnis | varchar (1) | DEFAULT NULL |



# schildintern_faechersortierung

| Name | Type | Spec |
|---|---|---|
| Fach | varchar (2) | NOT NULL |
| Bezeichnung | varchar (80) | DEFAULT NULL |
| Sortierung1 | int (11) | DEFAULT NULL |
| Sortierung2 | int (11) | DEFAULT NULL |
| Fachgruppe_ID | bigint (20) | DEFAULT NULL |
| FachgruppeKrz | varchar (2) | DEFAULT NULL |
| AufgabenbereichAbitur | varchar (5) | DEFAULT NULL |



# schildintern_filterfehlendeeintraege

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Beschreibung | varchar (100) | DEFAULT NULL |
| Feldname | varchar (30) | DEFAULT NULL |
| Tabellen | varchar (50) | DEFAULT NULL |
| SQLText | varchar (100) | DEFAULT NULL |
| Schulform | varchar (50) | DEFAULT NULL |
| Feldtyp | varchar (1) | DEFAULT NULL |



# schildintern_filterfeldliste

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Bezeichnung | varchar (50) | DEFAULT NULL |
| DBFeld | varchar (50) | DEFAULT NULL |
| Typ | varchar (50) | DEFAULT NULL |
| Werte | varchar (20) | DEFAULT NULL |
| StdWert | varchar (5) | DEFAULT NULL |
| Operator | varchar (10) | DEFAULT NULL |
| Zusatzbedingung | varchar (50) | DEFAULT NULL |



# schildintern_hschstatus

| Name | Type | Spec |
|---|---|---|
| StatusNr | int (11) | NOT NULL |
| Bezeichnung | varchar (255) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT NULL |
| InSimExp | varchar (1) | DEFAULT '+' |
| SIMAbschnitt | varchar (1) | DEFAULT NULL |



# schildintern_k_schulnote

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Krz | varchar (2) | DEFAULT NULL |
| Art | varchar (1) | DEFAULT NULL |
| Bezeichnung | varchar (40) | DEFAULT NULL |
| Zeugnisnotenbez | varchar (40) | DEFAULT NULL |
| Punkte | varchar (2) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT NULL |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Aenderbar | varchar (1) | DEFAULT '+' |



# schildintern_kaoa_anschlussoption

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| GueltigAb | datetime | DEFAULT NULL |
| GueltigBis | datetime | DEFAULT NULL |
| AO_Kuerzel | varchar (10) | NOT NULL |
| AO_Beschreibung | varchar (255) | DEFAULT NULL |
| AO_Stufen | varchar (10) | DEFAULT NULL |
| Zusatzmerkmal_Anzeige | varchar (50) | DEFAULT NULL |



# schildintern_kaoa_berufsfeld

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| GueltigAb | datetime | DEFAULT NULL |
| GueltigBis | datetime | DEFAULT NULL |
| BF_Kuerzel | varchar (10) | NOT NULL |
| BF_Beschreibung | varchar (255) | DEFAULT NULL |



# schildintern_kaoa_kategorie

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| GueltigAb | datetime | DEFAULT NULL |
| GueltigBis | datetime | DEFAULT NULL |
| K_Kuerzel | varchar (10) | NOT NULL |
| K_Beschreibung | varchar (255) | DEFAULT NULL |
| K_Jahrgaenge | varchar (25) | DEFAULT NULL |



# schildintern_laender

| Name | Type | Spec |
|---|---|---|
| Kurztext | varchar (2) | NOT NULL |
| Langtext | varchar (40) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT NULL |



# schildintern_prfsemabschl

| Name | Type | Spec |
|---|---|---|
| Nr | varchar (2) | NOT NULL |
| Klartext | varchar (50) | DEFAULT NULL |
| StatistikKrz | varchar (1) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT NULL |
| Schulform | varchar (2) | NOT NULL |
| StatistikKrzNeu | varchar (2) | DEFAULT NULL |



# schildintern_prueford_optionen

| Name | Type | Spec |
|---|---|---|
| OP_Schulformen | varchar (20) | NOT NULL |
| OP_POKrz | varchar (30) | NOT NULL |
| OP_Krz | varchar (40) | NOT NULL |
| OP_Abgangsart_B | varchar (2) | DEFAULT NULL |
| OP_Abgangsart_NB | varchar (2) | DEFAULT NULL |
| OP_Art | varchar (1) | NOT NULL |
| OP_Typ | varchar (5) | DEFAULT NULL |
| OP_Bildungsgang | varchar (1) | NOT NULL |
| OP_Name | varchar (255) | NOT NULL |
| OP_Kommentar | varchar (100) | DEFAULT NULL |
| OP_Jahrgaenge | varchar (20) | NOT NULL |
| OP_BKIndex | varchar (50) | DEFAULT NULL |
| OP_BKAnl_Typ | varchar (50) | DEFAULT NULL |
| OP_Reihenfolge | int (11) | NOT NULL |



# schildintern_pruefungsordnung

| Name | Type | Spec |
|---|---|---|
| PO_Schulform | varchar (50) | NOT NULL |
| PO_Krz | varchar (30) | NOT NULL |
| PO_Name | varchar (255) | NOT NULL |
| PO_SGL | varchar (50) | NOT NULL |
| PO_MinJahrgang | int (11) | NOT NULL DEFAULT 0 |
| PO_MaxJahrgang | int (11) | NOT NULL DEFAULT 20 |
| PO_Jahrgaenge | varchar (30) | NOT NULL |



# schildintern_schuelerimpexp

| Name | Type | Spec |
|---|---|---|
| Tabelle | varchar (50) | NOT NULL |
| TabellenAnzeige | varchar (50) | DEFAULT NULL |
| MasterTable | varchar (50) | DEFAULT NULL |
| ExpCmd | varchar (250) | DEFAULT NULL |
| SrcGetFieldsSQL | varchar (250) | DEFAULT NULL |
| DeleteSQL | varchar (250) | DEFAULT NULL |
| DstGetIDSQL | varchar (250) | DEFAULT NULL |
| HauptFeld | varchar (50) | DEFAULT NULL |
| DetailFeld | varchar (50) | DEFAULT NULL |
| Reihenfolge | int (11) | DEFAULT NULL |



# schildintern_spezialfilterfelder

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Gruppe | varchar (2) | DEFAULT NULL |
| KurzBez | varchar (50) | DEFAULT NULL |
| Bezeichnung | varchar (50) | DEFAULT NULL |
| Grundschule | varchar (1) | DEFAULT NULL |
| Tabelle | varchar (30) | DEFAULT NULL |
| DBFeld | varchar (50) | DEFAULT NULL |
| Typ | varchar (1) | DEFAULT NULL |
| Control | varchar (10) | DEFAULT NULL |
| WerteAnzeige | varchar (20) | DEFAULT NULL |
| WerteSQL | varchar (20) | DEFAULT NULL |
| LookupInfo | varchar (50) | DEFAULT NULL |
| OperatorenAnzeige | varchar (150) | DEFAULT NULL |
| OperatorenSQL | varchar (100) | DEFAULT NULL |
| Zusatzbedingung | varchar (100) | DEFAULT NULL |
| ZusatzTabellen | varchar (50) | DEFAULT NULL |



# schildintern_textexport

| Name | Type | Spec |
|---|---|---|
| DatenartKrz | varchar (10) | NOT NULL |
| Feldname | varchar (30) | NOT NULL |
| AnzeigeText | varchar (50) | NOT NULL |
| Feldtyp | varchar (1) | DEFAULT NULL |
| Feldwerte | varchar (20) | DEFAULT NULL |
| ErgebnisWerte | varchar (100) | DEFAULT NULL |
| LookupFeldname | varchar (100) | DEFAULT NULL |
| LookupSQLText | longtext | DEFAULT NULL |
| DBFormat | varchar (10) | NOT NULL DEFAULT 'ALLE' |



# schildintern_unicodeumwandlung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Unicodezeichen | varchar (2) | DEFAULT NULL |
| Ersatzzeichen | varchar (2) | DEFAULT NULL |
| DecimalZeichen | varchar (20) | DEFAULT NULL |
| DecimalErsatzzeichen | varchar (20) | DEFAULT NULL |
| Hexzeichen | varchar (50) | DEFAULT NULL |
| HexErsatzzeichen | varchar (50) | DEFAULT NULL |



# schildintern_verfimportfelder

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| TableDescription | varchar (50) | DEFAULT NULL |
| FieldDescription | varchar (50) | DEFAULT NULL |
| DstTable | varchar (50) | DEFAULT NULL |
| DstFieldName | varchar (50) | DEFAULT NULL |
| DstFieldType | varchar (1) | DEFAULT NULL |
| DstRequiredState | varchar (1) | DEFAULT NULL |
| DstLookupTable | varchar (50) | DEFAULT NULL |
| DstLookupTableIDFieldName | varchar (50) | DEFAULT NULL |
| DstLookupFieldName | varchar (50) | DEFAULT NULL |
| DstResultFieldName | varchar (50) | DEFAULT NULL |
| DstKeyLookupInsert | varchar (1) | DEFAULT NULL |
| DstKeyLookupNameCreateID | varchar (1) | DEFAULT NULL |
| DstForceNumeric | varchar (1) | DEFAULT NULL |



# schildintern_verfimporttabellen

| Name | Type | Spec |
|---|---|---|
| TableName | varchar (50) | NOT NULL |
| DstRequiredFields | varchar (50) | DEFAULT NULL |
| DstIDFieldName | varchar (50) | DEFAULT NULL |
| Sequence | int (11) | DEFAULT NULL |
| LookupTable | varchar (50) | DEFAULT NULL |
| LookupFields | varchar (50) | DEFAULT NULL |
| LookupFieldTypes | varchar (50) | DEFAULT NULL |
| LookupResultField | varchar (50) | DEFAULT NULL |
| LookupResultFieldType | varchar (10) | DEFAULT NULL |
| LookupKeyField | varchar (50) | DEFAULT NULL |
| DstDefaultFieldName | varchar (50) | DEFAULT NULL |
| DstDefaultFieldValue | varchar (20) | DEFAULT NULL |
| DstCreateID | varchar (1) | DEFAULT NULL |
| GU_ID_Field | varchar (50) | DEFAULT NULL |



# schildintern_zusatzinfos

| Name | Type | Spec |
|---|---|---|
| SGL_BKAbschl | varchar (50) | NOT NULL |
| JG_BKAbschl | varchar (50) | NOT NULL |



# schuelerliste

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | NOT NULL |
| Erzeuger | varchar (20) | DEFAULT NULL |
| Privat | varchar (1) | DEFAULT '+' |



# schulecredentials

| Name | Type | Spec |
|---|---|---|
| Schulnummer | int (11) | NOT NULL |
| RSAPublicKey | longtext | DEFAULT NULL |
| RSAPrivateKey | longtext | DEFAULT NULL |
| AES | longtext | DEFAULT NULL |



# schuljahresabschnitte

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Jahr | int (11) | NOT NULL |
| Abschnitt | int (11) | NOT NULL |
| VorigerAbschnitt_ID | bigint (20) | DEFAULT NULL |
| FolgeAbschnitt_ID | bigint (20) | DEFAULT NULL |



# schulleitungfunktion

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Funktionstext | varchar (255) | NOT NULL |
| AbSchuljahr | int (11) | DEFAULT NULL |
| BisSchuljahr | int (11) | DEFAULT NULL |



# schulver_dbs

| Name | Type | Spec |
|---|---|---|
| SchulNr | varchar (6) | NOT NULL |
| RegSchl | varchar (6) | DEFAULT NULL |
| KoRe | float | DEFAULT NULL |
| KoHo | float | DEFAULT NULL |
| ABez1 | varchar (40) | DEFAULT NULL |
| ABez2 | varchar (40) | DEFAULT NULL |
| ABez3 | varchar (40) | DEFAULT NULL |
| PLZ | varchar (6) | DEFAULT NULL |
| Ort | varchar (34) | DEFAULT NULL |
| Strasse | varchar (40) | DEFAULT NULL |
| TelVorw | varchar (6) | DEFAULT NULL |
| Telefon | varchar (12) | DEFAULT NULL |
| FaxVorw | varchar (6) | DEFAULT NULL |
| Fax | varchar (15) | DEFAULT NULL |
| ModemVorw | varchar (6) | DEFAULT NULL |
| Modem | varchar (15) | DEFAULT NULL |
| SF | varchar (2) | DEFAULT NULL |
| OeffPri | varchar (1) | DEFAULT NULL |
| KurzBez | varchar (40) | DEFAULT NULL |
| SchBetrSchl | int (11) | DEFAULT NULL |
| SchBetrSchlDatum | varchar (8) | DEFAULT NULL |
| ArtDerTraegerschaft | varchar (2) | DEFAULT NULL |
| SchultraegerNr | varchar (6) | DEFAULT NULL |
| Schulgliederung | varchar (3) | DEFAULT NULL |
| Schulart | varchar (3) | DEFAULT NULL |
| Ganztagsbetrieb | varchar (1) | DEFAULT NULL |
| FSP | varchar (2) | DEFAULT NULL |
| Verbund | varchar (1) | DEFAULT NULL |
| Bus | varchar (1) | DEFAULT NULL |
| Fachberater | int (11) | DEFAULT NULL |
| FachberHauptamtl | int (11) | DEFAULT NULL |
| TelNrDBSalt | varchar (15) | DEFAULT NULL |
| RP | varchar (1) | DEFAULT NULL |
| Email | varchar (100) | DEFAULT NULL |
| URL | varchar (1000) | DEFAULT NULL |
| Bemerkung | longtext | DEFAULT NULL |
| CD | int (11) | DEFAULT NULL |
| Stift | int (11) | DEFAULT NULL |
| OGTS | varchar (1) | DEFAULT NULL |
| SELB | varchar (1) | DEFAULT NULL |
| Internat | varchar (1) | DEFAULT NULL |
| InternatPlaetze | int (11) | DEFAULT 0 |
| SMail | varchar (50) | DEFAULT NULL |
| SportImAbi | varchar (1) | NOT NULL DEFAULT '0' |
| Tal | varchar (1) | NOT NULL DEFAULT '0' |
| KonKop | varchar (1) | NOT NULL DEFAULT '0' |



# schulver_schulformen

| Name | Type | Spec |
|---|---|---|
| Schulform | varchar (2) | NOT NULL |
| SF | varchar (2) | DEFAULT NULL |
| Bezeichnung | varchar (60) | DEFAULT NULL |
| Flag | varchar (1) | DEFAULT '1' |
| geaendert | datetime | DEFAULT NULL |



# schulver_schultraeger

| Name | Type | Spec |
|---|---|---|
| SchulNr | varchar (255) | NOT NULL |
| RegSchl | varchar (255) | DEFAULT NULL |
| KoRe | varchar (255) | DEFAULT NULL |
| KoHo | varchar (255) | DEFAULT NULL |
| ABez1 | varchar (255) | DEFAULT NULL |
| ABez2 | varchar (255) | DEFAULT NULL |
| ABez3 | varchar (255) | DEFAULT NULL |
| PLZ | varchar (255) | DEFAULT NULL |
| Ort | varchar (255) | DEFAULT NULL |
| Strasse | varchar (255) | DEFAULT NULL |
| TelVorw | varchar (255) | DEFAULT NULL |
| Telefon | varchar (255) | DEFAULT NULL |
| SF | varchar (255) | DEFAULT NULL |
| OeffPri | varchar (255) | DEFAULT NULL |
| KurzBez | varchar (255) | DEFAULT NULL |
| SchBetrSchl | int (11) | DEFAULT NULL |
| SchBetrSchlDatum | varchar (255) | DEFAULT NULL |
| SchuelerZahlASD | int (11) | DEFAULT 0 |
| SchuelerZahlVS | int (11) | DEFAULT 0 |
| ArtDerTraegerschaft | varchar (255) | DEFAULT NULL |
| SchultraegerNr | varchar (255) | DEFAULT NULL |
| Schulgliederung | varchar (255) | DEFAULT NULL |
| Ganztagsbetrieb | varchar (255) | DEFAULT NULL |
| Aktiv | int (11) | NOT NULL DEFAULT 1 |



# schulver_weiteresf

| Name | Type | Spec |
|---|---|---|
| SNR | varchar (6) | NOT NULL |
| SGL | varchar (3) | NOT NULL DEFAULT '   ' |
| FSP | varchar (2) | NOT NULL DEFAULT '  ' |



# statkue_abgangsart

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | NOT NULL |
| Art | varchar (2) | NOT NULL |
| Beschreibung | varchar (200) | DEFAULT NULL |
| KZ_Bereich | int (11) | NOT NULL DEFAULT 0 |
| KZ_Bereich_JG | int (11) | DEFAULT 0 |
| AbgangsJG | varchar (2) | NOT NULL |
| Flag | varchar (1) | DEFAULT '1' |
| geaendert | datetime | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 0 |



# statkue_allgmerkmale

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| SF | varchar (2) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| StatistikKrz | varchar (5) | DEFAULT NULL |
| Langtext | varchar (255) | NOT NULL |
| Schule | int (11) | DEFAULT NULL |
| Schueler | int (11) | DEFAULT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | DEFAULT NULL |



# statkue_anderegrundschulen

| Name | Type | Spec |
|---|---|---|
| SNR | varchar (6) | NOT NULL |
| SF | varchar (2) | DEFAULT NULL |
| ABez1 | varchar (40) | DEFAULT NULL |
| Strasse | varchar (40) | DEFAULT NULL |
| Ort | varchar (40) | DEFAULT NULL |
| Auswahl | int (11) | DEFAULT NULL |
| RegSchl | varchar (6) | DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_bilingual

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | NOT NULL |
| Fach | varchar (2) | NOT NULL |
| Beschreibung | varchar (100) | DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_einschulungsart

| Name | Type | Spec |
|---|---|---|
| Art | varchar (2) | NOT NULL |
| Sortierung | int (11) | DEFAULT 0 |
| Beschreibung | varchar (100) | DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_fachklasse

| Name | Type | Spec |
|---|---|---|
| BKIndex | int (11) | NOT NULL DEFAULT 0 |
| Flag | varchar (1) | DEFAULT NULL |
| FKS | varchar (3) | NOT NULL |
| AP | varchar (2) | NOT NULL |
| BGrp | varchar (1) | DEFAULT NULL |
| BFeld | varchar (2) | DEFAULT NULL |
| Ebene3 | varchar (2) | DEFAULT NULL |
| BAKLALT | varchar (2) | DEFAULT NULL |
| BAGRALT | varchar (4) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 0 |
| Status | varchar (20) | DEFAULT NULL |
| Flag_APOBK | varchar (1) | DEFAULT NULL |
| Beschreibung | varchar (100) | DEFAULT NULL |
| Beschreibung_W | varchar (100) | DEFAULT NULL |
| Beschreibung_MW | varchar (100) | DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |
| BAKL | varchar (5) | DEFAULT NULL |
| BAGR | varchar (8) | DEFAULT NULL |
| Ebene1 | varchar (2) | DEFAULT NULL |
| Ebene2 | varchar (2) | DEFAULT NULL |



# statkue_foerderschwerpunkt

| Name | Type | Spec |
|---|---|---|
| Beschreibung | varchar (100) | DEFAULT NULL |
| Flag | varchar (1) | DEFAULT '1' |
| FSP | varchar (2) | NOT NULL |
| geaendert | datetime | DEFAULT NULL |
| SF | varchar (2) | NOT NULL |



# statkue_gliederung

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | NOT NULL |
| Flag | varchar (1) | NOT NULL |
| BKAnlage | varchar (1) | NOT NULL |
| BKTyp | varchar (2) | NOT NULL |
| BKIndex | int (11) | DEFAULT 0 |
| Beschreibung | varchar (100) | DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_herkunftsart

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | NOT NULL |
| Art | varchar (2) | NOT NULL |
| Beschreibung | varchar (255) | NOT NULL |
| Flag | varchar (1) | NOT NULL DEFAULT '1' |
| Sortierung | int (11) | NOT NULL DEFAULT 0 |
| geaendert | datetime | DEFAULT NULL |



# statkue_herkunftsschulform

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | NOT NULL |
| HSF | varchar (3) | NOT NULL |
| Beschreibung | varchar (150) | NOT NULL |
| Flag | varchar (1) | NOT NULL DEFAULT '1' |
| geaendert | datetime | DEFAULT NULL |



# statkue_lehrerabgang

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |
| ASDSchluessel | varchar (2) | DEFAULT NULL |



# statkue_lehreranrechnung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| GueltigAbSJ | int (11) | DEFAULT NULL |
| GueltigBisSJ | int (11) | DEFAULT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerbeschaeftigungsart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrereinsatzstatus

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerfachranerkennung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerfachrichtung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerlehramt

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerlehramtanerkennung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerlehrbefaehigung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerlehrbefanerkennung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrermehrleistung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerminderleistung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerrechtsverhaeltnis

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerzugang

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |
| ASDSchluessel | varchar (2) | DEFAULT NULL |



# statkue_nationalitaeten

| Name | Type | Spec |
|---|---|---|
| Schluessel | varchar (3) | NOT NULL |
| Land | varchar (255) | NOT NULL |
| Nationalitaet | varchar (255) | NOT NULL |
| Flag | varchar (1) | DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |



# statkue_organisationsform

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | NOT NULL |
| OrgForm | varchar (1) | NOT NULL |
| FSP | varchar (2) | NOT NULL |
| Beschreibung | varchar (100) | NOT NULL |
| Flag | varchar (1) | DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_plzort

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| PLZ | varchar (50) | DEFAULT NULL |
| RegSchl | varchar (50) | DEFAULT NULL |
| Ort | varchar (50) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 1 |



# statkue_reformpaedagogik

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | NOT NULL |
| RPG | varchar (1) | NOT NULL |
| Beschreibung | varchar (100) | NOT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_religionen

| Name | Type | Spec |
|---|---|---|
| Schluessel | varchar (2) | NOT NULL |
| Klartext | varchar (50) | NOT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_schuelerersteschulformseki

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| SF | varchar (2) | DEFAULT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |
| geaendert | datetime | DEFAULT NULL |



# statkue_schuelerkindergartenbesuch

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| SF | varchar (2) | DEFAULT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_schueleruebergangsempfehlung5jg

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| SF | varchar (2) | DEFAULT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | DEFAULT NULL |
| HGSEM | varchar (4) | NOT NULL |



# statkue_schuelerverkehrssprache

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | NOT NULL |
| Langtext | varchar (255) | NOT NULL |
| Gesprochen_in | varchar (255) | DEFAULT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |



# statkue_schulformen

| Name | Type | Spec |
|---|---|---|
| Schulform | varchar (2) | DEFAULT NULL |
| SF | varchar (2) | NOT NULL |
| Bezeichnung | varchar (50) | NOT NULL |
| Flag | varchar (1) | NOT NULL DEFAULT '1' |
| geaendert | datetime | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 0 |



# statkue_strassen

| Name | Type | Spec |
|---|---|---|
| Ort | varchar (50) | NOT NULL |
| RegSchl | varchar (8) | NOT NULL |
| Strasse | varchar (75) | NOT NULL |
| Stand | varchar (20) | DEFAULT NULL |



# statkue_svws_bkanlagen

| Name | Type | Spec |
|---|---|---|
| BKAnlage | varchar (1) | NOT NULL |
| Beschreibung | varchar (120) | NOT NULL |



# statkue_svws_fachgruppen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Fachbereich | int (11) | DEFAULT NULL |
| SchildFgID | bigint (20) | DEFAULT NULL |
| FG_Bezeichnung | varchar (80) | NOT NULL |
| FG_Kuerzel | varchar (10) | DEFAULT NULL |
| Schulformen | varchar (255) | DEFAULT NULL |
| FarbeR | int (11) | DEFAULT NULL |
| FarbeG | int (11) | DEFAULT NULL |
| FarbeB | int (11) | DEFAULT NULL |
| gueltigVon | int (11) | DEFAULT NULL |
| gueltigBis | int (11) | DEFAULT NULL |



# statkue_svws_schulgliederungen

| Name | Type | Spec |
|---|---|---|
| SGL | varchar (3) | NOT NULL |
| istBK | int (11) | NOT NULL DEFAULT 0 |
| Schulformen | varchar (120) | NOT NULL |
| istAuslaufend | int (11) | NOT NULL DEFAULT 0 |
| istAusgelaufen | int (11) | NOT NULL DEFAULT 0 |
| Beschreibung | varchar (120) | NOT NULL |
| BKAnlage | varchar (1) | DEFAULT NULL |
| BKTyp | varchar (2) | DEFAULT NULL |
| BKIndex | varchar (10) | DEFAULT NULL |
| istVZ | int (11) | DEFAULT 0 |
| BKAbschlussBeruf | varchar (10) | DEFAULT NULL |
| BKAbschlussAllg | varchar (10) | DEFAULT NULL |



# statkue_svws_sprachpruefungniveaus

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Bezeichnung | varchar (16) | NOT NULL |
| Beschreibung | varchar (200) | NOT NULL |
| Sortierung | int (11) | NOT NULL |
| gueltigVon | int (11) | DEFAULT NULL |
| gueltigBis | int (11) | DEFAULT NULL |



# statkue_svws_zulaessigefaecher

| Name | Type | Spec |
|---|---|---|
| Fach | varchar (2) | NOT NULL |
| Bezeichnung | varchar (80) | NOT NULL |
| FachkuerzelAtomar | varchar (2) | NOT NULL |
| Kurzbezeichnung | varchar (80) | DEFAULT NULL |
| Aufgabenfeld | int (11) | DEFAULT NULL |
| Fachgruppe_ID | bigint (20) | DEFAULT NULL |
| SchulformenUndGliederungen | varchar (255) | DEFAULT NULL |
| SchulformenAusgelaufen | varchar (255) | DEFAULT NULL |
| AusgelaufenInSchuljahr | varchar (255) | DEFAULT NULL |
| AbJahrgang | varchar (2) | DEFAULT NULL |
| IstFremdsprache | int (11) | NOT NULL |
| IstHKFS | int (11) | NOT NULL |
| IstAusRegUFach | int (11) | NOT NULL |
| IstErsatzPflichtFS | int (11) | NOT NULL |
| IstKonfKoop | int (11) | NOT NULL |
| NurSII | int (11) | NOT NULL |
| ExportASD | int (11) | NOT NULL |
| gueltigVon | int (11) | DEFAULT NULL |
| gueltigBis | int (11) | DEFAULT NULL |



# statkue_svws_zulaessigejahrgaenge

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Schulform | varchar (2) | NOT NULL |
| SchulformKuerzel | varchar (3) | NOT NULL |
| Jahrgang | varchar (2) | NOT NULL |
| Beschreibung | varchar (80) | NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 0 |



# statkue_svws_zulaessigekursarten

| Name | Type | Spec |
|---|---|---|
| ID | varchar (7) | NOT NULL |
| Kuerzel | varchar (5) | NOT NULL |
| ASDNummer | varchar (2) | NOT NULL |
| Bezeichnung | varchar (120) | NOT NULL |
| SchulformenUndGliederungen | varchar (255) | DEFAULT NULL |
| KuerzelAllg | varchar (5) | DEFAULT NULL |
| BezeichnungAllg | varchar (120) | DEFAULT NULL |
| SchulformenAusgelaufen | varchar (255) | DEFAULT NULL |
| erlaubtGOSt | int (11) | NOT NULL DEFAULT 0 |
| AusgelaufenInSchuljahr | varchar (255) | DEFAULT NULL |
| Bemerkungen | varchar (120) | DEFAULT NULL |



# statkue_zulfaecher

| Name | Type | Spec |
|---|---|---|
| Schulform | varchar (2) | NOT NULL |
| FSP | varchar (2) | DEFAULT NULL |
| BG | varchar (3) | NOT NULL |
| Fach | varchar (2) | NOT NULL |
| Bezeichnung | varchar (80) | NOT NULL |
| KZ_Bereich | int (11) | DEFAULT 0 |
| Flag | varchar (1) | NOT NULL DEFAULT '1' |
| Sortierung | int (11) | DEFAULT 0 |
| Sortierung2 | int (11) | DEFAULT 0 |
| geaendert | datetime | DEFAULT NULL |



# statkue_zuljahrgaenge

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Schulform | varchar (2) | NOT NULL |
| SNR | varchar (6) | DEFAULT NULL |
| FSP | varchar (2) | DEFAULT NULL |
| Jahrgang | varchar (2) | DEFAULT NULL |
| KZ_Bereich | int (11) | DEFAULT 0 |
| Beschreibung | varchar (255) | DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_zulklart

| Name | Type | Spec |
|---|---|---|
| KlArt | varchar (2) | NOT NULL |
| FSP | varchar (2) | NOT NULL |
| Bezeichnung | varchar (100) | NOT NULL |
| Schulform | varchar (2) | NOT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_zulkuart

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | NOT NULL |
| FSP | varchar (2) | NOT NULL |
| BG | varchar (3) | NOT NULL |
| Kursart | varchar (3) | NOT NULL |
| Kursart2 | varchar (5) | NOT NULL |
| Bezeichnung | varchar (120) | NOT NULL |
| SGLBereich | int (11) | NOT NULL DEFAULT 0 |
| Flag | varchar (1) | NOT NULL DEFAULT '1' |
| geaendert | datetime | DEFAULT NULL |



# stundentafel

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | NOT NULL |
| Jahrgang_ID | bigint (20) | DEFAULT NULL |
| ASDJahrgang | varchar (2) | DEFAULT NULL |
| SGL | varchar (3) | DEFAULT NULL |
| Fachklasse_ID | bigint (20) | DEFAULT NULL |
| Sichtbar | varchar (1) | DEFAULT '+' |
| Sortierung | int (11) | DEFAULT 32000 |



# svws_client_konfiguration_global

| Name | Type | Spec |
|---|---|---|
| AppName | varchar (100) | NOT NULL |
| Schluessel | varchar (255) | NOT NULL |
| Wert | longtext | NOT NULL |



# svws_db_autoinkremente

| Name | Type | Spec |
|---|---|---|
| NameTabelle | varchar (200) | NOT NULL |
| MaxID | bigint (20) | NOT NULL DEFAULT 1 |



# svws_db_version

| Name | Type | Spec |
|---|---|---|
| Revision | int (11) | NOT NULL DEFAULT 0 |
| IsTainted | int (11) | NOT NULL DEFAULT 0 |



# textexportvorlagen

| Name | Type | Spec |
|---|---|---|
| VorlageName | varchar (50) | NOT NULL |
| Daten | longtext | DEFAULT NULL |



# usergroups

| Name | Type | Spec |
|---|---|---|
| UG_ID | bigint (20) | NOT NULL |
| UG_Bezeichnung | varchar (64) | DEFAULT NULL |
| UG_Kompetenzen | varchar (255) | DEFAULT NULL |
| UG_Nr | int (11) | DEFAULT NULL |



# users

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| US_Name | varchar (50) | NOT NULL |
| US_LoginName | varchar (20) | NOT NULL |
| US_Password | varchar (20) | DEFAULT NULL |
| US_UserGroups | varchar (50) | DEFAULT NULL |
| US_Privileges | varchar (255) | DEFAULT NULL |
| Email | varchar (100) | DEFAULT NULL |
| EmailName | varchar (100) | DEFAULT NULL |
| SMTPUsername | varchar (100) | DEFAULT NULL |
| SMTPPassword | varchar (100) | DEFAULT NULL |
| EmailSignature | longtext | DEFAULT NULL |
| HeartbeatDate | int (11) | DEFAULT NULL |
| ComputerName | varchar (50) | DEFAULT NULL |
| US_PasswordHash | varchar (255) | DEFAULT NULL |



# benutzerallgemein

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| AnzeigeName | varchar (255) | DEFAULT NULL |  |
| [CredentialID](#credentials) | bigint (20) | DEFAULT NULL | FOREIGN KEY (CredentialID) REFERENCES credentials(ID) |



# credentialslernplattformen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [LernplattformID](#lernplattformen) | bigint (20) | NOT NULL | FOREIGN KEY (LernplattformID) REFERENCES lernplattformen(ID) |
| Benutzername | varchar (255) | NOT NULL |  |
| BenutzernamePseudonym | varchar (255) | DEFAULT NULL |  |
| Initialkennwort | varchar (255) | DEFAULT NULL |  |
| PashwordHash | varchar (255) | DEFAULT NULL |  |
| RSAPublicKey | longtext | DEFAULT NULL |  |
| RSAPrivateKey | longtext | DEFAULT NULL |  |
| AES | longtext | DEFAULT NULL |  |



# eigeneschule

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL |  |
| SchulformNr | varchar (3) | DEFAULT NULL |  |
| SchulformKrz | varchar (3) | DEFAULT NULL |  |
| SchulformBez | varchar (50) | DEFAULT NULL |  |
| SchultraegerArt | varchar (2) | DEFAULT NULL |  |
| SchultraegerNr | varchar (6) | DEFAULT NULL |  |
| SchulNr | varchar (6) | DEFAULT NULL |  |
| Bezeichnung1 | varchar (50) | DEFAULT NULL |  |
| Bezeichnung2 | varchar (50) | DEFAULT NULL |  |
| Bezeichnung3 | varchar (50) | DEFAULT NULL |  |
| Strassenname | varchar (55) | DEFAULT NULL |  |
| HausNr | varchar (10) | DEFAULT NULL |  |
| HausNrZusatz | varchar (30) | DEFAULT NULL |  |
| PLZ | varchar (10) | DEFAULT NULL |  |
| Ort | varchar (50) | DEFAULT NULL |  |
| Telefon | varchar (20) | DEFAULT NULL |  |
| Fax | varchar (20) | DEFAULT NULL |  |
| Email | varchar (100) | DEFAULT NULL |  |
| Ganztags | varchar (1) | DEFAULT '+' |  |
| [Schuljahresabschnitts_ID](#schuljahresabschnitte) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Schuljahresabschnitts_ID) REFERENCES schuljahresabschnitte(ID) |
| AnzahlAbschnitte | int (11) | DEFAULT 2 |  |
| Fremdsprachen | varchar (1) | DEFAULT '+' |  |
| JVAZeigen | varchar (1) | DEFAULT '-' |  |
| RefPaedagogikZeigen | varchar (1) | DEFAULT '-' |  |
| AnzJGS_Jahr | smallint (6) | DEFAULT 1 |  |
| AbschnittBez | varchar (20) | DEFAULT 'Halbjahr' |  |
| BezAbschnitt1 | varchar (10) | DEFAULT '1. Hj' |  |
| BezAbschnitt2 | varchar (10) | DEFAULT '2. Hj' |  |
| IstHauptsitz | varchar (1) | DEFAULT '+' |  |
| NotenGesperrt | varchar (1) | DEFAULT '-' |  |
| BezAbschnitt3 | varchar (10) | DEFAULT NULL |  |
| BezAbschnitt4 | varchar (10) | DEFAULT NULL |  |
| ZurueckgestelltAnzahl | int (11) | DEFAULT NULL |  |
| ZurueckgestelltWeibl | int (11) | DEFAULT NULL |  |
| ZurueckgestelltAuslaender | int (11) | DEFAULT NULL |  |
| ZurueckgestelltAuslaenderWeibl | int (11) | DEFAULT NULL |  |
| ZurueckgestelltAussiedler | int (11) | DEFAULT NULL |  |
| ZurueckgestelltAussiedlerWeibl | int (11) | DEFAULT NULL |  |
| TeamTeaching | varchar (1) | DEFAULT '+' |  |
| AbiGruppenprozess | varchar (1) | DEFAULT '+' |  |
| DauerUnterrichtseinheit | int (11) | DEFAULT NULL |  |
| Gruppen8Bis1 | int (11) | DEFAULT NULL |  |
| Gruppen13Plus | int (11) | DEFAULT NULL |  |
| InternatsplaetzeM | int (11) | DEFAULT NULL |  |
| InternatsplaetzeW | int (11) | DEFAULT NULL |  |
| InternatsplaetzeNeutral | int (11) | DEFAULT NULL |  |
| SchulLogoBase64 | longtext | DEFAULT NULL |  |
| Einstellungen | longtext | DEFAULT NULL |  |
| WebAdresse | varchar (100) | DEFAULT NULL |  |
| Land | varchar (50) | DEFAULT NULL |  |



# eigeneschule_fachteilleistungen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| Teilleistung_ID | bigint (20) | NOT NULL |  |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| Kursart | varchar (5) | NOT NULL |  |



# eigeneschule_jahrgaenge

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| InternKrz | varchar (20) | DEFAULT NULL |  |
| [GueltigVon](#schuljahresabschnitte) | bigint (20) | DEFAULT NULL | FOREIGN KEY (GueltigVon) REFERENCES schuljahresabschnitte(ID) |
| [GueltigBis](#schuljahresabschnitte) | bigint (20) | DEFAULT NULL | FOREIGN KEY (GueltigBis) REFERENCES schuljahresabschnitte(ID) |
| ASDJahrgang | varchar (2) | DEFAULT NULL |  |
| ASDBezeichnung | varchar (100) | DEFAULT NULL |  |
| Sichtbar | varchar (1) | DEFAULT '+' |  |
| Sortierung | int (11) | DEFAULT 32000 |  |
| IstChronologisch | varchar (1) | DEFAULT '+' |  |
| Spaltentitel | varchar (2) | DEFAULT NULL |  |
| SekStufe | varchar (6) | DEFAULT NULL |  |
| [SGL](#statkue_svws_schulgliederungen) | varchar (3) | DEFAULT NULL | FOREIGN KEY (SGL) REFERENCES statkue_svws_schulgliederungen(SGL) |
| Restabschnitte | int (11) | DEFAULT NULL |  |
| Folgejahrgang_ID | bigint (20) | DEFAULT NULL |  |



# floskeln

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| Kuerzel | varchar (10) | NOT NULL |  |
| FloskelText | longtext | NOT NULL |  |
| [FloskelGruppe](#floskelgruppen) | varchar (10) | DEFAULT NULL | FOREIGN KEY (FloskelGruppe) REFERENCES floskelgruppen(Kuerzel) |
| FloskelFach | varchar (20) | DEFAULT NULL |  |
| FloskelNiveau | varchar (2) | DEFAULT NULL |  |
| FloskelJahrgang | varchar (2) | DEFAULT NULL |  |



# gost_jahrgang_fachkombinationen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Abi_Jahrgang](#gost_jahrgangsdaten) | int (11) | NOT NULL | FOREIGN KEY (Abi_Jahrgang) REFERENCES gost_jahrgangsdaten(Abi_Jahrgang) |
| ID | varchar (30) | NOT NULL |  |
| [Fach1_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach1_ID) REFERENCES eigeneschule_faecher(ID) |
| [Fach2_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach2_ID) REFERENCES eigeneschule_faecher(ID) |
| Kursart1 | varchar (5) | DEFAULT NULL |  |
| Kursart2 | varchar (5) | DEFAULT NULL |  |
| Phase | varchar (10) | NOT NULL DEFAULT '-' |  |
| Typ | int (11) | NOT NULL DEFAULT 0 |  |



# gost_jahrgang_faecher

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Abi_Jahrgang](#gost_jahrgangsdaten) | int (11) | NOT NULL | FOREIGN KEY (Abi_Jahrgang) REFERENCES gost_jahrgangsdaten(Abi_Jahrgang) |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| WaehlbarEF1 | int (11) | NOT NULL DEFAULT 1 |  |
| WaehlbarEF2 | int (11) | NOT NULL DEFAULT 1 |  |
| WaehlbarQ11 | int (11) | NOT NULL DEFAULT 1 |  |
| WaehlbarQ12 | int (11) | NOT NULL DEFAULT 1 |  |
| WaehlbarQ21 | int (11) | NOT NULL DEFAULT 1 |  |
| WaehlbarQ22 | int (11) | NOT NULL DEFAULT 1 |  |
| WaehlbarAbiGK | int (11) | NOT NULL DEFAULT 1 |  |
| WaehlbarAbiLK | int (11) | NOT NULL DEFAULT 1 |  |
| WochenstundenEF1 | int (11) | DEFAULT NULL |  |
| WochenstundenEF2 | int (11) | DEFAULT NULL |  |
| WochenstundenQPhase | int (11) | DEFAULT NULL |  |
| SchiftlichkeitEF1 | varchar (1) | DEFAULT NULL |  |
| SchiftlichkeitEF2 | varchar (1) | DEFAULT NULL |  |
| NurMuendlich | int (11) | NOT NULL DEFAULT 0 |  |



# k_allgadresse

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| AllgAdrName1 | varchar (50) | DEFAULT NULL |  |
| AllgAdrName2 | varchar (50) | DEFAULT NULL |  |
| AllgAdrStrassenname | varchar (55) | DEFAULT NULL |  |
| AllgAdrHausNr | varchar (10) | DEFAULT NULL |  |
| AllgAdrHausNrZusatz | varchar (30) | DEFAULT NULL |  |
| [AllgAdrOrt_ID](#k_ort) | bigint (20) | DEFAULT NULL | FOREIGN KEY (AllgAdrOrt_ID) REFERENCES k_ort(ID) |
| AllgAdrPLZ | varchar (10) | DEFAULT NULL |  |
| AllgAdrTelefon1 | varchar (20) | DEFAULT NULL |  |
| AllgAdrTelefon2 | varchar (20) | DEFAULT NULL |  |
| AllgAdrFax | varchar (20) | DEFAULT NULL |  |
| AllgAdrEmail | varchar (100) | DEFAULT NULL |  |
| AllgAdrBemerkungen | varchar (255) | DEFAULT NULL |  |
| Sortierung | int (11) | DEFAULT 32000 |  |
| AllgAdrAusbildungsBetrieb | varchar (1) | DEFAULT '-' |  |
| AllgAdrBietetPraktika | varchar (1) | DEFAULT '-' |  |
| AllgAdrBranche | varchar (50) | DEFAULT NULL |  |
| AllgAdrZusatz1 | varchar (10) | DEFAULT NULL |  |
| AllgAdrZusatz2 | varchar (10) | DEFAULT NULL |  |
| Sichtbar | varchar (1) | DEFAULT '+' |  |
| Aenderbar | varchar (1) | DEFAULT '+' |  |
| Massnahmentraeger | varchar (1) | DEFAULT '-' |  |
| BelehrungISG | varchar (1) | DEFAULT '-' |  |
| GU_ID | varchar (40) | DEFAULT NULL |  |
| ErwFuehrungszeugnis | varchar (1) | DEFAULT '-' |  |
| ExtID | varchar (50) | DEFAULT NULL |  |
| [AdressArt_ID](#k_adressart) | bigint (20) | DEFAULT NULL | FOREIGN KEY (AdressArt_ID) REFERENCES k_adressart(ID) |



# k_ankreuzfloskeln

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| IstASV | int (11) | NOT NULL DEFAULT 0 |  |
| Jahrgang | varchar (2) | NOT NULL |  |
| Gliederung | varchar (3) | DEFAULT NULL |  |
| FloskelText | varchar (255) | NOT NULL |  |
| Sortierung | int (11) | DEFAULT NULL |  |
| FachSortierung | int (11) | DEFAULT NULL |  |
| Abschnitt | int (11) | DEFAULT NULL |  |
| Sichtbar | varchar (1) | DEFAULT '+' |  |
| Aktiv | varchar (1) | DEFAULT '+' |  |



# k_ortsteil

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| Bezeichnung | varchar (30) | NOT NULL |  |
| [Ort_ID](#k_ort) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Ort_ID) REFERENCES k_ort(ID) |
| PLZ | varchar (10) | DEFAULT NULL |  |
| Sortierung | int (11) | DEFAULT 32000 |  |
| Sichtbar | varchar (1) | DEFAULT '+' |  |
| Aenderbar | varchar (1) | DEFAULT '+' |  |
| OrtsteilSchluessel | varchar (30) | DEFAULT NULL |  |



# klassen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| Schuljahresabschnitts_ID | bigint (20) | NOT NULL |  |
| Bezeichnung | varchar (150) | DEFAULT NULL |  |
| ASDKlasse | varchar (6) | DEFAULT NULL |  |
| Klasse | varchar (15) | NOT NULL |  |
| [Jahrgang_ID](#eigeneschule_jahrgaenge) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Jahrgang_ID) REFERENCES eigeneschule_jahrgaenge(ID) |
| FKlasse | varchar (15) | DEFAULT NULL |  |
| VKlasse | varchar (15) | DEFAULT NULL |  |
| OrgFormKrz | varchar (1) | DEFAULT NULL |  |
| ASDSchulformNr | varchar (3) | DEFAULT NULL |  |
| [Fachklasse_ID](#eigeneschule_fachklassen) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Fachklasse_ID) REFERENCES eigeneschule_fachklassen(ID) |
| PruefOrdnung | varchar (20) | DEFAULT NULL |  |
| Sichtbar | varchar (1) | DEFAULT '+' |  |
| Sortierung | int (11) | DEFAULT 32000 |  |
| Klassenart | varchar (2) | DEFAULT NULL |  |
| SommerSem | varchar (1) | DEFAULT '-' |  |
| NotenGesperrt | varchar (1) | DEFAULT '-' |  |
| AdrMerkmal | varchar (1) | DEFAULT 'A' |  |
| KoopKlasse | varchar (1) | DEFAULT '-' |  |
| Ankreuzzeugnisse | varchar (1) | DEFAULT '-' |  |



# kompetenzen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| KO_ID | bigint (20) | NOT NULL |  |
| [KO_Gruppe](#kompetenzgruppen) | bigint (20) | NOT NULL | FOREIGN KEY (KO_Gruppe) REFERENCES kompetenzgruppen(KG_ID) |
| KO_Bezeichnung | varchar (64) | NOT NULL |  |



# kurse

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schuljahresabschnitts_ID](#schuljahresabschnitte) | bigint (20) | NOT NULL | FOREIGN KEY (Schuljahresabschnitts_ID) REFERENCES schuljahresabschnitte(ID) |
| KurzBez | varchar (20) | NOT NULL |  |
| [Jahrgang_ID](#eigeneschule_jahrgaenge) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Jahrgang_ID) REFERENCES eigeneschule_jahrgaenge(ID) |
| ASDJahrgang | varchar (2) | DEFAULT NULL |  |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| KursartAllg | varchar (5) | DEFAULT NULL |  |
| WochenStd | smallint (6) | DEFAULT NULL |  |
| Lehrer_ID | bigint (20) | DEFAULT NULL |  |
| Sortierung | int (11) | DEFAULT 32000 |  |
| Sichtbar | varchar (1) | DEFAULT '+' |  |
| Schienen | varchar (20) | DEFAULT NULL |  |
| Fortschreibungsart | varchar (1) | DEFAULT NULL |  |
| WochenstdKL | float | DEFAULT NULL |  |
| SchulNr | int (11) | DEFAULT NULL |  |
| EpochU | varchar (1) | DEFAULT '-' |  |
| ZeugnisBez | varchar (130) | DEFAULT NULL |  |
| Jahrgaenge | varchar (50) | DEFAULT NULL |  |



# logins

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [LI_UserID](#users) | bigint (20) | NOT NULL | FOREIGN KEY (LI_UserID) REFERENCES users(ID) |
| LI_LoginTime | datetime | NOT NULL |  |
| LI_LogoffTime | datetime | DEFAULT NULL |  |



# nichtmoeglabifachkombi

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Fach1_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach1_ID) REFERENCES eigeneschule_faecher(ID) |
| [Fach2_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach2_ID) REFERENCES eigeneschule_faecher(ID) |
| Kursart1 | varchar (5) | DEFAULT NULL |  |
| Kursart2 | varchar (5) | DEFAULT NULL |  |
| PK | varchar (30) | NOT NULL |  |
| Sortierung | int (11) | DEFAULT NULL |  |
| Phase | varchar (10) | DEFAULT NULL |  |
| Typ | varchar (1) | DEFAULT NULL |  |



# personengruppen_personen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Gruppe_ID](#personengruppen) | bigint (20) | NOT NULL | FOREIGN KEY (Gruppe_ID) REFERENCES personengruppen(ID) |
| Person_ID | bigint (20) | DEFAULT NULL |  |
| PersonNr | int (11) | DEFAULT NULL |  |
| PersonArt | varchar (1) | DEFAULT NULL |  |
| PersonName | varchar (120) | NOT NULL |  |
| PersonVorname | varchar (80) | DEFAULT NULL |  |
| PersonPLZ | varchar (10) | DEFAULT NULL |  |
| PersonOrt | varchar (50) | DEFAULT NULL |  |
| PersonStrassenname | varchar (55) | DEFAULT NULL |  |
| PersonHausNr | varchar (10) | DEFAULT NULL |  |
| PersonHausNrZusatz | varchar (30) | DEFAULT NULL |  |
| PersonTelefon | varchar (20) | DEFAULT NULL |  |
| PersonMobil | varchar (20) | DEFAULT NULL |  |
| PersonEmail | varchar (100) | DEFAULT NULL |  |
| Bemerkung | varchar (100) | DEFAULT NULL |  |
| Zusatzinfo | varchar (100) | DEFAULT NULL |  |
| Sortierung | int (11) | DEFAULT NULL |  |
| PersonAnrede | varchar (10) | DEFAULT NULL |  |
| PersonAkadGrad | varchar (15) | DEFAULT NULL |  |



# schild_verwaltung

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| BackupDatum | datetime | DEFAULT NULL |  |
| AutoBerechnung | datetime | DEFAULT NULL |  |
| DatumStatkue | datetime | DEFAULT NULL |  |
| DatumSchildIntern | datetime | DEFAULT NULL |  |
| Bescheinigung | varchar (255) | DEFAULT NULL |  |
| Stammblatt | varchar (255) | DEFAULT NULL |  |
| DatenGeprueft | varchar (1) | DEFAULT '-' |  |
| Version | varchar (10) | DEFAULT NULL |  |
| GU_ID | varchar (40) | NOT NULL |  |
| DatumLoeschfristHinweisDeaktiviert | datetime | DEFAULT NULL |  |
| [DatumLoeschfristHinweisDeaktiviertUserID](#users) | bigint (20) | DEFAULT NULL | FOREIGN KEY (DatumLoeschfristHinweisDeaktiviertUserID) REFERENCES users(ID) |
| DatumDatenGeloescht | datetime | DEFAULT NULL |  |



# schildintern_kaoa_merkmal

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL |  |
| GueltigAb | datetime | DEFAULT NULL |  |
| GueltigBis | datetime | DEFAULT NULL |  |
| M_Kuerzel | varchar (20) | NOT NULL |  |
| [Kategorie_ID](#schildintern_kaoa_kategorie) | bigint (20) | NOT NULL | FOREIGN KEY (Kategorie_ID) REFERENCES schildintern_kaoa_kategorie(ID) |
| M_Beschreibung | varchar (255) | DEFAULT NULL |  |
| M_Option | varchar (25) | DEFAULT NULL |  |
| M_Kategorie | varchar (10) | DEFAULT NULL |  |
| BK_Anlagen | varchar (255) | DEFAULT NULL |  |



# schildintern_kaoa_zusatzmerkmal

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL |  |
| GueltigAb | datetime | DEFAULT NULL |  |
| GueltigBis | datetime | DEFAULT NULL |  |
| ZM_Kuerzel | varchar (20) | NOT NULL |  |
| [Merkmal_ID](#schildintern_kaoa_merkmal) | bigint (20) | NOT NULL | FOREIGN KEY (Merkmal_ID) REFERENCES schildintern_kaoa_merkmal(ID) |
| ZM_Beschreibung | varchar (255) | DEFAULT NULL |  |
| ZM_Option | varchar (25) | DEFAULT NULL |  |
| ZM_Merkmal | varchar (20) | DEFAULT NULL |  |



# schueler

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schuljahresabschnitts_ID](#schuljahresabschnitte) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Schuljahresabschnitts_ID) REFERENCES schuljahresabschnitte(ID) |
| GU_ID | varchar (40) | NOT NULL |  |
| SrcID | int (11) | DEFAULT NULL |  |
| IDext | varchar (30) | DEFAULT NULL |  |
| Status | int (11) | DEFAULT NULL |  |
| Name | varchar (120) | DEFAULT NULL |  |
| Vorname | varchar (80) | DEFAULT NULL |  |
| Zusatz | varchar (255) | DEFAULT NULL |  |
| Geburtsname | varchar (120) | DEFAULT NULL |  |
| Strassenname | varchar (55) | DEFAULT NULL |  |
| HausNr | varchar (10) | DEFAULT NULL |  |
| HausNrZusatz | varchar (30) | DEFAULT NULL |  |
| [Ort_ID](#k_ort) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Ort_ID) REFERENCES k_ort(ID) |
| PLZ | varchar (10) | DEFAULT NULL |  |
| [Ortsteil_ID](#k_ortsteil) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Ortsteil_ID) REFERENCES k_ortsteil(ID) |
| Telefon | varchar (20) | DEFAULT NULL |  |
| Email | varchar (100) | DEFAULT NULL |  |
| Fax | varchar (20) | DEFAULT NULL |  |
| Geburtsdatum | date | DEFAULT NULL |  |
| Geburtsort | varchar (100) | DEFAULT NULL |  |
| Volljaehrig | varchar (1) | DEFAULT '-' |  |
| Geschlecht | smallint (6) | DEFAULT NULL |  |
| [StaatKrz](#statkue_nationalitaeten) | varchar (3) | DEFAULT NULL | FOREIGN KEY (StaatKrz) REFERENCES statkue_nationalitaeten(Schluessel) |
| [StaatKrz2](#statkue_nationalitaeten) | varchar (3) | DEFAULT NULL | FOREIGN KEY (StaatKrz2) REFERENCES statkue_nationalitaeten(Schluessel) |
| Aussiedler | varchar (1) | DEFAULT '-' |  |
| [Religion_ID](#k_religion) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Religion_ID) REFERENCES k_religion(ID) |
| Religionsabmeldung | date | DEFAULT NULL |  |
| Religionsanmeldung | date | DEFAULT NULL |  |
| Bafoeg | varchar (1) | DEFAULT '-' |  |
| [Sportbefreiung_ID](#k_sportbefreiung) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Sportbefreiung_ID) REFERENCES k_sportbefreiung(ID) |
| [Fahrschueler_ID](#k_fahrschuelerart) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Fahrschueler_ID) REFERENCES k_fahrschuelerart(ID) |
| [Haltestelle_ID](#k_haltestelle) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Haltestelle_ID) REFERENCES k_haltestelle(ID) |
| SchulpflichtErf | varchar (1) | DEFAULT '-' |  |
| Anschreibdatum | date | DEFAULT NULL |  |
| Aufnahmedatum | date | DEFAULT NULL |  |
| Einschulungsjahr | smallint (6) | DEFAULT NULL |  |
| [Einschulungsart_ID](#k_einschulungsart) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Einschulungsart_ID) REFERENCES k_einschulungsart(ID) |
| LSSchulNr | varchar (6) | DEFAULT NULL |  |
| LSSchulformSIM | varchar (3) | DEFAULT NULL |  |
| LSJahrgang | varchar (2) | DEFAULT NULL |  |
| LSSchulEntlassDatum | date | DEFAULT NULL |  |
| LSVersetzung | varchar (2) | DEFAULT NULL |  |
| LSFachklKennung | varchar (10) | DEFAULT NULL |  |
| LSFachklSIM | varchar (5) | DEFAULT NULL |  |
| LSEntlassgrund | varchar (50) | DEFAULT NULL |  |
| LSEntlassArt | varchar (2) | DEFAULT NULL |  |
| LSKlassenart | varchar (2) | DEFAULT NULL |  |
| LSRefPaed | varchar (1) | DEFAULT '-' |  |
| Entlassjahrgang | varchar (2) | DEFAULT NULL |  |
| [Entlassjahrgang_ID](#eigeneschule_jahrgaenge) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Entlassjahrgang_ID) REFERENCES eigeneschule_jahrgaenge(ID) |
| Entlassdatum | date | DEFAULT NULL |  |
| Entlassgrund | varchar (50) | DEFAULT NULL |  |
| Entlassart | varchar (2) | DEFAULT NULL |  |
| SchulwechselNr | varchar (6) | DEFAULT NULL |  |
| Schulwechseldatum | date | DEFAULT NULL |  |
| Geloescht | varchar (1) | DEFAULT '-' |  |
| Gesperrt | varchar (1) | DEFAULT '-' |  |
| ModifiziertAm | datetime | DEFAULT NULL |  |
| ModifiziertVon | varchar (20) | DEFAULT NULL |  |
| Markiert | varchar (21) | DEFAULT '-' |  |
| FotoVorhanden | varchar (1) | DEFAULT '-' |  |
| JVA | varchar (1) | DEFAULT '-' |  |
| KeineAuskunft | varchar (1) | DEFAULT '-' |  |
| Beruf | varchar (100) | DEFAULT NULL |  |
| AbschlussDatum | varchar (15) | DEFAULT NULL |  |
| Bemerkungen | longtext | DEFAULT NULL |  |
| BeginnBildungsgang | date | DEFAULT NULL |  |
| DurchschnittsNote | varchar (4) | DEFAULT NULL |  |
| LSSGL | varchar (5) | DEFAULT NULL |  |
| LSSchulform | varchar (2) | DEFAULT NULL |  |
| KonfDruck | varchar (1) | DEFAULT '+' |  |
| DSN_Text | varchar (15) | DEFAULT NULL |  |
| Berufsabschluss | varchar (1) | DEFAULT NULL |  |
| LSSGL_SIM | varchar (3) | DEFAULT NULL |  |
| BerufsschulpflErf | varchar (1) | DEFAULT '-' |  |
| StatusNSJ | int (11) | DEFAULT NULL |  |
| [FachklasseNSJ_ID](#eigeneschule_fachklassen) | bigint (20) | DEFAULT NULL | FOREIGN KEY (FachklasseNSJ_ID) REFERENCES eigeneschule_fachklassen(ID) |
| BuchKonto | float | DEFAULT NULL |  |
| VerkehrsspracheFamilie | varchar (2) | DEFAULT 'de' |  |
| JahrZuzug | int (11) | DEFAULT NULL |  |
| DauerKindergartenbesuch | varchar (1) | DEFAULT NULL |  |
| VerpflichtungSprachfoerderkurs | varchar (1) | DEFAULT '-' |  |
| TeilnahmeSprachfoerderkurs | varchar (1) | DEFAULT '-' |  |
| SchulbuchgeldBefreit | varchar (1) | DEFAULT '-' |  |
| GeburtslandSchueler | varchar (10) | DEFAULT NULL |  |
| GeburtslandVater | varchar (10) | DEFAULT NULL |  |
| GeburtslandMutter | varchar (10) | DEFAULT NULL |  |
| Uebergangsempfehlung_JG5 | varchar (10) | DEFAULT NULL |  |
| ErsteSchulform_SI | varchar (10) | DEFAULT NULL |  |
| JahrWechsel_SI | int (11) | DEFAULT NULL |  |
| JahrWechsel_SII | int (11) | DEFAULT NULL |  |
| Migrationshintergrund | varchar (1) | DEFAULT '-' |  |
| ExterneSchulNr | varchar (6) | DEFAULT NULL |  |
| [Kindergarten_ID](#k_kindergarten) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Kindergarten_ID) REFERENCES k_kindergarten(ID) |
| LetzterBerufsAbschluss | varchar (10) | DEFAULT NULL |  |
| LetzterAllgAbschluss | varchar (10) | DEFAULT NULL |  |
| Land | varchar (2) | DEFAULT NULL |  |
| AV_Leist | int (11) | DEFAULT NULL |  |
| AV_Zuv | int (11) | DEFAULT NULL |  |
| AV_Selbst | int (11) | DEFAULT NULL |  |
| SV_Verant | int (11) | DEFAULT NULL |  |
| SV_Konfl | int (11) | DEFAULT NULL |  |
| SV_Koop | int (11) | DEFAULT NULL |  |
| Duplikat | varchar (1) | DEFAULT '-' |  |
| EinschulungsartASD | varchar (2) | DEFAULT NULL |  |
| DurchschnittsnoteFHR | varchar (4) | DEFAULT NULL |  |
| DSN_FHR_Text | varchar (15) | DEFAULT NULL |  |
| Eigenanteil | float | DEFAULT NULL |  |
| ZustimmungFoto | varchar (1) | DEFAULT '-' |  |
| BKAZVO | int (11) | DEFAULT NULL |  |
| HatBerufsausbildung | varchar (1) | DEFAULT '-' |  |
| Ausweisnummer | varchar (30) | DEFAULT NULL |  |
| EPJahre | int (11) | DEFAULT 2 |  |
| LSBemerkung | varchar (255) | DEFAULT NULL |  |
| WechselBestaetigt | varchar (1) | DEFAULT '-' |  |
| DauerBildungsgang | int (11) | DEFAULT NULL |  |
| AnmeldeDatum | date | DEFAULT NULL |  |
| MeisterBafoeg | varchar (1) | DEFAULT '-' |  |
| OnlineAnmeldung | varchar (1) | DEFAULT '-' |  |
| Dokumentenverzeichnis | varchar (255) | DEFAULT NULL |  |
| Berufsqualifikation | varchar (100) | DEFAULT NULL |  |
| ZusatzNachname | varchar (30) | DEFAULT NULL |  |
| EndeEingliederung | date | DEFAULT NULL |  |
| SchulEmail | varchar (100) | DEFAULT NULL |  |
| EndeAnschlussfoerderung | date | DEFAULT NULL |  |
| MasernImpfnachweis | varchar (1) | DEFAULT '-' |  |
| Lernstandsbericht | varchar (1) | DEFAULT '-' |  |
| SprachfoerderungVon | date | DEFAULT NULL |  |
| SprachfoerderungBis | date | DEFAULT NULL |  |
| EntlassungBemerkung | varchar (255) | DEFAULT NULL |  |
| [CredentialID](#credentials) | bigint (20) | DEFAULT NULL | FOREIGN KEY (CredentialID) REFERENCES credentials(ID) |



# schuelerabgaenge

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| BemerkungIntern | varchar (30) | DEFAULT NULL |  |
| AbgangsSchulform | varchar (2) | DEFAULT NULL |  |
| AbgangsBeschreibung | varchar (200) | DEFAULT NULL |  |
| OrganisationsformKrz | varchar (1) | DEFAULT NULL |  |
| AbgangsSchule | varchar (100) | DEFAULT NULL |  |
| AbgangsSchuleAnschr | varchar (100) | DEFAULT NULL |  |
| AbgangsSchulNr | varchar (6) | DEFAULT NULL |  |
| LSJahrgang | varchar (2) | DEFAULT NULL |  |
| LSEntlassArt | varchar (2) | DEFAULT NULL |  |
| LSSchulformSIM | varchar (3) | DEFAULT NULL |  |
| LSSchulEntlassDatum | date | DEFAULT NULL |  |
| LSVersetzung | varchar (2) | DEFAULT NULL |  |
| LSSGL | varchar (5) | DEFAULT NULL |  |
| LSFachklKennung | varchar (10) | DEFAULT NULL |  |
| LSFachklSIM | varchar (5) | DEFAULT NULL |  |
| FuerSIMExport | varchar (1) | DEFAULT '-' |  |
| LSBeginnDatum | date | DEFAULT NULL |  |
| LSBeginnJahrgang | varchar (2) | DEFAULT NULL |  |



# schuelerabifaecher

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| FachKrz | varchar (20) | DEFAULT NULL |  |
| FSortierung | int (11) | DEFAULT NULL |  |
| [Kurs_ID](#kurse) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Kurs_ID) REFERENCES kurse(ID) |
| KursartAllg | varchar (5) | DEFAULT NULL |  |
| Fachlehrer_ID | bigint (20) | DEFAULT NULL |  |
| AbiFach | varchar (1) | DEFAULT NULL |  |
| P11_1 | varchar (2) | DEFAULT NULL |  |
| S11_1 | varchar (1) | DEFAULT '-' |  |
| P11_2 | varchar (2) | DEFAULT NULL |  |
| S11_2 | varchar (1) | DEFAULT '-' |  |
| P_FA | varchar (2) | DEFAULT NULL |  |
| R_FA | varchar (1) | DEFAULT '-' |  |
| W12_1 | int (11) | DEFAULT NULL |  |
| P12_1 | varchar (2) | DEFAULT NULL |  |
| H12_1 | int (11) | DEFAULT NULL |  |
| R12_1 | varchar (1) | DEFAULT '-' |  |
| S12_1 | varchar (1) | DEFAULT '-' |  |
| W12_2 | int (11) | DEFAULT NULL |  |
| P12_2 | varchar (2) | DEFAULT NULL |  |
| H12_2 | int (11) | DEFAULT NULL |  |
| R12_2 | varchar (1) | DEFAULT '-' |  |
| S12_2 | varchar (1) | DEFAULT '-' |  |
| W13_1 | int (11) | DEFAULT NULL |  |
| P13_1 | varchar (2) | DEFAULT NULL |  |
| H13_1 | int (11) | DEFAULT NULL |  |
| R13_1 | varchar (1) | DEFAULT '-' |  |
| S13_1 | varchar (1) | DEFAULT '-' |  |
| W13_2 | int (11) | DEFAULT NULL |  |
| P13_2 | varchar (2) | DEFAULT NULL |  |
| H13_2 | int (11) | DEFAULT NULL |  |
| R13_2 | varchar (1) | DEFAULT '-' |  |
| S13_2 | varchar (1) | DEFAULT '-' |  |
| Zulassung | smallint (6) | DEFAULT NULL |  |
| Durchschnitt | float | DEFAULT NULL |  |
| AbiPruefErgebnis | smallint (6) | DEFAULT NULL |  |
| Zwischenstand | smallint (6) | DEFAULT NULL |  |
| MdlPflichtPruefung | varchar (1) | DEFAULT '-' |  |
| MdlBestPruefung | varchar (1) | DEFAULT '-' |  |
| MdlFreiwPruefung | varchar (1) | DEFAULT '-' |  |
| MdlPruefErgebnis | smallint (6) | DEFAULT NULL |  |
| MdlPruefFolge | smallint (6) | DEFAULT NULL |  |
| AbiErgebnis | smallint (6) | DEFAULT NULL |  |



# schuelerabitur

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [Schuljahresabschnitts_ID](#schuljahresabschnitte) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Schuljahresabschnitts_ID) REFERENCES schuljahresabschnitte(ID) |
| FA_Fach | varchar (130) | DEFAULT NULL |  |
| FA_Punkte | int (11) | DEFAULT NULL |  |
| FehlStd | int (11) | DEFAULT NULL |  |
| uFehlStd | int (11) | DEFAULT NULL |  |
| FranzBilingual | varchar (1) | DEFAULT '-' |  |
| BesondereLernleistung | varchar (1) | DEFAULT '-' |  |
| AnzRelLK | smallint (6) | DEFAULT NULL |  |
| AnzRelGK | smallint (6) | DEFAULT NULL |  |
| AnzRelOK | smallint (6) | DEFAULT NULL |  |
| AnzDefLK | smallint (6) | DEFAULT NULL |  |
| AnzDefGK | smallint (6) | DEFAULT NULL |  |
| Thema_PJK | varchar (255) | DEFAULT NULL |  |
| FS2_SekI_Manuell | varchar (1) | DEFAULT '-' |  |
| Kurse_I | int (11) | DEFAULT NULL |  |
| Defizite_I | int (11) | DEFAULT NULL |  |
| LK_Defizite_I | int (11) | DEFAULT NULL |  |
| AnzahlKurse_0 | int (11) | DEFAULT NULL |  |
| Punktsumme_I | int (11) | DEFAULT NULL |  |
| Durchschnitt_I | float | DEFAULT NULL |  |
| SummeGK | smallint (6) | DEFAULT NULL |  |
| SummeLK | smallint (6) | DEFAULT NULL |  |
| SummenOK | smallint (6) | DEFAULT NULL |  |
| Zugelassen | varchar (1) | DEFAULT '-' |  |
| BLL_Art | varchar (1) | DEFAULT 'K' |  |
| BLL_Punkte | int (11) | DEFAULT NULL |  |
| Thema_BLL | varchar (255) | DEFAULT NULL |  |
| Punktsumme_II | int (11) | DEFAULT NULL |  |
| Defizite_II | int (11) | DEFAULT NULL |  |
| LK_Defizite_II | int (11) | DEFAULT NULL |  |
| PruefungBestanden | varchar (1) | DEFAULT '-' |  |
| Note | varchar (3) | DEFAULT NULL |  |
| GesamtPunktzahl | smallint (6) | DEFAULT NULL |  |
| Notensprung | smallint (6) | DEFAULT NULL |  |
| FehlendePunktzahl | smallint (6) | DEFAULT NULL |  |



# schuelerbkabschluss

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [Schuljahresabschnitts_ID](#schuljahresabschnitte) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Schuljahresabschnitts_ID) REFERENCES schuljahresabschnitte(ID) |
| Zulassung | char (1) | DEFAULT NULL |  |
| Bestanden | char (1) | DEFAULT NULL |  |
| ZertifikatBK | char (1) | DEFAULT NULL |  |
| ZulassungErwBK | char (1) | DEFAULT NULL |  |
| BestandenErwBK | char (1) | DEFAULT NULL |  |
| ZulassungBA | char (1) | DEFAULT NULL |  |
| BestandenBA | char (1) | DEFAULT NULL |  |
| PraktPrfNote | varchar (2) | DEFAULT NULL |  |
| NoteKolloquium | varchar (2) | DEFAULT NULL |  |
| ThemaAbschlussarbeit | longtext | DEFAULT NULL |  |
| BAP_Vorhanden | varchar (1) | DEFAULT NULL |  |
| NoteFachpraxis | varchar (2) | DEFAULT NULL |  |
| FachPraktAnteilAusr | varchar (1) | DEFAULT NULL |  |



# schuelerbkfaecher

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [Schuljahresabschnitts_ID](#schuljahresabschnitte) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Schuljahresabschnitts_ID) REFERENCES schuljahresabschnitte(ID) |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| FachKrz | varchar (20) | DEFAULT NULL |  |
| FachSchriftlich | char (1) | DEFAULT NULL |  |
| FachSchriftlichBA | char (1) | DEFAULT NULL |  |
| Vornote | varchar (2) | DEFAULT NULL |  |
| NoteSchriftlich | varchar (2) | DEFAULT NULL |  |
| MdlPruefung | char (1) | DEFAULT NULL |  |
| MdlPruefungFW | char (1) | DEFAULT NULL |  |
| NoteMuendlich | varchar (2) | DEFAULT NULL |  |
| NoteAbschluss | varchar (2) | DEFAULT NULL |  |
| NotePrfGesamt | varchar (2) | DEFAULT NULL |  |
| FSortierung | int (11) | DEFAULT NULL |  |
| Fachlehrer_ID | bigint (20) | DEFAULT NULL |  |
| NoteAbschlussBA | varchar (2) | DEFAULT NULL |  |
| Kursart | varchar (5) | DEFAULT NULL |  |



# schuelerdatenschutz

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [Datenschutz_ID](#k_datenschutz) | bigint (20) | NOT NULL | FOREIGN KEY (Datenschutz_ID) REFERENCES k_datenschutz(ID) |
| Status | varchar (1) | NOT NULL DEFAULT '-' |  |



# schuelererzadr

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [ErzieherArt_ID](#k_erzieherart) | bigint (20) | DEFAULT NULL | FOREIGN KEY (ErzieherArt_ID) REFERENCES k_erzieherart(ID) |
| Anrede1 | varchar (20) | DEFAULT NULL |  |
| Titel1 | varchar (10) | DEFAULT NULL |  |
| Name1 | varchar (120) | DEFAULT NULL |  |
| Vorname1 | varchar (80) | DEFAULT NULL |  |
| Anrede2 | varchar (20) | DEFAULT NULL |  |
| Titel2 | varchar (10) | DEFAULT NULL |  |
| Name2 | varchar (120) | DEFAULT NULL |  |
| Vorname2 | varchar (80) | DEFAULT NULL |  |
| [ErzOrt_ID](#k_ort) | bigint (20) | DEFAULT NULL | FOREIGN KEY (ErzOrt_ID) REFERENCES k_ort(ID) |
| ErzStrassenname | varchar (55) | DEFAULT NULL |  |
| ErzPLZ | varchar (10) | DEFAULT NULL |  |
| ErzHausNr | varchar (10) | DEFAULT NULL |  |
| [ErzOrtsteil_ID](#k_ortsteil) | bigint (20) | DEFAULT NULL | FOREIGN KEY (ErzOrtsteil_ID) REFERENCES k_ortsteil(ID) |
| ErzHausNrZusatz | varchar (30) | DEFAULT NULL |  |
| ErzAnschreiben | varchar (1) | DEFAULT '+' |  |
| Sortierung | int (11) | DEFAULT NULL |  |
| ErzEmail | varchar (100) | DEFAULT NULL |  |
| ErzAdrZusatz | varchar (50) | DEFAULT NULL |  |
| [Erz1StaatKrz](#statkue_nationalitaeten) | varchar (3) | DEFAULT NULL | FOREIGN KEY (Erz1StaatKrz) REFERENCES statkue_nationalitaeten(Schluessel) |
| [Erz2StaatKrz](#statkue_nationalitaeten) | varchar (3) | DEFAULT NULL | FOREIGN KEY (Erz2StaatKrz) REFERENCES statkue_nationalitaeten(Schluessel) |
| ErzEmail2 | varchar (100) | DEFAULT NULL |  |
| Erz1ZusatzNachname | varchar (30) | DEFAULT NULL |  |
| Erz2ZusatzNachname | varchar (30) | DEFAULT NULL |  |
| Bemerkungen | longtext | DEFAULT NULL |  |
| [CredentialID](#credentials) | bigint (20) | DEFAULT NULL | FOREIGN KEY (CredentialID) REFERENCES credentials(ID) |



# schuelerfhr

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| FHRErreicht | varchar (1) | DEFAULT '-' |  |
| Note | varchar (3) | DEFAULT NULL |  |
| GesamtPunktzahl | smallint (6) | DEFAULT NULL |  |
| SummeGK | smallint (6) | DEFAULT NULL |  |
| SummeLK | smallint (6) | DEFAULT NULL |  |
| SummenOK | smallint (6) | DEFAULT NULL |  |
| AnzRelLK | smallint (6) | DEFAULT NULL |  |
| AnzRelGK | smallint (6) | DEFAULT NULL |  |
| AnzRelOK | smallint (6) | DEFAULT NULL |  |
| AnzDefLK | smallint (6) | DEFAULT NULL |  |
| AnzDefGK | smallint (6) | DEFAULT NULL |  |
| AnzDefOK | smallint (6) | DEFAULT NULL |  |
| JSII_2_1 | smallint (6) | DEFAULT NULL |  |
| JSII_2_1_W | smallint (6) | DEFAULT NULL |  |
| JSII_2_2 | smallint (6) | DEFAULT NULL |  |
| JSII_2_2_W | smallint (6) | DEFAULT NULL |  |
| JSII_3_1 | smallint (6) | DEFAULT NULL |  |
| JSII_3_1_W | smallint (6) | DEFAULT NULL |  |
| JSII_3_2 | smallint (6) | DEFAULT NULL |  |
| JSII_3_2_W | smallint (6) | DEFAULT NULL |  |
| ASII_2_1 | smallint (6) | DEFAULT NULL |  |
| ASII_2_2 | smallint (6) | DEFAULT NULL |  |
| ASII_2_1_W | smallint (6) | DEFAULT NULL |  |
| ASII_2_2_W | smallint (6) | DEFAULT NULL |  |
| ASII_3_1 | smallint (6) | DEFAULT NULL |  |
| ASII_3_2 | smallint (6) | DEFAULT NULL |  |
| ASII_3_1_W | smallint (6) | DEFAULT NULL |  |
| ASII_3_2_W | smallint (6) | DEFAULT NULL |  |
| WSII_2_1 | varchar (1) | DEFAULT NULL |  |
| WSII_2_2 | varchar (1) | DEFAULT NULL |  |
| WSII_2_1_W | varchar (1) | DEFAULT NULL |  |
| WSII_2_2_W | varchar (1) | DEFAULT NULL |  |
| WSII_3_1 | varchar (1) | DEFAULT NULL |  |
| WSII_3_2 | varchar (1) | DEFAULT NULL |  |
| WSII_3_1_W | varchar (1) | DEFAULT NULL |  |
| WSII_3_2_W | varchar (1) | DEFAULT NULL |  |



# schuelerfhrfaecher

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| KursartAllg | varchar (5) | DEFAULT NULL |  |
| FachKrz | varchar (20) | DEFAULT NULL |  |
| PSII_2_1 | varchar (2) | DEFAULT NULL |  |
| HSII_2_1 | int (11) | DEFAULT NULL |  |
| RSII_2_1 | varchar (1) | DEFAULT '-' |  |
| PSII_2_2 | varchar (2) | DEFAULT NULL |  |
| HSII_2_2 | int (11) | DEFAULT NULL |  |
| RSII_2_2 | varchar (1) | DEFAULT '-' |  |
| PSII_2_1_W | varchar (2) | DEFAULT NULL |  |
| HSII_2_1_W | int (11) | DEFAULT NULL |  |
| RSII_2_1_W | varchar (1) | DEFAULT '-' |  |
| PSII_2_2_W | varchar (2) | DEFAULT NULL |  |
| HSII_2_2_W | int (11) | DEFAULT NULL |  |
| RSII_2_2_W | varchar (1) | DEFAULT '-' |  |
| PSII_3_1 | varchar (2) | DEFAULT NULL |  |
| HSII_3_1 | int (11) | DEFAULT NULL |  |
| RSII_3_1 | varchar (1) | DEFAULT '-' |  |
| PSII_3_2 | varchar (2) | DEFAULT NULL |  |
| HSII_3_2 | int (11) | DEFAULT NULL |  |
| RSII_3_2 | varchar (1) | DEFAULT '-' |  |
| PSII_3_1_W | varchar (2) | DEFAULT NULL |  |
| HSII_3_1_W | int (11) | DEFAULT NULL |  |
| RSII_3_1_W | varchar (1) | DEFAULT '-' |  |
| PSII_3_2_W | varchar (2) | DEFAULT NULL |  |
| HSII_3_2_W | int (11) | DEFAULT NULL |  |
| RSII_3_2_W | varchar (1) | DEFAULT '-' |  |
| KSII_2_1 | varchar (5) | DEFAULT NULL |  |
| KSII_2_2 | varchar (5) | DEFAULT NULL |  |
| KSII_2_1_W | varchar (5) | DEFAULT NULL |  |
| KSII_2_2_W | varchar (5) | DEFAULT NULL |  |
| KSII_3_1 | varchar (5) | DEFAULT NULL |  |
| KSII_3_2 | varchar (5) | DEFAULT NULL |  |
| KSII_3_1_W | varchar (5) | DEFAULT NULL |  |
| KSII_3_2_W | varchar (5) | DEFAULT NULL |  |
| FSortierung | int (11) | DEFAULT NULL |  |



# schuelerfotos

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| FotoBase64 | longtext | DEFAULT NULL |  |



# schuelergsdaten

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| Note_Sprachgebrauch | int (11) | DEFAULT NULL |  |
| Note_Lesen | int (11) | DEFAULT NULL |  |
| Note_Rechtschreiben | int (11) | DEFAULT NULL |  |
| Note_Sachunterricht | int (11) | DEFAULT NULL |  |
| Note_Mathematik | int (11) | DEFAULT NULL |  |
| Note_Englisch | int (11) | DEFAULT NULL |  |
| Note_KunstTextil | int (11) | DEFAULT NULL |  |
| Note_Musik | int (11) | DEFAULT NULL |  |
| Note_Sport | int (11) | DEFAULT NULL |  |
| Note_Religion | int (11) | DEFAULT NULL |  |
| Durchschnittsnote_Sprache | float | DEFAULT NULL |  |
| Durchschnittsnote_Einfach | float | DEFAULT NULL |  |
| Durchschnittsnote_Gewichtet | float | DEFAULT NULL |  |
| Anrede_Klassenlehrer | varchar (10) | DEFAULT NULL |  |
| Nachname_Klassenlehrer | varchar (120) | DEFAULT NULL |  |
| GS_Klasse | varchar (15) | DEFAULT NULL |  |
| Bemerkungen | longtext | DEFAULT NULL |  |
| Geschwisterkind | varchar (1) | DEFAULT '-' |  |



# schuelerlernplattform

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [SchuelerID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (SchuelerID) REFERENCES schueler(ID) |
| [LernplattformID](#lernplattformen) | bigint (20) | NOT NULL | FOREIGN KEY (LernplattformID) REFERENCES lernplattformen(ID) |
| [CredentialID](#credentialslernplattformen) | bigint (20) | DEFAULT NULL | FOREIGN KEY (CredentialID) REFERENCES credentialslernplattformen(ID) |
| EinwilligungAbgefragt | int (11) | NOT NULL DEFAULT 0 |  |
| EinwilligungNutzung | int (11) | NOT NULL DEFAULT 0 |  |
| EinwilligungAudiokonferenz | int (11) | NOT NULL DEFAULT 0 |  |
| EinwilligungVideokonferenz | int (11) | NOT NULL DEFAULT 0 |  |



# schuelerliste_inhalt

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Liste_ID](#schuelerliste) | bigint (20) | NOT NULL | FOREIGN KEY (Liste_ID) REFERENCES schuelerliste(ID) |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |



# schuelermerkmale

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| Kurztext | varchar (10) | DEFAULT NULL |  |
| DatumVon | date | DEFAULT NULL |  |
| DatumBis | date | DEFAULT NULL |  |



# schuelerreportvorlagen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [User_ID](#users) | bigint (20) | NOT NULL | FOREIGN KEY (User_ID) REFERENCES users(ID) |
| Reportvorlage | varchar (255) | NOT NULL |  |
| Schueler_IDs | longtext | DEFAULT NULL |  |



# schuelersprachenfolge

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| AbschnittVon | smallint (6) | DEFAULT NULL |  |
| AbschnittBis | smallint (6) | DEFAULT NULL |  |
| Referenzniveau | varchar (5) | DEFAULT NULL |  |
| Sprache | varchar (2) | NOT NULL |  |
| ReihenfolgeNr | int (11) | DEFAULT NULL |  |
| ASDJahrgangVon | varchar (2) | DEFAULT NULL |  |
| ASDJahrgangBis | varchar (2) | DEFAULT NULL |  |
| KleinesLatinumErreicht | int (11) | DEFAULT NULL |  |
| LatinumErreicht | int (11) | DEFAULT NULL |  |
| GraecumErreicht | int (11) | DEFAULT NULL |  |
| HebraicumErreicht | int (11) | DEFAULT NULL |  |



# schuelersprachpruefungen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| Sprache | varchar (2) | NOT NULL |  |
| ASDJahrgang | varchar (2) | DEFAULT NULL |  |
| Anspruchsniveau_ID | bigint (20) | DEFAULT NULL |  |
| Pruefungsdatum | date | DEFAULT NULL |  |
| ErsetzteSprache | varchar (2) | DEFAULT NULL |  |
| KannErstePflichtfremdspracheErsetzen | int (11) | DEFAULT NULL |  |
| KannZweitePflichtfremdspracheErsetzen | int (11) | DEFAULT NULL |  |
| KannWahlpflichtfremdspracheErsetzen | int (11) | DEFAULT NULL |  |
| Referenzniveau | varchar (5) | DEFAULT NULL |  |
| NotePruefung | int (11) | DEFAULT NULL |  |



# schuelertelefone

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [TelefonArt_ID](#k_telefonart) | bigint (20) | DEFAULT NULL | FOREIGN KEY (TelefonArt_ID) REFERENCES k_telefonart(ID) |
| Telefonnummer | varchar (20) | DEFAULT NULL |  |
| Bemerkung | varchar (50) | DEFAULT NULL |  |
| Sortierung | int (11) | DEFAULT 32000 |  |
| Gesperrt | varchar (1) | DEFAULT '-' |  |



# schuelervermerke

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [VermerkArt_ID](#k_vermerkart) | bigint (20) | DEFAULT NULL | FOREIGN KEY (VermerkArt_ID) REFERENCES k_vermerkart(ID) |
| Datum | date | DEFAULT NULL |  |
| Bemerkung | longtext | DEFAULT NULL |  |
| AngelegtVon | varchar (20) | DEFAULT NULL |  |
| GeaendertVon | varchar (20) | DEFAULT NULL |  |



# schuelerwiedervorlage

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| Bemerkung | varchar (255) | DEFAULT NULL |  |
| AngelegtAm | datetime | DEFAULT NULL |  |
| WiedervorlageAm | datetime | DEFAULT NULL |  |
| ErledigtAm | datetime | DEFAULT NULL |  |
| [User_ID](#users) | bigint (20) | DEFAULT NULL | FOREIGN KEY (User_ID) REFERENCES users(ID) |
| Sekretariat | varchar (1) | DEFAULT '+' |  |
| Typ | varchar (1) | DEFAULT NULL |  |
| NichtLoeschen | varchar (1) | DEFAULT '-' |  |



# schuelerzp10

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [Schuljahresabschnitts_ID](#schuljahresabschnitte) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Schuljahresabschnitts_ID) REFERENCES schuljahresabschnitte(ID) |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| Vornote | varchar (2) | DEFAULT NULL |  |
| NoteSchriftlich | varchar (2) | DEFAULT NULL |  |
| MdlPruefung | char (1) | DEFAULT NULL |  |
| MdlPruefungFW | char (1) | DEFAULT NULL |  |
| NoteMuendlich | varchar (2) | DEFAULT NULL |  |
| NoteAbschluss | varchar (2) | DEFAULT NULL |  |
| Fachlehrer_ID | bigint (20) | DEFAULT NULL |  |



# stundenplan

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schuljahresabschnitts_ID](#schuljahresabschnitte) | bigint (20) | NOT NULL | FOREIGN KEY (Schuljahresabschnitts_ID) REFERENCES schuljahresabschnitte(ID) |
| Beginn | date | NOT NULL DEFAULT '1899-01-01' |  |
| Ende | date | DEFAULT NULL |  |
| Beschreibung | varchar (1000) | NOT NULL |  |



# stundenplan_aufsichtsbereiche

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Stundenplan_ID](#stundenplan) | bigint (20) | NOT NULL | FOREIGN KEY (Stundenplan_ID) REFERENCES stundenplan(ID) |
| Kuerzel | varchar (20) | NOT NULL |  |
| Beschreibung | varchar (1000) | NOT NULL |  |



# stundenplan_pausenzeit

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Stundenplan_ID](#stundenplan) | bigint (20) | NOT NULL | FOREIGN KEY (Stundenplan_ID) REFERENCES stundenplan(ID) |
| Tag | int (11) | NOT NULL |  |
| Beginn | time | NOT NULL DEFAULT current_timestamp() |  |
| Ende | time | NOT NULL DEFAULT current_timestamp() |  |



# stundenplan_raeume

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Stundenplan_ID](#stundenplan) | bigint (20) | NOT NULL | FOREIGN KEY (Stundenplan_ID) REFERENCES stundenplan(ID) |
| Kuerzel | varchar (20) | NOT NULL |  |
| Beschreibung | varchar (1000) | NOT NULL |  |
| Groesse | int (11) | NOT NULL DEFAULT 40 |  |



# stundenplan_zeitraster

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Stundenplan_ID](#stundenplan) | bigint (20) | NOT NULL | FOREIGN KEY (Stundenplan_ID) REFERENCES stundenplan(ID) |
| Tag | int (11) | NOT NULL |  |
| Stunde | int (11) | NOT NULL |  |
| Beginn | time | NOT NULL DEFAULT current_timestamp() |  |
| Ende | time | NOT NULL DEFAULT current_timestamp() |  |



# stundentafel_faecher

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Stundentafel_ID](#stundentafel) | bigint (20) | NOT NULL | FOREIGN KEY (Stundentafel_ID) REFERENCES stundentafel(ID) |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| KursartAllg | varchar (5) | DEFAULT NULL |  |
| WochenStd | smallint (6) | DEFAULT NULL |  |
| Lehrer_ID | bigint (20) | DEFAULT NULL |  |
| EpochenUnterricht | varchar (1) | DEFAULT '-' |  |
| Sortierung | int (11) | DEFAULT 32000 |  |
| Sichtbar | varchar (1) | DEFAULT '+' |  |
| Gewichtung | int (11) | DEFAULT 1 |  |



# svws_client_konfiguration_benutzer

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Benutzer_ID](#users) | bigint (20) | NOT NULL | FOREIGN KEY (Benutzer_ID) REFERENCES users(ID) |
| AppName | varchar (100) | NOT NULL |  |
| Schluessel | varchar (255) | NOT NULL |  |
| Wert | longtext | NOT NULL |  |



# zuordnungreportvorlagen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Jahrgang_ID](#eigeneschule_jahrgaenge) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Jahrgang_ID) REFERENCES eigeneschule_jahrgaenge(ID) |
| Abschluss | varchar (50) | DEFAULT NULL |  |
| AbschlussBB | varchar (50) | DEFAULT NULL |  |
| AbschlussArt | int (11) | DEFAULT NULL |  |
| VersetzungKrz | varchar (2) | DEFAULT NULL |  |
| [Fachklasse_ID](#eigeneschule_fachklassen) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Fachklasse_ID) REFERENCES eigeneschule_fachklassen(ID) |
| Reportvorlage | varchar (255) | DEFAULT NULL |  |
| Beschreibung | varchar (255) | DEFAULT NULL |  |
| Gruppe | varchar (50) | DEFAULT NULL |  |
| Zeugnisart | varchar (5) | DEFAULT NULL |  |



# allgadransprechpartner

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Adresse_ID](#k_allgadresse) | bigint (20) | NOT NULL | FOREIGN KEY (Adresse_ID) REFERENCES k_allgadresse(ID) |
| Name | varchar (120) | DEFAULT NULL |  |
| Vorname | varchar (80) | DEFAULT NULL |  |
| Anrede | varchar (10) | DEFAULT NULL |  |
| Telefon | varchar (20) | DEFAULT NULL |  |
| Email | varchar (100) | DEFAULT NULL |  |
| Abteilung | varchar (50) | DEFAULT NULL |  |
| Titel | varchar (15) | DEFAULT NULL |  |
| GU_ID | varchar (40) | DEFAULT NULL |  |



# benutzergruppenkompetenzen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Gruppe_ID](#benutzergruppen) | bigint (20) | NOT NULL | FOREIGN KEY (Gruppe_ID) REFERENCES benutzergruppen(ID) |
| [Kompetenz_ID](#kompetenzen) | bigint (20) | NOT NULL | FOREIGN KEY (Kompetenz_ID) REFERENCES kompetenzen(KO_ID) |



# erzieherdatenschutz

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [ErzieherID](#schuelererzadr) | bigint (20) | NOT NULL | FOREIGN KEY (ErzieherID) REFERENCES schuelererzadr(ID) |
| [DatenschutzID](#k_datenschutz) | bigint (20) | NOT NULL | FOREIGN KEY (DatenschutzID) REFERENCES k_datenschutz(ID) |
| Status | int (11) | NOT NULL DEFAULT 0 |  |



# erzieherlernplattform

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [ErzieherID](#schuelererzadr) | bigint (20) | NOT NULL | FOREIGN KEY (ErzieherID) REFERENCES schuelererzadr(ID) |
| [LernplattformID](#lernplattformen) | bigint (20) | NOT NULL | FOREIGN KEY (LernplattformID) REFERENCES lernplattformen(ID) |
| [CredentialID](#credentialslernplattformen) | bigint (20) | DEFAULT NULL | FOREIGN KEY (CredentialID) REFERENCES credentialslernplattformen(ID) |
| EinwilligungAbgefragt | int (11) | NOT NULL DEFAULT 0 |  |
| EinwilligungNutzung | int (11) | NOT NULL DEFAULT 0 |  |
| EinwilligungAudiokonferenz | int (11) | NOT NULL DEFAULT 0 |  |
| EinwilligungVideokonferenz | int (11) | NOT NULL DEFAULT 0 |  |



# gost_schueler

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| DatumBeratung | datetime | DEFAULT NULL |  |
| DatumRuecklauf | datetime | DEFAULT NULL |  |
| HatSprachPraktischePruefung | int (11) | NOT NULL DEFAULT 0 |  |
| HatSportattest | int (11) | NOT NULL DEFAULT 0 |  |
| Kommentar | longtext | DEFAULT NULL |  |
| Beratungslehrer_ID | bigint (20) | DEFAULT NULL |  |
| PruefPhase | varchar (1) | DEFAULT NULL |  |
| BesondereLernleistung_Art | varchar (1) | DEFAULT NULL |  |
| BesondereLernleistung_Punkte | int (11) | DEFAULT NULL |  |
| ZweiteFremdpracheInSekIVorhanden | int (11) | NOT NULL DEFAULT 0 |  |



# gost_schueler_fachwahlen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| EF1_Kursart | varchar (5) | DEFAULT NULL |  |
| EF1_Punkte | varchar (2) | DEFAULT NULL |  |
| EF2_Kursart | varchar (5) | DEFAULT NULL |  |
| EF2_Punkte | varchar (2) | DEFAULT NULL |  |
| Q11_Kursart | varchar (5) | DEFAULT NULL |  |
| Q11_Punkte | varchar (2) | DEFAULT NULL |  |
| Q12_Kursart | varchar (5) | DEFAULT NULL |  |
| Q12_Punkte | varchar (2) | DEFAULT NULL |  |
| Q21_Kursart | varchar (5) | DEFAULT NULL |  |
| Q21_Punkte | varchar (2) | DEFAULT NULL |  |
| Q22_Kursart | varchar (5) | DEFAULT NULL |  |
| Q22_Punkte | varchar (2) | DEFAULT NULL |  |
| AbiturFach | int (11) | DEFAULT NULL |  |
| Bemerkungen | varchar (50) | DEFAULT NULL |  |
| Markiert_Q1 | int (11) | DEFAULT NULL |  |
| Markiert_Q2 | int (11) | DEFAULT NULL |  |
| Markiert_Q3 | int (11) | DEFAULT NULL |  |
| Markiert_Q4 | int (11) | DEFAULT NULL |  |
| ergebnisAbiturpruefung | int (11) | DEFAULT NULL |  |
| hatMuendlichePflichtpruefung | int (11) | DEFAULT NULL |  |
| ergebnisMuendlichePruefung | int (11) | DEFAULT NULL |  |



# k_lehrer

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| GU_ID | varchar (40) | DEFAULT NULL |  |
| Kuerzel | varchar (10) | NOT NULL |  |
| LIDKrz | varchar (4) | DEFAULT NULL |  |
| Nachname | varchar (120) | NOT NULL |  |
| Vorname | varchar (80) | DEFAULT NULL |  |
| PersonTyp | varchar (20) | DEFAULT 'LEHRKRAFT' |  |
| Sortierung | int (11) | DEFAULT 32000 |  |
| Sichtbar | varchar (1) | DEFAULT '+' |  |
| Aenderbar | varchar (1) | DEFAULT '+' |  |
| FuerExport | varchar (1) | DEFAULT '+' |  |
| Statistik | varchar (1) | DEFAULT '+' |  |
| Strassenname | varchar (55) | DEFAULT NULL |  |
| HausNr | varchar (10) | DEFAULT NULL |  |
| HausNrZusatz | varchar (30) | DEFAULT NULL |  |
| [Ort_ID](#k_ort) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Ort_ID) REFERENCES k_ort(ID) |
| PLZ | varchar (10) | DEFAULT NULL |  |
| [Ortsteil_ID](#k_ortsteil) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Ortsteil_ID) REFERENCES k_ortsteil(ID) |
| Tel | varchar (20) | DEFAULT NULL |  |
| Handy | varchar (20) | DEFAULT NULL |  |
| Email | varchar (100) | DEFAULT NULL |  |
| EmailDienstlich | varchar (100) | DEFAULT NULL |  |
| [StaatKrz](#statkue_nationalitaeten) | varchar (3) | DEFAULT NULL | FOREIGN KEY (StaatKrz) REFERENCES statkue_nationalitaeten(Schluessel) |
| Geburtsdatum | date | DEFAULT NULL |  |
| Geschlecht | varchar (1) | DEFAULT NULL |  |
| Anrede | varchar (10) | DEFAULT NULL |  |
| Amtsbezeichnung | varchar (15) | DEFAULT NULL |  |
| Titel | varchar (20) | DEFAULT NULL |  |
| Faecher | varchar (100) | DEFAULT NULL |  |
| IdentNr1 | varchar (10) | DEFAULT NULL |  |
| SerNr | varchar (5) | DEFAULT NULL |  |
| PANr | varchar (20) | DEFAULT NULL |  |
| LBVNr | varchar (15) | DEFAULT NULL |  |
| VSchluessel | varchar (1) | DEFAULT NULL |  |
| DatumZugang | date | DEFAULT NULL |  |
| GrundZugang | varchar (10) | DEFAULT NULL |  |
| DatumAbgang | date | DEFAULT NULL |  |
| GrundAbgang | varchar (10) | DEFAULT NULL |  |
| PflichtstdSoll | float | DEFAULT NULL |  |
| Rechtsverhaeltnis | varchar (1) | DEFAULT NULL |  |
| Beschaeftigungsart | varchar (2) | DEFAULT NULL |  |
| Einsatzstatus | varchar (1) | DEFAULT NULL |  |
| StammschulNr | varchar (6) | DEFAULT NULL |  |
| MasernImpfnachweis | varchar (1) | DEFAULT '-' |  |
| UnterrichtsStd | float | DEFAULT NULL |  |
| MehrleistungStd | float | DEFAULT NULL |  |
| EntlastungStd | float | DEFAULT NULL |  |
| AnrechnungStd | float | DEFAULT NULL |  |
| RestStd | float | DEFAULT NULL |  |
| LPassword | varchar (255) | DEFAULT NULL |  |
| PWAktuell | varchar (3) | DEFAULT '-;5' |  |
| SchILDweb_FL | varchar (1) | DEFAULT '+' |  |
| SchILDweb_KL | varchar (1) | DEFAULT '+' |  |
| SchILDweb_Config | longtext | DEFAULT NULL |  |
| KennwortTools | varchar (255) | DEFAULT NULL |  |
| Antwort1 | varchar (255) | DEFAULT NULL |  |
| Antwort2 | varchar (255) | DEFAULT NULL |  |
| KennwortToolsAktuell | varchar (3) | DEFAULT '-;5' |  |
| XNMPassword | varchar (255) | DEFAULT NULL |  |
| XNMPassword2 | varchar (255) | DEFAULT NULL |  |
| [CredentialID](#credentials) | bigint (20) | DEFAULT NULL | FOREIGN KEY (CredentialID) REFERENCES credentials(ID) |



# klassenlehrer

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Klassen_ID](#klassen) | bigint (20) | NOT NULL | FOREIGN KEY (Klassen_ID) REFERENCES klassen(ID) |
| [Lehrer_ID](#k_lehrer) | bigint (20) | NOT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |
| Reihenfolge | int (11) | NOT NULL DEFAULT 1 |  |



# kurs_schueler

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Kurs_ID](#kurse) | bigint (20) | NOT NULL | FOREIGN KEY (Kurs_ID) REFERENCES kurse(ID) |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |



# kurslehrer

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Kurs_ID](#kurse) | bigint (20) | NOT NULL | FOREIGN KEY (Kurs_ID) REFERENCES kurse(ID) |
| [Lehrer_ID](#k_lehrer) | bigint (20) | NOT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |
| Anteil | float | DEFAULT NULL |  |



# lehrerabschnittsdaten

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Lehrer_ID](#k_lehrer) | bigint (20) | NOT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |
| [Schuljahresabschnitts_ID](#schuljahresabschnitte) | bigint (20) | NOT NULL | FOREIGN KEY (Schuljahresabschnitts_ID) REFERENCES schuljahresabschnitte(ID) |
| Rechtsverhaeltnis | varchar (1) | DEFAULT NULL |  |
| Beschaeftigungsart | varchar (2) | DEFAULT NULL |  |
| Einsatzstatus | varchar (1) | DEFAULT NULL |  |
| PflichtstdSoll | float | DEFAULT NULL |  |
| UnterrichtsStd | float | DEFAULT NULL |  |
| MehrleistungStd | float | DEFAULT NULL |  |
| EntlastungStd | float | DEFAULT NULL |  |
| AnrechnungStd | float | DEFAULT NULL |  |
| RestStd | float | DEFAULT NULL |  |



# lehreranrechnung

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Abschnitt_ID](#lehrerabschnittsdaten) | bigint (20) | NOT NULL | FOREIGN KEY (Abschnitt_ID) REFERENCES lehrerabschnittsdaten(ID) |
| AnrechnungsgrundKrz | varchar (10) | DEFAULT NULL |  |
| AnrechnungStd | float | DEFAULT NULL |  |



# lehrerdatenschutz

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [LehrerID](#k_lehrer) | bigint (20) | NOT NULL | FOREIGN KEY (LehrerID) REFERENCES k_lehrer(ID) |
| [DatenschutzID](#k_datenschutz) | bigint (20) | NOT NULL | FOREIGN KEY (DatenschutzID) REFERENCES k_datenschutz(ID) |
| Status | int (11) | NOT NULL DEFAULT 0 |  |



# lehrerentlastung

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Abschnitt_ID](#lehrerabschnittsdaten) | bigint (20) | NOT NULL | FOREIGN KEY (Abschnitt_ID) REFERENCES lehrerabschnittsdaten(ID) |
| EntlastungsgrundKrz | varchar (10) | DEFAULT NULL |  |
| EntlastungStd | float | DEFAULT NULL |  |



# lehrerfotos

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Lehrer_ID](#k_lehrer) | bigint (20) | NOT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |
| FotoBase64 | longtext | DEFAULT NULL |  |



# lehrerfunktionen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Abschnitt_ID](#lehrerabschnittsdaten) | bigint (20) | NOT NULL | FOREIGN KEY (Abschnitt_ID) REFERENCES lehrerabschnittsdaten(ID) |
| [Funktion_ID](#k_schulfunktionen) | bigint (20) | NOT NULL | FOREIGN KEY (Funktion_ID) REFERENCES k_schulfunktionen(ID) |



# lehrerlehramt

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Lehrer_ID](#k_lehrer) | bigint (20) | NOT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |
| LehramtKrz | varchar (10) | NOT NULL |  |
| LehramtAnerkennungKrz | varchar (10) | DEFAULT NULL |  |



# lehrerlehramtfachr

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Lehrer_ID](#k_lehrer) | bigint (20) | NOT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |
| FachrKrz | varchar (10) | NOT NULL |  |
| FachrAnerkennungKrz | varchar (10) | DEFAULT NULL |  |



# lehrerlehramtlehrbef

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Lehrer_ID](#k_lehrer) | bigint (20) | NOT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |
| LehrbefKrz | varchar (10) | NOT NULL |  |
| LehrbefAnerkennungKrz | varchar (10) | DEFAULT NULL |  |



# lehrerlernplattform

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [LehrerID](#k_lehrer) | bigint (20) | NOT NULL | FOREIGN KEY (LehrerID) REFERENCES k_lehrer(ID) |
| [LernplattformID](#lernplattformen) | bigint (20) | NOT NULL | FOREIGN KEY (LernplattformID) REFERENCES lernplattformen(ID) |
| [CredentialID](#credentialslernplattformen) | bigint (20) | DEFAULT NULL | FOREIGN KEY (CredentialID) REFERENCES credentialslernplattformen(ID) |
| EinwilligungAbgefragt | int (11) | NOT NULL DEFAULT 0 |  |
| EinwilligungNutzung | int (11) | NOT NULL DEFAULT 0 |  |
| EinwilligungAudiokonferenz | int (11) | NOT NULL DEFAULT 0 |  |
| EinwilligungVideokonferenz | int (11) | NOT NULL DEFAULT 0 |  |



# lehrermehrleistung

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Abschnitt_ID](#lehrerabschnittsdaten) | bigint (20) | NOT NULL | FOREIGN KEY (Abschnitt_ID) REFERENCES lehrerabschnittsdaten(ID) |
| MehrleistungsgrundKrz | varchar (10) | NOT NULL |  |
| MehrleistungStd | float | DEFAULT NULL |  |



# schildintern_kaoa_sbo_ebene4

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL |  |
| GueltigAb | datetime | DEFAULT NULL |  |
| GueltigBis | datetime | DEFAULT NULL |  |
| Kuerzel_EB4 | varchar (20) | NOT NULL |  |
| Beschreibung_EB4 | varchar (255) | DEFAULT NULL |  |
| Zusatzmerkmal | varchar (20) | DEFAULT NULL |  |
| [Zusatzmerkmal_ID](#schildintern_kaoa_zusatzmerkmal) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Zusatzmerkmal_ID) REFERENCES schildintern_kaoa_zusatzmerkmal(ID) |



# schueler_allgadr

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [Adresse_ID](#k_allgadresse) | bigint (20) | NOT NULL | FOREIGN KEY (Adresse_ID) REFERENCES k_allgadresse(ID) |
| [Vertragsart_ID](#k_beschaeftigungsart) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Vertragsart_ID) REFERENCES k_beschaeftigungsart(ID) |
| Vertragsbeginn | date | DEFAULT NULL |  |
| Vertragsende | date | DEFAULT NULL |  |
| Ausbilder | varchar (30) | DEFAULT NULL |  |
| AllgAdrAnschreiben | varchar (1) | DEFAULT '-' |  |
| Praktikum | varchar (1) | DEFAULT '-' |  |
| Sortierung | int (11) | DEFAULT NULL |  |
| [Ansprechpartner_ID](#allgadransprechpartner) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Ansprechpartner_ID) REFERENCES allgadransprechpartner(ID) |
| Betreuungslehrer_ID | bigint (20) | DEFAULT NULL |  |



# schuelerlernabschnittsdaten

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Schueler_ID](#schueler) | bigint (20) | NOT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [Schuljahresabschnitts_ID](#schuljahresabschnitte) | bigint (20) | NOT NULL | FOREIGN KEY (Schuljahresabschnitts_ID) REFERENCES schuljahresabschnitte(ID) |
| WechselNr | smallint (6) | DEFAULT NULL |  |
| Schulbesuchsjahre | smallint (6) | DEFAULT NULL |  |
| Hochrechnung | int (11) | DEFAULT NULL |  |
| SemesterWertung | varchar (1) | DEFAULT '+' |  |
| PruefOrdnung | varchar (20) | DEFAULT NULL |  |
| [Klassen_ID](#klassen) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Klassen_ID) REFERENCES klassen(ID) |
| Verspaetet | smallint (6) | DEFAULT NULL |  |
| [NPV_Fach_ID](#eigeneschule_faecher) | bigint (20) | DEFAULT NULL | FOREIGN KEY (NPV_Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| NPV_NoteKrz | varchar (2) | DEFAULT NULL |  |
| NPV_Datum | date | DEFAULT NULL |  |
| [NPAA_Fach_ID](#eigeneschule_faecher) | bigint (20) | DEFAULT NULL | FOREIGN KEY (NPAA_Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| NPAA_NoteKrz | varchar (2) | DEFAULT NULL |  |
| NPAA_Datum | date | DEFAULT NULL |  |
| [NPBQ_Fach_ID](#eigeneschule_faecher) | bigint (20) | DEFAULT NULL | FOREIGN KEY (NPBQ_Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| NPBQ_NoteKrz | varchar (2) | DEFAULT NULL |  |
| NPBQ_Datum | date | DEFAULT NULL |  |
| VersetzungKrz | varchar (2) | DEFAULT NULL |  |
| AbschlussArt | smallint (6) | DEFAULT NULL |  |
| AbschlIstPrognose | varchar (1) | DEFAULT '-' |  |
| Konferenzdatum | date | DEFAULT NULL |  |
| ZeugnisDatum | date | DEFAULT NULL |  |
| ASDSchulgliederung | varchar (3) | DEFAULT NULL |  |
| ASDJahrgang | varchar (2) | DEFAULT NULL |  |
| [Jahrgang_ID](#eigeneschule_jahrgaenge) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Jahrgang_ID) REFERENCES eigeneschule_jahrgaenge(ID) |
| [Fachklasse_ID](#eigeneschule_fachklassen) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Fachklasse_ID) REFERENCES eigeneschule_fachklassen(ID) |
| [Schwerpunkt_ID](#k_schwerpunkt) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Schwerpunkt_ID) REFERENCES k_schwerpunkt(ID) |
| ZeugnisBem | longtext | DEFAULT NULL |  |
| Schwerbehinderung | varchar (1) | DEFAULT '-' |  |
| [Foerderschwerpunkt_ID](#k_foerderschwerpunkt) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Foerderschwerpunkt_ID) REFERENCES k_foerderschwerpunkt(ID) |
| OrgFormKrz | varchar (1) | DEFAULT NULL |  |
| RefPaed | varchar (1) | DEFAULT '-' |  |
| Klassenart | varchar (2) | DEFAULT NULL |  |
| SumFehlStd | int (11) | DEFAULT NULL |  |
| SumFehlStdU | int (11) | DEFAULT NULL |  |
| Wiederholung | varchar (1) | DEFAULT '-' |  |
| Gesamtnote_GS | int (11) | DEFAULT NULL |  |
| Gesamtnote_NW | int (11) | DEFAULT NULL |  |
| [Folgeklasse_ID](#klassen) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Folgeklasse_ID) REFERENCES klassen(ID) |
| [Foerderschwerpunkt2_ID](#k_foerderschwerpunkt) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Foerderschwerpunkt2_ID) REFERENCES k_foerderschwerpunkt(ID) |
| Abschluss | varchar (50) | DEFAULT NULL |  |
| Abschluss_B | varchar (50) | DEFAULT NULL |  |
| DSNote | varchar (4) | DEFAULT NULL |  |
| AV_Leist | int (11) | DEFAULT NULL |  |
| AV_Zuv | int (11) | DEFAULT NULL |  |
| AV_Selbst | int (11) | DEFAULT NULL |  |
| SV_Verant | int (11) | DEFAULT NULL |  |
| SV_Konfl | int (11) | DEFAULT NULL |  |
| SV_Koop | int (11) | DEFAULT NULL |  |
| KN_Lehrer | varchar (10) | DEFAULT NULL |  |
| MoeglNPFaecher | longtext | DEFAULT NULL |  |
| Zertifikate | varchar (30) | DEFAULT NULL |  |
| DatumFHR | date | DEFAULT NULL |  |
| PruefAlgoErgebnis | longtext | DEFAULT NULL |  |
| Zeugnisart | varchar (5) | DEFAULT NULL |  |
| DatumVon | date | DEFAULT NULL |  |
| DatumBis | date | DEFAULT NULL |  |
| FehlstundenGrenzwert | int (11) | DEFAULT NULL |  |
| [Sonderpaedagoge_ID](#k_lehrer) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Sonderpaedagoge_ID) REFERENCES k_lehrer(ID) |
| FachPraktAnteilAusr | varchar (1) | NOT NULL DEFAULT '+' |  |
| BilingualerZweig | varchar (1) | DEFAULT NULL |  |
| AOSF | varchar (1) | DEFAULT '-' |  |
| Autist | varchar (1) | DEFAULT '-' |  |
| ZieldifferentesLernen | varchar (1) | DEFAULT '-' |  |



# schuelerzuweisungen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Abschnitt_ID](#schuelerlernabschnittsdaten) | bigint (20) | NOT NULL | FOREIGN KEY (Abschnitt_ID) REFERENCES schuelerlernabschnittsdaten(ID) |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| Kursart | varchar (5) | DEFAULT NULL |  |



# schulleitung

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [LeitungsfunktionID](#schulleitungfunktion) | bigint (20) | NOT NULL | FOREIGN KEY (LeitungsfunktionID) REFERENCES schulleitungfunktion(ID) |
| Funktionstext | varchar (255) | NOT NULL |  |
| [LehrerID](#k_lehrer) | bigint (20) | NOT NULL | FOREIGN KEY (LehrerID) REFERENCES k_lehrer(ID) |
| Von | datetime | DEFAULT NULL |  |
| Bis | datetime | DEFAULT NULL |  |



# stundenplan_pausenaufsichten

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Pausenzeit_ID](#stundenplan_pausenzeit) | bigint (20) | NOT NULL | FOREIGN KEY (Pausenzeit_ID) REFERENCES stundenplan_pausenzeit(ID) |
| Wochentyp | int (11) | NOT NULL DEFAULT 0 |  |
| [Lehrer_ID](#k_lehrer) | bigint (20) | NOT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |



# stundenplan_pausenaufsichtenbereich

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Pausenaufsicht_ID](#stundenplan_pausenaufsichten) | bigint (20) | NOT NULL | FOREIGN KEY (Pausenaufsicht_ID) REFERENCES stundenplan_pausenaufsichten(ID) |
| [Aufsichtsbereich_ID](#stundenplan_aufsichtsbereiche) | bigint (20) | NOT NULL | FOREIGN KEY (Aufsichtsbereich_ID) REFERENCES stundenplan_aufsichtsbereiche(ID) |



# stundenplan_unterricht

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Zeitraster_ID](#stundenplan_zeitraster) | bigint (20) | NOT NULL | FOREIGN KEY (Zeitraster_ID) REFERENCES stundenplan_zeitraster(ID) |
| Wochentyp | int (11) | NOT NULL DEFAULT 0 |  |
| [Klasse_ID](#klassen) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Klasse_ID) REFERENCES klassen(ID) |
| [Kurs_ID](#kurse) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Kurs_ID) REFERENCES kurse(ID) |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |



# stundenplan_unterrichtlehrer

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Unterricht_ID](#stundenplan_unterricht) | bigint (20) | NOT NULL | FOREIGN KEY (Unterricht_ID) REFERENCES stundenplan_unterricht(ID) |
| [Lehrer_ID](#k_lehrer) | bigint (20) | NOT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |



# stundenplan_unterrichtraum

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Unterricht_ID](#stundenplan_unterricht) | bigint (20) | NOT NULL | FOREIGN KEY (Unterricht_ID) REFERENCES stundenplan_unterricht(ID) |
| [Raum_ID](#stundenplan_raeume) | bigint (20) | NOT NULL | FOREIGN KEY (Raum_ID) REFERENCES stundenplan_raeume(ID) |



# benutzer

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL |  |
| Typ | smallint (6) | NOT NULL DEFAULT 0 |  |
| [Allgemein_ID](#benutzerallgemein) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Allgemein_ID) REFERENCES benutzerallgemein(ID) |
| [Lehrer_ID](#k_lehrer) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |
| [Schueler_ID](#schueler) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Schueler_ID) REFERENCES schueler(ID) |
| [Erzieher_ID](#schuelererzadr) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Erzieher_ID) REFERENCES schuelererzadr(ID) |
| IstAdmin | int (11) | NOT NULL DEFAULT 0 |  |



# benutzeremail

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Benutzer_ID](#benutzer) | bigint (20) | NOT NULL | FOREIGN KEY (Benutzer_ID) REFERENCES benutzer(ID) |
| Email | varchar (255) | NOT NULL |  |
| EmailName | varchar (255) | NOT NULL |  |
| SMTPUsername | varchar (255) | DEFAULT NULL |  |
| SMTPPassword | varchar (255) | DEFAULT NULL |  |
| EMailSignature | varchar (2047) | DEFAULT NULL |  |
| HeartbeatDate | bigint (20) | DEFAULT NULL |  |
| ComputerName | varchar (255) | DEFAULT NULL |  |



# benutzergruppenmitglieder

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Gruppe_ID](#benutzergruppen) | bigint (20) | NOT NULL | FOREIGN KEY (Gruppe_ID) REFERENCES benutzergruppen(ID) |
| [Benutzer_ID](#benutzer) | bigint (20) | NOT NULL | FOREIGN KEY (Benutzer_ID) REFERENCES benutzer(ID) |



# benutzerkompetenzen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Benutzer_ID](#benutzer) | bigint (20) | NOT NULL | FOREIGN KEY (Benutzer_ID) REFERENCES benutzer(ID) |
| [Kompetenz_ID](#kompetenzen) | bigint (20) | NOT NULL | FOREIGN KEY (Kompetenz_ID) REFERENCES kompetenzen(KO_ID) |



# eigeneschule_abteilungen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| Bezeichnung | varchar (50) | NOT NULL |  |
| [Schuljahresabschnitts_ID](#schuljahresabschnitte) | bigint (20) | NOT NULL DEFAULT -1 | FOREIGN KEY (Schuljahresabschnitts_ID) REFERENCES schuljahresabschnitte(ID) |
| [AbteilungsLeiter_ID](#k_lehrer) | bigint (20) | DEFAULT NULL | FOREIGN KEY (AbteilungsLeiter_ID) REFERENCES k_lehrer(ID) |
| Sichtbar | varchar (1) | DEFAULT '+' |  |
| Raum | varchar (20) | DEFAULT NULL |  |
| Email | varchar (100) | DEFAULT NULL |  |
| Durchwahl | varchar (20) | DEFAULT NULL |  |
| Sortierung | int (11) | DEFAULT NULL |  |



# gost_jahrgang_beratungslehrer

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| [Abi_Jahrgang](#gost_jahrgangsdaten) | int (11) | NOT NULL | FOREIGN KEY (Abi_Jahrgang) REFERENCES gost_jahrgangsdaten(Abi_Jahrgang) |
| [Lehrer_ID](#k_lehrer) | bigint (20) | NOT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |



# schuelerankreuzfloskeln

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Abschnitt_ID](#schuelerlernabschnittsdaten) | bigint (20) | NOT NULL | FOREIGN KEY (Abschnitt_ID) REFERENCES schuelerlernabschnittsdaten(ID) |
| [Floskel_ID](#k_ankreuzfloskeln) | bigint (20) | NOT NULL | FOREIGN KEY (Floskel_ID) REFERENCES k_ankreuzfloskeln(ID) |
| Stufe1 | varchar (1) | DEFAULT '-' |  |
| Stufe2 | varchar (1) | DEFAULT '-' |  |
| Stufe3 | varchar (1) | DEFAULT '-' |  |
| Stufe4 | varchar (1) | DEFAULT '-' |  |
| Stufe5 | varchar (1) | DEFAULT '-' |  |



# schuelerfehlstunden

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Abschnitt_ID](#schuelerlernabschnittsdaten) | bigint (20) | NOT NULL | FOREIGN KEY (Abschnitt_ID) REFERENCES schuelerlernabschnittsdaten(ID) |
| Datum | date | NOT NULL DEFAULT current_timestamp() |  |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| FehlStd | float | NOT NULL |  |
| VonStd | int (11) | DEFAULT NULL |  |
| BisStd | int (11) | DEFAULT NULL |  |
| Entschuldigt | varchar (1) | DEFAULT '-' |  |
| [Lehrer_ID](#k_lehrer) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |



# schuelerkaoadaten

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Abschnitt_ID](#schuelerlernabschnittsdaten) | bigint (20) | NOT NULL | FOREIGN KEY (Abschnitt_ID) REFERENCES schuelerlernabschnittsdaten(ID) |
| Jahrgang | varchar (2) | DEFAULT NULL |  |
| [KategorieID](#schildintern_kaoa_kategorie) | bigint (20) | NOT NULL | FOREIGN KEY (KategorieID) REFERENCES schildintern_kaoa_kategorie(ID) |
| [MerkmalID](#schildintern_kaoa_merkmal) | bigint (20) | DEFAULT NULL | FOREIGN KEY (MerkmalID) REFERENCES schildintern_kaoa_merkmal(ID) |
| [ZusatzmerkmalID](#schildintern_kaoa_zusatzmerkmal) | bigint (20) | DEFAULT NULL | FOREIGN KEY (ZusatzmerkmalID) REFERENCES schildintern_kaoa_zusatzmerkmal(ID) |
| [AnschlussoptionID](#schildintern_kaoa_anschlussoption) | bigint (20) | DEFAULT NULL | FOREIGN KEY (AnschlussoptionID) REFERENCES schildintern_kaoa_anschlussoption(ID) |
| [BerufsfeldID](#schildintern_kaoa_berufsfeld) | bigint (20) | DEFAULT NULL | FOREIGN KEY (BerufsfeldID) REFERENCES schildintern_kaoa_berufsfeld(ID) |
| [SBO_Ebene4ID](#schildintern_kaoa_sbo_ebene4) | bigint (20) | DEFAULT NULL | FOREIGN KEY (SBO_Ebene4ID) REFERENCES schildintern_kaoa_sbo_ebene4(ID) |
| Bemerkung | varchar (255) | DEFAULT NULL |  |



# schuelerld_psfachbem

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Abschnitt_ID](#schuelerlernabschnittsdaten) | bigint (20) | NOT NULL | FOREIGN KEY (Abschnitt_ID) REFERENCES schuelerlernabschnittsdaten(ID) |
| ASV | longtext | DEFAULT NULL |  |
| LELS | longtext | DEFAULT NULL |  |
| AUE | longtext | DEFAULT NULL |  |
| ESF | longtext | DEFAULT NULL |  |
| BemerkungFSP | longtext | DEFAULT NULL |  |
| BemerkungVersetzung | longtext | DEFAULT NULL |  |



# schuelerleistungsdaten

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Abschnitt_ID](#schuelerlernabschnittsdaten) | bigint (20) | NOT NULL | FOREIGN KEY (Abschnitt_ID) REFERENCES schuelerlernabschnittsdaten(ID) |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | NOT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| Hochrechnung | int (11) | DEFAULT NULL |  |
| [Fachlehrer_ID](#k_lehrer) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Fachlehrer_ID) REFERENCES k_lehrer(ID) |
| Kursart | varchar (5) | DEFAULT NULL |  |
| KursartAllg | varchar (5) | DEFAULT NULL |  |
| [Kurs_ID](#kurse) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Kurs_ID) REFERENCES kurse(ID) |
| NotenKrz | varchar (2) | DEFAULT NULL |  |
| Warnung | varchar (1) | DEFAULT '-' |  |
| Warndatum | date | DEFAULT NULL |  |
| AbiFach | varchar (1) | DEFAULT NULL |  |
| Wochenstunden | smallint (6) | DEFAULT NULL |  |
| AbiZeugnis | varchar (1) | DEFAULT '-' |  |
| Prognose | varchar (1) | DEFAULT NULL |  |
| FehlStd | smallint (6) | DEFAULT NULL |  |
| uFehlStd | smallint (6) | DEFAULT NULL |  |
| Sortierung | int (11) | DEFAULT 32000 |  |
| Lernentw | longtext | DEFAULT NULL |  |
| Gekoppelt | varchar (1) | DEFAULT '-' |  |
| VorherAbgeschl | varchar (1) | DEFAULT '-' |  |
| AbschlussJahrgang | varchar (2) | DEFAULT NULL |  |
| HochrechnungStatus | varchar (1) | DEFAULT NULL |  |
| SchulNr | int (11) | DEFAULT NULL |  |
| [Zusatzkraft_ID](#k_lehrer) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Zusatzkraft_ID) REFERENCES k_lehrer(ID) |
| WochenstdZusatzkraft | int (11) | DEFAULT NULL |  |
| Prf10Fach | varchar (1) | DEFAULT '-' |  |
| AufZeugnis | varchar (1) | DEFAULT '+' |  |
| Gewichtung | int (11) | DEFAULT 1 |  |
| NoteAbschlussBA | varchar (2) | DEFAULT NULL |  |
| Umfang | varchar (1) | DEFAULT NULL |  |



# eigeneschule_abt_kl

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| [Abteilung_ID](#eigeneschule_abteilungen) | bigint (20) | NOT NULL | FOREIGN KEY (Abteilung_ID) REFERENCES eigeneschule_abteilungen(ID) |
| Sichtbar | varchar (1) | DEFAULT '+' |  |
| [Klassen_ID](#klassen) | bigint (20) | NOT NULL | FOREIGN KEY (Klassen_ID) REFERENCES klassen(ID) |



# schuelereinzelleistungen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |  |
| Datum | date | DEFAULT NULL |  |
| [Lehrer_ID](#k_lehrer) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |
| [Art_ID](#k_einzelleistungen) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Art_ID) REFERENCES k_einzelleistungen(ID) |
| Bemerkung | varchar (100) | DEFAULT NULL |  |
| [Leistung_ID](#schuelerleistungsdaten) | bigint (20) | NOT NULL | FOREIGN KEY (Leistung_ID) REFERENCES schuelerleistungsdaten(ID) |
| NotenKrz | varchar (2) | DEFAULT NULL |  |



# schuelerfoerderempfehlungen

| Name | Type | Spec | Kommentar |
|---|---|---|---|
| GU_ID | varchar (40) | NOT NULL |  |
| [Abschnitt_ID](#schuelerlernabschnittsdaten) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Abschnitt_ID) REFERENCES schuelerlernabschnittsdaten(ID) |
| DatumAngelegt | date | NOT NULL DEFAULT current_timestamp() |  |
| [Klassen_ID](#klassen) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Klassen_ID) REFERENCES klassen(ID) |
| [Fach_ID](#eigeneschule_faecher) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Fach_ID) REFERENCES eigeneschule_faecher(ID) |
| [Lehrer_ID](#k_lehrer) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Lehrer_ID) REFERENCES k_lehrer(ID) |
| DatumAenderungSchild | datetime | DEFAULT NULL |  |
| DatumAenderungSchildWeb | datetime | DEFAULT NULL |  |
| Kurs | varchar (20) | DEFAULT NULL |  |
| Inhaltl_Prozessbez_Komp | longtext | DEFAULT NULL |  |
| Methodische_Komp | longtext | DEFAULT NULL |  |
| Lern_Arbeitsverhalten | longtext | DEFAULT NULL |  |
| Massn_Inhaltl_Prozessbez_Komp | longtext | DEFAULT NULL |  |
| Massn_Methodische_Komp | longtext | DEFAULT NULL |  |
| Massn_Lern_Arbeitsverhalten | longtext | DEFAULT NULL |  |
| Verantwortlichkeit_Eltern | longtext | DEFAULT NULL |  |
| Verantwortlichkeit_Schueler | longtext | DEFAULT NULL |  |
| Zeitrahmen_von_Datum | date | DEFAULT NULL |  |
| Zeitrahmen_bis_Datum | date | DEFAULT NULL |  |
| Ueberpruefung_Datum | date | DEFAULT NULL |  |
| Naechstes_Beratungsgespraech | date | DEFAULT NULL |  |
| [Leistung_ID](#schuelerleistungsdaten) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Leistung_ID) REFERENCES schuelerleistungsdaten(ID) |
| [Kurs_ID](#kurse) | bigint (20) | DEFAULT NULL | FOREIGN KEY (Kurs_ID) REFERENCES kurse(ID) |
| EingabeFertig | varchar (1) | DEFAULT '-' |  |
| Faecher | varchar (255) | DEFAULT NULL |  |
| Abgeschlossen | varchar (1) | DEFAULT '-' |  |

