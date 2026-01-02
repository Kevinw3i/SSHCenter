<template>
  <header class="topbar">
    <div class="topbar__left">
      <span class="topbar__title">{{ $t("app.title") }}</span>
      <span class="topbar__divider"></span>
      <span class="topbar__context">{{ $t("app.opsConsole") }}</span>
    </div>
    <div class="topbar__right">
      <span v-if="auth.user?.username" class="topbar__user">{{ auth.user.username }}</span>
      <el-dropdown trigger="click" @command="setLocale">
        <el-button size="small" text class="topbar__lang">
          {{ localeLabel }}
          <span class="topbar__chevron">▾</span>
        </el-button>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="zh-TW">繁體中文</el-dropdown-item>
            <el-dropdown-item command="zh-CN">简体中文</el-dropdown-item>
            <el-dropdown-item command="en">English</el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
      <el-button size="small" class="topbar__logout" @click="logout">
        {{ $t("app.logout") }}
      </el-button>
    </div>
  </header>
</template>

<script setup>
import { computed, onMounted } from "vue";
import { useI18n } from "vue-i18n";
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/auth";

const auth = useAuthStore();
const router = useRouter();
const { locale } = useI18n();

const localeLabel = computed(() => {
  const labels = {
    "zh-TW": "繁體中文",
    "zh-CN": "简体中文",
    en: "English"
  };
  return labels[locale.value] || "English";
});

const setLocale = (value) => {
  locale.value = value;
};

const logout = async () => {
  await auth.logout();
  router.push("/login");
};

onMounted(() => {
  if (auth.isAuthenticated && !auth.user) {
    auth.fetchMe();
  }
});
</script>

<style scoped>
.topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: var(--admin-topbar-height);
  padding: 0 var(--space-24);
  border-bottom: 1px solid var(--color-border-subtle);
  background: var(--color-surface-base);
}

.topbar__left {
  display: flex;
  align-items: center;
  gap: var(--space-12);
}

.topbar__title {
  color: var(--color-text-primary);
  font-weight: 600;
  font-size: var(--font-size-md);
}

.topbar__divider {
  width: 1px;
  height: 14px;
  background: var(--color-border-subtle);
}

.topbar__context {
  color: var(--color-text-muted);
  font-size: var(--font-size-xs);
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.topbar__right {
  display: flex;
  align-items: center;
  gap: var(--space-12);
}

.topbar__user {
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
}

.topbar__lang {
  color: var(--color-text-secondary);
}

.topbar__chevron {
  margin-left: 6px;
  font-size: 10px;
  opacity: 0.7;
}

.topbar__logout {
  height: 32px;
  border-radius: var(--radius-md);
  border: 1px solid var(--color-border-subtle);
}
</style>
