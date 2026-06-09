// 베소라 서비스워커 — 전도 현장 오프라인 대비 + 배포 즉시 반영
// 전략: 네트워크 우선(online이면 항상 최신), 실패 시 캐시 폴백(offline 지원)
const CACHE = "besora-v2";
const SHELL = ["/", "/setup", "/me", "/manifest.webmanifest", "/icons/icon.svg"];

self.addEventListener("install", (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(SHELL)).catch(() => {}));
  self.skipWaiting();
});

self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches
      .keys()
      .then((keys) =>
        Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))
      )
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", (e) => {
  const { request } = e;
  if (request.method !== "GET") return;
  // Supabase 등 API 요청은 항상 네트워크 (서비스워커가 건드리지 않음)
  if (request.url.includes("supabase.co")) return;

  e.respondWith(
    fetch(request)
      .then((res) => {
        // 성공하면 최신본을 캐시에 갱신해 두고 그대로 반환
        const copy = res.clone();
        caches.open(CACHE).then((c) => c.put(request, copy)).catch(() => {});
        return res;
      })
      .catch(async () => {
        // 오프라인: 캐시에서 찾고, 페이지 이동이면 홈 셸로 폴백
        const cached = await caches.match(request);
        if (cached) return cached;
        if (request.mode === "navigate") {
          const shell = await caches.match("/");
          if (shell) return shell;
        }
        return Response.error();
      })
  );
});
