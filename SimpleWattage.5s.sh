#!/bin/bash

mV=$(tail /sys/class/power_supply/BAT*/voltage_now)
mA=$(tail /sys/class/power_supply/BAT*/current_now)



FDesign=$(tail /sys/class/power_supply/BAT*/charge_full_design)
FDesignnew=$(tail /sys/class/power_supply/BAT*/charge_full)
FDesignnow=$(tail /sys/class/power_supply/BAT*/charge_now)

Status=$(tail /sys/class/power_supply/BAT*/status)


Level=$(tail /sys/class/power_supply/BAT*/capacity)
Health=$((($FDesignnew)/1000))
Healthnow=$((($FDesignnew*100)/FDesign))
FDesign2=$(($FDesign / 1000))
FDesign3=$(($FDesignnow / 1000))

Wattage=$(($mV*$mA))
Wh=$(($FDesignnow*$mV))
Timeleft=$(($Wh / $Wattage))


if [ ! "$(ls -A /sys/class/power_supply/BAT0)" ]; then
echo "empty"
else
if [ "$Wattage" = 0 ] && [ $Status = "Charging" ]; then
	echo "🕛"	
	else
	if [ "$Wattage" = 0 ] && [ $Status = "Discharging" ]; then
	echo "🕛"
	else
		if [ "$Wattage" = 0 ] && [ $Status = "Full" ]; then
		echo "🔌"	
		else
		echo -n "⚡  " ;echo "scale=10; $Wattage/1000000000000" | bc | xargs printf "%.2fW\n";
fi
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


echo ---


# Battery Health Section
if [ "$Health" -lt "75" ]; then
	echo "♥️ Battery Vitals | size=12"

	echo Current Capacity: $FDesign3 mAh
	echo Rated Capacity: $FDesign2 mAh 
	echo "Actual Capacity: $Health mAh | color=red"
	echo "Battery Health: $Healthnow% | color=red"
	echo "Status: Your capacity is smaller than 75% ⚠️| color=red"
	echo 

else
	echo "♥️ Battery Vitals | size=12"
	echo Current Capacity: $FDesign3 mAh
	echo Rated Capacity: $FDesign2 mAh 
	echo Actual Capacity: $Health mAh
	echo Battery Health: $Healthnow%
	echo "Status: All is well 💚| color=green"
fi
