module.exports = {
  title: 'SVWS Dokumentation',
  description: 'Vollständige Dokumentation für SVWS-NRW, Installation und Entwicklung',
  themeConfig: {
    sidebar: [
	  { 
		text: 'SVWS-Server', link: '/SVWS-Server/', 
		items:[
		  { text: 'SVWS-Server', link: '/SVWS-Server/' },
        
          { text: 'SVWS-UI-Framework', link: '/SVWS-UI-Framework/' },
		] 
	  },
	  
	  { 
		text: 'SVWS-UI-Framework', 
		items:[
		
		] 
	  },
	  
	  { 
		text: 'SVWS-Client', 
		items:[
		
		] 
	  },
	  
      { 
		text: 'Deployment', 
		items:[
		{ text: 'Reporting', link: '/Reporting/' },
          { text: 'SVWS-Client', link: '/SVWS-Client/' },
		    { text: 'SVWS-Server-Installationen', link: '/SVWS-Server-Installationen/' },
		] 
	  },
	  
	 	 	 
      {
        text: 'Entwicklungsumgebungen',
        items: [
          { text: 'Eclipse-Ubuntu', link: '/Entwicklungsumgebungen/Eclipse-Ubuntu/' },
          { text: 'Eclipse-Windows', link: '/Entwicklungsumgebungen/Eclipse-Windows/' },
          { text: 'Eclipse-Windows_im_MSB', link: '/Entwicklungsumgebungen/Eclipse-Windows_im_MSB/' },
          { text: 'Multipass', link: '/Entwicklungsumgebungen/Multipass/' },
          { text: 'VS-Code', link: '/Entwicklungsumgebungen/VS-Code/' },
          { text: 'macOS', link: '/Entwicklungsumgebungen/macOS/' }
        ]
      },
	  
      {
        text: 'DevOps',
        items: [
          { text: 'Dokumentation', link: '/DevOps/Dokumentation/' },
          { text: 'Lizenz-Informationen', link: '/DevOps/Lizenz-Informationen/' },
          { text: 'SVWS-Windows-Installer', link: '/SVWS-Windows-Installer/' },
          { text: 'Testumgebungen', link: '/Testumgebungen/' }
        ] 
      },
    ]
  }
};

