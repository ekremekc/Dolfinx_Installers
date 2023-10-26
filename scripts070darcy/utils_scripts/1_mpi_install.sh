export UTILS_DIR=/home/ee331/Dev/Venvs/dolfinx_utils
export PATH=$UTILS_DIR/cmake/bin:$PATH
export BUILD_NP=14

# just for darcy, because it is installed in the directory 12.3, not 12.3.0
export gcc_ver=12.3
export PATH=/home/ee331/gcc-$gcc_ver/bin:$PATH
export LD_LIBRARY_PATH=$HOME/gcc-$gcc_ver/lib64:$LD_LIBRARY_PATH
export CC=/home/ee331/gcc-$gcc_ver/bin/gcc
export CXX=/home/ee331/gcc-$gcc_ver/bin/g++

#set OMP variables
export OPENMPI_SERIES=4.1
export OPENMPI_PATCH=6

#install Openmpi
wget https://download.open-mpi.org/release/open-mpi/v${OPENMPI_SERIES}/openmpi-${OPENMPI_SERIES}.${OPENMPI_PATCH}.tar.gz
tar xfz openmpi-${OPENMPI_SERIES}.${OPENMPI_PATCH}.tar.gz
cd openmpi-${OPENMPI_SERIES}.${OPENMPI_PATCH}
 ./configure --prefix=$UTILS_DIR/openmpi
make -j${BUILD_NP} install

#ADD PATH OF MPIRUN 
export OMPI=$UTILS_DIR/openmpi
export PATH=$OMPI/bin:$PATH
export LD_LIBRARY_PATH=$OMPI/lib:$LD_LIBRARY_PATH
