cmake_minimum_required(VERSION 3.16)

project(game2048 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appgame2048
    main.cpp
)

qt_add_qml_module(appgame2048
    URI game2048
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES gamecontroller.h gamecontroller.cpp
        RESOURCES icons.qrc
)

qt_add_resources(appgame2048 RESOURCE "./icons.qrc")

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appgame2048 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appgame2048
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appgame2048
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appgame2048
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
