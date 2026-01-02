<template>
  <section class="panel servers-panel">
    <header class="panel__header">
      <div>
        <h2 class="terminal-heading">{{ $t("servers.title") }}</h2>
        <div class="panel__subtitle">access.scope :: group-based</div>
      </div>
      <div class="panel__actions">
        <button class="ghost" @click="refresh">{{ $t("servers.refresh") }}</button>
        <label class="toggle">
          <input type="checkbox" v-model="multiOpen" />
          {{ $t("servers.multiOpen") }}
        </label>
        <button v-if="multiOpen" class="primary" @click="openSelected">
          {{ $t("servers.openSelected") }}
        </button>
      </div>
    </header>

    <div v-if="servers.length === 0" class="empty">
      {{ $t("servers.empty") }}
    </div>

    <table v-else class="server-table">
      <thead>
        <tr>
          <th v-if="multiOpen"></th>
          <th>{{ $t("servers.site") }}</th>
          <th>{{ $t("servers.env") }}</th>
          <th>{{ $t("servers.role") }}</th>
          <th>{{ $t("servers.ip") }}</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="server in servers" :key="server.id">
          <td v-if="multiOpen">
            <input type="checkbox" :value="server.id" v-model="selectedIds" />
          </td>
          <td>{{ server.site }}</td>
          <td>{{ server.env }}</td>
          <td>{{ server.role }}</td>
          <td>{{ server.ip }}</td>
          <td>
            <button class="ghost" @click="openServer(server)">
              {{ $t("servers.connect") }}
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <div v-if="terminalCommands.length" class="command-box">
      <div class="command-title">Terminal commands</div>
      <div class="command" v-for="command in terminalCommands" :key="command">
        {{ command }}
      </div>
    </div>

    <div v-if="sessions.length" class="sessions">
      <TerminalSession
        v-for="session in sessions"
        :key="session.id"
        :server="session"
        @close="closeSession(session)"
      />
    </div>
  </section>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import api from "@/lib/api";
import { useAuthStore } from "@/stores/auth";
import TerminalSession from "@/components/TerminalSession.vue";

const auth = useAuthStore();
const servers = ref([]);
const multiOpen = ref(false);
const selectedIds = ref([]);
const sessions = ref([]);
const terminalCommands = ref([]);

const openMode = computed(() => auth.user?.open_mode || "terminal");

const refresh = async () => {
  const response = await api.get("/servers");
  servers.value = response.data.servers;
};

const openServer = (server) => {
  if (openMode.value === "web") {
    if (!sessions.value.find((item) => item.id === server.id)) {
      sessions.value.push(server);
    }
    return;
  }

  const command = `ssh ${auth.user?.username || "user"}@${server.ip}`;
  terminalCommands.value = [command, ...terminalCommands.value].slice(0, 5);
  window.open(`ssh://${server.ip}`, "_blank");
};

const openSelected = () => {
  const selected = servers.value.filter((server) => selectedIds.value.includes(server.id));
  selected.forEach(openServer);
  selectedIds.value = [];
};

const closeSession = (server) => {
  sessions.value = sessions.value.filter((item) => item.id !== server.id);
};

onMounted(async () => {
  await auth.fetchMe();
  await refresh();
});
</script>

<style scoped>
.servers-panel {
  padding: 24px;
}

.panel__header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 18px;
}

.panel__subtitle {
  font-size: 12px;
  color: var(--color-text-muted);
}

.panel__actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.server-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}

.server-table th,
.server-table td {
  padding: 12px;
  border-bottom: 1px solid var(--color-border-subtle);
}

.empty {
  padding: 30px;
  color: var(--color-text-muted);
}

.toggle {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
}

.ghost,
.primary {
  border: 1px solid var(--color-border-strong);
  background: transparent;
  color: var(--color-text-primary);
  padding: 8px 14px;
  border-radius: var(--radius-md);
  cursor: pointer;
}

.primary {
  border-color: var(--color-accent-neon);
  color: var(--color-accent-neon);
}

.command-box {
  margin-top: 18px;
  padding: 12px;
  border: 1px solid var(--color-border-subtle);
  border-radius: var(--radius-md);
  background: rgba(10, 14, 20, 0.8);
}

.command-title {
  font-size: 11px;
  text-transform: uppercase;
  color: var(--color-text-muted);
  margin-bottom: 8px;
}

.command {
  font-size: 12px;
}

.sessions {
  margin-top: 20px;
  display: grid;
  gap: 16px;
}
</style>
