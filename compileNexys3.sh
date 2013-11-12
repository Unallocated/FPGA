#!/bin/bash

if [ $# != 1 ]; then
	echo "Usage: $0 <file_to_compile_without_extension>"
	exit
fi

./compile2.sh xc6slx16-csg324 3 nexys3.ucf $1
