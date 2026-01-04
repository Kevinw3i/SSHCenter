<template>
  <section class="admin-page">
    <ContentHeader :title="$t('groups.title')" :subtitle="$t('groups.subtitle')">
      <template #actions>
        <el-button type="primary" class="btn-primary" @click="openCreate">
          {{ $t("groups.create") }}
        </el-button>
      </template>
    </ContentHeader>

    <div class="card table-card">
      <div class="table-toolbar">
        <div class="table-toolbar__meta">
          <span class="table-toolbar__title">{{ $t("groups.listTitle") }}</span>
          <span class="table-toolbar__subtitle">
            {{ $t("groups.listSubtitle") }} · {{ $t("groups.countLabel", { count: groups.length }) }}
          </span>
        </div>
      </div>
      <el-table :data="groups" row-key="id" class="data-table" v-loading="loading">
        <template #empty>
          <TableEmpty :description="$t('groups.empty')" />
        </template>
        <el-table-column prop="name" :label="$t('groups.name')" min-width="220" />
        <el-table-column :label="$t('groups.servers')" width="160">
          <template #default="scope">
            <span>{{ scope.row.servers_count ?? scope.row.server_ids?.length ?? 0 }}</span>
          </template>
        </el-table-column>
        <el-table-column :label="$t('groups.actions')" width="180" align="right" header-align="right">
          <template #default="scope">
            <div class="table-actions">
              <el-button text size="small" class="btn-link" @click="openEdit(scope.row)">
                {{ $t("common.edit") }}
              </el-button>
              <el-button text size="small" class="btn-link" @click="removeGroup(scope.row)">
                {{ $t("common.delete") }}
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="480px"
      :close-on-click-modal="false"
      :close-on-press-escape="false"
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-position="top" class="admin-form" :disabled="saving">
        <el-form-item :label="$t('groups.name')" prop="name">
          <el-input v-model="form.name" />
        </el-form-item>
        <el-form-item :label="$t('groups.servers')">
          <AdminSelect
            v-model="form.server_ids"
            :placeholder="$t('groups.serversPlaceholder')"
            :options="serverOptions"
            multiple
            filterable
            clearable
            collapse-tags
            :max-collapse-tags="2"
            :loading="loadingServers"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button class="btn-secondary" :disabled="saving" @click="dialogVisible = false">
          {{ $t("common.cancel") }}
        </el-button>
        <el-button type="primary" class="btn-primary" :loading="saving" @click="save">
          {{ $t("common.save") }}
        </el-button>
      </template>
    </el-dialog>
  </section>
</template>

<script setup>
import { computed, nextTick, onMounted, reactive, ref } from "vue";
import { useI18n } from "vue-i18n";
import { ElMessage } from "element-plus";
import api from "@/lib/api";
import ContentHeader from "@/components/ContentHeader.vue";
import AdminSelect from "@/components/AdminSelect.vue";
import { confirmAction } from "@/lib/confirm";
import TableEmpty from "@/components/TableEmpty.vue";

const groups = ref([]);
const servers = ref([]);
const dialogVisible = ref(false);
const isEdit = ref(false);
const saving = ref(false);
const loading = ref(false);
const loadingServers = ref(false);
const formRef = ref(null);
const { t } = useI18n();

const form = reactive({
  id: null,
  name: "",
  server_ids: []
});

const dialogTitle = computed(() => (isEdit.value ? t("groups.editTitle") : t("groups.createTitle")));
const rules = computed(() => ({
  name: [{ required: true, message: t("validation.required"), trigger: "blur" }]
}));

const serverOptions = computed(() =>
  servers.value.map((server) => ({
    value: server.id,
    label: `${server.site} / ${server.env} / ${server.role} - ${server.ip}`
  }))
);

const loadGroups = async () => {
  loading.value = true;
  try {
    const response = await api.get("/server_groups");
    groups.value = response.data.server_groups;
  } catch (error) {
    ElMessage.error(t("common.loadFailed"));
  } finally {
    loading.value = false;
  }
};

const loadServers = async () => {
  loadingServers.value = true;
  try {
    const response = await api.get("/admin/servers");
    servers.value = response.data.servers;
  } catch (error) {
    ElMessage.error(t("common.loadFailed"));
  } finally {
    loadingServers.value = false;
  }
};

const openCreate = () => {
  isEdit.value = false;
  Object.assign(form, { id: null, name: "", server_ids: [] });
  dialogVisible.value = true;
  nextTick(() => formRef.value?.clearValidate());
};

const openEdit = (group) => {
  isEdit.value = true;
  Object.assign(form, {
    id: group.id,
    name: group.name,
    server_ids: [...(group.server_ids || [])]
  });
  dialogVisible.value = true;
  nextTick(() => formRef.value?.clearValidate());
};

const save = async () => {
  const valid = await formRef.value?.validate().catch(() => false);
  if (!valid) return;
  const confirmed = await confirmAction(t("common.confirmMutation"));
  if (!confirmed) return;
  saving.value = true;
  try {
    const payload = { name: form.name, server_ids: form.server_ids };
    if (isEdit.value) {
      await api.patch(`/server_groups/${form.id}`, { server_group: payload });
    } else {
      await api.post("/server_groups", { server_group: payload });
    }
    dialogVisible.value = false;
    await Promise.all([loadGroups(), loadServers()]);
    ElMessage.success(t("common.saved"));
  } catch (error) {
    ElMessage.error(t("common.saveFailed"));
  } finally {
    saving.value = false;
  }
};

const removeGroup = async (group) => {
  const confirmed = await confirmAction(t("groups.confirmDelete"));
  if (!confirmed) return;
  try {
    await api.delete(`/server_groups/${group.id}`);
    await Promise.all([loadGroups(), loadServers()]);
    ElMessage.success(t("common.saved"));
  } catch (error) {
    ElMessage.error(t("common.saveFailed"));
  }
};

onMounted(() => {
  loadGroups();
  loadServers();
});
</script>
