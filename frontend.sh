echo -e "\e[33mInstalling nginx \e[0m"
yum install nginx -y &> /var/log/roboshop.log
if [ $? -lt 1 ];then
  echo -e "\e[32mSuccess\e[0m"
else
  echo -e "\e[31mError occurred check /var/log/roboshop.log file\e[0m"
fi
