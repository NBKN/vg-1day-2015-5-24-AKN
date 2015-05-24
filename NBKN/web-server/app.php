<?php

use Symfony\Component\HttpFoundation\Request;

$app = new My1DayServer\Application();
$app['debug'] = true;

$app->get('/messages', function () use ($app) {
    $messages = $app->getAllMessages();

    return $app->json($messages);
});

$app->get('/messages/{id}', function ($id) use ($app) {
    $message = $app->getMessage($id);

    return $app->json($message);
});

$app->post('/messages', function (Request $request) use ($app) {
    $data = $app->validateRequestAsJson($request);

    $username = isset($data['username']) ? $data['username'] : '';
    $body = isset($data['body']) ? $data['body'] : '';

    if($body == 'uranai') {
    	$rnd = rand(0, 100);
    	switch ($rnd) {
    		case (80 < $rnd):
    			$body = 'daikichi';
    			break;
    		case (40 < $rnd):
    			$body = 'kichi';
    			break;
    		default:
    			$body = 'kyou';
    			break;
    	}
    }

    $createdMessage = $app->createMessage($username, $body, base64_encode(file_get_contents($app['icon_image_path'])));
    $createdMessage = $app->createMessage('BOT', $body, base64_encode(file_get_contents($app['icon_image_path'])));

    return $app->json($createdMessage);
});

return $app;
