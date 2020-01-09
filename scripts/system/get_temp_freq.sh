#!/bin/sh
 
echo "Temp, FreqCPU0, FreqCPU1, FreqCPU2, FreqCPU3, FreqCPU4, FreqCPU5, FreqCPU6, FreqCPU7 "
while true :
do
     t=`cat /sys/devices/virtual/thermal/thermal_zone0/temp`
     t1=$(echo "scale=2; $t/1000" | bc)
 
     f0=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
     f0_r=$(echo "scale=2;  $f0/1000000" | bc)
 
     f1=`cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq`
     f1_r=$(echo "scale=2;  $f1/1000000" | bc)

     f2=`cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_cur_freq`
     f2_r=$(echo "scale=2;  $f2/1000000" | bc)

     f3=`cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq`
     f3_r=$(echo "scale=2;  $f3/1000000" | bc)

     echo $t1, $f0_r, $f1_r, $f2_r, $f3_r
 
     sleep 2
done
