<template>
  <aside class="sidebar">
    <div class="brand">
      <div class="brand__row">
        <span class="brand__dot"></span>
        <span class="brand__title">{{ $t("app.title") }}</span>
      </div>
      <div class="brand__subtitle">Secure Shell Center</div>
    </div>
    <nav class="nav">
      <RouterLink to="/servers" class="nav__link">{{ $t("nav.servers") }}</RouterLink>
      <RouterLink to="/user" class="nav__link">{{ $t("nav.userInfo") }}</RouterLink>
    </nav>
  </aside>
</template>

<style scoped>
.sidebar {
  width: 240px;
  min-height: 100vh;
  border-right: 1px solid var(--color-border-subtle);
  padding: 28px 20px;
  background: rgba(11, 15, 20, 0.9);
}

.brand {
  margin-bottom: 30px;
}

.brand__row {
  display: flex;
  align-items: center;
  gap: 10px;
}

.brand__dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: var(--color-accent-neon);
  box-shadow: 0 0 12px rgba(124, 255, 107, 0.8);
}

.brand__title {
  font-family: var(--font-display);
  letter-spacing: 0.08em;
}

.brand__subtitle {
  margin-top: 6px;
  font-size: 12px;
  color: var(--color-text-muted);
}

.nav {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.nav__link {
  text-decoration: none;
  color: var(--color-text-secondary);
  padding: 10px 14px;
  border-radius: var(--radius-md);
  border: 1px solid transparent;
  transition: all var(--motion-fast) var(--motion-ease);
}

.nav__link.router-link-active {
  color: var(--color-text-primary);
  border-color: var(--color-border-strong);
  background: rgba(124, 255, 107, 0.08);
  box-shadow: var(--shadow-sm);
}

.nav__link:hover {
  color: var(--color-text-primary);
}
</style>
