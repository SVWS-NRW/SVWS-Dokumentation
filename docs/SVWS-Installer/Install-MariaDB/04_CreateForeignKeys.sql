--
-- Definition for foreign keys : 
--

ALTER TABLE K_AllgAdresse
ADD CONSTRAINT K_AllgAdresse_AdressArt_FK FOREIGN KEY (AllgAdrAdressArt) 
  REFERENCES K_Adressart (Bezeichnung) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE AllgAdrAnsprechpartner
ADD CONSTRAINT Ansprechpartner_Adr_FK FOREIGN KEY (Adresse_ID) 
  REFERENCES K_AllgAdresse (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Versetzung
ADD CONSTRAINT Versetzung_Lehrer_FK FOREIGN KEY (KlassenlehrerKrz) 
  REFERENCES K_Lehrer (Kuerzel) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE EigeneSchule_Abteilungen
ADD CONSTRAINT EigeneSchule_Abteilungen_Leiter_FK FOREIGN KEY (AbteilungsLeiter) 
  REFERENCES K_Lehrer (Kuerzel) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE EigeneSchule_Abt_Kl
ADD CONSTRAINT EigeneSchuleAbtKl_Abteilung_FK FOREIGN KEY (Abteilung_ID) 
  REFERENCES EigeneSchule_Abteilungen (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE EigeneSchule_Abt_Kl
ADD CONSTRAINT EigeneSchuleAbtKl_Klasse_FK FOREIGN KEY (Klasse) 
  REFERENCES Versetzung (Klasse) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE EigeneSchule_FachTeilleistungen
ADD CONSTRAINT EigeneSchule_FachTeilleistungen_Fach_FK FOREIGN KEY (Fach_ID) 
  REFERENCES EigeneSchule_Faecher (ID) 
  ON UPDATE NO ACTION
  ON DELETE CASCADE
;

ALTER TABLE Fachklassen_Schwerpunkte
ADD CONSTRAINT Fachklassen_Schwerpunkte_Fachkl_FK FOREIGN KEY (Fachklasse_ID) 
  REFERENCES EigeneSchule_Fachklassen (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Fachklassen_Schwerpunkte
ADD CONSTRAINT Fachklassen_Schwerpunkte_Schwerp_FK FOREIGN KEY (Schwerpunkt_ID) 
  REFERENCES K_Schwerpunkt (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE KursLehrer
ADD CONSTRAINT KursLehrer_Kurs_FK FOREIGN KEY (Kurs_ID) 
  REFERENCES Kurse (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE KursLehrer
ADD CONSTRAINT KursLehrer_Lehrer_FK FOREIGN KEY (Lehrer_ID) 
  REFERENCES K_Lehrer (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Lehrer_IMEI
ADD CONSTRAINT Lehrer_IMEI_Lehrer_FK FOREIGN KEY (Lehrer_ID) 
  REFERENCES K_Lehrer (ID) 
  ON UPDATE NO ACTION
  ON DELETE CASCADE
;

ALTER TABLE LehrerAbschnittsdaten
ADD CONSTRAINT LehrerAbschnitte_Lehrer_FK FOREIGN KEY (Lehrer_ID) 
  REFERENCES K_Lehrer (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE LehrerAnrechnung
ADD CONSTRAINT LehrerAnrechnung_Lehrer_FK FOREIGN KEY (Lehrer_ID) 
  REFERENCES K_Lehrer (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE LehrerEntlastung
ADD CONSTRAINT LehrerEntlastung_Lehrer_FK FOREIGN KEY (Lehrer_ID) 
  REFERENCES K_Lehrer (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE LehrerFunktionen
ADD CONSTRAINT LehrerFunktionen_Funktion_FK FOREIGN KEY (Funktion_ID) 
  REFERENCES K_Schulfunktionen (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE LehrerFunktionen
ADD CONSTRAINT LehrerFunktionen_Lehrer_FK FOREIGN KEY (Lehrer_ID) 
  REFERENCES K_Lehrer (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE LehrerLehramt
ADD CONSTRAINT LehrerLehramt_Lehrer_FK FOREIGN KEY (Lehrer_ID) 
  REFERENCES K_Lehrer (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE LehrerMehrleistung
ADD CONSTRAINT LehrerMehrleistung_Lehrer_FK FOREIGN KEY (Lehrer_ID) 
  REFERENCES K_Lehrer (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE NUES_Merkmale
ADD CONSTRAINT NUES_Merkmale_Kategorie_FK FOREIGN KEY (HauptKategorie) 
  REFERENCES NUES_Kategorien (KategorieKuerzel) 
  ON UPDATE CASCADE
  ON DELETE CASCADE
;

ALTER TABLE Schueler
ADD CONSTRAINT Schueler_Einschulungsart_FK FOREIGN KEY (Einschulungsart_ID) 
  REFERENCES K_EinschulungsArt (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Schueler
ADD CONSTRAINT Schueler_Fahrschueler_FK FOREIGN KEY (Fahrschueler_ID) 
  REFERENCES K_FahrschuelerArt (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Schueler
ADD CONSTRAINT Schueler_Foerderschwerpunkt_FK FOREIGN KEY (Foerderschwerpunkt_ID) 
  REFERENCES K_Foerderschwerpunkt (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Schueler
ADD CONSTRAINT Schueler_Haltestelle_FK FOREIGN KEY (Haltestelle_ID) 
  REFERENCES K_Haltestelle (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Schueler
ADD CONSTRAINT Schueler_Ort_FK FOREIGN KEY (PLZ) 
  REFERENCES K_Ort (PLZ) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Schueler
ADD CONSTRAINT Schueler_Ortsteil_FK FOREIGN KEY (Ortsteil_ID) 
  REFERENCES K_Ortsteil (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Schueler
ADD CONSTRAINT Schueler_Religion_FK FOREIGN KEY (Religion_ID) 
  REFERENCES K_Religion (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Schueler
ADD CONSTRAINT Schueler_Sportbefreiung_FK FOREIGN KEY (Sportbefreiung_ID) 
  REFERENCES K_Sportbefreiung (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Schueler
ADD CONSTRAINT Schueler_Staat_FK FOREIGN KEY (StaatKrz) 
  REFERENCES K_Staat (StatistikKrz) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Schueler
ADD CONSTRAINT Schueler_Versetzung_FK FOREIGN KEY (Klasse) 
  REFERENCES Versetzung (Klasse) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Schueler_AllgAdr
ADD CONSTRAINT SchuelerAllgAdr_Adresse_FK FOREIGN KEY (Adresse_ID) 
  REFERENCES K_AllgAdresse (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Schueler_AllgAdr
ADD CONSTRAINT SchuelerAllgAdr_Ansprech_FK FOREIGN KEY (Ansprechpartner_ID) 
  REFERENCES AllgAdrAnsprechpartner (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Schueler_AllgAdr
ADD CONSTRAINT SchuelerAllgAdr_Beschaeftigungsart_FK FOREIGN KEY (Vertragsart_ID) 
  REFERENCES K_BeschaeftigungsArt (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Schueler_AllgAdr
ADD CONSTRAINT SchuelerAllgAdr_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerAbgaenge
ADD CONSTRAINT SchuelerAbgaenge_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerAbiFaecher
ADD CONSTRAINT SchuelerAbiFaecher_Fach_FK FOREIGN KEY (Fach_ID) 
  REFERENCES EigeneSchule_Faecher (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerAbiFaecher
ADD CONSTRAINT SchuelerAbiFaecher_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerAbitur
ADD CONSTRAINT SchuelerAbitur_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerAnkreuzfloskeln
ADD CONSTRAINT SchuelerAKF_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE CASCADE
;

ALTER TABLE SchuelerBKAbschluss
ADD CONSTRAINT SchuelerBKAbschl_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerBKFaecher
ADD CONSTRAINT SchuelerBKFaecher_Fach_FK FOREIGN KEY (Fach_ID) 
  REFERENCES EigeneSchule_Faecher (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerBKFaecher
ADD CONSTRAINT SchuelerBKFaecher_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerEinzelleistungen
ADD CONSTRAINT SchuelerEL_Art_FK FOREIGN KEY (Art_ID) 
  REFERENCES K_Einzelleistungen (ID) 
  ON UPDATE NO ACTION
  ON DELETE CASCADE
;

ALTER TABLE SchuelerErzAdr
ADD CONSTRAINT SchuelerErzAdr_ErzieherArt_FK FOREIGN KEY (ErzieherArt_ID) 
  REFERENCES K_ErzieherArt (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerErzAdr
ADD CONSTRAINT SchuelerErzAdr_Ort_FK FOREIGN KEY (ErzPLZ) 
  REFERENCES K_Ort (PLZ) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerErzAdr
ADD CONSTRAINT SchuelerErzAdr_Ortsteil_FK FOREIGN KEY (ErzOrtsteil_ID) 
  REFERENCES K_Ortsteil (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerErzAdr
ADD CONSTRAINT SchuelerErzAdr_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerErzFunktion
ADD CONSTRAINT SchuelerErzFunktion_Erzieher_FK FOREIGN KEY (Erzieher_ID) 
  REFERENCES SchuelerErzAdr (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerErzFunktion
ADD CONSTRAINT SchuelerErzFunktion_Funktion_FK FOREIGN KEY (Funktion_ID) 
  REFERENCES K_ErzieherFunktion (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerLernabschnittsdaten
ADD CONSTRAINT SchuelerLernabschnittsdaten_Fachklasse_FK FOREIGN KEY (Fachklasse_ID) 
  REFERENCES EigeneSchule_Fachklassen (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerLernabschnittsdaten
ADD CONSTRAINT SchuelerLernabschnittsdaten_Foerderschwerpunkt_FK FOREIGN KEY (Foerderschwerpunkt_ID) 
  REFERENCES K_Foerderschwerpunkt (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerLernabschnittsdaten
ADD CONSTRAINT SchuelerLernabschnittsdaten_Jahrgang_FK FOREIGN KEY (Jahrgang_ID) 
  REFERENCES EigeneSchule_Jahrgaenge (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerLernabschnittsdaten
ADD CONSTRAINT SchuelerLernabschnittsdaten_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerFehlstunden
ADD CONSTRAINT SchuelerFehlstunden_Abschnitt_FK FOREIGN KEY (Abschnitt_ID) 
  REFERENCES SchuelerLernabschnittsdaten (ID) 
  ON UPDATE NO ACTION
  ON DELETE CASCADE
;

ALTER TABLE SchuelerFHR
ADD CONSTRAINT SchuelerFHR_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerFHRFaecher
ADD CONSTRAINT SchuelerFHRFaecher_Fach_FK FOREIGN KEY (Fach_ID) 
  REFERENCES EigeneSchule_Faecher (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerFHRFaecher
ADD CONSTRAINT SchuelerFHRFaecher_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerFoerderempfehlungen
ADD CONSTRAINT SchuelerFE_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE CASCADE
;

ALTER TABLE SchuelerFotos
ADD CONSTRAINT SchuelerFotos_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerLD_PSFachBem
ADD CONSTRAINT SchuelerLD_PSFachBem_Abschnitt_FK FOREIGN KEY (Abschnitt_ID) 
  REFERENCES SchuelerLernabschnittsdaten (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerLeistungsdaten
ADD CONSTRAINT SchuelerLeistungsdaten_Abschnitt_FK FOREIGN KEY (Abschnitt_ID) 
  REFERENCES SchuelerLernabschnittsdaten (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerLeistungsdaten
ADD CONSTRAINT SchuelerLeistungsdaten_Fach_FK FOREIGN KEY (Fach_ID) 
  REFERENCES EigeneSchule_Faecher (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerLeistungsdaten
ADD CONSTRAINT SchuelerLeistungsdaten_Kurs_FK FOREIGN KEY (Kurs_ID) 
  REFERENCES Kurse (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerListe_Inhalt
ADD CONSTRAINT SchuelerListeInhalt_Liste_FK FOREIGN KEY (Liste_ID) 
  REFERENCES SchuelerListe (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerListe_Inhalt
ADD CONSTRAINT SchuelerListeInhalt_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerMerkmale
ADD CONSTRAINT SchuelerMerkmale_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerNUESDaten
ADD CONSTRAINT SchuelerNUESDaten_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE CASCADE
;

ALTER TABLE SchuelerSprachenfolge
ADD CONSTRAINT SchuelerSprachenfolge_Fach_FK FOREIGN KEY (Fach_ID) 
  REFERENCES EigeneSchule_Faecher (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerSprachenfolge
ADD CONSTRAINT SchuelerSprachenfolge_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerTelefone
ADD CONSTRAINT SchuelerTelefone_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerTelefone
ADD CONSTRAINT SchuelerTelefone_Telefonart_FK FOREIGN KEY (TelefonArt_ID) 
  REFERENCES K_TelefonArt (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerVermerke
ADD CONSTRAINT SchuelerVermerke_Schueler_FK FOREIGN KEY (Schueler_ID) 
  REFERENCES Schueler (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerVermerke
ADD CONSTRAINT SchuelerVermerke_VermerkArt_FK FOREIGN KEY (VermerkArt_ID) 
  REFERENCES K_Vermerkart (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE SchuelerZuweisungen
ADD CONSTRAINT Zuweisungen_Abschnitt_FK FOREIGN KEY (Abschnitt_ID) 
  REFERENCES SchuelerLernabschnittsdaten (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Stundentafel_Faecher
ADD CONSTRAINT StundentafelFaecher_Faecher_FK FOREIGN KEY (Fach_ID) 
  REFERENCES EigeneSchule_Faecher (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

ALTER TABLE Stundentafel_Faecher
ADD CONSTRAINT StundentafelFaecher_Stdtafel_FK FOREIGN KEY (Stundentafel_ID) 
  REFERENCES Stundentafel (ID) 
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
;

