extends Node2D

var isGameOn
onready var gameBoard = get_node( "Back/Board" )

func _ready():
	init()
	gameBoard.init()


func init():
	isGameOn = true

func _on_Board_playerChanged( isWhiteMove ):
	var playerColor = "White" if isWhiteMove else "Black"
	$Back/Menu/ItemList/PlayerLabel.text = "Player: " + playerColor


func _on_Board_playerChecked():
	$Back/Menu/ItemList/PlayerLabel.text += " (checked) "
