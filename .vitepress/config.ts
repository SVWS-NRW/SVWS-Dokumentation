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
			lastUpdated: {
				text: 'Diese Seite wurde zuletzt bearbeitet am',
				formatOptions: {
					dateStyle: 'full',
					timeStyle: 'medium'
				}
			},
			search: {
				provider: 'local'
			},
			nav: [
				{ text: 'Benutzerhandbuch', link: '/client'},
				{ text: 'Administration/Entwicklung', link: '/admin'},
				{ text: 'UI-Bibliothek', link: 'https://ui.svws-nrw.de' },
				{ text: 'Java-API', link: 'https://javadoc.svws-nrw.de' },
			],
			socialLinks: [
				{ icon: 'github', link: 'https://github.com/SVWS-NRW/SVWS-Dokumentation' }
			],
			sidebar: {
				'/admin': [
					{ text: '', items: [
						{ text: 'SVWS-Server', link: '/SVWS-Server/', collapsed: true, items: [
							{ text: 'svws-core', link: '/SVWS-Server/svws-core/' },
							{ text: 'svws-db', link: '/SVWS-Server/svws-db/' },
							{ text: 'svws-db-utils', link: '/SVWS-Server/svws-db-utils/' },
							{ text: 'svws-module-dav-api', link: '/SVWS-Server/svws-module-dav-api/', collapsed: true, items: [
								{ text: 'Beschreibung der Implementierung des CardDav Protokolls', link: 'SVWS-Server/svws-module-dav-api/carddav-beschreibung der implementierung.md' },
								{ text: 'CardDAV API - Limitierungen', link: 'SVWS-Server/svws-module-dav-api/carddav-limitierungen.md' },
								{ text: 'CalDav Limitierungen', link: 'SVWS-Server/svws-module-dav-api/caldav-limitierungen.md' },
							] },
							{ text: 'svws-openapi', link: '/SVWS-Server/svws-openapi/' },
							{ text: 'svws-server-app', link: '/SVWS-Server/svws-server-app/' },
							{ text: 'svws-transpile', link: '/SVWS-Server/svws-transpile/' },
							{ text: 'svws-webclient', link: '/SVWS-Server/svws-webclient/' }
						]
						},
						{ text: 'Deployment', link: '/Deployment/', collapsed: true, items: [
							{ text: 'IT-Umgebungen', link: '/Deployment/IT-Umgebungen/' },
							{ text: 'Linux-Installer', link: '/Deployment/Linux-Installer/' },
							{ text: 'Docker-Container', link: '/Deployment/Docker/' },
							{ text: 'Windows-Installer', link: '/Deployment/Windows-Installer/' },
							{ text: 'Datenmigration', link: '/Deployment/Datenmigration/' },
							{ text: 'Einrichtung', link: '/Deployment/Einrichtung/' }
						]
						},
						{ text: 'Entwicklungsumgebungen', link: '/Entwicklungsumgebungen/', collapsed: true, items: [
							{ text: 'Eclipse-Ubuntu', link: '/Entwicklungsumgebungen/Eclipse-Ubuntu/' },
							{ text: 'Eclipse-Windows', link: '/Entwicklungsumgebungen/Eclipse-Windows/' },
							{ text: 'IntelliJ', link: '/Entwicklungsumgebungen/IntelliJ/' },
							{ text: 'macOS', link: '/Entwicklungsumgebungen/macOS/' },
							{ text: 'VS-Code', link: '/Entwicklungsumgebungen/VS-Code/' }
						]
						},
						{ text: 'Teamarbeit', link: '/Teamarbeit/', collapsed: true, items: [
							{ text: 'Git Workflow', link: '/Teamarbeit/workflow/' },
							{ text: 'Bugs & Issues melden', link: '/Teamarbeit/issues/' }
						]
						},
						{ text: 'Schulungsumgebungen', link: '/Schulungsumgebungen/', collapsed: true, items: [
							{ text: 'SchulungsClient', link: '/Schulungsumgebungen/SchulungsClient/' },
							{ text: 'Virtualbox', link: '/Schulungsumgebungen/Virtualbox_Schulungsserver/' },
							{ text: 'Bootstick', link: '/Schulungsumgebungen/Bootstick_Schulungsserver/' },
							{ text: 'Proxmox', link: '/Schulungsumgebungen/Proxmox_Schulungsserver/' }
						]
						},
						{ text: 'Projekte', link: '/Projekte/', collapsed: true, items: [
							{ text: 'weblupo', link: '/Projekte/weblupo/' },
							{ text: 'WeNoM', link: '/Projekte/WeNoM/' },
							{ text: 'ASD-Statistik Modul', link: '/Projekte/ASD-Statistikmodul/' },
							{ text: 'SchülerOnline', link: '/Projekte/SchülerOnline/' },
							{ text: 'xSchule', link: '/Projekte/xSchule/' }

						]
						},
						{ text: 'FAQs', link: '/FAQ/' }
					]
					}
				],
				'/client': [
					{ text: '', items: [
						{ text: '━━━ Anleitungen ━━━', link: '/anleitungen/' },
						{ text: 'Allgemeine Anleitungen', link: '/anleitungen/', collapsed: true, items: [
							{ text: 'Anmeldung', link: '/anleitungen/anmeldung/' },
							{ text: 'Stundenpläne', link: '/anleitungen/stundenplan/' },
							{ text: 'JSON-Dateien', link: '/anleitungen/json_files/' }
						]
						},
						{ text: 'Schulformspezifisch', link: '/anleitungen_schulform/', collapsed: true, items: [
							{ text: 'Oberstufe', link: '/anleitungen_schulform//anleitungen_gost/' },
							{ text: 'Grundschule', link: '/anleitungen_schulform/anleitungen_gs/' }
						]
						},
						{ text: 'Zeugnisvorbereitung', link: '/anleitungen_zeugnisse/' },
						{ text: '━━━ Apps ━━━', link: '/apps/' },
						{ text: 'Aktueller Benutzer', link: '/aktuellernutzer/', collapsed: true },
						{ text: 'Schule', link: '/schule/', collapsed: true, items: [
							{ text: 'Benutzer', link: '/schule/benutzer/' },
							{ text: 'Benutzergruppen', link: '/schule/benutzergruppen/' },
							{ text: 'Datenaustausch', link: '/schule/datenaustausch/', collapsed: true, items: [
								{ text: 'Laufbahnberatung Oberstufe', link: '/schule/datenaustausch/lupo/' },
								{ text: 'WebNotenManager', link: '/schule/datenaustausch/wenom/' }
							]
							}
						]
						},
						{ text: 'Kataloge', link: '/kataloge/', collapsed: true, items: [
							{ text: 'Aufsichtsbereiche', link: '/kataloge/aufsichtsbereiche/' },
							{ text: 'Fächer', link: '/kataloge/faecher/' },
							{ text: 'Förderschwerpunkte', link: '/kataloge/foerderschwerpunkte/' },
							{ text: 'Jahrgänge', link: '/kataloge/jahrgaenge/' },
							{ text: 'Pausenzeiten', link: '/kataloge/pausenzeiten/' },
							{ text: 'Räume', link: '/kataloge/raeume/' },
							{ text: 'Religionen', link: '/kataloge/religionen/' },
							{ text: 'Zeitraster', link: '/kataloge/zeitraster/' }
						]
						},
						{ text: 'Schüler', link: '/schueler/', collapsed: true, items: [
							{ text: 'Individualdaten', link: '/schueler/individualdaten/' },
							{ text: 'Erziehungsberechtigte', link: '/schueler/erziehungsberechtigte/' },
							{ text: 'Ausbildungsbetriebe', link: '/schueler/ausbildungsbetriebe/' },
							{ text: 'Schulbesuch', link: '/schueler/schulbesuch/' },
							{ text: 'Lernabschnitte', link: '/schueler/lernabschnitte/', collapsed: true, items: [
								{ text: 'Allgemein', link: '/schueler/lernabschnitte/allgemein/' },
								{ text: 'Leistungsdaten', link: '/schueler/lernabschnitte/leistungsdaten/' }
							]
							},
							{ text: 'KAoA', link: '/schueler/kaoa/' },
							{ text: 'Laufbahn', link: '/schueler/laufbahn/' },
							{ text: 'Laufbahnplanung (SII)', link: '/schueler/laufbahnplanung/' },
							{ text: 'Stundenplan', link: '/schueler/stundenplan/' }
						]
						},
						{ text: 'Lehrkräfte', link: '/lehrer/', collapsed: true, items: [
							{ text: 'Individualdaten', link: '/lehrer/individualdaten/' },
							{ text: 'Unterricht', link: '/lehrer/unterricht/' },
							{ text: 'Stundenplan', link: '/lehrer/stundenplan/' }
						]
						},
						{ text: 'Klassen', link: '/klassen/' },
						{ text: 'Kurse', link: '/kurse/' },
						{
							text: 'Oberstufe', link: '/gost/', collapsed: true, items: [
								{ text: 'Abiturjahrgang', link: '/gost/abiturjahrgang/' },
								{ text: 'Fächer', link: '/gost/faecher/' },
								{ text: 'Beratung', link: '/gost/beratung/' },
								{ text: 'Laufbahnplanung', link: '/gost/laufbahn/' },
								{ text: 'Fachwahlen', link: '/gost/fachwahlen/' },
								{ text: 'WebLuPO', link: '/gost/weblupo/' },
								{ text: 'Kursplanung', link: '/gost/kursplanung/' },
								{ text: 'Klausurplanung', link: '/gost/klausurplanung/' }
							]
						},
						{ text: 'Statistik', link: '/statistik/', collapsed: true, items: [
							{ text: 'Verschlüsselung ', link: '/statistik/verschluesselung' },
							{ text: 'Datenprüfung', link: '/statistik/datenpruefung' },
							{ text: 'Dokumente', link: '/statistik/dokumente' },
							{ text: 'Hilfe', link: '/statistik/hilfe' }
						]
						},
						{ text: 'Stundenplan', link: '/stundenplan/', },
						{ text: '━━━ Weiteres ━━━', link: '/weiteres/' },
						{ text: 'Administration', link: '/administration/', collapsed: true, items: [
							{ text: 'Admin Client', link: '/administration/adminclient/' }
						]
						},
						{ text: 'Adressbücher', link: '/adressbuecher/' },
						{ text: 'Kalender', link: '/kalender/' },
						{ text: 'Informationen', link: '/informationen/', collapsed: true, items: [
							{ text: 'Änderungen ', link: '/informationen/änderungen/' },
							{ text: 'FAQ', link: '/informationen/faq' }
						]
						},
						{ text: 'Writing Guidelines (Temp)', link: '/writingguide/'}
					]
					}
				]
			}
		}
	}
})
