if [ $# != 4 ]; then
	echo "Usage: $0 <chip> <speed-grade> <ucf-file> <vhd-to-compile>"
	exit
fi

CHIP=$1
SPEED=$2
UCF=$3
FILE=$4

export XILINX=/opt/Xilinx/14.6/ISE_DS/ISE
export XILINX_DSP=$XILINX
export PATH=${XILINX}/bin/lin64:${XILINX}/sysgen/util:${PATH}
#. /opt/Xilinx/14.6/ISE_DS/settings64.sh
xst -intstyle ise -ifn ${FILE}.xst -ofn "${FILE}.syr" && ngdbuild -intstyle ise -dd _ngo -sd ipcore_dir -nt timestamp -uc $UCF -p $CHIP-3 $FILE.ngc && map -intstyle ise -p ${CHIP}-${SPEED} -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -global_opt off -mt 2 -ir off -pr off -lc off -power off -o ${FILE}_map.ncd ${FILE}.ngd ${FILE}.pcf && par -w -intstyle ise -ol high -mt 4 ${FILE}_map.ncd ${FILE}.ncd ${FILE}.pcf && trce -intstyle ise -v 3 -s 3 -n 3 -fastpaths -xml ${FILE}.twx ${FILE}.ncd -o ${FILE}.twr ${FILE}.pcf -ucf $UCF && bitgen -intstyle ise -f ${FILE}.ut ${FILE}.ncd
