-- =====================================================================
--  베소라 (Besora) — 글로벌 선교 전도 어플 · Supabase 스키마
--  Supabase 대시보드 > SQL Editor 에 통째로 붙여넣고 RUN 하세요.
--  (한 번에 실행되도록 idempotent 하게 작성: 재실행해도 안전)
--
--  ※ 다바르 등 기존 프로젝트에 함께 얹어도 충돌하지 않도록, 베소라의 모든
--    테이블은 전용 schema 'besora' 안에 격리됩니다. (public 의 기존 셀라/만나/
--    다바르 테이블은 전혀 건드리지 않습니다.)
--  ※ 실행 후 한 번만: Supabase 대시보드 > Settings > API > Data API >
--    Exposed schemas 에 'besora' 를 추가하고 저장해야 앱에서 읽힙니다.
-- =====================================================================

create schema if not exists besora;

-- ---------- 1. 언어 ----------
create table if not exists besora.languages (
  code        text primary key,        -- ko, en, ar ...
  name_native text not null,           -- 한국어, English, العربية
  name_en     text not null,
  rtl         boolean not null default false,
  enabled     boolean not null default true,
  sort        int not null default 0
);

-- ---------- 2. 전도 도구 (5개) ----------
create table if not exists besora.tools (
  id         uuid primary key default gen_random_uuid(),
  slug       text unique not null,     -- wordless, four-laws, bridge, three-circles, romans
  name_ko    text not null,
  color_key  text not null,            -- gold/ink/crimson/parch/green/violet
  sort       int not null default 0,
  enabled    boolean not null default true
);

-- ---------- 3. 도구 단계 (언어 중립 구조) ----------
create table if not exists besora.tool_steps (
  id          uuid primary key default gen_random_uuid(),
  tool_id     uuid not null references besora.tools(id) on delete cascade,
  step_order  int not null,
  kind        text not null,           -- intro | color | diagram | verse | decision
  color_key   text,                    -- 글없는책 색
  sketch_key  text,                    -- two-circles | cross | bridge | circle ...
  verse_ref   text,                    -- 로마서로의 길
  unique (tool_id, step_order)
);

-- ---------- 4. 단계별 다국어 콘텐츠 ----------
create table if not exists besora.tool_step_translations (
  id            uuid primary key default gen_random_uuid(),
  step_id       uuid not null references besora.tool_steps(id) on delete cascade,
  language_code text not null references besora.languages(code) on delete cascade,
  title         text,
  body          text,
  audio_url     text,
  unique (step_id, language_code)
);

-- ---------- 5. 결단/영접 공유 콘텐츠 (다국어) ----------
create table if not exists besora.decision_translations (
  language_code text primary key references besora.languages(code) on delete cascade,
  ask_title     text not null,
  ask_body      text,
  prayer_text   text not null,
  welcome_title text not null,
  welcome_body  text,
  audio_url     text
);

-- ---------- 6. 전도자 (로그인 선택) ----------
create table if not exists besora.evangelists (
  id            uuid primary key references auth.users(id) on delete cascade,
  display_name  text,
  home_language text references besora.languages(code),
  created_at    timestamptz not null default now()
);

-- ---------- 7. 전도 기록 (게스트도 기록 가능) ----------
create table if not exists besora.sessions (
  id             uuid primary key default gen_random_uuid(),
  evangelist_id  uuid references auth.users(id) on delete set null,
  tool_slug      text not null,
  seeker_language text,
  decided        boolean not null default false,
  note           text,
  created_at     timestamptz not null default now()
);

-- ---------- 8. (Phase 2) 간증 커뮤니티 ----------
create table if not exists besora.testimonies (
  id            uuid primary key default gen_random_uuid(),
  author_id     uuid references auth.users(id) on delete set null,
  language_code text references besora.languages(code),
  title         text,
  body          text,
  approved      boolean not null default false,
  created_at    timestamptz not null default now()
);

-- ---------- 9. (Phase 2) 세계를 위한 중보 대상 ----------
create table if not exists besora.intercession_targets (
  id            uuid primary key default gen_random_uuid(),
  region        text,
  title_ko      text,
  body_ko       text,
  active_date   date,
  created_at    timestamptz not null default now()
);

