-- ═══════════════════════════════════════════════════
-- Триггер: уведомление в Telegram при новой заявке
-- Запустить в Supabase Dashboard → SQL Editor
-- ═══════════════════════════════════════════════════

-- 1. Включить расширение pg_net (HTTP-запросы из PostgreSQL)
create extension if not exists pg_net with schema extensions;

-- 2. Добавить policy на удаление (для админки)
do $$ begin
  create policy "auth delete leads" on leads
    for delete to authenticated using (true);
exception when duplicate_object then null;
end $$;

-- 3. Сохранить токены в settings
insert into settings (key, value) values
  ('telegram_bot_token', '8752313582:AAHTzNSoDVkfq7iqxIWuGdL2dYi73xqcoH8'),
  ('telegram_chat_id',   '564797830')
on conflict (key) do update set value = excluded.value;

-- 4. Функция отправки уведомления в Telegram
create or replace function notify_admin_on_lead()
returns trigger as $$
declare
  bot_token text;
  chat_id   text;
  msg       text;
begin
  select value into bot_token from settings where key = 'telegram_bot_token';
  select value into chat_id   from settings where key = 'telegram_chat_id';

  if bot_token is null or chat_id is null then
    raise warning 'notify_admin_on_lead: telegram credentials not found in settings';
    return NEW;
  end if;

  msg := '🆕 Новая заявка!' || chr(10) || chr(10) ||
         '👤 ' || coalesce(NEW.name, '—') || chr(10) ||
         '📱 ' || coalesce(NEW.tg_username, '—') || chr(10) ||
         '🔧 Услуга: ' || coalesce(NEW.service, '—') || chr(10) ||
         '💰 Бюджет: ' || coalesce(NEW.budget, '—') || chr(10) ||
         '📝 ' || coalesce(left(NEW.description, 1000), '—');

  msg := left(msg, 4090);

  perform net.http_post(
    url     := 'https://api.telegram.org/bot' || bot_token || '/sendMessage',
    body    := jsonb_build_object(
      'chat_id', chat_id,
      'text',    msg
    ),
    headers := '{"Content-Type": "application/json"}'::jsonb
  );

  return NEW;

exception when others then
  raise warning 'notify_admin_on_lead failed: %', SQLERRM;
  return NEW;
end;
$$ language plpgsql security definer;

-- 5. Триггер: срабатывает после каждой новой заявки
drop trigger if exists on_lead_insert on leads;
create trigger on_lead_insert
  after insert on leads
  for each row
  execute function notify_admin_on_lead();

-- ═══════════════════════════════════════════════════
-- ПРОВЕРКА (выполни отдельно после основного скрипта):
-- ═══════════════════════════════════════════════════
-- select extname from pg_extension where extname = 'pg_net';
-- select proname from pg_proc where proname = 'notify_admin_on_lead';
-- select trigger_name from information_schema.triggers where trigger_name = 'on_lead_insert';
