import { createRouter, createWebHistory } from "vue-router";
import LoginView from "@/views/LoginView.vue";
import UserInfoView from "@/views/UserInfoView.vue";
import ServerListView from "@/views/ServerListView.vue";
import { useAuthStore } from "@/stores/auth";

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: "/login", name: "login", component: LoginView },
    { path: "/user", name: "user", component: UserInfoView },
    { path: "/servers", name: "servers", component: ServerListView },
    { path: "/", redirect: "/servers" }
  ]
});

router.beforeEach((to) => {
  const auth = useAuthStore();
  if (to.name !== "login" && !auth.isAuthenticated) {
    return { name: "login" };
  }
  if (to.name === "login" && auth.isAuthenticated) {
    return { name: "servers" };
  }
  return true;
});

export default router;
