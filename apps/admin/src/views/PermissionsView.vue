<template>
  <section class="admin-page">
    <ContentHeader :title="$t('permissions.title')" :subtitle="$t('permissions.subtitle')" />

    <div class="card table-card">
      <div class="table-toolbar">
        <div class="table-toolbar__meta">
          <span class="table-toolbar__title">{{ $t("permissions.listTitle") }}</span>
          <span class="table-toolbar__subtitle">
            {{ $t("permissions.listSubtitle") }} ·
            {{ $t("permissions.countLabel", { count: memberships.length }) }}
          </span>
        </div>
      </div>
      <div class="table-filters">
        <AdminSelect
          v-model="selectedUser"
          :placeholder="$t('permissions.selectUser')"
          :options="users"
          option-label="username"
          option-value="id"
          filterable
          clearable
          size="small"
          :loading="loadingUsers"
        />
        <AdminSelect
          v-model="selectedGroup"
          :placeholder="$t('permissions.selectGroup')"
          :options="groups"
          option-label="name"
          option-value="id"
          filterable
          clearable
          size="small"
          :loading="loadingGroups"
        />
        <el-button type="primary" class="btn-primary" :loading="assigning" :disabled="assignDisabled" @click="assign">
          {{ $t("permissions.assign") }}
        </el-button>
      </div>

      <el-table :data="memberships" row-key="id" class="data-table" v-loading="loadingMemberships">
        <template #empty>
          <TableEmpty :description="$t('permissions.empty')" />
        </template>
        <el-table-column prop="user.username" :label="$t('app.username')" min-width="200" />
        <el-table-column prop="server_group.name" :label="$t('servers.group')" min-width="200" />
        <el-table-column :label="$t('users.actions')" width="140" align="right" header-align="right">
          <template #default="scope">
            <div class="table-actions">
              <el-button text size="small" class="btn-link" @click="remove(scope.row)">
                {{ $t("common.delete") }}
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </section>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useI18n } from "vue-i18n";
import { ElMessage } from "element-plus";
import api from "@/lib/api";
import ContentHeader from "@/components/ContentHeader.vue";
import AdminSelect from "@/components/AdminSelect.vue";
import { confirmAction } from "@/lib/confirm";
import TableEmpty from "@/components/TableEmpty.vue";

const users = ref([]);
const groups = ref([]);
const memberships = ref([]);
const selectedUser = ref(null);
const selectedGroup = ref(null);
const loadingUsers = ref(false);
const loadingGroups = ref(false);
const loadingMemberships = ref(false);
const assigning = ref(false);
const { t } = useI18n();

const assignDisabled = computed(
  () => assigning.value || loadingUsers.value || loadingGroups.value || !selectedUser.value || !selectedGroup.value
);

const loadUsers = async () => {
  loadingUsers.value = true;
  try {
    const response = await api.get("/users");
    users.value = response.data.users;
  } finally {
    loadingUsers.value = false;
  }
};

const loadGroups = async () => {
  loadingGroups.value = true;
  try {
    const response = await api.get("/server_groups");
    groups.value = response.data.server_groups;
  } finally {
    loadingGroups.value = false;
  }
};

const loadMemberships = async () => {
  loadingMemberships.value = true;
  try {
    const response = await api.get("/group_memberships");
    memberships.value = response.data.group_memberships;
  } catch (error) {
    ElMessage.error(t("common.loadFailed"));
  } finally {
    loadingMemberships.value = false;
  }
};

const assign = async () => {
  if (assignDisabled.value) return;
  const confirmed = await confirmAction(t("common.confirmMutation"));
  if (!confirmed) return;
  assigning.value = true;
  try {
    await api.post("/group_memberships", {
      group_membership: { user_id: selectedUser.value, server_group_id: selectedGroup.value }
    });
    ElMessage.success(t("common.saved"));
    selectedUser.value = null;
    selectedGroup.value = null;
    await loadMemberships();
  } catch (error) {
    ElMessage.error(t("common.saveFailed"));
  } finally {
    assigning.value = false;
  }
};

const remove = async (membership) => {
  const confirmed = await confirmAction(t("permissions.confirmRemove"));
  if (!confirmed) return;
  try {
    await api.delete(`/group_memberships/${membership.id}`);
    await loadMemberships();
    ElMessage.success(t("common.saved"));
  } catch (error) {
    ElMessage.error(t("common.saveFailed"));
  }
};

onMounted(async () => {
  await Promise.all([loadUsers(), loadGroups(), loadMemberships()]);
});
</script>
