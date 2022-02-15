
# benutzergruppen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| IstAdmin | int (11) | NOT NULL DEFAULT 0 |



# credentials

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Benutzername | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| BenutzernamePseudonym | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Initialkennwort | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| PasswordHash | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| RSAPublicKey | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| RSAPrivateKey | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| AES | longtext | COLLATE utf8mb4_bin DEFAULT NULL |



# eigeneschule_fachklassen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| BKIndex | smallint (6) | DEFAULT NULL |
| FKS | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| AP | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bezeichnung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Kennung | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| FKS_AP_SIM | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| BKIndexTyp | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| Beschreibung_W | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Status | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Lernfelder | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| DQR_Niveau | int (11) | DEFAULT NULL |
| Ebene1Klartext | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ebene2Klartext | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ebene3Klartext | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |



# eigeneschule_faecher

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| FachKrz | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bezeichnung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| ZeugnisBez | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| UeZeugnisBez | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| StatistikKrz | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| BasisFach | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| IstSprache | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Sortierung | int (11) | DEFAULT 32000 |
| SortierungS2 | int (11) | DEFAULT 32000 |
| NachprErlaubt | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Gewichtung | smallint (6) | DEFAULT 1 |
| Unterichtssprache | varchar (1) | COLLATE utf8mb4_bin DEFAULT 'D' |
| IstSchriftlich | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| IstSchriftlichBA | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| AufZeugnis | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Lernfelder | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| LK_Moegl | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Abi_Moegl | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| E1 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| E2 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Q1 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Q2 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Q3 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Q4 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| AlsNeueFSInSII | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Leitfach_ID | bigint (20) | DEFAULT NULL |
| Leitfach2_ID | bigint (20) | DEFAULT NULL |
| E1_WZE | int (11) | DEFAULT NULL |
| E2_WZE | int (11) | DEFAULT NULL |
| Q_WZE | int (11) | DEFAULT NULL |
| E1_S | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| E2_S | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| NurMuendlich | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Aufgabenfeld | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbgeschlFaecherHolen | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| GewichtungFHR | int (11) | DEFAULT NULL |
| MaxBemZeichen | int (11) | DEFAULT NULL |



# eigeneschule_kaoadaten

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Curriculum | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '+' |
| Koordinator | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '+' |
| Berufsorientierungsbuero | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '+' |
| KooperationsvereinbarungAA | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '+' |
| NutzungReflexionsworkshop | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '+' |
| NutzungEntscheidungskompetenzI | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '+' |
| NutzungEntscheidungskompetenzII | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '+' |



# eigeneschule_kursart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (120) | COLLATE utf8mb4_bin DEFAULT NULL |
| InternBez | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Kursart | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| KursartAllg | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# eigeneschule_merkmale

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schule | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Schueler | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Langtext | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |



# eigeneschule_schulformen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| SGL | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| SF_SGL | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Schulform | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| DoppelQualifikation | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| BKIndex | int (11) | DEFAULT NULL |
| Schulform2 | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |



# eigeneschule_teilstandorte

| Name | Type | Spec |
|---|---|---|
| AdrMerkmal | varchar (1) | COLLATE utf8mb4_bin NOT NULL |
| PLZ | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ort | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Strassenname | varchar (55) | COLLATE utf8mb4_bin DEFAULT NULL |
| HausNr | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| HausNrZusatz | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bemerkung | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Kuerzel | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |



# eigeneschule_texte

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kuerzel | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Inhalt | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Beschreibung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# eigeneschule_zertifikate

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Kuerzel | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| Bezeichnung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Fach | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Formatvorlage | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |



# fach_gliederungen

| Name | Type | Spec |
|---|---|---|
| Fach_ID | bigint (20) | NOT NULL |
| Gliederung | varchar (3) | COLLATE utf8mb4_bin NOT NULL |
| Faechergruppe | int (11) | DEFAULT NULL |
| GewichtungAB | int (11) | DEFAULT NULL |
| GewichtungBB | int (11) | DEFAULT NULL |
| SchriftlichAB | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| SchriftlichBB | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| GymOSFach | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| ZeugnisBez | varchar (130) | COLLATE utf8mb4_bin DEFAULT NULL |
| Lernfelder | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Fachklasse_ID | bigint (20) | NOT NULL DEFAULT 0 |
| Sortierung | int (11) | DEFAULT 32000 |



# floskelgruppen

| Name | Type | Spec |
|---|---|---|
| Kuerzel | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Hauptgruppe | varchar (4) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| Farbe | int (11) | DEFAULT NULL |



# gost_jahrgangsdaten

| Name | Type | Spec |
|---|---|---|
| Abi_Jahrgang | int (11) | NOT NULL |
| ZusatzkursGEVorhanden | int (11) | DEFAULT 1 |
| ZusatzkursGEErstesHalbjahr | varchar (4) | COLLATE utf8mb4_bin DEFAULT 'Q2.1' |
| ZusatzkursSWVorhanden | int (11) | DEFAULT 1 |
| ZusatzkursSWErstesHalbjahr | varchar (4) | COLLATE utf8mb4_bin DEFAULT 'Q2.1' |
| TextBeratungsbogen | varchar (2000) | COLLATE utf8mb4_bin DEFAULT NULL |
| TextMailversand | varchar (2000) | COLLATE utf8mb4_bin DEFAULT NULL |



# impexp_eigeneimporte

| Name | Type | Spec |
|---|---|---|
| ID | int (11) | NOT NULL DEFAULT 0 |
| Title | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DelimiterChar | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| TextQuote | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| SkipLines | smallint (6) | DEFAULT 0 |
| DateFormat | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| BooleanTrue | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbkWeiblich | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbkMaennlich | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| MainTable | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| InsertMode | int (11) | DEFAULT NULL |
| LookupTableDir | varchar (250) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchuelerIDMode | varchar (4) | COLLATE utf8mb4_bin DEFAULT NULL |



# impexp_eigeneimporte_felder

| Name | Type | Spec |
|---|---|---|
| Import_ID | int (11) | NOT NULL DEFAULT 0 |
| Field_ID | int (11) | NOT NULL DEFAULT 0 |
| TableDescription | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| FieldDescription | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| SrcPosition | smallint (6) | DEFAULT 0 |
| DstTable | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstFieldName | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstFieldType | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstFieldIsIdentifier | int (11) | DEFAULT NULL |
| DstLookupDir | varchar (250) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstLookupTable | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstLookupFieldName | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstLookupTableIDFieldName | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstResultFieldName | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstKeyLookupInsert | int (11) | DEFAULT NULL |
| DstKeyLookupNameCreateID | int (11) | DEFAULT NULL |
| DstForceNumeric | int (11) | DEFAULT NULL |



# impexp_eigeneimporte_tabellen

| Name | Type | Spec |
|---|---|---|
| Import_ID | int (11) | NOT NULL DEFAULT 0 |
| TableName | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| DstCreateID | int (11) | DEFAULT NULL |
| DstIDFieldName | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sequence | int (11) | DEFAULT 0 |
| LookupTable | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupFields | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupFieldTypes | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupFieldPos | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupKeyField | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupResultField | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupResultFieldType | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstDefaultFieldName | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstDefaultFieldValue | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| GU_ID_Field | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |



# k_adressart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# k_ankreuzdaten

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| TextStufe1 | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| TextStufe2 | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| TextStufe3 | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| TextStufe4 | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| TextStufe5 | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| BezeichnungSONST | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |



# k_beschaeftigungsart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# k_datenschutz

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (250) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '+' |
| Schluessel | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | NOT NULL DEFAULT 32000 |
| Beschreibung | longtext | COLLATE utf8mb4_bin DEFAULT NULL |



# k_einschulungsart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (40) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# k_einzelleistungen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Gewichtung | float | DEFAULT NULL |



# k_entlassgrund

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# k_erzieherart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| ExportBez | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |



# k_erzieherfunktion

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# k_fahrschuelerart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# k_foerderschwerpunkt

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| StatistikKrz | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# k_haltestelle

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| EntfernungSchule | float | DEFAULT NULL |



# k_kindergarten

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| PLZ | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ort | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| Strassenname | varchar (55) | COLLATE utf8mb4_bin DEFAULT NULL |
| HausNr | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| HausNrZusatz | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| Tel | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Email | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bemerkung | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Sortierung | int (11) | DEFAULT NULL |



# k_ort

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| PLZ | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| Kreis | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Land | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |



# k_religion

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| StatistikKrz | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| ExportBez | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| ZeugnisBezeichnung | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |



# k_schule

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| SchulNr | varchar (6) | COLLATE utf8mb4_bin NOT NULL |
| Name | varchar (120) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchulformNr | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchulformKrz | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchulformBez | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Strassenname | varchar (55) | COLLATE utf8mb4_bin DEFAULT NULL |
| HausNr | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| HausNrZusatz | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| PLZ | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ort | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Telefon | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Fax | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Email | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| Schulleiter | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| SchulNr_SIM | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| Kuerzel | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| KurzBez | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |



# k_schulfunktionen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT NULL |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# k_schwerpunkt

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# k_sportbefreiung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# k_telefonart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# k_textdateien

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (32) | COLLATE utf8mb4_bin DEFAULT NULL |
| Text_ID | bigint (20) | NOT NULL |
| Text_Body | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Sortierung | smallint (6) | DEFAULT NULL |



# k_vermerkart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# k_zertifikate

| Name | Type | Spec |
|---|---|---|
| Kuerzel | varchar (5) | COLLATE utf8mb4_bin NOT NULL |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin NOT NULL |



# katalog_aufsichtsbereich

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Kuerzel | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (1000) | COLLATE utf8mb4_bin NOT NULL |



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
| Kuerzel | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (1000) | COLLATE utf8mb4_bin NOT NULL |
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
| KG_Bezeichnung | varchar (50) | COLLATE utf8mb4_bin NOT NULL |



# lernplattformen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| BenutzernameSuffixLehrer | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| BenutzernameSuffixErzieher | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| BenutzernameSuffixSchueler | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Konfiguration | longtext | COLLATE utf8mb4_bin DEFAULT NULL |



# personengruppen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Gruppenname | varchar (100) | COLLATE utf8mb4_bin NOT NULL |
| Zusatzinfo | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| SammelEmail | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| GruppenArt | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| XMLExport | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# schildfilter

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Art | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Name | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Tabellen | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| ZusatzTabellen | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bedingung | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| BedingungKlartext | longtext | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_abiturinfos

| Name | Type | Spec |
|---|---|---|
| PrfOrdnung | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| AbiFach | varchar (1) | COLLATE utf8mb4_bin NOT NULL |
| Bedingung | varchar (3) | COLLATE utf8mb4_bin NOT NULL |
| AbiInfoKrz | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| AbiInfoBeschreibung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbiInfoText | longtext | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_berufsebene

| Name | Type | Spec |
|---|---|---|
| Berufsebene | int (11) | NOT NULL |
| Kuerzel | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Klartext | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_datenart

| Name | Type | Spec |
|---|---|---|
| DatenartKrz | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Datenart | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Tabellenname | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| Reihenfolge | int (11) | DEFAULT NULL |



# schildintern_dqr_niveaus

| Name | Type | Spec |
|---|---|---|
| Gliederung | varchar (4) | COLLATE utf8mb4_bin NOT NULL |
| FKS | varchar (8) | COLLATE utf8mb4_bin NOT NULL |
| DQR_Niveau | int (11) | NOT NULL |



# schildintern_fachgruppen

