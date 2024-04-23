import { defineConfig, loadEnv } from 'vite'

// https://vitepress.dev/reference/site-config
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '');

  return {
    base: env.BASE || '/SVWS-Dokumentation/',
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
			 socialLinks: [
     				{ icon: 'github', link: 'https://github.com/SVWS-NRW' }
    			],
			sidebar: {
				'/': [
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
				]
			}
		}
	}
})
