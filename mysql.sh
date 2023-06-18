source common.sh

mysql_password=$1
if [ -z "${mysql_password}" ];then
  echo -e "\e[31mMissing password argument\e[0m"
  exit 1
fi

print_head "Disable mysql 8"
yum module disable mysql -y  &>> "${log_file}"
error_check

print_head "setup mysql repo file"
cp "${code_dir}"/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>> "${log_file}"
error_check

print_head "Install mysql server"
yum install mysql-community-server -y &>> "${log_file}"
error_check

print_head "start mysql service"
systemctl enable mysqld &>> "${log_file}"
systemctl start mysqld  &>> "${log_file}"
error_check

print_head "Set root password"
echo show databases | mysql -uroor -p"${mysql_password}" &>> "${log_file}"
if [ $? -ne 0 ]; then
  mysql_secure_installation --set-root-pass "${mysql_password}" &>> "${log_file}"
fi
error_check

