<template>
  <div class="table-empty">
    <el-empty :description="description" :image-size="72" />
    <div v-if="$slots.action" class="table-empty__action">
      <slot name="action" />
    </div>
  </div>
</template>

<script setup>
defineProps({
  description: {
    type: String,
    default: ""
  }
});
</script>
