# CLAUDE.md — Правила работы над проектом

## Проект
Личный лендинг Михаила Похилько — цифровые продукты под ключ.

---

## Стек и ограничения

- Лендинг в `landing.html`, админка в `admin.html` — без фреймворков, без npm
- Иконки только SVG встроенные в HTML
- CSS и JS внутри HTML-файлов
- Внешние CDN разрешены (Supabase JS SDK)
- **Supabase** — бэкенд (БД, авторизация, API). Проект: `pizugvvcpjrulhvrsnyo.supabase.co`
- SQL-схема: `supabase-setup.sql`

---

## Дизайн-система

| Переменная | Значение |
|------------|----------|
| Фон основной | `#F0F2FF` |
| Фон вторичный | `#E8EAFF` |
| Карточки | `#FFFFFF` |
| Акцент | `#5B5BD6` |
| Акцент hover | `#4747C2` |
| Текст | `#0A0E1C` |
| Приглушённый | `#6B7280` |
| Радиус | `16px` |

- Светлая тема
- Шрифт: Inter (body) / Manrope (заголовки) — Google Fonts
- Mobile-first адаптация обязательна

---

## Контент (не менять без запроса)

- **Имя:** Михаил Похилько, 36 лет
- **Telegram:** @MuXauJl89
- **Фото:** `photo-hero.png`
- **Заголовок:** "Один разработчик — Telegram-бот, сайт или MVP под ключ"

---

## Git-правила

- Коммиты на английском, формат: `feat:` / `fix:` / `docs:` / `style:`
- Каждое изменение — отдельный коммит
- Не делать `git push --force`
- Не коммитить без явной просьбы пользователя

---

## Правила работы с кодом

- Не добавлять новые секции без запроса
- Не менять цены и тексты без явного указания
- Не усложнять — минимум кода для задачи
- Перед правками — читать файл
- После правок — проверять мобильную вёрстку

---

## Архитектура

```
admin.html ──(fetch)──→ PHP API ←──(fetch)── landing.html
                            ↓
                     MySQL (Beget)
                            ↓
                  leads.php → Telegram API
```

- `landing.html` — лендинг, подтягивает данные из PHP API (`/api/*.php`), fallback на статику
- `admin.html` — админ-панель, PHP-сессии для авторизации, CRUD через fetch к API
- `api/` — PHP API: config.php, auth.php, settings.php, services.php, faq.php, portfolio.php, reviews.php, leads.php
- `mysql-schema.sql` — таблицы: settings, services, faq, portfolio, reviews, leads, admins
- **Хостинг:** Beget shared (PHP 8.1 + MySQL 8.0), домен mpohilko.ru

## Следующие шаги проекта

- [x] Пуш на GitHub — репо `pohilkom89-ctrl/my-landing`
- [x] FAQ секция — аккордеон с 6 вопросами
- [x] Админ-панель + Supabase — управление всем контентом
- [x] **Supabase подключён** — проект создан, SQL запущен, ключи вставлены в оба HTML
- [x] Лендинг обновлён — Inter/Manrope, OG-теги, новое фото, Supabase dynamic load
- [x] **Telegram-бот + Mini App** — код готов, webapp на Vercel, Supabase leads таблица создана
- [x] **Воронка: лендинг → Mini App** — все CTA ведут на webapp, заявки пишутся в Supabase напрямую
- [x] **152-ФЗ базовый** — privacy.html, чекбокс согласия в форме, ссылка в футере
- [x] **Админка: вкладка Заявки** — просмотр, статусы (новая/в работе/готово), удаление
- [x] **Код-ревью бота** — XSS-защита, singleton Supabase, параллельные запросы, валидация
- [x] **Деплой на Beget** — shared-хостинг, файлы залиты по FTP, .htaccess, WebP, robots/sitemap
- [x] **Домен mpohilko.ru** — зарегистрирован, привязан, SSL Let's Encrypt активен
- [x] **CTA → Telegram + Max** — все кнопки ведут на личные аккаунты (t.me/MuXauJl89 + max.ru)
- [x] **SSL + HTTPS-редирект** — Let's Encrypt, .htaccess с X-Forwarded-Proto (Beget nginx proxy)
- [x] **Миграция Supabase → PHP+MySQL** — 8 PHP API файлов, 7 MySQL таблиц, 38 вызовов переписаны
- [x] **152-ФЗ: данные в РФ** — все ПД хранятся на Beget (российский хостинг)
- [x] **Telegram-уведомления** — leads.php отправляет через curl при новой заявке
- [ ] **152-ФЗ доработка** — уведомить Роскомнадзор, доработать политику (8 пробелов из аудита VK)
- [ ] Наполнить портфолио и отзывы реальным контентом (через админку)
- [ ] Протестировать полный цикл: лендинг → Telegram/Max → заявка → уведомление
- [ ] Запустить Telegram-канал для трафика
- [ ] Удалить Supabase проект (больше не используется)
