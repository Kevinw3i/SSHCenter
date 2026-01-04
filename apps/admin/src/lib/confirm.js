import { ElMessageBox } from "element-plus";
import i18n from "@/i18n";

export const confirmAction = async (message, options = {}) => {
  const { t } = i18n.global;
  try {
    await ElMessageBox.confirm(message, options.title || t("common.confirmTitle"), {
      confirmButtonText: options.confirmText || t("common.confirm"),
      cancelButtonText: options.cancelText || t("common.cancel"),
      type: options.type || "warning",
      distinguishCancelAndClose: true
    });
    return true;
  } catch {
    return false;
  }
};
