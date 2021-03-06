#-------------------------------------------------------------------
# This file is part of the CMake build system for OGRE
#     (Object-oriented Graphics Rendering Engine)
# For the latest info, see http://www.ogre3d.org/
#
# The contents of this file are placed in the public domain. Feel
# free to make use of it in any way you like.
#-------------------------------------------------------------------

macro( add_recursive dir retVal )
	file( GLOB_RECURSE ${retVal} ${dir}/*.hpp ${dir}/*.cpp )
endmacro()

include_directories(${CMAKE_SOURCE_DIR}/../Common)
include_directories(${OGRE_INCLUDE_DIRS})
include_directories(${OIS_INCLUDE_DIRS})
#include_directories(${Boost_INCLUDE_DIRS})
#include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_recursive( ./ SOURCE_FILES )

# Specify build paths
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
if (WIN32 OR APPLE)
  if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    # We don't want to install in default system location, install is really for the SDK, so call it that
    set(CMAKE_INSTALL_PREFIX
	  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}" CACHE PATH "${PROJECT_NAME} install prefix" FORCE
    )
  endif (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
endif(WIN32 OR APPLE)

ogre_add_executable(${PROJECT_NAME} WIN32 ${SOURCE_FILES})

set_target_properties(${PROJECT_NAME}
    PROPERTIES
    DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX}
    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
)

target_link_libraries(${PROJECT_NAME} ${OGRE_LIBRARIES} ${OGRE_SAMPLES_LIBRARIES})

file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX}/bin)
file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX}/media)

# post-build copy for win32
if(WIN32 AND NOT MINGW)
	add_custom_command( TARGET ${PROJECT_NAME} PRE_BUILD
		COMMAND if not exist \"${CMAKE_INSTALL_PREFIX}/bin\" mkdir \"${CMAKE_INSTALL_PREFIX}/bin/$(ConfigurationName)\" )
	add_custom_command( TARGET ${PROJECT_NAME} POST_BUILD
		COMMAND copy /y \"$(TargetPath)\" \"${CMAKE_INSTALL_PREFIX}/bin/$(ConfigurationName)\" )
	add_custom_command( TARGET ${PROJECT_NAME} POST_BUILD
		COMMAND if $(ConfigurationName) == Debug copy /y \"$(TargetDir)$(TargetName).pdb\" \"${CMAKE_INSTALL_PREFIX}/bin/$(ConfigurationName)\" )
endif(WIN32 AND NOT MINGW)

if(WIN32)
 
	install(TARGETS ${PROJECT_NAME}
		RUNTIME DESTINATION bin/Release
		CONFIGURATIONS Release RelWithDebInfo
    )

	install(TARGETS ${PROJECT_NAME}
		RUNTIME DESTINATION bin/Debug
		CONFIGURATIONS Debug
    )
 
	install(DIRECTORY ${CMAKE_SOURCE_DIR}/dist/Media
		DESTINATION ./
		CONFIGURATIONS Release RelWithDebInfo Debug
	)
 
	install(FILES ${CMAKE_SOURCE_DIR}/dist/bin/plugins.cfg
		${CMAKE_SOURCE_DIR}/dist/bin/resources2.cfg
		DESTINATION bin/Release
		CONFIGURATIONS Release RelWithDebInfo
	)
 
	install(FILES ${CMAKE_SOURCE_DIR}/dist/bin/plugins${CMAKE_DEBUG_POSTFIX}.cfg
		${CMAKE_SOURCE_DIR}/dist/bin/resources2${CMAKE_DEBUG_POSTFIX}.cfg
		DESTINATION bin/Debug
		CONFIGURATIONS Debug
	)
 
	install(FILES ${OGRE_PLUGIN_DIR_REL}/OgreMain.dll
		${OGRE_PLUGIN_DIR_REL}/OgreOverlay.dll
		${OGRE_PLUGIN_DIR_REL}/OgreHlmsPbs.dll
		${OGRE_PLUGIN_DIR_REL}/OgreHlmsUnlit.dll
		${OGRE_PLUGIN_DIR_REL}/RenderSystem_Direct3D11.dll
		${OGRE_PLUGIN_DIR_REL}/RenderSystem_GL3Plus.dll
		${OGRE_PLUGIN_DIR_REL}/OIS.dll
		${OGRE_PLUGIN_DIR_REL}/cg.dll
		${OGRE_PLUGIN_DIR_REL}/D3DCompiler_47.dll
		DESTINATION bin/Release
		CONFIGURATIONS Release RelWithDebInfo
	)
 
	install(FILES ${OGRE_PLUGIN_DIR_DBG}/OgreMain${CMAKE_DEBUG_POSTFIX}.dll
		${OGRE_PLUGIN_DIR_DBG}/OgreOverlay${CMAKE_DEBUG_POSTFIX}.dll
		${OGRE_PLUGIN_DIR_DBG}/OgreHlmsPbs${CMAKE_DEBUG_POSTFIX}.dll
		${OGRE_PLUGIN_DIR_DBG}/OgreHlmsUnlit${CMAKE_DEBUG_POSTFIX}.dll
		${OGRE_PLUGIN_DIR_DBG}/RenderSystem_Direct3D11${CMAKE_DEBUG_POSTFIX}.dll
		${OGRE_PLUGIN_DIR_DBG}/RenderSystem_GL3Plus${CMAKE_DEBUG_POSTFIX}.dll
		${OGRE_PLUGIN_DIR_DBG}/OIS${CMAKE_DEBUG_POSTFIX}.dll
		${OGRE_PLUGIN_DIR_DBG}/cg.dll
		${OGRE_PLUGIN_DIR_DBG}/D3DCompiler_47.dll
		DESTINATION bin/Debug
		CONFIGURATIONS Debug
	)
endif(WIN32)

if(UNIX)
 
	install(TARGETS ${PROJECT_NAME}
		RUNTIME DESTINATION bin
		CONFIGURATIONS All)
 
	install(DIRECTORY ${CMAKE_SOURCE_DIR}/dist/media
		DESTINATION ./
		CONFIGURATIONS Release RelWithDebInfo Debug
	)
 
	install(FILES ${CMAKE_SOURCE_DIR}/dist/bin/plugins.cfg
		${CMAKE_SOURCE_DIR}/dist/bin/resources.cfg
		DESTINATION bin
		CONFIGURATIONS Release RelWithDebInfo Debug
	)
 
endif(UNIX)

set(OGRE_WORK_DIR "${CMAKE_INSTALL_PREFIX}")
set(OGRE_BINARY_DIR "${CMAKE_INSTALL_PREFIX}/bin")
ogre_create_vcproj_userfile(${PROJECT_NAME})

#set(OGRE_ARCHIVE_OUTPUT "${CMAKE_BINARY_DIR}/lib")
#set(OGRE_LIBRARY_OUTPUT "${CMAKE_BINARY_DIR}/lib")
#set(OGRE_RUNTIME_OUTPUT "${CMAKE_BINARY_DIR}/bin")
#ogre_config_sample_exe(${PROJECT_NAME})
