module.exports = 
{
title: 'SVWS Dokumentation',
description: 'Dokumentation SVWS-Server NRW, Installation und Entwicklung',

themeConfig: 
{

sidebar: 
{

'/':
	[
		{ text: '', items:
			[
				{ text: 'SVWS-Server Repository', link: '/SVWS-Server/', collapsed: true, items:
					{ text: 'svws-core', link: '/SVWS-Server/svws-core/' },
					{ text: 'svws-db', link: '/SVWS-Server/svws-db/' },
					{ text: 'svws-db-utils', link: '/SVWS-Server/svws-db-utils/' },
					{ text: 'svws-module-dav-api', link: '/SVWS-Server/svws-module-dav-api/' },
					{ text: 'svws-openapi', link: '/SVWS-Server/svws-openapi/' },
					{ text: 'svws-server-app', link: '/SVWS-Server/svws-server-app/' },
					{ text: 'svws-transpile', link: '/SVWS-Server/svws-transpile/' }, 
					{ text: 'svws-webclient', link: '/SVWS-Server/svws-webclient/' }					
				},
				
				{ text: 'Deployments', link: '/Deployments/' , collapsed: true, items:
					{ text: 'IT-Umgebungen', link: '/Deployments/IT-Umgebungen/' },
					{ text: 'Linux-Installer', link: '/Deployments/Linux-Installer/' },
					{ text: 'Docker', link: '/Deployments/Docker/' },
					{ text: 'Windows-Installer', link: '/Deployments/Windows-Installer/' },
				},
				
				{ text: 'Projekte', link: '/Projekte/' , collapsed: true, items:
						{ text: 'Reporting', link: '/Projekte/Reporting/' },
						{ text: 'WeNoM', link: '/Projekte/WeNoM/' },
						{ text: 'ASD-Statistik Modul', link: '/Projekte/WeNoM/' }, 
						{ text: 'xSchule', link: '/Projekte/xSchule/' }
				},
				
				{ text: 'Entwicklungsumgebungen', link: '/Entwicklungsumgebungen/' , collapsed: true, items:
					{ text: 'Eclipse-Ubuntu', link: '/Entwicklungsumgebungen/Eclipse-Ubuntu/' },
					{ text: 'Eclipse-Windows', link: '/Entwicklungsumgebungen/Eclipse-Windows/' },
					{ text: 'IntelliJ', link: '/Entwicklungsumgebungen/IntelliJ/' },
					{ text: 'macOS', link: '/Entwicklungsumgebungen/macOS/' },
					{ text: 'Multipass', link: '/Entwicklungsumgebungen/Multipass/' },
					{ text: 'VS-Code', link: '/Entwicklungsumgebungen/VS-Code/' }
				}
			] 
		}
	]
}
}
};
