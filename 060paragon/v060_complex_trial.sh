# This install script is written to install complex version of dolfinx 
# Before running this script, following libraries should be installed;
# 
# 1- gcc 12.2.0 - bin variables should be added to the path and 
#   export CC=/home/ee331/bin/gcc
#   export CXX=/home/ee331/bin/g++ 
#   need to be defined.
# 
# 2- cmake version should be greater than 3.20

export WORKING_DIR=$HOME/Dev/Venvs/Yeditepe
export VENV_NAME=v060_complex

mkdir -p $WORKING_DIR

export HDF5_SERIES=1.12
export HDF5_PATCH=2
export PYBIND11_VERSION=2.10.1
export PETSC_VERSION=3.17.2
export SLEPC_VERSION=3.17.1
export ADIOS2_VERSION=2.8.2
export PYVISTA_VERSION=0.37.0
export NUMPY_VERSION=1.23.3
export KAHIP_VERSION=3.14
export XTL_VERSION=0.7.4
export BASIX_VERSION=v0.6.0
export UFL_VERSION=2023.1.0
export FFCX_VERSION=v0.6.0
export DOLFINX_VERSION=v0.6.0
export DOLFINX_MPC_VERSION=v0.6.1

export MPICH_VERSION=4.0.2
export OPENMPI_SERIES=4.1
export OPENMPI_PATCH=4

export PETSC_SLEPC_OPTFLAGS="-O2"
# PETSc and SLEPc number of make processes (--with-make-np)
export PETSC_SLEPC_MAKE_NP=14
# Turn on PETSc and SLEPc debugging. "yes" or "no".
export PETSC_SLEPC_DEBUGGING="no"

# MPI variant. "mpich" or "openmpi".
export MPI="mpich"
export MPICH_CONFIGURE_OPTIONS="FCFLAGS=-fallow-argument-mismatch FFLAGS=-fallow-argument-mismatch --with-device=ch4:ofi"

# Number of build threads to use with make
export TOTAL_NP=$(nproc --all)
export DIVIDER=2
export BUILD_NP=$((TOTAL_NP / DIVIDER))

export OPENBLAS_NUM_THREADS=1 
export OPENBLAS_VERBOSE=0



export VENV_DIR=$WORKING_DIR/$VENV_NAME
export INSTALL_DIR=$VENV_DIR/installation
export PETSC_DIR=$VENV_DIR/installation/petsc 
export DOLFINX_CMAKE_BUILD_TYPE="RelWithDebInfo"

export SLEPC_DIR=$INSTALL_DIR/slepc
export ADIOS2_DIR=$INSTALL_DIR/adios2/cmake
export xtl_DIR=$INSTALL_DIR/xtl
export COMPLEX_PREFIX=$INSTALL_DIR/dolfinx-complex
export CMAKE_INSTALL_PREFIX=$INSTALL_DIR
export REPO_DIR=$VENV_DIR/repos
export SCRIPT_DIR=$VENV_DIR/scripts
export SRC_DIR=$REPO_DIR/src
export CMAKE_PREFIX_PATH=$INSTALL_DIR/basix:$CMAKE_PREFIX_PATH

export PYTHONPATH=$VENV_DIR/lib/python3.8

mkdir -p $REPO_DIR
mkdir -p $INSTALL_DIR
mkdir -p $SCRIPT_DIR

cd $WORKING_DIR

python3.8 -m venv $VENV_NAME
source $VENV_NAME/bin/activate


# Checking the cmake version
function version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }
export cmake_version=$(cmake --version | head -n1 | awk '{print $3}')
export cmake_version_required=3.19.9
if version_gt $cmake_version $cmake_version_required
then
     echo "$cmake_version is greater than $cmake_version_required !"
     echo "Installation of cmake can be skipped.."
else
    echo "cmake needs to be installed."
    cd $REPO_DIR
    wget https://github.com/Kitware/CMake/releases/download/v$cmake_version_required/cmake-$cmake_version_required.tar.gz
    tar -zxvf cmake-$cmake_version_required.tar.gz
    cd cmake-$cmake_version_required
    ./bootstrap --prefix=$CMAKE_INSTALL_PREFIX/cmake
    make -j$BUILD_NP
    make install
    
    echo "Cmake is installed now."
    export PATH=$CMAKE_INSTALL_PREFIX/cmake/bin:$PATH
fi


cd $VENV_DIR
cd $REPO_DIR

# install openmpi
wget https://download.open-mpi.org/release/open-mpi/v${OPENMPI_SERIES}/openmpi-${OPENMPI_SERIES}.${OPENMPI_PATCH}.tar.gz
tar xfz openmpi-${OPENMPI_SERIES}.${OPENMPI_PATCH}.tar.gz
cd openmpi-${OPENMPI_SERIES}.${OPENMPI_PATCH}
./configure --prefix=$CMAKE_INSTALL_PREFIX/openmpi
make -j${BUILD_NP} install

