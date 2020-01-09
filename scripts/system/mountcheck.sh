ansible all -m shell -a "df -h | grep scratch_nas"
echo "__________________________________________________________"
ansible all -m shell -a "df -h | grep mnt"

