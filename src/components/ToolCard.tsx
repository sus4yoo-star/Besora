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

export default function ToolCard({ tool }: { tool: Tool }) {
  const grad = COLOR[tool.color_key] ?? COLOR.ink;
  const dark = tool.color_key === "parch";
  return (
    <Link
      href={`/present/${tool.slug}`}
      className={`relative flex aspect-[4/5] flex-col justify-end overflow-hidden rounded-3xl bg-gradient-to-br ${grad} p-5 transition active:scale-[.97]`}
    >
      <span
        className={`font-serif text-2xl font-semibold ${dark ? "text-ink" : "text-white"}`}
      >
        {tool.name_ko}
      </span>
      <span
        className={`mt-1 text-sm ${dark ? "text-ink/70" : "text-white/80"}`}
      >
        {tool.slug}
      </span>
    </Link>
  );
}
