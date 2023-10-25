sudo apt install python3.10-venv
export VENV_NAME=dolfinx_v070
python3 -m venv $VENV_NAME
cd $VENV_NAME && source bin/activate
source scripts/versions.sh

#install cmake first
sudo apt install cmake
# To install from source (if needed)
wget https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.20.0.tar.gz
tar -zxvf cmake-3.22.1.tar.gz
cd cmake-3.22.1
./bootstrap --prefix=$CMAKE_INSTALL_PREFIX/cmake
make -j2
make install


sudo apt-get -qq update && \
sudo apt-get -yq --with-new-pkgs -o Dpkg::Options::="--force-confold" upgrade && \
sudo apt-get -y install \
clang \
cmake \
g++ \
gfortran \
libboost-dev \
libboost-filesystem-dev \
libboost-timer-dev \
liblapack-dev \
libopenblas-dev \
libpugixml-dev \
ninja-build \
pkg-config \
python3-dev \
python3-pip \
python3-setuptools && \
#
sudo apt-get -y install \
catch2 \
clang-format \
doxygen \
git \
graphviz \
libeigen3-dev \
valgrind \
wget && \
#
sudo apt-get -y install \
libglu1 \
libxcursor-dev \
libxft2 \
libxinerama1 \
libfltk1.3-dev \
libfreetype6-dev  \
libgl1-mesa-dev \
libocct-foundation-dev \
libocct-data-exchange-dev && \
sudo apt-get clean

mkdir repos && mkdir installation
cd repos

# install openmpi
wget https://download.open-mpi.org/release/open-mpi/v${OPENMPI_SERIES}/openmpi-${OPENMPI_SERIES}.${OPENMPI_PATCH}.tar.gz
tar xfz openmpi-${OPENMPI_SERIES}.${OPENMPI_PATCH}.tar.gz
cd openmpi-${OPENMPI_SERIES}.${OPENMPI_PATCH}
./configure --prefix=$CMAKE_INSTALL_PREFIX/openmpi
make -j${BUILD_NP} install
cd ..

#ADD PATH OF MPIRUN 
export OMPI=$VENV_DIR/installation/openmpi
export PATH=$OMPI/bin:$PATH
export LD_LIBRARY_PATH=$OMPI/lib:$LD_LIBRARY_PATH

pip3 install --no-binary="numpy" --no-cache-dir cffi mpi4py numba numpy==${NUMPY_VERSION} scipy cython
pip3 install --no-cache-dir cppimport flake8 isort jupytext matplotlib mypy myst-parser pybind11==${PYBIND11_VERSION} pytest pytest-xdist sphinx sphinx_rtd_theme

# Install KaHIP
wget -nc --quiet https://github.com/kahip/kahip/archive/v${KAHIP_VERSION}.tar.gz 
tar -xf v${KAHIP_VERSION}.tar.gz 
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX/KaHIP -B build-dir -S KaHIP-${KAHIP_VERSION} 
cmake --build build-dir
cmake --install build-dir
rm -r build-dir

export KAHIP=$VENV_DIR/installation/KaHIP
export PATH=$KAHIP/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KAHIP/lib


# Install HDf5
wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_SERIES}/hdf5-${HDF5_SERIES}.${HDF5_PATCH}/src/hdf5-${HDF5_SERIES}.${HDF5_PATCH}.tar.gz
tar xfz hdf5-${HDF5_SERIES}.${HDF5_PATCH}.tar.gz
cd hdf5-${HDF5_SERIES}.${HDF5_PATCH} 
./configure --prefix=$CMAKE_INSTALL_PREFIX/hdf5 --enable-parallel --enable-shared --enable-static=no
make -j${BUILD_NP} install
cd ..

export HDF5=$VENV_DIR/installation/hdf5
export PATH=$HDF5/bin:$PATH
export LD_LIBRARY_PATH=$HDF5/lib:$LD_LIBRARY_PATH

# Install ADIOS2 (HDF PATH IS UPDATED IN ACTIVATE FILE!)
wget  https://github.com/ornladios/ADIOS2/archive/v${ADIOS2_VERSION}.tar.gz -O adios2-v${ADIOS2_VERSION}.tar.gz 
mkdir -p adios2-v${ADIOS2_VERSION} 
tar -xf adios2-v${ADIOS2_VERSION}.tar.gz -C adios2-v${ADIOS2_VERSION} --strip-components 1
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX/adios2 -DADIOS2_USE_HDF5=on -DADIOS2_USE_Fortran=off -DBUILD_TESTING=off -DADIOS2_BUILD_EXAMPLES=off -DADIOS2_USE_ZeroMQ=off -B build-dir -S ./adios2-v${ADIOS2_VERSION} 
cmake --build build-dir
cmake --install build-dir 
rm -r build-dir

export ADIOS2=$VENV_DIR/installation/adios2
export PATH=$ADIOS2/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ADIOS2/lib

#INSTALL GMSH
pip3 install gmsh

export PYTHONPATH=$VENV_DIR/lib:$PYTHONPATH

# INSTALL PETSC AND SLEPC

sudo apt-get -y install bison flex

