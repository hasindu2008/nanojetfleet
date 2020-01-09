if [ "$#" -ne 1 ]; then
    echo "useage : $0 script.sh"
        exit
fi

ansible all -m copy -a "src=$1 dest=/tmp/$1 mode=0744" 
ansible all -m shell -a "/tmp/$1" -K -b

