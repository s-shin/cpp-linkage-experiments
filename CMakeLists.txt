cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project(myapp1 CXX)

set(LIBHELLO_LIB_TYPE "STATIC" CACHE STRING "library type of libhello")
option(LIBHELLO_VISIBILITY off "-fvisibility=hidden or not")
set(LIBHELLO_LIBSAY_VER "v1" CACHE STRING "libsay version used in libhello")
set(MYAPP_LIBSAY_VER "v1" CACHE STRING "libsay version used in myapp")
set(MYAPP_STATIC_LINK_OF_SHARED_LIBHELLO "na" CACHE STRING "link libhello as shared library statically")

add_library(libhello ${LIBHELLO_LIB_TYPE} libhello/src/hello.cc)
set_target_properties(libhello PROPERTIES PREFIX "")
target_include_directories(libhello PUBLIC libhello/include libsay/${LIBHELLO_LIBSAY_VER}/include)
if(${LIBHELLO_VISIBILITY})
  target_compile_options(libhello PUBLIC "-fvisibility=hidden")
endif()

add_executable(myapp myapp/main.cc)
target_include_directories(myapp PUBLIC libhello/include libsay/${MYAPP_LIBSAY_VER}/include)
target_link_libraries(myapp libhello)
if(${MYAPP_STATIC_LINK_OF_SHARED_LIBHELLO} AND NOT APPLE)
  set_target_properties(myapp PROPERTIES LINK_FLAGS "-static")
endif()
