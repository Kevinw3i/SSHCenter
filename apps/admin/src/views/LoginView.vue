<template>
  <div class="login">
    <div class="login-shell">
      <section class="login-hero">
        <div class="login-hero__content">
          <span class="login-kicker">SSCenter</span>
          <h2 class="login-headline">{{ $t("app.loginHeadline") }}</h2>
          <p class="login-subtitle">{{ $t("app.loginSubtitle") }}</p>
        </div>
        <div class="login-signals">
          <span class="login-chip">{{ $t("app.loginOpsLabel") }}</span>
          <p class="login-note">{{ $t("app.loginOpsNote") }}</p>
          <ul class="login-list">
            <li>{{ $t("app.loginSignalOtp") }}</li>
            <li>{{ $t("app.loginSignalRole") }}</li>
            <li>{{ $t("app.loginSignalToken") }}</li>
          </ul>
        </div>
        <div class="login-graphic" aria-hidden="true">
          <span class="login-orbit login-orbit--one"></span>
          <span class="login-orbit login-orbit--two"></span>
          <span class="login-orbit login-orbit--three"></span>
        </div>
      </section>
      <section class="login-panel">
        <div class="login-card">
          <div class="login-card__header">
            <span class="login-card__kicker">{{ $t("app.title") }}</span>
            <h1>{{ $t("app.login") }}</h1>
            <p>{{ $t("app.loginHelper") }}</p>
          </div>
          <el-form :model="form" label-position="top" class="login-form admin-form">
            <el-form-item :label="$t('app.username')">
              <el-input v-model="form.username" autocomplete="username" />
            </el-form-item>
            <el-form-item :label="$t('app.password')">
              <el-input v-model="form.password" type="password" autocomplete="current-password" />
            </el-form-item>
            <el-form-item :label="$t('app.otp')">
              <el-input v-model="form.otpCode" autocomplete="one-time-code" />
              <span class="login-otp-hint">{{ $t("app.loginOtpHint") }}</span>
            </el-form-item>
            <el-button type="primary" class="btn-primary login-button" :loading="loading" @click="submit">
              {{ $t("app.signIn") }}
            </el-button>
          </el-form>
          <div class="login-footer">{{ $t("app.loginFooter") }}</div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { useAuthStore } from "@/stores/auth";

const router = useRouter();
const auth = useAuthStore();
const loading = ref(false);
const form = reactive({
  username: "",
  password: "",
  otpCode: ""
});

const submit = async () => {
  loading.value = true;
  try {
    await auth.login(form);
    router.push("/users");
  } catch (error) {
    ElMessage.error("Login failed. Check credentials and OTP.");
  } finally {
    loading.value = false;
  }
};
</script>

<style scoped>
.login {
  min-height: 100vh;
  display: grid;
  place-items: center;
  padding: clamp(32px, 6vw, 72px) 0;
  position: relative;
  overflow: hidden;
  background: radial-gradient(circle at 15% 10%, rgba(61, 214, 255, 0.2), transparent 45%),
    radial-gradient(circle at 85% 0%, rgba(124, 255, 107, 0.16), transparent 40%),
    radial-gradient(circle at 90% 90%, rgba(255, 181, 71, 0.12), transparent 35%),
    var(--color-ink-900);
}

.login::before {
  content: "";
  position: absolute;
  inset: 0;
  background-image: linear-gradient(rgba(15, 24, 36, 0.65) 1px, transparent 1px),
    linear-gradient(90deg, rgba(15, 24, 36, 0.65) 1px, transparent 1px);
  background-size: 32px 32px;
  opacity: 0.35;
  pointer-events: none;
}

.login::after {
  content: "";
  position: absolute;
  inset: auto -10% -20% auto;
  width: 360px;
  height: 360px;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(61, 214, 255, 0.25), transparent 65%);
  filter: blur(2px);
  pointer-events: none;
}

.login-shell {
  width: min(980px, 92vw);
  display: grid;
  grid-template-columns: minmax(280px, 1fr) minmax(320px, 0.9fr);
  gap: clamp(24px, 4vw, 56px);
  align-items: center;
  position: relative;
  z-index: 1;
  animation: login-rise 680ms var(--motion-ease) both;
}

.login-hero {
  color: var(--color-text-primary);
  display: grid;
  gap: 24px;
  padding-right: clamp(8px, 3vw, 28px);
}

.login-hero__content {
  display: grid;
  gap: 12px;
}

