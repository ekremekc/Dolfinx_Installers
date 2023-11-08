export UTILS_DIR=/home/ee331/Dev/Venvs/dolfinx_utils

export PATH=$UTILS_DIR/cmake/bin:$PATH

export OMPI=$UTILS_DIR/openmpi
export PATH=$OMPI/bin:$PATH
export LD_LIBRARY_PATH=$OMPI/lib:$LD_LIBRARY_PATH

export KAHIP=$UTILS_DIR/installation/KaHIP
export PATH=$KAHIP/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KAHIP/lib

export BUILD_NP=14

# source gcc
source gcc.sh

#set OMP variables
export HDF5_SERIES=1.14
export HDF5_PATCH=2

#install hdf5
wget -nc --quiet https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_SERIES}/hdf5-${HDF5_SERIES}.${HDF5_PATCH}/src/hdf5-${HDF5_SERIES}.${HDF5_PATCH}.tar.gz
tar xfz hdf5-${HDF5_SERIES}.${HDF5_PATCH}.tar.gz

cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$UTILS_DIR/hdf5 -DCMAKE_BUILD_TYPE=Release -DHDF5_ENABLE_PARALLEL=on -DHDF5_ENABLE_Z_LIB_SUPPORT=on -B build-dir -S hdf5-${HDF5_SERIES}.${HDF5_PATCH}
cmake --build build-dir
cmake --install build-dir
rm -r build-dir

rm -r hdf5-1.14.2
rm hdf5-1.14.2.tar.gz 

# HDF IS NOT INSTALLED TO THE INSTALLATION DIRECTORY,CHECK THAT - IT MAKES A PROBLEM DURING DOLFINX INSTALLATION
export HDF5=$UTILS_DIR/hdf5
export PATH=$HDF5/bin:$PATH
export LD_LIBRARY_PATH=$HDF5/lib:$LD_LIBRARY_PATH