-- ---------- 10. (Phase 3) 칼럼: 보편 이슈를 그리스도 시선으로 ----------
create table if not exists besora.columns (
  id            uuid primary key default gen_random_uuid(),
  topic         text,                  -- 이혼 / 전쟁 / 고통 ...
  language_code text references besora.languages(code),
  title         text,
  body          text,
  published     boolean not null default false,
  created_at    timestamptz not null default now()
);

-- =====================================================================
--  RLS (Row Level Security)
-- =====================================================================
alter table besora.languages              enable row level security;
alter table besora.tools                  enable row level security;
alter table besora.tool_steps             enable row level security;
alter table besora.tool_step_translations enable row level security;
alter table besora.decision_translations  enable row level security;
alter table besora.evangelists            enable row level security;
alter table besora.sessions               enable row level security;
alter table besora.testimonies            enable row level security;
alter table besora.intercession_targets   enable row level security;
alter table besora.columns                enable row level security;

-- 콘텐츠는 누구나 읽기 (전도 대상은 로그인하지 않음)
drop policy if exists read_languages on besora.languages;
create policy read_languages on besora.languages for select using (true);
drop policy if exists read_tools on besora.tools;
create policy read_tools on besora.tools for select using (enabled);
drop policy if exists read_steps on besora.tool_steps;
create policy read_steps on besora.tool_steps for select using (true);
drop policy if exists read_step_tr on besora.tool_step_translations;
create policy read_step_tr on besora.tool_step_translations for select using (true);
drop policy if exists read_decision on besora.decision_translations;
create policy read_decision on besora.decision_translations for select using (true);
drop policy if exists read_intercession on besora.intercession_targets;
create policy read_intercession on besora.intercession_targets for select using (true);
drop policy if exists read_columns on besora.columns;
create policy read_columns on besora.columns for select using (published);
drop policy if exists read_testimonies on besora.testimonies;
create policy read_testimonies on besora.testimonies for select using (approved);

-- 전도자 본인 프로필
drop policy if exists evangelist_self on besora.evangelists;
create policy evangelist_self on besora.evangelists
  for all using (auth.uid() = id) with check (auth.uid() = id);

-- 전도 기록: 누구나 남길 수 있고(게스트 포함), 본인 것만 조회
drop policy if exists insert_sessions on besora.sessions;
create policy insert_sessions on besora.sessions for insert with check (true);
drop policy if exists read_own_sessions on besora.sessions;
create policy read_own_sessions on besora.sessions
  for select using (auth.uid() = evangelist_id);

-- 간증: 로그인 사용자가 작성(승인 전엔 비공개)
drop policy if exists insert_testimonies on besora.testimonies;
create policy insert_testimonies on besora.testimonies
  for insert with check (auth.uid() = author_id);

-- =====================================================================
--  GRANTS — Data API(anon/authenticated)가 besora schema 에 접근 가능하도록.
--  (행 단위 보호는 위의 RLS 정책이 계속 담당)
-- =====================================================================
grant usage on schema besora to anon, authenticated, service_role;
grant all on all tables    in schema besora to anon, authenticated, service_role;
grant all on all sequences in schema besora to anon, authenticated, service_role;
-- 앞으로 besora schema 에 새로 만들 테이블에도 자동 적용
alter default privileges in schema besora
  grant all on tables to anon, authenticated, service_role;
alter default privileges in schema besora
  grant all on sequences to anon, authenticated, service_role;

-- =====================================================================
--  SEED — 언어 (대표 8개, RTL 포함). 나머지는 셀라 30개에서 확장.
-- =====================================================================
insert into besora.languages (code, name_native, name_en, rtl, sort) values
  ('ko', '한국어',   'Korean',  false, 1),
  ('en', 'English',  'English', false, 2),
  ('es', 'Espanol',  'Spanish', false, 3),
  ('zh', '中文',     'Chinese', false, 4),
  ('fr', 'Francais', 'French',  false, 5),
  ('hi', 'हिन्दी',     'Hindi',   false, 6),
  ('pt', 'Portugues','Portuguese', false, 7),
  ('ar', 'العربية',  'Arabic',  true,  8)
on conflict (code) do nothing;

-- =====================================================================
--  SEED — 도구 5개 (글없는책 색 체계)
-- =====================================================================
insert into besora.tools (slug, name_ko, color_key, sort) values
  ('wordless',      '글없는책',       'gold',    1),
  ('four-laws',     '사영리',         'crimson', 2),
  ('bridge',        '다리 예화',      'parch',   3),
  ('three-circles', '세 개의 원',     'green',   4),
  ('romans',        '로마서로의 길',  'violet',  5)
