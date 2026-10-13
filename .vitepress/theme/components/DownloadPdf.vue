
<script setup>
import { useRoute } from 'vitepress'

const route = useRoute()

function downloadPdf() {
  window.print()
}
</script>

<template>
  <button class="pdf-button" @click="downloadPdf">
    PDF herunterladen
  </button>
</template>

<style scoped>
.pdf-button {
  padding: 10px 16px;
  border: 1px solid var(--vp-c-brand-1);
  border-radius: 8px;
  background: var(--vp-c-brand-1);
  color: white;
  cursor: pointer;
  font-weight: 600;
}
</style>
