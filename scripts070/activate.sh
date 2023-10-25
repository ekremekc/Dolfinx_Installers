export VENV_DIR=/home/ekrem/Dev/Venvs/dolfinx_v070

source $VENV_DIR/bin/activate 

export OMPI=/$VENV_DIR/installation/openmpi
export PATH=$OMPI/bin:$PATH
export LD_LIBRARY_PATH=$OMPI/lib:$LD_LIBRARY_PATH
export OMP_NUM_THREADS=1

export KAHIP=$VENV_DIR/installation/KaHIP
export PATH=$KAHIP/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KAHIP/lib

#export HDF5=$VENV_DIR/installation/hdf5
#export PATH=$HDF5/bin:$PATH
#export LD_LIBRARY_PATH=$HDF5/lib:$LD_LIBRARY_PATH

export ADIOS2=$VENV_DIR/installation/adios2
export PATH=$ADIOS2/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ADIOS2/lib

# Activating complex mode
export PKG_CONFIG_PATH=$VENV_DIR/installation/dolfinx-complex/lib/pkgconfig:$PKG_CONFIG_PATH
export PETSC_ARCH=linux-gnu-complex-32 
export PYTHONPATH=$VENV_DIR/lib/python3.10/dist-packages:/usr/bin/python3:$PYTHONPATH
export LD_LIBRARY_PATH=$VENV_DIR/installation/lib:$LD_LIBRARY_PATH