git clone -b v${PETSC_VERSION}  https://gitlab.com/petsc/petsc.git ${PETSC_DIR}
cd ${PETSC_DIR}

# Complex, 32-bit int
python3 ./configure \
PETSC_ARCH=linux-gnu-complex-32 \
--COPTFLAGS="${PETSC_SLEPC_OPTFLAGS}" \
--CXXOPTFLAGS="${PETSC_SLEPC_OPTFLAGS}" \
--FOPTFLAGS="${PETSC_SLEPC_OPTFLAGS}" \
--with-64-bit-indices=no \
--with-debugging=${PETSC_SLEPC_DEBUGGING} \
--with-fortran-bindings=no \
--with-shared-libraries \
--download-metis \
--download-mumps \
--download-ptscotch \
--download-scalapack \
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

cd $INSTALL_DIR
# Install SLEPc
git clone -b v${SLEPC_VERSION} https://gitlab.com/slepc/slepc.git ${SLEPC_DIR}
cd ${SLEPC_DIR} 
export PETSC_ARCH=linux-gnu-complex-32 
python3 ./configure 
make 


# Install slepc4py
cd src/binding/slepc4py && \
PETSC_ARCH=linux-gnu-complex-32 pip3 install --no-cache-dir . && \
rm -rf ${SLEPC_DIR}/CTAGS ${SLEPC_DIR}/TAGS ${SLEPC_DIR}/docs ${SLEPC_DIR}/src/ ${SLEPC_DIR}/**/obj/ ${SLEPC_DIR}/**/test/ 


export BASIX_VERSION=v0.7.0
export UFL_VERSION=2023.2.0
export FFCX_VERSION=v0.7.0
export DOLFINX_VERSION=v0.7.0

# INSTALL BASIX, FFC, UFL and IPYTHON
cd $REPO_DIR
mkdir src && cd src

git clone -b ${BASIX_VERSION} --single-branch https://github.com/FEniCS/basix.git
cd basix
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX/basix -DCMAKE_BUILD_TYPE=${DOLFINX_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS=${DOLFINX_CMAKE_CXX_FLAGS} -B build-dir -S ./cpp
cmake --build build-dir
cmake --install build-dir
export CMAKE_PREFIX_PATH=$CMAKE_INSTALL_PREFIX/basix:$CMAKE_PREFIX_PATH
python3 -m pip install ./python

cd ..
git clone -b ${UFL_VERSION} --single-branch https://github.com/FEniCS/ufl.git
cd ufl
pip3 install --no-cache-dir  .

cd ..
git clone -b ${FFCX_VERSION} --single-branch https://github.com/FEniCS/ffcx.git
cd ffcx
pip3 install  --no-cache-dir .

cd ../ && pip3 install --no-cache-dir ipython

# complex build
git clone -b ${DOLFINX_VERSION} --single-branch https://github.com/FEniCS/dolfinx.git
cd dolfinx 
mkdir -p build-complex && cd build-complex
PETSC_ARCH=linux-gnu-complex-32 cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX/dolfinx-complex -DCMAKE_BUILD_TYPE=${DOLFINX_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS=${DOLFINX_CMAKE_CXX_FLAGS} ../cpp
ninja install
cd ../python
export CMAKE_PREFIX_PATH=$CMAKE_INSTALL_PREFIX/dolfinx-complex:$CMAKE_PREFIX_PATH
CXXFLAGS=${DOLFINX_CMAKE_CXX_FLAGS} PETSC_ARCH=linux-gnu-complex-32 pip3 install --target $VENV_DIR/lib/python3.10/dist-packages --no-dependencies .
cd ../
cd ../ 

export DOLFINX_MPC_VERSION=v0.6.1.post1

git clone -b $DOLFINX_MPC_VERSION --single-branch https://github.com/jorgensd/dolfinx_mpc.git
cd dolfinx_mpc 
mkdir -p build-dir 
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX/dolfinx_mpc -DCMAKE_BUILD_TYPE=${DOLFINX_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS=${DOLFINX_CMAKE_CXX_FLAGS} -B build-dir -S ./cpp
cd build-dir
ninja install
export DOLFINX_MPC_DIR=$CMAKE_INSTALL_PREFIX/dolfinx_mpc
cd ../python
export CMAKE_PREFIX_PATH=$CMAKE_INSTALL_PREFIX/dolfinx-mpc:$CMAKE_PREFIX_PATH
CXXFLAGS=${DOLFINX_CMAKE_CXX_FLAGS} PETSC_ARCH=linux-gnu-complex-32 pip3 install --target $VENV_DIR/lib/python3.10/dist-packages --no-dependencies .

# Install adios4dolfinx
export ADIOS4DOLFINX_VERSION=v0.7.1
git clone -b $ADIOS4DOLFINX_VERSION --single-branch https://github.com/jorgensd/adios4dolfinx.git
cd adios4dolfinx
pip3 install .

cd $SCRIPT_DIR

pip3 install pythreejs meshio h5py pyevtk geomdl geomdl.shapes

cd /home/ekrem/Dev
git clone https://github.com/ekremekc/Helmholtz-x.git
cd Helmholtz-x
pip3 install -e .


