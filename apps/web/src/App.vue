<template>
  <div class="screen">
    <TerminalSidebar v-if="auth.isAuthenticated" />
    <div class="main">
      <StatusBar v-if="auth.isAuthenticated" />
      <main class="content">
        <RouterView />
      </main>
    </div>
  </div>
</template>

<script setup>
import { useAuthStore } from "@/stores/auth";
import TerminalSidebar from "@/components/TerminalSidebar.vue";
import StatusBar from "@/components/StatusBar.vue";

const auth = useAuthStore();
</script>

<style scoped>
.main {
  flex: 1;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.content {
  flex: 1;
  padding: 28px;
}
</style>
