source common.sh
echo -e "\e[33mInstalling nginx \e[0m"
yum install nginx -y &> "$log_file"
error_check

echo -e "\e[33mRemoving default content\e[0m"
rm -rf /usr/share/nginx/html/*  &> "${log_file}"
error_check

echo -e "\e[33mDownloading frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &> "${log_file}"
error_check

echo -e "\e[33mExtracting frontend content\e[0m"
cd /usr/share/nginx/html &>"${log_file}"
unzip /tmp/frontend.zip &>"${log_file}"
error_check

echo -e "\e[33mReverse proxy configuration\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &> "${log_file}"
error_check

echo -e "\e[33mEnable and restart nginx service\e[0m"
systemctl enable nginx &> "${log_file}"
systemctl restart nginx &> "${log_file}"
error_check

echo "log file: '$log_file'"