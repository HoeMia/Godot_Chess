extends KinematicBody2D

class_name Piece

var PointScript
var TileScript
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
	point = Point.new( 0, 0 )
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

func getAllPossibleMovesOnBoard( board ):
	match( pieceType ):
		PieceConstantsPath.PieceType.Pawn:
			return getPawnAllPossibleMovesOnBoard( board )
		PieceConstantsPath.PieceType.Rook:
			return getRookAllPossibleMovesOnBoard( board )
		PieceConstantsPath.PieceType.Knight:
			return getKnightAllPossibleMovesOnBoard( board )
		PieceConstantsPath.PieceType.Bishop:
			return getBishopAllPossibleMovesOnBoard( board )
		PieceConstantsPath.PieceType.Queen:
			return getQueenAllPossibleMovesOnBoard( board )
		PieceConstantsPath.PieceType.King:
			return getKingAllPossibleMovesOnBoard( board )

func getPawnAllPossibleMovesOnBoard( board ):
	var forwardMoves = getPawnForwardMovesOnBoard( board )
	var diagonalMoves = getPawnDiagonalMovesOnBoard( board )
	var allMoves = forwardMoves + diagonalMoves
	return allMoves

func getRookAllPossibleMovesOnBoard( board ):
	var horizontalMoves = getRookHorizontalMovesOnBoard( board )
	var verticalMoves = getRookVerticalMovesOnBoard( board )
	var allMoves = horizontalMoves + verticalMoves
	return allMoves

func getKnightAllPossibleMovesOnBoard( board ):
	var longHorizontalMoves = getKnightLongHorizontalMovesOnBoard( board )
	var longVerticalMoves = getKnightLongVerticalMovesOnBoard( board )
	var allMoves = longHorizontalMoves + longVerticalMoves
	return allMoves

func getBishopAllPossibleMovesOnBoard( board ):
	var leftDiagonals = getBishopLeftDiagonalsOnBoard( board )
	var rightDiagonals = getBishopRightDiagonalsOnBoard( board )
	var allMoves = leftDiagonals + rightDiagonals
	return allMoves

func getQueenAllPossibleMovesOnBoard( board ):
	var diagonalMoves = getBishopAllPossibleMovesOnBoard( board )
	var straightMoves = getRookAllPossibleMovesOnBoard( board )
	var allMoves = diagonalMoves + straightMoves
	return allMoves

func getKingAllPossibleMovesOnBoard( board ):
	var straightMoves = getKingStraightMovesOnBoard( board )
	var diagonalMoves = getKingDiagonalMovesOnBoard( board )
	var rochadeMoves = getKingRochadeMovesOnBoard( board )
	var allMoves = straightMoves + diagonalMoves + rochadeMoves
	return allMoves

func getPawnForwardMovesOnBoard( board ):
	var allMoves = []
	var newTileCoords
	if isWhite:
		if tile.canTileBeShiftedBy( 0, 1 ):
			newTileCoords = tile.getCoordsInArrayShiftedBy(0, 1)
			if isTileOnBoardFree( newTileCoords, board ):
				allMoves.push_back( newTileCoords )
		if (not hasPieceMoved()) and tile.canTileBeShiftedBy( 0, 2 ):
			newTileCoords = tile.getCoordsInArrayShiftedBy(0, 2)
			if isTileOnBoardFree( newTileCoords, board ):
				allMoves.push_back( newTileCoords )
	else:
		if tile.canTileBeShiftedBy( 0, -1 ):
			newTileCoords = tile.getCoordsInArrayShiftedBy(0, -1)
			if isTileOnBoardFree( newTileCoords, board ):
				allMoves.push_back( newTileCoords )
		if (not hasPieceMoved()) and tile.canTileBeShiftedBy( 0, -2 ):
			newTileCoords = tile.getCoordsInArrayShiftedBy(0, -2)
			if isTileOnBoardFree( newTileCoords, board ):
				allMoves.push_back( newTileCoords )
	return allMoves

func getPawnDiagonalMovesOnBoard( board ):
	var allMoves = []
	var tileCoords
	if isWhite:
		if tile.canTileBeShiftedBy( 1, 1 ):
			tileCoords = tile.getCoordsInArrayShiftedBy(1, 1)
			if isEnemyOnTile( tileCoords, board ):
				allMoves.push_back( tileCoords )
		if tile.canTileBeShiftedBy( -1, 1 ):
			tileCoords = tile.getCoordsInArrayShiftedBy(-1, 1)
			if isEnemyOnTile( tileCoords, board ):
				allMoves.push_back( tileCoords )
	else:
		if tile.canTileBeShiftedBy( 1, -1 ):
			tileCoords = tile.getCoordsInArrayShiftedBy(1, -1)
			if isEnemyOnTile( tileCoords, board ):
				allMoves.push_back( tileCoords )
		if tile.canTileBeShiftedBy( -1, -1 ):
			tileCoords = tile.getCoordsInArrayShiftedBy(-1, -1)
			if isEnemyOnTile( tileCoords, board ):
				allMoves.push_back( tileCoords )
	return allMoves

