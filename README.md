# 베소라 (Besora) — 글로벌 선교 전도 어플

온 인류를 향한 기쁜 소식. 다섯 가지 전도 도구를 다국어 + 음성 + 오프라인으로.
**Next.js(App Router) + TypeScript + Supabase + Tailwind + PWA.** 셀라/만나와 같은 스택.

---

## 들어 있는 것 (이번 스켈레톤)

- **5개 도구 골격**: 글없는책 · 사영리 · 다리 예화 · 세 개의 원 · 로마서로의 길
- **공통 엔진**: 다섯 도구가 같은 러너·결단 화면을 공유 (한 번 고치면 다 좋아짐)
- **다국어**: 상대 언어 ↔ 전도자 따라읽기. 8개 언어 시드(아랍어 RTL 포함), 셀라 30개로 확장 가능
- **음성**: 녹음 파일이 없어도 브라우저 음성합성(TTS)으로 상대 언어 낭독
- **결단 흐름**: 영접 권유 → 따라 읽는 기도 → 환영. 전도 기록 자동 저장(게스트도 가능)
- **오프라인**: PWA 서비스워커로 앱 셸 캐시
- **DB**: 콘텐츠가 전부 Supabase에 있어 배포 없이 번역·칼럼·간증 확장 (Phase 2/3 테이블 미리 준비됨)

콘텐츠는 **글없는책 = 한국어+영어 완성**, 나머지 4개 = 한국어. 영접 기도 = 한국어+영어.

---

## 배포 순서

### 1. Supabase
1. supabase.com 에서 프로젝트 사용 — **기존 프로젝트(예: 다바르)에 그대로 얹어도 됨.**
   베소라의 모든 테이블은 전용 `besora` schema 안에 격리되어, 기존 `public` 테이블
   (셀라/만나/다바르)과 절대 충돌하지 않습니다.
2. 좌측 **SQL Editor** → `supabase/schema.sql` 전체 붙여넣고 **RUN** → 이어서
   `supabase/content.sql` 전체 붙여넣고 **RUN** (순서 중요, 둘 다 재실행 안전).
3. ⭐ **Settings → API → Data API → Exposed schemas** 에 **`besora`** 를 추가하고
   **Save**. (이 단계를 빼먹으면 앱이 DB를 못 읽습니다.)
4. **Settings → API** 에서 `Project URL` 과 `anon public` 키 복사.

### 2. GitHub
1. 새 저장소 생성 (예: `besora`)
2. 이 폴더의 파일들을 웹 UI로 드래그앤드롭 업로드
   - ⚠️ `node_modules`, `.next` 는 올리지 않음 (이미 .gitignore 처리)
   - 파일 100개 제한 안에 들어옴

### 3. Netlify
1. **Add new site → Import from GitHub** → `besora` 선택
2. 빌드 설정: Build command `npm run build`, Publish directory `.next` (Next 플러그인 자동)
3. **Site settings → Environment variables** 에 두 개 추가:
   - `NEXT_PUBLIC_SUPABASE_URL` = (1단계 Project URL)
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY` = (1단계 anon 키)
4. Deploy. 이후 GitHub에 올리면 자동 재배포.

### 4. 도메인 (선택)
가비아에서 `besora.theamov.com` CNAME → Netlify 주소 연결.

### 5. 확인
- 홈에 도구 5개 카드가 뜨면 DB 연결 성공
- 글없는책 → 상대 언어 English 선택 → 색 카드가 영어로, ▶ 누르면 영어 음성
- 마지막에서 결단 → 기도 → 환영

---

## 다음 단계 (콘텐츠/기능 채우기)

- 나머지 4개 도구의 영어+다국어 본문 채우기 (`tool_step_translations`)
- 셀라 30개 언어를 `languages` 에 추가
- 도구별 일러스트/애니메이션 (`StepView` 의 `Sketch` 를 SVG·모션으로 교체)
- 카카오/구글 OAuth (전도 기록을 기기 너머로 저장) — 셀라 설정 재사용
- Phase 2: 간증 커뮤니티 / 세계를 위한 중보 (테이블 준비됨)
- Phase 3: 보편 이슈 칼럼 (`columns` 테이블 준비됨)
- 결단 후 상대 폰으로 넘기는 QR/링크, 음성 녹음 파일(ElevenLabs) 연결

---

Love Creates Value · Inspired by Prayer, Powered by Love