| Name | Type | Spec |
|---|---|---|
| FG_ID | bigint (20) | NOT NULL |
| FG_SF | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| FG_Bezeichnung | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| FG_Farbe | int (11) | DEFAULT NULL |
| FG_Sortierung | int (11) | DEFAULT NULL |
| FG_Kuerzel | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| FG_Zeugnis | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_faechersortierung

| Name | Type | Spec |
|---|---|---|
| Fach | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Bezeichnung | varchar (80) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung1 | int (11) | DEFAULT NULL |
| Sortierung2 | int (11) | DEFAULT NULL |
| Fachgruppe_ID | bigint (20) | DEFAULT NULL |
| FachgruppeKrz | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| AufgabenbereichAbitur | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_filterfehlendeeintraege

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Beschreibung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Feldname | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| Tabellen | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| SQLText | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Schulform | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Feldtyp | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_filterfeldliste

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DBFeld | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Typ | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Werte | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| StdWert | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Operator | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Zusatzbedingung | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_hschstatus

| Name | Type | Spec |
|---|---|---|
| StatusNr | int (11) | NOT NULL |
| Bezeichnung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT NULL |
| InSimExp | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| SIMAbschnitt | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_k_schulnote

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Krz | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Art | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bezeichnung | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| Zeugnisnotenbez | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| Punkte | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT NULL |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# schildintern_kaoa_anschlussoption

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| GueltigAb | datetime | DEFAULT NULL |
| GueltigBis | datetime | DEFAULT NULL |
| AO_Kuerzel | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| AO_Beschreibung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| AO_Stufen | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Zusatzmerkmal_Anzeige | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_kaoa_berufsfeld

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| GueltigAb | datetime | DEFAULT NULL |
| GueltigBis | datetime | DEFAULT NULL |
| BF_Kuerzel | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| BF_Beschreibung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_kaoa_kategorie

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| GueltigAb | datetime | DEFAULT NULL |
| GueltigBis | datetime | DEFAULT NULL |
| K_Kuerzel | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| K_Beschreibung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| K_Jahrgaenge | varchar (25) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_laender

| Name | Type | Spec |
|---|---|---|
| Kurztext | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT NULL |



# schildintern_prfsemabschl

| Name | Type | Spec |
|---|---|---|
| Nr | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Klartext | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| StatistikKrz | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT NULL |
| Schulform | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| StatistikKrzNeu | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_prueford_optionen

| Name | Type | Spec |
|---|---|---|
| OP_Schulformen | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| OP_POKrz | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| OP_Krz | varchar (40) | COLLATE utf8mb4_bin NOT NULL |
| OP_Abgangsart_B | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| OP_Abgangsart_NB | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| OP_Art | varchar (1) | COLLATE utf8mb4_bin NOT NULL |
| OP_Typ | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| OP_Bildungsgang | varchar (1) | COLLATE utf8mb4_bin NOT NULL |
| OP_Name | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| OP_Kommentar | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| OP_Jahrgaenge | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| OP_BKIndex | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| OP_BKAnl_Typ | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| OP_Reihenfolge | int (11) | NOT NULL |



# schildintern_pruefungsordnung

| Name | Type | Spec |
|---|---|---|
| PO_Schulform | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| PO_Krz | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| PO_Name | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| PO_SGL | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| PO_MinJahrgang | int (11) | NOT NULL DEFAULT 0 |
| PO_MaxJahrgang | int (11) | NOT NULL DEFAULT 20 |
| PO_Jahrgaenge | varchar (30) | COLLATE utf8mb4_bin NOT NULL |



# schildintern_schuelerimpexp

| Name | Type | Spec |
|---|---|---|
| Tabelle | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| TabellenAnzeige | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| MasterTable | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| ExpCmd | varchar (250) | COLLATE utf8mb4_bin DEFAULT NULL |
| SrcGetFieldsSQL | varchar (250) | COLLATE utf8mb4_bin DEFAULT NULL |
| DeleteSQL | varchar (250) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstGetIDSQL | varchar (250) | COLLATE utf8mb4_bin DEFAULT NULL |
| HauptFeld | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DetailFeld | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Reihenfolge | int (11) | DEFAULT NULL |



# schildintern_spezialfilterfelder

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Gruppe | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| KurzBez | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Grundschule | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Tabelle | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| DBFeld | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Typ | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Control | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| WerteAnzeige | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| WerteSQL | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupInfo | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| OperatorenAnzeige | varchar (150) | COLLATE utf8mb4_bin DEFAULT NULL |
| OperatorenSQL | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Zusatzbedingung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| ZusatzTabellen | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_textexport

| Name | Type | Spec |
|---|---|---|
| DatenartKrz | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Feldname | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| AnzeigeText | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| Feldtyp | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Feldwerte | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| ErgebnisWerte | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupFeldname | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupSQLText | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| DBFormat | varchar (10) | COLLATE utf8mb4_bin NOT NULL DEFAULT 'ALLE' |



# schildintern_unicodeumwandlung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Unicodezeichen | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ersatzzeichen | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| DecimalZeichen | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| DecimalErsatzzeichen | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Hexzeichen | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| HexErsatzzeichen | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_verfimportfelder

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| TableDescription | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| FieldDescription | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstTable | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstFieldName | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstFieldType | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstRequiredState | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstLookupTable | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstLookupTableIDFieldName | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstLookupFieldName | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstResultFieldName | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstKeyLookupInsert | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstKeyLookupNameCreateID | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstForceNumeric | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_verfimporttabellen

| Name | Type | Spec |
|---|---|---|
| TableName | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| DstRequiredFields | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstIDFieldName | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sequence | int (11) | DEFAULT NULL |
| LookupTable | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupFields | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupFieldTypes | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupResultField | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupResultFieldType | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| LookupKeyField | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstDefaultFieldName | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstDefaultFieldValue | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| DstCreateID | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| GU_ID_Field | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_zusatzinfos

| Name | Type | Spec |
|---|---|---|
| SGL_BKAbschl | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| JG_BKAbschl | varchar (50) | COLLATE utf8mb4_bin NOT NULL |



# schuelerliste

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| Erzeuger | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Privat | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# schulecredentials

| Name | Type | Spec |
|---|---|---|
| Schulnummer | int (11) | NOT NULL |
| RSAPublicKey | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| RSAPrivateKey | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| AES | longtext | COLLATE utf8mb4_bin DEFAULT NULL |



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
| Funktionstext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| AbSchuljahr | int (11) | DEFAULT NULL |
| BisSchuljahr | int (11) | DEFAULT NULL |



# schulver_dbs

| Name | Type | Spec |
|---|---|---|
| SchulNr | varchar (6) | COLLATE utf8mb4_bin NOT NULL |
| RegSchl | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| KoRe | float | DEFAULT NULL |
| KoHo | float | DEFAULT NULL |
| ABez1 | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| ABez2 | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| ABez3 | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| PLZ | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ort | varchar (34) | COLLATE utf8mb4_bin DEFAULT NULL |
| Strasse | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| TelVorw | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| Telefon | varchar (12) | COLLATE utf8mb4_bin DEFAULT NULL |
| FaxVorw | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| Fax | varchar (15) | COLLATE utf8mb4_bin DEFAULT NULL |
| ModemVorw | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| Modem | varchar (15) | COLLATE utf8mb4_bin DEFAULT NULL |
| SF | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| OeffPri | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| KurzBez | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchBetrSchl | int (11) | DEFAULT NULL |
| SchBetrSchlDatum | varchar (8) | COLLATE utf8mb4_bin DEFAULT NULL |
| ArtDerTraegerschaft | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchultraegerNr | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| Schulgliederung | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| Schulart | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ganztagsbetrieb | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| FSP | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Verbund | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bus | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Fachberater | int (11) | DEFAULT NULL |
| FachberHauptamtl | int (11) | DEFAULT NULL |
| TelNrDBSalt | varchar (15) | COLLATE utf8mb4_bin DEFAULT NULL |
| RP | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Email | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| URL | varchar (1000) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bemerkung | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| CD | int (11) | DEFAULT NULL |
| Stift | int (11) | DEFAULT NULL |
| OGTS | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| SELB | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Internat | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| InternatPlaetze | int (11) | DEFAULT 0 |
| SMail | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| SportImAbi | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '0' |
| Tal | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '0' |
| KonKop | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '0' |



# schulver_schulformen

| Name | Type | Spec |
|---|---|---|
| Schulform | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| SF | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bezeichnung | varchar (60) | COLLATE utf8mb4_bin DEFAULT NULL |
| Flag | varchar (1) | COLLATE utf8mb4_bin DEFAULT '1' |
| geaendert | datetime | DEFAULT NULL |



# schulver_schultraeger

| Name | Type | Spec |
|---|---|---|
| SchulNr | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| RegSchl | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| KoRe | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| KoHo | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| ABez1 | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| ABez2 | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| ABez3 | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| PLZ | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ort | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Strasse | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| TelVorw | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Telefon | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| SF | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| OeffPri | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| KurzBez | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchBetrSchl | int (11) | DEFAULT NULL |
| SchBetrSchlDatum | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchuelerZahlASD | int (11) | DEFAULT 0 |
| SchuelerZahlVS | int (11) | DEFAULT 0 |
| ArtDerTraegerschaft | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchultraegerNr | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Schulgliederung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ganztagsbetrieb | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Aktiv | int (11) | NOT NULL DEFAULT 1 |



# schulver_weiteresf

| Name | Type | Spec |
|---|---|---|
| SNR | varchar (6) | COLLATE utf8mb4_bin NOT NULL |
| SGL | varchar (3) | COLLATE utf8mb4_bin NOT NULL DEFAULT '   ' |
| FSP | varchar (2) | COLLATE utf8mb4_bin NOT NULL DEFAULT '  ' |



# statkue_abgangsart

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Art | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (200) | COLLATE utf8mb4_bin DEFAULT NULL |
| KZ_Bereich | int (11) | NOT NULL DEFAULT 0 |
| KZ_Bereich_JG | int (11) | DEFAULT 0 |
| AbgangsJG | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Flag | varchar (1) | COLLATE utf8mb4_bin DEFAULT '1' |
| geaendert | datetime | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 0 |



# statkue_allgmerkmale

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| SF | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| StatistikKrz | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Schule | int (11) | DEFAULT NULL |
| Schueler | int (11) | DEFAULT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | DEFAULT NULL |



# statkue_anderegrundschulen

| Name | Type | Spec |
|---|---|---|
| SNR | varchar (6) | COLLATE utf8mb4_bin NOT NULL |
| SF | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| ABez1 | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| Strasse | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ort | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| Auswahl | int (11) | DEFAULT NULL |
| RegSchl | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_bilingual

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Fach | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_einschulungsart

| Name | Type | Spec |
|---|---|---|
| Art | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT 0 |
| Beschreibung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_fachklasse

| Name | Type | Spec |
|---|---|---|
| BKIndex | int (11) | NOT NULL DEFAULT 0 |
| Flag | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| FKS | varchar (3) | COLLATE utf8mb4_bin NOT NULL |
| AP | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| BGrp | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| BFeld | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ebene3 | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| BAKLALT | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| BAGRALT | varchar (4) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 0 |
| Status | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Flag_APOBK | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Beschreibung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Beschreibung_W | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Beschreibung_MW | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |
| BAKL | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| BAGR | varchar (8) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ebene1 | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ebene2 | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |



# statkue_foerderschwerpunkt

| Name | Type | Spec |
|---|---|---|
| Beschreibung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Flag | varchar (1) | COLLATE utf8mb4_bin DEFAULT '1' |
| FSP | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| geaendert | datetime | DEFAULT NULL |
| SF | varchar (2) | COLLATE utf8mb4_bin NOT NULL |



