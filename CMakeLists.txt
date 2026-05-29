cmake_minimum_required(VERSION 3.16)

project(HospitalApp VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Sql QuickControls2)

qt_standard_project_setup()

set(SOURCES
    main.cpp
    DatabaseManager.cpp
    PatientsModel.cpp
    VisitsModel.cpp
)

set(HEADERS
    DatabaseManager.h
    PatientsModel.h
    VisitsModel.h
)

qt_add_executable(appHospitalApp
    ${SOURCES}
    ${HEADERS}
)

# Добавляем QML модуль — файлы будут видны в IDE, но мы их не используем как ресурсы
qt_add_qml_module(appHospitalApp
    URI HospitalApp
    QML_FILES
        qml/main.qml
        qml/LoginPage.qml
        qml/MainTabs.qml
        qml/AddPatientPage.qml
        qml/AddVisitPage.qml
        qml/HistoryPage.qml
        qml/VisitDetailPage.qml
        qml/RoomsPage.qml
        qml/PrimaryButton.qml
        qml/StatusMessage.qml
        qml/StyledField.qml
        qml/Theme.qml
        QML_FILES qml/RegisterDialog.qml
        QML_FILES qml/BackgroundWithDots.qml
        QML_FILES qml/WindowControls.qml
        SOURCES doctorsmodel.h doctorsmodel.cpp
        QML_FILES qml/DoctorsPage.qml
        QML_FILES qml/PatientDetailPage.qml

)

target_link_libraries(appHospitalApp
    PRIVATE Qt6::Core
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Sql
    PRIVATE Qt6::QuickControls2
)

# Копируем папку qml в место, где лежит исполняемый файл (для загрузки из файловой системы)
add_custom_command(TARGET appHospitalApp POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/qml
        $<TARGET_FILE_DIR:appHospitalApp>/qml
    COMMENT "Копирование QML файлов в папку с исполняемым файлом"
)

set_target_properties(appHospitalApp PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

install(TARGETS appHospitalApp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)