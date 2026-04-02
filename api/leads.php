<?php
require_once __DIR__ . '/config.php';

$method = $_SERVER['REQUEST_METHOD'];
$db = getDB();
$id = $_GET['id'] ?? null;

// GET — список заявок (только для админа)
if ($method === 'GET') {
    requireAuth();
    $rows = $db->query('SELECT * FROM leads ORDER BY created_at DESC')->fetchAll();
    jsonResponse($rows);
}

// POST — новая заявка (публичный, от webapp)
if ($method === 'POST') {
    $b = getJsonBody();
    $name = trim($b['name'] ?? '');

    if (!$name) {
        jsonError('Name is required');
    }

    $stmt = $db->prepare('INSERT INTO leads (`name`, service, budget, description, tg_username, tg_id, contact, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)');
    $stmt->execute([
        $name,
        $b['service'] ?? null,
        $b['budget'] ?? null,
        $b['description'] ?? null,
        $b['tg_username'] ?? null,
        $b['tg_id'] ?? null,
        $b['contact'] ?? null,
        'new',
    ]);

    // Telegram notification
    sendTelegramNotification($b);

    jsonResponse(['ok' => true, 'id' => (int)$db->lastInsertId()]);
}

// PUT — обновить статус
if ($method === 'PUT' && $id) {
    requireAuth();
    $b = getJsonBody();
    $status = $b['status'] ?? null;

    if (!in_array($status, ['new', 'in_progress', 'done'])) {
        jsonError('Invalid status');
    }

    $db->prepare('UPDATE leads SET status = ? WHERE id = ?')->execute([$status, (int)$id]);
    jsonResponse(['ok' => true]);
}

// DELETE
if ($method === 'DELETE' && $id) {
    requireAuth();
    $db->prepare('DELETE FROM leads WHERE id = ?')->execute([(int)$id]);
    jsonResponse(['ok' => true]);
}

// ─── Telegram notification ───
function sendTelegramNotification(array $b): void {
    $msg = "🆕 Новая заявка!\n\n"
        . "👤 " . ($b['name'] ?? '—') . "\n"
        . "📱 " . ($b['tg_username'] ?? $b['contact'] ?? '—') . "\n"
        . "🔧 Услуга: " . ($b['service'] ?? '—') . "\n"
        . "💰 Бюджет: " . ($b['budget'] ?? '—') . "\n"
        . "📝 " . mb_substr($b['description'] ?? '—', 0, 1000);

    $url = 'https://api.telegram.org/bot' . TG_BOT_TOKEN . '/sendMessage';

    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => json_encode([
            'chat_id' => TG_CHAT_ID,
            'text' => $msg,
        ]),
        CURLOPT_HTTPHEADER => ['Content-Type: application/json'],
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 5,
    ]);
    curl_exec($ch);
    curl_close($ch);
}

jsonError('Method not allowed', 405);
