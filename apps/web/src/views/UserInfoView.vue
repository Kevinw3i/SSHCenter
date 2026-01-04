<template>
  <section class="panel user-panel">
    <header class="panel__header">
      <h2 class="terminal-heading">{{ $t("user.title") }}</h2>
      <div class="panel__subtitle">profile.edit :: enabled</div>
    </header>

    <div class="section">
      <h3>{{ $t("user.changePassword") }}</h3>
      <div class="grid">
        <input v-model="passwordForm.current_password" :placeholder="$t('user.currentPassword')" type="password" />
        <input v-model="passwordForm.new_password" :placeholder="$t('user.newPassword')" type="password" />
        <button @click="updatePassword">{{ $t("user.save") }}</button>
      </div>
    </div>

    <div class="section">
      <h3>{{ $t("user.sshKey") }}</h3>
      <textarea v-model="sshPublicKey" rows="4" placeholder="ssh-rsa AAA..." />
      <button @click="updateSshKey">{{ $t("user.save") }}</button>
    </div>

    <div class="section">
      <h3>{{ $t("user.openMode") }}</h3>
      <div class="toggle">
        <label>
          <input type="radio" value="terminal" v-model="openMode" />
          {{ $t("user.terminal") }}
        </label>
        <label>
          <input type="radio" value="web" v-model="openMode" />
          {{ $t("user.web") }}
        </label>
        <button @click="updateOpenMode">{{ $t("user.save") }}</button>
      </div>
    </div>
  </section>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue";
import { useI18n } from "vue-i18n";
import { useAuthStore } from "@/stores/auth";
import api from "@/lib/api";
import { confirmAction } from "@/lib/confirm";

const auth = useAuthStore();
const { t } = useI18n();
const sshPublicKey = ref("");
const openMode = ref("terminal");
const passwordForm = reactive({
  current_password: "",
  new_password: ""
});

const hydrate = () => {
  sshPublicKey.value = auth.user?.ssh_public_key || "";
  openMode.value = auth.user?.open_mode || "terminal";
};

const updatePassword = async () => {
  if (!confirmAction(t("common.confirmMutation"))) return;
  await api.patch("/users/me/password", passwordForm);
  passwordForm.current_password = "";
  passwordForm.new_password = "";
};

const updateSshKey = async () => {
  if (!confirmAction(t("common.confirmMutation"))) return;
  const response = await api.patch("/users/me/ssh_key", { ssh_public_key: sshPublicKey.value });
  auth.user = response.data.user;
};

const updateOpenMode = async () => {
  if (!confirmAction(t("common.confirmMutation"))) return;
  const response = await api.patch("/users/me", { user: { open_mode: openMode.value } });
  auth.user = response.data.user;
};

onMounted(async () => {
  await auth.fetchMe();
  hydrate();
});
</script>

<style scoped>
.user-panel {
  padding: 24px;
}

.panel__header {
  margin-bottom: 20px;
}

.panel__subtitle {
  font-size: 12px;
  color: var(--color-text-muted);
}

.section {
  margin-bottom: 24px;
}

.section h3 {
  margin: 0 0 10px;
  font-size: 14px;
  text-transform: uppercase;
  color: var(--color-text-secondary);
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 12px;
}

input,
textarea {
  background: transparent;
  border: 1px solid var(--color-border-strong);
  color: var(--color-text-primary);
  padding: 10px 12px;
  border-radius: var(--radius-md);
}

button {
  background: transparent;
  border: 1px solid var(--color-accent-neon);
  color: var(--color-accent-neon);
  padding: 10px 16px;
  border-radius: var(--radius-md);
  cursor: pointer;
}

.toggle {
  display: flex;
  align-items: center;
  gap: 12px;
}
</style>
