-- ============================================================
-- Supabase setup for landing admin panel
-- Run this in Supabase SQL Editor (supabase.com → project → SQL Editor)
-- ============================================================

-- ─── SETTINGS (key-value) ───
create table if not exists settings (
  key text primary key,
  value text not null,
  updated_at timestamptz default now()
);

-- ─── SERVICES ───
create table if not exists services (
  id serial primary key,
  name text not null,
  description text not null default '',
  price integer not null default 0,
  tags text[] not null default '{}',
  benefits text[] not null default '{}',
  is_popular boolean not null default false,
  sort_order integer not null default 0,
  visible boolean not null default true
);

-- ─── FAQ ───
create table if not exists faq (
  id serial primary key,
  question text not null,
  answer text not null,
  sort_order integer not null default 0,
  visible boolean not null default true
);

-- ─── PORTFOLIO ───
create table if not exists portfolio (
  id serial primary key,
  title text not null,
  stack text not null default '',
  result text not null default '',
  image_url text not null default '',
  sort_order integer not null default 0,
  visible boolean not null default true
);

-- ─── REVIEWS ───
create table if not exists reviews (
  id serial primary key,
  name text not null,
  role text not null default '',
  text text not null default '',
  avatar_letter char(1) not null default 'A',
  sort_order integer not null default 0,
  visible boolean not null default true
);

-- ============================================================
-- ROW LEVEL SECURITY
-- anon = read only, authenticated = full access
-- ============================================================

alter table settings  enable row level security;
alter table services  enable row level security;
alter table faq       enable row level security;
alter table portfolio enable row level security;
alter table reviews   enable row level security;

-- Settings
create policy "settings_read"  on settings for select to anon, authenticated using (true);
create policy "settings_write" on settings for all    to authenticated using (true) with check (true);

-- Services
create policy "services_read"  on services for select to anon, authenticated using (true);
create policy "services_write" on services for all    to authenticated using (true) with check (true);

-- FAQ
create policy "faq_read"  on faq for select to anon, authenticated using (true);
create policy "faq_write" on faq for all    to authenticated using (true) with check (true);

-- Portfolio
create policy "portfolio_read"  on portfolio for select to anon, authenticated using (true);
create policy "portfolio_write" on portfolio for all    to authenticated using (true) with check (true);

-- Reviews
create policy "reviews_read"  on reviews for select to anon, authenticated using (true);
create policy "reviews_write" on reviews for all    to authenticated using (true) with check (true);

-- ============================================================
-- SEED DATA — current landing content
-- ============================================================

-- Settings
insert into settings (key, value) values
  ('busy_pct',       '80'),
  ('free_slots',     '2'),
  ('slots_month',    'апреле'),
  ('hero_title',     'Telegram-бот, сайт или MVP — под ключ'),
  ('hero_subtitle',  'Запускаю за 1–14 дней. Без студий и посредников — напрямую, быстро, по фиксированной цене.'),
  ('about_text_1',   'Меня зовут Михаил Похилько, 36 лет. Создаю цифровые продукты для бизнеса — быстро, качественно и напрямую без студий.'),
  ('about_text_2',   'Работаю с предпринимателями и небольшими командами, которым нужен результат, а не процесс. Вы получаете исходники, документацию и поддержку после запуска.')
on conflict (key) do nothing;

-- Services
insert into services (name, description, price, tags, benefits, is_popular, sort_order) values
  ('Telegram-боты',  'Автоматизация заявок и общения с клиентами. Работает 24/7 без участия человека.', 14900, '{Python,aiogram,SQLite}', '{Принимает заявки 24/7,Освобождает менеджера от рутины,"Срок: 5–10 дней"}', false, 1),
  ('Лендинги',       'Страницы для запуска продукта или услуги. Адаптив, быстрая загрузка, чёткая структура.', 24900, '{HTML/CSS,JS,Адаптив}', '{Мобильная версия с первого дня,"Быстрая загрузка — до 2 секунд","Срок: 3–7 дней"}', true, 2),
  ('MVP сервисы',    'Рабочий прототип за 1–2 недели. Минимум кода, максимум ценности — для проверки идеи.', 80000, '{FastAPI,PostgreSQL,Docker}', '{Рабочий прототип за 1–2 недели,Готов к проверке инвестором,Поддержка 1 месяц после сдачи}', false, 3),
  ('AI инструменты', 'Чат-боты и автоматизация на базе GPT. Экономят время на рутинных задачах бизнеса.', 29900, '{OpenAI API,GPT-4o,LangChain}', '{Экономит 10+ часов в неделю,Отвечает как живой специалист,"Срок: 7–14 дней"}', false, 4);

-- FAQ
insert into faq (question, answer, sort_order) values
  ('Как происходит оплата?', '50% предоплата перед началом работы, 50% после сдачи и вашего подтверждения. Принимаю перевод на карту, по счёту для ИП/ООО, а также через СБП. Выдаю чек самозанятого.', 1),
  ('Сколько времени займёт проект?', 'Зависит от сложности: лендинг — 3–7 дней, Telegram-бот — 5–10 дней, MVP — 1–2 недели. Точные сроки фиксируем до начала работы, чтобы не было сюрпризов.', 2),
  ('Что если результат не устроит?', 'Показываю промежуточные результаты на каждом этапе — вы видите, как двигается проект. Правки вносим по ходу, а не в конце. Если совсем не подойдёт — вы платите только за выполненную часть.', 3),
  ('Можно ли вносить правки по ходу работы?', 'Да, правки в рамках согласованного ТЗ — бесплатно. Если захотите добавить что-то сверх изначального объёма, обсудим стоимость отдельно. Всё прозрачно.', 4),
  ('Что входит в поддержку после запуска?', '1 месяц бесплатной поддержки: исправление багов, мелкие доработки, консультации. Исходники передаю вам полностью — вы не зависите от меня после проекта.', 5),
  ('Работаете с ИП и ООО?', 'Да. Оформляю как самозанятый — выставляю счёт, выдаю чек. Подходит для закрытия расходов ИП и ООО. При необходимости заключаем договор на оказание услуг.', 6);

-- Portfolio (placeholders)
insert into portfolio (title, stack, result, sort_order, visible) values
  ('Проект 1', 'Стек · Технологии', 'Результат проекта', 1, true),
  ('Проект 2', 'Стек · Технологии', 'Результат проекта', 2, true),
  ('Проект 3', 'Стек · Технологии', 'Результат проекта', 3, true);

-- Reviews (placeholders)
insert into reviews (name, role, text, avatar_letter, sort_order, visible) values
  ('Имя клиента', 'Компания / сфера', 'Здесь будет отзыв клиента о сотрудничестве.', 'А', 1, true),
  ('Имя клиента', 'Компания / сфера', 'Здесь будет отзыв клиента о сотрудничестве.', 'Б', 2, true),
  ('Имя клиента', 'Компания / сфера', 'Здесь будет отзыв клиента о сотрудничестве.', 'В', 3, true);
