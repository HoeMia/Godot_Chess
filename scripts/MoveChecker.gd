var PointScript = preload( "res://scripts/Point.gd" )
var PieceConstantsPath = preload( "res://scripts/PieceConstants.gd" )
var PieceScript = preload( "res://scripts/Piece.gd" )
var TilePath = preload( "res://scripts/Tile.gd" )

static func canHeldPieceMoveToTile( tile, piece, board, isWhiteMove ):
	var pieceMoves = piece.getAllPossibleMoves()
	var tileCoords = tile.getCoordsInArray()
	
	print_debug(pieceMoves)
	if( tileCoords in pieceMoves ):
		return true
	#get all possible moves of given piece
	#check if piee can move to tile (if the piece isn't blocked on the way)
	#check if piece is attacking other piece
	return false

static func isPlayerMakingRochade( tile, piece, isWhiteMove ):
	var isAttackingOtherPiece = tile.hasPiece() and tile.getPiece() != piece
	var isAttackingSelf = isAttackingOtherPiece and tile.getPiece().isColor( isWhiteMove )
	if( isAttackingSelf ):
		return true
	return false
