export UTILS_DIR=/home/ee331/Dev/Venvs/dolfinx_utils
export BUILD_NP=14
# just for darcy, because it is installed in the directory 12.3, not 12.3.0
export gcc_ver=12.3
export PATH=/home/ee331/gcc-$gcc_ver/bin:$PATH
export LD_LIBRARY_PATH=$HOME/gcc-$gcc_ver/lib64:$LD_LIBRARY_PATH
export CC=/home/ee331/gcc-$gcc_ver/bin/gcc
export CXX=/home/ee331/gcc-$gcc_ver/bin/g++

export CMAKE_VERSION=3.26.5
wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz
tar -zxvf cmake-$CMAKE_VERSION.tar.gz
cd cmake-$CMAKE_VERSION
./bootstrap --prefix=$UTILS_DIR/cmake
make -j$BUILD_NP
make install
cd ..

#set environmental variables
export PATH=$UTILS_DIR/cmake/bin:$PATH

