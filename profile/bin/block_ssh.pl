#!/usr/bin/perl

#       及時封鎖使用 "暴入法" 入侵的使用者(SSH)
#       技術支援: http://www.vixual.net/

#==相關參數==

#記錄 ssh 連線的 LOG 檔，預設: /var/log/secure
$log_file = "/var/log/sshd/current";

#於多久的時間內嘗試登入(秒)，預設: 1 小時
$time_range = 1 * 60 * 60;

#於 $time_range 所設定的時間內，嘗試登入失敗多少次立即封鎖 IP，預設: 10 次
$drop_count = 2;

#寄件通知，預設收件者: root@localhost
$mail = 'root@localhost';

#寄件程式的位置
$sendmail = "/usr/sbin/sendmail";

#====

use Time::Local;

$ip = $ARGV[0];
$daemon = $ARGV[1];
$count = 0;

%month = (
	Jan	=>	0,
	Feb =>	1,
	Mar	=>	2,
	Apr	=>	3,
	May	=>	4,
	Jun	=>	5,
	Jul	=>	6,
	Aug	=>	7,
	Sep	=>	8,
	Oct	=>	9,
	Nov	=>	10,
	Dec	=>	11
);

$time = time();
($second,$minute,$hour,$day,$month,$year) = localtime($time);

#取得登入失敗的 log
echo $ip >>/tmp/ssh_ip.list
@list = `cat $log_file | grep $ip | grep -e "Authentication failure" -e "Invalid user"`;
for(my $i = $#list; $i >= 0; $i--){
	#取得 log 的時間
	my($log_month,$log_day,$log_time) = split(/ +/,$list[$i]);
	my($log_hour,$log_minute,$log_second) = split(/:/,$log_time);
	#前一年的記錄
	if($log_month > $month){
		$log_year = $year - 1;
	}else{
		$log_year = $year;
	}
	#將時間轉為秒數
	$log_time = timelocal($log_second,$log_minute,$log_hour,$log_day,$month{$log_month},$log_year);
	if($time < $log_time + $time_range ){
		$count++;
	}else{
		last;
	}
}

if($count > $drop_count){
	#封鎖 IP
	`iptables -A INPUT -p tcp -s $ip --dport 22 -j DROP`;
	if($mail){
		#寄件通知
		$hostname = `hostname`;
		$month++;
		$year += 1900;
		chomp($hostname);
		open(MAIL, "| $sendmail -t") || die "Can't open $sendmail !\n";
		print MAIL qq|To: $mail\n|;
		print MAIL qq|Subject: [$hostname]封鎖 $ip\n|;
		print MAIL qq|Content-Transfer-Encoding: 8bit\n|;
		print MAIL qq|Content-type: text/plain\; charset=Big5\n\n|;
		print MAIL "\n時間: $year-$month-$day $hour:$minute:$second\n----\n使用者 \"$ip\" 嘗試以 SSH 登入伺服器，共失敗 $count 次，已於防火牆封鎖該 IP。\n\n";
		print MAIL @list;
		close(MAIL);
	}
}

exit;

