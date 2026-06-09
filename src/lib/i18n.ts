// 앱 UI(버튼/안내) 다국어. 전도 콘텐츠는 DB에 있고, 여기는 화면 골격용.
export const UI = {
  ko: {
    appName: "베소라",
    tagline: "온 인류를 향한 기쁜 소식",
    start: "전도 시작",
    chooseTool: "도구 선택",
    myLanguage: "내 언어",
    seekerLanguage: "상대의 언어",
    setMyLanguage: "내 언어를 골라주세요",
    setSeekerLanguage: "상대가 읽을 언어를 골라주세요",
    next: "다음",
    prev: "이전",
    toDecision: "결단으로",
    listen: "들려주기",
    follow: "따라읽기",
    pray: "함께 기도하기",
    amen: "기도를 마쳤어요",
    again: "다시 전도하기",
    notNow: "조금 더 생각해볼게요",
    yes: "네, 영접할게요",
    myRecords: "나의 전도 기록",
    offlineReady: "오프라인 준비됨",
    home: "홈",
  },
  en: {
    appName: "Besora",
    tagline: "Good news for all humanity",
    start: "Start sharing",
    chooseTool: "Choose a tool",
    myLanguage: "My language",
    seekerLanguage: "Their language",
    setMyLanguage: "Pick your language",
    setSeekerLanguage: "Pick the language they will read",
    next: "Next",
    prev: "Back",
    toDecision: "To decision",
    listen: "Play audio",
    follow: "Read along",
    pray: "Pray together",
    amen: "Finished praying",
    again: "Share again",
    notNow: "I want to think more",
    yes: "Yes, I receive Jesus",
    myRecords: "My records",
    offlineReady: "Offline ready",
    home: "Home",
  },
} as const;

export type UILang = keyof typeof UI;
export type UIKey = keyof (typeof UI)["ko"];

export function ui(lang: string, key: UIKey): string {
  const l = (lang in UI ? lang : "ko") as UILang;
  return UI[l][key];
}
