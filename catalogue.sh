source common.sh
print_head "setup nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> "${log_file}"
error_check

print_head "Installing nodejs"
yum install nodejs -y &>> "${log_file}"
error_check

