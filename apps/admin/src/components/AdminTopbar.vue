<template>
  <header class="topbar">
    <div class="topbar__meta">
      <span class="topbar__label">{{ $t("app.title") }}</span>
      <span class="topbar__divider">/</span>
      <span class="topbar__hint">OPS Console</span>
    </div>
    <div class="topbar__actions">
      <el-select v-model="locale" size="small" class="lang-select">
        <el-option label="繁體中文" value="zh-TW" />
        <el-option label="简体中文" value="zh-CN" />
        <el-option label="English" value="en" />
      </el-select>
      <el-button type="primary" plain size="small" @click="logout">
        {{ $t("app.logout") }}
      </el-button>
    </div>
  </header>
</template>

<script setup>
import { useI18n } from "vue-i18n";
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/auth";

const auth = useAuthStore();
const router = useRouter();
const { locale } = useI18n();

const logout = async () => {
  await auth.logout();
  router.push("/login");
};
</script>

<style scoped>
.topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 28px;
  border-bottom: 1px solid var(--color-border-subtle);
  background: rgba(20, 28, 37, 0.72);
  backdrop-filter: blur(12px);
}

.topbar__meta {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--color-text-muted);
}

.topbar__label {
  color: var(--color-text-primary);
  font-weight: 600;
}

.topbar__divider {
  opacity: 0.4;
}

.topbar__actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.lang-select {
  width: 140px;
}
</style>
