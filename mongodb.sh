source common.sh
print_head "setup mongodb repo file"
cp "${code_dir}"/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>> "${log_file}"
error_check

print_head "Install mongodb"
yum install mongodb-org -y &>> "${log_file}"
error_check

print_head "start and enable mongodb service"
systemctl enable mongod &>> "${log_file}"
systemctl start mongod &>> "${log_file}"

print_head "Updating listen address"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> "${log_file}"
error_check

print_head "restart mongod service"
systemctl restart mongod &>> "${log_file}"
error_check


