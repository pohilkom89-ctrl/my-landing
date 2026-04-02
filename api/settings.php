<?php
require_once __DIR__ . '/config.php';

$method = $_SERVER['REQUEST_METHOD'];
$db = getDB();

// GET — публичный (лендинг читает без авторизации)
if ($method === 'GET') {
    $rows = $db->query('SELECT `key`, `value` FROM settings')->fetchAll();
    $result = [];
    foreach ($rows as $r) {
        $result[$r['key']] = $r['value'];
    }
    jsonResponse($result);
}

// POST — обновить настройки (требует авторизации)
if ($method === 'POST') {
    requireAuth();
    $body = getJsonBody();

    $stmt = $db->prepare('INSERT INTO settings (`key`, `value`) VALUES (?, ?) ON DUPLICATE KEY UPDATE `value` = VALUES(`value`)');

    foreach ($body as $key => $value) {
        $stmt->execute([(string)$key, (string)$value]);
    }

    jsonResponse(['ok' => true]);
}

jsonError('Method not allowed', 405);
