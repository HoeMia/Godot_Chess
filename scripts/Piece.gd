extends KinematicBody2D

var PointScript
var PieceConstantsPath
var point
var isWhite
var pieceTexture
var texturePath
var drag_enabled
var tile
var pieceWidth

func init( t_isWhite, t_pieceType, t_tile ):
	loadScripts()
	setVariables( t_isWhite, t_tile )
	setTexturePath( t_pieceType, t_isWhite )
	loadTexture()
	setTexture()
	setTileRelatedPosition()


func loadScripts():
	PointScript = preload( "res://scripts/Point.gd" )
	PieceConstantsPath = preload( "res://scripts/PieceConstants.gd" )

func setVariables( t_isWhite, t_tile ):
	isWhite = t_isWhite
	tile = t_tile
	drag_enabled = false
	point = PointScript.new( 0, 0 )
	pieceWidth = 64

func setTile( newTile ):
	tile = newTile

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

func setTileRelatedPosition():
	var t_point = tile.getPoint()
	position.x = t_point.get_left_top_x() + pieceWidth/2
	position.y = t_point.get_left_top_y() + pieceWidth/2

func setMouseRelativePosition():
	position.x = point.get_left_top_x()
	position.y = point.get_left_top_y()

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


func _process( _delta ):
	if drag_enabled:
		changePoint()
		setMouseRelativePosition()

func changePoint():
	var mousepos = get_viewport().get_mouse_position()
	var scaledMousepos = PieceConstantsPath.getMouseScaledPos( mousepos )
	point.top_left_x = scaledMousepos.x
	point.top_left_y = scaledMousepos.y

func setPressed( isPressed ):
	drag_enabled = isPressed

func resetPositionToTile():
	setTileRelatedPosition()

func getPossibleMoves():
	pass

func canMoveToTile( newTile ):
	return true
