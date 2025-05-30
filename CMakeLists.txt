set(PROJECT_VERSION_MAJOR 0)
set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.1.1")

project(scorekeeper LANGUAGES CXX)

set(PROJECT_SOURCES
    main.cpp
    qml.qrc
)


set(QT_MIN_VERSION "5.15.2")
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)


find_package(Qt5 REQUIRED COMPONENTS Core Quick)

find_package(ECM ${KF5_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake ${ECM_MODULE_PATH} )

include(KDEInstallDirs)

include(CheckIncludeFiles)
include(CMakePackageConfigHelpers)
include(FeatureSummary)
include(GenerateExportHeader)

cmake_minimum_required(VERSION 3.21)

qt_add_resources(PROJECT_SOURCES qml.qrc)

#set(QML_IMPORT_TRACE 1)
set(QML_IMPORT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/qml CACHE STRING "Import paths for Qt Creator's code model" FORCE)

add_compile_definitions(QT_DECLARATIVE_DEBUG QT_QML_DEBUG)

add_executable(${CMAKE_PROJECT_NAME}
  ${PROJECT_SOURCES}
)

target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE QT_QML_DEBUG)

target_link_libraries(${CMAKE_PROJECT_NAME}
    Qt::Core
    Qt::Quick
    Qt::Qml
)

install(TARGETS ${CMAKE_PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

