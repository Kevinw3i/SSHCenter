<template>
  <div class="session panel">
    <div class="session__header">
      <div class="session__meta">
        <span class="session__prompt">ssh</span>
        <span>{{ server.site }} / {{ server.env }} / {{ server.role }}</span>
      </div>
      <button class="ghost" @click="$emit('close')">{{ $t("servers.back") }}</button>
    </div>
    <div class="session__body">
      <p class="line">Connecting to {{ server.role }}@{{ server.ip }}...</p>
      <p class="line">Welcome to {{ server.site }} ({{ server.env }})</p>
      <p class="line">Last login: {{ new Date().toISOString() }}</p>
      <p class="cursor">$</p>
    </div>
  </div>
</template>

<script setup>
defineProps({
  server: {
    type: Object,
    required: true
  }
});
</script>

<style scoped>
.session {
  margin-top: 20px;
  padding: 16px;
  border: 1px solid var(--color-border-strong);
}

.session__header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.session__meta {
  display: flex;
  gap: 10px;
  font-size: 12px;
  color: var(--color-text-muted);
}

.session__prompt {
  color: var(--color-accent-neon);
}

.session__body {
  font-size: 13px;
  line-height: 1.7;
}

.line {
  margin: 0;
}

.cursor {
  margin-top: 12px;
  color: var(--color-accent-neon);
  animation: blink 1.2s infinite;
}

@keyframes blink {
  0%,
  50% {
    opacity: 1;
  }
  60%,
  100% {
    opacity: 0.2;
  }
}
</style>
