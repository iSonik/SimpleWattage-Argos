#!/bin/bash

mV=$(tail /sys/class/power_supply/BAT0/device/power_supply/BAT*/voltage_now)
mA=$(tail /sys/class/power_supply/BAT0/device/power_supply/BAT*/current_now)
FDesign=$(tail /sys/class/power_supply/BAT0/device/power_supply/BAT*/charge_full_design)
FDesignnow=$(tail /sys/class/power_supply/BAT0/device/power_supply/BAT*/charge_full)
Status=$(tail /sys/class/power_supply/BAT*/device/power_supply/BAT0*/status)
Level=$(tail /sys/class/power_supply/BAT*/device/power_supply/BAT0*/capacity)
Health=$((($FDesign-$FDesignnow)/100))
Healthnow=$((($FDesignnow*100)/FDesign))
FDesign2=$(($FDesign / 1000))
Wattage=$(($mV*$mA))
Wh=$(($FDesignnow*$mV))


# Thanks to mmuman

if [ "$Wattage" = 0 ] && [ $Status = "Charging" ]; then
	echo "🕛 loading"	

else
	if [ "$Wattage" = 0 ] && [ $Status = "Discharging" ]; then
	echo "🕛 loading"
	else
	if [ "$Wattage" = 0 ] && [ $Status = "Full" ]; then
		echo "🔌"	
	else
		echo -n "⚡  " ;echo "scale=10; $Wattage/1000000000000" | bc | xargs printf "%.2fW\n";
fi
fi
fi
	echo ---
if [ "$Wattage" = 0 ] && [ $Status = "Full" ]; then
	echo "⚡ Power Info| size=12"
	echo -n "Voltage: ";echo "scale=10; $mV/1000000" | bc | xargs printf "%.3fV\n"
else
	echo "⚡ Power Info| size=12"

	echo -n "Voltage: ";echo "scale=10; $mV/1000000" | bc | xargs printf "%.3fV\n"
	echo -n "Ampere: ";echo "scale=10; $mA/1000000" | bc | xargs printf "%.3fA\n"	
fi

if [ $Status = "Charging" ]; then
	echo "🔌 Plugged in | color=yellow"
else
	if [ $Status = "Charging" ]; then
	echo "🔋On Battery | color=yellow"
	else
		if [ $Status = "Full" ]; then
		echo "🔌 Plugged in | color=yellow"
fi
fi
fi

echo ---
echo "🔋Battery Info| size=12"
echo "Battery Charge: $Level%" 
echo -n "Watt hours: "; echo "scale=3; $Wh/1000000000000" | bc | xargs printf "%.2fWh\n"

if [ "$Status" = Full ]; then
echo ""
else
echo -n "Battery time left: "; echo "scale=3; $Wh/$Wattage" | bc | xargs printf "%.2fh\n"	
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
