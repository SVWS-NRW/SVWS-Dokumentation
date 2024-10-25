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
				prev: 'Vorherige Seite'
			},
			lastUpdated: {
				text: 'Diese Seite wurde zuletzt bearbeitet am',
				formatOptions: {
					dateStyle: 'full',
					timeStyle: 'medium'
				}
			},
			search: {
				provider: 'local',
			},
			nav: [
				{
					text: 'Benutzerhandbücher',
					items: [
						{ text: 'SVWS-Client', link: '/client' },
						{ text: 'Laufbahnplanung', link: '/laufbahnplanung' }
					]
				},
				{ text: 'Administration/Entwicklung', 
					items: [
						{ text: 'Installation (Todo)', link: '/deployment' },  //Hier Hook für Deployment (test) 
						{ text: 'Administration/Entwicklung', link: '/admin'},
						{ text: 'Admin-Client', link: '/adminclient' }
			 		]
				},
				{ text: 'UI-Bibliothek', link: 'https://ui.svws-nrw.de' },
				{ text: 'Java-API', link: 'https://javadoc.svws-nrw.de' },
			],
			socialLinks: [
				{ icon: 'github', link: 'https://github.com/SVWS-NRW/SVWS-Dokumentation' }
			],
			sidebar: {
				'/adminclient': [
					{ text: '', items: [
						{ text: 'Adminclient', link: '/adminclient/' },
						{ text: 'Administration', link: '/adminclient/administration' },
					]
					},
				],
				'/admin': [
					{ text: '', items: [
						{ text: 'SVWS-Server', link: '/admin/SVWS-Server/', collapsed: true, items: [
							{ text: 'svws-core', link: '/admin/SVWS-Server/svws-core/' },
							{ text: 'svws-db', link: '/admin/SVWS-Server/svws-db/' },
							{ text: 'svws-db-utils', link: '/admin/SVWS-Server/svws-db-utils/' },
							{ text: 'svws-module-dav-api', link: '/admin/SVWS-Server/svws-module-dav-api/', collapsed: true, items: [
								{ text: 'Beschreibung der Implementierung des CardDav Protokolls', link: '/admin/SVWS-Server/svws-module-dav-api/carddav-beschreibung der implementierung.md' },
								{ text: 'CardDAV API - Limitierungen', link: '/admin/SVWS-Server/svws-module-dav-api/carddav-limitierungen.md' },
								{ text: 'CalDav Limitierungen', link: '/admin/SVWS-Server/svws-module-dav-api/caldav-limitierungen.md' },
							] },
							{ text: 'svws-openapi', link: '/admin/SVWS-Server/svws-openapi/' },
							{ text: 'svws-server-app', link: '/admin/SVWS-Server/svws-server-app/' },
							{ text: 'svws-transpile', link: '/admin/SVWS-Server/svws-transpile/' },
							{ text: 'svws-webclient', link: '/admin/SVWS-Server/svws-webclient/' }
						]
						},
						{ text: 'Deployment', link: '/admin/Deployment/', collapsed: true, items: [
							{ text: 'IT-Umgebungen', link: '/admin/Deployment/IT-Umgebungen/' },
							{ text: 'Linux-Installer', link: '/admin/Deployment/Linux-Installer/' },
							{ text: 'Docker-Container', link: '/admin/Deployment/Docker/' },
							{ text: 'Windows-Installer', link: '/admin/Deployment/Windows-Installer/' },
							{ text: 'Datenmigration', link: '/admin/Deployment/Datenmigration/' },
							{ text: 'Einrichtung', link: '/admin/Deployment/Einrichtung/' }
						]
						},
						{ text: 'Entwicklungsumgebungen', link: '/admin/Entwicklungsumgebungen/', collapsed: true, items: [
							{ text: 'Eclipse-Ubuntu', link: '/admin/Entwicklungsumgebungen/Eclipse-Ubuntu/' },
							{ text: 'Eclipse-Windows', link: '/admin/Entwicklungsumgebungen/Eclipse-Windows/' },
							{ text: 'IntelliJ', link: '/admin/Entwicklungsumgebungen/IntelliJ/' },
							{ text: 'macOS', link: '/admin/Entwicklungsumgebungen/macOS/' },
							{ text: 'VS-Code', link: '/admin/Entwicklungsumgebungen/VS-Code/' }
						]
						},
						{ text: 'Teamarbeit', link: '/admin/Teamarbeit/', collapsed: true, items: [
							{ text: 'Git Workflow', link: '/admin/Teamarbeit/workflow/' },
							{ text: 'Bugs & Issues melden', link: '/admin/Teamarbeit/issues/' }
						]
						},
						{ text: 'Schulungsumgebungen', link: '/admin/Schulungsumgebungen/', collapsed: true, items: [
							{ text: 'SchulungsClient', link: '/admin/Schulungsumgebungen/SchulungsClient/' },
							{ text: 'Virtualbox', link: '/admin/Schulungsumgebungen/Virtualbox_Schulungsserver/' },
							{ text: 'Bootstick', link: '/admin/Schulungsumgebungen/Bootstick_Schulungsserver/' },
							{ text: 'Proxmox', link: '/admin/Schulungsumgebungen/Proxmox_Schulungsserver/' }
						]
						},
						{ text: 'Projekte', link: '/admin/Projekte/', collapsed: true, items: [
							{ text: 'weblupo', link: '/admin/Projekte/weblupo/' },
							{ text: 'WeNoM', link: '/admin/Projekte/WeNoM/' },
							{ text: 'ASD-Statistik Modul', link: '/Projekte/ASD-Statistikmodul/' },
							{ text: 'SchülerOnline', link: '/admin/Projekte/SchülerOnline/' },
							{ text: 'xSchule', link: '/admin/Projekte/xSchule/' }

						]
						},
						{ text: 'FAQs', link: '/admin/FAQ/' }
					]
					}
				],
				'/deployment': [
					{ text: '', items: [
						{ text: 'Deployment Base?', link: '/deployment/' },  //Testweise für Head of Deployment
						{ text: 'IT-Umgebungen', link: '/deployment/IT-Umgebungen/' },
						{ text: 'Linux-Installer', link: 'deployment/Linux-Installer/' },
						{ text: 'Docker-Container', link: '/deployment/Docker/' },
						{ text: 'Windows-Installer', link: '/deployment/Windows-Installer/' },
						{ text: 'Datenmigration', link: '/deployment/Datenmigration/' },
						{ text: 'Einrichtung', link: '/deployment/Einrichtung/' }
					]
					}
				],
				'/client': [
					{ text: '', items:
						[
							{ text: 'Diese Webseite', link: '/client/clientwebsite/' },
							{ text: '━━━ Der Client ━━━', link: '/client/client/', collapsed: false, items:
									[
										{ text: 'Tastaturnavigation', link: '/client/client/tastaturnavigation' },
										{ text: 'Änderungen', link: '/client/client/änderungen/' },
										{ text: 'FAQ', link: '/client/client/faq/' },
										{ text: 'JSON-Dateien', link: '/client/client/json_files/' },
									]
							},
							{ text: '━━━ Anleitungen ━━━', link: '/client/anleitungen/' },
							{ text: 'Allgemeine Anleitungen', link: '/client/anleitungen_allgemein/', collapsed: true, items:
									[
										{ text: 'Anmeldung', link: '/client/anleitungen_allgemein/anmeldung/' },
										{ text: 'Stundenpläne (Verschieben zu Stundenpläne?)', link: '/client/anleitungen_allgemein/stundenplan/' }
									]
							},
							{ text: 'Schulformspezifisch', link: '/client/anleitungen_schulform/', collapsed: true, items:
									[
										{ text: 'Oberstufe', link: '/client/anleitungen_schulform//anleitungen_gost/' },
										{ text: 'Grundschule', link: '/client/anleitungen_schulform/anleitungen_gs/' }
									]
							},
							{ text: 'Zeugnisvorbereitung', link: '/client/anleitungen_zeugnisse/' },
							{ text: '━━━ Apps ━━━', link: '/client/apps/' },
							{ text: 'Aktueller Benutzer', link: '/client/aktuellernutzer/' },
							{ text: 'Schule', link: '/client/schule/', collapsed: true, items:
									[
										{ text: 'Schulbezogene Kataloge', collapsed: true, items:
													[
														{ text: 'Stammdaten der Schule (Todo)' },
														{ text: 'Betriebe (Todo)' },
														{ text: 'Einwilligungsarten (Todo)' },
														{ text: 'Fächer', link: '/client/schule/kataloge/faecher/' },
														{ text: 'Förderschwerpunkte', link: '/client/schule/kataloge/foerderschwerpunkte/' },
														{ text: 'Jahrgänge', link: '/client/schule/kataloge/jahrgaenge/' },
														{ text: 'Vermerkarten (Todo)' }
													]
										},
										{ text: 'Allgemeine Kataloge', collapsed: true, items:
													[
														{ text: 'Religionen', link: '/client/schule/kataloge/religionen/' },
														{ text: 'Schulen (Todo)' }
													]
										},
										{ text: 'Datenaustausch', link: '/client/schule/datenaustausch/', collapsed: true, items:
													[
														{ text: 'ENM Notenmanager (Todo)' },
														{ text: 'LuPO Laufbahnplanung', link: '/client/schule/datenaustausch/lupo/' },
														{ text: 'WebNotenManager', link: '/client/schule/datenaustausch/wenom/' },
														{ text: 'Kurs 42 (Todo)' },
														{ text: 'Untis (Todo)' }
													]
										}
									]
							},
							{ text: 'Schüler (Anpassen!)', link: '/client/schueler/', collapsed: true, items:
									[
										{ text: 'Individualdaten', link: '/client/schueler/individualdaten/' },
										{ text: 'Erziehungsberechtigte', link: '/client/schueler/erziehungsberechtigte/' },
										{ text: 'Ausbildungsbetriebe', link: '/client/schueler/ausbildungsbetriebe/' },
										{ text: 'Schulbesuch', link: '/client/schueler/schulbesuch/' },
										{ text: 'Lernabschnitte', link: '/client/schueler/lernabschnitte/', collapsed: true, items:
													[
														{ text: 'Allgemein', link: '/client/schueler/lernabschnitte/allgemein/' },
														{ text: 'Leistungsdaten', link: '/client/schueler/lernabschnitte/leistungsdaten/' }
													]
										},
										{ text: 'KAoA', link: '/client/schueler/kaoa/' },
										{ text: 'Laufbahn', link: '/client/schueler/laufbahn/' },
										{ text: 'Laufbahnplanung Sek II', link: '/client/schueler/laufbahnplanung/' },
										{ text: 'Stundenplan', link: '/client/schueler/stundenplan/' }
									]
							},
							{ text: 'Lehrkräfte', link: '/client/lehrer/', collapsed: true, items:
									[
										{ text: 'Individualdaten', link: '/client/lehrer/individualdaten/' },
										{ text: 'Unterricht', link: '/client/lehrer/unterricht/' },
										{ text: 'Stundenplan', link: '/client/lehrer/stundenplan/' }
									]
							},
							{ text: 'Klassen', link: '/client/klassen/' },
							{ text: 'Kurse', link: '/client/kurse/' },
							{
								text: 'Oberstufe', link: '/client/gost/', collapsed: true, items:
									[
										{ text: 'Abiturjahrgang', link: '/client/gost/abiturjahrgang/' },
										{ text: 'Fächer', link: '/client/gost/faecher/' },
										{ text: 'Beratung', link: '/client/gost/beratung/' },
										{ text: 'Laufbahnplanung', link: '/client/gost/laufbahn/' },
										{ text: 'Fachwahlen', link: '/client/gost/fachwahlen/' },
										{ text: 'WebLuPO', link: '/client/gost/weblupo/' },
										{ text: 'Kursplanung', link: '/client/gost/kursplanung/' },
										{ text: 'Klausurplanung', link: '/client/gost/klausurplanung/' }
									]
							},
							{ text: 'Statistik', link: '/client/statistik/', collapsed: true, items:
									[
										{ text: 'Verschlüsselung ', link: '/client/statistik/verschluesselung/' },
										{ text: 'Datenprüfung', link: '/client/statistik/datenpruefung/' },
										{ text: 'Dokumente', link: '/client/statistik/dokumente/' },
										{ text: 'Hilfe', link: '/client/statistik/hilfe/' }
									]
							},
							{ text: 'Stundenplan', link: '/client/stundenplan/', collapsed: true, items:
									[
										{ text: 'Grundlagen zum Stundenplan', link: '/client/stundenplan/stundenplan_basisinformationen/' },
										{ text: 'Hierhier: Stundenplananleitung?' },
										{ text: 'Allgemeine Vorlagen', link: '/client/stundenplan/allgemeine_vorlagen/', collapsed: true, items:
													[
														{ text: 'Aufsichtsbereiche', link: '/client/stundenplan/allgemeine_vorlagen/aufsichtsbereiche/' },
														{ text: 'Pausenzeiten', link: '/client/stundenplan/allgemeine_vorlagen/pausenzeiten/' },
														{ text: 'Räume', link: '/client/stundenplan/allgemeine_vorlagen/raeume/' },
														{ text: 'Zeitraster', link: '/client/stundenplan/allgemeine_vorlagen/zeitraster/' }
													]
										}
									]
							},
							{ text: 'Einstellungen', link: '/client/einstellungen/', collapsed: true, items:
									[
										{ text: 'Benutzer (Anzupassen)', link: '/client/einstellungen/benutzer/' },
										{ text: 'Benutzergruppen (Anzupassen)', link: '/client/einstellungen/benutzergruppen/' }
									]
							},
							{ text: '━━━ Weiteres ━━━', link: '/client/weiteres/' },
							{ text: 'Adressbücher', link: '/client/adressbuecher/' },
							{ text: 'Kalender', link: '/client/kalender/' },
							{ text: '-----------'},
							{ text: 'Writing Guidelines (Temp)', link: '/client/writingguide/' }
						]
					}
				]
			}
		}
	}
})
