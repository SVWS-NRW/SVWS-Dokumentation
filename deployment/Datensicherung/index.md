# Datensicherung 

## manuelle Sicherung im SQLite Format 

Über die grafische Oberfläche des Adminclients kann sehr komfortabel eine Datensicherung im SQLite Format angelegt werden. 
Der Admin-Client kann i.d.R. unter `https://URLdesSVWS-Servers/admin` aufgerufen werden. 
Weitere Informationen dazu befinden sich im [Handbuch des Adminclients](../../adminclient/).

## automatisierte SQLite Backups

Automatisierte SQLite Backups können z.B. crontab gescriptet aufgerufen werden. 

````bash 

curl --user "rootUsername:MYSQLROOTPW" -k -X "GET"  "https://SERVERNAME:PORT/db/SCHEMA/export/sqlite" -H "accept: application/json"

````

Hier bitte die Variablen rootUsername, MYSQLROOTPW, SERVERNAME, PORT und SCHEMA ersetzen bzw. vorher im Skript oder Terminal definieren. 

## Backup mit Mariabackup

Das Tool mariabackup kann auch auf Windows per MSI-Paket installiert werden. Die [Anleitung von MariaDB.com] (https://mariadb.com/kb/en/full-backup-and-restore-with-mariabackup/) beschreibt, 
wie man mit kurzen Befehlen Backups anlegt und zurückspielt. Dies kann über einen Cronjob oder die Windows Aufgabenplanung regelmäßig ausgeführt werden.


## automatisiertes Backup per mysqldump

### mysqldump per cronjob

````bash 
mysqldump --user=USERNAME --password=PASSWORD DATABASENAME /path/to/mysql_dump.sql
````
Sichert die Datenbank einmalig unter dem angegebenen path. Dies kann mit Crontab sinnvoll automatisiert werden.

### automysqlbackup

Das Linux Tool `automysqlbackup` ist für regelmäßige Sicherungen sehr komfortabler und einfach. 
Es richtet unter `/var/lib/automysqlbackup` in entsprechenden Ordnern daily, weekly und monthly `.sql` Sicherungen ein. 

````bash 
apt install automysqlbackup
````
In der config `/etc/default/automysqlbackup` kann ggf. das Backupverzeichnisse definiert oder die Zeiten bzw. Exklusionen editiert werden. 

Regelmäßige Backups müssen dann per cronjob eingerichtet werden. z.B:

````bash 
0  1 * * * /usr/sbin/automysqlbackup
````

Aktuell muss unter Debian 12 in `/etc/mysql/debian.cnf` das rootpasswort für den Datenbankzugang eingetragen werden. Dazu bitte die beiden Variablen in dieser Datei ergänzen: 
````bash 
USERNAME=root
PASSWORD="the root password"
````
Dann in der Datei `/etc/mysql/debian.cnf` die folgenden Zeilen aktivieren:

```bash 
...
USERNAME=`grep user /etc/mysql/debian.cnf ...
...
PASSWORD=`grep password /etc/mysql/debian.cnf 
```
## bekannte Probleme

### Veränderung der Groß- und Kleinschreibung nach Rückspielen der Datensicherung 

In manchen Systemen tritt bei einem Dump und einem anschließenden Wiedereinspielen das Problem auf, dass die groß und kleinschreibung der Tebellenspalten durch den dump oder das Zurückspielen verändert wird. z.B. wird aus dem ursprünglichen Spalten namen ```allgAdrAnsprechpartner``` dann im zurückgespielten System ein ```allgadransprechpartner```. Dies kann dann weder von Schild3 noch vom SVWS-Server sauber verwertet werden. 

Hier ein Script, welches für die Version 1.0.12 des SVWS-Servers die Tabellenspalten in dem SQL Dump ```dump.sql``` wieder umbenennt. Der Parameter ```-i``` muss beim Mac gesetzt sein, ebenso wird beim Mac ```LC_ALL=C``` aufgrund der Anführungszeichen gesetzt sein. 


```
LC_ALL=C sed -i '' -e '
s/`allgadransprechpartner`/`AllgAdrAnsprechpartner`/g
s/`credentials`/`Credentials`/g
s/`credentialslernplattformen`/`CredentialsLernplattformen`/g
s/`eigeneschule`/`EigeneSchule`/g
s/`eigeneschule_abt_kl`/`EigeneSchule_Abt_Kl`/g
s/`eigeneschule_abteilungen`/`EigeneSchule_Abteilungen`/g
s/`eigeneschule_fachklassen`/`EigeneSchule_Fachklassen`/g
s/`eigeneschule_fachteilleistungen`/`EigeneSchule_FachTeilleistungen`/g
s/`eigeneschule_faecher`/`EigeneSchule_Faecher`/g
s/`eigeneschule_jahrgaenge`/`EigeneSchule_Jahrgaenge`/g
s/`eigeneschule_kaoadaten`/`EigeneSchule_KAoADaten`/g
s/`eigeneschule_kursart`/`EigeneSchule_Kursart`/g
s/`eigeneschule_merkmale`/`EigeneSchule_Merkmale`/g
s/`eigeneschule_schulformen`/`EigeneSchule_Schulformen`/g
s/`eigeneschule_teilstandorte`/`EigeneSchule_Teilstandorte`/g
s/`eigeneschule_texte`/`EigeneSchule_Texte`/g
s/`eigeneschule_zertifikate`/`EigeneSchule_Zertifikate`/g
s/`erzieherdatenschutz`/`ErzieherDatenschutz`/g
s/`erzieherlernplattform`/`ErzieherLernplattform`/g
s/`fach_gliederungen`/`Fach_Gliederungen`/g
s/`floskelgruppen`/`Floskelgruppen`/g
s/`floskeln`/`Floskeln`/g
s/`k_adressart`/`K_Adressart`/g
s/`k_allgadresse`/`K_AllgAdresse`/g
s/`k_ankreuzdaten`/`K_Ankreuzdaten`/g
s/`k_ankreuzfloskeln`/`K_Ankreuzfloskeln`/g
s/`k_beschaeftigungsart`/`K_BeschaeftigungsArt`/g
s/`k_datenschutz`/`K_Datenschutz`/g
s/`k_einschulungsart`/`K_EinschulungsArt`/g
s/`k_einzelleistungen`/`K_Einzelleistungen`/g
s/`k_entlassgrund`/`K_EntlassGrund`/g
s/`k_erzieherart`/`K_ErzieherArt`/g
s/`k_erzieherfunktion`/`K_ErzieherFunktion`/g
s/`k_fahrschuelerart`/`K_FahrschuelerArt`/g
s/`k_foerderschwerpunkt`/`K_Foerderschwerpunkt`/g
s/`k_haltestelle`/`K_Haltestelle`/g
s/`k_kindergarten`/`K_Kindergarten`/g
s/`k_lehrer`/`K_Lehrer`/g
s/`k_ort`/`K_Ort`/g
s/`k_ortsteil`/`K_Ortsteil`/g
s/`k_religion`/`K_Religion`/g
s/`k_schule`/`K_Schule`/g
s/`k_schulfunktionen`/`K_Schulfunktionen`/g
s/`k_schwerpunkt`/`K_Schwerpunkt`/g
s/`k_sportbefreiung`/`K_Sportbefreiung`/g
s/`k_staat`/`K_Staat`/g
s/`k_telefonart`/`K_TelefonArt`/g
s/`k_verkehrssprachen`/`K_Verkehrssprachen`/g
s/`k_vermerkart`/`K_Vermerkart`/g
s/`k_zertifikate`/`K_Zertifikate`/g
s/`kompetenzen`/`Kompetenzen`/g
s/`kompetenzgruppen`/`Kompetenzgruppen`/g
s/`kurse`/`Kurse`/g
s/`kurslehrer`/`KursLehrer`/g
s/`lehrerabschnittsdaten`/`LehrerAbschnittsdaten`/g
s/`lehreranrechnung`/`LehrerAnrechnung`/g
s/`lehrerdatenschutz`/`LehrerDatenschutz`/g
s/`lehrerentlastung`/`LehrerEntlastung`/g
s/`lehrerfotos`/`LehrerFotos`/g
s/`lehrerfunktionen`/`LehrerFunktionen`/g
s/`lehrerlehramt`/`LehrerLehramt`/g
s/`lehrerlehramtfachr`/`LehrerLehramtFachr`/g
s/`lehrerlehramtlehrbef`/`LehrerLehramtLehrbef`/g
s/`lehrerlernplattform`/`LehrerLernplattform`/g
s/`lehrermehrleistung`/`LehrerMehrleistung`/g
s/`lernplattformen`/`Lernplattformen`/g
s/`logins`/`Logins`/g
s/`nichtmoeglabifachkombi`/`NichtMoeglAbiFachKombi`/g
s/`personengruppen`/`Personengruppen`/g
s/`personengruppen_personen`/`Personengruppen_Personen`/g
s/`prfsemabschl`/`PrfSemAbschl`/g
s/`schild_verwaltung`/`Schild_Verwaltung`/g
s/`schildfilter`/`SchildFilter`/g
s/`schueler`/`Schueler`/g
s/`schueler_allgadr`/`Schueler_AllgAdr`/g
s/`schuelerabgaenge`/`SchuelerAbgaenge`/g
s/`schuelerabifaecher`/`SchuelerAbiFaecher`/g
s/`schuelerabitur`/`SchuelerAbitur`/g
s/`schuelerankreuzfloskeln`/`SchuelerAnkreuzfloskeln`/g
s/`schuelerbkabschluss`/`SchuelerBKAbschluss`/g
s/`schuelerbkfaecher`/`SchuelerBKFaecher`/g
s/`schuelerdatenschutz`/`SchuelerDatenschutz`/g
s/`schuelereinzelleistungen`/`SchuelerEinzelleistungen`/g
s/`schuelererzadr`/`SchuelerErzAdr`/g
s/`schuelerfehlstunden`/`SchuelerFehlstunden`/g
s/`schuelerfhr`/`SchuelerFHR`/g
s/`schuelerfhrfaecher`/`SchuelerFHRFaecher`/g
s/`schuelerfoerderempfehlungen`/`SchuelerFoerderempfehlungen`/g
s/`schuelerfotos`/`SchuelerFotos`/g
s/`schuelergsdaten`/`SchuelerGSDaten`/g
s/`schuelerkaoadaten`/`SchuelerKAoADaten`/g
s/`schuelerld_psfachbem`/`SchuelerLD_PSFachBem`/g
s/`schuelerleistungsdaten`/`SchuelerLeistungsdaten`/g
s/`schuelerlernabschnittsdaten`/`SchuelerLernabschnittsdaten`/g
s/`schuelerlernplattform`/`SchuelerLernplattform`/g
s/`schuelerliste`/`SchuelerListe`/g
s/`schuelerliste_inhalt`/`SchuelerListe_Inhalt`/g
s/`schuelermerkmale`/`SchuelerMerkmale`/g
s/`schuelerreportvorlagen`/`SchuelerReportvorlagen`/g
s/`schuelersprachenfolge`/`SchuelerSprachenfolge`/g
s/`schuelertelefone`/`SchuelerTelefone`/g
s/`schuelervermerke`/`SchuelerVermerke`/g
s/`schuelerwiedervorlage`/`SchuelerWiedervorlage`/g
s/`schuelerzuweisungen`/`SchuelerZuweisungen`/g
s/`schulecredentials`/`SchuleCredentials`/g
s/`stundentafel`/`Stundentafel`/g
s/`stundentafel_faecher`/`Stundentafel_Faecher`/g
s/`textexportvorlagen`/`TextExportVorlagen`/g
s/`usergroups`/`Usergroups`/g
s/`users`/`Users`/g
s/`versetzung`/`Versetzung`/g
s/`zuordnungreportvorlagen`/`ZuordnungReportvorlagen`/g
' dump.sql

```

Alternativ und etwas performanter kann dieses Skript unter node.js verwendet werden: 

```js
// Dieses Node-Script kann mit node entweder als Script ausgeführt werden:
// node diesesScript.js
// oder im Browser, in den Entwicklertools in der Console ausführen (Copy/Paste/Ausführen)
// oder in einem beliebigen anderen node-REPL
//
// Vor dem Ausführen müssen noch die Namen der Datenbanken angepasst werden:

// Namen der Datenbanken eingeben, deren Tabellen umbenannt werden sollen:
const dbs = ["schild_gym_sek1", "schild_gym_sek2", "schild_kbk", "schild_kbk2"];

// Die Ausgabe nach dem Ausführen dieses Scripts kann in der MySQL, bzw. MariaDB-Konsole ausgeführt werden und benennt alle Tabellen in das korrekte Format um.

const names = ["allgadransprechpartner", "credentials", "credentialslernplattformen", "eigeneschule", "eigeneschule_abt_kl", "eigeneschule_abteilungen", "eigeneschule_fachklassen", "eigeneschule_fachteilleistungen", "eigeneschule_faecher", "eigeneschule_jahrgaenge", "eigeneschule_kaoadaten", "eigeneschule_kursart", "eigeneschule_kursartallg", "eigeneschule_merkmale", "eigeneschule_schulformen", "eigeneschule_teilstandorte", "eigeneschule_texte", "eigeneschule_zertifikate", "eigeneschule_zertifikatsfaecher", "erzieherdatenschutz", "erzieherlernplattform", "fach_gliederungen", "fachklassen_schwerpunkte", "floskelgruppen", "floskeln", "k_adressart", "k_allgadresse", "k_ankreuzdaten", "k_ankreuzfloskeln", "k_beschaeftigungsart", "k_datenschutz", "k_einschulungsart", "k_einzelleistungen", "k_entlassgrund", "k_erzieherart", "k_erzieherfunktion", "k_fahrschuelerart", "k_foerderschwerpunkt", "k_haltestelle", "k_kindergarten", "k_klassenorgform", "k_lehrer", "k_ort", "k_ortsteil", "k_religion", "k_schule", "k_schulfunktionen", "k_schwerpunkt", "k_sportbefreiung", "k_staat", "k_telefonart", "k_verkehrssprachen", "k_vermerkart", "k_zertifikate", "kompetenzen", "kompetenzgruppen", "kurse", "kurskombinationen", "kurslehrer", "lehrer_imei", "lehrerabschnittsdaten", "lehreranrechnung", "lehrerdatenschutz", "lehrerentlastung", "lehrerfotos", "lehrerfunktionen", "lehrerlehramt", "lehrerlehramtfachr", "lehrerlehramtlehrbef", "lehrerlernplattform", "lehrermehrleistung", "lernplattformen", "logins", "nichtmoeglabifachkombi", "personengruppen", "personengruppen_personen", "prfsemabschl", "schild_verwaltung", "schildfilter", "schueler", "schueler_allgadr", "schuelerabgaenge", "schuelerabifaecher", "schuelerabitur", "schuelerankreuzfloskeln", "schuelerbkabschluss", "schuelerbkfaecher", "schuelerdatenschutz", "schuelereinzelleistungen", "schuelererzadr", "schuelererzfunktion", "schuelerfehlstunden", "schuelerfhr", "schuelerfhrfaecher", "schuelerfoerderempfehlungen", "schuelerfotos", "schuelergsdaten", "schuelerkaoadaten", "schuelerld_psfachbem", "schuelerleistungsdaten", "schuelerlernabschnittsdaten", "schuelerlernplattform", "schuelerliste", "schuelerliste_inhalt", "schuelermerkmale", "schuelerreportvorlagen", "schuelersprachenfolge", "schuelertelefone", "schuelervermerke", "schuelerwiedervorlage", "schuelerzuweisungen", "schulecredentials", "stundentafel", "stundentafel_faecher", "textexportvorlagen", "usergroups", "users", "versetzung", "zuordnungreportvorlagen"];

const namesNeu = ["AllgAdrAnsprechpartner", "AllgemeineMerkmaleKatalog_Keys", "Benutzer", "BenutzerAllgemein", "BenutzerEmail", "BenutzerKompetenzen", "Benutzergruppen", "BenutzergruppenKompetenzen", "BenutzergruppenMitglieder", "Berufskolleg_Anlagen", "Berufskolleg_Berufsebenen1", "Berufskolleg_Berufsebenen2", "Berufskolleg_Berufsebenen3", "Berufskolleg_Fachklassen_Keys", "Credentials", "CredentialsLernplattformen", "DavRessourceCollections", "DavRessourceCollectionsACL", "DavRessources", "DavSyncTokenLehrer", "DavSyncTokenSchueler", "EigeneSchule", "EigeneSchule_Abt_Kl", "EigeneSchule_Abteilungen", "EigeneSchule_Email", "EigeneSchule_FachTeilleistungen", "EigeneSchule_Fachklassen", "EigeneSchule_Faecher", "EigeneSchule_Jahrgaenge", "EigeneSchule_KAoADaten", "EigeneSchule_Kursart", "EigeneSchule_Logo", "EigeneSchule_Merkmale", "EigeneSchule_Schulformen", "EigeneSchule_Teilstandorte", "EigeneSchule_Texte", "EigeneSchule_Zertifikate", "EinschulungsartKatalog_Keys", "EnmLeistungsdaten", "EnmLernabschnittsdaten", "EnmTeilleistungen", "ErzieherDatenschutz", "ErzieherLernplattform", "FachKatalog", "FachKatalog_Keys", "FachKatalog_Schulformen", "Fach_Gliederungen", "Fachgruppen", "Floskelgruppen", "Floskeln", "Gost_Blockung", "Gost_Blockung_Kurse", "Gost_Blockung_Kurslehrer", "Gost_Blockung_Regeln", "Gost_Blockung_Regelparameter", "Gost_Blockung_Schienen", "Gost_Blockung_Zwischenergebnisse", "Gost_Blockung_Zwischenergebnisse_Kurs_Schienen", "Gost_Blockung_Zwischenergebnisse_Kurs_Schueler", "Gost_Jahrgang_Beratungslehrer", "Gost_Jahrgang_Fachkombinationen", "Gost_Jahrgang_Fachwahlen", "Gost_Jahrgang_Faecher", "Gost_Jahrgangsdaten", "Gost_Klausuren_Kalenderinformationen", "Gost_Klausuren_Kursklausuren", "Gost_Klausuren_NtaZeiten", "Gost_Klausuren_Raeume", "Gost_Klausuren_Raumstunden", "Gost_Klausuren_Raumstunden_Aufsichten", "Gost_Klausuren_Schuelerklausuren", "Gost_Klausuren_Schuelerklausuren_Termine", "Gost_Klausuren_SchuelerklausurenTermine_Raumstunden", "Gost_Klausuren_Termine", "Gost_Klausuren_Termine_Jahrgaenge", "Gost_Klausuren_Vorgaben", "Gost_Schueler", "Gost_Schueler_Fachwahlen", "Herkunft", "Herkunft_Keys", "Herkunft_Schulformen", "Herkunftsart", "Herkunftsart_Keys", "Herkunftsart_Schulformen", "ImpExp_EigeneImporte", "ImpExp_EigeneImporte_Felder", "ImpExp_EigeneImporte_Tabellen", "Jahrgaenge_Keys", "KAoA_Anschlussoption_Keys", "KAoA_Berufsfeld_Keys", "KAoA_Kategorie_Keys", "KAoA_Merkmal_Keys", "KAoA_SBO_Ebene4_Keys", "KAoA_Zusatzmerkmal_Keys", "K_Adressart", "K_AllgAdresse", "K_Ankreuzdaten", "K_Ankreuzfloskeln", "K_BeschaeftigungsArt", "K_Datenschutz", "K_EinschulungsArt", "K_Einzelleistungen", "K_EntlassGrund", "K_ErzieherArt", "K_ErzieherFunktion", "K_FahrschuelerArt", "K_Foerderschwerpunkt", "K_Haltestelle", "K_Kindergarten", "K_Lehrer", "K_Ort", "K_Ortsteil", "K_Religion", "K_Schule", "K_Schulfunktionen", "K_Schwerpunkt", "K_Sportbefreiung", "K_TelefonArt", "K_Textdateien", "K_Vermerkart", "K_Zertifikate", "Katalog_Aufsichtsbereich", "Katalog_Pausenzeiten", "Katalog_Raeume", "Katalog_Zeitraster", "Klassen", "KlassenLehrer", "KlassenartenKatalog_Keys", "Kompetenzen", "Kompetenzgruppen", "KursFortschreibungsarten", "KursLehrer", "Kurs_Schueler", "KursartenKatalog_Keys", "Kurse", "LehrerAbschnittsdaten", "LehrerAnrechnung", "LehrerDatenschutz", "LehrerEntlastung", "LehrerFotos", "LehrerFunktionen", "LehrerLehramt", "LehrerLehramtFachr", "LehrerLehramtLehrbef", "LehrerLeitungsfunktion_Keys", "LehrerLernplattform", "LehrerMehrleistung", "LehrerNotenmodulCredentials", "LehrerPersonaldatenLehramt", "LehrerPersonaldatenLehramtFachrichtung", "LehrerPersonaldatenLehramtLehrbefaehigung", "Lernplattformen", "Logins", "Nationalitaeten_Keys", "NichtMoeglAbiFachKombi", "Noten", "OrganisationsformenKatalog_Keys", "PersonalTypen", "Personengruppen", "Personengruppen_Personen", "Religionen_Keys", "Client_Konfiguration_Benutzer", "Client_Konfiguration_Global", "Schema_Core_Type_Versionen", "Schema_AutoInkremente", "Schema_Status", "SchildFilter", "Schild_Verwaltung", "Schueler", "SchuelerAbgaenge", "SchuelerAbiFaecher", "SchuelerAbitur", "SchuelerAnkreuzfloskeln", "SchuelerBKAbschluss", "SchuelerBKFaecher", "SchuelerDatenschutz", "SchuelerEinzelleistungen", "SchuelerErzAdr", "SchuelerFHR", "SchuelerFHRFaecher", "SchuelerFehlstunden", "SchuelerFoerderempfehlungen", "SchuelerFotos", "SchuelerGSDaten", "SchuelerKAoADaten", "SchuelerLD_PSFachBem", "SchuelerLeistungsdaten", "SchuelerLernabschnittsdaten", "SchuelerLernplattform", "SchuelerListe", "SchuelerListe_Inhalt", "SchuelerMerkmale", "SchuelerReportvorlagen", "SchuelerSprachenfolge", "SchuelerSprachpruefungen", "SchuelerStatus_Keys", "SchuelerTelefone", "SchuelerVermerke", "SchuelerWiedervorlage", "SchuelerZP10", "SchuelerZuweisungen", "Schueler_AllgAdr", "SchuleCredentials", "SchuleOAuthSecrets", "Schulbewerbung_Importe", "Schulformen", "Schuljahresabschnitte", "Schulleitung", "Stundenplan", "Stundenplan_Aufsichtsbereiche", "Stundenplan_Kalenderwochen_Zuordnung", "Stundenplan_Pausenaufsichten", "Stundenplan_PausenaufsichtenBereich", "Stundenplan_Pausenzeit", "Stundenplan_Pausenzeit_Klassenzuordnung", "Stundenplan_Raeume", "Stundenplan_Schienen", "Stundenplan_Unterricht", "Stundenplan_UnterrichtKlasse", "Stundenplan_UnterrichtLehrer", "Stundenplan_UnterrichtRaum", "Stundenplan_UnterrichtSchiene", "Stundenplan_Zeitraster", "Stundentafel", "Stundentafel_Faecher", "TextExportVorlagen", "TimestampsLehrerNotenmodulCredentials", "TimestampsSchuelerAnkreuzkompetenzen", "TimestampsSchuelerLeistungsdaten", "TimestampsSchuelerLernabschnittsdaten", "TimestampsSchuelerTeilleistungen", "Usergroups", "Users", "Versetzung", "Wiedervorlage", "ZuordnungReportvorlagen"];
namesNeu.push("K_Staat", "K_Verkehrssprachen", "PrfSemAbschl");

let out = "";

for (const db of dbs) {
    for (const n of names) {
        const nn = namesNeu.find(name => n.toLowerCase() === name.toLowerCase());
        if (nn === undefined)
            continue;
        out += `RENAME TABLE ${db}.${n} TO ${db}.${nn};`
    }
}

console.log(out);
```