func getRookHorizontalMovesOnBoard( board ):
	var allMoves = []
	var shift = -1
	var tileCoords
	while tile.canTileBeShiftedBy( shift, 0 ):
		tileCoords = tile.getCoordsInArrayShiftedBy( shift, 0 )
		if (isTileOnBoardFree( tileCoords, board )
		 or isEnemyOnTile( tileCoords, board )
		 or (isOwnKingOnTile( tileCoords, board ) and isRook())):
			allMoves.push_back( tileCoords )
			if isEnemyOnTile( tileCoords, board ) or isOwnKingOnTile( tileCoords, board ):
				break
		else:
			break
		shift -= 1
	shift = 1
	while tile.canTileBeShiftedBy( shift, 0 ):
		tileCoords = tile.getCoordsInArrayShiftedBy( shift, 0 )
		if (isTileOnBoardFree( tileCoords, board )
		 or isEnemyOnTile( tileCoords, board )
		 or (isOwnKingOnTile( tileCoords, board ) and isRook())):
			allMoves.push_back( tileCoords )
			if isEnemyOnTile( tileCoords, board ) or isOwnKingOnTile( tileCoords, board ):
				break
		else:
			break
		shift += 1
	return allMoves

func getRookVerticalMovesOnBoard( board ):
	var allMoves = []
	var shift = -1
	var tileCoords
	while tile.canTileBeShiftedBy( 0, shift ):
		tileCoords = tile.getCoordsInArrayShiftedBy( 0, shift )
		if isTileOnBoardFree( tileCoords, board ) or isEnemyOnTile( tileCoords, board ):
			allMoves.push_back( tileCoords )
			if isEnemyOnTile( tileCoords, board ):
				break
		else:
			break
		shift -= 1
	shift = 1
	while tile.canTileBeShiftedBy( 0, shift ):
		tileCoords = tile.getCoordsInArrayShiftedBy( 0, shift )
		if isTileOnBoardFree( tileCoords, board ) or isEnemyOnTile( tileCoords, board ):
			allMoves.push_back( tileCoords )
			if isEnemyOnTile( tileCoords, board ):
				break
		else:
			break
		shift += 1
	return allMoves

func getKnightLongHorizontalMovesOnBoard( board ):
	var allMoves = []
	var tileCoords
	var coordsShifts = [ [2, 1], [2, -1], [-2, 1], [-2, -1] ]
	for shifts in coordsShifts:
		if tile.canTileBeShiftedBy(shifts[0], shifts[1] ):
			tileCoords = tile.getCoordsInArrayShiftedBy( shifts[0], shifts[1] )
			if isTileOnBoardFree( tileCoords, board ) or isEnemyOnTile( tileCoords, board ):
				allMoves.push_back( tileCoords )
	return allMoves

func getKnightLongVerticalMovesOnBoard( board ):
	var allMoves = []
	var tileCoords
	var coordsShifts = [ [1, 2], [1, -2], [-1, 2], [-1, -2] ]
	for shifts in coordsShifts:
		if tile.canTileBeShiftedBy(shifts[0], shifts[1] ):
			tileCoords = tile.getCoordsInArrayShiftedBy( shifts[0], shifts[1] )
			if isTileOnBoardFree( tileCoords, board ) or isEnemyOnTile( tileCoords, board ):
				allMoves.push_back( tileCoords )
	return allMoves

func getBishopLeftDiagonalsOnBoard( board ):
	var allMoves = []
	var iterator = -1
	var tileCoords
	while tile.canTileBeShiftedBy( iterator, iterator ):
		tileCoords = tile.getCoordsInArrayShiftedBy( iterator, iterator )
		if isTileOnBoardFree( tileCoords, board ) or isEnemyOnTile( tileCoords, board ):
			allMoves.push_back( tileCoords )
			iterator -= 1
		else:
			break
	iterator = -1
	while tile.canTileBeShiftedBy( iterator, -iterator ):
		tileCoords = tile.getCoordsInArrayShiftedBy( iterator, -iterator )
		if isTileOnBoardFree( tileCoords, board ) or isEnemyOnTile( tileCoords, board ):
			allMoves.push_back( tileCoords )
			iterator -= 1
		else:
			break
	return allMoves

func getBishopRightDiagonalsOnBoard( board ):
	var allMoves = []
	var iterator = 1
	var tileCoords
	while tile.canTileBeShiftedBy( iterator, iterator ):
		tileCoords = tile.getCoordsInArrayShiftedBy( iterator, iterator )
		if isTileOnBoardFree( tileCoords, board ) or isEnemyOnTile( tileCoords, board ):
			allMoves.push_back( tileCoords )
			iterator += 1
		else:
			break
	iterator = 1
	while tile.canTileBeShiftedBy( iterator, -iterator ):
		tileCoords = tile.getCoordsInArrayShiftedBy( iterator, -iterator )
		if isTileOnBoardFree( tileCoords, board ) or isEnemyOnTile( tileCoords, board ):
			allMoves.push_back( tileCoords )
			iterator += 1
		else:
			break
	return allMoves

