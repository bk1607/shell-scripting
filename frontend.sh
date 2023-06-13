source common.sh
print_head "Installing nginx "
yum install nginx -y &>> "${log_file}"
error_check

print_head "Removing default content"
rm -rf /usr/share/nginx/html/*  &>> "${log_file}"
error_check

print_head "Downloading frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>> "${log_file}"
error_check

print_head "Extracting frontend content"
cd /usr/share/nginx/html &>> "${log_file}"
unzip /tmp/frontend.zip &>> "${log_file}"
error_check

print_head "Reverse proxy configuration"
cp ${code_dir}/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> "${log_file}"
error_check

print_head "Enable and restart nginx service"
systemctl enable nginx &>> "${log_file}"
systemctl restart nginx &>> "${log_file}"
error_check
