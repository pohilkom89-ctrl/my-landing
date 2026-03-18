# PLAN.md — План развития лендинга

## Что сделано (Steps 1–6, март 2026)

- [x] Step 1 — Базовые баги: box-sizing, blob overflow, hero mobile swap, img width/height, preload, copyright
- [x] Step 2 — Дизайн: светлая тема (#F0F2FF), blobs внутри hero, типографика ≥ 0.75rem, mid-cta статичный градиент
- [x] Step 3 — UX: badge занятости, hero note, footer legal, nav links portfolio/reviews, placeholder секции
- [x] Step 4 — Цены: flex-column на картах, 14 900 / 24 900 / 80 000 / 29 900 ₽, benefits list, guarantee, блок "Почему не студия"
- [x] Step 5 — SEO: Schema.org JSON-LD (Person + OfferCatalog), удалён @keyframes grad-shift
- [x] Step 6 — Доступность: :focus-visible, aria-hidden на SVG, aria-expanded на burger, mob-nav → <nav>, Escape сбрасывает aria-expanded
- [x] GitHub: репо pohilkom89-ctrl/my-landing, GitHub Pages

---

## Осталось сделать

### Контент (ждёт клиентов)

- [ ] **#portfolio — реальные кейсы**
  - Формат: название, стек, задача → решение → результат, ссылка/скриншот
  - Сейчас 3 placeholder-карточки ("Скоро")

- [ ] **#reviews — отзывы**
  - Формат: аватар, имя, роль клиента, текст
  - Сейчас 3 placeholder-карточки

### Маркетинг / трафик

- [ ] **Демо Telegram-бот** — ссылка на живого бота как доказательство скилла
- [ ] **Telegram-канал** — создать, оформить, публиковать кейсы
- [ ] **Счётчик проектов** ("12 проектов запущено") — после накопления

### Техническое

- [ ] **FAQ секция** — вставить перед #about
  - Вопросы: цена, сроки, правки, что если не понравится, поддержка после сдачи

- [ ] **Обновлять badge вручную** — `Занят на 80% · 2 слота в апреле`
  - Менять перед началом каждого месяца в landing.html (~строка 715)

- [ ] **Canonical URL** — после подключения домена обновить в JSON-LD и добавить `<link rel="canonical">`

- [ ] **Яндекс.Метрика** — подключить счётчик для аналитики трафика

---

## Цены (актуальные)

| Услуга          | Цена       |
|-----------------|------------|
| Telegram-бот    | от 14 900 ₽ |
| Лендинг         | от 24 900 ₽ |
| MVP сервис      | от 80 000 ₽ |
| AI инструменты  | от 29 900 ₽ |
