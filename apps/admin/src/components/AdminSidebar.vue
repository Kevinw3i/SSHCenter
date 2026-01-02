<template>
  <aside class="sidebar">
    <div class="brand">
      <span class="brand__mark">◆</span>
      <span class="brand__title">{{ $t("app.title") }}</span>
    </div>
    <nav class="nav">
      <RouterLink to="/users" class="nav__link">{{ $t("nav.users") }}</RouterLink>
      <RouterLink to="/servers" class="nav__link">{{ $t("nav.servers") }}</RouterLink>
      <RouterLink to="/permissions" class="nav__link">{{ $t("nav.permissions") }}</RouterLink>
    </nav>
  </aside>
</template>

<style scoped>
.sidebar {
  width: 240px;
  min-height: 100vh;
  background: linear-gradient(180deg, rgba(20, 28, 37, 0.98), rgba(11, 15, 20, 0.98));
  border-right: 1px solid var(--color-border-subtle);
  padding: 24px 18px;
}

.brand {
  display: flex;
  align-items: center;
  gap: 10px;
  font-family: var(--font-display);
  font-size: 18px;
  letter-spacing: 0.06em;
  color: var(--color-text-primary);
  margin-bottom: 28px;
}

.brand__mark {
  color: var(--color-accent-neon);
  text-shadow: 0 0 12px rgba(124, 255, 107, 0.5);
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
  box-shadow: var(--shadow-sm);
  background: rgba(61, 214, 255, 0.08);
}

.nav__link:hover {
  color: var(--color-text-primary);
  border-color: var(--color-border-subtle);
}
</style>
