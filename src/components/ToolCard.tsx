"use client";

import Link from "next/link";
import type { Tool } from "@/lib/types";

const COLOR: Record<string, string> = {
  gold: "from-[#F2CF6B] to-[#D89E22]",
  crimson: "from-[#D9533F] to-[#A52A1C]",
  parch: "from-[#F5F1E8] to-[#E7E1D4] text-ink",
  green: "from-[#6FB98B] to-[#3F8862]",
  violet: "from-[#B3A6DA] to-[#7E6CB8]",
  ink: "from-[#3A3346] to-[#16131d]",
};

export default function ToolCard({ tool, wide = false }: { tool: Tool; wide?: boolean }) {
  const grad = COLOR[tool.color_key] ?? COLOR.ink;
  const dark = tool.color_key === "parch";

  if (wide) {
    return (
      <Link
        href={`/present/${tool.slug}`}
        className={`relative flex h-[68px] items-center gap-3 overflow-hidden rounded-3xl bg-gradient-to-br ${grad} px-5 transition active:scale-[.98]`}
      >
        <span className={`font-serif text-xl font-semibold ${dark ? "text-ink" : "text-white"}`}>
          {tool.name_ko}
        </span>
        <span className={`text-xs ${dark ? "text-ink/60" : "text-white/70"}`}>{tool.slug}</span>
      </Link>
    );
  }

  return (
    <Link
      href={`/present/${tool.slug}`}
      className={`relative flex aspect-[6/5] flex-col justify-end overflow-hidden rounded-3xl bg-gradient-to-br ${grad} p-4 transition active:scale-[.97]`}
    >
      <span className={`font-serif text-xl font-semibold ${dark ? "text-ink" : "text-white"}`}>
        {tool.name_ko}
      </span>
      <span className={`mt-0.5 text-xs ${dark ? "text-ink/70" : "text-white/80"}`}>{tool.slug}</span>
    </Link>
  );
}
