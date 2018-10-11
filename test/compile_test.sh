#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testCompile()
{
  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertEquals 0 ${rtrn}
  assertEquals "" "`cat ${STD_ERR}`"

  assertContains "-----> Downloading jemalloc-5.1.0"  "`cat ${STD_OUT}`"
  assertTrue "Should have cached jemalloc `ls -la ${CACHE_DIR}`" "[ -f ${CACHE_DIR}/jemalloc-5.1.0.tar.bz2 ]"

  assertFileMD5 "ad534cd9ca266f833d4c6cac2b0af4c9" "${CACHE_DIR}/jemalloc-5.1.0.tar.bz2"

  assertContains "-----> Installing jemalloc"  "`cat ${STD_OUT}`"
  assertTrue "Should have installed bin/jemalloc.sh in build dir: `ls -la ${BUILD_DIR}`" "[ -f ${BUILD_DIR}/vendor/jemalloc/bin/jemalloc.sh ]"
  assertTrue "Should have installed bin/jemalloc-config in build dir: `ls -la ${BUILD_DIR}`" "[ -f ${BUILD_DIR}/vendor/jemalloc/bin/jemalloc-config ]"
  assertTrue "Should have installed bin/jeprof in build dir: `ls -la ${BUILD_DIR}`" "[ -f ${BUILD_DIR}/vendor/jemalloc/bin/jeprof ]"
  assertTrue "Should have installed lib/libjemalloc.so in build dir: `ls -la ${BUILD_DIR}`" "[ -f ${BUILD_DIR}/vendor/jemalloc/lib/libjemalloc.so ]"
  assertTrue "Should have installed lib/libjemalloc.so.2 in build dir: `ls -la ${BUILD_DIR}`" "[ -f ${BUILD_DIR}/vendor/jemalloc/lib/libjemalloc.so.2 ]"

  assertContains "-----> Building runtime environment" "`cat ${STD_OUT}`"
  assertTrue "Should have installed .profile.d/jemalloc.sh in build dir: `ls -la ${BUILD_DIR}`" "[ -f ${BUILD_DIR}/.profile.d/jemalloc.sh ]"


  # Run again to ensure cache is used.
  rm -rf ${BUILD_DIR}/*
  resetCapture

  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertNotContains "-----> Downloading jemalloc-5.1.0"  "`cat ${STD_OUT}`"
  assertContains "-----> Installing jemallo"  "`cat ${STD_OUT}`"

  assertEquals 0 ${rtrn}
  assertEquals "" "`cat ${STD_ERR}`"
}
