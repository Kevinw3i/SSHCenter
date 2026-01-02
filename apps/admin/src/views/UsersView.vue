<template>
  <section class="panel">
    <div class="panel__header">
      <div>
        <h2>{{ $t("users.title") }}</h2>
        <p>Manage accounts, roles, and OTP.</p>
      </div>
      <el-button type="primary" @click="openCreate">{{ $t("users.create") }}</el-button>
    </div>

    <el-table :data="users" style="width: 100%">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="username" :label="$t('app.username')" />
      <el-table-column prop="role" :label="$t('users.role')" width="120" />
      <el-table-column prop="open_mode" :label="$t('users.openMode')" width="140" />
      <el-table-column label="Actions" width="220">
        <template #default="scope">
          <el-button size="small" @click="openEdit(scope.row)">{{ $t("users.edit") }}</el-button>
          <el-button size="small" plain @click="openOtp(scope.row)">{{ $t("users.otpQr") }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="420px">
      <el-form :model="form" label-position="top">
        <el-form-item :label="$t('app.username')">
          <el-input v-model="form.username" />
        </el-form-item>
        <el-form-item :label="$t('app.password')" v-if="isCreate">
          <el-input v-model="form.password" type="password" />
        </el-form-item>
        <el-form-item :label="$t('users.role')">
          <el-select v-model="form.role">
            <el-option label="admin" value="admin" />
            <el-option label="manage" value="manage" />
            <el-option label="user" value="user" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('users.openMode')">
          <el-select v-model="form.open_mode">
            <el-option label="terminal" value="terminal" />
            <el-option label="web" value="web" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">Cancel</el-button>
        <el-button type="primary" @click="save">Save</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="otpVisible" title="OTP QR" width="360px">
      <div class="otp-box" v-html="otpSvg" />
    </el-dialog>
  </section>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue";
import { ElMessage } from "element-plus";
import api from "@/lib/api";

const users = ref([]);
const dialogVisible = ref(false);
const otpVisible = ref(false);
const otpSvg = ref("");
const isCreate = ref(true);
const dialogTitle = ref("");
const form = reactive({
  id: null,
  username: "",
  password: "",
  role: "user",
  open_mode: "terminal"
});

const loadUsers = async () => {
  const response = await api.get("/users");
  users.value = response.data.users;
};

const openCreate = () => {
  isCreate.value = true;
  dialogTitle.value = "Create User";
  Object.assign(form, { id: null, username: "", password: "", role: "user", open_mode: "terminal" });
  dialogVisible.value = true;
};

const openEdit = (user) => {
  isCreate.value = false;
  dialogTitle.value = "Edit User";
  Object.assign(form, { id: user.id, username: user.username, password: "", role: user.role, open_mode: user.open_mode });
  dialogVisible.value = true;
};

const save = async () => {
  const payload = { ...form };
  if (!payload.password) delete payload.password;
  try {
    if (isCreate.value) {
      await api.post("/users", { user: payload });
    } else {
      await api.patch(`/users/${form.id}`, { user: payload });
    }
    dialogVisible.value = false;
    await loadUsers();
    ElMessage.success("Saved");
  } catch (error) {
    ElMessage.error("Save failed");
  }
};

const openOtp = async (user) => {
  const response = await api.get(`/users/${user.id}/otp_qr`);
  otpSvg.value = response.data.qr_svg;
  otpVisible.value = true;
};

onMounted(loadUsers);
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
  margin-bottom: 20px;
}

.panel__header h2 {
  margin: 0 0 6px;
  font-size: 20px;
}

.panel__header p {
  margin: 0;
  color: var(--color-text-muted);
}

.otp-box {
  display: grid;
  place-items: center;
  padding: 16px;
  background: #fff;
}
</style>
