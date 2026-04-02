<?php
require_once __DIR__ . '/config.php';

$method = $_SERVER['REQUEST_METHOD'];
$db = getDB();
$id = $_GET['id'] ?? null;

if ($method === 'GET') {
    $visible = $_GET['visible'] ?? null;
    if ($visible === 'true') {
        $rows = $db->query('SELECT * FROM reviews WHERE visible = 1 ORDER BY sort_order ASC')->fetchAll();
    } else {
        $rows = $db->query('SELECT * FROM reviews ORDER BY sort_order ASC')->fetchAll();
    }
    foreach ($rows as &$r) { $r['visible'] = (bool)$r['visible']; }
    jsonResponse($rows);
}

if ($method === 'POST') {
    requireAuth();
    $b = getJsonBody();
    $stmt = $db->prepare('INSERT INTO reviews (`name`, role, text, avatar_letter, sort_order, visible) VALUES (?, ?, ?, ?, ?, ?)');
    $stmt->execute([$b['name'] ?? '', $b['role'] ?? '', $b['text'] ?? '', $b['avatar_letter'] ?? 'A', (int)($b['sort_order'] ?? 0), (int)($b['visible'] ?? 1)]);
    jsonResponse(['ok' => true, 'id' => (int)$db->lastInsertId()]);
}

if ($method === 'PUT' && $id) {
    requireAuth();
    $b = getJsonBody();
    $fields = [];
    $params = [];
    foreach (['name', 'role', 'text', 'avatar_letter'] as $f) {
        if (isset($b[$f])) { $fields[] = "`$f` = ?"; $params[] = $b[$f]; }
    }
    if (isset($b['sort_order'])) { $fields[] = 'sort_order = ?'; $params[] = (int)$b['sort_order']; }
    if (isset($b['visible'])) { $fields[] = 'visible = ?'; $params[] = (int)$b['visible']; }

    if ($fields) {
        $params[] = (int)$id;
        $db->prepare('UPDATE reviews SET ' . implode(', ', $fields) . ' WHERE id = ?')->execute($params);
    }
    jsonResponse(['ok' => true]);
}

if ($method === 'DELETE' && $id) {
    requireAuth();
    $db->prepare('DELETE FROM reviews WHERE id = ?')->execute([(int)$id]);
    jsonResponse(['ok' => true]);
}

jsonError('Method not allowed', 405);
