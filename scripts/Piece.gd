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
var pieceType
var hasPieceMoved

func init( t_isWhite, t_pieceType, t_tile ):
	loadScripts()
	setVariables( t_isWhite, t_tile, t_pieceType )
	setTexturePath( t_pieceType, t_isWhite )
	loadTexture()
	setTexture()
	setTileRelatedPosition()


func loadScripts():
	PointScript = preload( "res://scripts/Point.gd" )
	PieceConstantsPath = preload( "res://scripts/PieceConstants.gd" )

func setVariables( t_isWhite, t_tile, t_pieceType ):
	isWhite = t_isWhite
	tile = t_tile
	pieceType = t_pieceType
	drag_enabled = false
	point = PointScript.new( 0, 0 )
	pieceWidth = 64
	hasPieceMoved = false

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

func setMouseRelativePosition():
	position.x = point.get_left_top_x()
	position.y = point.get_left_top_y()

func setPressed( isPressed ):
	drag_enabled = isPressed

func resetPositionToTile():
	setTileRelatedPosition()

func getAllPossibleMoves():
	match( pieceType ):
		PieceConstantsPath.PieceType.Pawn:
			return getPawnAllPossibleMoves()
		PieceConstantsPath.PieceType.Rook:
			return getRookAllPossibleMoves()
		PieceConstantsPath.PieceType.Knight:
			return getKnightAllPossibleMoves()
		PieceConstantsPath.PieceType.Bishop:
			return getBishopAllPossibleMoves()
		PieceConstantsPath.PieceType.Queen:
			return getQueenAllPossibleMoves()
		PieceConstantsPath.PieceType.King:
			return getKingAllPossibleMoves()

func getPawnAllPossibleMoves():
	var forwardMoves = getPawnForwardMoves()
	var diagonalMoves = getPawnDiagonalMoves()
	var allMoves = forwardMoves + diagonalMoves
	return allMoves

func getRookAllPossibleMoves():
	var horizontalMoves = getRookHorizontalMoves()
	var verticalMoves = getRookVerticalMoves()
	var allMoves = horizontalMoves + verticalMoves
	return allMoves

func getKnightAllPossibleMoves():
	var longHorizontalMoves = getKnightLongHorizontalMoves()
	var longVerticalMoves = getKnightLongVerticalMoves()
	var allMoves = longHorizontalMoves + longVerticalMoves
	return allMoves

func getBishopAllPossibleMoves():
	var leftDiagonals = getBishopLeftDiagonals()
	var rightDiagonals = getBishopRightDiagonals()
	var allMoves = leftDiagonals + rightDiagonals
	return allMoves

func getQueenAllPossibleMoves():
	var diagonalMoves = getBishopAllPossibleMoves()
	var straightMoves = getRookAllPossibleMoves()
	var allMoves = diagonalMoves + straightMoves
	return allMoves

func getKingAllPossibleMoves():
	var straightMoves = getKingStraightMoves()
	var diagonalMoves = getKingDiagonalMoves()
	var rochadeMoves = getKingRochadeMoves()
	var allMoves = straightMoves + diagonalMoves
	return allMoves

func getPawnForwardMoves():
	var allMoves = []
	if isWhite and tile.canTileBeShiftedBy( 0, 1 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy(0, 1) )
		if (not hasPieceMoved()) and tile.canTileBeShiftedBy( 0, 2 ):
			allMoves.push_back( tile.getCoordsInArrayShiftedBy(0, 2) )
	elif tile.canTileBeShiftedBy( 0, -1 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy(0, -1) )
		if (not hasPieceMoved()) and tile.canTileBeShiftedBy( 0, -2 ):
			allMoves.push_back( tile.getCoordsInArrayShiftedBy(0, -2) )
	return allMoves

func getPawnDiagonalMoves():
	var allMoves = []
	if isWhite:
		if tile.canTileBeShiftedBy( 1, 1 ):
			allMoves.push_back( tile.getCoordsInArrayShiftedBy(1, 1) )
		if tile.canTileBeShiftedBy( -1, 1 ):
			allMoves.push_back( tile.getCoordsInArrayShiftedBy(-1, 1) )
	else:
		if tile.canTileBeShiftedBy( 1, -1 ):
			allMoves.push_back( tile.getCoordsInArrayShiftedBy(1, -1) )
		if tile.canTileBeShiftedBy( -1, -1 ):
			allMoves.push_back( tile.getCoordsInArrayShiftedBy(-1, -1) )
	return allMoves