# statkue_gliederung

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Flag | varchar (1) | COLLATE utf8mb4_bin NOT NULL |
| BKAnlage | varchar (1) | COLLATE utf8mb4_bin NOT NULL |
| BKTyp | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| BKIndex | int (11) | DEFAULT 0 |
| Beschreibung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_herkunftsart

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Art | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Flag | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '1' |
| Sortierung | int (11) | NOT NULL DEFAULT 0 |
| geaendert | datetime | DEFAULT NULL |



# statkue_herkunftsschulform

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| HSF | varchar (3) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (150) | COLLATE utf8mb4_bin NOT NULL |
| Flag | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '1' |
| geaendert | datetime | DEFAULT NULL |



# statkue_lehrerabgang

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |
| ASDSchluessel | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |



# statkue_lehreranrechnung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| GueltigAbSJ | int (11) | DEFAULT NULL |
| GueltigBisSJ | int (11) | DEFAULT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerbeschaeftigungsart

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrereinsatzstatus

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerfachranerkennung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerfachrichtung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerlehramt

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerlehramtanerkennung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerlehrbefaehigung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerlehrbefanerkennung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrermehrleistung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerminderleistung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerrechtsverhaeltnis

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_lehrerzugang

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |
| ASDSchluessel | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |



# statkue_nationalitaeten

| Name | Type | Spec |
|---|---|---|
| Schluessel | varchar (3) | COLLATE utf8mb4_bin NOT NULL |
| Land | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Nationalitaet | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Flag | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |



# statkue_organisationsform

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| OrgForm | varchar (1) | COLLATE utf8mb4_bin NOT NULL |
| FSP | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (100) | COLLATE utf8mb4_bin NOT NULL |
| Flag | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_plzort

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| PLZ | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| RegSchl | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ort | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 1 |



# statkue_reformpaedagogik

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| RPG | varchar (1) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (100) | COLLATE utf8mb4_bin NOT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_religionen

| Name | Type | Spec |
|---|---|---|
| Schluessel | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Klartext | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_schuelerersteschulformseki

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| SF | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |
| geaendert | datetime | DEFAULT NULL |



# statkue_schuelerkindergartenbesuch

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| SF | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | NOT NULL DEFAULT 0 |



# statkue_schueleruebergangsempfehlung5jg

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| SF | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| Sort | int (11) | DEFAULT NULL |
| HGSEM | varchar (4) | COLLATE utf8mb4_bin NOT NULL |



# statkue_schuelerverkehrssprache

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| Langtext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Gesprochen_in | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |



# statkue_schulformen

| Name | Type | Spec |
|---|---|---|
| Schulform | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| SF | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| Flag | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '1' |
| geaendert | datetime | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 0 |



# statkue_strassen

| Name | Type | Spec |
|---|---|---|
| Ort | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| RegSchl | varchar (8) | COLLATE utf8mb4_bin NOT NULL |
| Strasse | varchar (75) | COLLATE utf8mb4_bin NOT NULL |
| Stand | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |



# statkue_svws_bkanlagen

| Name | Type | Spec |
|---|---|---|
| BKAnlage | varchar (1) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (120) | COLLATE utf8mb4_bin NOT NULL |



# statkue_svws_fachgruppen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Fachbereich | int (11) | DEFAULT NULL |
| SchildFgID | bigint (20) | DEFAULT NULL |
| FG_Bezeichnung | varchar (80) | COLLATE utf8mb4_bin NOT NULL |
| FG_Kuerzel | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Schulformen | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| FarbeR | int (11) | DEFAULT NULL |
| FarbeG | int (11) | DEFAULT NULL |
| FarbeB | int (11) | DEFAULT NULL |
| gueltigVon | int (11) | DEFAULT NULL |
| gueltigBis | int (11) | DEFAULT NULL |



# statkue_svws_schulgliederungen

| Name | Type | Spec |
|---|---|---|
| SGL | varchar (3) | COLLATE utf8mb4_bin NOT NULL |
| istBK | int (11) | NOT NULL DEFAULT 0 |
| Schulformen | varchar (120) | COLLATE utf8mb4_bin NOT NULL |
| istAuslaufend | int (11) | NOT NULL DEFAULT 0 |
| istAusgelaufen | int (11) | NOT NULL DEFAULT 0 |
| Beschreibung | varchar (120) | COLLATE utf8mb4_bin NOT NULL |
| BKAnlage | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| BKTyp | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| BKIndex | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| istVZ | int (11) | DEFAULT 0 |
| BKAbschlussBeruf | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| BKAbschlussAllg | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |



# statkue_svws_sprachpruefungniveaus

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Bezeichnung | varchar (16) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (200) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | NOT NULL |
| gueltigVon | int (11) | DEFAULT NULL |
| gueltigBis | int (11) | DEFAULT NULL |



# statkue_svws_zulaessigefaecher

| Name | Type | Spec |
|---|---|---|
| Fach | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Bezeichnung | varchar (80) | COLLATE utf8mb4_bin NOT NULL |
| FachkuerzelAtomar | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Kurzbezeichnung | varchar (80) | COLLATE utf8mb4_bin DEFAULT NULL |
| Aufgabenfeld | int (11) | DEFAULT NULL |
| Fachgruppe_ID | bigint (20) | DEFAULT NULL |
| SchulformenUndGliederungen | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchulformenAusgelaufen | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| AusgelaufenInSchuljahr | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbJahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
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
| Schulform | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| SchulformKuerzel | varchar (3) | COLLATE utf8mb4_bin NOT NULL |
| Jahrgang | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (80) | COLLATE utf8mb4_bin NOT NULL |
| Beginn | datetime | DEFAULT NULL |
| Ende | datetime | DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 0 |



# statkue_svws_zulaessigekursarten

| Name | Type | Spec |
|---|---|---|
| ID | varchar (7) | COLLATE utf8mb4_bin NOT NULL |
| Kuerzel | varchar (5) | COLLATE utf8mb4_bin NOT NULL |
| ASDNummer | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Bezeichnung | varchar (120) | COLLATE utf8mb4_bin NOT NULL |
| SchulformenUndGliederungen | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| KuerzelAllg | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| BezeichnungAllg | varchar (120) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchulformenAusgelaufen | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| erlaubtGOSt | int (11) | NOT NULL DEFAULT 0 |
| AusgelaufenInSchuljahr | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bemerkungen | varchar (120) | COLLATE utf8mb4_bin DEFAULT NULL |



# statkue_zulfaecher

| Name | Type | Spec |
|---|---|---|
| Schulform | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| FSP | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| BG | varchar (3) | COLLATE utf8mb4_bin NOT NULL |
| Fach | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Bezeichnung | varchar (80) | COLLATE utf8mb4_bin NOT NULL |
| KZ_Bereich | int (11) | DEFAULT 0 |
| Flag | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '1' |
| Sortierung | int (11) | DEFAULT 0 |
| Sortierung2 | int (11) | DEFAULT 0 |
| geaendert | datetime | DEFAULT NULL |



# statkue_zuljahrgaenge

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Schulform | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| SNR | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| FSP | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Jahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| KZ_Bereich | int (11) | DEFAULT 0 |
| Beschreibung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_zulklart

| Name | Type | Spec |
|---|---|---|
| KlArt | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| FSP | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Bezeichnung | varchar (100) | COLLATE utf8mb4_bin NOT NULL |
| Schulform | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| geaendert | datetime | DEFAULT NULL |



# statkue_zulkuart

| Name | Type | Spec |
|---|---|---|
| SF | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| FSP | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| BG | varchar (3) | COLLATE utf8mb4_bin NOT NULL |
| Kursart | varchar (3) | COLLATE utf8mb4_bin NOT NULL |
| Kursart2 | varchar (5) | COLLATE utf8mb4_bin NOT NULL |
| Bezeichnung | varchar (120) | COLLATE utf8mb4_bin NOT NULL |
| SGLBereich | int (11) | NOT NULL DEFAULT 0 |
| Flag | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '1' |
| geaendert | datetime | DEFAULT NULL |



# stundentafel

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| Jahrgang_ID | bigint (20) | DEFAULT NULL |
| ASDJahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| SGL | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| Fachklasse_ID | bigint (20) | DEFAULT NULL |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Sortierung | int (11) | DEFAULT 32000 |



# svws_client_konfiguration_global

| Name | Type | Spec |
|---|---|---|
| AppName | varchar (100) | COLLATE utf8mb4_bin NOT NULL |
| Schluessel | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Wert | longtext | COLLATE utf8mb4_bin NOT NULL |



# svws_db_autoinkremente

| Name | Type | Spec |
|---|---|---|
| NameTabelle | varchar (200) | COLLATE utf8mb4_bin NOT NULL |
| MaxID | bigint (20) | NOT NULL DEFAULT 1 |



# svws_db_version

| Name | Type | Spec |
|---|---|---|
| Revision | int (11) | NOT NULL DEFAULT 0 |
| IsTainted | int (11) | NOT NULL DEFAULT 0 |



# textexportvorlagen

| Name | Type | Spec |
|---|---|---|
| VorlageName | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| Daten | longtext | COLLATE utf8mb4_bin DEFAULT NULL |



# usergroups

| Name | Type | Spec |
|---|---|---|
| UG_ID | bigint (20) | NOT NULL |
| UG_Bezeichnung | varchar (64) | COLLATE utf8mb4_bin DEFAULT NULL |
| UG_Kompetenzen | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| UG_Nr | int (11) | DEFAULT NULL |



# users

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| US_Name | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| US_LoginName | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| US_Password | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| US_UserGroups | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| US_Privileges | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Email | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| EmailName | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| SMTPUsername | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| SMTPPassword | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| EmailSignature | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| HeartbeatDate | int (11) | DEFAULT NULL |
| ComputerName | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| US_PasswordHash | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |



# benutzerallgemein

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| AnzeigeName | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| CredentialID | bigint (20) | DEFAULT NULL |



# credentialslernplattformen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| LernplattformID | bigint (20) | NOT NULL |
| Benutzername | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| BenutzernamePseudonym | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Initialkennwort | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| PashwordHash | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| RSAPublicKey | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| RSAPrivateKey | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| AES | longtext | COLLATE utf8mb4_bin DEFAULT NULL |



# eigeneschule

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| SchulformNr | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchulformKrz | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchulformBez | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchultraegerArt | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchultraegerNr | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchulNr | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bezeichnung1 | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bezeichnung2 | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bezeichnung3 | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Strassenname | varchar (55) | COLLATE utf8mb4_bin DEFAULT NULL |
| HausNr | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| HausNrZusatz | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| PLZ | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ort | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Telefon | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Fax | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Email | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ganztags | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Schuljahresabschnitts_ID | bigint (20) | DEFAULT NULL |
| AnzahlAbschnitte | int (11) | DEFAULT 2 |
| Fremdsprachen | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| JVAZeigen | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| RefPaedagogikZeigen | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| AnzJGS_Jahr | smallint (6) | DEFAULT 1 |
| AbschnittBez | varchar (20) | COLLATE utf8mb4_bin DEFAULT 'Halbjahr' |
| BezAbschnitt1 | varchar (10) | COLLATE utf8mb4_bin DEFAULT '1. Hj' |
| BezAbschnitt2 | varchar (10) | COLLATE utf8mb4_bin DEFAULT '2. Hj' |
| IstHauptsitz | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| NotenGesperrt | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| BezAbschnitt3 | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| BezAbschnitt4 | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| ZurueckgestelltAnzahl | int (11) | DEFAULT NULL |
| ZurueckgestelltWeibl | int (11) | DEFAULT NULL |
| ZurueckgestelltAuslaender | int (11) | DEFAULT NULL |
| ZurueckgestelltAuslaenderWeibl | int (11) | DEFAULT NULL |
| ZurueckgestelltAussiedler | int (11) | DEFAULT NULL |
| ZurueckgestelltAussiedlerWeibl | int (11) | DEFAULT NULL |
| TeamTeaching | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| AbiGruppenprozess | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| DauerUnterrichtseinheit | int (11) | DEFAULT NULL |
| Gruppen8Bis1 | int (11) | DEFAULT NULL |
| Gruppen13Plus | int (11) | DEFAULT NULL |
| InternatsplaetzeM | int (11) | DEFAULT NULL |
| InternatsplaetzeW | int (11) | DEFAULT NULL |
| InternatsplaetzeNeutral | int (11) | DEFAULT NULL |
| SchulLogoBase64 | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Einstellungen | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| WebAdresse | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Land | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |



# eigeneschule_fachteilleistungen

| Name | Type | Spec |
|---|---|---|
| Teilleistung_ID | bigint (20) | NOT NULL |
| Fach_ID | bigint (20) | NOT NULL |
| Kursart | varchar (5) | COLLATE utf8mb4_bin NOT NULL |



# eigeneschule_jahrgaenge

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| InternKrz | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| GueltigVon | bigint (20) | DEFAULT NULL |
| GueltigBis | bigint (20) | DEFAULT NULL |
| ASDJahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| ASDBezeichnung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Sortierung | int (11) | DEFAULT 32000 |
| IstChronologisch | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Spaltentitel | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| SekStufe | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| SGL | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| Restabschnitte | int (11) | DEFAULT NULL |
| Folgejahrgang_ID | bigint (20) | DEFAULT NULL |



# floskeln

| Name | Type | Spec |
|---|---|---|
| Kuerzel | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| FloskelText | longtext | COLLATE utf8mb4_bin NOT NULL |
| FloskelGruppe | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| FloskelFach | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| FloskelNiveau | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| FloskelJahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |



# gost_jahrgang_fachkombinationen

| Name | Type | Spec |
|---|---|---|
| Abi_Jahrgang | int (11) | NOT NULL |
| ID | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| Fach1_ID | bigint (20) | NOT NULL |
| Fach2_ID | bigint (20) | NOT NULL |
| Kursart1 | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Kursart2 | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Phase | varchar (10) | COLLATE utf8mb4_bin NOT NULL DEFAULT '-' |
| Typ | int (11) | NOT NULL DEFAULT 0 |



# gost_jahrgang_faecher

| Name | Type | Spec |
|---|---|---|
| Abi_Jahrgang | int (11) | NOT NULL |
| Fach_ID | bigint (20) | NOT NULL |
| WaehlbarEF1 | int (11) | NOT NULL DEFAULT 1 |
| WaehlbarEF2 | int (11) | NOT NULL DEFAULT 1 |
| WaehlbarQ11 | int (11) | NOT NULL DEFAULT 1 |
| WaehlbarQ12 | int (11) | NOT NULL DEFAULT 1 |
| WaehlbarQ21 | int (11) | NOT NULL DEFAULT 1 |
| WaehlbarQ22 | int (11) | NOT NULL DEFAULT 1 |
| WaehlbarAbiGK | int (11) | NOT NULL DEFAULT 1 |
| WaehlbarAbiLK | int (11) | NOT NULL DEFAULT 1 |
| WochenstundenEF1 | int (11) | DEFAULT NULL |
| WochenstundenEF2 | int (11) | DEFAULT NULL |
| WochenstundenQPhase | int (11) | DEFAULT NULL |
| SchiftlichkeitEF1 | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchiftlichkeitEF2 | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| NurMuendlich | int (11) | NOT NULL DEFAULT 0 |



# k_allgadresse

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| AllgAdrName1 | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| AllgAdrName2 | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| AllgAdrStrassenname | varchar (55) | COLLATE utf8mb4_bin DEFAULT NULL |
| AllgAdrHausNr | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| AllgAdrHausNrZusatz | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| AllgAdrOrt_ID | bigint (20) | DEFAULT NULL |
| AllgAdrPLZ | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| AllgAdrTelefon1 | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| AllgAdrTelefon2 | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| AllgAdrFax | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| AllgAdrEmail | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| AllgAdrBemerkungen | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| AllgAdrAusbildungsBetrieb | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| AllgAdrBietetPraktika | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| AllgAdrBranche | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| AllgAdrZusatz1 | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| AllgAdrZusatz2 | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Massnahmentraeger | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| BelehrungISG | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| GU_ID | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| ErwFuehrungszeugnis | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| ExtID | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| AdressArt_ID | bigint (20) | DEFAULT NULL |



# k_ankreuzfloskeln

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Fach_ID | bigint (20) | DEFAULT NULL |
| IstASV | int (11) | NOT NULL DEFAULT 0 |
| Jahrgang | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| Gliederung | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| FloskelText | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT NULL |
| FachSortierung | int (11) | DEFAULT NULL |
| Abschnitt | int (11) | DEFAULT NULL |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aktiv | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |



# k_ortsteil

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| Ort_ID | bigint (20) | DEFAULT NULL |
| PLZ | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| OrtsteilSchluessel | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |



# klassen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schuljahresabschnitts_ID | bigint (20) | NOT NULL |
| Bezeichnung | varchar (150) | COLLATE utf8mb4_bin DEFAULT NULL |
| ASDKlasse | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| Klasse | varchar (15) | COLLATE utf8mb4_bin NOT NULL |
| Jahrgang_ID | bigint (20) | DEFAULT NULL |
| FKlasse | varchar (15) | COLLATE utf8mb4_bin DEFAULT NULL |
| VKlasse | varchar (15) | COLLATE utf8mb4_bin DEFAULT NULL |
| OrgFormKrz | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| ASDSchulformNr | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| Fachklasse_ID | bigint (20) | DEFAULT NULL |
| PruefOrdnung | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Sortierung | int (11) | DEFAULT 32000 |
| Klassenart | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| SommerSem | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| NotenGesperrt | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| AdrMerkmal | varchar (1) | COLLATE utf8mb4_bin DEFAULT 'A' |
| KoopKlasse | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Ankreuzzeugnisse | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |



# kompetenzen

| Name | Type | Spec |
|---|---|---|
| KO_ID | bigint (20) | NOT NULL |
| KO_Gruppe | bigint (20) | NOT NULL |
| KO_Bezeichnung | varchar (64) | COLLATE utf8mb4_bin NOT NULL |



# kurse

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schuljahresabschnitts_ID | bigint (20) | NOT NULL |
| KurzBez | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| Jahrgang_ID | bigint (20) | DEFAULT NULL |
| ASDJahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Fach_ID | bigint (20) | NOT NULL |
| KursartAllg | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| WochenStd | smallint (6) | DEFAULT NULL |
| Lehrer_ID | bigint (20) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Schienen | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Fortschreibungsart | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| WochenstdKL | float | DEFAULT NULL |
| SchulNr | int (11) | DEFAULT NULL |
| EpochU | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| ZeugnisBez | varchar (130) | COLLATE utf8mb4_bin DEFAULT NULL |
| Jahrgaenge | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |



# logins

| Name | Type | Spec |
|---|---|---|
| LI_UserID | bigint (20) | NOT NULL |
| LI_LoginTime | datetime | NOT NULL |
| LI_LogoffTime | datetime | DEFAULT NULL |



# nichtmoeglabifachkombi

| Name | Type | Spec |
|---|---|---|
| Fach1_ID | bigint (20) | NOT NULL |
| Fach2_ID | bigint (20) | NOT NULL |
| Kursart1 | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Kursart2 | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| PK | varchar (30) | COLLATE utf8mb4_bin NOT NULL |
| Sortierung | int (11) | DEFAULT NULL |
| Phase | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Typ | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |



# personengruppen_personen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Gruppe_ID | bigint (20) | NOT NULL |
| Person_ID | bigint (20) | DEFAULT NULL |
| PersonNr | int (11) | DEFAULT NULL |
| PersonArt | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| PersonName | varchar (120) | COLLATE utf8mb4_bin NOT NULL |
| PersonVorname | varchar (80) | COLLATE utf8mb4_bin DEFAULT NULL |
| PersonPLZ | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| PersonOrt | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| PersonStrassenname | varchar (55) | COLLATE utf8mb4_bin DEFAULT NULL |
| PersonHausNr | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| PersonHausNrZusatz | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| PersonTelefon | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| PersonMobil | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| PersonEmail | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bemerkung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Zusatzinfo | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT NULL |
| PersonAnrede | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| PersonAkadGrad | varchar (15) | COLLATE utf8mb4_bin DEFAULT NULL |



# schild_verwaltung

| Name | Type | Spec |
|---|---|---|
| BackupDatum | datetime | DEFAULT NULL |
| AutoBerechnung | datetime | DEFAULT NULL |
| DatumStatkue | datetime | DEFAULT NULL |
| DatumSchildIntern | datetime | DEFAULT NULL |
| Bescheinigung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Stammblatt | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| DatenGeprueft | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Version | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| GU_ID | varchar (40) | COLLATE utf8mb4_bin NOT NULL |
| DatumLoeschfristHinweisDeaktiviert | datetime | DEFAULT NULL |
| DatumLoeschfristHinweisDeaktiviertUserID | bigint (20) | DEFAULT NULL |
| DatumDatenGeloescht | datetime | DEFAULT NULL |



# schildintern_kaoa_merkmal

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| GueltigAb | datetime | DEFAULT NULL |
| GueltigBis | datetime | DEFAULT NULL |
| M_Kuerzel | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| Kategorie_ID | bigint (20) | NOT NULL |
| M_Beschreibung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| M_Option | varchar (25) | COLLATE utf8mb4_bin DEFAULT NULL |
| M_Kategorie | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| BK_Anlagen | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |



# schildintern_kaoa_zusatzmerkmal

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| GueltigAb | datetime | DEFAULT NULL |
| GueltigBis | datetime | DEFAULT NULL |
| ZM_Kuerzel | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| Merkmal_ID | bigint (20) | NOT NULL |
| ZM_Beschreibung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| ZM_Option | varchar (25) | COLLATE utf8mb4_bin DEFAULT NULL |
| ZM_Merkmal | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |



# schueler

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schuljahresabschnitts_ID | bigint (20) | DEFAULT NULL |
| GU_ID | varchar (40) | COLLATE utf8mb4_bin NOT NULL |
| SrcID | int (11) | DEFAULT NULL |
| IDext | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| Status | int (11) | DEFAULT NULL |
| Name | varchar (120) | COLLATE utf8mb4_bin DEFAULT NULL |
| Vorname | varchar (80) | COLLATE utf8mb4_bin DEFAULT NULL |
| Zusatz | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Geburtsname | varchar (120) | COLLATE utf8mb4_bin DEFAULT NULL |
| Strassenname | varchar (55) | COLLATE utf8mb4_bin DEFAULT NULL |
| HausNr | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| HausNrZusatz | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ort_ID | bigint (20) | DEFAULT NULL |
| PLZ | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ortsteil_ID | bigint (20) | DEFAULT NULL |
| Telefon | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Email | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Fax | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Geburtsdatum | date | DEFAULT NULL |
| Geburtsort | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Volljaehrig | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Geschlecht | smallint (6) | DEFAULT NULL |
| StaatKrz | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| StaatKrz2 | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| Aussiedler | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Religion_ID | bigint (20) | DEFAULT NULL |
| Religionsabmeldung | date | DEFAULT NULL |
| Religionsanmeldung | date | DEFAULT NULL |
| Bafoeg | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Sportbefreiung_ID | bigint (20) | DEFAULT NULL |
| Fahrschueler_ID | bigint (20) | DEFAULT NULL |
| Haltestelle_ID | bigint (20) | DEFAULT NULL |
| SchulpflichtErf | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Anschreibdatum | date | DEFAULT NULL |
| Aufnahmedatum | date | DEFAULT NULL |
| Einschulungsjahr | smallint (6) | DEFAULT NULL |
| Einschulungsart_ID | bigint (20) | DEFAULT NULL |
| LSSchulNr | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSSchulformSIM | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSJahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSSchulEntlassDatum | date | DEFAULT NULL |
| LSVersetzung | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSFachklKennung | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSFachklSIM | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSEntlassgrund | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSEntlassArt | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSKlassenart | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSRefPaed | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Entlassjahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Entlassjahrgang_ID | bigint (20) | DEFAULT NULL |
| Entlassdatum | date | DEFAULT NULL |
| Entlassgrund | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Entlassart | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchulwechselNr | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| Schulwechseldatum | date | DEFAULT NULL |
| Geloescht | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Gesperrt | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| ModifiziertAm | datetime | DEFAULT NULL |
| ModifiziertVon | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Markiert | varchar (21) | COLLATE utf8mb4_bin DEFAULT '-' |
| FotoVorhanden | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| JVA | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| KeineAuskunft | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Beruf | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbschlussDatum | varchar (15) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bemerkungen | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| BeginnBildungsgang | date | DEFAULT NULL |
| DurchschnittsNote | varchar (4) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSSGL | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSSchulform | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| KonfDruck | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| DSN_Text | varchar (15) | COLLATE utf8mb4_bin DEFAULT NULL |
| Berufsabschluss | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSSGL_SIM | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| BerufsschulpflErf | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| StatusNSJ | int (11) | DEFAULT NULL |
| FachklasseNSJ_ID | bigint (20) | DEFAULT NULL |
| BuchKonto | float | DEFAULT NULL |
| VerkehrsspracheFamilie | varchar (2) | COLLATE utf8mb4_bin DEFAULT 'de' |
| JahrZuzug | int (11) | DEFAULT NULL |
| DauerKindergartenbesuch | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| VerpflichtungSprachfoerderkurs | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| TeilnahmeSprachfoerderkurs | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| SchulbuchgeldBefreit | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| GeburtslandSchueler | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| GeburtslandVater | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| GeburtslandMutter | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Uebergangsempfehlung_JG5 | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| ErsteSchulform_SI | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| JahrWechsel_SI | int (11) | DEFAULT NULL |
| JahrWechsel_SII | int (11) | DEFAULT NULL |
| Migrationshintergrund | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| ExterneSchulNr | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| Kindergarten_ID | bigint (20) | DEFAULT NULL |
| LetzterBerufsAbschluss | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| LetzterAllgAbschluss | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Land | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| AV_Leist | int (11) | DEFAULT NULL |
| AV_Zuv | int (11) | DEFAULT NULL |
| AV_Selbst | int (11) | DEFAULT NULL |
| SV_Verant | int (11) | DEFAULT NULL |
| SV_Konfl | int (11) | DEFAULT NULL |
| SV_Koop | int (11) | DEFAULT NULL |
| Duplikat | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| EinschulungsartASD | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| DurchschnittsnoteFHR | varchar (4) | COLLATE utf8mb4_bin DEFAULT NULL |
| DSN_FHR_Text | varchar (15) | COLLATE utf8mb4_bin DEFAULT NULL |
| Eigenanteil | float | DEFAULT NULL |
| ZustimmungFoto | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| BKAZVO | int (11) | DEFAULT NULL |
| HatBerufsausbildung | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Ausweisnummer | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| EPJahre | int (11) | DEFAULT 2 |
| LSBemerkung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| WechselBestaetigt | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| DauerBildungsgang | int (11) | DEFAULT NULL |
| AnmeldeDatum | date | DEFAULT NULL |
| MeisterBafoeg | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| OnlineAnmeldung | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Dokumentenverzeichnis | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Berufsqualifikation | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| ZusatzNachname | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| EndeEingliederung | date | DEFAULT NULL |
| SchulEmail | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| EndeAnschlussfoerderung | date | DEFAULT NULL |
| MasernImpfnachweis | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Lernstandsbericht | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| SprachfoerderungVon | date | DEFAULT NULL |
| SprachfoerderungBis | date | DEFAULT NULL |
| EntlassungBemerkung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| CredentialID | bigint (20) | DEFAULT NULL |



# schuelerabgaenge

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| BemerkungIntern | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbgangsSchulform | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbgangsBeschreibung | varchar (200) | COLLATE utf8mb4_bin DEFAULT NULL |
| OrganisationsformKrz | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbgangsSchule | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbgangsSchuleAnschr | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbgangsSchulNr | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSJahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSEntlassArt | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSSchulformSIM | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSSchulEntlassDatum | date | DEFAULT NULL |
| LSVersetzung | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSSGL | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSFachklKennung | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| LSFachklSIM | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| FuerSIMExport | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| LSBeginnDatum | date | DEFAULT NULL |
| LSBeginnJahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |



# schuelerabifaecher

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| Fach_ID | bigint (20) | NOT NULL |
| FachKrz | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| FSortierung | int (11) | DEFAULT NULL |
| Kurs_ID | bigint (20) | DEFAULT NULL |
| KursartAllg | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Fachlehrer_ID | bigint (20) | DEFAULT NULL |
| AbiFach | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| P11_1 | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| S11_1 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| P11_2 | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| S11_2 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| P_FA | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| R_FA | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| W12_1 | int (11) | DEFAULT NULL |
| P12_1 | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| H12_1 | int (11) | DEFAULT NULL |
| R12_1 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| S12_1 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| W12_2 | int (11) | DEFAULT NULL |
| P12_2 | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| H12_2 | int (11) | DEFAULT NULL |
| R12_2 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| S12_2 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| W13_1 | int (11) | DEFAULT NULL |
| P13_1 | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| H13_1 | int (11) | DEFAULT NULL |
| R13_1 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| S13_1 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| W13_2 | int (11) | DEFAULT NULL |
| P13_2 | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| H13_2 | int (11) | DEFAULT NULL |
| R13_2 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| S13_2 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Zulassung | smallint (6) | DEFAULT NULL |
| Durchschnitt | float | DEFAULT NULL |
| AbiPruefErgebnis | smallint (6) | DEFAULT NULL |
| Zwischenstand | smallint (6) | DEFAULT NULL |
| MdlPflichtPruefung | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| MdlBestPruefung | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| MdlFreiwPruefung | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| MdlPruefErgebnis | smallint (6) | DEFAULT NULL |
| MdlPruefFolge | smallint (6) | DEFAULT NULL |
| AbiErgebnis | smallint (6) | DEFAULT NULL |



# schuelerabitur

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| Schuljahresabschnitts_ID | bigint (20) | DEFAULT NULL |
| FA_Fach | varchar (130) | COLLATE utf8mb4_bin DEFAULT NULL |
| FA_Punkte | int (11) | DEFAULT NULL |
| FehlStd | int (11) | DEFAULT NULL |
| uFehlStd | int (11) | DEFAULT NULL |
| FranzBilingual | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| BesondereLernleistung | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| AnzRelLK | smallint (6) | DEFAULT NULL |
| AnzRelGK | smallint (6) | DEFAULT NULL |
| AnzRelOK | smallint (6) | DEFAULT NULL |
| AnzDefLK | smallint (6) | DEFAULT NULL |
| AnzDefGK | smallint (6) | DEFAULT NULL |
| Thema_PJK | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| FS2_SekI_Manuell | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Kurse_I | int (11) | DEFAULT NULL |
| Defizite_I | int (11) | DEFAULT NULL |
| LK_Defizite_I | int (11) | DEFAULT NULL |
| AnzahlKurse_0 | int (11) | DEFAULT NULL |
| Punktsumme_I | int (11) | DEFAULT NULL |
| Durchschnitt_I | float | DEFAULT NULL |
| SummeGK | smallint (6) | DEFAULT NULL |
| SummeLK | smallint (6) | DEFAULT NULL |
| SummenOK | smallint (6) | DEFAULT NULL |
| Zugelassen | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| BLL_Art | varchar (1) | COLLATE utf8mb4_bin DEFAULT 'K' |
| BLL_Punkte | int (11) | DEFAULT NULL |
| Thema_BLL | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Punktsumme_II | int (11) | DEFAULT NULL |
| Defizite_II | int (11) | DEFAULT NULL |
| LK_Defizite_II | int (11) | DEFAULT NULL |
| PruefungBestanden | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Note | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| GesamtPunktzahl | smallint (6) | DEFAULT NULL |
| Notensprung | smallint (6) | DEFAULT NULL |
| FehlendePunktzahl | smallint (6) | DEFAULT NULL |



# schuelerbkabschluss