#ADD PATH OF MPIRUN 
export OMPI=$VENV_DIR/installation/openmpi
export PATH=$OMPI/bin:$PATH
export LD_LIBRARY_PATH=$OMPI/lib:$LD_LIBRARY_PATH

pip3 install --no-binary="numpy" --no-cache-dir cffi mpi4py numba numpy==${NUMPY_VERSION} scipy
pip3 install --no-cache-dir cppimport flake8 isort jupytext matplotlib mypy myst-parser pybind11==${PYBIND11_VERSION} pytest pytest-xdist sphinx sphinx_rtd_theme

cd $REPO_DIR
# Install KaHIP
wget -nc --quiet https://github.com/kahip/kahip/archive/v${KAHIP_VERSION}.tar.gz 
tar -xf v${KAHIP_VERSION}.tar.gz 
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DNONATIVEOPTIMIZATIONS=on -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX/KaHIP -B build-dir -S KaHIP-${KAHIP_VERSION} 
cmake --build build-dir
cmake --install build-dir
rm -r build-dir

export KAHIP=$VENV_DIR/installation/KaHIP
export PATH=$KAHIP/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KAHIP/lib

cd $REPO_DIR
# Install HDf5
wget -nc --quiet https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_SERIES}/hdf5-${HDF5_SERIES}.${HDF5_PATCH}/src/hdf5-${HDF5_SERIES}.${HDF5_PATCH}.tar.gz
tar xfz hdf5-${HDF5_SERIES}.${HDF5_PATCH}.tar.gz
cd hdf5-${HDF5_SERIES}.${HDF5_PATCH} 
./configure --prefix=$CMAKE_INSTALL_PREFIX/hdf5 --enable-parallel --enable-shared --enable-static=no
make -j${BUILD_NP} install
cd ..

export HDF5=$VENV_DIR/installation/hdf5
export PATH=$HDF5/bin:$PATH
export LD_LIBRARY_PATH=$HDF5/lib:$LD_LIBRARY_PATH
cd $REPO_DIR

# Install ADIOS2 (HDF PATH IS UPDATED IN ACTIVATE FILE!)
wget -nc --quiet https://github.com/ornladios/ADIOS2/archive/v${ADIOS2_VERSION}.tar.gz -O adios2-v${ADIOS2_VERSION}.tar.gz 
mkdir -p adios2-v${ADIOS2_VERSION} 
tar -xf adios2-v${ADIOS2_VERSION}.tar.gz -C adios2-v${ADIOS2_VERSION} --strip-components 1
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX/adios2 -DADIOS2_USE_HDF5=on -DADIOS2_USE_Fortran=off -DBUILD_TESTING=off -DADIOS2_BUILD_EXAMPLES=off -DADIOS2_USE_ZeroMQ=off -B build-dir -S ./adios2-v${ADIOS2_VERSION} 
cmake --build build-dir
cmake --install build-dir 
rm -r build-dir

export ADIOS2=$VENV_DIR/installation/adios2
export PATH=$ADIOS2/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ADIOS2/lib
cd $REPO_DIR

#INSTALL GMSH
pip3 install gmsh

export PYTHONPATH=$VENV_DIR/lib:$PYTHONPATH

# INSTALL PETSC AND SLEPC

wget -nc --quiet http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-${PETSC_VERSION}.tar.gz -O petsc-${PETSC_VERSION}.tar.gz
mkdir -p ${PETSC_DIR} && tar -xf petsc-${PETSC_VERSION}.tar.gz -C ${PETSC_DIR} --strip-components 1
cd ${PETSC_DIR}


# Complex, 32-bit int
python3 ./configure \
PETSC_ARCH=linux-gnu-complex-32 \
--COPTFLAGS="${PETSC_SLEPC_OPTFLAGS}" \
--CXXOPTFLAGS="${PETSC_SLEPC_OPTFLAGS}" \
--FOPTFLAGS="${PETSC_SLEPC_OPTFLAGS}" \
--with-make-np=${PETSC_SLEPC_MAKE_NP} \
--with-64-bit-indices=no \
--with-debugging=${PETSC_SLEPC_DEBUGGING} \
--with-fortran-bindings=no \
--with-shared-libraries \
--download-hypre \
--download-metis \
--download-mumps \
--download-ptscotch \
--download-scalapack \
--download-suitesparse \
--download-superlu \
--download-superlu_dist \
--with-scalar-type=complex 

make PETSC_DIR=$PETSC_DIR PETSC_ARCH=linux-gnu-complex-32 ${MAKEFLAGS} all

# Install petsc4py
cd src/binding/petsc4py 
PETSC_ARCH=linux-gnu-complex-32 pip3 install --no-cache-dir . 

rm -rf \
${PETSC_DIR}/**/tests/ \
${PETSC_DIR}/**/obj/ \
${PETSC_DIR}/**/externalpackages/  \
${PETSC_DIR}/CTAGS \
${PETSC_DIR}/RDict.log \
${PETSC_DIR}/TAGS \
${PETSC_DIR}/docs/ \
${PETSC_DIR}/share/ \
${PETSC_DIR}/src/ \
${PETSC_DIR}/systems/ 

