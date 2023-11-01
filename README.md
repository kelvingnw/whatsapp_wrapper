**Whatsapp Wrapper by Indospring IT Department**

This wrapper contains 2 Main Element

1. Node JS Script that runs every minute, processing messages that is in queue by reading the Database.
2. PHP Based API to insert messages into Database for queue.

**whatsapp_wrapper.js**

A Node JS Script that uses Whatsapp-Web JS Library to connect into Whatsapp Web using QR Code to Login.

Login Credentials are saved into Hidden Folders, otherwise we will be asked to Login via QR Code again.

This script will run every minutes by using Node-Cron Library, to avoid Whatsapp blocking the Wrapper because of suspicious activity as a bot, it will wait for 3 to 6 seconds each time before sending a new messages.

This wrapper can send plain-text messages, attachment such as images, pdf, office files, etc. It will process the messages in batch according to the priority value and queue order, batch size is adjustable by editing the value in settings table inside the Database. While the previous process is still not finished, it will wait until the process has been finished before processing the next batch.

**whatsapp_api.php**

A POST Based REST API built with PHP, this API retrieves POST parameters and verify it's contents before processing it into the Database.

_List of parameters that is used in this API:_

| Parameter           | Description                                                                      | Example Value                              | Mandatory |
| ------------------- | -------------------------------------------------------------------------------- | ------------------------------------------ | --------- |
| phone_number        | Recipient Phone Number (with leading 0)                                          | 088197xxxxx                                | [✓]       |
| message             | Content of the Chat                                                              | Free Text with Whatsapp Format             | [✓]       |
| attachment          | File to Attach in cURL File Format (local) or Base64 String (base64)             | Result of curl_file_create('path_to_file') | [X]       |
| attachment_type     | Attachment File Format                                                           | img/ pdf/ xlsx                             | [△]       |
| attachment_location | cURL File Format or Base64                                                       | local/ base64                              | [△]       |
| attachment_filename | New Filename for Attached File                                                   | gambar_baru1                               | [X]       |
| schedule_date       | When the Message are Allowed to be Processed (Default Value is now)              | 2023-07-27 10:42:49.000                    | [X]       |
| app_type            | Source Program Referring to Table app_list                                       | hris/ pp                                   | [✓]       |
| token               | Token based on Source Program                                                    | p8FN0pUoDg5pGSz8tyWs1qwoy3WzPkVZJDeP9 | [✓]       |
| priority            | Message Priority, Smaller Number = Higher Priority (1-100, Default Value is 100) | 23                                         | [X]       |
| sender_refid        | Sender Reference ID, Usually ISP Barcode/ bot if from system                     | SF221233xxx/ bot                           | [X]       |
| sender_notes        | Freetext Notes from Sender Perspective                                           | Direksi PR Approver                        | [X]       |
| receiver_refid      | Recipient Reference ID, Usually ISP Barcode                                      | SF221233xxx                                | [X]       |
| receiver_notes      | Freetext Notes from Recipient Perspective                                        | PR Creator/ PR PIC                         | [X]       |

[✓]= Mandatory
 [△]= Mandatory if there is an Attachment
 [X]= Not Mandatory

_Request Form Example:_

$target_url = 'http://url_to_api';

$post = array();

$post['phone_number'] = '08819751892';

$post['message'] = "Test Message with wa.me hyperlink such as https://wa.me/628xxxx610?text=Test%20WA%20Me";

$post['attachment'] =  curl_file_create('./wallpaperflare.com_wallpaper.jpg');

$post['attachment_type'] =  'img';

$post['attachment_filename'] =  'Gambar1';

$post['schedule_date'] = date('Y-m-d H:i:s');

$post['app_type'] = 'hris';

$post['token'] = 'p8FN0pUoDg5pGSz8tyWs1qwoy3WzPkVZJDeP9';

$post['priority'] = 15;

$post['sender_refid'] = 'SF22061292';

$post['sender_notes'] = 'Manager PR Approver';

$post['receiver_refid'] = 'SF23011330';

$post['receiver_notes'] = 'PR PIC';

$ch = curl_init();

curl_setopt($ch, CURLOPT_URL, $target_url);

curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

curl_setopt($ch, CURLOPT_POST, 1);

curl_setopt($ch, CURLOPT_POSTFIELDS, $post);

$result = curl_exec($ch);

curl_close($ch);

echo $result;
