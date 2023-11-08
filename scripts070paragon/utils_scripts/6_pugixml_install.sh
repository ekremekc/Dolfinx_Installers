export UTILS_DIR=/home/ee331/Dev/Venvs/dolfinx_utils

wget -np --quiet https://github.com/zeux/pugixml/releases/download/v1.14/pugixml-1.14.tar.gz -O pugixml-v1.14.tar.gz
tar xfz pugixml-v1.14.tar.gz
cd pugixml-1.14
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$UTILS_DIR/pugixml .
ninja install
export CMAKE_PREFIX_PATH=$UTILS_DIR/pugixml/lib/cmake/pugixml:$CMAKE_PREFIX_PATH
cd ..

rm -r pugixml-1.14
rm pugixml-v1.14.tar.gz
