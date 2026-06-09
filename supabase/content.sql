-- =====================================================================
--  베소라 콘텐츠 추가분 — 영어(완성) + 스페인어(초안, 원어민 검수 필요)
--  schema.sql 를 먼저 RUN 한 뒤, 이 파일을 SQL Editor 에 붙여넣고 RUN.
--  (upsert 방식이라 여러 번 실행해도 안전)
--  ※ 스페인어는 검수 전 초안입니다. 특히 영접 기도는 현장 사용 전 신뢰할 수
--    있는 원어민 검토를 권장합니다. 로마서는 영어 WEB / 스페인어 RV1909
--    (둘 다 퍼블릭 도메인) 본문을 사용했습니다. 한국어 로마서는 의역이므로,
--    퍼블릭 도메인 또는 라이선스된 한국어 번역으로 교체 가능합니다.
-- =====================================================================

do $$
declare s uuid;
begin
  -- ============ 글없는책 (wordless) — ES 추가 ============
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='wordless') and step_order=1;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'es','El evangelio en colores','La mejor noticia, contada en cinco colores. Miramos juntos?')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='wordless') and step_order=2;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'es','Oro — el amor de Dios','Dios te ama y ha preparado un hogar eterno en el cielo.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='wordless') and step_order=3;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'es','Negro — el pecado','Pero el pecado nos ha separado de Dios.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='wordless') and step_order=4;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'es','Rojo — la sangre de Jesus','Jesus pago el precio derramando su sangre en la cruz.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='wordless') and step_order=5;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'es','Blanco — limpio','Cuando crees en el, tu corazon queda blanco como la nieve.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='wordless') and step_order=6;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'es','Verde — crecer','Ahora comienza una vida nueva que crece cada dia.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;

  -- ============ 사영리 (four-laws) — EN + ES ============
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='four-laws') and step_order=1;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','Four Spiritual Truths','Let me share four truths that open a relationship with God.'),
    (s,'es','Cuatro verdades espirituales','Quiero compartir cuatro verdades que abren una relacion con Dios.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='four-laws') and step_order=2;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','One: Love and a Plan','God loves you and has a wonderful plan for your life.'),
    (s,'es','Uno: amor y un plan','Dios te ama y tiene un plan maravilloso para tu vida.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='four-laws') and step_order=3;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','Two: Sin and Separation','Our sin stands in the way of that love.'),
    (s,'es','Dos: pecado y separacion','Nuestro pecado se interpone en ese amor.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='four-laws') and step_order=4;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','Three: Jesus Christ','Jesus is the only way to bridge that separation.'),
    (s,'es','Tres: Jesucristo','Jesus es el unico camino para cerrar esa separacion.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='four-laws') and step_order=5;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','Four: Receive Him','Now you can open the door of your heart and welcome him in.'),
    (s,'es','Cuatro: recibelo','Ahora puedes abrir la puerta de tu corazon y darle la bienvenida.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;

  -- ============ 다리 예화 (bridge) — EN + ES ============
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='bridge') and step_order=1;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','On Two Sides','On one side stands humanity, on the other the holy God.'),
    (s,'es','En dos lados','De un lado esta la humanidad, del otro el Dios santo.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='bridge') and step_order=2;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','The Gap Sin Made','Sin opened a deep canyon between the two.'),
    (s,'es','El abismo del pecado','El pecado abrio un abismo profundo entre los dos.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='bridge') and step_order=3;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','The Cross as a Bridge','The cross of Jesus became the bridge across that canyon.'),
    (s,'es','La cruz como puente','La cruz de Jesus se convirtio en el puente sobre ese abismo.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='bridge') and step_order=4;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','Crossing by Faith','By faith you can cross that bridge and come to God.'),
    (s,'es','Cruzar por fe','Por fe puedes cruzar ese puente y llegar a Dios.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;

  -- ============ 세 개의 원 (three-circles) — EN + ES ============
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='three-circles') and step_order=1;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','Let Us Draw Together','Let me draw the story with three circles.'),
    (s,'es','Dibujemos juntos','Voy a dibujar la historia con tres circulos.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='three-circles') and step_order=2;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','The Design of God','God designed a good and beautiful life.'),
    (s,'es','El diseno de Dios','Dios diseno una vida buena y hermosa.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='three-circles') and step_order=3;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','Brokenness','We left that path, and life became broken.'),
    (s,'es','Quebranto','Nos apartamos de ese camino y la vida se quebro.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='three-circles') and step_order=4;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','The Gospel and Recovery','Jesus came to restore what was broken.'),
    (s,'es','El evangelio y la restauracion','Jesus vino a restaurar lo que estaba roto.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='three-circles') and step_order=5;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','Repent and Believe','We turn, believe, and follow him.'),
    (s,'es','Arrepientete y cree','Nos volvemos, creemos y le seguimos.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;

  -- ============ 로마서로의 길 (romans) — EN(WEB) + ES(RV1909) ============
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='romans') and step_order=1;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','All have sinned','For all have sinned, and fall short of the glory of God.'),
    (s,'es','Todos pecaron','Por cuanto todos pecaron, y estan destituidos de la gloria de Dios.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='romans') and step_order=2;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','Wages and gift','For the wages of sin is death, but the free gift of God is eternal life in Christ Jesus our Lord.'),
    (s,'es','Paga y dadiva','Porque la paga del pecado es muerte, mas la dadiva de Dios es vida eterna en Cristo Jesus Senor nuestro.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='romans') and step_order=3;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','That love','But God commends his own love toward us, in that while we were yet sinners, Christ died for us.'),
    (s,'es','Ese amor','Mas Dios muestra su amor para con nosotros, en que siendo aun pecadores, Cristo murio por nosotros.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='romans') and step_order=4;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','Confess and believe','If you confess with your mouth that Jesus is Lord and believe in your heart that God raised him from the dead, you will be saved.'),
    (s,'es','Confiesa y cree','Que si confesares con tu boca al Senor Jesus, y creyeres en tu corazon que Dios le levanto de los muertos, seras salvo.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
  select id into s from besora.tool_steps where tool_id=(select id from besora.tools where slug='romans') and step_order=5;
  insert into besora.tool_step_translations (step_id,language_code,title,body) values
    (s,'en','Whoever calls','For whoever will call on the name of the Lord will be saved.'),
    (s,'es','Todo aquel','Porque todo aquel que invocare el nombre del Senor, sera salvo.')
  on conflict (step_id,language_code) do update set title=excluded.title, body=excluded.body;
end $$;

-- ============ 결단/영접 (decision) — ES 추가 ============
insert into besora.decision_translations
  (language_code, ask_title, ask_body, prayer_text, welcome_title, welcome_body) values
  ('es','Quieres recibir a Jesus?','Sin presion. Si tu corazon esta abierto, oremos juntos.',
   'Jesus, soy pecador. Creo que moriste por mi y resucitaste. Entra en mi corazon y se mi Senor. Gracias. Amen.',
   'Bienvenido!','Hoy comienza una vida nueva. Caminaremos juntos, paso a paso.')
on conflict (language_code) do update set
  ask_title=excluded.ask_title, ask_body=excluded.ask_body, prayer_text=excluded.prayer_text,
  welcome_title=excluded.welcome_title, welcome_body=excluded.welcome_body;

-- 끝.
