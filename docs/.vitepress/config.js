module.exports = {
  title: 'SVWS Dokumentation',
  description: 'Just playing around.',
  themeConfig: {
    sidebar: [

      { text: 'Test-SVWS-Client', link: '/SVWS-Client/' },
      { text: 'T-SVWS-Installer', link: '/SVWS-Installer/index' },
      {	
        text: 'T-SVWS-Server',
        link: '/SVWS-Server/',
        children: [ { text: 'svws-db', link: '/SVWS-Server/svws-db/' }, ]
      },
      {	
        text: 'T-SVWS-Server-Installationen',
        link: '/SVWS-Server-Installationen/#server-installationen',
        children: [ { text: 'VPN-Server', link: '/SVWS-Server-Installationen/#vpn-server' }, ]
      },

      {
        text: 'Entwicklungsumgebungen',
        children: [
          {
            text: 'Eclipse-Ubuntu',
            link: '/Entwicklungsumgebungen/Eclipse-Ubuntu/',
          },
          {
            text: 'Eclipse-Windows',
            link: '/Entwicklungsumgebungen/Eclipse-Windows/',
          },
          {
            text: 'Eclipse-Windows_im_MSB',
            link: '/Entwicklungsumgebungen/Eclipse-Windows_im_MSB/',
          },
          {
            text: 'Multipass',
            link: '/Entwicklungsumgebungen/Multipass/',
          },
          { text: 'VS-Code', link: '/Entwicklungsumgebungen/VS-Code/' },
          { text: 'macOS', link: '/Entwicklungsumgebungen/macOS/' },
        ],
      },
      { text: 'Gitlab-Server', link: '/Gitlab-Server/' },
      { text: 'Lizenz-Informationen', link: '/Lizenz-Informationen/' },
      { text: 'Reporting', link: '/Reporting/' },
      { text: 'SVWS-Client', link: '/SVWS-Client/' },
      { text: 'SVWS-Installer', link: '/SVWS-Installer/' },
      {
        text: 'SVWS-Server',
        link: '/SVWS-Server/',
        children: [ { text: 'svws-db', link: '/SVWS-Server/svws-db/' } ],
      },
      { text: 'SVWS-Server-Installationen', link: '/SVWS-Server-Installationen/' },
      { text: 'SVWS-UI-Framework', link: '/SVWS-UI-Framework/' },
      
    ],
  },
};

