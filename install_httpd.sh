#!/bin/sh
#Make sure only root can run this script
if [ "$(id -u)" != "0" ];
	then
	echo "This script mast run as root" 1>&2
	exit 1
else
#install and config httpd

clear;
echo "#####################";
echo "#                   #";
echo "#    Apache2/httpd  #";
echo "#        Welcom     #";
echo "#                   #";
echo "#####################";
while true;
do 
	echo  "# 1 => Install web server and PHP ";
	echo  "# 2 => Change the port number ";
	#echo  "# 3 => Add a virtual name domain";
	echo  "# 4 => Status";
	echo  "# 5 => exit";
	read choix;
	case $choix in
      1 )  install=$(zenity --list --checklist --column "install" --column "technologie" FALSE "Apache2" FALSE "PHP" ) #FALSE "test your service" FALSE "choix 4") 
#instalation du apache  !!!	
		if [ "$install" == "Apache2" ];
		then
		#echo "Bonjour HTML server !!!";
		su -c 'yum install httpd-manual -y';
		su -lc 'systemctl start httpd.service';
		su -lc 'service httpd start';

	while true ;
	do
		echo "Do you want start Apache2 when you start your server in level 2,3 and 5 ? (yes / no)";
		read rep
		case $rep in
			y*|Y*|O*|o* ) su -lc 'systemctl enable httpd.service' ; break;;
			n*|N* ) echo "Don't forget to start Apache when you restart your server next time " ; break ;;
			* ) echo "repet please !!!"; break;;
		esac
	done
			touch /var/www/html/index.html ;
			chmod 775 /var/www/html/index.html ; 
			echo "</br><h1><center>Bonjour HTML !!!</center></h1>" >> /var/www/html/index.html ;
			firefox localhost/index.html ;
			
fi 
# installation du apache2 avec php !!!
if [ "$install" == "Apache2|PHP" ];
		then
		#echo "Bonjour HTML server !!!";
		su -c 'yum install httpd-manual -y ';
		#su -lc 'systemctl start httpd.service';
		su -lc 'service httpd start';

	while true ;
	do
		echo "Do you want start Apache2 when you start your server in level 2,3 and 5 ? (yes / no)";
		read rep
		case $rep in
			y*|Y* ) su -lc 'chkconfig --level 235 httpd on ' ; break;;
			n*|N* ) echo "Don't forget to start Apache when you restart your server next time " ; break ;;
			* ) echo "repet please !!!"; break;;
		esac
	done
			touch /var/www/html/index.html ;
			chmod 775 /var/www/html/index.html ; 
			echo "</br><h1><center>Bonjour HTML !!!</center></h1>" >> /var/www/html/index.html ;
			firefox localhost/index.html ;

			# start install PHP
		su -lc 'yum install -y php-cli';
	su -lc 'yum install -y php' ;
	su -lc 'yum install -y php-fpm';
	su -lc 'service php-fpm start';
	su -lc 'service httpd restart';
	touch /var/www/html/info.php ;
	chmod 775 /var/www/html/info.php ;
	echo "<?php phpinfo(); ?>" >> /var/www/html/info.php ;
	su -lc 'yum install -y php-cli lighttpd-fastcgi' ;
	touch /etc/lighttpd/conf.d/php.conf ;
	
	echo " server.modules += ( " mod_fastcgi " )

  fastcgi.server = ( ".php" =>
    (( "socket" => "/tmp/php-fastcgi.socket",
        "bin-path" => "/usr/bin/php-cgi" 
    ))
  ) " >> /etc/lighttpd/conf.d/php.conf ;

	su -lc 'service lighttpd restart' ;
	yum install -y php-sqlite3 ;
	firefox http://localhost/info.php ;
	su -lc 'service httpd reload'
		
fi

# installation du php sec

if [ "$install" == "PHP" ];
then
	su -lc 'yum install -y php-cli';
	su -lc 'yum install -y php' ;
	su -lc 'yum install -y php-fpm';
	su -lc 'service php-fpm start';
	su -lc 'service httpd restart';
	touch /var/www/html/info.php ;
	chmod 775 /var/www/html/info.php ;
	echo "<?php phpinfo(); ?>" >> /var/www/html/info.php ;
	su -lc 'yum install -y php-cli lighttpd-fastcgi' ;
	touch /etc/lighttpd/conf.d/php.conf ;
	
	echo " server.modules += ( " mod_fastcgi " )

  fastcgi.server = ( ".php" =>
    (( "socket" => "/tmp/php-fastcgi.socket",
        "bin-path" => "/usr/bin/php-cgi" 
    ))
  ) " >> /etc/lighttpd/conf.d/php.conf ;

	su -lc 'service lighttpd restart' ;
	yum install -y php-sqlite3 ;
	firefox http://localhost/info.php ;
	su -lc 'service httpd reload'     
fi 
;;
# configuration des serveur web & php !!!

      2 ) 	echo "what is the new number of (port) ?";
		read number;
		sed -i 's/80/'$number'/g' /etc/httpd/conf/httpd.conf ;
		grep $number /etc/httpd/conf/httpd.conf ;;

# test de l'état du serveur !!!

      4 ) while true; do 
		echo "";
		echo "# 1 => Stop your web server";
		echo "# 2 => Start your web server";
		echo "# 3 => Restart your web server";
		echo "# 4 => Status of web server";
		echo "# 5 => Know the version of your web server";
		echo "# 6 => Know the version of PHP ";
		echo "# R/r=>Rutern to the menu";
	
	read choix2;
		case $choix2 in
			1 ) service httpd stop  ;;
			2 ) service httpd start  ;;
			3 ) service httpd restart ;;
			4 ) systemctl status httpd.service  ;;
			5 ) httpd -v ;;
			6 ) php --version ;;
			* ) echo "can you insert your choix for your 2sd time"; break;;
			r* |R* ) exit ;;
		esac
	
		 done
		 ;;
     	4 ) service httpd status ;;
	5 ) echo " bye-bye "; exit 0  ;;
      	* )  echo "ni 1 ni 2 " ;;
esac
done 

fi
exit 0
