import QtQuick 2.4
import QtQuick.Controls.Universal
import QtQuick.Layouts

Window {
    width: 880
    height: 620
    visible: true
    title: qsTr("Hello World")

    property int appMargin: 10

    RowLayout{
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: parent.width * 0.35;
            //Layout.preferredHeight: parent.height
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

                TabBar {
                    id: bar
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 0.5
                    Layout.fillWidth: true
                    background: Rectangle {
                        color: "lightgray"
                        radius: 10
                    }

                    TabButton {
                        id: noteTab
                        text: qsTr("Notes")
                        implicitHeight: 30

                        contentItem: Text {
                            text: parent.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: parent.checked ? "black" : "white"
                            font.bold: true
                            font.pointSize: 14
                            font.family: "Roboto"
                        }

                        background: Rectangle {
                            color: noteTab.checked ?  "white" : "lightgray"
                            border.color: noteTab.checked ?  "green" : "lightgray"
                            border.width: 2
                            radius: 10
                        }
                    }

                    TabButton {
                        id: archiveTab
                        text: qsTr("Archive")
                        implicitHeight: 30
                        contentItem: Text {
                            text: parent.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: parent.checked ? "black" : "white"
                            font.bold: true
                            font.pointSize: 14
                            font.family: "Roboto"
                        }

                        background: Rectangle {
                            color: archiveTab.checked ? "white" : "lightgray"
                            border.color: archiveTab.checked ? "green" : "lightgray"
                            border.width: 2
                            radius: 10
                        }
                    }
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
                            anchors.fill: parent;
                            onClicked: {
                                console.log("image")
                            }
                            onPressedChanged: {
                            
                                console.log("MouseArea pressed changed to", plusMouseArea.pressed)

                                if(plusMouseArea.pressed) {
                                    plusIcon.source = "qrc:/images/icons8-plus-math-50.png"
                                } else {
                                     plusIcon.source = "qrc:/images/icons8-plus-50.png"
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
                    bottom: parent.bottom
                    right: parent.right
                    left: parent.left
                    margins: appMargin
                }

                Item {
                    id: homeTab

                        ListView {

                            id: list

                            Component.onCompleted: {
                                console.log("width: " + list.width)
                                console.log("Height: " + list.height)
                            }

                            anchors.fill: parent

                            model: ListNoteModel{}

                            delegate: Row {

                                Text {
                                    text: name
                                }

                                Item {
                                    width: 50
                                    height: 20
                                }

                                Text {
                                    text: cost
                                }
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
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "green"

            RowLayout {
                anchors.fill: parent
                spacing: 0
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 0.2
                    Layout.fillWidth: true
                    color: "peru"
                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 0.2
                    Layout.fillWidth: true
                    color: "blue"
                }
                 Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 0.2
                    Layout.fillWidth: true
                    color: "yellow"
                }
                 Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 0.2
                    Layout.fillWidth: true
                    color: "lime"
                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 0.2
                    Layout.fillWidth: true
                    color: "lightBlue"
                }
            }

            RowLayout {
                anchors.fill: parent

                Item { Layout.fillWidth: true }

                Button {
                    text: "Right button"
                    onClicked: {
                        console.log("Right")
                    }
                }
            }

            RowLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "Middle button"
                    onClicked: {
                        console.log("Center")
                    }
                }

                Item { Layout.fillWidth: true }
            }
        }
    }
}
