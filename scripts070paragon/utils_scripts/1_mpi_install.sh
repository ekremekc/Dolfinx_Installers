export UTILS_DIR=/home/ee331/Dev/Venvs/dolfinx_utils
export PATH=$UTILS_DIR/cmake/bin:$PATH
export BUILD_NP=14

# source gcc
source gcc.sh

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
cd ..

rm -r openmpi-${OPENMPI_SERIES}.${OPENMPI_PATCH}
rm openmpi-${OPENMPI_SERIES}.${OPENMPI_PATCH}.tar.gz