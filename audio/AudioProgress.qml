import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Controls.Private 1.0
import "../styles/base.js" as Base
import "../styles"
Slider {
    id : sld
    width : 200
    height : 6
    maximumValue: 100
    minimumValue: 0
    property int sliderHeight : 6
    property int handleWidth : 16
    property int handleHeight : 16
    property int handleRadius : 8

    onHoveredChanged: {
        if (hovered) focus = true
    }




    activeFocusOnPress : true
    style : SliderStyle{
        handle: Rectangle {
                    id : handleItem
                    anchors.centerIn: parent
                    color: sld.hovered ? sld.pressed ? Base.Color.Primary.Dark : Base.Color.Primary.Light : Base.Color.Primary.Value
                    width: sld.handleWidth
                    height: sld.handleHeight
                    radius: sld.handleRadius

                    opacity : sld.hovered  ? 1 : 0
                    Behavior on  opacity {
                        NumberAnimation{duration : 200}
                    }

                    states: [
                        State {
                            name: "clickState"
                            when : sld.pressed
                            PropertyChanges { target: handleItem; color: Base.Color.Primary.Dark}
                        },
                        State {
                            name: "hoverState"
                            when : sld.hovered
                            PropertyChanges { target: handleItem; color: Base.Color.Primary.Light}
                        }

                    ]
                    transitions: [
                        Transition {
                            to : "clickState"
                            PropertyAnimation { properties: "color"; easing.type: Easing.InOutQuad; duration: 300 }
                        },
                        Transition {
                            to : "hoverState"
                            PropertyAnimation { properties: "color"; easing.type: Easing.InOutQuad; duration: 300 }
                        }
                    ]
                }
        groove: Rectangle {
                    id : theRect
                    implicitWidth: sld.width
                    implicitHeight: sliderHeight
                    color: Base.Color.Disabled.Value
                    radius: sliderHeight/2
                    function getWidth(){
                        if (sld.minimumValue===sld.value) {
                            return styleData.handlePosition - sld.handleWidth/2
                        } else if (sld.maximumValue===sld.value){
                            return styleData.handlePosition + sld.handleWidth/2
                        } else return styleData.handlePosition
                    }
                    Rectangle {
                        id : completeRect
                        implicitWidth: getWidth()
                        implicitHeight: sliderHeight
                        color: Base.Color.Primary.Value
                        radius: sliderHeight/2
                        //                 onWidthChanged: {
                        //                     console.log("Duration: " + sld.audioDuration + " Position: " + sld.audioPosition + " slider value:" + sld.value +  " HandlePOsition:" + styleData.handlePosition + " SliderWidth:" + sld.width)
                        //                 }

                    }
                    DNATooltip{
                        text :Base.Utils.formatTime(sld.value)
                        x : styleData.handlePosition - width/2
                        y : -height - 10
                        width : 60
                        height: 30
                        textLeftRightMargin : 5
                        pointerSize: 5
                        style : "down"
                        visible : (sld.hovered || sld.pressed) ? true : false

                    }
                }
    }
 }



