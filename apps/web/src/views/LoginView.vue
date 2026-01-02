<template>
  <div class="login">
    <div class="login-card panel">
      <div class="login-card__header">
        <span class="terminal-heading">{{ $t("app.login") }}</span>
        <div class="login-card__subtitle">otp.required :: true</div>
      </div>
      <form class="login-form" @submit.prevent="submit">
        <label>
          {{ $t("app.username") }}
          <input v-model="form.username" type="text" autocomplete="username" />
        </label>
        <label>
          {{ $t("app.password") }}
          <input v-model="form.password" type="password" autocomplete="current-password" />
        </label>
        <label>
          {{ $t("app.otp") }}
          <input v-model="form.otpCode" type="text" autocomplete="one-time-code" />
        </label>
        <p v-if="error" class="error">{{ error }}</p>
        <button type="submit" :disabled="loading">
          {{ loading ? "..." : $t("app.signIn") }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/auth";

const router = useRouter();
const auth = useAuthStore();
const loading = ref(false);
const error = ref("");
const form = reactive({
  username: "",
  password: "",
  otpCode: ""
});

const submit = async () => {
  loading.value = true;
  error.value = "";
  try {
    await auth.login(form);
    router.push("/servers");
  } catch (error) {
    error.value = "Login failed. Check credentials and OTP.";
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
  position: relative;
}

.login-card {
  width: min(420px, 90vw);
  padding: 28px;
  border: 1px solid var(--color-border-strong);
  backdrop-filter: blur(10px);
}

.login-card__header {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-bottom: 20px;
}

.login-card__subtitle {
  font-size: 12px;
  color: var(--color-text-muted);
}

.login-form {
  display: grid;
  gap: 16px;
}

label {
  display: grid;
  gap: 6px;
  font-size: 12px;
  text-transform: uppercase;
  color: var(--color-text-muted);
}

input {
  background: transparent;
  border: 1px solid var(--color-border-strong);
  color: var(--color-text-primary);
  padding: 10px 12px;
  border-radius: var(--radius-md);
  font-size: 14px;
}

button {
  background: var(--color-accent-neon);
  color: var(--color-text-inverse);
  border: none;
  padding: 12px 16px;
  border-radius: var(--radius-md);
  font-weight: 600;
  cursor: pointer;
  text-transform: uppercase;
  letter-spacing: 0.12em;
}

button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.error {
  color: var(--color-state-danger);
  font-size: 12px;
  margin: 0;
}
</style>
