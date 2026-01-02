<template>
  <section class="admin-page">
    <ContentHeader :title="$t('permissions.title')" :subtitle="$t('permissions.subtitle')" />

    <div class="card table-card">
      <div class="table-toolbar">
        <div class="table-toolbar__meta">
          <span class="table-toolbar__title">{{ $t("permissions.listTitle") }}</span>
          <span class="table-toolbar__subtitle">{{ $t("permissions.listSubtitle") }}</span>
        </div>
      </div>
      <div class="table-filters">
        <el-select v-model="selectedUser" :placeholder="$t('permissions.selectUser')">
          <el-option v-for="user in users" :key="user.id" :label="user.username" :value="user.id" />
        </el-select>
        <el-select v-model="selectedGroup" :placeholder="$t('permissions.selectGroup')">
          <el-option v-for="group in groups" :key="group.id" :label="group.name" :value="group.id" />
        </el-select>
        <el-button type="primary" class="btn-primary" @click="assign">{{ $t("permissions.assign") }}</el-button>
      </div>

      <el-table :data="memberships" row-key="id" class="data-table">
        <el-table-column prop="user.username" :label="$t('app.username')" min-width="200" />
        <el-table-column prop="server_group.name" :label="$t('servers.group')" min-width="200" />
      </el-table>
    </div>
  </section>
</template>

<script setup>
import { onMounted, ref } from "vue";
import { useI18n } from "vue-i18n";
import { ElMessage } from "element-plus";
import api from "@/lib/api";
import ContentHeader from "@/components/ContentHeader.vue";

const users = ref([]);
const groups = ref([]);
const memberships = ref([]);
const selectedUser = ref(null);
const selectedGroup = ref(null);
const { t } = useI18n();

const loadUsers = async () => {
  const response = await api.get("/users");
  users.value = response.data.users;
};

const loadGroups = async () => {
  const response = await api.get("/server_groups");
  groups.value = response.data.server_groups;
};

const loadMemberships = async () => {
  const response = await api.get("/group_memberships");
  memberships.value = response.data.group_memberships;
};

const assign = async () => {
  if (!selectedUser.value || !selectedGroup.value) return;
  try {
    await api.post("/group_memberships", {
      group_membership: { user_id: selectedUser.value, server_group_id: selectedGroup.value }
    });
    ElMessage.success(t("common.saved"));
    await loadMemberships();
  } catch (error) {
    ElMessage.error(t("common.saveFailed"));
  }
};

onMounted(async () => {
  await Promise.all([loadUsers(), loadGroups(), loadMemberships()]);
});
</script>
