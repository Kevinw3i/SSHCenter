<template>
  <section class="admin-page">
    <ContentHeader :title="$t('servers.title')" :subtitle="$t('servers.subtitle')">
      <template #actions>
        <el-button type="primary" class="btn-primary" @click="openCreate">
          {{ $t("servers.create") }}
        </el-button>
      </template>
    </ContentHeader>

    <div class="card table-card">
      <div class="table-toolbar">
        <div class="table-toolbar__meta">
          <span class="table-toolbar__title">{{ $t("servers.listTitle") }}</span>
          <span class="table-toolbar__subtitle">{{ $t("servers.listSubtitle") }}</span>
        </div>
      </div>
      <div class="table-filters">
        <el-input v-model="newGroupName" :placeholder="$t('servers.groupPlaceholder')" />
        <el-button class="btn-secondary" @click="createGroup">{{ $t("servers.groupCreate") }}</el-button>
      </div>
      <el-table :data="servers" row-key="id" class="data-table">
        <el-table-column prop="site" :label="$t('servers.site')" min-width="140" />
        <el-table-column prop="env" :label="$t('servers.env')" min-width="120" />
        <el-table-column prop="role" :label="$t('servers.role')" min-width="120" />
        <el-table-column prop="ip" :label="$t('servers.ip')" min-width="160" />
        <el-table-column prop="server_group.name" :label="$t('servers.group')" min-width="160" />
        <el-table-column :label="$t('servers.actions')" width="140" align="right" header-align="right">
          <template #default="scope">
            <div class="table-actions">
              <el-button text size="small" class="btn-link" @click="openEdit(scope.row)">
                {{ $t("servers.edit") }}
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="440px">
      <el-form :model="form" label-position="top" class="admin-form">
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
          <el-select v-model="form.server_group_id" :placeholder="$t('servers.groupSelect')">
            <el-option v-for="group in groups" :key="group.id" :label="group.name" :value="group.id" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button class="btn-secondary" @click="dialogVisible = false">{{ $t("common.cancel") }}</el-button>
        <el-button type="primary" class="btn-primary" @click="save">{{ $t("common.save") }}</el-button>
      </template>
    </el-dialog>
  </section>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from "vue";
import { useI18n } from "vue-i18n";
import { ElMessage } from "element-plus";
import api from "@/lib/api";
import ContentHeader from "@/components/ContentHeader.vue";

const servers = ref([]);
const groups = ref([]);
const dialogVisible = ref(false);
const newGroupName = ref("");
const { t } = useI18n();
const isEdit = ref(false);
const dialogTitle = computed(() => (isEdit.value ? t("servers.editTitle") : t("servers.createTitle")));
const form = reactive({
  id: null,
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
  isEdit.value = false;
  Object.assign(form, { id: null, site: "", env: "", role: "", ip: "", server_group_id: groups.value[0]?.id || null });
  dialogVisible.value = true;
};

const openEdit = (server) => {
  isEdit.value = true;
  Object.assign(form, {
    id: server.id,
    site: server.site,
    env: server.env,
    role: server.role,
    ip: server.ip,
    server_group_id: server.server_group_id || server.server_group?.id || null
  });
  dialogVisible.value = true;
};

const save = async () => {
  try {
    const payload = {
      site: form.site,
      env: form.env,
      role: form.role,
      ip: form.ip,
      server_group_id: form.server_group_id
    };
    if (isEdit.value) {
      await api.patch(`/servers/${form.id}`, { server: payload });
    } else {
      await api.post("/servers", { server: payload });
    }
    dialogVisible.value = false;
    await loadServers();
    ElMessage.success(t("common.saved"));
  } catch (error) {
    ElMessage.error(t("common.saveFailed"));
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
