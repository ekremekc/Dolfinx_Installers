# This script is prepared to install gcc 12.2 from source.
# Dolfinx uses cpp 20 so this compiler is necessary to build latest versions of dolfinx.

mkdir $HOME/gcc-install
cd $HOME/gcc-install
export gcc_ver=12.3.0 
wget -nc --quiet https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$gcc_ver/gcc-$gcc_ver.tar.gz
tar -xf gcc-$gcc_ver.tar.gz

export srcdir=$HOME/gcc-install/gcc-$gcc_ver
export objdir=$HOME/gcc-$gcc_ver

mkdir $objdir && cd $objdir

# configure and build gcc
$srcdir/configure --prefix=$objdir --disable-nls --enable-languages=c,c++,fortran --without-headers --enable-multilib
make -j 16
make install # This code will executed tomorrow

echo "Installation of gcc is complete"
echo "Now, we will link the libraries.."

# just for darcy, because it is installed in the directory 12.3, not 12.3.0
export gcc_ver=12.3.0
export PATH=/home/ee331/gcc-$gcc_ver/bin:$PATH
export LD_LIBRARY_PATH=$HOME/gcc-$gcc_ver/lib64:$LD_LIBRARY_PATH
export CC=/home/ee331/gcc-$gcc_ver/bin/gcc
export CXX=/home/ee331/gcc-$gcc_ver/bin/g++

echo "The gcc installed in system now has a version of;"
gcc -v
gfortran -v


