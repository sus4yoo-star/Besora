"use client";

import Link from "next/link";
import { ReactNode } from "react";
import LanguageToggle from "@/components/LanguageToggle";
import { useLang } from "@/context/LanguageContext";
import { ui } from "@/lib/i18n";

export default function AppShell({ children }: { children: ReactNode }) {
  const { myLang } = useLang();
  return (
    <div className="mx-auto flex min-h-dvh max-w-md flex-col">
      <header className="sticky top-0 z-40 flex items-center justify-between border-b border-white/10 bg-ink/80 px-4 py-3 backdrop-blur">
        <Link href="/" className="font-serif text-xl font-bold text-gospel-gold">
          {ui(myLang, "appName")}
        </Link>
        <LanguageToggle />
      </header>
      <main className="flex flex-1 flex-col px-4 py-4">{children}</main>
    </div>
  );
}
