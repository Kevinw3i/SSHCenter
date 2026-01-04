<template>
  <aside class="sidebar">
    <div class="brand">
      <span class="brand__mark">■</span>
      <span class="brand__title">{{ $t("app.title") }}</span>
    </div>
    <nav class="nav">
      <RouterLink to="/users" class="nav__link">
        <span class="nav__label">{{ $t("nav.users") }}</span>
      </RouterLink>
      <RouterLink to="/servers" class="nav__link">
        <span class="nav__label">{{ $t("nav.servers") }}</span>
      </RouterLink>
      <RouterLink to="/groups" class="nav__link">
        <span class="nav__label">{{ $t("nav.groups") }}</span>
      </RouterLink>
      <RouterLink to="/permissions" class="nav__link">
        <span class="nav__label">{{ $t("nav.permissions") }}</span>
      </RouterLink>
    </nav>
  </aside>
</template>

<style scoped>
.sidebar {
  width: var(--admin-sidebar-width);
  min-height: 100vh;
  background: var(--color-ink-800);
  border-right: 1px solid var(--color-border-subtle);
  padding: var(--space-24) var(--space-16);
}

.brand {
  display: flex;
  align-items: center;
  gap: var(--space-12);
  font-family: var(--font-base);
  font-size: var(--font-size-lg);
  font-weight: 600;
  letter-spacing: 0.02em;
  color: var(--color-text-primary);
  margin-bottom: var(--space-24);
}

.brand__mark {
  color: var(--color-accent-cyan);
  font-size: var(--font-size-xs);
}

.nav {
  display: flex;
  flex-direction: column;
  gap: var(--space-8);
}

.nav__link {
  text-decoration: none;
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
  padding: var(--space-8) var(--space-12);
  border-radius: var(--radius-md);
  position: relative;
  transition: background var(--motion-fast) var(--motion-ease),
    color var(--motion-fast) var(--motion-ease);
}

.nav__link::before {
  content: "";
  position: absolute;
  left: 0;
  top: var(--space-8);
  bottom: var(--space-8);
  width: 3px;
  border-radius: var(--radius-pill);
  background: transparent;
}

.nav__link.router-link-active {
  color: var(--color-text-primary);
  background: rgba(61, 214, 255, 0.08);
}

.nav__link.router-link-active::before {
  background: var(--color-accent-cyan);
}

.nav__link:hover {
  color: var(--color-text-primary);
  background: rgba(61, 214, 255, 0.05);
}
</style>
