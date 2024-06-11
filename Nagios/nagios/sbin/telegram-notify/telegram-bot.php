#!/usr/bin/php -q
<?php
// Example: php /usr/local/nagios/sbin/telegram-notify/telegram-bot.php "370022700" "83633434:kewkekekekdkkfiirrjririrjr" 1 "Notify: NOTIFICATIONTYPE 0XzXZ0 Host: HOSTNAME 0XzXZ0 Service: SERVICEDESC 0XzXZ0 Date: SHORTDATETIME 0XzXZ0 Info: SERVICEOUTPUT"
// Using to send messages about new threads in moderated status.
// where 370022700 - chat_id.
//
/*
Bot: nagiosnotifybot
API:83633434:kewkekekekdkkfiirrjririrjr
-----
How to get Chat_ID or Username of Telegram channel/chat:
1. Add bot to chat/channel as admin with post messages permitions.
2. Type command /my_id in chat.
3. See output here: https://api.telegram.org/bot83633434:kewkekekekdkkfiirrjririrjr/getUpdates
----
*/
//date_default_timezone_set('Europe/Minsk');
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL ^ E_NOTICE);
set_time_limit(30);
define('THIS_SCRIPT', 'telegram-bot');

$chat_id = $argv[1];
$botToken = $argv[2];
$flag = $argv[3];
$message = $argv[4];

//############## LOGS ####################//
$log_file= __DIR__ . '/log/'.date('dmY').'_telegram.log';

if(!file_exists ($log_file))
	{
$fh = fopen ($log_file, "w+");
  fwrite ($fh, "");
  fclose ($fh);
	}
//##################################//

if (isset($flag))
{
	if ($flag != 1)
	{
	//$msg = 'Flag is NOT valid: ' .$flag.' Exit.';
	//echo $msg."\n";
	//file_put_contents($log_file,date('d.m.Y H:i:s').'  :    '.$msg."\r\n",FILE_APPEND );
	/**** Flag must be = 1. ****/
	die;
	}
} else{
	//$msg = 'Not input flag: ' .$flag.' Exit.';
	//echo $msg."\n";
	//file_put_contents($log_file,date('d.m.Y H:i:s').'  :    '.$msg."\r\n",FILE_APPEND );
	die;
}

$msg = "-------------------------------------------------------------------";
file_put_contents($log_file,$msg."\r\n",FILE_APPEND );

/* Debug
$msg = "----- DEBUG:\nChat_id: ".$chat_id. ".\nBot_token: ".$botToken.".\nFlag: ".$flag.".\nMessage: ".$message."\n    ----- DEBUG.";
file_put_contents($log_file,date('d.m.Y H:i:s').'  :    '.$msg."\r\n",FILE_APPEND );
Debug */

if (!$chat_id) 
	{
	$msg = 'Not input chat_id. Exit.'; 
	echo $msg."\n";
	file_put_contents($log_file,date('d.m.Y H:i:s').'  :    '.$msg."\r\n",FILE_APPEND );
	die;
	}

if (!$botToken) 
	{
	$msg = 'Not input botToken. Exit.'; 
	echo $msg."\n";
	file_put_contents($log_file,date('d.m.Y H:i:s').'  :    '.$msg."\r\n",FILE_APPEND );
	die;
	}

//Fix line break
// 0XzXZ0 - it's fake line break character defined in Nagios command definition.
function replace_linebreak($message)
{
	global $message;
	$linebreak = "\n";
	$message = preg_replace('/0XzXZ0?/m', $linebreak, $message);
	$message = urlencode($message);
    return $message;
}

function Send_msg_to_Telegram ($botToken, $telegram_chat_id, $message){
	global $url, $log_file;
	$bot_url    = "https://api.telegram.org/bot$botToken/";
	//Fix new break
	$message = replace_linebreak($message);
	$url = $bot_url."sendMessage?chat_id=".$telegram_chat_id."&text=".$message;
	if ($content = json_decode(file_get_contents($url),true)) {
		return $content['ok'];
	}else{
	$msg = "ERROR with Telegram chat: ".$telegram_chat_id.".";
	echo $msg."\n";
	file_put_contents($log_file,date('d.m.Y H:i:s').'  :    '.$msg."\r\n",FILE_APPEND );
	}
}

$TelegramGROUPS=explode(',',$chat_id);

foreach ($TelegramGROUPS as $telegram_chat_id)
{
	echo "\n";
	$msg = '------------ START posting to '.$telegram_chat_id.' ------------';
	echo $msg."\n";
	file_put_contents($log_file,date('d.m.Y H:i:s').'  :    '.$msg."\r\n",FILE_APPEND );
	$telegram_data = Send_msg_to_Telegram($botToken, $telegram_chat_id, $message);
	if (isset($telegram_data) AND $telegram_data == 1) {
		$msg = "Message was SENT to telegram ".$telegram_chat_id."\r\nText: ".$message;
		echo $msg."\n";
		file_put_contents($log_file,date('d.m.Y H:i:s').'  :    '.$msg."\r\n",FILE_APPEND );
		} else {
		$msg = "Message was NOT sent to telegram ".$telegram_chat_id."\r\nText: ".$message;
		echo $msg."\n";
		file_put_contents($log_file,date('d.m.Y H:i:s').'  :    '.$msg."\r\n",FILE_APPEND );
		continue;
	}
$msg = "------------ END posting to ".$telegram_chat_id." ------------";
echo $msg."\n";
file_put_contents($log_file,date('d.m.Y H:i:s').'  :    '.$msg."\r\n",FILE_APPEND );
}

//Clean OLD logs every 30 days
	$files = glob(realpath(dirname(__FILE__)).'/log/*.log');
	if (empty($files)) {
	exit;
	}
	foreach($files as $file){
		if(time() - filectime($file) > 2592000){
			unlink($file);
		}
	} 
//Clean OLD logs every 30 days
?>