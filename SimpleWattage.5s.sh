#!/bin/bash



Wattage=0
infos=""
for b in /sys/class/power_supply/BAT*; do
	read mV < "$b/device/power_supply/${b##*/}/voltage_now"
	mA=0
	if [ -e "$b/device/power_supply/${b##*/}/current_now" ]; then
		read mA < "$b/device/power_supply/${b##*/}/current_now"
	fi
	Wattage=$(($Wattage + $mV*$mA))

infos="$infos
${b##*/}:
Voltage: $(echo "scale=10; $mV/1000000" | bc | xargs printf "%.3f V\n")
Current: $(echo "scale=10; $mA/1000000" | bc | xargs printf "%.3f A\n")
"
done

echo "scale=10; $Wattage/1000000000000" | bc | xargs printf "🗲%.2fW\n";
echo ---

echo "More Information"
echo "$infos"
