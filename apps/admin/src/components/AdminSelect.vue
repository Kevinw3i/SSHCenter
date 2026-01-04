<template>
  <el-select
    v-bind="attrs"
    class="admin-select"
    :class="{ 'is-filled': isFilled, 'is-multiple': multiple }"
    :model-value="modelValue"
    :placeholder="placeholder"
    :filterable="filterable"
    :clearable="clearable"
    :multiple="multiple"
    :collapse-tags="collapseTags"
    :collapse-tags-tooltip="collapseTagsTooltip"
    :max-collapse-tags="maxCollapseTags"
    :loading="loading"
    :loading-text="resolvedLoadingText"
    :no-data-text="resolvedNoDataText"
    :no-match-text="resolvedNoMatchText"
    :disabled="disabled"
    :size="size"
    :teleported="teleported"
    @update:modelValue="handleUpdate"
  >
    <template v-if="$slots.default">
      <slot />
    </template>
    <template v-else>
      <el-option
        v-for="option in normalizedOptions"
        :key="option.key"
        :label="option.label"
        :value="option.value"
        :disabled="option.disabled"
      />
    </template>
    <template v-if="$slots.loading" #loading>
      <slot name="loading" />
    </template>
    <template v-if="$slots.empty" #empty>
      <slot name="empty" />
    </template>
  </el-select>
</template>

<script setup>
import { computed, useAttrs } from "vue";
import { useI18n } from "vue-i18n";

defineOptions({ inheritAttrs: false });

const props = defineProps({
  modelValue: {
    type: [String, Number, Array, Object, Boolean],
    default: null
  },
  options: {
    type: Array,
    default: () => []
  },
  optionLabel: {
    type: String,
    default: "label"
  },
  optionValue: {
    type: String,
    default: "value"
  },
  optionDisabled: {
    type: String,
    default: "disabled"
  },
  placeholder: {
    type: String,
    default: ""
  },
  filterable: {
    type: Boolean,
    default: false
  },
  clearable: {
    type: Boolean,
    default: false
  },
  multiple: {
    type: Boolean,
    default: false
  },
  collapseTags: {
    type: Boolean,
    default: true
  },
  collapseTagsTooltip: {
    type: Boolean,
    default: true
  },
  maxCollapseTags: {
    type: Number,
    default: 2
  },
  loading: {
    type: Boolean,
    default: false
  },
  disabled: {
    type: Boolean,
    default: false
  },
  size: {
    type: String,
    default: "default"
  },
  teleported: {
    type: Boolean,
    default: true
  },
  loadingText: {
    type: String,
    default: ""
  },
  noDataText: {
    type: String,
    default: ""
  },
  noMatchText: {
    type: String,
    default: ""
  }
});

const emit = defineEmits(["update:modelValue"]);
const attrs = useAttrs();
const { t } = useI18n();

const normalizedOptions = computed(() =>
  props.options.map((option, index) => {
    if (option && typeof option === "object") {
      const value = option[props.optionValue] ?? option[props.optionLabel];
      return {
        key: value ?? option[props.optionLabel] ?? index,
        label: option[props.optionLabel] ?? String(value ?? ""),
        value,
        disabled: Boolean(option[props.optionDisabled])
      };
    }
    return {
      key: option ?? index,
      label: String(option),
      value: option,
      disabled: false
    };
  })
);

const isFilled = computed(() => {
  if (props.multiple) {
    return Array.isArray(props.modelValue) && props.modelValue.length > 0;
  }
  return props.modelValue !== null && props.modelValue !== undefined && props.modelValue !== "";
});

const resolvedLoadingText = computed(() => props.loadingText || t("common.loading"));
const resolvedNoDataText = computed(() => props.noDataText || t("common.noData"));
const resolvedNoMatchText = computed(() => props.noMatchText || t("common.noMatch"));

const handleUpdate = (value) => {
  emit("update:modelValue", value);
};
</script>