.login-kicker {
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.3em;
  color: var(--color-text-muted);
}

.login-headline {
  margin: 0;
  font-family: var(--font-display);
  font-size: clamp(28px, 4vw, 44px);
  letter-spacing: 0.02em;
}

.login-subtitle {
  margin: 0;
  color: var(--color-text-secondary);
  font-size: var(--font-size-lg);
  max-width: 420px;
}

.login-signals {
  display: grid;
  gap: 12px;
  background: linear-gradient(145deg, rgba(20, 28, 37, 0.7), rgba(24, 34, 48, 0.9));
  border: 1px solid rgba(51, 74, 99, 0.6);
  border-radius: var(--radius-lg);
  padding: 20px 22px;
  box-shadow: var(--shadow-sm);
}

.login-chip {
  width: fit-content;
  padding: 6px 12px;
  border-radius: var(--radius-pill);
  background: rgba(124, 255, 107, 0.12);
  color: var(--color-accent-neon);
  font-size: var(--font-size-xs);
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.login-note {
  margin: 0;
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
}

.login-list {
  margin: 0;
  padding-left: 18px;
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
  display: grid;
  gap: 6px;
}

.login-graphic {
  display: grid;
  grid-template-columns: repeat(3, minmax(80px, 1fr));
  gap: 14px;
  margin-top: 8px;
}

.login-orbit {
  height: 120px;
  border-radius: var(--radius-lg);
  background: linear-gradient(180deg, rgba(20, 28, 37, 0.8), rgba(11, 15, 20, 0.6));
  border: 1px solid rgba(51, 74, 99, 0.5);
  position: relative;
  overflow: hidden;
}

.login-orbit::after {
  content: "";
  position: absolute;
  inset: -30% 0 auto;
  height: 60%;
  background: linear-gradient(120deg, transparent, rgba(61, 214, 255, 0.35), transparent);
  animation: login-scan 3.4s ease-in-out infinite;
}

.login-orbit--two::after {
  animation-delay: 0.6s;
}

.login-orbit--three::after {
  animation-delay: 1.2s;
}

.login-panel {
  display: flex;
  justify-content: center;
}

.login-card {
  width: min(360px, 92vw);
  background: rgba(20, 28, 37, 0.92);
  border: 1px solid var(--color-border-subtle);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  padding: 28px;
  position: relative;
  animation: login-card 620ms var(--motion-ease) both;
}

.login-card::before {
  content: "";
  position: absolute;
  inset: 0;
  border-radius: inherit;
  box-shadow: inset 0 0 0 1px rgba(124, 255, 107, 0.08);
  pointer-events: none;
}

.login-card__header {
  margin-bottom: 16px;
  display: grid;
  gap: 8px;
}

.login-card__kicker {
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.32em;
  color: var(--color-text-muted);
}

.login-card h1 {
  margin: 0;
  font-family: var(--font-display);
  font-size: 24px;
}

.login-card p {
  margin: 0;
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
}

.login-form :deep(.el-form-item) {
  margin-bottom: 16px;
}

.login-otp-hint {
  display: block;
  margin-top: 6px;
  color: var(--color-text-muted);
  font-size: var(--font-size-xs);
}

.login-button {
  width: 100%;
  margin-top: var(--space-12);
  height: var(--control-height-md);
  border-radius: var(--radius-md);
}

.login-footer {
  margin-top: 18px;
  text-align: center;
  color: var(--color-text-muted);
  font-size: var(--font-size-xs);
}

@keyframes login-rise {
  from {
    opacity: 0;
    transform: translateY(18px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes login-card {
  from {
    opacity: 0;
    transform: translateY(12px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes login-scan {
  0% {
    transform: translateX(-120%);
  }
  50% {
    transform: translateX(20%);
  }
  100% {
    transform: translateX(140%);
  }
}

@media (max-width: 960px) {
  .login-shell {
    grid-template-columns: 1fr;
  }

  .login-panel {
    justify-content: center;
    order: 1;
  }

  .login-hero {
    order: 2;
    text-align: center;
  }

  .login-signals {
    text-align: left;
  }

  .login-graphic {
    grid-template-columns: repeat(3, minmax(70px, 1fr));
  }
}

@media (max-width: 640px) {
  .login-card {
    padding: 24px;
  }

  .login-graphic {
    grid-template-columns: repeat(2, minmax(90px, 1fr));
  }

  .login-orbit--three {
    display: none;
  }
}
</style>
