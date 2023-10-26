export VENV_NAME=v070complex

python3 -m venv $VENV_NAME
cd $VENV_NAME && source bin/activate

#Set environmental variables
export VENV_DIR=/home/ee331/Dev/Venvs/$VENV_NAME

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

export ADIOS2=$UTILS_DIR/adios2
export PATH=$ADIOS2/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ADIOS2/lib

export BUILD_NP=14

# just for darcy, because it is installed in the directory 12.3, not 12.3.0
export gcc_ver=12.3
export PATH=/home/ee331/gcc-$gcc_ver/bin:$PATH
export LD_LIBRARY_PATH=$HOME/gcc-$gcc_ver/lib64:$LD_LIBRARY_PATH
export CC=/home/ee331/gcc-$gcc_ver/bin/gcc
export CXX=/home/ee331/gcc-$gcc_ver/bin/g++

export PYBIND11_VERSION=2.11.1
export NUMPY_VERSION=1.23.2

pip3 install --no-binary="numpy" --no-cache-dir numpy==${NUMPY_VERSION}
pip3 install gmsh

export INSTALL_DIR=$VENV_DIR/installation
mkdir -p ${INSTALL_DIR}
export PETSC_DIR=$INSTALL_DIR/petsc

# Install PETSC
export PETSC_SLEPC_OPTFLAGS="-O2"
export PETSC_SLEPC_MAKE_NP=14
export PETSC_SLEPC_DEBUGGING="no"
export PETSC_VERSION=3.20.0

mkdir -p ${PETSC_DIR} && cd ${PETSC_DIR}
git clone -b v${PETSC_VERSION}  https://gitlab.com/petsc/petsc.git ${PETSC_DIR}

# Complex, 32-bit int
python3 ./configure \
PETSC_ARCH=linux-gnu-complex-32 \
--COPTFLAGS="${PETSC_SLEPC_OPTFLAGS}" \
--CXXOPTFLAGS="${PETSC_SLEPC_OPTFLAGS}" \
--FOPTFLAGS="${PETSC_SLEPC_OPTFLAGS}" \
--with-make-np="${PETSC_SLEPC_MAKE_NP}" \
--with-64-bit-indices=no \
--with-debugging=${PETSC_SLEPC_DEBUGGING} \
--with-fortran-bindings=no \
--with-shared-libraries \
--download-metis \
--download-mumps \
--download-ptscotch \
--download-scalapack \
--download-suitesparse \
--with-scalar-type=complex 

make PETSC_DIR=$PETSC_DIR PETSC_ARCH=linux-gnu-complex-32 ${MAKEFLAGS} all

cd src/binding/petsc4py 
PETSC_ARCH=linux-gnu-complex-32 pip3 install --no-cache-dir --no-dependencies . 

pip3 install wheel
# Install SLEPc
export SLEPC_VERSION=3.20.0
export SLEPC_DIR=$INSTALL_DIR/slepc
mkdir -p ${SLEPC_DIR} 
git clone -b v${SLEPC_VERSION} https://gitlab.com/slepc/slepc.git ${SLEPC_DIR}
cd ${SLEPC_DIR} 
PETSC_ARCH=linux-gnu-complex-32 python3 ./configure 
make SLEPC_DIR=${SLEPC_DIR} PETSC_DIR=$PETSC_DIR PETSC_ARCH=linux-gnu-complex-32

# Install slepc4py
cd src/binding/slepc4py && \
PETSC_ARCH=linux-gnu-complex-32 pip3 install --no-cache-dir .

# INSTALL BASIX, FFC, UFL and IPYTHON
export REPO_DIR=$VENV_DIR/repos
mkdir -p ${REPO_DIR}  && cd $REPO_DIR
mkdir src && cd src

export BASIX_VERSION=v0.7.0
export DOLFINX_CMAKE_BUILD_TYPE="RelWithDebInfo"

