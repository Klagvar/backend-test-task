<?php
declare(strict_types=1);

const LOCK_KEY  = 'my_script_lock';
const LOCK_TTL  = 10; // seconds
const WORK_TIME = 5;  // seconds

$redis = new Redis();

$redis->connect('redis', 6379);

// пробуем установить замок: true → мы первые, false → уже кто-то работает
$lockAcquired = $redis->set(LOCK_KEY, 1, ['nx', 'ex' => LOCK_TTL]);

if (!$lockAcquired) {
    echo "Another instance is already running – exiting.\n";
    exit(0);
}

echo "Lock acquired, working...\n";
sleep(WORK_TIME);
echo "Work done.\n";

// снимаем замок раньше TTL, чтобы не держать лишний ключ
$redis->del(LOCK_KEY);








