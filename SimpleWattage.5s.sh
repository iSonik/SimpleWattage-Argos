#!/bin/bash

mV=$(tail /sys/class/power_supply/BAT0/device/power_supply/BAT0/voltage_now)
mA=$(tail /sys/class/power_supply/BAT0/device/power_supply/BAT0/current_now)

Wattage=$(($mV*$mA))

	echo -n "W: ";echo "scale=10; $Wattage/1000000000000" | bc | xargs printf "%.2f\n"; 
	echo ---

	echo "More Information"
	echo -n "Voltage: ";echo "scale=10; $mV/1000000" | bc | xargs printf "%.3f\n"
	echo -n "Ampere: ";echo "scale=10; $mA/1000000" | bc | xargs printf "%.3f\n"

	echo -n "W: ";echo "scale=10; $Wattage/1000000000000" | bc | xargs printf "%.2f\n"; 
	
done
