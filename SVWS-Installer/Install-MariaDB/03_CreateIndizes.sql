--
-- Definition for indices : 
--

CREATE UNIQUE INDEX K_Adressart_IDX1 ON K_Adressart (Bezeichnung);

CREATE UNIQUE INDEX K_Lehrer_IDX1 ON K_Lehrer(Kuerzel);

CREATE UNIQUE INDEX Versetzung_IDX1 ON Versetzung(Klasse);

CREATE UNIQUE INDEX EigeneSchule_Fachklassen_IDX1 ON EigeneSchule_Fachklassen(BKIndexTyp, FKS, AP);

CREATE UNIQUE INDEX EigeneSchule_Faecher_IDX1 ON EigeneSchule_Faecher(FachKrz);

CREATE UNIQUE INDEX EigeneSchule_Jahrgaenge_IDX1 ON EigeneSchule_Jahrgaenge(InternKrz);

CREATE UNIQUE INDEX EigeneSchule_Kursart_IDX1 ON EigeneSchule_Kursart(Kursart, KursartAllg);

CREATE UNIQUE INDEX EigeneSchule_KursartAllg_IDX1 ON EigeneSchule_KursartAllg(KursartAllg);

CREATE UNIQUE INDEX EigeneSchule_Schulformen_IDX1 ON EigeneSchule_Schulformen(SGL);

CREATE UNIQUE INDEX EigeneSchule_Zertifikate_IX1 ON EigeneSchule_Zertifikate(SchulnrEigner, Kuerzel);

CREATE UNIQUE INDEX K_Schwerpunkt_IDX1 ON K_Schwerpunkt(Bezeichnung);

CREATE UNIQUE INDEX K_BeschaeftigungsArt_IDX1 ON K_BeschaeftigungsArt(Bezeichnung);

CREATE UNIQUE INDEX K_EinschulungsArt_IDX1 ON K_EinschulungsArt(Bezeichnung);

CREATE UNIQUE INDEX K_EntlassGrund_IDX1 ON K_EntlassGrund(Bezeichnung);

CREATE UNIQUE INDEX K_ErzieherArt_IDX1 ON K_ErzieherArt(Bezeichnung);

CREATE UNIQUE INDEX K_ErzieherFunktion_IDX1 ON K_ErzieherFunktion(Bezeichnung);

CREATE UNIQUE INDEX K_FahrschuelerArt_IDX1 ON K_FahrschuelerArt(Bezeichnung);

CREATE UNIQUE INDEX K_Foerderschwerpunkt_IDX1 ON K_Foerderschwerpunkt(Bezeichnung);

CREATE UNIQUE INDEX K_Haltestelle_IDX1 ON K_Haltestelle(Bezeichnung);

CREATE UNIQUE INDEX K_KlassenOrgForm_IDX1 ON K_KlassenOrgForm(Bezeichnung);

CREATE UNIQUE INDEX K_Ort_IDX1 ON K_Ort(PLZ);

CREATE UNIQUE INDEX K_Ortsteil_IDX1 ON K_Ortsteil(Bezeichnung);

CREATE UNIQUE INDEX K_Religion_IDX1 ON K_Religion(Bezeichnung);

CREATE UNIQUE INDEX K_Schule_IDX1 ON K_Schule(SchulNr);

CREATE UNIQUE INDEX K_Sportbefreiung_IDX1 ON K_Sportbefreiung(Bezeichnung);

CREATE UNIQUE INDEX K_Staat_IDX1 ON K_Staat(StatistikKrz);

CREATE UNIQUE INDEX K_TelefonArt_IDX1 ON K_TelefonArt(Bezeichnung);

CREATE UNIQUE INDEX K_Vermerkart_IDX1 ON K_Vermerkart(Bezeichnung);

CREATE UNIQUE INDEX Kurse_IDX1 ON Kurse(Jahr, Abschnitt, KurzBez, Fach_ID, ASDJahrgang, Jahrgaenge, KursartAllg, Wochenstd, LehrerKrz);

CREATE UNIQUE INDEX SchildFilter_IDX1 ON SchildFilter(Name);

CREATE UNIQUE INDEX Schueler_IDX1 ON Schueler(GU_ID);

CREATE INDEX Schueler_AllgAdr_IDX1 ON Schueler_AllgAdr(Schueler_ID);

CREATE UNIQUE INDEX SchuelerAbgaenge_IDX1 ON SchuelerAbgaenge(Schueler_ID, LSSchulEntlassDatum);

CREATE UNIQUE INDEX SchuelerAbitur_IDX1 ON SchuelerAbitur(Schueler_ID);

CREATE INDEX SchuelerErzAdr_IDX1 ON SchuelerErzAdr(Schueler_ID);

CREATE UNIQUE INDEX SchuelerLernabschnittsdaten_IDX1 ON SchuelerLernabschnittsdaten(Schueler_ID, Jahr, Abschnitt, Bildungsgang, WechselNr);

CREATE UNIQUE INDEX SchuelerFHR_IDX1 ON SchuelerFHR(Schueler_ID);

CREATE UNIQUE INDEX SchuelerLeistungsdaten_IDX2 ON SchuelerLeistungsdaten(Abschnitt_ID, Fach_ID, Kursart, Kurs_ID);

CREATE UNIQUE INDEX SchuelerListe_IDX1 ON SchuelerListe(Bezeichnung);

CREATE UNIQUE INDEX SchuelerSprachenfolge_IDX1 ON SchuelerSprachenfolge(Schueler_ID, Fach_ID);

CREATE INDEX SchuelerTelefone_IDX1 ON SchuelerTelefone(Schueler_ID);

CREATE INDEX SchuelerVermerke_IDX1 ON SchuelerVermerke(Schueler_ID);

CREATE UNIQUE INDEX Stundentafel_Faecher_IDX1 ON Stundentafel_Faecher(Stundentafel_ID, Fach_ID);

CREATE UNIQUE INDEX Usergroups_IX1 ON Usergroups(UG_Bezeichnung);

CREATE UNIQUE INDEX Users_IX1 ON Users(US_LoginName);

