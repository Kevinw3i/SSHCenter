import { createI18n } from "vue-i18n";

const messages = {
  en: {
    app: {
      title: "SSCenter",
      login: "Secure Console Access",
      username: "Username",
      password: "Password",
      otp: "One-time code",
      signIn: "Enter",
      logout: "Log out",
      language: "Language"
    },
    nav: {
      userInfo: "User Info",
      servers: "Servers"
    },
    common: {
      confirmMutation: "This action will update data. Continue?",
      confirmLogout: "Log out and revoke the current session?"
    },
    status: {
      user: "User",
      time: "Time",
      ip: "IP"
    },
    user: {
      title: "User Settings",
      changePassword: "Change Password",
      currentPassword: "Current password",
      newPassword: "New password",
      sshKey: "SSH Public Key",
      openMode: "Open Mode",
      terminal: "Terminal",
      web: "Web",
      save: "Save"
    },
    servers: {
      title: "Server List",
      refresh: "Refresh",
      multiOpen: "Multi-open",
      openSelected: "Open Selected",
      empty: "No servers assigned yet. Contact an admin to get access.",
      back: "Back to list",
      connect: "Connect",
      site: "Site",
      env: "Env",
      role: "Role",
      ip: "IP"
    }
  },
  "zh-TW": {
    app: {
      title: "SSCenter",
      login: "安全連線登入",
      username: "帳號",
      password: "密碼",
      otp: "一次性驗證碼",
      signIn: "進入",
      logout: "登出",
      language: "語言"
    },
    nav: {
      userInfo: "使用者資訊",
      servers: "伺服器列表"
    },
    common: {
      confirmMutation: "此操作將更新資料，是否繼續？",
      confirmLogout: "是否登出並撤銷目前登入？"
    },
    status: {
      user: "使用者",
      time: "時間",
      ip: "IP"
    },
    user: {
      title: "使用者設定",
      changePassword: "修改密碼",
      currentPassword: "目前密碼",
      newPassword: "新密碼",
      sshKey: "SSH 公鑰",
      openMode: "開啟方式",
      terminal: "終端機",
      web: "網頁",
      save: "儲存"
    },
    servers: {
      title: "伺服器列表",
      refresh: "刷新",
      multiOpen: "多重開啟",
      openSelected: "開啟已選",
      empty: "尚未分配任何伺服器，請聯絡管理者。",
      back: "返回列表",
      connect: "連線",
      site: "站點",
      env: "環境",
      role: "角色",
      ip: "IP"
    }
  },
  "zh-CN": {
    app: {
      title: "SSCenter",
      login: "安全连接登录",
      username: "账号",
      password: "密码",
      otp: "一次性验证码",
      signIn: "进入",
      logout: "退出",
      language: "语言"
    },
    nav: {
      userInfo: "用户信息",
      servers: "服务器列表"
    },
    common: {
      confirmMutation: "此操作将更新数据，是否继续？",
      confirmLogout: "是否退出并撤销当前登录？"
    },
    status: {
      user: "用户",
      time: "时间",
      ip: "IP"
    },
    user: {
      title: "用户设置",
      changePassword: "修改密码",
      currentPassword: "当前密码",
      newPassword: "新密码",
      sshKey: "SSH 公钥",
      openMode: "打开方式",
      terminal: "终端机",
      web: "网页",
      save: "保存"
    },
    servers: {
      title: "服务器列表",
      refresh: "刷新",
      multiOpen: "多重打开",
      openSelected: "打开已选",
      empty: "尚未分配任何服务器，请联系管理员。",
      back: "返回列表",
      connect: "连接",
      site: "站点",
      env: "环境",
      role: "角色",
      ip: "IP"
    }
  }
};

const getInitialLocale = () => {
  if (typeof window === "undefined") return "zh-TW";
  return localStorage.getItem("sscenter_locale") || "zh-TW";
};

const i18n = createI18n({
  legacy: false,
  locale: getInitialLocale(),
  fallbackLocale: "en",
  messages
});

export default i18n;
