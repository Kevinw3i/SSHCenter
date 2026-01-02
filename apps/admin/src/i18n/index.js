import { createI18n } from "vue-i18n";

const messages = {
  en: {
    app: {
      title: "SSCenter Admin",
      login: "Admin Sign In",
      username: "Username",
      password: "Password",
      otp: "One-time code",
      signIn: "Sign In",
      logout: "Log out"
    },
    nav: {
      users: "Users",
      servers: "Servers",
      permissions: "Permissions"
    },
    users: {
      title: "User Management",
      create: "Create User",
      edit: "Edit",
      otpQr: "OTP QR",
      role: "Role",
      openMode: "Open Mode"
    },
    servers: {
      title: "Server Management",
      create: "Create Server",
      group: "Group",
      site: "Site",
      env: "Env",
      role: "Role",
      ip: "IP"
    },
    permissions: {
      title: "Permission Management",
      assign: "Assign Group"
    }
  },
  "zh-TW": {
    app: {
      title: "SSCenter 後台",
      login: "後台登入",
      username: "帳號",
      password: "密碼",
      otp: "一次性驗證碼",
      signIn: "登入",
      logout: "登出"
    },
    nav: {
      users: "使用者",
      servers: "伺服器",
      permissions: "權限"
    },
    users: {
      title: "使用者管理",
      create: "新增帳號",
      edit: "編輯",
      otpQr: "OTP QR",
      role: "角色",
      openMode: "開啟方式"
    },
    servers: {
      title: "伺服器管理",
      create: "新增伺服器",
      group: "群組",
      site: "站點",
      env: "環境",
      role: "角色",
      ip: "IP"
    },
    permissions: {
      title: "權限管理",
      assign: "指派群組"
    }
  },
  "zh-CN": {
    app: {
      title: "SSCenter 后台",
      login: "后台登录",
      username: "账号",
      password: "密码",
      otp: "一次性验证码",
      signIn: "登录",
      logout: "退出"
    },
    nav: {
      users: "用户",
      servers: "服务器",
      permissions: "权限"
    },
    users: {
      title: "用户管理",
      create: "新建账号",
      edit: "编辑",
      otpQr: "OTP QR",
      role: "角色",
      openMode: "打开方式"
    },
    servers: {
      title: "服务器管理",
      create: "新建服务器",
      group: "分组",
      site: "站点",
      env: "环境",
      role: "角色",
      ip: "IP"
    },
    permissions: {
      title: "权限管理",
      assign: "分配分组"
    }
  }
};

const i18n = createI18n({
  legacy: false,
  locale: "zh-TW",
  fallbackLocale: "en",
  messages
});

export default i18n;
