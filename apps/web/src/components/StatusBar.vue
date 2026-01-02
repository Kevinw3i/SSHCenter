<template>
  <header class="statusbar">
    <div class="statusbar__left">
      <div class="status-pill">
        <span class="status-label">{{ $t("status.user") }}</span>
        <span class="status-value">{{ auth.user?.username || "-" }}</span>
      </div>
      <div class="status-pill">
        <span class="status-label">{{ $t("status.time") }}</span>
        <span class="status-value">{{ formattedTime }}</span>
      </div>
      <div class="status-pill">
        <span class="status-label">{{ $t("status.ip") }}</span>
        <span class="status-value">{{ auth.ip || "-" }}</span>
      </div>
    </div>
    <div class="statusbar__right">
      <select v-model="locale" class="lang-select">
        <option value="zh-TW">繁體中文</option>
        <option value="zh-CN">简体中文</option>
        <option value="en">English</option>
      </select>
      <button class="ghost" @click="logout">{{ $t("app.logout") }}</button>
    </div>
  </header>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref } from "vue";
import { useRouter } from "vue-router";
import { useI18n } from "vue-i18n";
import { useAuthStore } from "@/stores/auth";

const auth = useAuthStore();
const router = useRouter();
const { locale } = useI18n();
const now = ref(new Date());
let timer;

const formattedTime = computed(() =>
  now.value.toLocaleTimeString("en-US", { hour12: false })
);

onMounted(() => {
  timer = setInterval(() => {
    now.value = new Date();
  }, 1000);
});

onUnmounted(() => {
  clearInterval(timer);
});

const logout = async () => {
  await auth.logout();
  router.push("/login");
};
</script>

<style scoped>
.statusbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px 24px;
  border-bottom: 1px solid var(--color-border-subtle);
  background: rgba(17, 24, 33, 0.85);
  backdrop-filter: blur(10px);
}

.statusbar__left,
.statusbar__right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.status-pill {
  display: flex;
  gap: 8px;
  padding: 8px 12px;
  border-radius: var(--radius-pill);
  border: 1px solid var(--color-border-strong);
  background: rgba(12, 18, 26, 0.8);
  font-size: 12px;
}

.status-label {
  color: var(--color-text-muted);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.status-value {
  color: var(--color-text-primary);
}

.lang-select {
  background: transparent;
  color: var(--color-text-primary);
  border: 1px solid var(--color-border-subtle);
  padding: 6px 10px;
  border-radius: var(--radius-pill);
}

.ghost {
  border: 1px solid var(--color-border-subtle);
  background: transparent;
  color: var(--color-text-primary);
  padding: 6px 14px;
  border-radius: var(--radius-pill);
  cursor: pointer;
}
</style>
