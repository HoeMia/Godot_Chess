extends Node2D

signal playerChanged
signal playerChecked
#board size is 512 px, one tile is 64px wide (square)
var tileWidth
var whiteRowHeight
var blackRowHeight
var TileScript 
var PieceScene
var PointScript
var MoveCheckerScript
var PieceConstantsPath
var board
var heldPiece
var heldTile
var isWhiteMove

func init():
	loadScripts()
	initVariables()
	initBoard()
	loadPieces()

func initVariables():
	tileWidth = 64
	whiteRowHeight = 448
	blackRowHeight = 0
	
	isWhiteMove = true

func loadScripts():
	TileScript = preload( "res://scripts/Tile.gd" )
	PieceScene = preload( "res://Piece.tscn" )
	PieceConstantsPath = preload( "res://scripts/PieceConstants.gd" )
	PointScript = preload( "res://scripts/Point.gd" )
	MoveCheckerScript = preload( "res://scripts/MoveChecker.gd" )

func onPieceDrop():
	pass

func initBoard():
	board = [
		initFirstRow( PieceConstantsPath.PieceColor.Black ),
		initSecondRow( PieceConstantsPath.PieceColor.Black ),
		initBlankRow( 5 ),
		initBlankRow( 4 ),
		initBlankRow( 3 ),
		initBlankRow( 2 ),
		initSecondRow ( PieceConstantsPath.PieceColor.White ),
		initFirstRow( PieceConstantsPath.PieceColor.White )
	]

func initFirstRow( isWhite ):
	var row = []
	for i in range( 8 ):
		var point = createFirstRowPoint( i, isWhite )
		var rowIndex = 0 if isWhite else 7
		var tile = createTileForGivenPoint( point, rowIndex, i )
		var piece = getPieceForGivenColumnFirstRow( i, tile, isWhite )
		tile.setPiece( piece )
		row.push_back( tile )
	return row

func createTileForGivenPoint( point, row, column ):
	var tile = TileScript.new( point.get_left_top_x(), point.get_left_top_y(),
	 PieceConstantsPath.rowNumbers[row], 
	PieceConstantsPath.columnLetters[column], tileWidth, tileWidth )
	return tile

func getPieceForGivenColumnFirstRow( column, tile, isWhite ):
	var piece = PieceScene.instance()
	var pieceType
	match( column ):
		0, 7:
			pieceType = PieceConstantsPath.PieceType.Rook
		1, 6:
			pieceType = PieceConstantsPath.PieceType.Knight
		2, 5:
			pieceType = PieceConstantsPath.PieceType.Bishop
		3:
			pieceType = PieceConstantsPath.PieceType.Queen
		4:
			pieceType = PieceConstantsPath.PieceType.King
	piece.init( isWhite, pieceType, tile )
	return piece

func initSecondRow( isWhite ):
	var row = []
	for i in range( 8 ):
		var point = createSecondRowPoint( i, isWhite )
		var rowIndex = 1 if isWhite else 6
		var tile = createTileForGivenPoint( point, rowIndex, i )
		var pawn = createPawn( tile, isWhite )
		tile.setPiece( pawn )
		row.push_back( tile )
	return row

func initBlankRow( rowNumber ):
	var row = []
	var point = createBlankRowFirstPoint( rowNumber )
	for i in range(8):
		var tile = createTileForGivenPoint( point, rowNumber, i )
		point.top_left_x += tileWidth
		row.push_back( tile )
	return row

func createBlankRowFirstPoint( i ):
	var rowHeight = whiteRowHeight - tileWidth*i
	var point = PointScript.new( 0, rowHeight )
	return point
	
func createSecondRowPoint( i, isWhite ):
	var rowHeight = 0
	if( isWhite ):
		rowHeight = whiteRowHeight - tileWidth
	else:
		rowHeight = blackRowHeight + tileWidth
	var point = PointScript.new( i*tileWidth, rowHeight )
	return point

func createFirstRowPoint( i, isWhite ):
	var rowHeight = 0
	if( isWhite ):
		rowHeight = whiteRowHeight
	else:
		rowHeight = blackRowHeight
	var point = PointScript.new( i*tileWidth, rowHeight )
	return point

func createPawn( tile, isWhite ):
	var piece = PieceScene.instance()
	var pieceType = PieceConstantsPath.PieceType.Pawn
	piece.init( isWhite, pieceType, tile )
	return piece

func loadPieces():
	for row in board:
		for tile in row:
			if( tile.hasPiece() ):
				add_child( tile.getPiece() )

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		var t_point = getScaledPointFromMousePosEvent( event )
		var t_tile = findClickedTile( t_point )
		if event.button_index == BUTTON_LEFT and t_tile != null:
			if event.pressed and t_tile.hasPiece() and canPlayerPickPiece( t_tile.getPiece() ):
				startMovingPiece( t_tile, event )
			elif heldPiece != null:
				dropMovingPiece( t_tile )

func getScaledPointFromMousePosEvent( event ):
	var mousepos = event.position
	var scaledMousepos = PieceConstantsPath.getMouseScaledPos( mousepos )
	var t_point = PointScript.new( scaledMousepos.x, scaledMousepos.y )
	return t_point

func startMovingPiece( t_tile, event ):
	heldTile = t_tile
	heldPiece = t_tile.getPiece()
	heldPiece.setPressed( event.pressed )

func dropMovingPiece( newTile ):
	heldPiece.setPressed( false )
	if MoveCheckerScript.canHeldPieceMoveToTile( newTile, heldPiece, board, isWhiteMove ):
		movePieceToNewTile( newTile )
		changePlayer()
		analyzeIfPlayerChecked()
	heldPiece.resetPositionToTile()
	heldTile = null
	heldPiece = null

func changePlayer():
	isWhiteMove = not( isWhiteMove )
	emitPlayerChanged()

func findClickedTile( t_point ):
	for row in board:
		for tile in row:
			if tile.isPointInsideTile( t_point ):
				print("mouse inside tile ", tile.verticalLetter, tile.horizontalNumber)
				return tile

func movePieceToNewTile( newTile ):
	heldTile.removePiece()
	newTile.setPiece( heldPiece )
	heldPiece.setTile( newTile )
	heldPiece.SetMovedIfNotSetAlready()

func canPlayerPickPiece( piece ):
	if isWhiteMove and piece.isWhite:
		return true
	if not( isWhiteMove ) and not( piece.isWhite ):
		return true
	return false

func analyzeIfPlayerChecked():
	var playerKing = getCurrnetPlayerKing()
	var attackingPieces = getPiecesAttacking( playerKing )
	if attackingPieces.size() > 0:
		emitPlayerChecked()

func getCurrnetPlayerKing():
	for row in board:
		for tile in row:
			if tile.hasPiece():
				var piece = tile.getPiece()
				var color = PieceConstantsPath.PieceColor.White if isWhiteMove else PieceConstantsPath.PieceColor.Black
				if piece.isColor( color ) and piece.isKing():
					return piece

func getPiecesAttacking( piece ):
	var attackers = []
	return []

func emitPlayerChecked():
	emit_signal( "playerChecked" )

func emitPlayerChanged():
	emit_signal( "playerChanged", isWhiteMove )
