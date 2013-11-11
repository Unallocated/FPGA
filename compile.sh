CHIP=$1
SPEED=$2
UCF=$3

xst -intstyle ise -ifn "/home/main/git/FPGA/cpu_instructor_copy.xst" -ofn "/home/main/git/FPGA/cpu_instructor_copy.syr" && ngdbuild -intstyle ise -dd _ngo -sd ipcore_dir -nt timestamp -uc $UCF -p $CHIP-3 cpu_instructor_copy.ngc && map -intstyle ise -p ${CHIP}-${SPEED} -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -global_opt off -mt 2 -ir off -pr off -lc off -power off -o cpu_instructor_copy_map.ncd cpu_instructor_copy.ngd cpu_instructor_copy.pcf && par -w -intstyle ise -ol high -mt 4 cpu_instructor_copy_map.ncd cpu_instructor_copy.ncd cpu_instructor_copy.pcf && trce -intstyle ise -v 3 -s 3 -n 3 -fastpaths -xml cpu_instructor_copy.twx cpu_instructor_copy.ncd -o cpu_instructor_copy.twr cpu_instructor_copy.pcf -ucf $UCF && bitgen -intstyle ise -f cpu_instructor_copy.ut cpu_instructor_copy.ncd
