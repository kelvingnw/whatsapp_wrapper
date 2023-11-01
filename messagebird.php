<?php

require(__DIR__ . '/vendor/autoload.php');

$messageBird = new \MessageBird\Client('kEnKtaa09M4vdXxAdZEoJS6qI', null, [\MessageBird\Client::ENABLE_CONVERSATIONSAPI_WHATSAPP_SANDBOX]);

// Enable the whatsapp sandbox feature
//$messageBird = new MessageBirdClient(
//    yZ4qj9Ds5uPdsjmLn1LEObexC',
//    null,
//    [MessageBirdClient::ENABLE_CONVERSATIONSAPI_WHATSAPP_SANDBOX]
//);

$conversationId = '2e15efafec384e1c82e9842075e87beb';

$content = new \MessageBird\Objects\Conversation\Content();
$content->text = 'test';

$message = new \MessageBird\Objects\Conversation\Message();
$message->channelId = '52537b1edeb141e1ab8e6eeef37e1905';
$message->type = 'text';
$message->content = $content;

try {
    $conversation = $messageBird->conversationMessages->create($conversationId, $message);
    var_dump($conversation);
} catch (\Exception $e) {
    echo sprintf("%s: %s", get_class($e), $e->getMessage());
}

// $content = new \MessageBird\Objects\Conversation\Content();
// $content->text = 'Hello world';

// $message = new \MessageBird\Objects\Conversation\Message();
// $message->channelId = '52537b1edeb141e1ab8e6eeef37e1905';
// $message->content = $content;
// $message->to = '2e15efafec384e1c82e9842075e87beb'; // Channel-specific, e.g. MSISDN for SMS.
// $message->type = 'text';

// try {
//     $conversation = $messageBird->conversations->start($message);
//     var_dump($conversation);
// } catch (\Exception $e) {
//     echo sprintf("%s: %s", get_class($e), $e->getMessage());
// }
