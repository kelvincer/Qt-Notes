import QtQuick
import QtQuick.Controls.Universal
import QtQuick.Layouts
import Notes
import "../js/Constants.js" as Constants

Window {
    id: mainWindow
    width: 880
    height: 620
    visible: true
    title: qsTr("Hello World")

    property int appMargin: 10
    property var currentEditorText: []

    signal sendEditorColor(var editorColor)
    signal sendLoadedText(var array)
    signal sendCursorPosition(int cursorPosition)

    NotesBackend {
        id: notesBackend
        onTitleOrDescriptionChanged: (title, description) => {
            console.log("new log", title, description);

            notesList.model.get(notesList.currentIndex).title = title;
            notesList.model.get(notesList.currentIndex).description = description;
        }
        onEditorCursorPositionChanged: {}
        format: Format {
            id: formatter
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredWidth: 0.35
            color: "white"
            Layout.fillHeight: true

            RowLayout {
                id: rowBar
                width: parent.width
                anchors.top: parent.top
                anchors.margins: appMargin

                Item {
                    Layout.preferredWidth: 0.25
                    Layout.fillWidth: true
                }

                NotesTabBar {
                    id: bar
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 0.5
                    Layout.fillWidth: true
                }

                Item {
                    Layout.preferredWidth: 0.1
                    Layout.fillWidth: true
                }

                Rectangle {
                    color: "transparent"
                    Layout.preferredWidth: 0.15
                    Layout.fillWidth: true
                    height: plusIcon.height

                    Image {
                        id: plusIcon
                        width: 25
                        height: 25
                        source: "qrc:/images/icons8-plus-50.png"
                        fillMode: Image.PreserveAspectFit
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                            rightMargin: appMargin
                        }

                        MouseArea {
                            id: plusMouseArea
                            anchors.fill: parent
                            onClicked: {

                                notesBackend.blocks = [];
                                notesBackend.cursorPosition = 0;
                                sendCursorPosition(notesBackend.cursorPosition);

                                notesList.model.addNewItem({
                                    "title": "",
                                    "description": "",
                                    "time": "14:45"
                                }, notesList.count);

                                notesList.currentIndex = 0;

                                let element = notesList.model.get(0)
                                sendEditorColor(element.itemColor)
                                sendLoadedText([{markdown: "", isTitle: false}])
                                markDownInput.clear()
                            }
                            onPressedChanged: {
                                if (plusMouseArea.pressed) {
                                    plusIcon.source = "qrc:/images/icons8-plus-math-50.png";
                                } else {
                                    plusIcon.source = "qrc:/images/icons8-plus-50.png";
                                }
                            }
                        }
                    }
                }
            }

            StackLayout {
                width: parent.width
                currentIndex: bar.currentIndex
                anchors {
                    top: rowBar.bottom
                    bottom: searchBox.top
                    right: parent.right
                    left: parent.left
                    margins: appMargin
                    topMargin: 15
                }

                Item {
                    id: homeTab
                    NotesList {
                        id: notesList
                        onListItemSelected: {
                            console.log("index", currentIndex);

                            let element = notesList.model.get(currentIndex);
                            sendEditorColor(element.itemColor);
                            notesBackend.setCurrentIndex(currentIndex);

                            console.log("title", element.title, element.description);

                            currentEditorText = [];

                            currentEditorText.push({
                                markdown: Constants.titleStarted + element.title,
                                isTitle: true,
                                isTitleFirstChar: false
                            });
                            currentEditorText.push({
                                markdown: "\n" + element.description,
                                isTitle: false,
                                isTitleFirstChar: false
                            });

                            sendLoadedText(currentEditorText);

                            const result = currentEditorText.filter(e => e.markdown.length > 0).map(e => e.markdown);
                            const maxCursorPosValue = MdArray.getTotalLength(currentEditorText);
                            console.log("max length", maxCursorPosValue);

                            if (result.length > 0) {
                                markDownInput.clear()
                                //console.log("not empty")
                                notesBackend.blocks = result
                                notesBackend.cursorPosition = maxCursorPosValue
                                sendCursorPosition(notesBackend.cursorPosition)
                            } else {
                                notesBackend.blocks = []
                                notesBackend.cursorPosition = 0
                                sendCursorPosition(0)
                                //markDownInput.clear()
                            }
                        }

                        Component.onCompleted: {
                            let element = notesList.model.get(0);
                            sendEditorColor(element.itemColor);
                            notesBackend.setCurrentIndex(0);

                            console.log("title", element.title, element.description);

                            currentEditorText.push({
                                markdown: element.title,
                                isTitle: true,
                                isTitleFirstChar: false
                            });
                            currentEditorText.push({
                                markdown: element.description,
                                isTitle: false,
                                isTitleFirstChar: false
                            });

                            sendLoadedText(currentEditorText);

                            const result = currentEditorText.map(e => e.markdown);
                            const maxCursorPosValue = MdArray.getTotalLength(currentEditorText);
                            //console.log("max length", maxCursorPosValue);

                            notesBackend.blocks = result;
                            notesBackend.cursorPosition = maxCursorPosValue;
                            sendCursorPosition(notesBackend.cursorPosition);
                        }
                    }
                }

                Item {
                    id: discoverTab
                    Text {
                        text: qsTr("Archive")
                    }
                }
            }

            TextField {
                id: searchBox
                font.pointSize: 14
                leftPadding: 30
                implicitHeight: 30
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    leftMargin: 55
                    rightMargin: 55
                    bottomMargin: 20
                }
                background: Rectangle {
                    radius: 3
                    border.color: "#707070"
                    border.width: 1

                    Image {
                        width: 16
                        height: 16
                        source: "qrc:/images/icons8-search-50.png"
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        MarkdownTextArea {
            id: markDownInput
            Layout.fillHeight: true
            Layout.preferredWidth: 0.55
            Layout.fillWidth: true
            backend: notesBackend
        }

        Column {
            Layout.fillHeight: true
            Layout.preferredWidth: 0.1
            Layout.fillWidth: true

            Text {
                text: "H1"
            }

            Text {
                text: "H2"
            }

            Text {
                text: "H3"
            }

            Button {
                text: "B"
                onClicked: {
                    console.log("B");
                    if (markDownInput.userSelected !== "") {
                        notesBackend.setBoldFormat(markDownInput.getText(0, markDownInput.length), markDownInput.selectionStart, markDownInput.selectionEnd);
                    }
                }
            }
        }
    }
}
