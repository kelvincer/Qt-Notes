import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Window {
    width: 880
    height: 620
    visible: true
    title: qsTr("Hello World")


    RowLayout{
        anchors.fill: parent
        spacing: 0
        //Layout.margins: 10

        Rectangle {

            Layout.preferredWidth: parent.width * 0.35;
            Layout.preferredHeight: parent.height
            color: "orange"
            //Layout.margins: 10
            Layout.fillHeight: true
            //Layout.topMargin: 20

            RowLayout {
                height: 50
                width: parent.width
                //y: 15

                //Layout.preferredWidth: parent.width
                //Layout.rightMargin: 7

                Item { Layout.fillWidth: true }

                Image {
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    source: "qrc:/image/plus.png"
                    fillMode: Image.PreserveAspectFit
                    Layout.alignment: Qt.AlignVCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("image");
                        }
                    }
                }
            }


            RowLayout {
                id:rowBar
                anchors {
                    left: parent.left
                    right: parent.right
                }
                y: 15

                TabBar {
                    id: bar
                    height: 50
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 150
                    background: Rectangle {
                        color: "lime"
                        border.color: "red"
                        radius: 20
                    }


                    TabButton {
                        id: noteTab
                        text: qsTr("Notes")
                        contentItem: Text {
                            text: parent.text
                            font.pointSize: 12 // adjust the font size as needed
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: parent.checked ? "black" : "white"
                        }
                        background: Rectangle {
                            color: "lime"
                            //border.color: "red"
                            //radius: 20
                        }
                    }
                    TabButton {
                        id: archiveTab
                        text: qsTr("Archive")
                        contentItem: Text {
                            text: parent.text
                            font.pointSize: 12 // adjust the font size as needed
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: parent.checked ? "black" : "white"
                        }
                        background: Rectangle {
                            color: "lime"
                            //border.color: "red"
                            //radius: 20
                        }
                    }
                }

                //Item { Layout.fillWidth: true }
            }

            StackLayout {
                width: parent.width
                currentIndex: bar.currentIndex

                anchors.top: rowBar.bottom

                Item {
                    id: homeTab

                    Text {
                        text: qsTr("Notes")
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
            //Layout.preferredWidth: parent.width * 0.65;
            //Layout.preferredHeight: parent.height
            //height: parent.height
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "green"

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
                //anchors.fill: parent
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
