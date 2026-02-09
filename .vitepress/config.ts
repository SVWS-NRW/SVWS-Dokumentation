import { defineConfig, loadEnv } from 'vite'

// https://vitepress.dev/reference/site-config
export default defineConfig(({ mode }) => {
	const env = loadEnv(mode, process.cwd(), '');
	return {
		// eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
		base: env.BASE === undefined ? '/SVWS-Dokumentation/' : env.BASE,
		title: 'SVWS Dokumentation',
		description: 'Dokumentation SVWS-Server NRW, Installation und Entwicklung',
		lastUpdated: true,
		themeConfig: {
			outline: {
				label: 'Auf dieser Seite',
			},
			docFooter: {
				next: 'Nächste Seite',
				prev: 'Vorherige Seite',
			},
			lastUpdated: {
				text: 'Diese Seite wurde zuletzt bearbeitet am',
				formatOptions: {
					dateStyle: 'full',
					timeStyle: 'medium',
				},
			},
			search: {
				provider: 'local',
			},
			nav: [
				{
					text: 'Benutzerhandbücher',
					items: [
						{ text: 'SVWS-Webclient', link: '/webclient' },
						{ text: 'SVWS-Adminclient', link: '/adminclient' },
						{ text: 'WebNotenManager (Alpha)', link: '/wenom' },
						{ text: 'Laufbahnplanung SII mit WebLuPO', link: '/weblupo' },
					] },
				{ text: 'Administration',
					items: [
						{ text: 'Installation', link: '/deployment' },
						{ text: 'FAQ', link: '/deployment/FAQ.md' },
						{ text: 'Roadmap', link: '/deployment/roadmap.md' },
					] },

				{ text: 'Entwicklung',
					items: [
						{ text: 'SVWS-Server', link: '/development/SVWS-Server/'},
						{ text: 'Entwicklungsumgebungen', link: '/development/Entwicklungsumgebungen/'},
						{ text: 'Tailwind 4', link: '/development/Tailwind-4/' },
						{ text: 'Gradle', link: '/development/Gradle/' },
						{ text: 'APIs für externe Tools', link: '/development/ExterneAPIs/'},
						{ text: 'UI-Bibliothek', link: 'https://ui.svws-nrw.de' },
						{ text: 'FAQs Development', link: '/development/FAQ/' },
						{ text: ' ', items:[]},
						{ text: 'Projekte', link: '/projekte' },
						{ text: 'Mitarbeit', link: '/teamarbeit' },
						{ text: 'Schulungen', link: '/schulungen' },
					] },
			],
			socialLinks: [
				{ icon: 'github', link: 'https://github.com/SVWS-NRW/SVWS-Dokumentation' },
			],
			sidebar: {
				'/adminclient': [
					{ text: '', items: [
						{ text: 'SVWS-Adminclient', link: '/adminclient' },
						{ text: 'Bedienungkonzept', link: '/adminclient/client/', collapsed: true},
						{ text: 'Apps', link: '/adminclient/apps/', collapsed: false, items: [
							{ text: 'Schemata', link: '/adminclient/apps/schemata/' },
							{ text: 'Konfiguration', link: '/adminclient/apps/konfiguration' },
						] },
					] },
				],
				'/schulungen': [
					{ text: '', items: [
						{ text: 'Schulungen', link: '/schulungen/' },
					] },
				],
				'/teamarbeit': [
					{ text: '', items: [
						{ text: 'Teamarbeit', link: '/teamarbeit/', collapsed: false, items: [
							{ text: 'Git Workflow', link: '/teamarbeit/workflow/' },
						] },
					] },
				],
				'/projekte': [
					{ text: '', items: [
						{ text: 'Projekte', link: '/projekte/', collapsed: false, items: [
							{ text: 'WeNoM', link: '/wenom/' },
							{ text: 'ASD-Statistik', link: '/projekte/ASD-Statistik/' },
							{ text: 'Schulbewerbung.de', link: '/projekte/Schulbewerbung.de/' },
							{ text: 'xSchule', link: '/projekte/xSchule/' },
						] },
					] },
				],
				'/development': [
					{ text: '', items: [
						{ text: 'SVWS-Server', link: '/development/SVWS-Server/', collapsed: true, items: [
							{ text: 'svws-core', link: '/development/SVWS-Server/svws-core/' },
							{ text: 'svws-db', link: '/development/SVWS-Server/svws-db/' },
							{ text: 'svws-db-utils', link: '/development/SVWS-Server/svws-db-utils/' },
							{ text: 'svws-module-dav-api', link: '/development/SVWS-Server/svws-module-dav-api/', collapsed: true, items: [
								{ text: 'Beschreibung CalDav', link: 'development/SVWS-Server/svws-module-dav-api/CalDav-Anwender-Doku' },
								{ text: 'CalDav Limitierungen', link: '/development/SVWS-Server/svws-module-dav-api/caldav-limitierungen' },
								{ text: 'Beschreibung CardDav', link: '/development/SVWS-Server/svws-module-dav-api/carddav-beschreibung der implementierung' },
								{ text: 'CardDav Limitierungen', link: '/development/SVWS-Server/svws-module-dav-api/carddav-limitierungen' },
							] },
							{ text: 'svws-openapi', link: '/development/SVWS-Server/svws-openapi/' },
							{ text: 'svws-server-app', link: '/development/SVWS-Server/svws-server-app/' },
							{ text: 'svws-transpile', link: '/development/SVWS-Server/svws-transpile/' },
						] },
						{ text: 'Entwicklungsumgebungen', link: '/development/Entwicklungsumgebungen/', collapsed: true, items: [
							{ text: 'Eclipse-Ubuntu', link: '/development/Entwicklungsumgebungen/Eclipse-Ubuntu/' },
							{ text: 'Eclipse-Ubuntu (Docker)', link: '/development/Entwicklungsumgebungen/Eclipse-Ubuntu/ubuntu_docker' },
							{ text: 'Eclipse-Windows', link: '/development/Entwicklungsumgebungen/Eclipse-Windows/' },
							{ text: 'IntelliJ', link: '/development/Entwicklungsumgebungen/IntelliJ/' },
							{ text: 'macOS', link: '/development/Entwicklungsumgebungen/macOS/' },
							{ text: 'VS-Code', link: '/development/Entwicklungsumgebungen/VS-Code/' },
							{ text: 'Coding Guidlines', link: '/development/Entwicklungsumgebungen/Coding-Guidlines' },
							{ text: 'Code Styles', link: '/development/Entwicklungsumgebungen/Code-Styles' },
						],
						},
						{ text: 'Tailwind 4', link: '/development/Tailwind-4/' },
						{ text: 'Gradle', link: '/development/Gradle/' },
						{ text: 'APIs für externe Tools', link: '/development/ExterneAPIs/' , collapsed: true, items: [
							{ text: 'Lernplattform Export', link: '/development/ExterneAPIs/Lernplattformen' },
						],
						},
						{ text: 'UI-Bibliothek', link: 'https://ui.svws-nrw.de' },
						{ text: 'FAQs Development', link: '/development/FAQ/' },
					] },
				],
				'/deployment': [
					{ text: '', items: [
						{ text: 'Übersicht', link: '/deployment/' },
						{ text: 'IT-Umgebungen', link: '/deployment/IT-Umgebungen/' },
						{ text: 'Installationsmethoden', link: '/deployment/installationsmethoden.md', collapsed: false, items: [
							{ text: 'Linux-Installer', link: '/deployment/Linux-Installer/' },
							{ text: 'Docker-Container', link: '/deployment/Docker/' },
							{ text: 'NAS', link: '/deployment/NAS/' },
							{ text: 'Windows-Installer', link: '/deployment/Windows-Installer/' },
//							{ text: 'Testserver', link: '/deployment/Testserver/' },
						] },
						{ text: 'Einrichtung', link: '/deployment/Einrichtung/' },
						{ text: 'Datenmigration', link: '/deployment/Datenmigration/' },
						{ text: 'Datensicherung', link: '/deployment/Datensicherung/' },
						{ text: 'Schulungsserver', link: '/deployment/Schulungsserver/', collapsed: true, items: [
							{ text: 'SchulungsClient', link: '/deployment/Schulungsserver/SchulungsClient/' },
							{ text: 'Docker SchulungsServer', link: '/deployment/Schulungsserver/Docker_Schulungsserver/' },
							{ text: 'Proxmox SchulungsServer', link: '/deployment/Schulungsserver/Proxmox_Schulungsserver/' },
						] },
						{ text: 'SchILD-NRW-3', link: '/deployment/Schild-NRW3/' },
						{ text: 'FAQ', link: '/deployment/FAQ.md' },
						{ text: 'Roadmap', link: '/deployment/roadmap.md' },
					] },
				],
				'/weblupo' : [
					{ text: '', items: [
						{ text: 'Weblupo', link: '/weblupo/' },
					] },
				],
				'/wenom' : [
					{ text: '', items: [
						{ text: 'WeNoM', link: '/wenom/index.md' },
						{ text: 'Technische Installation', collapsed: false, items: [
							{ text: 'Installation', link: '/wenom/installation/1_installation.md' },
							{ text: 'Ersteinrichtung', link: '/wenom/installation/2_ersteinrichtung.md' },
							{ text: 'Mehrere Mandanten', link: '/wenom/installation/3_mehrereMandanten_Beispiel.md' },
							{ text: 'Skript zur Testinstallation', link: '/wenom/installation/4_testinstall_script.md' },
						] },
						{ text: 'Benutzerhandbuch Schule', collapsed: false, items: [
							{ text: 'Schulische Einrichtung', link: '/wenom/benutzerhandbuch/1_erstinstallation_synchronisation.md'},
							{ text: 'Leistungsdaten eintragen', link: '/wenom/benutzerhandbuch/2_leistungsdaten_lehrkraefte.md'},
						] },
						{ text: 'Geschäftsprozesse WeNoM', link: '/wenom/geschaeftsprozesse.md' },
					] },
				],
				'/webclient': [
					{ text: '', items:
						[
							{ text: 'SVWS-Webclient', link: '/webclient/', collapsed: false, items: [
								{ text: 'Supportkonzept', link: '/webclient/client/supportkonzept/' },
								{ text: 'Bedienung im Browser', link: '/webclient/client/', collapsed: false },
								{ text: 'Tastaturnavigation', link: '/webclient/client/tastaturnavigation' },
								{ text: 'Änderungen', link: '/webclient/client/änderungen/' },
							] },
							{ text: 'Apps', link: '/webclient/apps/', collapsed: false, items: [
								{ text: 'Aktueller Benutzer', link: '/webclient/apps/aktuellernutzer/' },
								{ text: 'Schule', link: '/webclient/apps/schule/', collapsed: true, items: [
									{ text: 'Allgemein', link: '/webclient/apps/schule/allgemein/stammdaten/', collapsed: true, items: [
										{ text: 'Stammdaten der Schule', link: '/webclient/apps/schule/allgemein/stammdaten/' },
									] },
									{ text: 'Kataloge', link: '/webclient/apps/schule/kataloge/', collapsed: true, items: [
										//{ text: 'Abteilungen', link: '/webclient/apps/schule/kataloge/abteilungen/' },
										{ text: 'Betriebe', link: '/webclient/apps/schule/kataloge/betriebe/' },
										//{ text: 'Beschäftigungsarten', link: '/webclient/apps/schule/kataloge/beschaeftigungsarten/' },
										{ text: 'Einwilligungsarten', link: '/webclient/apps/schule/kataloge/einwilligungsarten/' },
										{ text: 'Entlassgründe', link: '/webclient/apps/schule/kataloge/entlassgruende/' },
										{ text: 'Erzieherarten', link: '/webclient/apps/schule/kataloge/erzieherarten/' },
										{ text: 'Fächer', link: '/webclient/apps/schule/kataloge/faecher/' },
										{ text: 'Fahrschülerarten', link: '/webclient/apps/schule/kataloge/fahrschuelerarten/' },
										//{ text: 'Floskelgrupppen', link: '/webclient/apps/schule/kataloge/floskelgruppen/' },
										//{ text: 'Floskeln (Platzhalter???)', link: '/webclient/apps/schule/kataloge/floskeln/' },
										//{ text: 'Förderschwerpunkte', link: '/webclient/apps/schule/kataloge/foerderschwerpunkte/' },
										//{ text: 'Haltestellen', link: '/webclient/apps/schule/kataloge/haltestellen/' },
										//{ text: 'Jahrgänge', link: '/webclient/apps/schule/kataloge/jahrgaenge/' },
										{ text: 'Kindergärten', link: '/webclient/apps/schule/kataloge/kindergaerten/' },
										{ text: 'Konfessionen', link: '/webclient/apps/schule/kataloge/konfessionen/' },
										//{ text: 'Lernplattformen', link: '/webclient/apps/schule/kataloge/lernplattformen/' },
										{ text: 'Orte', link: '/webclient/apps/schule/kataloge/orte/' },
										{ text: 'Ortsteile', link: '/webclient/apps/schule/kataloge/ortsteile/' },
										//{ text: 'Schulen', link: '/webclient/apps/schule/kataloge/schulen/' },
										//{ text: 'Telefonarten', link: '/webclient/apps/schule/kataloge/telefonarten/' },
										{ text: 'Vermerkarten', link: '/webclient/apps/schule/kataloge/vermerkarten/' },
									] },
									{ text: 'Datenaustausch', link: '/webclient/apps/schule/datenaustausch/', collapsed: true, items: [
										//{ text: 'ENM Notenmanager (Todo)' },
										{ text: 'LuPO Laufbahnplanung', link: '/webclient/apps/schule/datenaustausch/lupo/' },
										{ text: 'Kurs 42', link: '/webclient/apps/schule/datenaustausch/kurs42/' },
										{ text: 'Untis', link: '/webclient/apps/schule/datenaustausch/untis/' },
									] },
								] },
								{ text: 'Schüler', link: '/webclient/apps/schueler/', collapsed: true, items: [
									{ text: 'Individualdaten', link: '/webclient/apps/schueler/individualdaten/' },
									// { text: 'Sonstiges', link: '/webclient/apps/schueler/sonstiges/', collapsed: true, items: [
									//	{ text: 'Vermerke', link: '/webclient/apps/schueler/sonstiges/vermerke/' },
									//	{ text: 'Einwilligungen', link: '/webclient/apps/schueler/sonstiges/einwilligungen/' },
									//	{ text: 'Lernplattformen', link: '/webclient/apps/schueler/sonstiges/lernplattformen/' },
									// ] },
									//{ text: 'Erziehungsberechtigte', link: '/webclient/apps/schueler/erziehungsberechtigte/' },
									//{ text: 'Ausbildungsbetriebe', link: '/webclient/apps/schueler/ausbildungsbetriebe/' },
									//{ text: 'Schulbesuch', link: '/webclient/apps/schueler/schulbesuch/' },
									{ text: 'Lernabschnitte', link: '/webclient/apps/schueler/lernabschnitte/', collapsed: true, items: [
										{ text: 'Allgemein', link: '/webclient/apps/schueler/lernabschnitte/allgemein/' },
										{ text: 'Leistungsdaten', link: '/webclient/apps/schueler/lernabschnitte/leistungsdaten/' },
										// { text: 'Förderempfehlungen', link: '/webclient/apps/schueler/lernabschnitte/foerderempfehlungen/' },
									] },
									//{ text: 'KAoA', link: '/webclient/apps/schueler/kaoa/' },
									{ text: 'Sprachen', link: '/webclient/apps/schueler/sprachen/' },
									{ text: 'Laufbahnplanung Sek II', link: '/webclient/apps/schueler/laufbahnplanung/' },
									{ text: 'Stundenplan', link: '/webclient/apps/schueler/stundenplan/' },
								] },
								{ text: 'Lehrkräfte', link: '/webclient/apps/lehrer/', collapsed: true, items: [
									{ text: 'Individualdaten', link: '/webclient/apps/lehrer/individualdaten/' },
									//{ text: 'Personaldaten', link: '/webclient/apps/lehrer/personaldaten/' },
									//{ text: 'Unterricht', link: '/webclient/apps/lehrer/unterricht/' },
									{ text: 'Stundenplan', link: '/webclient/apps/lehrer/stundenplan/' },
								] },
								{ text: 'Klassen', link: '/webclient/apps/klassen/klasse/', collapsed: true, items: [
									{ text: 'Klasse', link: '/webclient/apps/klassen/klasse/' },
									{ text: 'Stundenplan', link: '/webclient/apps/klassen/stundenplan/' },
								] },
								{ text: 'Kurse', link: '/webclient/apps/kurse/' },
								//{ text: 'Noten', link: '/webclient/apps/noten/', collapsed: true, items: [
								//	{ text: 'Administration', collapsed: false, items: [
								//		{ text: 'Serververbindungen', link: '/webclient/apps/noten/serververbindungen/' },
								//		{ text: 'Zugangsdaten', link: '/webclient/apps/noten/zugangsdaten/' },
								//	] },
								//	{ text: 'Noteneingabe', collapsed: false, items: [
								//		{ text: 'Leistungsdaten', link: '/webclient/apps/noten/leistungsdaten/' },
								//		{ text: 'Teilleistungen', link: '/webclient/apps/noten/teilleistungen/' },
								//		{ text: 'Klassenleitung', link: '/webclient/apps/noten/klassenleitung/' },
								//	] },
								//] },
								{ text: 'Oberstufe', link: '/webclient/apps/gost/', collapsed: true, items: [
									{ text: 'Fächer', link: '/webclient/apps/gost/faecher/' },
									{ text: 'Beratung', link: '/webclient/apps/gost/beratung/' },
									{ text: 'Laufbahnplanung', link: '/webclient/apps/gost/laufbahn/' },
									{ text: 'Fachwahlen', link: '/webclient/apps/gost/fachwahlen/' },
									{ text: 'Kursplanung', link: '/webclient/apps/gost/kursplanung/' },
									{ text: 'Klausurplanung', link: '/webclient/apps/gost/klausurplanung/' },
								] },
								{ text: 'Statistik', link: '/webclient/apps/statistik/' }, //, collapsed: true, items: [
								//	{ text: 'Verschlüsselung ', link: '/webclient/apps/statistik/verschluesselung/' },
								//	{ text: 'Datenprüfung', link: '/webclient/apps/statistik/datenpruefung/' },
								//	{ text: 'Dokumente', link: '/webclient/apps/statistik/dokumente/' },
								//	{ text: 'Hilfe', link: '/webclient/apps/statistik/hilfe/' },
								//] },
								{ text: 'Stundenplan', link: '/webclient/apps/stundenplan/stundenplan_basisinformationen/', collapsed: true, items: [
									{ text: 'Grundlagen zum Stundenplan', link: '/webclient/apps/stundenplan/stundenplan_basisinformationen/' },
									{ text: 'Stundenpläne erstellen/bearbeiten', link: '/webclient/apps/stundenplan/stundenplan_anleitung/' },
									{ text: 'Allgemeine Vorlagen', link: '/webclient/apps/stundenplan/allgemeine_vorlagen/', collapsed: true, items: [
										{ text: 'Aufsichtsbereiche', link: '/webclient/apps/stundenplan/allgemeine_vorlagen/aufsichtsbereiche/' },
										{ text: 'Pausenzeiten', link: '/webclient/apps/stundenplan/allgemeine_vorlagen/pausenzeiten/' },
										{ text: 'Räume', link: '/webclient/apps/stundenplan/allgemeine_vorlagen/raeume/' },
										{ text: 'Zeitraster', link: '/webclient/apps/stundenplan/allgemeine_vorlagen/zeitraster/' },
									] },
								] },
								{ text: 'Einstellungen', link: '/webclient/apps/einstellungen/', collapsed: true, items: [
									{ text: 'Benutzer (Anzupassen)', link: '/webclient/apps/einstellungen/benutzer/' },
									{ text: 'Benutzergruppen (Anzupassen)', link: '/webclient/apps/einstellungen/benutzergruppen/' },
								] },
							] },
							{ text: 'Anleitungen', link: '/webclient/anleitungen/', collapsed: false, items: [
								{ text: 'Allgemeine Anleitungen', link: '/webclient/anleitungen/anleitungen_allgemein/', collapsed: true, items: [
									{ text: 'Anmeldung', link: '/webclient/anleitungen/anleitungen_allgemein/anmeldung/' },
									{ text: 'Schulbescheinigung drucken', link: '/webclient/anleitungen/anleitungen_allgemein/drucken_schulbescheinigung/' },
								] },
								{ text: 'Schulformspezifisch', link: '/webclient/anleitungen/anleitungen_schulform/', collapsed: true, items: [
									{ text: 'Oberstufe', link: '/webclient/anleitungen/anleitungen_schulform/anleitungen_gost/', collapsed: true, items: [
										{ text: 'WebLuPO (Schulintern)', link: '/webclient/anleitungen/anleitungen_schulform/anleitungen_gost/weblupo/' },
									] },
									// { text: 'Grundschule', link: '/webclient/anleitungen/anleitungen_schulform/anleitungen_gs/' },
								] },
								{ text: 'Zeugnisvorbereitung', link: '/webclient/anleitungen/anleitungen_zeugnisse/' },
							] },
							{ text: 'Weiteres', link: '/webclient/weiteres/', collapsed: false, items: [
								{ text: 'JSON-Dateien', link: '/webclient/weiteres/json_files/' },
								{ text: 'Adressbücher', link: '/webclient/kommunikationsschnittstelle/adressbuecher/' },
								{ text: 'Kalender', link: '/webclient/kommunikationsschnittstelle/kalender/' },
							] },
						],
					},
				],
			},
		},
	}
})
