// BackgroundWithDots.qml
import QtQuick 2.15

Rectangle {
    id: root
    anchors.fill: parent
    color: "#0D3349" // как в LoginPage

    property real animT: 0

    NumberAnimation on animT {
        from: 0; to: Math.PI * 2
        duration: 12000
        loops: Animation.Infinite
        running: true
    }

    Canvas {
        anchors.fill: parent
        onTChanged: requestPaint()
        property real t: root.animT

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            var dots = [
                { x: 0.12, y: 0.20, r: 90,  a: 0.06 },
                { x: 0.85, y: 0.10, r: 130, a: 0.05 },
                { x: 0.75, y: 0.80, r: 100, a: 0.07 },
                { x: 0.20, y: 0.85, r: 70,  a: 0.05 },
                { x: 0.50, y: 0.50, r: 160, a: 0.03 },
            ]
            for (var i = 0; i < dots.length; i++) {
                var d = dots[i]
                var ox = Math.sin(t + i * 1.3) * 18
                var oy = Math.cos(t + i * 0.9) * 14
                var grd = ctx.createRadialGradient(
                    d.x * width + ox, d.y * height + oy, 0,
                    d.x * width + ox, d.y * height + oy, d.r
                )
                grd.addColorStop(0, Qt.rgba(0.10, 0.55, 0.75, d.a + 0.04))
                grd.addColorStop(1, Qt.rgba(0.10, 0.55, 0.75, 0))
                ctx.fillStyle = grd
                ctx.beginPath()
                ctx.arc(d.x * width + ox, d.y * height + oy, d.r, 0, Math.PI * 2)
                ctx.fill()
            }
        }
    }

    // Сетка (как в LoginPage)
    Canvas {
        anchors.fill: parent
        opacity: 0.2
        onPaint: {
            var ctx = getContext("2d")
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.03)
            ctx.lineWidth = 1
            var step = 40
            for (var x = 0; x < width; x += step) {
                ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, height); ctx.stroke()
            }
            for (var y = 0; y < height; y += step) {
                ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(width, y); ctx.stroke()
            }
        }
    }
}