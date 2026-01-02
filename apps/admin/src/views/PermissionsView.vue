<template>
  <section class="panel">
    <div class="panel__header">
      <div>
        <h2>{{ $t("permissions.title") }}</h2>
        <p>Assign server groups to frontend users.</p>
      </div>
    </div>

    <div class="assign">
      <el-select v-model="selectedUser" placeholder="Select user">
        <el-option v-for="user in users" :key="user.id" :label="user.username" :value="user.id" />
      </el-select>
      <el-select v-model="selectedGroup" placeholder="Select group">
        <el-option v-for="group in groups" :key="group.id" :label="group.name" :value="group.id" />
      </el-select>
      <el-button type="primary" @click="assign">{{ $t("permissions.assign") }}</el-button>
    </div>

    <el-table :data="memberships" style="width: 100%">
      <el-table-column prop="user.username" :label="$t('app.username')" />
      <el-table-column prop="server_group.name" :label="$t('servers.group')" />
    </el-table>
  </section>
</template>

<script setup>
import { onMounted, ref } from "vue";
import { ElMessage } from "element-plus";
import api from "@/lib/api";

const users = ref([]);
const groups = ref([]);
const memberships = ref([]);
const selectedUser = ref(null);
const selectedGroup = ref(null);

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
    ElMessage.success("Assigned");
    await loadMemberships();
  } catch (error) {
    ElMessage.error("Assignment failed");
  }
};

onMounted(async () => {
  await Promise.all([loadUsers(), loadGroups(), loadMemberships()]);
});
</script>

<style scoped>
.panel {
  background: rgba(20, 28, 37, 0.8);
  border: 1px solid var(--color-border-subtle);
  border-radius: var(--radius-lg);
  padding: 24px;
  box-shadow: var(--shadow-sm);
}

.panel__header {
  margin-bottom: 16px;
}

.assign {
  display: grid;
  grid-template-columns: 1fr 1fr auto;
  gap: 12px;
  align-items: center;
  margin-bottom: 20px;
}
</style>
