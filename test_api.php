<?php
echo "Start API Test";

// $cFile = curl_file_create('./wallpaperflare.com_wallpaper.jpg');

$target_url = 'http://192.168.150.200:9070/whatsapp_api.php';

$post = array();

$post['phone_number'] = '08819751892';

$post['message'] = "Test Message with wa.me hyperlink such as https://wa.me/6282229556610?text=Test%20WA%20Me";

$post['attachment'] =  curl_file_create('./wallpaperflare.com_wallpaper.jpg');

$post['attachment_type'] =  'img';

$post['attachment_filename'] =  'Gambar1';

$post['schedule_date'] = date('Y-m-d H:i:s');

$post['app_type'] = 'hris';

$post['token'] = 'p8FN0pUooQUjTYzLv5u4M6MkAbPdHGEm0tBDg5pGSz8tyWs1qwoy3WzPkVZJDeP9';

$post['priority'] = 15;

$post['sender_refid'] = 'SF22061292';

$post['sender_notes'] = 'Manager PR Approver';

$post['receiver_refid'] = 'SF23011330';

$post['receiver_notes'] = 'PR PIC';

// echo var_dump($post);    

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $target_url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
$result = curl_exec($ch);
curl_close($ch);
echo $result;
