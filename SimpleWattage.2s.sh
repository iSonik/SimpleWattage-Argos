#!/bin/bash




mV=$(tail /sys/class/power_supply/BAT0/device/power_supply/BAT0/voltage_now)
mA=$(tail /sys/class/power_supply/BAT0/device/power_supply/BAT0/current_now)
FDesign=$(tail /sys/class/power_supply/BAT0/device/power_supply/BAT0/charge_full_design)
FDesignnow=$(tail /sys/class/power_supply/BAT0/device/power_supply/BAT0/charge_full)
Health=$((($FDesign-$FDesignnow)/100))
Healthnow=$((($FDesignnow*100)/FDesign))
FDesign2=$(($FDesign / 1000))
Wattage=$(($mV*$mA))
Status=$(tail /sys/class/power_supply/BAT0/device/power_supply/BAT0/status)

# Thanks to mmuman
if [ "$Wattage" = 0 ]; then
	echo "🕛 loading"	

else
	if [ "$Wattage" = 0 ] && [ $Status = "Charging" ]; then
		echo "🔌 Charging"	
	else
		echo -n "⚡  " ;echo "scale=10; $Wattage/1000000000000" | bc | xargs printf "%.2fW\n";
fi
fi
	echo ---
if [ "$Wattage" = 0 ] && [ $Status = "Charging" ]; then
	echo "⚡ Power Info| size=12"
else
	echo "⚡ Power Info| size=12"
	echo -n "Voltage: ";echo "scale=10; $mV/1000000" | bc | xargs printf "%.3fV\n"
	echo -n "Ampere: ";echo "scale=10; $mA/1000000" | bc | xargs printf "%.3fA\n"	
fi

if [ $Status = "Charging" ]; then
	echo "🔌 Plugged in | color=yellow"
else
	echo "🔋On Battery | color=yellow"
fi




echo ---


# Battery Health Section
if [ "$Health" -lt "75" ]; then
	echo "♥️ Battery Vitals | size=12"
	echo "Battery Health: $Healthnow% | color=red"
	echo Rated Capacity: $FDesign2 mAh 
	echo Current Capacity: $Health mAh
	echo "Status: Your capacity is smaller than 75% ⚠️| color=red"
	echo 

else
	echo "♥️ Battery Vitals | size=12"
	echo Battery Health: $Healthnow%
	echo Rated Capacity: $FDesign2 mAh 
	echo Current Capacity: $Health mAh
	echo "Status: All is well 💚| color=green"
fi
