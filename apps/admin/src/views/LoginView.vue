<template>
  <div class="login">
    <div class="login-card">
      <div class="login-card__header">
        <span class="login-card__kicker">SSCenter</span>
        <h1>{{ $t("app.login") }}</h1>
      </div>
      <el-form :model="form" label-position="top" class="login-form">
        <el-form-item :label="$t('app.username')">
          <el-input v-model="form.username" autocomplete="username" />
        </el-form-item>
        <el-form-item :label="$t('app.password')">
          <el-input v-model="form.password" type="password" autocomplete="current-password" />
        </el-form-item>
        <el-form-item :label="$t('app.otp')">
          <el-input v-model="form.otpCode" autocomplete="one-time-code" />
        </el-form-item>
        <el-button type="primary" class="login-button" :loading="loading" @click="submit">
          {{ $t("app.signIn") }}
        </el-button>
      </el-form>
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
  background: radial-gradient(circle at 10% 20%, rgba(61, 214, 255, 0.15), transparent 45%),
    radial-gradient(circle at 90% 10%, rgba(124, 255, 107, 0.12), transparent 40%),
    var(--color-ink-900);
}

.login-card {
  width: min(420px, 92vw);
  background: rgba(20, 28, 37, 0.9);
  border: 1px solid var(--color-border-strong);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  padding: 32px;
}

.login-card__header {
  margin-bottom: 20px;
}

.login-card__kicker {
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.3em;
  color: var(--color-text-muted);
}

.login-card h1 {
  margin: 8px 0 0;
  font-family: var(--font-display);
  font-size: 24px;
}

.login-button {
  width: 100%;
  margin-top: 12px;
}
</style>
