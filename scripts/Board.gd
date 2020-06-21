extends Node2D

#board size is 512 px, one tile is 64px wide (square)
var tileWidth
var whiteRowHeight
var blackRowHeight
var TileScript 
var PieceScene
var PointScript
var PieceConstantsPath
var board

func init():
	loadScripts()
	initVariables()
	initBoard()
	loadPieces()

func initVariables():
	tileWidth = 64
	whiteRowHeight = 448
	blackRowHeight = 0

func loadScripts():
	TileScript = preload( "res://scripts/Tile.gd" )
	PieceScene = preload( "res://Piece.tscn" )
	PieceConstantsPath = preload( "res://scripts/PieceConstants.gd" )
	PointScript = preload( "res://scripts/Point.gd" )

func onPieceDrop():
	pass

func initBoard():
	board = [
		initFirstRow( PieceConstantsPath.PieceColor.Black ),
		initSecondRow( PieceConstantsPath.PieceColor.Black ),
		initBlankRow(),
		initBlankRow(),
		initBlankRow(),
		initBlankRow(),
		initSecondRow ( PieceConstantsPath.PieceColor.White ),
		initFirstRow( PieceConstantsPath.PieceColor.White )
	]

func initFirstRow( isWhite ):
	var row = []
	for i in range( 8 ):
		var point = createFirstRowPoint( i, isWhite )
		var piece = getPieceForGivenColumnFirstRow( i, point, isWhite )
		row.push_back( piece )
	return row

func getPieceForGivenColumnFirstRow( column, point, isWhite ):
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
	piece.init( point, isWhite, pieceType )
	return piece

func initSecondRow( isWhite ):
	var row = []
	for i in range( 8 ):
		var point = createSecondRowPoint( i, isWhite )
		var pawn = createPawn( point, isWhite )
		row.push_back( pawn )
	return row

func initBlankRow():
	return [null, null, null, null, null, null, null, null]

func createSecondRowPoint( i, isWhite ):
	var rowHeight = 0
	if( isWhite ):
		rowHeight = whiteRowHeight - tileWidth
	else:
		rowHeight = blackRowHeight + tileWidth
	var point = PointScript.new( i*tileWidth + tileWidth/2, rowHeight + tileWidth/2 )
	return point

func createFirstRowPoint( i, isWhite ):
	var rowHeight = 0
	if( isWhite ):
		rowHeight = whiteRowHeight
	else:
		rowHeight = blackRowHeight
	var point = PointScript.new( i*tileWidth + tileWidth/2, rowHeight + tileWidth/2 )
	return point

func createPawn( point, isWhite ):
	var piece = PieceScene.instance()
	var pieceType = PieceConstantsPath.PieceType.Pawn
	piece.init( point, isWhite, pieceType )
	return piece

func loadPieces():
	for row in board:
		for piece in row:
			if( piece != null ):
				add_child(piece)
