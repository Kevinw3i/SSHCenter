import { defineStore } from "pinia";
import axios from "axios";
import api from "@/lib/api";

const API_BASE = import.meta.env.VITE_API_BASE_URL || "http://localhost:3001/api/v1";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    token: localStorage.getItem("web_token") || "",
    user: null,
    ip: ""
  }),
  getters: {
    isAuthenticated: (state) => Boolean(state.token)
  },
  actions: {
    setToken(token) {
      this.token = token;
      if (token) {
        localStorage.setItem("web_token", token);
        axios.defaults.headers.common.Authorization = `Bearer ${token}`;
        api.defaults.headers.common.Authorization = `Bearer ${token}`;
      } else {
        localStorage.removeItem("web_token");
        delete axios.defaults.headers.common.Authorization;
        delete api.defaults.headers.common.Authorization;
      }
    },
    async login({ username, password, otpCode }) {
      const response = await axios.post(`${API_BASE}/auth/login`, {
        user: {
          username,
          password,
          otp_code: otpCode
        }
      });
      const token = response.data.token || response.headers.authorization?.replace("Bearer ", "");
      this.setToken(token);
      this.user = response.data.user;
      await this.fetchMe();
    },
    async logout() {
      await axios.delete(`${API_BASE}/auth/logout`);
      this.setToken("");
      this.user = null;
      this.ip = "";
    },
    async fetchMe() {
      const response = await api.get("/auth/me");
      this.user = response.data.user;
      this.ip = response.data.ip;
    }
  }
});
