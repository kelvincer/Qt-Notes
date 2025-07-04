cmake_minimum_required(VERSION 3.16)

project(Notes VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTORCC ON)

set(CMAKE_QT_DEFINITIONS "-DQT_QML_DEBUG")

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Sql)
# find_package(Qt6 6.4 REQUIRED COMPONENTS Widgets)
find_package(cmark CONFIG REQUIRED)

qt_standard_project_setup(REQUIRES 6.5)

# qt_standard_project_setup()

include_directories(backend js)

qt_add_executable(appNotes
    main.cpp
)

qt_add_qml_module(appNotes
    URI Notes
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/NotesList.qml
        qml/NoteItem.qml
        qml/NotesTabBar.qml
        qml/MarkdownTextArea.qml
        qml/model/ListNoteModel.qml

    QML_FILES
        js/Constants.js
        js/MdArray.js
        js/TextBlock.js

    RESOURCES images.qrc

    SOURCES
        backend/notesbackend.h backend/notesbackend.cpp
        backend/Note.h
        backend/notetable.h backend/notetable.cpp
        backend/format.h backend/format.cpp
        SOURCES
        SOURCES backend/cmutil.h backend/cmutil.cpp
    
    QML_FILES
        tests/tst_breaks.qml
        tests/tst_brick_index_on_which_cursor_is_located.qml
        tests/tst_cursor_block_index.qml
        tests/tst_cursor_displacement_inside_block.qml
        tests/tst_cursor_displacement_inside_markdown_block.qml
        tests/tst_cursor_just_after_paragraph_breakline.qml
        tests/tst_length_before_cursor_block.qml
        tests/tst_length_until_cursor.qml
        tests/tst_paragraph_length.qml
        tests/tst_title_length.qml
        tests/tst_title_with_newline_length.qml
        tests/tst_total_length.qml
        tests/tst_blocks_from_text.qml
        tests/tst_first_char_of_title.qml
        tests/tst_first_paragraph_breakline_index.qml
        tests/tst_get_markdown_text_on_block_before_cursor.qml
        tests/tst_count_italics_asterisks_before_cursor.qml
        tests/tst_update_italics.qml
        tests/tst_find_last_html_break_end_index.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appNotes PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appNotes
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appNotes
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Sql
    # PRIVATE Qt6::Widgets
)

include(GNUInstallDirs)
install(TARGETS appNotes
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

include(FetchContent)

FetchContent_Declare(
    cmark
    GIT_REPOSITORY https://github.com/commonmark/cmark.git
    # GIT_TAG v1.0.0  # or master, main, or specific commit hash
)
FetchContent_MakeAvailable(cmark)

target_link_libraries(appNotes PRIVATE cmark)
