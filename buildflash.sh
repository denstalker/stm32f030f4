#/bin/bash
mkdir build
cd build
cmake ..
cmake --build . -- -j4
openocd -f interface/jlink.cfg -f target/stm32f0x.cfg -c "program $1 verify reset exit"
cd ../