git clone -b ${BASIX_VERSION} --single-branch https://github.com/FEniCS/basix.git
cd basix
cmake -G Ninja -D CMAKE_C_COMPILER=$CMAKE_C_COMPILER -D CMAKE_CXX_COMPILER=$CMAKE_CXX_COMPILER -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/basix -DCMAKE_BUILD_TYPE=${DOLFINX_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS=${DOLFINX_CMAKE_CXX_FLAGS} -B build-dir -S ./cpp

cmake --build build-dir
cmake --install build-dir
export CMAKE_PREFIX_PATH=$INSTALL_DIR/basix:$CMAKE_PREFIX_PATH
export Basix_DIR=$CMAKE_INSTALL_PREFIX/basix/lib/cmake/basix
python3 -m pip install --no-cache-dir ./python

cd ..
export UFL_VERSION=2023.2.0
git clone -b ${UFL_VERSION} --single-branch https://github.com/FEniCS/ufl.git
cd ufl
pip3 install --no-cache-dir .

cd ..
export FFCX_VERSION=v0.7.0
git clone -b ${FFCX_VERSION} --single-branch https://github.com/FEniCS/ffcx.git
cd ffcx
pip3 install --no-cache-dir .

cd ../ && pip3 install --no-cache-dir ipython

export CMAKE_PREFIX_PATH=$UTILS_DIR/pugixml/lib/cmake/pugixml:$CMAKE_PREFIX_PATH
export PYBIND11_VERSION=2.11.1
pip3 install --no-cache-dir --upgrade setuptools pip
pip3 install --no-cache-dir cffi mpi4py numba scipy
pip3 install --no-cache-dir cppimport flake8 isort jupytext matplotlib mypy myst-parser pybind11==${PYBIND11_VERSION}  pytest pytest-xdist sphinx sphinx_rtd_theme

# complex build
export DOLFINX_VERSION=v0.7.0
export DOLFINX_CMAKE_BUILD_TYPE="RelWithDebInfo"

git clone -b ${DOLFINX_VERSION} --single-branch https://github.com/FEniCS/dolfinx.git
cd dolfinx 
mkdir -p build-complex && cd build-complex
PETSC_ARCH=linux-gnu-complex-32 cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/dolfinx-complex -DCMAKE_BUILD_TYPE=${DOLFINX_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS=${DOLFINX_CMAKE_CXX_FLAGS} ../cpp
ninja install
cd ../python
export CMAKE_PREFIX_PATH=$INSTALL_DIR/dolfinx-complex:$CMAKE_PREFIX_PATH

CXXFLAGS=${DOLFINX_CMAKE_CXX_FLAGS} PETSC_ARCH=linux-gnu-complex-32 pip3 install --target $VENV_DIR/lib/python3.8/dist-packages --no-dependencies --no-cache-dir .
cd ../.. 

# Dolfinx_mpc
export DOLFINX_MPC_VERSION=v0.6.0
git clone -b ${DOLFINX_MPC_VERSION} --single-branch https://github.com/jorgensd/dolfinx_mpc.git
cd dolfinx_mpc 
mkdir -p build-dir 
PETSC_ARCH=linux-gnu-complex-32 cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/dolfinx_mpc -B build-dir -S ./cpp
cd build-dir
ninja install
export DOLFINX_MPC_DIR=$INSTALL_DIR/dolfinx_mpc
cd ../python
export CMAKE_PREFIX_PATH=$INSTALL_DIR/dolfinx-mpc:$CMAKE_PREFIX_PATH
CXXFLAGS=${DOLFINX_CMAKE_CXX_FLAGS} PETSC_ARCH=linux-gnu-complex-32 pip3 install --target $VENV_DIR/lib/python3.8/dist-packages --no-dependencies .

# install adios4dolfinx
export adios4dolfinx_VERSION=v0.7.1
git clone -b ${adios4dolfinx_VERSION} --single-branch https://github.com/jorgensd/adios4dolfinx.git
cd adios4dolfinx
pip3 install .
cd ..

# install pyvista
export PYVISTA_VERSION=0.42.2
pip3 install --no-cache-dir pyvista==${PYVISTA_VERSION}
pip3 install pythreejs meshio h5py geomdl geomdl.shapes pyevtk




