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
						{ text: 'WebLuPO', link: '/weblupo' },
					] },
				{ text: 'Administration',
					items: [
						{ text: 'Installation', link: '/deployment' },
						{ text: 'Schulungen', link: '/schulungen' },
					] },

				{ text: 'Entwicklung',
					items: [
						{ text: 'SVWS-Server', link: '/development/' },
						{ text: 'Projekte', link: '/projekte' },
						{ text: 'Mitarbeit', link: '/teamarbeit' },
						{ text: 'UI-Bibliothek', link: 'https://ui.svws-nrw.de' },
						{ text: 'Java-API', link: 'https://javadoc.svws-nrw.de' },
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
						{ text: 'Schulungsumgebungen', link: '/schulungen/', collapsed: false, items: [
							{ text: 'SchulungsClient', link: '/schulungen/SchulungsClient/' },
							{ text: 'Virtualbox', link: '/schulungen/Virtualbox_Schulungsserver/' },
							{ text: 'Proxmox', link: '/schulungen/Proxmox_Schulungsserver/' },
							{ text: 'Docker', link: '/schulungen/Docker_Schulungsserver/' },
						] },
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
							{ text: 'WebLuPO', link: '/projekte/WebLupo/' },
							{ text: 'WeNoM', link: '/projekte/WeNoM/' },
							{ text: 'ASD-Statistik', link: '/projekte/ASD-Statistik/' },
							{ text: 'SchülerOnline', link: '/projekte/SchülerOnline/' },
							{ text: 'xSchule', link: '/projekte/xSchule/' },
						] },
					] },
				],
				'/development': [
					{ text: '', items: [
						{ text: 'SVWS-Server', link: '/development/SVWS-Server/', collapsed: false, items: [
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
						{ text: 'Technische FAQs', link: '/development/FAQ/' },
					] },
				],
				'/deployment': [
					{ text: '', items: [
						{ text: 'Installation', link: '/deployment/' },
						{ text: 'IT-Umgebungen', link: '/deployment/IT-Umgebungen/' },
						{ text: 'Installationsmethoden', link: '/deployment/installationsmethoden.md', collapsed: false, items: [
							{ text: 'Linux-Installer', link: '/deployment/Linux-Installer/' },
							{ text: 'Docker-Container', link: '/deployment/Docker/' },
							{ text: 'NAS', link: '/deployment/NAS/' },
							{ text: 'Windows-Installer', link: '/deployment/Windows-Installer/' },
							{ text: 'SchILD-NRW-3', link: '/deployment/Schild-NRW3/' },
						] },
						{ text: 'Einrichtung', link: '/deployment/Einrichtung/' },
						{ text: 'Datenmigration', link: '/deployment/Datenmigration/' },
						{ text: 'Datensicherung', link: '/deployment/Datensicherung/' },
						{ text: 'FAQ', link: '/deployment/FAQ.md' },
					] },
				],
				'/weblupo' : [
					{ text: '', items: [
						{ text: 'Weblupo', link: '/weblupo/' },
					] },
				],
				'/webclient': [
					{ text: '', items:
						[
							{ text: 'SVWS-Webclient', link: '/webclient/', collapsed: false },
							{ text: 'Bedienkonzept', link: '/webclient/client/', collapsed: false, items: [
								{ text: 'Tastaturnavigation', link: '/webclient/client/tastaturnavigation' },
								{ text: 'Änderungen', link: '/webclient/client/änderungen/' },
								{ text: 'FAQ', link: '/webclient/client/faq/' },
							] },
							{ text: 'Apps', link: '/webclient/apps/', collapsed: false, items: [
								{ text: 'Aktueller Benutzer', link: '/webclient/aktuellernutzer/' },
								{ text: 'Schule', link: '/webclient/schule/', collapsed: true, items: [
									{ text: 'Schulbezogene Kataloge', collapsed: true, items: [
										{ text: 'Stammdaten der Schule', link: '/webclient/schule/kataloge/sb_stammdaten/' },
										{ text: 'Betriebe (Todo)', link: '/webclient/schule/kataloge/sb_betriebe/' },
										{ text: 'Einwilligungsarten (Todo)', link: '/webclient/schule/kataloge/sb_einwilligungsarten/' },
										{ text: 'Fächer', link: '/webclient/schule/kataloge/sb_faecher/' },
										{ text: 'Förderschwerpunkte', link: '/webclient/schule/kataloge/sb_foerderschwerpunkte/' },
										{ text: 'Jahrgänge', link: '/webclient/schule/kataloge/sb_jahrgaenge/' },
										{ text: 'Vermerkarten (todo)', link: '/webclient/schule/kataloge/sb_vermerkarten/' },
									] },
									{ text: 'Allgemeine Kataloge', collapsed: true, items: [
										{ text: 'Religionen', link: '/webclient/schule/kataloge/religionen/' },
										{ text: 'Schulen (Todo)' },
									] },
									{ text: 'Datenaustausch', link: '/webclient/schule/datenaustausch/', collapsed: true, items: [
										{ text: 'ENM Notenmanager (Todo)' },
										{ text: 'LuPO Laufbahnplanung', link: '/webclient/schule/datenaustausch/lupo/' },
										{ text: 'WebNotenManager', link: '/webclient/schule/datenaustausch/wenom/' },
										{ text: 'Kurs 42', link: '/webclient/schule/datenaustausch/kurs42/' },
										{ text: 'Untis', link: '/webclient/schule/datenaustausch/untis/' },
									] },
								] },
								{ text: 'Schüler', link: '/webclient/schueler/', collapsed: true, items: [
									{ text: 'Individualdaten', link: '/webclient/schueler/individualdaten/' },
									{ text: 'Erziehungsberechtigte', link: '/webclient/schueler/erziehungsberechtigte/' },
									{ text: 'Ausbildungsbetriebe', link: '/webclient/schueler/ausbildungsbetriebe/' },
									{ text: 'Schulbesuch', link: '/webclient/schueler/schulbesuch/' },
									{ text: 'Lernabschnitte', link: '/webclient/schueler/lernabschnitte/', collapsed: true, items: [
										{ text: 'Allgemein', link: '/webclient/schueler/lernabschnitte/allgemein/' },
										{ text: 'Leistungsdaten', link: '/webclient/schueler/lernabschnitte/leistungsdaten/' },
									] },
									{ text: 'KAoA', link: '/webclient/schueler/kaoa/' },
									{ text: 'Sprachen', link: '/webclient/schueler/sprachen/' },
									{ text: 'Laufbahnplanung Sek II', link: '/webclient/schueler/laufbahnplanung/' },
									{ text: 'Stundenplan', link: '/webclient/schueler/stundenplan/' },
								] },
								{ text: 'Lehrkräfte', link: '/webclient/lehrer/', collapsed: true, items: [
									{ text: 'Individualdaten', link: '/webclient/lehrer/individualdaten/' },
									{ text: 'Personaldaten', link: '/webclient/lehrer/personaldaten/' },
									{ text: 'Unterricht', link: '/webclient/lehrer/unterricht/' },
									{ text: 'Stundenplan', link: '/webclient/lehrer/stundenplan/' },
								] },
								{ text: 'Klassen', link: '/webclient/klassen/klasse/', collapsed: true, items: [
									{ text: 'Klasse', link: '/webclient/klassen/klasse/' },
									{ text: 'Stundenplan', link: '/webclient/klassen/stundenplan/' },
								] },
								{ text: 'Kurse', link: '/webclient/kurse/' },
								{
									text: 'Oberstufe', link: '/webclient/gost/', collapsed: true, items: [
										{ text: 'Abiturjahrgang', link: '/webclient/gost/abiturjahrgang/' },
										{ text: 'Fächer', link: '/webclient/gost/faecher/' },
										{ text: 'Beratung', link: '/webclient/gost/beratung/' },
										{ text: 'Laufbahnplanung', link: '/webclient/gost/laufbahn/' },
										{ text: 'Fachwahlen', link: '/webclient/gost/fachwahlen/' },
										{ text: 'Kursplanung', link: '/webclient/gost/kursplanung/' },
										{ text: 'Klausurplanung', link: '/webclient/gost/klausurplanung/' },
									] },
								{ text: 'Statistik', link: '/webclient/statistik/', collapsed: true, items: [
									{ text: 'Verschlüsselung ', link: '/webclient/statistik/verschluesselung/' },
									{ text: 'Datenprüfung', link: '/webclient/statistik/datenpruefung/' },
									{ text: 'Dokumente', link: '/webclient/statistik/dokumente/' },
									{ text: 'Hilfe', link: '/webclient/statistik/hilfe/' },
								] },
								{ text: 'Stundenplan', link: '/webclient/stundenplan/stundenplan_basisinformationen/', collapsed: true, items: [
									{ text: 'Grundlagen zum Stundenplan', link: '/webclient/stundenplan/stundenplan_basisinformationen/' },
									{ text: 'Stundenpläne erstellen/bearbeiten', link: '/webclient/stundenplan/stundenplan_anleitung/' },
									{ text: 'Allgemeine Vorlagen', link: '/webclient/stundenplan/allgemeine_vorlagen/', collapsed: true, items: [
										{ text: 'Aufsichtsbereiche', link: '/webclient/stundenplan/allgemeine_vorlagen/aufsichtsbereiche/' },
										{ text: 'Pausenzeiten', link: '/webclient/stundenplan/allgemeine_vorlagen/pausenzeiten/' },
										{ text: 'Räume', link: '/webclient/stundenplan/allgemeine_vorlagen/raeume/' },
										{ text: 'Zeitraster', link: '/webclient/stundenplan/allgemeine_vorlagen/zeitraster/' },
									] },
								] },
								{ text: 'Einstellungen', link: '/webclient/einstellungen/', collapsed: true, items: [
									{ text: 'Benutzer (Anzupassen)', link: '/webclient/einstellungen/benutzer/' },
									{ text: 'Benutzergruppen (Anzupassen)', link: '/webclient/einstellungen/benutzergruppen/' },
								] },
							] },
							{ text: 'Anleitungen', link: '/webclient/anleitungen/', collapsed: false, items: [
								{ text: 'Allgemeine Anleitungen', link: '/webclient/anleitungen_allgemein/', collapsed: true, items: [
									{ text: 'Anmeldung', link: '/webclient/anleitungen_allgemein/anmeldung/' },
								] },
								{ text: 'Schulformspezifisch', link: '/webclient/anleitungen_schulform/', collapsed: true, items: [
									{ text: 'Oberstufe', link: '/webclient/anleitungen_schulform/anleitungen_gost/', collapsed: true, items: [
										{ text: 'WebLuPO', link: '/webclient/anleitungen_schulform/anleitungen_gost/weblupo/' },
									] },
									{ text: 'Grundschule', link: '/webclient/anleitungen_schulform/anleitungen_gs/' },
								] },
								{ text: 'Zeugnisvorbereitung', link: '/webclient/anleitungen_zeugnisse/' },
							] },
							{ text: 'Weiteres', link: '/webclient/weiteres/', collapsed: false, items: [
								{ text: 'JSON-Dateien', link: '/webclient/client/json_files/' },
								{ text: 'Adressbücher', link: '/webclient/adressbuecher/' },
								{ text: 'Kalender', link: '/webclient/kalender/' },
							] },
						],
					},
				],
			},
		},
	}
})
