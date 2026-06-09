# Besora (베소라) — Claude Code 프로젝트 가이드

> 이 파일을 읽고 프로젝트 맥락을 파악한 뒤, 사용자와 한국어로 대화하세요.

## WHY (목적)
베소라는 AMOV의 **글로벌 선교 전도 어플**. 슬로건 "온 인류를 향한 기쁜 소식."
전도자가 언어가 다른 낯선 사람에게 폰을 건네, 복음을 **다국어 + 음성**으로 전하는 도구.
입구용 funnel이 아니라 **그 자체로 완결된 선교 어플** (양육·기록·다국어 콘텐츠 내장).
철학: Love Creates Value · Inspired by Prayer, Powered by Love.

## WHAT (무엇)
5개 전도 도구를 하나의 공통 엔진으로 구동:
1. 글없는책(wordless) 2. 사영리(four-laws) 3. 다리 예화(bridge)
4. 세 개의 원(three-circles) 5. 로마서로의 길(romans)
디자인 척추 = 글없는책 5색(금/검정/빨강/하양/초록)을 앱 전체 색 체계로.

## HOW (스택 & 구조)
- **Next.js 14 (App Router) + TypeScript + Tailwind + Supabase + PWA** (셀라/만나와 동일 스택)
- 콘텐츠는 전부 **Supabase DB**에 (배포 없이 번역·칼럼·간증 확장). Phase 2/3 테이블(testimonies / intercession_targets / columns) 미리 준비됨.
- `src/app`: `page`(홈·도구선택) / `setup`(내 언어) / `present/[tool]`(러너) / `me`(기록)
- `src/components`: AppShell, LanguageToggle, ToolCard, StepView, DecisionFlow, AudioButton, ServiceWorker
- `src/lib`: content.ts(페처), i18n.ts, types.ts, supabase/client.ts
- `src/context/LanguageContext.tsx`: myLang(전도자) + seekerLang(상대), localStorage 저장
- `supabase/schema.sql`(스키마+시드) → 먼저 RUN, 그다음 `supabase/content.sql`(영어/스페인어 추가)

## 지켜야 할 핵심 디자인 결정
- **두 언어를 항상 함께 한 화면에.** 상대 언어가 주인공(크게), 내 언어는 같은 카드 안 작지만 또렷한 보조. 결단/기도/환영 화면에도 동일 적용 (StepView.tsx, DecisionFlow.tsx 참고).
- 음성: `audio_url` 있으면 재생, 없으면 브라우저 speechSynthesis로 상대 언어 낭독 (AudioButton.tsx).
- 전도자 로그인은 **선택**, 게스트로도 전도/기록 가능. 결단 시 `sessions`에 기록.
- 오프라인 PWA (public/sw.js, manifest.webmanifest).
- 톤: 따뜻하고 강요 없는 복음 제시. 신학적으로 건전하게.

## 명령어
- 의존성 설치: `npm install`
- 개발 서버: `npm run dev`
- 빌드: `npm run build`
- 환경변수 (.env.local 또는 Netlify): `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`

## 배포
- GitHub → Netlify 자동 배포 (셀라/만나와 동일). 도메인 `besora.theamov.com` (가비아 CNAME) 예정.
- Supabase SQL Editor에 `schema.sql` → `content.sql` 순서로 RUN.

## 현재 상태
- 스켈레톤 완성. 글없는책 = KO+EN+ES, 나머지 4개 = KO+EN+ES(스페인어는 검수 전 초안). 결단 = KO/EN/ES.
- 로마서: 영어 WEB / 스페인어 RV1909 (둘 다 퍼블릭 도메인). 한국어는 의역.
- **아직 미배포** (Supabase/GitHub/Netlify 연결 필요).

## 다음 할 일
1. 배포: Supabase SQL 2개 RUN → GitHub 업로드 → Netlify 환경변수.
2. 도구별 일러스트/애니메이션 (StepView의 `Sketch`를 SVG·모션으로): 다리 놓이는 연출, 세 개의 원 그려지기 등.
3. 셀라 30개 언어를 `languages` 테이블에 추가 + 콘텐츠 번역(원어민 검수, 특히 영접 기도).
4. 카카오/구글 OAuth (셀라 설정 재사용) — 기록을 기기 너머로.
5. 결단 후 QR/링크로 상대 폰에 전달, 음성 녹음(ElevenLabs) 연결.
6. Phase 2: 간증 커뮤니티 / 세계를 위한 중보. Phase 3: 보편 이슈 칼럼(이혼·전쟁 등).

## 협업 메모
- 사용자(유상철)는 비개발자. **한국어로 응답.** 모든 코드는 Claude가 작성.
- 큰 변경은 계획을 먼저 보여주고 진행. 한 번에 하나씩 진단(스크린샷 요청 가능).
- 배포는 GitHub 웹 UI 드래그앤드롭 + Netlify를 써왔으나, 이제 Claude Code가 직접 git/빌드 가능.
