<?php

include __DIR__ . '/../vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../');
$dotenv->load();

function request($url, $body = []) {
  $curl = \curl_init();
  $url = 'https://api.telegram.org/bot' . $_ENV['BOT_TOKEN'] . $url;
  $headers = [
    "Cache-Control: no-cache",
    "Content-Type:  application/json",
  ];
  curl_setopt($curl, CURLOPT_URL, $url);
  curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
  curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
  curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
  curl_setopt($curl, CURLOPT_POST, true);
  curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($body));
  $response = json_decode(curl_exec($curl), true);
  curl_close($curl);
  return $response;
}

request('/sendMessage', [
	'text' => '123',
	'chat_id' => 18435891
]);

echo PHP_EOL;