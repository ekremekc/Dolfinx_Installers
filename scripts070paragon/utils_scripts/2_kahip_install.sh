export UTILS_DIR=/home/ee331/Dev/Venvs/dolfinx_utils
export PATH=$UTILS_DIR/cmake/bin:$PATH
export OMPI=$UTILS_DIR/openmpi
export PATH=$OMPI/bin:$PATH
export LD_LIBRARY_PATH=$OMPI/lib:$LD_LIBRARY_PATH
export BUILD_NP=14

# source gcc
source gcc.sh

#set OMP variables
export KAHIP_VERSION=3.15

#install KaHIP
wget -nc --quiet https://github.com/kahip/kahip/archive/v${KAHIP_VERSION}.tar.gz 
tar -xf v${KAHIP_VERSION}.tar.gz 
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DNONATIVEOPTIMIZATIONS=on -DCMAKE_INSTALL_PREFIX=$UTILS_DIR/KaHIP -B build-dir -S KaHIP-${KAHIP_VERSION} 
cmake --build build-dir
cmake --install build-dir
rm -r build-dir

rm -r KaHIP-${KAHIP_VERSION}
rm v${KAHIP_VERSION}.tar.gz 

export KAHIP=$UTILS_DIR/installation/KaHIP
export PATH=$KAHIP/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KAHIP/lib
