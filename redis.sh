source common.sh
print_head "Install redis repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> ${log_file}
error_check

print_head "Enable redis 6.2"
yum module enable redis:remi-6.2 -y &>> "${log_file}"
error_check

print_head "Install redis"
yum install redis -y &>> "${log_file}"
error_check

print_head "Update listen address"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>> "${log_file}"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>> "${log_file}"
error_check

print_head "Enable and start the service"
systemctl enable redis &>> "${log_file}"
systemctl start redis &>> "${log_file}"
error_check