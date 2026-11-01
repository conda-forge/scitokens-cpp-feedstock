#!/bin/bash
set -euxo pipefail

mkdir _build
pushd _build

# configure
cmake \
	${SRC_DIR} \
	${CMAKE_ARGS} \
	-DCMAKE_BUILD_TYPE:STRING=Release \
	-DSCITOKENS_BUILD_UNITTESTS:BOOL=TRUE \
	-DSCITOKENS_EXTERNAL_GTEST:BOOL=TRUE \
;

# build
cmake --build . --verbose --parallel ${CPU_COUNT}

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
	ctest --output-on-failure --no-tests=error --parallel ${CPU_COUNT}
fi

# install
cmake --build . --verbose --parallel ${CPU_COUNT} --target install
