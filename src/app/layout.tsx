import type { Metadata, Viewport } from "next";
import "./globals.css";
import { LanguageProvider } from "@/context/LanguageContext";
import ServiceWorker from "@/components/ServiceWorker";

export const metadata: Metadata = {
  title: "베소라 · Besora",
  description: "온 인류를 향한 기쁜 소식 — 글로벌 선교 전도 어플",
  manifest: "/manifest.webmanifest",
};

export const viewport: Viewport = {
  themeColor: "#15121E",
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="ko">
      <body>
        <LanguageProvider>{children}</LanguageProvider>
        <ServiceWorker />
      </body>
    </html>
  );
}
