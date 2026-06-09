"use client";

import { useEffect } from "react";

export default function ServiceWorker() {
  useEffect(() => {
    if (!("serviceWorker" in navigator)) return;

    // 새 서비스워커가 제어권을 잡으면(=새 배포 활성화) 한 번만 새로고침해 최신 앱 표시
    let refreshing = false;
    navigator.serviceWorker.addEventListener("controllerchange", () => {
      if (refreshing) return;
      refreshing = true;
      window.location.reload();
    });

    navigator.serviceWorker
      .register("/sw.js")
      .then((reg) => {
        // 접속할 때마다 새 버전이 있는지 확인
        reg.update().catch(() => {});
      })
      .catch(() => {});
  }, []);

  return null;
}
