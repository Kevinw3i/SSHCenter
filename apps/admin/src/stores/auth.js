import { defineStore } from "pinia";
import axios from "axios";
import api from "@/lib/api";

const API_BASE = import.meta.env.VITE_API_BASE_URL || "http://localhost:3001/api/v1";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    token: localStorage.getItem("admin_token") || "",
    user: null
  }),
  getters: {
    isAuthenticated: (state) => Boolean(state.token)
  },
  actions: {
    setToken(token) {
      this.token = token;
      if (token) {
        localStorage.setItem("admin_token", token);
        axios.defaults.headers.common.Authorization = `Bearer ${token}`;
        api.defaults.headers.common.Authorization = `Bearer ${token}`;
      } else {
        localStorage.removeItem("admin_token");
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
    },
    async logout() {
      await axios.delete(`${API_BASE}/auth/logout`);
      this.setToken("");
      this.user = null;
    },
    async fetchMe() {
      const response = await axios.get(`${API_BASE}/auth/me`);
      this.user = response.data.user;
    }
  }
});
