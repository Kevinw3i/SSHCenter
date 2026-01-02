<template>
  <div class="content-header">
    <div class="content-header__main">
      <p v-if="eyebrow" class="content-header__eyebrow">{{ eyebrow }}</p>
      <h1 class="content-header__title">{{ title }}</h1>
      <p v-if="subtitle" class="content-header__subtitle">{{ subtitle }}</p>
    </div>
    <div class="content-header__actions">
      <slot name="actions" />
    </div>
  </div>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    required: true
  },
  subtitle: {
    type: String,
    default: ""
  },
  eyebrow: {
    type: String,
    default: ""
  }
});
</script>
