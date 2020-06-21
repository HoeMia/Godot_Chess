extends Node2D

var isGameOn
var isWhiteMove
onready var gameBoard = get_node( "Back/Board" )

func _ready():
	init()
	gameBoard.init()


func init():
	isWhiteMove = true
	isGameOn = true

func changePlayer():
	isWhiteMove = !isWhiteMove

