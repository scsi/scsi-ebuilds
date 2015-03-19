#!/usr/bin/perl

#       �ήɫ���ϥ� "�ɤJ�k" �J�I���ϥΪ�(SSH)
#       �޳N�䴩: http://www.vixual.net/

#==�����Ѽ�==

#�O�� ssh �s�u�� LOG �ɡA�w�]: /var/log/secure
$log_file = "/var/log/sshd/current";

#��h�[���ɶ������յn�J(��)�A�w�]: 1 �p��
$time_range = 1 * 60 * 60;

#�� $time_range �ҳ]�w���ɶ����A���յn�J���Ѧh�֦��ߧY���� IP�A�w�]: 10 ��
$drop_count = 2;

#�H��q���A�w�]�����: root@localhost
$mail = 'root@localhost';

#�H��{������m
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

#���o�n�J���Ѫ� log
echo $ip >>/tmp/ssh_ip.list
@list = `cat $log_file | grep $ip | grep -e "Authentication failure" -e "Invalid user"`;
for(my $i = $#list; $i >= 0; $i--){
	#���o log ���ɶ�
	my($log_month,$log_day,$log_time) = split(/ +/,$list[$i]);
	my($log_hour,$log_minute,$log_second) = split(/:/,$log_time);
	#�e�@�~���O��
	if($log_month > $month){
		$log_year = $year - 1;
	}else{
		$log_year = $year;
	}
	#�N�ɶ��ର���
	$log_time = timelocal($log_second,$log_minute,$log_hour,$log_day,$month{$log_month},$log_year);
	if($time < $log_time + $time_range ){
		$count++;
	}else{
		last;
	}
}

if($count > $drop_count){
	#���� IP
	`iptables -A INPUT -p tcp -s $ip --dport 22 -j DROP`;
	if($mail){
		#�H��q��
		$hostname = `hostname`;
		$month++;
		$year += 1900;
		chomp($hostname);
		open(MAIL, "| $sendmail -t") || die "Can't open $sendmail !\n";
		print MAIL qq|To: $mail\n|;
		print MAIL qq|Subject: [$hostname]���� $ip\n|;
		print MAIL qq|Content-Transfer-Encoding: 8bit\n|;
		print MAIL qq|Content-type: text/plain\; charset=Big5\n\n|;
		print MAIL "\n�ɶ�: $year-$month-$day $hour:$minute:$second\n----\n�ϥΪ� \"$ip\" ���եH SSH �n�J���A���A�@���� $count ���A�w�󨾤������� IP�C\n\n";
		print MAIL @list;
		close(MAIL);
	}
}

exit;