cd $REPO_DIR

# Install SLEPc
wget -nc --quiet https://gitlab.com/slepc/slepc/-/archive/v${SLEPC_VERSION}/slepc-v${SLEPC_VERSION}.tar.gz
mkdir -p ${SLEPC_DIR} && tar -xf slepc-v${SLEPC_VERSION}.tar.gz -C ${SLEPC_DIR} --strip-components 1 
cd ${SLEPC_DIR} 
export PETSC_ARCH=linux-gnu-complex-32 
python3 ./configure 
make 


# Install slepc4py
cd src/binding/slepc4py && \
PETSC_ARCH=linux-gnu-complex-32 pip3 install --no-cache-dir . && \
rm -rf ${SLEPC_DIR}/CTAGS ${SLEPC_DIR}/TAGS ${SLEPC_DIR}/docs ${SLEPC_DIR}/src/ ${SLEPC_DIR}/**/obj/ ${SLEPC_DIR}/**/test/ && \

cd $REPO_DIR

# INSTALL BASIX, FFC, UFL and IPYTHON

# Install basix
cd $SRC_DIR
git clone -b ${BASIX_VERSION} --single-branch https://github.com/FEniCS/basix.git
cd basix
cmake -G Ninja -D CMAKE_C_COMPILER=$CMAKE_C_COMPILER -D CMAKE_CXX_COMPILER=$CMAKE_CXX_COMPILER -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX/basix -DCMAKE_BUILD_TYPE=${DOLFINX_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS=${DOLFINX_CMAKE_CXX_FLAGS} -B build-dir -S ./cpp

cmake --build build-dir
cmake --install build-dir
export CMAKE_PREFIX_PATH=$CMAKE_INSTALL_PREFIX/basix:$CMAKE_PREFIX_PATH
pip3 install --upgrade pip
python3 -m pip install --no-cache-dir ./python

cd $SRC_DIR

# Install UFL
git clone -b ${UFL_VERSION} --single-branch https://github.com/FEniCS/ufl.git
cd ufl
pip3 install --no-cache-dir .
cd $SRC_DIR

# Install FFCX
git clone -b ${FFCX_VERSION} --single-branch https://github.com/FEniCS/ffcx.git
cd ffcx
pip3 install --no-cache-dir .
cd $SRC_DIR

# Install iPython
pip3 install --no-cache-dir ipython

# Install pugixml
wget -nc --quiet http://github.com/zeux/pugixml/releases/download/v1.13/pugixml-1.13.tar.gz
tar xfz pugixml-1.13.tar.gz
cd pugixml-1.13
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX/pugixml ../
ninja install
export CMAKE_PREFIX_PATH=$CMAKE_INSTALL_PREFIX/pugixml/lib/cmake/pugixml:$CMAKE_PREFIX_PATH
cd $SRC_DIR

# Install complex dolfinx 
git clone -b ${DOLFINX_VERSION} --single-branch https://github.com/FEniCS/dolfinx.git
cd dolfinx 
mkdir -p build-complex && cd build-complex
PETSC_ARCH=linux-gnu-complex-32 cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX/dolfinx-complex -DCMAKE_BUILD_TYPE=${DOLFINX_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS=${DOLFINX_CMAKE_CXX_FLAGS} ../cpp
ninja install
cd ../python
export CMAKE_PREFIX_PATH=$CMAKE_INSTALL_PREFIX/dolfinx-complex:$CMAKE_PREFIX_PATH

CXXFLAGS=${DOLFINX_CMAKE_CXX_FLAGS} PETSC_ARCH=linux-gnu-complex-32 pip3 install --target $VENV_DIR/lib/python3.8/dist-packages --no-dependencies --no-cache-dir .
cd $SRC_DIR

# Install dolfinx_mpc
export DOLFINX_DIR=$CMAKE_INSTALL_PREFIX/dolfinx-complex

git clone -b ${DOLFINX_MPC_VERSION} --single-branch https://github.com/jorgensd/dolfinx_mpc.git
cd dolfinx_mpc 
mkdir -p build-dir 
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX/dolfinx_mpc -DCMAKE_BUILD_TYPE=${DOLFINX_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS=${DOLFINX_CMAKE_CXX_FLAGS} -B build-dir -S ./cpp
cd build-dir
ninja install
export DOLFINX_MPC_DIR=$CMAKE_INSTALL_PREFIX/dolfinx_mpc
cd ../python
export CMAKE_PREFIX_PATH=$CMAKE_INSTALL_PREFIX/dolfinx-mpc:$CMAKE_PREFIX_PATH
CXXFLAGS=${DOLFINX_CMAKE_CXX_FLAGS} PETSC_ARCH=linux-gnu-complex-32 pip3 install --target $VENV_DIR/lib/python3.8/dist-packages --no-dependencies .
cd $SRC_DIR

# Install some dependencies, pyvista, meshio, h5py
pip3 install --no-cache-dir pyvista==${PYVISTA_VERSION}
pip3 install pythreejs
pip3 install meshio
pip3 install h5py













