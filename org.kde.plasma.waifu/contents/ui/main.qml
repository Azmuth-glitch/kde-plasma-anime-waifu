import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import QtQuick 2.15 as QQ   // Alias to access QtQuick types explicitly

PlasmoidItem {
    id: root
    width: 200
    height: 300

    Rectangle {
        id: backgroundPanel
        anchors.fill: parent
        color: "black"
        opacity: 0.0
        z: 1
    }

    Image {
        id: waifuImage
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        cache: false
        asynchronous: true
    }

    function fetchWaifu() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://api.waifu.pics/sfw/waifu")
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        var result = JSON.parse(xhr.responseText)
                        if (result.url) {
                            waifuImage.source = result.url
                        } else {
                            console.log("Invalid API response:", xhr.responseText)
                        }
                    } catch (error) {
                        console.log("JSON parse error:", error)
                    }
                } else {
                    console.log("HTTP error:", xhr.status)
                }
            }
        }
        xhr.send()
    }

    QQ.Timer {
        id: refreshTimer
        interval: 30 * 60 * 1000
        repeat: true
        running: true
        onTriggered: fetchWaifu()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: fetchWaifu()
    }

    Component.onCompleted: fetchWaifu()
}
