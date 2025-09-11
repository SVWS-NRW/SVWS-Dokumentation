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

````bash 
...
USERNAME=`grep user /etc/mysql/debian.cnf ...
...
PASSWORD=`grep password /etc/mysql/debian.cnf 
````bash 

## bekannte Probleme

In manchen Systemen tritt bei einem Dump und einem anschließenden Wiedereinspielen das Problem auf, dass die groß und kleinschreibung der Tebellenspalten durch den dump oder das Zurückspielen verändert wird. z.B. wird aus dem ursprünglichen Spalten namen '''allgAdrAnsprechpartner''' dann im zurückgespielten System ein '''allgadransprechpartner'''. Dies kann dann weder von Schild3 noch vom SVWS-Server sauber verwertet werden. 

Hier ein Script, welches für die Version 1.0.12 des SVWS-Servers die Tabellenspalten in dem SQL Dump '''dump.sql'''wieder umbenennt. Der Parameter '''-i''' muss beim Mac gesetzt sein, ebenso wird beim Mac '''LC_ALL=C''' aufgrund der Anführungszeichen gesetzt sein. 


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