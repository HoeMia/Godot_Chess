extends KinematicBody2D

var PointScript
var PieceConstantsPath
var point
var isWhite
var pieceTexture
var texturePath
var drag_enabled

func init( t_point, t_isWhite, t_pieceType ):
	loadScripts()
	setVariables( t_point, t_isWhite )
	setTexturePath( t_pieceType, t_isWhite )
	loadTexture()
	setTexture()
	setPosition()


func loadScripts():
	PointScript = preload( "res://scripts/Point.gd" )
	PieceConstantsPath = preload( "res://scripts/PieceConstants.gd" )

func setVariables( t_point, t_isWhite ):
	isWhite = t_isWhite
	point = t_point
	drag_enabled = false

func setTexturePath( t_pieceType, t_isWhite ):
	match( t_pieceType ):
		PieceConstantsPath.PieceType.Pawn:
			SetPawnTexturePath( t_isWhite )
		PieceConstantsPath.PieceType.Rook:
			SetRookTexturePath( t_isWhite )
		PieceConstantsPath.PieceType.Knight:
			SetKnightTexturePath( t_isWhite )
		PieceConstantsPath.PieceType.Bishop:
			SetBishopTexturePath( t_isWhite )
		PieceConstantsPath.PieceType.Queen:
			SetQueenTexturePath( t_isWhite )
		PieceConstantsPath.PieceType.King:
			SetKingTexturePath( t_isWhite )

func setPosition():
	position.x = point.top_left_x
	position.y = point.top_left_y

func SetPawnTexturePath( t_isWhite ):
	if( t_isWhite ):
		texturePath = "res://graphics/RedPawn.jpg"
	else:
		texturePath = "res://graphics/YellowPawn.jpg"

func SetRookTexturePath( t_isWhite ):
	if( t_isWhite ):
		texturePath = "res://graphics/RedRook.jpg"
	else:
		texturePath = "res://graphics/YellowRook.jpg"

func SetKnightTexturePath( t_isWhite ):
	if( t_isWhite ):
		texturePath = "res://graphics/RedKnight.jpg"
	else:
		texturePath = "res://graphics/YellowKnight.jpg"

func SetBishopTexturePath( t_isWhite ):
	if( t_isWhite ):
		texturePath = "res://graphics/RedBishop.jpg"
	else:
		texturePath = "res://graphics/YellowBishop.jpg"

func SetQueenTexturePath( t_isWhite ):
	if( t_isWhite ):
		texturePath = "res://graphics/RedQueen.jpg"
	else:
		texturePath = "res://graphics/YellowQueen.jpg"

func SetKingTexturePath( t_isWhite ):
	if( t_isWhite ):
		texturePath = "res://graphics/RedKing.jpg"
	else:
		texturePath = "res://graphics/YellowKing.jpg"

func loadTexture():
	pieceTexture = load( texturePath )

func setTexture():
	$"Piece".set_texture( pieceTexture )

func onDragStart():
	pass

func onDrop():
	pass

func isMoveValid():
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			drag_enabled = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			drag_enabled = event.pressed

func _process(delta):
	if drag_enabled:
		changePoint()
		setPosition()

func changePoint():
	var mousepos = get_viewport().get_mouse_position()
	point.top_left_x = mousepos.x
	point.top_left_y = mousepos.y
