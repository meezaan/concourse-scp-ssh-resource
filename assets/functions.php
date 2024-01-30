<?php

function write(mixed $message): void
{
    if (is_array($message) || is_object($message)) {
        // Sanitize anything.
        $message = json_decode(json_encode($message));
        $message = implode("\n", $message);
    }
    fwrite(STDERR, $message . "\n");
}
