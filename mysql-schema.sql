-- ============================================================
-- MySQL Schema для mpohilko.ru
-- Выполнить в phpMyAdmin на Beget
-- ============================================================

-- ─── SETTINGS (key-value) ───
CREATE TABLE IF NOT EXISTS settings (
  `key` VARCHAR(255) PRIMARY KEY,
  `value` LONGTEXT NOT NULL,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─── SERVICES ───
CREATE TABLE IF NOT EXISTS services (
  id INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  description LONGTEXT NOT NULL DEFAULT '',
  price INT NOT NULL DEFAULT 0,
  tags JSON NOT NULL,
  benefits JSON NOT NULL,
  is_popular BOOLEAN NOT NULL DEFAULT FALSE,
  sort_order INT NOT NULL DEFAULT 0,
  visible BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─── FAQ ───
CREATE TABLE IF NOT EXISTS faq (
  id INT PRIMARY KEY AUTO_INCREMENT,
  question LONGTEXT NOT NULL,
  answer LONGTEXT NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  visible BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─── PORTFOLIO ───
CREATE TABLE IF NOT EXISTS portfolio (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  stack LONGTEXT NOT NULL DEFAULT '',
  result LONGTEXT NOT NULL DEFAULT '',
  image_url LONGTEXT NOT NULL DEFAULT '',
  sort_order INT NOT NULL DEFAULT 0,
  visible BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─── REVIEWS ───
CREATE TABLE IF NOT EXISTS reviews (
  id INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  role VARCHAR(255) NOT NULL DEFAULT '',
  text LONGTEXT NOT NULL DEFAULT '',
  avatar_letter CHAR(1) NOT NULL DEFAULT 'A',
  sort_order INT NOT NULL DEFAULT 0,
  visible BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─── LEADS (заявки) ───
CREATE TABLE IF NOT EXISTS leads (
  id INT PRIMARY KEY AUTO_INCREMENT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  `name` VARCHAR(255) DEFAULT NULL,
  service VARCHAR(255) DEFAULT NULL,
  budget VARCHAR(255) DEFAULT NULL,
  description LONGTEXT DEFAULT NULL,
  tg_username VARCHAR(255) DEFAULT NULL,
  tg_id VARCHAR(255) DEFAULT NULL,
  contact VARCHAR(255) DEFAULT NULL,
  status ENUM('new','in_progress','done') NOT NULL DEFAULT 'new'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─── ADMINS (авторизация) ───
CREATE TABLE IF NOT EXISTS admins (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- НАЧАЛЬНЫЕ ДАННЫЕ
-- ============================================================

-- Админ (пароль: Admin2026!)
INSERT INTO admins (email, password_hash) VALUES
  ('misha.pohil@yandex.ru', '$2y$10$placeholder');
-- ВАЖНО: после создания — выполнить в PHP:
-- echo password_hash('Admin2026!', PASSWORD_DEFAULT);
-- и заменить $2y$10$placeholder на реальный хеш

-- Настройки
INSERT INTO settings (`key`, `value`) VALUES
  ('busy_pct', '80'),
  ('free_slots', '2'),
  ('slots_month', 'апреле'),
  ('hero_title', 'Telegram-бот, сайт или MVP — под ключ'),
  ('hero_subtitle', 'Запускаю за 1–14 дней. Без студий и посредников — напрямую, быстро, по фиксированной цене.'),
  ('about_text_1', 'Меня зовут Михаил Похилько, 36 лет. Создаю цифровые продукты для бизнеса — быстро, качественно и напрямую без студий.'),
  ('about_text_2', 'Работаю с предпринимателями и небольшими командами, которым нужен результат, а не процесс. Вы получаете исходники, документацию и поддержку после запуска.');

-- Услуги
INSERT INTO services (`name`, description, price, tags, benefits, is_popular, sort_order) VALUES
  ('Telegram-боты', 'Автоматизация заявок и общения с клиентами. Работает 24/7 без участия человека.', 14900, '["Python","aiogram","SQLite"]', '["Принимает заявки 24/7","Освобождает менеджера от рутины","Срок: 5–10 дней"]', FALSE, 1),
  ('Лендинги', 'Страницы для запуска продукта или услуги. Адаптив, быстрая загрузка, чёткая структура.', 24900, '["HTML/CSS","JS","Адаптив"]', '["Мобильная версия с первого дня","Быстрая загрузка — до 2 секунд","Срок: 3–7 дней"]', TRUE, 2),
  ('MVP сервисы', 'Рабочий прототип за 1–2 недели. Минимум кода, максимум ценности — для проверки идеи.', 80000, '["FastAPI","PostgreSQL","Docker"]', '["Рабочий прототип за 1–2 недели","Готов к проверке инвестором","Поддержка 1 месяц после сдачи"]', FALSE, 3),
  ('AI инструменты', 'Чат-боты и автоматизация на базе GPT. Экономят время на рутинных задачах бизнеса.', 29900, '["OpenAI API","GPT-4o","LangChain"]', '["Экономит 10+ часов в неделю","Отвечает как живой специалист","Срок: 7–14 дней"]', FALSE, 4);

-- FAQ
INSERT INTO faq (question, answer, sort_order) VALUES
  ('Как происходит оплата?', '50% предоплата перед началом работы, 50% после сдачи и вашего подтверждения. Принимаю перевод на карту, по счёту для ИП/ООО, а также через СБП. Выдаю чек самозанятого.', 1),
  ('Сколько времени займёт проект?', 'Зависит от сложности: лендинг — 3–7 дней, Telegram-бот — 5–10 дней, MVP — 1–2 недели. Точные сроки фиксируем до начала работы, чтобы не было сюрпризов.', 2),
  ('Что если результат не устроит?', 'Показываю промежуточные результаты на каждом этапе — вы видите, как двигается проект. Правки вносим по ходу, а не в конце. Если совсем не подойдёт — вы платите только за выполненную часть.', 3),
  ('Можно ли вносить правки по ходу работы?', 'Да, правки в рамках согласованного ТЗ — бесплатно. Если захотите добавить что-то сверх изначального объёма, обсудим стоимость отдельно. Всё прозрачно.', 4),
  ('Что входит в поддержку после запуска?', '1 месяц бесплатной поддержки: исправление багов, мелкие доработки, консультации. Исходники передаю вам полностью — вы не зависите от меня после проекта.', 5),
  ('Работаете с ИП и ООО?', 'Да. Оформляю как самозанятый — выставляю счёт, выдаю чек. Подходит для закрытия расходов ИП и ООО. При необходимости заключаем договор на оказание услуг.', 6);

-- Портфолио (заглушки)
INSERT INTO portfolio (title, stack, result, sort_order, visible) VALUES
  ('Проект 1', 'Стек · Технологии', 'Результат проекта', 1, TRUE),
  ('Проект 2', 'Стек · Технологии', 'Результат проекта', 2, TRUE),
  ('Проект 3', 'Стек · Технологии', 'Результат проекта', 3, TRUE);

-- Отзывы (заглушки)
INSERT INTO reviews (`name`, role, text, avatar_letter, sort_order, visible) VALUES
  ('Имя клиента', 'Компания / сфера', 'Здесь будет отзыв клиента о сотрудничестве.', 'А', 1, TRUE),
  ('Имя клиента', 'Компания / сфера', 'Здесь будет отзыв клиента о сотрудничестве.', 'Б', 2, TRUE),
  ('Имя клиента', 'Компания / сфера', 'Здесь будет отзыв клиента о сотрудничестве.', 'В', 3, TRUE);
