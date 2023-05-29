#******************************************************************************
#*Copyright (C) 2023 by Salvador Z                                            *
#*                                                                            *
#*****************************************************************************/
#*
#*@author Salvador Z
#*@brief CMakeLists file to add executables targets
#*
add_executable(main main.c)
target_link_libraries(main strio)

install(TARGETS main
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)