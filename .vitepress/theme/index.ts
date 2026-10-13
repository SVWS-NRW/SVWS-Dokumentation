import { h, nextTick, watch } from 'vue';
import DefaultTheme from 'vitepress/theme';
import DownloadPdf from './components/DownloadPdf.vue';
import type { Theme } from 'vitepress';
import { useData } from 'vitepress';
import { createMermaidRenderer } from 'vitepress-mermaid-renderer';
import './print.css';

const toolbarLocales = {
  de: {
    tooltips: {
      zoomIn: 'Vergrößern',
      zoomOut: 'Verkleinern',
      resetView: 'Ansicht zurücksetzen',
      copyCode: 'Code kopieren',
      copyCodeCopied: 'Kopiert',
      download: 'Herunterladen',
      toggleFullscreen: 'Vollbild umschalten',
    },
  },
};

export default {
  extends: DefaultTheme,
  enhanceApp({ app }) {
    app.component('DownloadPdf', DownloadPdf)
  },


  Layout: () => {
    const { isDark, localeIndex } = useData();

    const initMermaid = () => {
      const mermaidRenderer = createMermaidRenderer({
        theme: isDark.value ? 'dark' : 'forest',
        static: true, // Deaktiviert die interaktive Leiste für alle Diagramme
      });
      mermaidRenderer.setToolbar({
        showLanguageLabel: false,
        downloadFormat: 'svg',
        fullscreenMode: 'browser',
        desktop: {
          copyCode: 'enabled',
          toggleFullscreen: 'enabled',
          resetView: 'enabled',
          zoomOut: 'enabled',
          zoomIn: 'enabled',
          zoomLevel: 'enabled',
          download: 'enabled',
        },
        fullscreen: {
          copyCode: 'disabled',
          toggleFullscreen: 'enabled',
          resetView: 'disabled',
          zoomLevel: 'disabled',
          download: 'enabled',
        },
        i18n: {
          localeIndex: localeIndex.value,
          locales: toolbarLocales,
        },
      });
    };

    nextTick(() => initMermaid());

    watch(
      () => [isDark.value, localeIndex.value] as const,
      () => {
        initMermaid();
      },
    );

    return h(DefaultTheme.Layout);
  },
} satisfies Theme;
