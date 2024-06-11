Send notifications via Telegram

I use this PHP-script to send Nagios notifications to Telegram groups, channels or private.

Requirements:
-PHP 5.3 and above.
-Nagios 3 and above.

Instructions:
1. Telegram.
1.1. Find @BotFather in your telegram account.
1.2. Creating your own bot: 
 - Input command /newbot
 - Define name for your bot. For example: Nagios-Notify
 - Define username for your bot. Username must be with ending with "bot" or "_bot". For example: nagiosnotifybot
 - If you done all right, you'll see congratulation message from BotFather. There is HTTP API key. Write down this information and bot's username as well.
1.3. Now you (and other users who need to telegram notifies) must add your bot to contact (find @nagiosnotifybot).
1.4. Find your chad_id value. Every user need to send message /my_id to in chat with your bot. After that open following URL: 
https://api.telegram.org/bot83633434:kewkekekekdkkfiirrjririrjr/getUpdates
, where 83633434:kewkekekekdkkfiirrjririrjr -it's your HTTP API key (for example).
On this page you can find information, that see you bot. For example:
{"ok":true,"result":[{"update_id":135442367,"message":{"message_id":8,"from":{"id":370022700,"is_bot":false,"first_name":"myusername","username":"myusername","language_code":"ru"},"chat":{"id":370022700,"first_name":"myusername","username":"myusername","type":"private"},"date":1519148458,"text":"/my_id","entities":[{"offset":0,"length":6,"type":"bot_command"}]}}]}
, where 370022700 - it's your ID. Write down this information. You'll define this ID in your Nagios contact definitions.

2. PHP-script.
2.1. Download and unzip telegram-notify.zip in /usr/local/nagios/sbin folder. telegram-notify.zip contains: 
- folder "telegram-notify";
- folder "log";
- php-script "telegram-bot.php"; 
- readme.txt;
- .htaccess file to protect writable log folder;
2.2. Give write permittions to "log" folder for nagios user and protect htaccess file.
chown nagios:nagios -R /usr/local/nagios/sbin/telegram-notify/log/
chmod 775 -R /usr/local/nagios/sbin/telegram-notify/log/
chown root:root /usr/local/nagios/sbin/telegram-notify/log/.htaccess
chmod 644  /usr/local/nagios/sbin/telegram-notify/log/.htaccess
2.3. Now you can send test message from command line to see if everything is ok:
- login as nagios user: su - nagios.
- run script (example): php /usr/local/nagios/sbin/telegram-notify/telegram-bot.php "370022700" "83633434:kewkekekekdkkfiirrjririrjr" 1 "Notify: NOTIFICATIONTYPE 0XzXZ0 Host: HOSTNAME 0XzXZ0 Service: SERVICEDESC 0XzXZ0 Date: SHORTDATETIME 0XzXZ0 Info: SERVICEOUTPUT"
, where 
370022700 - telegram id of user who need to receive message;
83633434:kewkekekekdkkfiirrjririrjr - HTTP API key of your bot;
1 - mark. Script will send message if flag=1 only.
0XzXZ0 - fake linebreak character. I don't know why \n doesn't work :(

If test was successful go to the last part - configuring nagios.

3. Nagios configuration.
3.1. Define command:
# Telegram notifies.
# 'notify-service-telegram' command definition
# Telegram-bot: @bsnagiosbot
# 0XzXZ0 - line break character.
# Example: php /usr/local/nagios/sbin/telegram-notify/telegram-bot.php "370022700" "83633434:kewkekekekdkkfiirrjririrjr" 1 "Notify: NOTIFICATIONTYPE 0XzXZ0 Host: HOSTNAME 0XzXZ0 Service: SERVICEDESC 0XzXZ0 Date: SHORTDATETIME 0XzXZ0 Info: SERVICEOUTPUT"
define command{
	command_name	notify-service-telegram
	command_line	/usr/bin/php /usr/local/nagios/sbin/telegram-notify/telegram-bot.php "$_CONTACTTELEGRAM$" "83633434:kewkekekekdkkfiirrjririrjr" $_SERVICESENDTELEGRAM$ "Notify: $NOTIFICATIONTYPE$ 0XzXZ0 Hsot: $HOSTNAME$ 0XzXZ0 Service: $SERVICEDESC$ 0XzXZ0 Date: $SHORTDATETIME$ 0XzXZ0 Info: $SERVICEOUTPUT$"
	}

# 'notify-host-telegram' command definition
define command{
	command_name	notify-host-telegram
	command_line	 /usr/bin/php /usr/local/nagios/sbin/telegram-notify/telegram-bot.php "$_CONTACTTELEGRAM" "83633434:kewkekekekdkkfiirrjririrjr" $_HOSTSENDTELEGRAM$ "Notify: $NOTIFICATIONTYPE$ 0XzXZ0 Host: $HOSTNAME$ 0XzXZ0 Date: $SHORTDATETIME$ 0XzXZ0 Info: $HOSTOUTPUT$"
	}

3.2. Add notifying command to generic-contact template:
define contact{
        name                            generic-contact
	...
        service_notification_commands   notify-service-by-email-bs,notify-service-xml-sms,notify-service-skype,notify-service-telegram
        host_notification_commands      notify-host-by-email-bs,notify-host-xml-sms,notify-host-skype,notify-host-telegram
	...
        }

3.3. You can define _SENDTELEGRAM with value 1 to you host/services template OR create telegram-service and telegram-host templates which can be joined to your host/service. Variable _SENDTELEGRAM will be used as mark = 1 (see point 2.3). So only particular hosts/services will participate in telegram notifying.
define service{
         name   			telegram-service
         _SENDTELEGRAM 	1; 
        register                        0;
 }

define service{
         name   			telegram-host
         _SENDTELEGRAM 	1;
        register                        0;
 }

3.4. Define contact. Here we specify variable _telegram.
define contact{
        contact_name                    nagiosadmin	
	use				generic-contact
	...
	_telegram			370022700
	...
        }

4. Test and apply configurations and check whether everything works properly. Enjoy!
