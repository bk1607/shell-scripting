source common.sh
mysql_pass=$1
if [ -z mysql_pass ];then
  echo -e "\e[31mMissing password argument\e[0m"
  exit 1
fi
component=shipping
schema=mysql
maven