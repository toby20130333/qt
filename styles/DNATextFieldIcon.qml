import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0
import "base.js" as Base

// implement custom settings of selectionColor
Rectangle{
    id : rect
    width : 200
    height: 30
    property alias type : txtField.type
    border.color: Base.Color.Disabled.Value;

    border.width: 2

    property bool hovered : mouseRegion.containsMouse
    property alias bgColor : txtField.bgColor
    property alias searchFocus : txtField.activeFocus
//    property bool entered : false
    property bool normalStatus : false

    // Mimic aliases of TextField property
    property alias acceptableInput  : txtField.acceptableInput
    property alias activeFocusOnPress  : txtField.activeFocusOnPress
    property alias canPaste  : txtField.canPaste
    property alias canRedo  : txtField.canRedo
    property alias canUndo  : txtField.canUndo
    property alias cursorPosition  : txtField.cursorPosition
    property alias displayText  : txtField.displayText
    property alias echoMode  : txtField.echoMode
    property alias effectiveHorizontalAlignment  : txtField.effectiveHorizontalAlignment
    property alias font  : txtField.font
    property alias horizontalAlignment  : txtField.horizontalAlignment
    property alias inputMask  : txtField.inputMask
    property alias inputMethodHints  : txtField.inputMethodHints
    property alias length  : txtField.length
    property alias maximumLength  : txtField.maximumLength
    property alias placeholderText  : txtField.placeholderText
    property alias readOnly  : txtField.readOnly
    property alias selectedText  : txtField.selectedText
    property alias selectionEnd  : txtField.selectionEnd
    property alias selectionStart  : txtField.selectionStart
    property alias style  : txtField.style
    property alias text  : txtField.text
    property alias textColor  : txtField.textColor
    property alias validator  : txtField.validator
    property alias verticalAlignment  : txtField.verticalAlignment

    // Image props
    property alias imageSource : searchImg.source
    property alias imageWidth : searchImg.width
    property alias imageHeight : searchImg.height
    property bool hasLeftIcon : false



    signal clicked()
    signal accepted()
    radius : 4
    color : enabled ? "transparent" : Qt.lighter(Base.Color.Disabled.Value,1.2)

    function changeColor(){
        if (type == "Custom") {
            return bgColor;

        } else return Base.Color[type].Value;
    }
    MouseArea{
        id : mouseRegion
        anchors.fill: parent
        hoverEnabled: true
        onClicked : {
            txtField.focus = true
        }
    }


    function caculateTextFieldWidth(){
        if (rect.hasLeftIcon) {
            return rect.width -searchImg.width -searchImg.anchors.leftMargin;
        } else return rect.width -searchImg.width -searchImg.anchors.rightMargin;
    }

    TextField {
       id : txtField
       anchors.left : parent.left
       anchors.leftMargin: (rect.hasLeftIcon) ? searchImg.width+searchImg.anchors.leftMargin : 0
       implicitWidth: caculateTextFieldWidth()
       implicitHeight: parent.height
       anchors.verticalCenter: parent.verticalCenter
       font.family: Base.Font.family
       property string type : "Default"
       property color bgColor : Base.Color.Grey
       placeholderText : "Your Place Holder"
//       onActiveFocusChanged : {
//           console.log("active focus of text Field: " + activeFocus + " " + rect.type)
//           console.log("Active focus of root : "+ rect.activeFocus)
//           if (txtField.activeFocus){
//               rect.focus = true
//           }
//       }

       style: TextFieldStyle {
           textColor: Base.Color.BlackDark
           selectionColor : Base.Color[txtField.type].Value
           selectedTextColor : Base.Color.White
           background: Rectangle {
               id : completeRect
               implicitWidth: txtField.width
               implicitHeight: txtField.height
               border.width: 0
               color : "transparent"
//               opacity : 0.5


           }
       }
    }


    Image{
        id : searchImg
        anchors.right : rect.hasLeftIcon ? undefined : rect.right
        anchors.rightMargin: rect.hasLeftIcon ? undefined : 10
        anchors.left : rect.hasLeftIcon ? rect.left : undefined
        anchors.leftMargin: rect.hasLeftIcon ? 10 : undefined
        anchors.verticalCenter: rect.verticalCenter
        source : "images/search_icon.png"
        width : 21
        height : 21
        property alias color : colorOverlay.color
        ColorOverlay {
            id : colorOverlay
            anchors.fill: searchImg
            source: searchImg
            color: Base.Color.Disabled.Value;
            Behavior on color{
                ColorAnimation { duration: 300 }
            }
        }

    }
    states: [
        State {
            name: "searchFocusState"
            when : rect.searchFocus
            PropertyChanges {target: rect; border.color: rect.changeColor()}
            PropertyChanges {target: searchImg; color:rect.changeColor()}
        },
        State {
            name: "hoverState"
            when : rect.hovered
            PropertyChanges {target: rect; border.color: rect.changeColor()}
            PropertyChanges {target: searchImg; color:rect.changeColor()}
        }/*,

        State {
            name: "enteredState"
            when : rect.entered
            PropertyChanges {target: rect; border.color: Base.Color.Disabled.Value}
            PropertyChanges {target: searchImg; color:Base.Color.Disabled.Value}
        }*/
//        ,

//        State {
//            name: "hasRightImage"
//            when : !rect.hasLeftIcon
//            AnchorChanges {target: searchImg; anchors.right: rect.right}
//            AnchorChanges {target: searchImg; anchors.left: undefined}
//            PropertyChanges {target: searchImg; anchors.rightMargin:10}
//        },
//        State {
//            name: "hasLeftIcon"
//            when : rect.hasLeftIcon
//            AnchorChanges {target: searchImg; anchors.left: rect.left}
//            AnchorChanges {target: searchImg; anchors.right: undefined}
//            PropertyChanges {target: searchImg; anchors.leftMargin:10}
//            PropertyChanges {target: txtField; implicitWidth:rect.width -searchImg.width -searchImg.anchors.leftMargin}
//        }

    ]
    transitions: [
        Transition {
            to : "searchFocusState"
            PropertyAnimation { properties: "border.color"; easing.type: Easing.InOutQuad; duration: 300 }
        },
        Transition {
            to : "hoverState"
            PropertyAnimation { properties: "border.color"; easing.type: Easing.InOutQuad; duration: 300 }
        }/*,
        Transition {
            to : "enteredState"
            PropertyAnimation { properties: "border.color"; easing.type: Easing.InOutQuad; duration: 300 }
        }*/

    ]


    Component.onCompleted: {
        txtField.accepted.connect(rect.accepted)
        if (type == "Disabled"){
            enabled = false;}
    }


}