func getKingStraightMovesOnBoard( board ):
	var allMoves = []
	var tileCoords
	var straightMovesIndexes = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]
	for straightMove in straightMovesIndexes:
		if tile.canTileBeShiftedBy( straightMove[0], straightMove[1] ):
			tileCoords = tile.getCoordsInArrayShiftedBy( straightMove[0], straightMove[1] )
			if isTileOnBoardFree( tileCoords, board ) or isEnemyOnTile( tileCoords, board ):
				allMoves.push_back( tileCoords )
	return allMoves

func getKingDiagonalMovesOnBoard( board ):
	var allMoves = []
	var tileCoords
	var straightMovesIndexes = [ [1, 1], [-1, 1], [1, -1], [-1, -1] ]
	for straightMove in straightMovesIndexes:
		if tile.canTileBeShiftedBy( straightMove[0], straightMove[1] ):
			tileCoords = tile.getCoordsInArrayShiftedBy( straightMove[0], straightMove[1] )
			if isTileOnBoardFree( tileCoords, board ) or isEnemyOnTile( tileCoords, board ):
				allMoves.push_back( tileCoords )
	return allMoves

func getKingRochadeMovesOnBoard( board ):
	var possibleMoves = []
	if not hasPieceMoved:
		var yPoint = 0 if isWhite else 7
		if( not isSomethingBetweenPieceAndCoords( 0, yPoint, board ) and isOwnRookAt( 0, yPoint, board )):
			possibleMoves.push_back( [tile.getLetterFromIndex(0), tile.getNumberFromIndex(yPoint)] )
		if( not isSomethingBetweenPieceAndCoords( 7, yPoint, board ) and isOwnRookAt( 7, yPoint, board )):
			possibleMoves.push_back( [tile.getLetterFromIndex(7), tile.getNumberFromIndex(yPoint)] )
	return possibleMoves
	

func isColor( color ):
	return color == isWhite

func isKing():
	return pieceType == PieceConstantsPath.PieceType.King

func isRook():
	return pieceType == PieceConstantsPath.PieceType.Rook

func isSomethingBetweenPieceAndCoords( xCoord, yCoord, board ):
	var pieceLetterIndex = tile.getArrayIndexFromLetterColumn()
	var pieceNumberIndex = tile.getArrayIndexFromNumberRow()
	var xDiff = xCoord - pieceLetterIndex
	var yDiff = yCoord - pieceNumberIndex
	if abs( xDiff ) == 1 and abs( yDiff ) == 1:
		return false
	var xDirection = 1 if xDiff > 0 else -1
	var yDirection = 1 if yDiff > 0 else -1
	var startingX = pieceLetterIndex + xDirection
	var startingY = pieceNumberIndex + yDirection
	while startingX != xCoord and startingY != yCoord:
		if board[startingX][startingY].hasPiece():
			return true
		startingX += xDirection
		startingY += yDirection
	return false

func isOwnRookAt( xCoord, yCoord, board ):
	var coordsTile = board[xCoord][yCoord]
	if coordsTile.hasPiece() and coordsTile.getPiece().isRook() and coordsTile.getPiece().isColor( isWhite ):
		return true
	return false

func SetMovedIfNotSetAlready():
	if not hasPieceMoved:
		hasPieceMoved = true

func hasPieceMoved():
	return hasPieceMoved

func isTileOnBoardFree( newTileCoords, board ):
	var letterIndex = tile.getArrayIndexFromLetterColumn( newTileCoords[0] )
	var numberIndex = tile.getArrayIndexFromNumberRow( newTileCoords[1] )
	if getTileOnBoardFromArrayIndexes(letterIndex, numberIndex, board).hasPiece():
		return false
	return true

func isEnemyOnTile( tileCoords, board ):
	var letterIndex = tile.getArrayIndexFromLetterColumn( tileCoords[0] )
	var numberIndex = tile.getArrayIndexFromNumberRow( tileCoords[1] )
	var tileOnBoard = getTileOnBoardFromArrayIndexes(letterIndex, numberIndex, board)
	if (tileOnBoard.hasPiece() and not tileOnBoard.getPiece().isColor( isWhite )
	and not tileOnBoard.getPiece().isKing()):
		return true
	return false

func isOwnKingOnTile( tileCoords, board ):
	var letterIndex = tile.getArrayIndexFromLetterColumn( tileCoords[0] )
	var numberIndex = tile.getArrayIndexFromNumberRow( tileCoords[1] )
	var tileOnBoard = getTileOnBoardFromArrayIndexes(letterIndex, numberIndex, board)
	if tileOnBoard.hasPiece() and tileOnBoard.getPiece().isColor( isWhite ) and tileOnBoard.getPiece().isKing():
		return true
	return false

func getTileOnBoardFromArrayIndexes(letterIndex, numberIndex, board):
	return board[7 - numberIndex][letterIndex]
