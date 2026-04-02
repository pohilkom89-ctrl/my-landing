<?php
// ─── Database config ───
define('DB_HOST', 'localhost');
define('DB_NAME', 'pohilkex_landing');
define('DB_USER', 'pohilkex_landing');
define('DB_PASS', 'mwQX*6k2XdU&');

// ─── Telegram ───
define('TG_BOT_TOKEN', '8752313582:AAHTzNSoDVkfq7iqxIWuGdL2dYi73xqcoH8');
define('TG_CHAT_ID', '564797830');

// ─── Session ───
session_start();

// ─── PDO connection ───
function getDB(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO(
            'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
            DB_USER,
            DB_PASS,
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
            ]
        );
    }
    return $pdo;
}

// ─── JSON response helpers ───
function jsonResponse($data, int $code = 200): void {
    http_response_code($code);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

function jsonError(string $msg, int $code = 400): void {
    jsonResponse(['error' => $msg], $code);
}

// ─── Auth check ───
function requireAuth(): void {
    if (empty($_SESSION['admin_id'])) {
        jsonError('Unauthorized', 401);
    }
}

// ─── Read JSON body ───
function getJsonBody(): array {
    $raw = file_get_contents('php://input');
    $data = json_decode($raw, true);
    return is_array($data) ? $data : [];
}

// ─── CORS (same domain, no issues) ───
header('X-Content-Type-Options: nosniff');
