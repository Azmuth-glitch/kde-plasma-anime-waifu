import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0

PlasmoidItem {
    id: root
    width: 200
    height: 300

    Image {
        id: waifuImage
        anchors.centerIn: parent
        width: parent.width * 1
        height: parent.height * 1
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

    Timer {
        id: refreshTimer
        interval: 30 * 60 * 1000 // 30 minutes
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
