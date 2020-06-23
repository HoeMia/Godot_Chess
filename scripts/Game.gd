extends Node2D

var isGameOn
onready var gameBoard = get_node( "Back/Board" )

func _ready():
	init()
	gameBoard.init()


func init():
	isGameOn = true


