log_file=/var/log/roboshop.log
c0de_dir=$(pwd)
error_check() {
  if [ $? -lt 1 ];then
    echo -e "\e[32mSuccess\e[0m"
  else
    echo -e "\e[31mError occurred check $log_file \e[0m"
  fi
}