| Name | Type | Spec |
|---|---|---|
| Schueler_ID | bigint (20) | NOT NULL |
| Schuljahresabschnitts_ID | bigint (20) | DEFAULT NULL |
| Zulassung | char (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bestanden | char (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| ZertifikatBK | char (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| ZulassungErwBK | char (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| BestandenErwBK | char (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| ZulassungBA | char (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| BestandenBA | char (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| PraktPrfNote | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| NoteKolloquium | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| ThemaAbschlussarbeit | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| BAP_Vorhanden | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| NoteFachpraxis | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| FachPraktAnteilAusr | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |



# schuelerbkfaecher

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| Schuljahresabschnitts_ID | bigint (20) | DEFAULT NULL |
| Fach_ID | bigint (20) | NOT NULL |
| FachKrz | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| FachSchriftlich | char (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| FachSchriftlichBA | char (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Vornote | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| NoteSchriftlich | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| MdlPruefung | char (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| MdlPruefungFW | char (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| NoteMuendlich | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| NoteAbschluss | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| NotePrfGesamt | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| FSortierung | int (11) | DEFAULT NULL |
| Fachlehrer_ID | bigint (20) | DEFAULT NULL |
| NoteAbschlussBA | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Kursart | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |



# schuelerdatenschutz

| Name | Type | Spec |
|---|---|---|
| Schueler_ID | bigint (20) | NOT NULL |
| Datenschutz_ID | bigint (20) | NOT NULL |
| Status | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '-' |



# schuelererzadr

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| ErzieherArt_ID | bigint (20) | DEFAULT NULL |
| Anrede1 | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Titel1 | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Name1 | varchar (120) | COLLATE utf8mb4_bin DEFAULT NULL |
| Vorname1 | varchar (80) | COLLATE utf8mb4_bin DEFAULT NULL |
| Anrede2 | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Titel2 | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Name2 | varchar (120) | COLLATE utf8mb4_bin DEFAULT NULL |
| Vorname2 | varchar (80) | COLLATE utf8mb4_bin DEFAULT NULL |
| ErzOrt_ID | bigint (20) | DEFAULT NULL |
| ErzStrassenname | varchar (55) | COLLATE utf8mb4_bin DEFAULT NULL |
| ErzPLZ | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| ErzHausNr | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| ErzOrtsteil_ID | bigint (20) | DEFAULT NULL |
| ErzHausNrZusatz | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| ErzAnschreiben | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Sortierung | int (11) | DEFAULT NULL |
| ErzEmail | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| ErzAdrZusatz | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Erz1StaatKrz | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| Erz2StaatKrz | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| ErzEmail2 | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Erz1ZusatzNachname | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| Erz2ZusatzNachname | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bemerkungen | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| CredentialID | bigint (20) | DEFAULT NULL |



# schuelerfhr

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| FHRErreicht | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Note | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| GesamtPunktzahl | smallint (6) | DEFAULT NULL |
| SummeGK | smallint (6) | DEFAULT NULL |
| SummeLK | smallint (6) | DEFAULT NULL |
| SummenOK | smallint (6) | DEFAULT NULL |
| AnzRelLK | smallint (6) | DEFAULT NULL |
| AnzRelGK | smallint (6) | DEFAULT NULL |
| AnzRelOK | smallint (6) | DEFAULT NULL |
| AnzDefLK | smallint (6) | DEFAULT NULL |
| AnzDefGK | smallint (6) | DEFAULT NULL |
| AnzDefOK | smallint (6) | DEFAULT NULL |
| JSII_2_1 | smallint (6) | DEFAULT NULL |
| JSII_2_1_W | smallint (6) | DEFAULT NULL |
| JSII_2_2 | smallint (6) | DEFAULT NULL |
| JSII_2_2_W | smallint (6) | DEFAULT NULL |
| JSII_3_1 | smallint (6) | DEFAULT NULL |
| JSII_3_1_W | smallint (6) | DEFAULT NULL |
| JSII_3_2 | smallint (6) | DEFAULT NULL |
| JSII_3_2_W | smallint (6) | DEFAULT NULL |
| ASII_2_1 | smallint (6) | DEFAULT NULL |
| ASII_2_2 | smallint (6) | DEFAULT NULL |
| ASII_2_1_W | smallint (6) | DEFAULT NULL |
| ASII_2_2_W | smallint (6) | DEFAULT NULL |
| ASII_3_1 | smallint (6) | DEFAULT NULL |
| ASII_3_2 | smallint (6) | DEFAULT NULL |
| ASII_3_1_W | smallint (6) | DEFAULT NULL |
| ASII_3_2_W | smallint (6) | DEFAULT NULL |
| WSII_2_1 | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| WSII_2_2 | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| WSII_2_1_W | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| WSII_2_2_W | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| WSII_3_1 | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| WSII_3_2 | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| WSII_3_1_W | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| WSII_3_2_W | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |



# schuelerfhrfaecher

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| Fach_ID | bigint (20) | NOT NULL |
| KursartAllg | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| FachKrz | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| PSII_2_1 | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| HSII_2_1 | int (11) | DEFAULT NULL |
| RSII_2_1 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| PSII_2_2 | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| HSII_2_2 | int (11) | DEFAULT NULL |
| RSII_2_2 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| PSII_2_1_W | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| HSII_2_1_W | int (11) | DEFAULT NULL |
| RSII_2_1_W | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| PSII_2_2_W | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| HSII_2_2_W | int (11) | DEFAULT NULL |
| RSII_2_2_W | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| PSII_3_1 | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| HSII_3_1 | int (11) | DEFAULT NULL |
| RSII_3_1 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| PSII_3_2 | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| HSII_3_2 | int (11) | DEFAULT NULL |
| RSII_3_2 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| PSII_3_1_W | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| HSII_3_1_W | int (11) | DEFAULT NULL |
| RSII_3_1_W | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| PSII_3_2_W | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| HSII_3_2_W | int (11) | DEFAULT NULL |
| RSII_3_2_W | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| KSII_2_1 | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| KSII_2_2 | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| KSII_2_1_W | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| KSII_2_2_W | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| KSII_3_1 | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| KSII_3_2 | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| KSII_3_1_W | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| KSII_3_2_W | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| FSortierung | int (11) | DEFAULT NULL |



# schuelerfotos

| Name | Type | Spec |
|---|---|---|
| Schueler_ID | bigint (20) | NOT NULL |
| FotoBase64 | longtext | COLLATE utf8mb4_bin DEFAULT NULL |



# schuelergsdaten

| Name | Type | Spec |
|---|---|---|
| Schueler_ID | bigint (20) | NOT NULL |
| Note_Sprachgebrauch | int (11) | DEFAULT NULL |
| Note_Lesen | int (11) | DEFAULT NULL |
| Note_Rechtschreiben | int (11) | DEFAULT NULL |
| Note_Sachunterricht | int (11) | DEFAULT NULL |
| Note_Mathematik | int (11) | DEFAULT NULL |
| Note_Englisch | int (11) | DEFAULT NULL |
| Note_KunstTextil | int (11) | DEFAULT NULL |
| Note_Musik | int (11) | DEFAULT NULL |
| Note_Sport | int (11) | DEFAULT NULL |
| Note_Religion | int (11) | DEFAULT NULL |
| Durchschnittsnote_Sprache | float | DEFAULT NULL |
| Durchschnittsnote_Einfach | float | DEFAULT NULL |
| Durchschnittsnote_Gewichtet | float | DEFAULT NULL |
| Anrede_Klassenlehrer | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Nachname_Klassenlehrer | varchar (120) | COLLATE utf8mb4_bin DEFAULT NULL |
| GS_Klasse | varchar (15) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bemerkungen | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Geschwisterkind | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |



# schuelerlernplattform

| Name | Type | Spec |
|---|---|---|
| SchuelerID | bigint (20) | NOT NULL |
| LernplattformID | bigint (20) | NOT NULL |
| CredentialID | bigint (20) | DEFAULT NULL |
| EinwilligungAbgefragt | int (11) | NOT NULL DEFAULT 0 |
| EinwilligungNutzung | int (11) | NOT NULL DEFAULT 0 |
| EinwilligungAudiokonferenz | int (11) | NOT NULL DEFAULT 0 |
| EinwilligungVideokonferenz | int (11) | NOT NULL DEFAULT 0 |



# schuelerliste_inhalt

| Name | Type | Spec |
|---|---|---|
| Liste_ID | bigint (20) | NOT NULL |
| Schueler_ID | bigint (20) | NOT NULL |



# schuelermerkmale

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Schueler_ID | bigint (20) | NOT NULL |
| Kurztext | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| DatumVon | date | DEFAULT NULL |
| DatumBis | date | DEFAULT NULL |



# schuelerreportvorlagen

| Name | Type | Spec |
|---|---|---|
| User_ID | bigint (20) | NOT NULL |
| Reportvorlage | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Schueler_IDs | longtext | COLLATE utf8mb4_bin DEFAULT NULL |



# schuelersprachenfolge

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| AbschnittVon | smallint (6) | DEFAULT NULL |
| AbschnittBis | smallint (6) | DEFAULT NULL |
| Referenzniveau | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sprache | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| ReihenfolgeNr | int (11) | DEFAULT NULL |
| ASDJahrgangVon | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| ASDJahrgangBis | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| KleinesLatinumErreicht | int (11) | DEFAULT NULL |
| LatinumErreicht | int (11) | DEFAULT NULL |
| GraecumErreicht | int (11) | DEFAULT NULL |
| HebraicumErreicht | int (11) | DEFAULT NULL |



# schuelersprachpruefungen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| Sprache | varchar (2) | COLLATE utf8mb4_bin NOT NULL |
| ASDJahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Anspruchsniveau_ID | bigint (20) | DEFAULT NULL |
| Pruefungsdatum | date | DEFAULT NULL |
| ErsetzteSprache | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| KannErstePflichtfremdspracheErsetzen | int (11) | DEFAULT NULL |
| KannZweitePflichtfremdspracheErsetzen | int (11) | DEFAULT NULL |
| KannWahlpflichtfremdspracheErsetzen | int (11) | DEFAULT NULL |
| Referenzniveau | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| NotePruefung | int (11) | DEFAULT NULL |



# schuelertelefone

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| TelefonArt_ID | bigint (20) | DEFAULT NULL |
| Telefonnummer | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Bemerkung | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Gesperrt | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |



# schuelervermerke

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| VermerkArt_ID | bigint (20) | DEFAULT NULL |
| Datum | date | DEFAULT NULL |
| Bemerkung | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| AngelegtVon | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| GeaendertVon | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |



# schuelerwiedervorlage

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| Bemerkung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| AngelegtAm | datetime | DEFAULT NULL |
| WiedervorlageAm | datetime | DEFAULT NULL |
| ErledigtAm | datetime | DEFAULT NULL |
| User_ID | bigint (20) | DEFAULT NULL |
| Sekretariat | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Typ | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| NichtLoeschen | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |



# schuelerzp10

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| Schuljahresabschnitts_ID | bigint (20) | DEFAULT NULL |
| Fach_ID | bigint (20) | NOT NULL |
| Vornote | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| NoteSchriftlich | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| MdlPruefung | char (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| MdlPruefungFW | char (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| NoteMuendlich | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| NoteAbschluss | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Fachlehrer_ID | bigint (20) | DEFAULT NULL |



# stundenplan

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schuljahresabschnitts_ID | bigint (20) | NOT NULL |
| Beginn | date | NOT NULL DEFAULT '1899-01-01' |
| Ende | date | DEFAULT NULL |
| Beschreibung | varchar (1000) | COLLATE utf8mb4_bin NOT NULL |



# stundenplan_aufsichtsbereiche

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Stundenplan_ID | bigint (20) | NOT NULL |
| Kuerzel | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (1000) | COLLATE utf8mb4_bin NOT NULL |



# stundenplan_pausenzeit

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Stundenplan_ID | bigint (20) | NOT NULL |
| Tag | int (11) | NOT NULL |
| Beginn | time | NOT NULL DEFAULT current_timestamp() |
| Ende | time | NOT NULL DEFAULT current_timestamp() |



# stundenplan_raeume

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Stundenplan_ID | bigint (20) | NOT NULL |
| Kuerzel | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung | varchar (1000) | COLLATE utf8mb4_bin NOT NULL |
| Groesse | int (11) | NOT NULL DEFAULT 40 |



# stundenplan_zeitraster

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Stundenplan_ID | bigint (20) | NOT NULL |
| Tag | int (11) | NOT NULL |
| Stunde | int (11) | NOT NULL |
| Beginn | time | NOT NULL DEFAULT current_timestamp() |
| Ende | time | NOT NULL DEFAULT current_timestamp() |



# stundentafel_faecher

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Stundentafel_ID | bigint (20) | NOT NULL |
| Fach_ID | bigint (20) | NOT NULL |
| KursartAllg | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| WochenStd | smallint (6) | DEFAULT NULL |
| Lehrer_ID | bigint (20) | DEFAULT NULL |
| EpochenUnterricht | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Gewichtung | int (11) | DEFAULT 1 |



# svws_client_konfiguration_benutzer

| Name | Type | Spec |
|---|---|---|
| Benutzer_ID | bigint (20) | NOT NULL |
| AppName | varchar (100) | COLLATE utf8mb4_bin NOT NULL |
| Schluessel | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| Wert | longtext | COLLATE utf8mb4_bin NOT NULL |



# zuordnungreportvorlagen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Jahrgang_ID | bigint (20) | DEFAULT NULL |
| Abschluss | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbschlussBB | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbschlussArt | int (11) | DEFAULT NULL |
| VersetzungKrz | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Fachklasse_ID | bigint (20) | DEFAULT NULL |
| Reportvorlage | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Beschreibung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Gruppe | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Zeugnisart | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |



# allgadransprechpartner

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Adresse_ID | bigint (20) | NOT NULL |
| Name | varchar (120) | COLLATE utf8mb4_bin DEFAULT NULL |
| Vorname | varchar (80) | COLLATE utf8mb4_bin DEFAULT NULL |
| Anrede | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Telefon | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Email | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Abteilung | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Titel | varchar (15) | COLLATE utf8mb4_bin DEFAULT NULL |
| GU_ID | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |



# benutzergruppenkompetenzen

| Name | Type | Spec |
|---|---|---|
| Gruppe_ID | bigint (20) | NOT NULL |
| Kompetenz_ID | bigint (20) | NOT NULL |



# erzieherdatenschutz

| Name | Type | Spec |
|---|---|---|
| ErzieherID | bigint (20) | NOT NULL |
| DatenschutzID | bigint (20) | NOT NULL |
| Status | int (11) | NOT NULL DEFAULT 0 |



# erzieherlernplattform

| Name | Type | Spec |
|---|---|---|
| ErzieherID | bigint (20) | NOT NULL |
| LernplattformID | bigint (20) | NOT NULL |
| CredentialID | bigint (20) | DEFAULT NULL |
| EinwilligungAbgefragt | int (11) | NOT NULL DEFAULT 0 |
| EinwilligungNutzung | int (11) | NOT NULL DEFAULT 0 |
| EinwilligungAudiokonferenz | int (11) | NOT NULL DEFAULT 0 |
| EinwilligungVideokonferenz | int (11) | NOT NULL DEFAULT 0 |



# gost_schueler

| Name | Type | Spec |
|---|---|---|
| Schueler_ID | bigint (20) | NOT NULL |
| DatumBeratung | datetime | DEFAULT NULL |
| DatumRuecklauf | datetime | DEFAULT NULL |
| HatSprachPraktischePruefung | int (11) | NOT NULL DEFAULT 0 |
| HatSportattest | int (11) | NOT NULL DEFAULT 0 |
| Kommentar | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Beratungslehrer_ID | bigint (20) | DEFAULT NULL |
| PruefPhase | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| BesondereLernleistung_Art | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| BesondereLernleistung_Punkte | int (11) | DEFAULT NULL |
| ZweiteFremdpracheInSekIVorhanden | int (11) | NOT NULL DEFAULT 0 |



# gost_schueler_fachwahlen

| Name | Type | Spec |
|---|---|---|
| Schueler_ID | bigint (20) | NOT NULL |
| Fach_ID | bigint (20) | NOT NULL |
| EF1_Kursart | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| EF1_Punkte | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| EF2_Kursart | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| EF2_Punkte | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Q11_Kursart | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Q11_Punkte | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Q12_Kursart | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Q12_Punkte | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Q21_Kursart | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Q21_Punkte | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Q22_Kursart | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Q22_Punkte | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbiturFach | int (11) | DEFAULT NULL |
| Bemerkungen | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Markiert_Q1 | int (11) | DEFAULT NULL |
| Markiert_Q2 | int (11) | DEFAULT NULL |
| Markiert_Q3 | int (11) | DEFAULT NULL |
| Markiert_Q4 | int (11) | DEFAULT NULL |
| ergebnisAbiturpruefung | int (11) | DEFAULT NULL |
| hatMuendlichePflichtpruefung | int (11) | DEFAULT NULL |
| ergebnisMuendlichePruefung | int (11) | DEFAULT NULL |



# k_lehrer

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| GU_ID | varchar (40) | COLLATE utf8mb4_bin DEFAULT NULL |
| Kuerzel | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| LIDKrz | varchar (4) | COLLATE utf8mb4_bin DEFAULT NULL |
| Nachname | varchar (120) | COLLATE utf8mb4_bin NOT NULL |
| Vorname | varchar (80) | COLLATE utf8mb4_bin DEFAULT NULL |
| PersonTyp | varchar (20) | COLLATE utf8mb4_bin DEFAULT 'LEHRKRAFT' |
| Sortierung | int (11) | DEFAULT 32000 |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Aenderbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| FuerExport | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Statistik | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Strassenname | varchar (55) | COLLATE utf8mb4_bin DEFAULT NULL |
| HausNr | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| HausNrZusatz | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ort_ID | bigint (20) | DEFAULT NULL |
| PLZ | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Ortsteil_ID | bigint (20) | DEFAULT NULL |
| Tel | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Handy | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Email | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| EmailDienstlich | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| StaatKrz | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| Geburtsdatum | date | DEFAULT NULL |
| Geschlecht | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Anrede | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| Amtsbezeichnung | varchar (15) | COLLATE utf8mb4_bin DEFAULT NULL |
| Titel | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Faecher | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| IdentNr1 | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| SerNr | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| PANr | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| LBVNr | varchar (15) | COLLATE utf8mb4_bin DEFAULT NULL |
| VSchluessel | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| DatumZugang | date | DEFAULT NULL |
| GrundZugang | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| DatumAbgang | date | DEFAULT NULL |
| GrundAbgang | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| PflichtstdSoll | float | DEFAULT NULL |
| Rechtsverhaeltnis | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Beschaeftigungsart | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Einsatzstatus | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| StammschulNr | varchar (6) | COLLATE utf8mb4_bin DEFAULT NULL |
| MasernImpfnachweis | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| UnterrichtsStd | float | DEFAULT NULL |
| MehrleistungStd | float | DEFAULT NULL |
| EntlastungStd | float | DEFAULT NULL |
| AnrechnungStd | float | DEFAULT NULL |
| RestStd | float | DEFAULT NULL |
| LPassword | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| PWAktuell | varchar (3) | COLLATE utf8mb4_bin DEFAULT '-;5' |
| SchILDweb_FL | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| SchILDweb_KL | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| SchILDweb_Config | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| KennwortTools | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Antwort1 | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Antwort2 | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| KennwortToolsAktuell | varchar (3) | COLLATE utf8mb4_bin DEFAULT '-;5' |
| XNMPassword | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| XNMPassword2 | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| CredentialID | bigint (20) | DEFAULT NULL |



# klassenlehrer

| Name | Type | Spec |
|---|---|---|
| Klassen_ID | bigint (20) | NOT NULL |
| Lehrer_ID | bigint (20) | NOT NULL |
| Reihenfolge | int (11) | NOT NULL DEFAULT 1 |



# kurs_schueler

| Name | Type | Spec |
|---|---|---|
| Kurs_ID | bigint (20) | NOT NULL |
| Schueler_ID | bigint (20) | NOT NULL |



# kurslehrer

| Name | Type | Spec |
|---|---|---|
| Kurs_ID | bigint (20) | NOT NULL |
| Lehrer_ID | bigint (20) | NOT NULL |
| Anteil | float | DEFAULT NULL |



# lehrerabschnittsdaten

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Lehrer_ID | bigint (20) | NOT NULL |
| Schuljahresabschnitts_ID | bigint (20) | NOT NULL |
| Rechtsverhaeltnis | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Beschaeftigungsart | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Einsatzstatus | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| PflichtstdSoll | float | DEFAULT NULL |
| UnterrichtsStd | float | DEFAULT NULL |
| MehrleistungStd | float | DEFAULT NULL |
| EntlastungStd | float | DEFAULT NULL |
| AnrechnungStd | float | DEFAULT NULL |
| RestStd | float | DEFAULT NULL |



# lehreranrechnung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Abschnitt_ID | bigint (20) | NOT NULL |
| AnrechnungsgrundKrz | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| AnrechnungStd | float | DEFAULT NULL |



# lehrerdatenschutz

| Name | Type | Spec |
|---|---|---|
| LehrerID | bigint (20) | NOT NULL |
| DatenschutzID | bigint (20) | NOT NULL |
| Status | int (11) | NOT NULL DEFAULT 0 |



# lehrerentlastung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Abschnitt_ID | bigint (20) | NOT NULL |
| EntlastungsgrundKrz | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| EntlastungStd | float | DEFAULT NULL |



# lehrerfotos

| Name | Type | Spec |
|---|---|---|
| Lehrer_ID | bigint (20) | NOT NULL |
| FotoBase64 | longtext | COLLATE utf8mb4_bin DEFAULT NULL |



# lehrerfunktionen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Abschnitt_ID | bigint (20) | NOT NULL |
| Funktion_ID | bigint (20) | NOT NULL |



# lehrerlehramt

| Name | Type | Spec |
|---|---|---|
| Lehrer_ID | bigint (20) | NOT NULL |
| LehramtKrz | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| LehramtAnerkennungKrz | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |



# lehrerlehramtfachr

| Name | Type | Spec |
|---|---|---|
| Lehrer_ID | bigint (20) | NOT NULL |
| FachrKrz | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| FachrAnerkennungKrz | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |



# lehrerlehramtlehrbef

| Name | Type | Spec |
|---|---|---|
| Lehrer_ID | bigint (20) | NOT NULL |
| LehrbefKrz | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| LehrbefAnerkennungKrz | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |



# lehrerlernplattform

| Name | Type | Spec |
|---|---|---|
| LehrerID | bigint (20) | NOT NULL |
| LernplattformID | bigint (20) | NOT NULL |
| CredentialID | bigint (20) | DEFAULT NULL |
| EinwilligungAbgefragt | int (11) | NOT NULL DEFAULT 0 |
| EinwilligungNutzung | int (11) | NOT NULL DEFAULT 0 |
| EinwilligungAudiokonferenz | int (11) | NOT NULL DEFAULT 0 |
| EinwilligungVideokonferenz | int (11) | NOT NULL DEFAULT 0 |



# lehrermehrleistung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Abschnitt_ID | bigint (20) | NOT NULL |
| MehrleistungsgrundKrz | varchar (10) | COLLATE utf8mb4_bin NOT NULL |
| MehrleistungStd | float | DEFAULT NULL |



# schildintern_kaoa_sbo_ebene4

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| GueltigAb | datetime | DEFAULT NULL |
| GueltigBis | datetime | DEFAULT NULL |
| Kuerzel_EB4 | varchar (20) | COLLATE utf8mb4_bin NOT NULL |
| Beschreibung_EB4 | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Zusatzmerkmal | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Zusatzmerkmal_ID | bigint (20) | DEFAULT NULL |



# schueler_allgadr

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| Adresse_ID | bigint (20) | NOT NULL |
| Vertragsart_ID | bigint (20) | DEFAULT NULL |
| Vertragsbeginn | date | DEFAULT NULL |
| Vertragsende | date | DEFAULT NULL |
| Ausbilder | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| AllgAdrAnschreiben | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Praktikum | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Sortierung | int (11) | DEFAULT NULL |
| Ansprechpartner_ID | bigint (20) | DEFAULT NULL |
| Betreuungslehrer_ID | bigint (20) | DEFAULT NULL |



# schuelerlernabschnittsdaten

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Schueler_ID | bigint (20) | NOT NULL |
| Schuljahresabschnitts_ID | bigint (20) | NOT NULL |
| WechselNr | smallint (6) | DEFAULT NULL |
| Schulbesuchsjahre | smallint (6) | DEFAULT NULL |
| Hochrechnung | int (11) | DEFAULT NULL |
| SemesterWertung | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| PruefOrdnung | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Klassen_ID | bigint (20) | DEFAULT NULL |
| Verspaetet | smallint (6) | DEFAULT NULL |
| NPV_Fach_ID | bigint (20) | DEFAULT NULL |
| NPV_NoteKrz | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| NPV_Datum | date | DEFAULT NULL |
| NPAA_Fach_ID | bigint (20) | DEFAULT NULL |
| NPAA_NoteKrz | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| NPAA_Datum | date | DEFAULT NULL |
| NPBQ_Fach_ID | bigint (20) | DEFAULT NULL |
| NPBQ_NoteKrz | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| NPBQ_Datum | date | DEFAULT NULL |
| VersetzungKrz | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| AbschlussArt | smallint (6) | DEFAULT NULL |
| AbschlIstPrognose | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Konferenzdatum | date | DEFAULT NULL |
| ZeugnisDatum | date | DEFAULT NULL |
| ASDSchulgliederung | varchar (3) | COLLATE utf8mb4_bin DEFAULT NULL |
| ASDJahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Jahrgang_ID | bigint (20) | DEFAULT NULL |
| Fachklasse_ID | bigint (20) | DEFAULT NULL |
| Schwerpunkt_ID | bigint (20) | DEFAULT NULL |
| ZeugnisBem | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Schwerbehinderung | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Foerderschwerpunkt_ID | bigint (20) | DEFAULT NULL |
| OrgFormKrz | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| RefPaed | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Klassenart | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| SumFehlStd | int (11) | DEFAULT NULL |
| SumFehlStdU | int (11) | DEFAULT NULL |
| Wiederholung | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Gesamtnote_GS | int (11) | DEFAULT NULL |
| Gesamtnote_NW | int (11) | DEFAULT NULL |
| Folgeklasse_ID | bigint (20) | DEFAULT NULL |
| Foerderschwerpunkt2_ID | bigint (20) | DEFAULT NULL |
| Abschluss | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| Abschluss_B | varchar (50) | COLLATE utf8mb4_bin DEFAULT NULL |
| DSNote | varchar (4) | COLLATE utf8mb4_bin DEFAULT NULL |
| AV_Leist | int (11) | DEFAULT NULL |
| AV_Zuv | int (11) | DEFAULT NULL |
| AV_Selbst | int (11) | DEFAULT NULL |
| SV_Verant | int (11) | DEFAULT NULL |
| SV_Konfl | int (11) | DEFAULT NULL |
| SV_Koop | int (11) | DEFAULT NULL |
| KN_Lehrer | varchar (10) | COLLATE utf8mb4_bin DEFAULT NULL |
| MoeglNPFaecher | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Zertifikate | varchar (30) | COLLATE utf8mb4_bin DEFAULT NULL |
| DatumFHR | date | DEFAULT NULL |
| PruefAlgoErgebnis | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Zeugnisart | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| DatumVon | date | DEFAULT NULL |
| DatumBis | date | DEFAULT NULL |
| FehlstundenGrenzwert | int (11) | DEFAULT NULL |
| Sonderpaedagoge_ID | bigint (20) | DEFAULT NULL |
| FachPraktAnteilAusr | varchar (1) | COLLATE utf8mb4_bin NOT NULL DEFAULT '+' |
| BilingualerZweig | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| AOSF | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Autist | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| ZieldifferentesLernen | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |



# schuelerzuweisungen

| Name | Type | Spec |
|---|---|---|
| Abschnitt_ID | bigint (20) | NOT NULL |
| Fach_ID | bigint (20) | NOT NULL |
| Kursart | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |



# schulleitung

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| LeitungsfunktionID | bigint (20) | NOT NULL |
| Funktionstext | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| LehrerID | bigint (20) | NOT NULL |
| Von | datetime | DEFAULT NULL |
| Bis | datetime | DEFAULT NULL |



# stundenplan_pausenaufsichten

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Pausenzeit_ID | bigint (20) | NOT NULL |
| Wochentyp | int (11) | NOT NULL DEFAULT 0 |
| Lehrer_ID | bigint (20) | NOT NULL |



# stundenplan_pausenaufsichtenbereich

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Pausenaufsicht_ID | bigint (20) | NOT NULL |
| Aufsichtsbereich_ID | bigint (20) | NOT NULL |



# stundenplan_unterricht

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Zeitraster_ID | bigint (20) | NOT NULL |
| Wochentyp | int (11) | NOT NULL DEFAULT 0 |
| Klasse_ID | bigint (20) | DEFAULT NULL |
| Kurs_ID | bigint (20) | DEFAULT NULL |
| Fach_ID | bigint (20) | NOT NULL |



# stundenplan_unterrichtlehrer

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Unterricht_ID | bigint (20) | NOT NULL |
| Lehrer_ID | bigint (20) | NOT NULL |



# stundenplan_unterrichtraum

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Unterricht_ID | bigint (20) | NOT NULL |
| Raum_ID | bigint (20) | NOT NULL |



# benutzer

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL |
| Typ | smallint (6) | NOT NULL DEFAULT 0 |
| Allgemein_ID | bigint (20) | DEFAULT NULL |
| Lehrer_ID | bigint (20) | DEFAULT NULL |
| Schueler_ID | bigint (20) | DEFAULT NULL |
| Erzieher_ID | bigint (20) | DEFAULT NULL |
| IstAdmin | int (11) | NOT NULL DEFAULT 0 |



# benutzeremail

| Name | Type | Spec |
|---|---|---|
| Benutzer_ID | bigint (20) | NOT NULL |
| Email | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| EmailName | varchar (255) | COLLATE utf8mb4_bin NOT NULL |
| SMTPUsername | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| SMTPPassword | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| EMailSignature | varchar (2047) | COLLATE utf8mb4_bin DEFAULT NULL |
| HeartbeatDate | bigint (20) | DEFAULT NULL |
| ComputerName | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |



# benutzergruppenmitglieder

| Name | Type | Spec |
|---|---|---|
| Gruppe_ID | bigint (20) | NOT NULL |
| Benutzer_ID | bigint (20) | NOT NULL |



# benutzerkompetenzen

| Name | Type | Spec |
|---|---|---|
| Benutzer_ID | bigint (20) | NOT NULL |
| Kompetenz_ID | bigint (20) | NOT NULL |



# eigeneschule_abteilungen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Bezeichnung | varchar (50) | COLLATE utf8mb4_bin NOT NULL |
| Schuljahresabschnitts_ID | bigint (20) | NOT NULL DEFAULT -1 |
| AbteilungsLeiter_ID | bigint (20) | DEFAULT NULL |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Raum | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Email | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Durchwahl | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Sortierung | int (11) | DEFAULT NULL |



# gost_jahrgang_beratungslehrer

| Name | Type | Spec |
|---|---|---|
| Abi_Jahrgang | int (11) | NOT NULL |
| Lehrer_ID | bigint (20) | NOT NULL |



# schuelerankreuzfloskeln

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Abschnitt_ID | bigint (20) | NOT NULL |
| Floskel_ID | bigint (20) | NOT NULL |
| Stufe1 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Stufe2 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Stufe3 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Stufe4 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Stufe5 | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |



# schuelerfehlstunden

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Abschnitt_ID | bigint (20) | NOT NULL |
| Datum | date | NOT NULL DEFAULT current_timestamp() |
| Fach_ID | bigint (20) | DEFAULT NULL |
| FehlStd | float | NOT NULL |
| VonStd | int (11) | DEFAULT NULL |
| BisStd | int (11) | DEFAULT NULL |
| Entschuldigt | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Lehrer_ID | bigint (20) | DEFAULT NULL |



# schuelerkaoadaten

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Abschnitt_ID | bigint (20) | NOT NULL |
| Jahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| KategorieID | bigint (20) | NOT NULL |
| MerkmalID | bigint (20) | DEFAULT NULL |
| ZusatzmerkmalID | bigint (20) | DEFAULT NULL |
| AnschlussoptionID | bigint (20) | DEFAULT NULL |
| BerufsfeldID | bigint (20) | DEFAULT NULL |
| SBO_Ebene4ID | bigint (20) | DEFAULT NULL |
| Bemerkung | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |



# schuelerld_psfachbem

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Abschnitt_ID | bigint (20) | NOT NULL |
| ASV | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| LELS | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| AUE | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| ESF | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| BemerkungFSP | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| BemerkungVersetzung | longtext | COLLATE utf8mb4_bin DEFAULT NULL |



# schuelerleistungsdaten

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Abschnitt_ID | bigint (20) | NOT NULL |
| Fach_ID | bigint (20) | NOT NULL |
| Hochrechnung | int (11) | DEFAULT NULL |
| Fachlehrer_ID | bigint (20) | DEFAULT NULL |
| Kursart | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| KursartAllg | varchar (5) | COLLATE utf8mb4_bin DEFAULT NULL |
| Kurs_ID | bigint (20) | DEFAULT NULL |
| NotenKrz | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Warnung | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Warndatum | date | DEFAULT NULL |
| AbiFach | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| Wochenstunden | smallint (6) | DEFAULT NULL |
| AbiZeugnis | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Prognose | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| FehlStd | smallint (6) | DEFAULT NULL |
| uFehlStd | smallint (6) | DEFAULT NULL |
| Sortierung | int (11) | DEFAULT 32000 |
| Lernentw | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Gekoppelt | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| VorherAbgeschl | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| AbschlussJahrgang | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| HochrechnungStatus | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |
| SchulNr | int (11) | DEFAULT NULL |
| Zusatzkraft_ID | bigint (20) | DEFAULT NULL |
| WochenstdZusatzkraft | int (11) | DEFAULT NULL |
| Prf10Fach | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| AufZeugnis | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Gewichtung | int (11) | DEFAULT 1 |
| NoteAbschlussBA | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |
| Umfang | varchar (1) | COLLATE utf8mb4_bin DEFAULT NULL |



# eigeneschule_abt_kl

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Abteilung_ID | bigint (20) | NOT NULL |
| Sichtbar | varchar (1) | COLLATE utf8mb4_bin DEFAULT '+' |
| Klassen_ID | bigint (20) | NOT NULL |



# schuelereinzelleistungen

| Name | Type | Spec |
|---|---|---|
| ID | bigint (20) | NOT NULL DEFAULT -1 |
| Datum | date | DEFAULT NULL |
| Lehrer_ID | bigint (20) | DEFAULT NULL |
| Art_ID | bigint (20) | DEFAULT NULL |
| Bemerkung | varchar (100) | COLLATE utf8mb4_bin DEFAULT NULL |
| Leistung_ID | bigint (20) | NOT NULL |
| NotenKrz | varchar (2) | COLLATE utf8mb4_bin DEFAULT NULL |



# schuelerfoerderempfehlungen

| Name | Type | Spec |
|---|---|---|
| GU_ID | varchar (40) | COLLATE utf8mb4_bin NOT NULL |
| Abschnitt_ID | bigint (20) | DEFAULT NULL |
| DatumAngelegt | date | NOT NULL DEFAULT current_timestamp() |
| Klassen_ID | bigint (20) | DEFAULT NULL |
| Fach_ID | bigint (20) | DEFAULT NULL |
| Lehrer_ID | bigint (20) | DEFAULT NULL |
| DatumAenderungSchild | datetime | DEFAULT NULL |
| DatumAenderungSchildWeb | datetime | DEFAULT NULL |
| Kurs | varchar (20) | COLLATE utf8mb4_bin DEFAULT NULL |
| Inhaltl_Prozessbez_Komp | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Methodische_Komp | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Lern_Arbeitsverhalten | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Massn_Inhaltl_Prozessbez_Komp | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Massn_Methodische_Komp | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Massn_Lern_Arbeitsverhalten | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Verantwortlichkeit_Eltern | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Verantwortlichkeit_Schueler | longtext | COLLATE utf8mb4_bin DEFAULT NULL |
| Zeitrahmen_von_Datum | date | DEFAULT NULL |
| Zeitrahmen_bis_Datum | date | DEFAULT NULL |
| Ueberpruefung_Datum | date | DEFAULT NULL |
| Naechstes_Beratungsgespraech | date | DEFAULT NULL |
| Leistung_ID | bigint (20) | DEFAULT NULL |
| Kurs_ID | bigint (20) | DEFAULT NULL |
| EingabeFertig | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |
| Faecher | varchar (255) | COLLATE utf8mb4_bin DEFAULT NULL |
| Abgeschlossen | varchar (1) | COLLATE utf8mb4_bin DEFAULT '-' |


