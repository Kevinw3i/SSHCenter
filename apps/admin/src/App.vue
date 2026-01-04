<template>
  <div class="app-shell">
    <AdminSidebar v-if="auth.isAuthenticated" />
    <div class="app-main">
      <AdminTopbar v-if="auth.isAuthenticated" />
      <main class="app-content">
        <RouterView />
      </main>
    </div>
  </div>
</template>

<script setup>
import { useAuthStore } from "@/stores/auth";
import AdminSidebar from "@/components/AdminSidebar.vue";
import AdminTopbar from "@/components/AdminTopbar.vue";

const auth = useAuthStore();
</script>

<style scoped>
.app-shell {
  display: flex;
  min-height: 100vh;
}

.app-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: var(--color-ink-900);
}

.app-content {
  flex: 1;
  padding: var(--admin-page-padding-top) var(--admin-page-padding-x) var(--admin-page-padding-bottom);
}
</style>
