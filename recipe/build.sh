#!/bin/bash

mkdir _build
pushd _build

# configure
cmake \
	${SRC_DIR} \
	${CMAKE_ARGS} \
	-DCMAKE_BUILD_TYPE:STRING=Release \
	-DBUILD_UNITTESTS:BOOL=TRUE \
	-DEXTERNAL_GTEST:BOOL=TRUE \
;

# build
cmake --build . --verbose --parallel ${CPU_COUNT}

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
ctest -V
fi

# install
cmake --build . --verbose --parallel ${CPU_COUNT} --target install
