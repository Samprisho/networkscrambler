cmake_minimum_required(VERSION 3.16)

project(NetworkScrambler VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Core)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appNetworkScrambler
    main.cpp
)

qt_add_qml_module(appNetworkScrambler
    URI NetworkScrambler
    VERSION 1.0
    QML_FILES
        Main.qml
        InputSection.qml
        PacketLossInput.qml
    SOURCES
        networkmanager.h
        networkmanager.cpp
        networkemulation.h
        networkemulation.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appNetworkScrambler PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.appNetworkScrambler.dev
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appNetworkScrambler
    PRIVATE Qt6::Quick Qt6::Core
)

include(GNUInstallDirs)

# Install the main executable
install(TARGETS appNetworkScrambler
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Install PolicyKit policy file
install(FILES
    ${CMAKE_SOURCE_DIR}/com.networkscrambler.policy
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/polkit-1/actions/
)

# Install helper script
install(PROGRAMS
    ${CMAKE_SOURCE_DIR}/network-helper.sh
    DESTINATION ${CMAKE_INSTALL_LIBEXECDIR}/networkscrambler/
)

# Install desktop file
install(FILES
    ${CMAKE_SOURCE_DIR}/networkscrambler.desktop
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications/
)

# Create directory for helper scripts
install(DIRECTORY DESTINATION ${CMAKE_INSTALL_LIBEXECDIR}/networkscrambler/)
