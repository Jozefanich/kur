# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appstack_test_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appstack_test_autogen.dir\\ParseCache.txt"
  "appstack_test_autogen"
  )
endif()
