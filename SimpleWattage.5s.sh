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
		echo -n "⚡  " ;echo "scale=10; $Wattage/1000000000000" | bc | xargs printf "%.2f W\n";
fi
fi
fi
fi
echo ---
	echo "⚡ Power Info| size=12"
if [ "$Wattage" = 0 ] && [ $Status = "Full" ]; then

	echo -n "Voltage: ";echo "scale=10; $mV/1000000" | bc | xargs printf "%.3f V\n"
else

	echo -n "Voltage: ";echo "scale=10; $mV/1000000" | bc | xargs printf "%.3f V\n"
	echo -n "Ampere: ";echo "scale=10; $mA/1000000" | bc | xargs printf "%.3f A\n"	
fi



echo ---

echo "🔋Battery Info| size=12"
echo "Battery Charge: $Level%" 
echo -n "Watt hours: "; echo "scale=3; $Wh/1000000000000" | bc | xargs printf "%.2f Wh\n"

Yellow='\033[0;33m'
NC='\033[0m'

if [ $Status = "Full" ] && [ $Wattage = 0 ]; then
perl -pe chomp; echo -e "${Yellow}🔌 Plugged in"  | perl -pe chomp; printf "%02d\n" $hour | perl -pe chomp;
else
if [ $Status = "Discharging" ] && [ $Wattage != 0 ]; then

Timeleft=$(($Wh*10/$Wattage*10))
hour=$(($Wh/$Wattage))
h=$(($hour*100))
minu=$(($Timeleft-$h))
minut=$(($minu*60/100))
x
perl -pe chomp; echo -e "${Yellow}🔋 Battery Time: "  | perl -pe chomp; printf "%02d\n" $hour | perl -pe chomp; echo : | perl -pe chomp; printf "%02d\n" $minut 



else


echo $minute
echo $hours 
Designdif=$(($FDesignnew-$FDesignnow))
d1=$(($Designdif*100))
tc=$((($d1/$mA)))
tc1=$((($tc/100)*100))
tch=$(($tc/100))
tc2=$(($tc-$tc1))
tc3=$(($tc2*60/100))

perl -pe chomp; echo -e "${Yellow}🔌 Until Full: "  | perl -pe chomp; printf "%02d\n" $tch | perl -pe chomp; echo : | perl -pe chomp; printf "%02d\n" $tc3 



fi
fi


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
