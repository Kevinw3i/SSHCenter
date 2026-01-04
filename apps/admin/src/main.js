import { createApp } from "vue";
import { createPinia } from "pinia";
import axios from "axios";
import ElementPlus from "element-plus";
import App from "./App.vue";
import router from "./router";
import i18n from "./i18n";
import { useAuthStore } from "./stores/auth";
import api from "./lib/api";
import "./styles/base.css";

const app = createApp(App);
const pinia = createPinia();

app.use(pinia);
app.use(router);
app.use(i18n);
app.use(ElementPlus);

const auth = useAuthStore(pinia);

let isRedirecting = false;
const attachUnauthorizedHandler = (client) => {
  client.interceptors.response.use(
    (response) => response,
    (error) => {
      const status = error?.response?.status;
      const requestUrl = error?.config?.url || "";
      if (status === 401 && !requestUrl.includes("/auth/login")) {
        auth.setToken("");
        auth.user = null;
        if (!isRedirecting && router.currentRoute.value.name !== "login") {
          isRedirecting = true;
          router.push({ name: "login" }).finally(() => {
            isRedirecting = false;
          });
        }
      }
      return Promise.reject(error);
    }
  );
};

attachUnauthorizedHandler(api);
attachUnauthorizedHandler(axios);
if (auth.token) {
  auth.setToken(auth.token);
}

app.mount("#app");
