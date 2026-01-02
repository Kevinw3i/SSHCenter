import { createRouter, createWebHistory } from "vue-router";
import LoginView from "@/views/LoginView.vue";
import UsersView from "@/views/UsersView.vue";
import ServersView from "@/views/ServersView.vue";
import PermissionsView from "@/views/PermissionsView.vue";
import { useAuthStore } from "@/stores/auth";

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: "/login", name: "login", component: LoginView },
    { path: "/users", name: "users", component: UsersView },
    { path: "/servers", name: "servers", component: ServersView },
    { path: "/permissions", name: "permissions", component: PermissionsView },
    { path: "/", redirect: "/users" }
  ]
});

router.beforeEach((to) => {
  const auth = useAuthStore();
  if (to.name !== "login" && !auth.isAuthenticated) {
    return { name: "login" };
  }
  if (to.name === "login" && auth.isAuthenticated) {
    return { name: "users" };
  }
  return true;
});

export default router;
