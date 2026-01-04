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
          <span class="table-toolbar__subtitle">
            {{ $t("servers.listSubtitle") }} · {{ $t("servers.countLabel", { count: servers.length }) }}
          </span>
        </div>
      </div>
      <el-table :data="servers" row-key="id" class="data-table" v-loading="loading">
        <template #empty>
          <TableEmpty :description="$t('servers.empty')">
            <template #action>
              <el-button type="primary" class="btn-primary" @click="openCreate">
                {{ $t("servers.create") }}
              </el-button>
            </template>
          </TableEmpty>
        </template>
        <el-table-column prop="site" :label="$t('servers.site')" min-width="140" />
        <el-table-column prop="env" :label="$t('servers.env')" min-width="120" />
        <el-table-column prop="role" :label="$t('servers.role')" min-width="120" />
        <el-table-column prop="ip" :label="$t('servers.ip')" min-width="160" />
        <el-table-column :label="$t('servers.actions')" width="200" align="right" header-align="right">
          <template #default="scope">
            <div class="table-actions">
              <el-button text size="small" class="btn-link" @click="openEdit(scope.row)">
                {{ $t("servers.edit") }}
              </el-button>
              <el-button text size="small" class="btn-link" @click="removeServer(scope.row)">
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
      width="440px"
      :close-on-click-modal="false"
      :close-on-press-escape="false"
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-position="top" class="admin-form" :disabled="saving">
        <el-form-item :label="$t('servers.site')" prop="site">
          <el-input v-model="form.site" />
        </el-form-item>
        <el-form-item :label="$t('servers.env')" prop="env">
          <el-input v-model="form.env" />
        </el-form-item>
        <el-form-item :label="$t('servers.role')" prop="role">
          <el-input v-model="form.role" />
        </el-form-item>
        <el-form-item :label="$t('servers.ip')" prop="ip">
          <el-input v-model="form.ip" />
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
import { confirmAction } from "@/lib/confirm";
import TableEmpty from "@/components/TableEmpty.vue";
import { resolveApiError } from "@/lib/errors";

const servers = ref([]);
const dialogVisible = ref(false);
const { t } = useI18n();
const isEdit = ref(false);
const loading = ref(false);
const saving = ref(false);
const formRef = ref(null);
const dialogTitle = computed(() => (isEdit.value ? t("servers.editTitle") : t("servers.createTitle")));
const form = reactive({
  id: null,
  site: "",
  env: "",
  role: "",
  ip: ""
});

const ipRegex =
  /^(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}$/;

const rules = computed(() => ({
  site: [{ required: true, message: t("validation.required"), trigger: "blur" }],
  env: [{ required: true, message: t("validation.required"), trigger: "blur" }],
  role: [{ required: true, message: t("validation.required"), trigger: "blur" }],
  ip: [
    { required: true, message: t("validation.required"), trigger: "blur" },
    {
      validator: (_, value, callback) => {
        if (!value || ipRegex.test(value)) {
          callback();
          return;
        }
        callback(new Error(t("validation.invalidIp")));
      },
      trigger: "blur"
    }
  ]
}));

const loadServers = async () => {
  loading.value = true;
  try {
    const response = await api.get("/admin/servers");
    servers.value = response.data.servers;
  } catch (error) {
    ElMessage.error(t("common.loadFailed"));
  } finally {
    loading.value = false;
  }
};

const openCreate = () => {
  isEdit.value = false;
  Object.assign(form, { id: null, site: "", env: "", role: "", ip: "" });
  dialogVisible.value = true;
  nextTick(() => formRef.value?.clearValidate());
};

const openEdit = (server) => {
  isEdit.value = true;
  Object.assign(form, {
    id: server.id,
    site: server.site,
    env: server.env,
    role: server.role,
    ip: server.ip
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
    const payload = {
      site: form.site,
      env: form.env,
      role: form.role,
      ip: form.ip
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
    ElMessage.error(resolveApiError(error, t("common.saveFailed")));
  } finally {
    saving.value = false;
  }
};

const removeServer = async (server) => {
  const confirmed = await confirmAction(t("common.confirmDelete"));
  if (!confirmed) return;
  try {
    await api.delete(`/servers/${server.id}`);
    await loadServers();
    ElMessage.success(t("common.saved"));
  } catch (error) {
    ElMessage.error(resolveApiError(error, t("common.saveFailed")));
  }
};

onMounted(loadServers);
</script>
