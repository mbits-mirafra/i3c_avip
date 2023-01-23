cd $1
make cli
xterm -T $1 -e vi transcript &
rm -rf work
cd ../../../..
