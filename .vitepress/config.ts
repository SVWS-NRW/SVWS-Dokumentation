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
						{ text: 'SVWS-Client', link: '/svws-client' },
						{ text: 'SVWS-AdminClient', link: '/adminclient' },
						{ text: '', items: [
							{ text: 'SVWS WebNotenManager (Beta)', link: '/wenom' },
							{ text: 'SVWS Konferenz (Beta)', link: '/svws_module/svws_konferenzuebersicht' },
							{ text: 'SVWS Prognos (Alpha)', link: '/svws_module/svws_prognos' },
							{ text: 'SVWS WebLuPO', link: '/weblupo' },
						] },
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
						{ text: 'APIs für externe Tools', link: '/development/ExterneAPIs/'},
						{ text: 'FAQs Development', link: '/development/FAQ/' },
						{ text: 'SVWS-Server bei GitHub', link: 'https://github.com/SVWS-NRW/SVWS-Server/' },
						{ text: ' ', items: [
							{ text: 'Projekte', link: '/projekte' },
						] },
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
						{ text: 'SVWS-AdminClient', link: '/adminclient' },
						{ text: 'Bedienungkonzept', link: '/adminclient/bedienkonzept/', collapsed: true},
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
							{ text: 'Eclipse', link: '/development/Entwicklungsumgebungen/Eclipse/' },
							{ text: 'IntelliJ', link: '/development/Entwicklungsumgebungen/IntelliJ/' },
							{ text: 'macOS', link: '/development/Entwicklungsumgebungen/macOS/' },
							{ text: 'VS-Code', link: '/development/Entwicklungsumgebungen/VS-Code/' },
							{ text: 'Coding Guidlines', link: '/development/Entwicklungsumgebungen/Coding-Guidlines' },
							{ text: 'Code Styles', link: '/development/Entwicklungsumgebungen/Code-Styles' },
						],
						},
						{ text: 'APIs für externe Tools', link: '/development/ExterneAPIs/' , collapsed: true, items: [
							{ text: 'Lernplattform Export', link: '/development/ExterneAPIs/Lernplattformen' },
						],
						},
						{ text: 'SVWS-Server bei GitHub', link: 'https://github.com/SVWS-NRW/SVWS-Server/' },
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
						{ text: 'Updates', link: '/deployment/UpdateSVWS' },
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
				'/svws_module/svws_konferenzuebersicht' : [
					{ text: '', items: [
						{ text: 'SVWS-Konferenzübersicht', link: '/svws_module/svws_konferenzuebersicht/',  collapsed: false, items: [
							{ text: 'Installation und Bereitstellung', link: '/svws_module/svws_konferenzuebersicht/installation.md' },
							{ text: 'Login (Offline und Online)', link: '/svws_module/svws_konferenzuebersicht/login.md' },
							{ text: 'Verwendung in der Konferenz', link: '/svws_module/svws_konferenzuebersicht/verwendung.md' },
							{ text: 'Fehlerbehebung', link: '/svws_module/svws_konferenzuebersicht/fehlerbehebung.md' },
							{ text: 'Hinweise zum Datenschutz', link: '/svws_module/svws_konferenzuebersicht/datenschutz.md' },
						] },
					] },
				],
				'/svws_module/svws_prognos' : [
					{ text: '', items: [
						{ text: 'SVWS Prognos', link: '/svws_module/svws_prognos/',  collapsed: false, items: [
							{ text: 'Installation und Bereitstellung', link: '/svws_module/svws_prognos/installation.md' },
							{ text: 'Verwendung und Aufbau', collapsed: false, items: [
								{ text: 'Verbindung mit dem Server', link: '/svws_module/svws_prognos/server_verbinden.md' },
								{ text: 'Übersicht Prognos [leer]' },
								{ text: 'Jahrgangsprognosen [leer]' },
								{ text: 'Manuelle Prognosen [leer]' },
							] } ,
							{ text: 'Begriffe, Konventionen und Fehlersuche' },
						] },
					] },
				],
				'/weblupo' : [
					{ text: '', items: [
						{ text: 'SVWS Weblupo', link: '/weblupo/' },
					] },
				],
				'/wenom' : [
					{ text: '', items: [
						{ text: 'SVWS WeNoM', link: '/wenom/index.md' },
						{ text: 'Benutzerhandbuch', link: '/wenom/benutzerhandbuch/index.md', collapsed: false, items: [
							{ text: 'Anleitung für Lehrkräfte', link: '/wenom/benutzerhandbuch/anleitung_lehrkraefte.md'},
							{ text: 'Einrichten der 2-Faktor-Authentifizierung', link: '/wenom/benutzerhandbuch/einrichtungZweiterFaktor.md' },
							{ text: 'Schulische Administration', link: '/wenom/benutzerhandbuch/schulische_administration.md'},
						] },
						{ text: 'Installation', link: '/wenom/installation/index.md', collapsed: false, items: [
							{ text: 'Installationsanleitung', link: '/wenom/installation/installation.md' },
							{ text: 'Ersteinrichtung', link: '/wenom/installation/ersteinrichtung.md' },
							{ text: 'Hosterspezifische Anleitungen',link: '/wenom/hoster_installation/', collapsed: false, items: [
								{ text: 'All-Inkl', link: '/wenom/hoster_installation/all-inkl.md' },
								{ text: 'Hosteurope', link: '/wenom/hoster_installation/hosteurope.md' },
								{ text: 'Strato', link: '/wenom/hoster_installation/strato.md' },
								{ text: 'Eigener Webserver', link: '/wenom/installation/installation_webserver.md' },
							] },
							{ text: 'mehrere Mandanten', link: '/wenom/installation/mehrereMandanten.md' },
						] },
						{ text: 'Geschäftsprozesse WeNoM', link: '/wenom/geschaeftsprozesse.md' },
					] },
				],
				'/svws-client': [
					{ text: '', items:
						[
							{ text: 'SVWS-Client', link: '/svws-client/', collapsed: false, items: [
								{ text: 'Supportkonzept', link: '/svws-client/dokumentationsartikel/supportkonzept/' },
								{ text: 'Bedienung im Browser', link: '/svws-client/dokumentationsartikel/' },
								{ text: 'Gruppenprozesse', link: '/svws-client/dokumentationsartikel/gruppenprozesse/' },
								{ text: 'Tastaturnavigation', link: '/svws-client/dokumentationsartikel/tastaturnavigation' },
								{ text: 'Änderungen', link: '/svws-client/dokumentationsartikel/änderungen/' },
							] },
							{ text: 'Apps', link: '/svws-client/apps/', collapsed: false, items: [
								{ text: 'Aktueller Benutzer', link: '/svws-client/apps/aktuellernutzer/' },
								{ text: 'Schule', link: '/svws-client/apps/schule/', collapsed: true, items: [
									{ text: 'Allgemein', link: '/svws-client/apps/schule/allgemein/stammdaten/', collapsed: true, items: [
										{ text: 'Stammdaten der Schule', link: '/svws-client/apps/schule/allgemein/stammdaten/' },
									] },
									{ text: 'Kataloge', link: '/svws-client/apps/schule/kataloge/', collapsed: true, items: [
										//{ text: 'Abteilungen', link: '/svws-client/apps/schule/kataloge/abteilungen/' },
										// Ankreuzkompetenzen
										{ text: 'Betriebe', link: '/svws-client/apps/schule/kataloge/betriebe/' },
										//{ text: 'Beschäftigungsarten', link: '/svws-client/apps/schule/kataloge/beschaeftigungsarten/' },
										{ text: 'Einwilligungsarten', link: '/svws-client/apps/schule/kataloge/einwilligungsarten/' },
										{ text: 'Entlassgründe', link: '/svws-client/apps/schule/kataloge/entlassgruende/' },
										{ text: 'Erzieherarten', link: '/svws-client/apps/schule/kataloge/erzieherarten/' },
										{ text: 'Fächer', link: '/svws-client/apps/schule/kataloge/faecher/' },
										{ text: 'Fahrschülerarten', link: '/svws-client/apps/schule/kataloge/fahrschuelerarten/' },
										//{ text: 'Floskelgrupppen', link: '/svws-client/apps/schule/kataloge/floskelgruppen/' },
										//{ text: 'Floskeln (Platzhalter???)', link: '/svws-client/apps/schule/kataloge/floskeln/' },
										//{ text: 'Förderschwerpunkte', link: '/svws-client/apps/schule/kataloge/foerderschwerpunkte/' },
										//{ text: 'Haltestellen', link: '/svws-client/apps/schule/kataloge/haltestellen/' },
										//{ text: 'Jahrgänge', link: '/svws-client/apps/schule/kataloge/jahrgaenge/' },
										{ text: 'Kindergärten', link: '/svws-client/apps/schule/kataloge/kindergaerten/' },
										{ text: 'Konfessionen', link: '/svws-client/apps/schule/kataloge/konfessionen/' },
										//{ text: 'Leitungsfunktionen', link: '/svws-client/apps/schule/kataloge/leitungsfunktionen/' },
										{ text: 'Lernplattformen', link: '/svws-client/apps/schule/kataloge/lernplattformen/' },
										{ text: 'Orte', link: '/svws-client/apps/schule/kataloge/orte/' },
										{ text: 'Ortsteile', link: '/svws-client/apps/schule/kataloge/ortsteile/' },
										//{ text: 'Schulen', link: '/svws-client/apps/schule/kataloge/schulen/' },
										//{ text: 'Teilleistungsarten', link: '/svws-client/apps/schule/kataloge/teilleistungsarten/' },
										//{ text: 'Telefonarten', link: '/svws-client/apps/schule/kataloge/telefonarten/' },
										{ text: 'Vermerkarten', link: '/svws-client/apps/schule/kataloge/vermerkarten/' },
									] },
									{ text: 'Datenaustausch', link: '/svws-client/apps/schule/datenaustausch/', collapsed: true, items: [
										//{ text: 'ENM Notenmanager (Todo)' },
										{ text: 'LuPO Laufbahnplanung', link: '/svws-client/apps/schule/datenaustausch/lupo/' },
										{ text: 'Kurs 42', link: '/svws-client/apps/schule/datenaustausch/kurs42/' },
										{ text: 'Untis', link: '/svws-client/apps/schule/datenaustausch/untis/' },
									] },
								] },
								{ text: 'Schüler', link: '/svws-client/apps/schueler/', collapsed: true, items: [
									{ text: 'Individualdaten', link: '/svws-client/apps/schueler/individualdaten/' },
									{ text: 'Sonstiges', link: '/svws-client/apps/schueler/sonstiges/', collapsed: true, items: [
										{ text: 'Vermerke', link: '/svws-client/apps/schueler/sonstiges/vermerke/' },
										{ text: 'Einwilligungen', link: '/svws-client/apps/schueler/sonstiges/einwilligungen/' },
										{ text: 'Lernplattformen', link: '/svws-client/apps/schueler/sonstiges/lernplattformen/' },
									] },
									{ text: 'Erziehungsberechtigte', link: '/svws-client/apps/schueler/erziehungsberechtigte/' },
									{ text: 'Betriebe', link: '/svws-client/apps/schueler/ausbildungsbetriebe/' },
									//{ text: 'Schulbesuch', link: '/svws-client/apps/schueler/schulbesuch/' },
									{ text: 'Lernabschnitte', link: '/svws-client/apps/schueler/lernabschnitte/', collapsed: true, items: [
										{ text: 'Allgemein', link: '/svws-client/apps/schueler/lernabschnitte/allgemein/' },
										{ text: 'Leistungsdaten', link: '/svws-client/apps/schueler/lernabschnitte/leistungsdaten/' },
										// { text: 'Förderempfehlungen', link: '/svws-client/apps/schueler/lernabschnitte/foerderempfehlungen/' },
									] },
									//{ text: 'KAoA', link: '/svws-client/apps/schueler/kaoa/' },
									{ text: 'Sprachen', link: '/svws-client/apps/schueler/sprachen/' },
									{ text: 'Laufbahnplanung Sek II', link: '/svws-client/apps/schueler/laufbahnplanung/' },
									{ text: 'Stundenplan', link: '/svws-client/apps/schueler/stundenplan/' },
								] },
								{ text: 'Lehrkräfte', link: '/svws-client/apps/lehrer/', collapsed: true, items: [
									{ text: 'Individualdaten', link: '/svws-client/apps/lehrer/individualdaten/' },
									{ text: 'Personaldaten', link: '/svws-client/apps/lehrer/personaldaten/' },
									//{ text: 'Unterricht', link: '/svws-client/apps/lehrer/unterricht/' },
									{ text: 'Stundenplan', link: '/svws-client/apps/lehrer/stundenplan/' },
								] },
								{ text: 'Klassen', link: '/svws-client/apps/klassen/klasse/', collapsed: true, items: [
									{ text: 'Klasse', link: '/svws-client/apps/klassen/klasse/' },
									{ text: 'Stundenplan', link: '/svws-client/apps/klassen/stundenplan/' },
								] },
								{ text: 'Kurse', link: '/svws-client/apps/kurse/' },
								{ text: 'Noten', link: '/svws-client/apps/noten/', collapsed: true, items: [
									{ text: 'Administration', link: '/svws-client/apps/noten/administration' },
									{ text: 'Noteneingabe', link: '/svws-client/apps/noten/noteneingabe' },
								] },
								{ text: 'Oberstufe', link: '/svws-client/apps/gost/', collapsed: true, items: [
									{ text: 'Fächer', link: '/svws-client/apps/gost/faecher/' },
									{ text: 'Beratung', link: '/svws-client/apps/gost/beratung/' },
									{ text: 'Laufbahnplanung', link: '/svws-client/apps/gost/laufbahn/' },
									{ text: 'Fachwahlen', link: '/svws-client/apps/gost/fachwahlen/' },
									{ text: 'Kursplanung', link: '/svws-client/apps/gost/kursplanung/', collapsed: true, items: [
										{ text: 'Beispiele, Infos, Tipps', link: '/svws-client/apps/gost/kursplanung/beispiele_weiteres.md' },
									] },
									{ text: 'Klausurplanung', link: '/svws-client/apps/gost/klausurplanung/' },
								] },
								{ text: 'Statistik', link: '/svws-client/apps/statistik/' }, //, collapsed: true, items: [
								//	{ text: 'Verschlüsselung ', link: '/svws-client/apps/statistik/verschluesselung/' },
								//	{ text: 'Datenprüfung', link: '/svws-client/apps/statistik/datenpruefung/' },
								//	{ text: 'Dokumente', link: '/svws-client/apps/statistik/dokumente/' },
								//	{ text: 'Hilfe', link: '/svws-client/apps/statistik/hilfe/' },
								//] },
								{ text: 'Stundenplan', link: '/svws-client/apps/stundenplan/stundenplan_basisinformationen/', collapsed: true, items: [
									{ text: 'Grundlagen zum Stundenplan', link: '/svws-client/apps/stundenplan/stundenplan_basisinformationen/' },
									{ text: 'Stundenpläne erstellen/bearbeiten', link: '/svws-client/apps/stundenplan/stundenplan_anleitung/' },
									{ text: 'Allgemeine Vorlagen', link: '/svws-client/apps/stundenplan/allgemeine_vorlagen/', collapsed: true, items: [
										{ text: 'Aufsichtsbereiche', link: '/svws-client/apps/stundenplan/allgemeine_vorlagen/aufsichtsbereiche/' },
										{ text: 'Pausenzeiten', link: '/svws-client/apps/stundenplan/allgemeine_vorlagen/pausenzeiten/' },
										{ text: 'Räume', link: '/svws-client/apps/stundenplan/allgemeine_vorlagen/raeume/' },
										{ text: 'Zeitraster', link: '/svws-client/apps/stundenplan/allgemeine_vorlagen/zeitraster/' },
									] },
								] },
								{ text: 'Einstellungen', link: '/svws-client/apps/einstellungen/', collapsed: true, items: [
									{ text: 'Benutzer', link: '/svws-client/apps/einstellungen/benutzer/' },
									{ text: 'Benutzergruppen', link: '/svws-client/apps/einstellungen/benutzergruppen/' },
								] },
							] },
							{ text: 'Anleitungen', link: '/svws-client/anleitungen/', collapsed: false, items: [
								{ text: 'Allgemeine Anleitungen', link: '/svws-client/anleitungen/anleitungen_allgemein/', collapsed: true, items: [
									{ text: 'Anmeldung', link: '/svws-client/anleitungen/anleitungen_allgemein/anmeldung/' },
									{ text: 'Schulbescheinigung drucken', link: '/svws-client/anleitungen/anleitungen_allgemein/drucken_schulbescheinigung/' },
								] },
								{ text: 'Schulformspezifisch', link: '/svws-client/anleitungen/anleitungen_schulform/', collapsed: true, items: [
									{ text: 'Oberstufe', link: '/svws-client/anleitungen/anleitungen_schulform/anleitungen_gost/', collapsed: true, items: [
										{ text: 'WebLuPO (Schulintern)', link: '/svws-client/anleitungen/anleitungen_schulform/anleitungen_gost/weblupo/' },
									] },
									// { text: 'Grundschule', link: '/svws-client/anleitungen/anleitungen_schulform/anleitungen_gs/' },
								] },
								{ text: 'Zeugnisvorbereitung', link: '/svws-client/anleitungen/anleitungen_zeugnisse/' },
							] },
							//{ text: 'Weiteres', link: '/svws-client/weiteres/', collapsed: false, items: [
							//	{ text: 'Adressbücher', link: '/svws-client/kommunikationsschnittstelle/adressbuecher/' },
							//	{ text: 'Kalender', link: '/svws-client/kommunikationsschnittstelle/kalender/' },
							//] },
						],
					},
				],
			},
		},
	}
})
