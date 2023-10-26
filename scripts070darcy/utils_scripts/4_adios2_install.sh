export UTILS_DIR=/home/ee331/Dev/Venvs/dolfinx_utils

export PATH=$UTILS_DIR/cmake/bin:$PATH

export OMPI=$UTILS_DIR/openmpi
export PATH=$OMPI/bin:$PATH
export LD_LIBRARY_PATH=$OMPI/lib:$LD_LIBRARY_PATH

export KAHIP=$UTILS_DIR/KaHIP
export PATH=$KAHIP/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KAHIP/lib

export HDF5=$UTILS_DIR/hdf5
export PATH=$HDF5/bin:$PATH
export LD_LIBRARY_PATH=$HDF5/lib:$LD_LIBRARY_PATH

export BUILD_NP=14

# just for darcy, because it is installed in the directory 12.3, not 12.3.0
export gcc_ver=12.3
export PATH=/home/ee331/gcc-$gcc_ver/bin:$PATH
export LD_LIBRARY_PATH=$HOME/gcc-$gcc_ver/lib64:$LD_LIBRARY_PATH
export CC=/home/ee331/gcc-$gcc_ver/bin/gcc
export CXX=/home/ee331/gcc-$gcc_ver/bin/g++

#set Adios2 variables
export ADIOS2_VERSION=2.9.1

#install adios2
wget -nc --quiet https://github.com/ornladios/ADIOS2/archive/v${ADIOS2_VERSION}.tar.gz -O adios2-v${ADIOS2_VERSION}.tar.gz 
mkdir -p adios2-v${ADIOS2_VERSION} 
tar -xf adios2-v${ADIOS2_VERSION}.tar.gz -C adios2-v${ADIOS2_VERSION} --strip-components 1
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$UTILS_DIR/adios2 -DADIOS2_USE_HDF5=on -DADIOS2_USE_Fortran=off -DADIOS2_USE_Python=ON -DBUILD_TESTING=off -DADIOS2_BUILD_EXAMPLES=off -DADIOS2_USE_ZeroMQ=off -B build-dir -S ./adios2-v${ADIOS2_VERSION} 
cmake --build build-dir
cmake --install build-dir 
rm -r build-dir

rm -r adios2-v${ADIOS2_VERSION}
rm adios2-v${ADIOS2_VERSION}.tar.gz


# HDF IS NOT INSTALLED TO THE INSTALLATION DIRECTORY,CHECK THAT - IT MAKES A PROBLEM DURING DOLFINX INSTALLATION
export ADIOS2=$UTILS_DIR/adios2
export PATH=$ADIOS2/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ADIOS2/lib

export PYTHONPATH=/home/ee331/Dev/Venvs/dolfinx_utils/adios2/home/ee331/Dev/Venvs/v070complex/lib/python3.8/site-packages/adios2:PYTHONPATH
