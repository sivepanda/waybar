#!/bin/bash
#
# raw_clock=$(cat /sys/class/drm/card2/device/pp_dpm_sclk | egrep -o '[0-9]{0,4}Mhz \W' | sed "s/Mhz \*//")
# clock=$(echo "scale=1;$raw_clock/1000" | bc | sed -e 's/^-\./-0./' -e 's/^\./0./')
#
# raw_temp=$(cat /sys/class/drm/card2/device/hwmon/hwmon5/temp1_input)
# temperature=$(($raw_temp/1000))
# busypercent=$(cat /sys/class/hwmon/hwmon5/device/gpu_busy_percent)
# deviceinfo=$(glxinfo -B | grep 'Device:' | sed 's/^.*: //')
# driverinfo=$(glxinfo -B | grep "OpenGL version")
#
# echo '{"text": "'$clock'GHz |   '$temperature'°C <span color=\"darkgray\">| '$busypercent'%</span>", "class": "custom-gpu", "tooltip": "<b>'$deviceinfo'</b>\n'$driverinfo'"}'
#


# Get the current GPU clock (in MHz), then convert to GHz.
raw_clock=$(nvidia-smi --query-gpu=clocks.current.graphics --format=csv,noheader,nounits)
clock=$(echo "scale=1; $raw_clock / 1000" | bc)

# Get the GPU temperature (in °C)
temperature=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

# Get the GPU utilization percentage
busypercent=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

# Get the device (GPU model) information.
deviceinfo=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n1)

# Get the driver version information.
driverinfo=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -n1)

# Print JSON output similar to your original script.
echo '{"text": "'$clock'GHz |  '$temperature'°C <span color=\"darkgray\">| '$busypercent'%</span>", "class": "custom-gpu", "tooltip": "<b>'$deviceinfo'</b>\nDriver: '$driverinfo'"}'

