<template>
  <section class="panel">
    <div class="panel__header">
      <div>
        <h2>{{ $t("servers.title") }}</h2>
        <p>Maintain server inventory and groups.</p>
      </div>
      <el-button type="primary" @click="openCreate">{{ $t("servers.create") }}</el-button>
    </div>

    <div class="group-bar">
      <el-input v-model="newGroupName" placeholder="New group name" />
      <el-button plain @click="createGroup">Create Group</el-button>
    </div>

    <el-table :data="servers" style="width: 100%">
      <el-table-column prop="site" :label="$t('servers.site')" />
      <el-table-column prop="env" :label="$t('servers.env')" />
      <el-table-column prop="role" :label="$t('servers.role')" />
      <el-table-column prop="ip" :label="$t('servers.ip')" />
      <el-table-column prop="server_group.name" :label="$t('servers.group')" />
    </el-table>

    <el-dialog v-model="dialogVisible" title="Create Server" width="440px">
      <el-form :model="form" label-position="top">
        <el-form-item :label="$t('servers.site')">
          <el-input v-model="form.site" />
        </el-form-item>
        <el-form-item :label="$t('servers.env')">
          <el-input v-model="form.env" />
        </el-form-item>
        <el-form-item :label="$t('servers.role')">
          <el-input v-model="form.role" />
        </el-form-item>
        <el-form-item :label="$t('servers.ip')">
          <el-input v-model="form.ip" />
        </el-form-item>
        <el-form-item :label="$t('servers.group')">
          <el-select v-model="form.server_group_id" placeholder="Select group">
            <el-option v-for="group in groups" :key="group.id" :label="group.name" :value="group.id" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">Cancel</el-button>
        <el-button type="primary" @click="save">Save</el-button>
      </template>
    </el-dialog>
  </section>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue";
import { ElMessage } from "element-plus";
import api from "@/lib/api";

const servers = ref([]);
const groups = ref([]);
const dialogVisible = ref(false);
const newGroupName = ref("");
const form = reactive({
  site: "",
  env: "",
  role: "",
  ip: "",
  server_group_id: null
});

const loadServers = async () => {
  const response = await api.get("/admin/servers");
  servers.value = response.data.servers;
};

const loadGroups = async () => {
  const response = await api.get("/server_groups");
  groups.value = response.data.server_groups;
};

const openCreate = () => {
  Object.assign(form, { site: "", env: "", role: "", ip: "", server_group_id: groups.value[0]?.id || null });
  dialogVisible.value = true;
};

const save = async () => {
  try {
    await api.post("/servers", { server: form });
    dialogVisible.value = false;
    await loadServers();
    ElMessage.success("Saved");
  } catch (error) {
    ElMessage.error("Save failed");
  }
};

const createGroup = async () => {
  if (!newGroupName.value) return;
  await api.post("/server_groups", { server_group: { name: newGroupName.value } });
  newGroupName.value = "";
  await loadGroups();
};

onMounted(async () => {
  await Promise.all([loadServers(), loadGroups()]);
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
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.group-bar {
  display: flex;
  gap: 12px;
  align-items: center;
  margin-bottom: 16px;
}
</style>
