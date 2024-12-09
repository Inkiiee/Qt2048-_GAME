import QtQuick
import QtQuick.Controls
import Game2048 1.0

Window {
    width: 350
    height: 480
    visible: true
    title: qsTr("2048")
    color: "black"

    GameController{
        id: gameController
        onMapChanged: {
            let map = gameController.get_map();
            for(let i=0; i<16; i++){
                let block = blockRepeater.itemAt(i).children[0];

                if(map[i] === 0){block.opacity = 0;}
                else{
                    block.opacity = 1;
                    block.color = blockColor(map[i] > 2048 ? map[i] / 2048 : map[i]);

                    let block_text = block.children[0];
                    block_text.text = ""+map[i];
                    block_text.color = map[i] > 4 ? "#F9F6F2" : "#776E65";
                }
            }
        }
        onScoreChanged: score.text = "" + gameController.score;
        onGameOver:function gameOverCheck(win){
            maxScore.text=""+gameController.get_max_score();

            if(win === 0) {gameOverPopupText.text = "Game Over"; gameOverPopup.open();}
            else {gameOverPopupText.text = "You're Win!!"; gameOverPopup.open();}
        }
        onCreateBlock: function createBlock(idx){
            let map = gameController.get_map();
            let block = blockRepeater.itemAt(idx).children[0];

            block.opacity = 1;
            block.color = blockColor(map[idx] > 2048 ? map[idx] / 2048 : map[idx]);

            let block_text = block.children[0];
            block_text.text = ""+map[idx];
            block_text.color = map[idx] > 4 ? "#F9F6F2" : "#776E65";
            block.anim.start();
        }
    }

    Popup{
        id: gameOverPopup
        anchors.centerIn: parent
        width: parent.width * 0.7
        height: parent.height * 0.4
        focus: true

        Rectangle{
            id: gameOverPopupRect
            anchors.fill: parent
            width: parent.width
            height: parent.height
            color: "#E6CDA3"
            border.color: "black"
            radius: 5

            Text{
                id: gameOverPopupText
                anchors.centerIn: parent
                font.bold: true
                font.pixelSize: parent.width / 10
                horizontalAlignment: Text.horizontalAlignment
            }

            Rectangle{
                id: gameOverPopupButtonRect
                anchors{
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: 20
                }
                width: parent.width / 3
                height: parent.height / 10
                radius: 5
                border.color: "#B5AD85"

                property bool isMouseThere: popupMouseArea.containsMouse
                color: isMouseThere ? "#D9C199" : "#EDD3A8"

                Text{
                    text: "Ok"
                    anchors.centerIn: parent
                    font.bold: true
                    font.pixelSize: parent.width / 5
                    horizontalAlignment: Text.horizontalAlignment
                }

                MouseArea{
                    id: popupMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{gameOverPopup.close();}
                }
            }
        }
    }

    Rectangle{
        id: menuRect
        anchors.top: parent.top
        width: parent.width
        height: parent.height / 7
        color: "#FFE4B5"
        opacity: 0.99
        Component.onCompleted: {gameController.init(); maxScore.text=""+gameController.get_max_score();}

        Text{
            id: gameTitle
            anchors{
                left: parent.left
                leftMargin: 5
                top: parent.top
                topMargin: 5
                bottomMargin: 5
                rightMargin: 5
            }
            width: parent.width / 3 * 2 - 10
            height: parent.height - 10
            text: " 2048 Game"
            font.bold: true
            font.pixelSize: gameTitle.width / text.length
            color: "#CF8861"
            verticalAlignment: Text.AlignVCenter
        }

        Button{
            id: restartButton
            anchors{
                left:gameTitle.right
                top: parent.top
                leftMargin:5
                topMargin: 5
                verticalCenter: gameTitle.verticalCenter
            }
            icon.source: "qrc:/icons/refeat_icon.png"
            background: null
            onClicked: {gameController.init(); game2048Rect.focus = true;}
        }
    }
    Rectangle{
        id: scoreRect
        anchors.top: menuRect.bottom
        anchors.left: menuRect.left
        width: parent.width
        height: menuRect.height
        color: "#FFE4B5"
        opacity: 0.96
        Rectangle{
            id: currentScoreRect
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.width/2
            height: parent.height
            border.color: "#F2D9AC"
            color: "#FFE4B5"
            Text{
                id: score
                anchors{
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                    leftMargin: 10
                    rightMargin: 10
                }
                text: "2048"
                font.pixelSize: parent.width/6
                font.italic: true
                font.bold: true
                color: "brown"
            }
            Text{
                id:currentScoreTitle
                anchors{
                    top: parent.top
                    left: parent.left
                    leftMargin: 10
                    topMargin: 5
                }
                width: parent.width
                height: parent.height/6
                font.pixelSize: parent.height/6
                font.italic: true
                font.bold: true
                color: "brown"
                text: "Score"
            }
        }
        Rectangle{
            id: maxScoreRect
            anchors.left: currentScoreRect.right
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            border.color: "#F2D9AC"
            color: "#FFE4B5"
            Text{
                id:maxScore
                anchors{
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                    leftMargin: 10
                    rightMargin: 10
                }
                text: "2048"
                color: "#FFC90E"
                font.pixelSize: parent.width/6
                font.italic: true
                font.bold: true
            }
            Text{
                id:maxScoreTitle
                anchors{
                    top: parent.top
                    left: parent.left
                    topMargin: 5
                    leftMargin: 10
                }
                width: parent.width
                height: parent.height/6
                font.pixelSize: parent.height/6
                font.italic: true
                font.bold: true
                color: "#FFC90E"
                text: "Max Score"
            }
        }
    }
    Rectangle{
        id: game2048Rect
        anchors{top: scoreRect.bottom; left: scoreRect.left}
        width: parent.width
        height: parent.height - (scoreRect.height + menuRect.height)
        color: "#FFE4B5"
        opacity: 0.96
        focus: true
        Keys.onPressed: function (event){
            console.log("pressed");
            if(event.key === Qt.Key_W){gameController.move_up();}
            else if(event.key === Qt.Key_S){gameController.move_down();}
            else if(event.key === Qt.Key_D){gameController.move_right();}
            else if(event.key === Qt.Key_A){gameController.move_left();}
        }

        MouseArea{
            id: gameMouseArea
            anchors.fill: parent
            property bool isDragging: false
            property double myx: 0.0
            property double myy: 0.0

            onPressed:{
                if(isDragging) {return;}
                myx = mouse.x;
                myy = mouse.y;
                isDragging = true;
            }
            onReleased: {
                let mx = mouse.x;
                let my = mouse.y;

                mx = (mx - myx);
                my = (my - myy);
                let theta = Math.atan2(my, mx) * (180 / 3.14159);
                theta = theta < 0 ? theta + 360 : theta;

                if(mx * mx + my * my < 100) {isDragging = false; return;}

                if(theta <= 45 || theta > (360 - 45)){console.log("right"); gameController.move_right();}
                else if(theta > 45 && theta <= 135) {console.log("down"); gameController.move_down();}
                else if(theta > 135 && theta <= 225) {console.log("left"); gameController.move_left();}
                else{console.log("up"); gameController.move_up();}
                isDragging = false;
            }
        }

        Rectangle{
            id: gamePanel
            anchors{
                fill: parent
                leftMargin: 10
                rightMargin: 10
                topMargin: 10
                bottomMargin: 10
            }
            radius: 10
            color: "#B67A57"

            Grid{
                id: grid
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.topMargin: 10
                columns: 4
                spacing: 10
                Repeater{
                    id: blockRepeater
                    model: 16
                    Rectangle{
                        width: parent.width / 4 - 10
                        height: parent.height / 4 - 10
                        objectName: "block_panel_"+index
                        color: "#D99168"
                        radius: 10

                        Rectangle{
                            id: block
                            anchors{fill: parent; centerIn: parent}
                            color: "white"
                            radius: 10
                            opacity: 0
                            objectName: "block_"+index

                            Text {
                                text: "20480"
                                anchors.centerIn: parent
                                font.bold: true
                                font.pixelSize: (parent.width < parent.height ? parent.width -20 : parent.height -20) / text.length
                            }
                            SequentialAnimation{
                                id: blockAnimation
                                PropertyAnimation{
                                    target: block
                                    property: "scale"
                                    from: 0.5
                                    to: 1
                                    duration: 200
                                }
                            }
                            property alias anim: blockAnimation
                        }
                    }
                }
            }
        }
    }

    function blockColor(value) {
        switch (value) {
            case 2: return "#EEE4DA";
            case 4: return "#EDE0C8";
            case 8: return "#F2B179";
            case 16: return "#F59563";
            case 32: return "#F67C5F";
            case 64: return "#F65E3B";
            case 128: return "#EDCF72";
            case 256: return "#EDCC61";
            case 512: return "#EDC850";
            case 1024: return "#EDC53F";
            case 2048: return "#EDC22E";
            default: return "#CDC1B4"; // 빈 칸 색상
        }
    }
}
