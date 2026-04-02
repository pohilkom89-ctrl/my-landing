<?php
require_once __DIR__ . '/config.php';

$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';

if ($method === 'POST' && $action === 'login') {
    $body = getJsonBody();
    $email = trim($body['email'] ?? '');
    $password = $body['password'] ?? '';

    if (!$email || !$password) {
        jsonError('Email and password required');
    }

    $db = getDB();
    $stmt = $db->prepare('SELECT id, password_hash FROM admins WHERE email = ?');
    $stmt->execute([$email]);
    $admin = $stmt->fetch();

    if (!$admin || !password_verify($password, $admin['password_hash'])) {
        jsonError('Invalid credentials', 401);
    }

    $_SESSION['admin_id'] = $admin['id'];
    jsonResponse(['ok' => true]);
}

if ($method === 'POST' && $action === 'logout') {
    session_destroy();
    jsonResponse(['ok' => true]);
}

if ($method === 'GET' && $action === 'session') {
    jsonResponse(['authenticated' => !empty($_SESSION['admin_id'])]);
}

// ─── Утилита: сгенерировать хеш пароля (вызвать один раз) ───
if ($method === 'GET' && $action === 'hash') {
    $pass = $_GET['pass'] ?? '';
    if (!$pass) jsonError('?pass= required');
    jsonResponse(['hash' => password_hash($pass, PASSWORD_DEFAULT)]);
}

jsonError('Unknown action', 404);
