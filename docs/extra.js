// Keep the supplied prebuilt search index usable under a GitHub Pages project path.
(() => {
  const previewPrefix = "https://kevinxing3.github.io/NMADTA/";
  const nativeFetch = window.fetch.bind(window);
  window.fetch = async (...args) => {
    const response = await nativeFetch(...args);
    if (!response.url || !new URL(response.url).pathname.endsWith("/search.json"))
      return response;
    try {
      const rows = await response.clone().json();
      if (!Array.isArray(rows)) return response;
      let changed = false;
      for (const row of rows) {
        if (typeof row.path === "string" && row.path.startsWith(previewPrefix)) {
          row.path = new URL(row.path.slice(previewPrefix.length), response.url).href;
          changed = true;
        }
      }
      return changed ? new Response(JSON.stringify(rows), {
        status: response.status, headers: {"Content-Type": "application/json"}
      }) : response;
    } catch {
      return response;
    }
  };
})();
