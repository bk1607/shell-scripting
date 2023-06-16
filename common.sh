log_file=/var/log/roboshop.log
code_dir=$(pwd)

print_head(){
  echo -e "\e[33m$1 \e[0m"
}

error_check() {
  if [ $? -eq 0 ];then
    echo "Success"
  else
    echo -e "\e[31mError occurred check $log_file \e[0m"
  fi
}

app_setup(){

  print_head "adding roboshop user"
  if ! id roboshop >/dev/null 2>&1; then
    useradd roboshop
  fi
  error_check

  print_head "Create app directory"
  if [ ! -d /app ]; then
    mkdir /app
  elif [ -d /app ]; then
    rm -rf /app/* &>> "${log_file}"
  fi
  error_check

  print_head "download application directory"
  curl -L -o /tmp/"${component}".zip https://roboshop-artifacts.s3.amazonaws.com/"${component}".zip &>> "${log_file}"
  error_check
  cd /app

  print_head "Extracting content"
  unzip /tmp/"${component}".zip &>> "${log_file}"
  error_check

  print_head "Download dependencies"
  cd /app
  npm install &>> "$log_file"
  error_check

}

systemd_setup(){
  print_head "copy service file"
  cp "${code_dir}"/configs/"${component}".service /etc/systemd/system/"${component}".service &>> ${log_file}
  error_check

  print_head "Daemon reload"
  systemctl daemon-reload &>> ${log_file}
  error_check

  print_head "Enable and start service "
  systemctl enable "${component}" &>> "${log_file}"
  systemctl start "${component}"
  error_check

}

schema_setup(){

  print_head "Setup Mongodb repo file"
  cp "${code_dir}"/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>> "${log_file}"
  error_check

  print_head "Installing mongodb"
  yum install mongodb-org-shell -y &>> "${log_file}"
  error_check

  print_head "Load schema"
  mongo --host 54.234.246.159 </app/schema/catalogue.js &>> "${log_file}"
  error_check

}

nodejs() {

  print_head "setup nodejs repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> "${log_file}"
  error_check

  print_head "Installing nodejs"
  yum install nodejs -y &>> "${log_file}"
  error_check

  app_setup

  systemd_setup

  schema_setup

}