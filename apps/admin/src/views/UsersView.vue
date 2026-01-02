<template>
  <section class="admin-page">
    <ContentHeader :title="$t('users.title')" :subtitle="$t('users.subtitle')">
      <template #actions>
        <el-button type="primary" class="btn-primary" @click="goCreate">{{ $t("users.create") }}</el-button>
      </template>
    </ContentHeader>

    <div class="card table-card">
      <div class="table-toolbar">
        <div class="table-toolbar__meta">
          <span class="table-toolbar__title">{{ $t("users.listTitle") }}</span>
          <span class="table-toolbar__subtitle">
            {{ $t("users.countLabel", { count: users.length }) }}
          </span>
        </div>
      </div>
      <el-table :data="users" row-key="id" class="data-table">
        <el-table-column prop="id" label="ID" width="80" align="center" header-align="center" />
        <el-table-column prop="username" :label="$t('app.username')" min-width="180" />
        <el-table-column prop="role" :label="$t('users.role')" width="140">
          <template #default="scope">
            <el-tag size="small" effect="plain" :type="roleTagType(scope.row.role)">
              {{ scope.row.role }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="open_mode" :label="$t('users.openMode')" width="160">
          <template #default="scope">
            <el-tag size="small" effect="plain" type="info">
              {{ scope.row.open_mode }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column :label="$t('users.actions')" width="200" align="right" header-align="right">
          <template #default="scope">
            <div class="table-actions">
              <el-button text size="small" class="btn-link" @click="goEdit(scope.row)">
                {{ $t("users.edit") }}
              </el-button>
              <el-button text size="small" class="btn-link" @click="openOtp(scope.row)">
                {{ $t("users.otpQr") }}
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog v-model="otpVisible" class="otp-dialog" :title="$t('users.otpTitle')" width="360px">
      <div class="otp-modal">
        <p class="otp-modal__hint">{{ $t("users.otpSubtitle") }}</p>
        <div class="otp-box" v-html="otpSvg" />
      </div>
    </el-dialog>
  </section>
</template>

<script setup>
import { onMounted, ref } from "vue";
import { useI18n } from "vue-i18n";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import api from "@/lib/api";
import ContentHeader from "@/components/ContentHeader.vue";

const router = useRouter();
const { t } = useI18n();
const users = ref([]);
const otpVisible = ref(false);
const otpSvg = ref("");

const loadUsers = async () => {
  const response = await api.get("/users");
  users.value = response.data.users;
};

const goCreate = () => {
  router.push("/users/new");
};

const goEdit = (user) => {
  router.push(`/users/${user.id}/edit`);
};

const roleTagType = (role) => {
  if (role === "admin") return "danger";
  if (role === "manage") return "warning";
  return "info";
};

const openOtp = async (user) => {
  try {
    const response = await api.get(`/users/${user.id}/otp_qr`);
    otpSvg.value = response.data.qr_svg;
    otpVisible.value = true;
  } catch (error) {
    ElMessage.error(t("common.loadFailed"));
  }
};

onMounted(async () => {
  try {
    await loadUsers();
  } catch (error) {
    ElMessage.error(t("common.loadFailed"));
  }
});
</script>

<style scoped>
.otp-modal {
  display: grid;
  gap: var(--space-12);
}

.otp-modal__hint {
  margin: 0;
  font-size: var(--font-size-xs);
  color: var(--color-text-muted);
}

.otp-box {
  display: grid;
  place-items: center;
  padding: var(--space-16);
  background: #fff;
  border-radius: var(--radius-md);
}
</style>
