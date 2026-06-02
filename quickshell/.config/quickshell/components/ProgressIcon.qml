import QtQuick
import QtQuick.Shapes
import qs.style
import qs.style.motions
import qs.components

Item {
    id: root
    
    required property real progress
    required property string iconName
    property bool clickable: false
    property int iconPointSize: 10
    property int verticalOffset: 0
    property color color: Theme.primary
    
    implicitWidth: innerIcon.implicitWidth + Tokens.appearance.padding.medium
    implicitHeight: innerIcon.implicitHeight + Tokens.appearance.padding.medium

    signal clicked()
    signal wheeled(var wheel)

    // Drawing both paths in the same Shape guarantees they use 
    // the exact same coordinate math and rendering pipeline.
    Shape {
        id: canvas
        anchors.fill: parent
        
        // Forces hardware-accelerated, ultra-smooth curves
        preferredRendererType: Shape.CurveRenderer
        antialiasing: true

        // 1. The Empty Background Track (Replaces the Rectangle)
        ShapePath {
            fillColor: "transparent"
            strokeColor: Qt.alpha(root.color, 0.15)
            strokeWidth: 2
            capStyle: ShapePath.RoundCap

            startX: canvas.width / 2
            startY: (canvas.height / 2) - (canvas.width / 2 - 1)

            PathAngleArc {
                centerX: canvas.width / 2
                centerY: canvas.height / 2
                radiusX: canvas.width / 2 - 1
                radiusY: canvas.height / 2 - 1
                startAngle: -90
                sweepAngle: 360 // Draw a full circle
            }
        }

        // 2. The Active Progress Arc
        ShapePath {
            fillColor: "transparent" 
            strokeColor: root.color
            strokeWidth: 2
            capStyle: ShapePath.RoundCap

            startX: canvas.width / 2
            startY: (canvas.height / 2) - (canvas.width / 2 - 1)

            PathAngleArc {
                centerX: canvas.width / 2
                centerY: canvas.height / 2
                radiusX: canvas.width / 2 - 1
                radiusY: canvas.height / 2 - 1
                startAngle: -90
                
                // Keep it capped safely
                sweepAngle: Math.max(0, Math.min(360, root.progress * 360))
            }
        }
    }

    MaterialIcon {
        id: innerIcon
        anchors.centerIn: parent
        anchors.verticalCenterOffset: root.verticalOffset

        text: root.iconName
        color: root.color
        font.pointSize: root.iconPointSize

        SwapMotion on text {
            item: innerIcon
        }
    }

    Loader {
        anchors.fill: parent
        active: root.clickable
        sourceComponent: Component {
            StateLayer {
                radius: Tokens.appearance.rounding.full
                effectColor: root.color
                onClicked: root.clicked()
                onWheeled: wheel => root.wheeled(wheel)
            }
        }
    }
}
