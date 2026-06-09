"use client";

import { useState } from "react";

export default function AudioButton({
  text,
  lang,
  audioUrl,
  label,
}: {
  text: string;
  lang: string;
  audioUrl?: string | null;
  label: string;
}) {
  const [playing, setPlaying] = useState(false);

  function play() {
    if (typeof window === "undefined") return;

    if (audioUrl) {
      const a = new Audio(audioUrl);
      setPlaying(true);
      a.onended = () => setPlaying(false);
      a.play().catch(() => setPlaying(false));
      return;
    }

    // 폴백: 브라우저 음성합성으로 상대 언어 낭독 (녹음 파일 없이도 작동)
    const synth = window.speechSynthesis;
    if (!synth || !text) return;
    synth.cancel();
    const u = new SpeechSynthesisUtterance(text);
    u.lang = lang;
    u.rate = 0.95;
    u.onstart = () => setPlaying(true);
    u.onend = () => setPlaying(false);
    synth.speak(u);
  }

  return (
    <button
      onClick={play}
      className="inline-flex items-center gap-2 rounded-full border border-white/40 bg-white/15 px-5 py-2.5 text-sm backdrop-blur transition active:scale-95"
      aria-pressed={playing}
    >
      <span>{playing ? "‖" : "▶"}</span>
      {label}
    </button>
  );
}
