#speedfreq
#echo `cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq` Hz `cat /proc/acpi/thermal_zone/THRM/temperature`
func_status(){
  cd /sys/devices/system/cpu/cpu0/cpufreq/

  for aa in * ;do
    echo $aa: "$(<$aa)"
  done
  echo -
  cd /sys/devices/system/cpu/intel_pstate
  for aa in * ;do
    echo $aa: "$(<$aa)"
  done
}
func_turbo(){
  echo "performance">/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
  echo "balance_performance">/sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference
  echo "100">/sys/devices/system/cpu/intel_pstate/turbo_pct
}
func_save(){
  echo "powersave">/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
  echo "balance_power">/sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference
  echo "60">/sys/devices/system/cpu/intel_pstate/turbo_pct
}
eval func_$1
func_status

