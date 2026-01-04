<template>
  <section class="admin-page">
    <ContentHeader :title="pageTitle" :subtitle="$t('users.formSubtitle')">
      <template #actions>
        <el-button class="btn-secondary" @click="goBack">{{ $t("common.back") }}</el-button>
      </template>
    </ContentHeader>

    <div class="card card--padded form-card">
      <div class="form-grid">
        <el-form
          ref="formRef"
          :model="form"
          :rules="rules"
          label-position="top"
          class="admin-form"
          :disabled="loading"
        >
          <el-form-item :label="$t('app.username')" prop="username">
            <el-input v-model="form.username" autocomplete="username" />
          </el-form-item>
          <el-form-item v-if="isCreate" :label="$t('app.password')" prop="password">
            <el-input v-model="form.password" type="password" autocomplete="new-password" />
          </el-form-item>
          <el-form-item :label="$t('users.role')" prop="role">
            <AdminSelect v-model="form.role" :options="roleOptions" />
          </el-form-item>
          <el-form-item :label="$t('users.openMode')" prop="open_mode">
            <AdminSelect v-model="form.open_mode" :options="openModeOptions" />
          </el-form-item>
        </el-form>

        <aside class="form-aside">
          <h3>{{ $t("users.securityTitle") }}</h3>
          <p>{{ $t("users.securitySubtitle") }}</p>
          <ul>
            <li>{{ $t("users.securityOtp") }}</li>
            <li>{{ $t("users.securityPassword") }}</li>
            <li>{{ $t("users.securityRole") }}</li>
          </ul>
        </aside>
      </div>

      <div class="form-actions">
        <el-button class="btn-secondary" @click="goBack">{{ $t("common.cancel") }}</el-button>
        <el-button type="primary" class="btn-primary" :loading="loading" @click="save">
          {{ isCreate ? $t("common.create") : $t("common.save") }}
        </el-button>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed, nextTick, onMounted, reactive, ref, watch } from "vue";
import { useI18n } from "vue-i18n";
import { useRoute, useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import api from "@/lib/api";
import ContentHeader from "@/components/ContentHeader.vue";
import AdminSelect from "@/components/AdminSelect.vue";
import { confirmAction } from "@/lib/confirm";
import { resolveApiError } from "@/lib/errors";

const route = useRoute();
const router = useRouter();
const { t } = useI18n();
const loading = ref(false);
const formRef = ref(null);

const form = reactive({
  id: null,
  username: "",
  password: "",
  role: "user",
  open_mode: "terminal"
});

const roleOptions = [
  { label: "admin", value: "admin" },
  { label: "manage", value: "manage" },
  { label: "user", value: "user" }
];

const openModeOptions = [
  { label: "terminal", value: "terminal" },
  { label: "web", value: "web" }
];

const isCreate = computed(() => route.name === "user-create");
const pageTitle = computed(() => (isCreate.value ? t("users.createTitle") : t("users.editTitle")));
const rules = computed(() => ({
  username: [{ required: true, message: t("validation.required"), trigger: "blur" }],
  password: isCreate.value
    ? [{ required: true, message: t("validation.passwordRequired"), trigger: "blur" }]
    : [],
  role: [{ required: true, message: t("validation.required"), trigger: "change" }],
  open_mode: [{ required: true, message: t("validation.required"), trigger: "change" }]
}));

const resetForm = () => {
  Object.assign(form, { id: null, username: "", password: "", role: "user", open_mode: "terminal" });
};

const loadUser = async () => {
  if (isCreate.value) {
    resetForm();
    nextTick(() => formRef.value?.clearValidate());
    return;
  }

  loading.value = true;
  try {
    const response = await api.get("/users");
    const user = response.data.users.find((item) => String(item.id) === String(route.params.id));
    if (!user) {
      ElMessage.error(t("users.notFound"));
      router.push("/users");
      return;
    }
    Object.assign(form, { id: user.id, username: user.username, password: "", role: user.role, open_mode: user.open_mode });
    nextTick(() => formRef.value?.clearValidate());
  } catch (error) {
    ElMessage.error(t("common.loadFailed"));
  } finally {
    loading.value = false;
  }
};

const save = async () => {
  const valid = await formRef.value?.validate().catch(() => false);
  if (!valid) return;
  const confirmed = await confirmAction(t("common.confirmMutation"));
  if (!confirmed) return;
  loading.value = true;
  try {
    const payload = {
      username: form.username,
      role: form.role,
      open_mode: form.open_mode
    };

    if (isCreate.value) {
      payload.password = form.password;
      await api.post("/users", { user: payload });
      ElMessage.success(t("common.saved"));
    } else {
      await api.patch(`/users/${form.id}`, { user: payload });
      ElMessage.success(t("common.saved"));
    }

    router.push("/users");
  } catch (error) {
    ElMessage.error(resolveApiError(error, t("common.saveFailed")));
  } finally {
    loading.value = false;
  }
};

const goBack = () => {
  router.push("/users");
};

onMounted(loadUser);
watch(() => route.params.id, loadUser);
</script>

<style scoped>
.form-card {
  display: grid;
  gap: var(--space-24);
}

.form-grid {
  display: grid;
  grid-template-columns: minmax(240px, 1.1fr) minmax(200px, 0.9fr);
  gap: var(--space-24);
}

.form-aside {
  padding: var(--space-16);
  border: 1px solid var(--color-border-subtle);
  border-radius: var(--radius-md);
  background: rgba(20, 28, 37, 0.6);
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
}

.form-aside h3 {
  margin: 0 0 var(--space-8);
  font-size: var(--font-size-sm);
  color: var(--color-text-primary);
  text-transform: uppercase;
  letter-spacing: 0.12em;
}

.form-aside p {
  margin: 0 0 var(--space-12);
}

.form-aside ul {
  margin: 0;
  padding-left: var(--space-16);
  display: grid;
  gap: var(--space-8);
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: var(--space-12);
}

@media (max-width: 900px) {
  .form-grid {
    grid-template-columns: 1fr;
  }
}
</style>
