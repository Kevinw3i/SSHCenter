export const resolveApiError = (error, fallback) => {
  const payload = error?.response?.data?.error;
  if (Array.isArray(payload) && payload.length > 0) {
    return payload[0];
  }
  if (typeof payload === "string" && payload.length > 0) {
    return payload;
  }
  return fallback;
};
