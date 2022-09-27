module.exports = {
  title: 'SVWS Dokumentation',
  description: 'Vollständige Dokumentation für SVWS-NRW, Installation und Entwicklung',
  themeConfig: {
    sidebar: {
	
	'/SVWS-Server/':
	[
	  { 
		text: 'Aufbau des SVWS-Server Repositories',
		items:
		[
		  { text: 'svws-base', link: '/SVWS-Server/svws-base' },
          { text: 'svws-core', link: '/SVWS-Server/svws-core' },
		  { text: 'svws-core', link: '/SVWS-Server/svws-core' }
		] 
	  }
	],
	  
	'/Projekte/':
	[
	  { 
		text: 'weitere Projekte',
		items:
		[
		  { text: 'Reporting', link: '/Repoting/' },
          { text: 'WeNoM', link: '/WeNoM/' }
		] 
	  }
	],
	  
	'/Deployments/':
	[
      { 
		text: 'Deployments', 
		items:
		[
		    { text: 'SVWS-Server-Installationen', link: '/SVWS-Server-Installationen/' }
		] 
	  }
	],

	'/Entwicklungsumgebungen/':
	[
      {
        text: 'Entwicklungsumgebungen',
        items: [
          { text: 'Eclipse-Ubuntu', link: '/Entwicklungsumgebungen/Eclipse-Ubuntu/' },
          { text: 'Eclipse-Windows', link: '/Entwicklungsumgebungen/Eclipse-Windows/' },
          { text: 'Eclipse-Windows_im_MSB', link: '/Entwicklungsumgebungen/Eclipse-Windows_im_MSB/' },
		  { text: 'IntelliJ', link: '/Entwicklungsumgebungen/IntelliJ/' },
		  { text: 'macOS', link: '/Entwicklungsumgebungen/macOS/' },
          { text: 'Multipass', link: '/Entwicklungsumgebungen/Multipass/' },
          { text: 'VS-Code', link: '/Entwicklungsumgebungen/VS-Code/' }
        ]
      }
	], 
	
	
	'/DevOps/':
	[
      {
        text: 'DevOps',
        items: 
		[
          { text: 'Dokumentation', link: '/DevOps/Dokumentation/' },
          { text: 'Lizenz-Informationen', link: '/DevOps/Lizenz-Informationen/' },
          { text: 'SVWS-Windows-Installer', link: '/SVWS-Windows-Installer/' },
          { text: 'Testumgebungen', link: '/Testumgebungen/' }
        ] 
      }
	]
	
	
    }
  }
};