func getRookHorizontalMoves():
	var allMoves = []
	var shift = -1
	while tile.canTileBeShiftedBy( shift, 0 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( shift, 0 ) )
		shift -= 1
	shift = 1
	while tile.canTileBeShiftedBy( shift, 0 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( shift, 0 ) )
		shift += 1
	return allMoves

func getRookVerticalMoves():
	var allMoves = []
	var shift = -1
	while tile.canTileBeShiftedBy( 0, shift ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( 0, shift ) )
		shift -= 1
	shift = 1
	while tile.canTileBeShiftedBy( 0, shift ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( 0, shift ) )
		shift += 1
	return allMoves

func getKnightLongHorizontalMoves():
	var allMoves = []
	if tile.canTileBeShiftedBy( 2, 1 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( 2, 1 ) )
	if tile.canTileBeShiftedBy( 2, -1 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( 2, -1 ) )
	if tile.canTileBeShiftedBy( -2, 1 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( -2, 1 ) )
	if tile.canTileBeShiftedBy( -2, -1 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( -2, -1 ) )
	return allMoves

func getKnightLongVerticalMoves():
	var allMoves = []
	if tile.canTileBeShiftedBy( 1, 2 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( 1, 2 ) )
	if tile.canTileBeShiftedBy( 1, -2 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( 1, -2 ) )
	if tile.canTileBeShiftedBy( -1, 2 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( -1, 2 ) )
	if tile.canTileBeShiftedBy( -1, -2 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( -1, -2 ) )
	return allMoves

func getBishopLeftDiagonals():
	var allMoves = []
	var iterator = -1
	while tile.canTileBeShiftedBy( iterator, iterator ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( iterator, iterator ) )
		iterator -= 1
	iterator = -1
	while tile.canTileBeShiftedBy( iterator, -iterator ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( iterator, -iterator ) )
		iterator -= 1
	return allMoves

func getBishopRightDiagonals():
	var allMoves = []
	var iterator = 1
	while tile.canTileBeShiftedBy( iterator, iterator ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( iterator, iterator ) )
		iterator += 1
	iterator = 1
	while tile.canTileBeShiftedBy( iterator, -iterator ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( iterator, -iterator ) )
		iterator += 1
	return allMoves

func getKingStraightMoves():
	var allMoves = []
	if tile.canTileBeShiftedBy( 1, 0 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( 1, 0 ) )
	if tile.canTileBeShiftedBy( -1, 0 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( -1, 0 ) )
	if tile.canTileBeShiftedBy( 0, 1 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( 0, 1 ) )
	if tile.canTileBeShiftedBy( 0, -1 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( 0, -1 ) )
	return allMoves

func getKingDiagonalMoves():
	var allMoves = []
	if tile.canTileBeShiftedBy( 1, 1 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( 1, 1 ) )
	if tile.canTileBeShiftedBy( -1, 1 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( -1, 1 ) )
	if tile.canTileBeShiftedBy( 1, -1 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( 1, -1 ) )
	if tile.canTileBeShiftedBy( -1, -1 ):
		allMoves.push_back( tile.getCoordsInArrayShiftedBy( -1, -1 ) )
	return allMoves

func getKingRochadeMoves():
	var possibleMoves = []
	if not hasPieceMoved:
		var yPoint = 0 if isWhite else 7
		possibleMoves.push_back( [tile.getLetterFromIndex(0), tile.getNumberFromIndex(yPoint)] )
		possibleMoves.push_back( [tile.getLetterFromIndex(7), tile.getNumberFromIndex(yPoint)] )
	return possibleMoves
	

func isColor( color ):
	return color == isWhite

func isKing():
	return pieceType == PieceConstantsPath.PieceType.King

func SetMovedIfNotSetAlready():
	if not hasPieceMoved:
		hasPieceMoved = true

func hasPieceMoved():
	return hasPieceMoved
