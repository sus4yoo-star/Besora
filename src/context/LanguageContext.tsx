"use client";

import {
  createContext,
  useContext,
  useEffect,
  useState,
  ReactNode,
} from "react";
import { fetchLanguages } from "@/lib/content";
import type { Language } from "@/lib/types";

type Ctx = {
  myLang: string;
  seekerLang: string;
  setMyLang: (c: string) => void;
  setSeekerLang: (c: string) => void;
  languages: Language[];
  rtlFor: (code: string) => boolean;
  ready: boolean;
};

const LanguageCtx = createContext<Ctx | null>(null);

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [myLang, setMyLangState] = useState("ko");
  const [seekerLang, setSeekerLangState] = useState("");
  const [languages, setLanguages] = useState<Language[]>([]);
  const [ready, setReady] = useState(false);

  useEffect(() => {
    const m = localStorage.getItem("besora.myLang");
    const s = localStorage.getItem("besora.seekerLang");
    if (m) setMyLangState(m);
    if (s) setSeekerLangState(s);
    fetchLanguages()
      .then(setLanguages)
      .catch(() => setLanguages([]))
      .finally(() => setReady(true));
  }, []);

  const setMyLang = (c: string) => {
    setMyLangState(c);
    localStorage.setItem("besora.myLang", c);
  };
  const setSeekerLang = (c: string) => {
    setSeekerLangState(c);
    localStorage.setItem("besora.seekerLang", c);
  };
  const rtlFor = (code: string) =>
    languages.find((l) => l.code === code)?.rtl ?? false;

  return (
    <LanguageCtx.Provider
      value={{ myLang, seekerLang, setMyLang, setSeekerLang, languages, rtlFor, ready }}
    >
      {children}
    </LanguageCtx.Provider>
  );
}

export function useLang(): Ctx {
  const c = useContext(LanguageCtx);
  if (!c) throw new Error("useLang must be used inside LanguageProvider");
  return c;
}
