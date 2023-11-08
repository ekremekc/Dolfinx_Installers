export UTILS_DIR=/home/ee331/Dev/Venvs/dolfinx_utils
export BUILD_NP=14

# source gcc
source gcc.sh

export CMAKE_VERSION=3.26.5
wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz
tar -zxvf cmake-$CMAKE_VERSION.tar.gz
cd cmake-$CMAKE_VERSION
./bootstrap --prefix=$UTILS_DIR/cmake
make -j$BUILD_NP
make install
cd ..

rm -r cmake-$CMAKE_VERSION
rm cmake-$CMAKE_VERSION.tar.gz 

#set environmental variables
export PATH=$UTILS_DIR/cmake/bin:$PATH