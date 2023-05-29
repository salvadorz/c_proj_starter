#******************************************************************************
#*Copyright (C) 2023 by Salvador Z                                            *
#*                                                                            *
#*****************************************************************************/
#*
#*@author Salvador Z
#*@brief CMakeLists file to add all test cases for current lib
#*
set(TEST_BINARY ${PROJECT_NAME}_test)
add_executable(${TEST_BINARY} test_strio.c)
target_link_libraries(${TEST_BINARY} strio)

### Test Cases ###
add_test(NAME test_strio_lib COMMAND ${TEST_BINARY})

set (passRegex "[OK]" "^All tests were successful")
set (failRegex "Error" "Failed")

set_tests_properties(test_strio_lib PROPERTIES
  FAIL_REGULAR_EXPRESSION "[^a-z]Error;ERROR;Failed"
)

set_property (TEST test_strio_lib
              PROPERTY PASS_REGULAR_EXPRESSION "${passRegex}")
set_property (TEST test_strio_lib
              PROPERTY FAIL_REGULAR_EXPRESSION "${failRegex}")


install(TARGETS ${TEST_BINARY}
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/test)