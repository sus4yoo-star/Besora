"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import AppShell from "@/components/AppShell";
import ToolCard from "@/components/ToolCard";
import { fetchTools } from "@/lib/content";
import type { Tool } from "@/lib/types";
import { useLang } from "@/context/LanguageContext";
import { ui } from "@/lib/i18n";

export default function Home() {
  const { myLang, ready } = useLang();
  const [tools, setTools] = useState<Tool[]>([]);
  const [err, setErr] = useState<string | null>(null);

  useEffect(() => {
    fetchTools()
      .then(setTools)
      .catch((e) => setErr(e.message));
  }, []);

  return (
    <AppShell>
      <section className="mb-6 mt-2">
        <p className="font-serif text-3xl font-bold leading-tight text-gospel-parch">
          {ui(myLang, "tagline")}
        </p>
        <p className="mt-2 text-sm text-gospel-parch/70">{ui(myLang, "chooseTool")}</p>
      </section>

      {err && (
        <div className="mb-4 rounded-xl border border-gospel-crimson/40 bg-gospel-crimson/10 p-4 text-sm text-gospel-parch">
          콘텐츠를 불러오지 못했어요. Supabase 환경변수와 schema.sql 실행을 확인해 주세요.
          <span className="mt-1 block text-xs text-muted">{err}</span>
        </div>
      )}

      <div className="grid grid-cols-2 gap-4">
        {tools.map((t) => (
          <ToolCard key={t.id} tool={t} />
        ))}
      </div>

      <div className="mt-8 flex items-center justify-between text-sm">
        <Link href="/setup" className="text-gospel-parch/70 underline">
          {ui(myLang, "setMyLanguage")}
        </Link>
        <Link href="/me" className="text-gospel-gold">
          {ui(myLang, "myRecords")} →
        </Link>
      </div>

      {!ready && <p className="mt-6 text-center text-xs text-muted">…</p>}
    </AppShell>
  );
}
