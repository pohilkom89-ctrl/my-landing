<?php
require_once __DIR__ . '/config.php';

$method = $_SERVER['REQUEST_METHOD'];
$db = getDB();
$id = $_GET['id'] ?? null;

// GET — публичный
if ($method === 'GET') {
    $visible = $_GET['visible'] ?? null;
    if ($visible === 'true') {
        $rows = $db->query('SELECT * FROM services WHERE visible = 1 ORDER BY sort_order ASC')->fetchAll();
    } else {
        $rows = $db->query('SELECT * FROM services ORDER BY sort_order ASC')->fetchAll();
    }
    foreach ($rows as &$r) {
        $r['tags'] = json_decode($r['tags'], true) ?: [];
        $r['benefits'] = json_decode($r['benefits'], true) ?: [];
        $r['is_popular'] = (bool)$r['is_popular'];
        $r['visible'] = (bool)$r['visible'];
    }
    jsonResponse($rows);
}

// POST — создать
if ($method === 'POST') {
    requireAuth();
    $b = getJsonBody();
    $stmt = $db->prepare('INSERT INTO services (`name`, description, price, tags, benefits, is_popular, sort_order, visible) VALUES (?, ?, ?, ?, ?, ?, ?, ?)');
    $stmt->execute([
        $b['name'] ?? '',
        $b['description'] ?? '',
        (int)($b['price'] ?? 0),
        json_encode($b['tags'] ?? [], JSON_UNESCAPED_UNICODE),
        json_encode($b['benefits'] ?? [], JSON_UNESCAPED_UNICODE),
        (int)($b['is_popular'] ?? 0),
        (int)($b['sort_order'] ?? 0),
        (int)($b['visible'] ?? 1),
    ]);
    jsonResponse(['ok' => true, 'id' => (int)$db->lastInsertId()]);
}

// PUT — обновить
if ($method === 'PUT' && $id) {
    requireAuth();
    $b = getJsonBody();
    $fields = [];
    $params = [];

    foreach (['name', 'description'] as $f) {
        if (isset($b[$f])) { $fields[] = "`$f` = ?"; $params[] = $b[$f]; }
    }
    if (isset($b['price'])) { $fields[] = 'price = ?'; $params[] = (int)$b['price']; }
    foreach (['tags', 'benefits'] as $f) {
        if (isset($b[$f])) { $fields[] = "`$f` = ?"; $params[] = json_encode($b[$f], JSON_UNESCAPED_UNICODE); }
    }
    foreach (['is_popular', 'visible'] as $f) {
        if (isset($b[$f])) { $fields[] = "`$f` = ?"; $params[] = (int)$b[$f]; }
    }
    if (isset($b['sort_order'])) { $fields[] = 'sort_order = ?'; $params[] = (int)$b['sort_order']; }

    if ($fields) {
        $params[] = (int)$id;
        $db->prepare('UPDATE services SET ' . implode(', ', $fields) . ' WHERE id = ?')->execute($params);
    }
    jsonResponse(['ok' => true]);
}

// DELETE
if ($method === 'DELETE' && $id) {
    requireAuth();
    $db->prepare('DELETE FROM services WHERE id = ?')->execute([(int)$id]);
    jsonResponse(['ok' => true]);
}

jsonError('Method not allowed', 405);
