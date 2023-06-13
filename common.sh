log_file=/var/log/roboshop.log
code_dir=$(pwd)

print_head(){
  echo -e "\e[33m$1 \e[0m"
}
error_check() {
  if [ $? -eq 1 ];then
    echo "Success"
  else
    echo -e "\e[31mError occurred check $log_file \e[0m"
  fi
}
