source common.sh

rabbitmq_pass=$1
user_name=roboshop
if [ -z "${rabbitmq_pass}" ];then
  echo -e "\e[31mMissing password argument\e[0m"
  exit 1
fi

print_head "configure yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> "${log_file}"
error_check

print_head "Configure yum repos for rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> "${log_file}"
error_check

print_head "Install rabbitmq"
yum install rabbitmq-server -y &>> "${log_file}"
error_check

print_head "Start rabbitmq service"
systemctl enable rabbitmq-server &>> "${log_file}"
systemctl start rabbitmq-server  &>> "${log_file}"
error_check

print_head "add user"
rabbitmqctl list_users | grep "${user_name}" &>> "${log_file}"
if [ $? -ne 0 ];then
  rabbitmqctl add_user "${user_name}" "${rabbitmq_pass}" &>> "${log_file}"
fi
error_check

print_head "set permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> "${log_file}"
error_check