on conflict (slug) do nothing;

-- =====================================================================
--  SEED — 단계 구조 (언어 중립). DO 블록으로 도구 id를 찾아 삽입.
-- =====================================================================
do $$
declare
  t_wordless uuid; t_four uuid; t_bridge uuid; t_three uuid; t_romans uuid;
begin
  select id into t_wordless from besora.tools where slug='wordless';
  select id into t_four     from besora.tools where slug='four-laws';
  select id into t_bridge   from besora.tools where slug='bridge';
  select id into t_three    from besora.tools where slug='three-circles';
  select id into t_romans   from besora.tools where slug='romans';

  -- 글없는책: 표지 + 5색 + 결단
  insert into besora.tool_steps (tool_id, step_order, kind, color_key) values
    (t_wordless,1,'intro',null),
    (t_wordless,2,'color','gold'),
    (t_wordless,3,'color','ink'),
    (t_wordless,4,'color','crimson'),
    (t_wordless,5,'color','parch'),
    (t_wordless,6,'color','green'),
    (t_wordless,7,'decision',null)
  on conflict do nothing;

  -- 사영리: 인트로 + 4단계 + 결단
  insert into besora.tool_steps (tool_id, step_order, kind, sketch_key) values
    (t_four,1,'intro',null),
    (t_four,2,'diagram','circle'),
    (t_four,3,'diagram','two-circles'),
    (t_four,4,'diagram','cross'),
    (t_four,5,'diagram','throne'),
    (t_four,6,'decision',null)
  on conflict do nothing;

  -- 다리 예화
  insert into besora.tool_steps (tool_id, step_order, kind, sketch_key) values
    (t_bridge,1,'diagram','two-sides'),
    (t_bridge,2,'diagram','gap'),
    (t_bridge,3,'diagram','bridge'),
    (t_bridge,4,'diagram','cross-over'),
    (t_bridge,5,'decision',null)
  on conflict do nothing;

  -- 세 개의 원
  insert into besora.tool_steps (tool_id, step_order, kind, sketch_key) values
    (t_three,1,'intro',null),
    (t_three,2,'diagram','circle'),
    (t_three,3,'diagram','circle-broken'),
    (t_three,4,'diagram','circle-gospel'),
    (t_three,5,'diagram','arrows'),
    (t_three,6,'decision',null)
  on conflict do nothing;

  -- 로마서로의 길
  insert into besora.tool_steps (tool_id, step_order, kind, verse_ref) values
    (t_romans,1,'verse','롬 3:23'),
    (t_romans,2,'verse','롬 6:23'),
    (t_romans,3,'verse','롬 5:8'),
    (t_romans,4,'verse','롬 10:9'),
    (t_romans,5,'verse','롬 10:13'),
    (t_romans,6,'decision',null)
  on conflict do nothing;
end $$;

-- =====================================================================
--  SEED — 콘텐츠. 글없는책은 한국어+영어 완성, 나머지는 한국어.
--  (영어 본문은 작은따옴표 회피를 위해 단순 표현 사용)
-- =====================================================================
do $$
declare s uuid;
begin
  -- ===== 글없는책 (wordless) — KO + EN =====
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='wordless') and step_order=1;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','색으로 듣는 복음','다섯 가지 색으로 전하는 가장 좋은 소식이에요. 함께 볼까요?'),
    (s,'en','The Gospel in Colors','The best news, told in five colors. Shall we look together?')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;

  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='wordless') and step_order=2;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','금 — 하나님의 사랑','하나님은 당신을 사랑하시고, 영원한 천국을 예비하셨어요.'),
    (s,'en','Gold — The Love of God','God loves you and has prepared an eternal home in heaven.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;

  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='wordless') and step_order=3;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','검정 — 죄','그런데 죄가 우리와 하나님 사이를 갈라놓았어요.'),
    (s,'en','Black — Sin','But sin has separated us from God.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;

  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='wordless') and step_order=4;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','빨강 — 예수님의 피','예수님이 십자가에서 피를 흘려 그 값을 치르셨어요.'),
    (s,'en','Red — The Blood of Jesus','Jesus paid the price by shedding his blood on the cross.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;

  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='wordless') and step_order=5;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','하양 — 깨끗함','그분을 믿으면 마음이 눈처럼 깨끗해져요.'),
    (s,'en','White — Made Clean','When you believe in him, your heart is washed white as snow.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;

  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='wordless') and step_order=6;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','초록 — 자라남','이제 새 생명이 매일 자라가요.'),
    (s,'en','Green — Growing','Now a new life begins and grows each day.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;

  -- ===== 사영리 (four-laws) — KO =====
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='four-laws') and step_order=1;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','네 가지 영적 진리','하나님과의 관계를 여는 네 가지 진리를 나눌게요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='four-laws') and step_order=2;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','하나, 사랑과 계획','하나님은 당신을 사랑하시고 당신을 향한 놀라운 계획이 있으세요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='four-laws') and step_order=3;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','둘, 죄와 단절','우리의 죄가 그 사랑을 가로막고 있어요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='four-laws') and step_order=4;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','셋, 예수 그리스도','예수님이 그 단절을 잇는 유일한 길이세요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='four-laws') and step_order=5;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','넷, 영접','이제 마음의 문을 열어 그분을 모셔들이면 돼요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;

  -- ===== 다리 예화 (bridge) — KO =====
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='bridge') and step_order=1;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','두 편에 선 우리','한쪽엔 사람, 한쪽엔 거룩하신 하나님이 계세요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='bridge') and step_order=2;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','죄가 만든 간격','죄가 둘 사이에 깊은 골을 만들었어요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='bridge') and step_order=3;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','십자가라는 다리','예수님의 십자가가 그 골을 잇는 다리가 되셨어요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='bridge') and step_order=4;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','믿음으로 건너감','믿음으로 그 다리를 건너 하나님께 갈 수 있어요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;

  -- ===== 세 개의 원 (three-circles) — KO =====
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='three-circles') and step_order=1;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','함께 그려볼까요','세 개의 원으로 이야기를 그려볼게요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='three-circles') and step_order=2;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','하나님의 디자인','하나님은 선하고 아름다운 삶을 디자인하셨어요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='three-circles') and step_order=3;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','깨어짐','우리가 그 길을 벗어나 삶이 깨어졌어요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='three-circles') and step_order=4;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','복음과 회복','예수님이 오셔서 깨어진 것을 회복하세요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='three-circles') and step_order=5;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','회개와 믿음','돌이켜 믿고 그분을 따라가는 거예요.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;

  -- ===== 로마서로의 길 (romans) — KO =====
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='romans') and step_order=1;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','모든 사람이 죄를 지음','모든 사람이 죄를 범하여 하나님의 영광에 이르지 못합니다.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='romans') and step_order=2;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','죄의 삯과 선물','죄의 삯은 사망이나, 하나님의 선물은 영생입니다.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='romans') and step_order=3;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','그 사랑','우리가 죄인 되었을 때에 그리스도께서 우리를 위하여 죽으셨습니다.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='romans') and step_order=4;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','믿음과 고백','예수를 주로 시인하고 마음으로 믿으면 구원을 받습니다.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='romans') and step_order=5;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'ko','누구든지','주의 이름을 부르는 자는 누구든지 구원을 받습니다.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
end $$;

-- =====================================================================
--  SEED — 결단/영접 (KO + EN)
-- =====================================================================
insert into besora.decision_translations
  (language_code, ask_title, ask_body, prayer_text, welcome_title, welcome_body) values
  ('ko','예수님을 영접하시겠어요?','강요하지 않아요. 마음이 열리셨다면 함께 기도해요.',
   '예수님, 저는 죄인입니다. 저를 위해 죽으시고 다시 살아나심을 믿습니다. 제 마음에 들어오셔서 저의 주님이 되어 주세요. 감사합니다. 아멘.',
   '환영합니다!','오늘은 새로운 삶이 시작된 날이에요. 천천히 함께 걸어가요.'),
  ('en','Would you like to receive Jesus?','No pressure. If your heart is open, let us pray together.',
   'Jesus, I am a sinner. I believe you died for me and rose again. Please come into my heart and be my Lord. Thank you. Amen.',
   'Welcome!','Today a new life begins. We will walk together, one step at a time.')
on conflict (language_code) do update set
  ask_title=excluded.ask_title, ask_body=excluded.ask_body, prayer_text=excluded.prayer_text,
  welcome_title=excluded.welcome_title, welcome_body=excluded.welcome_body;

-- 끝.
