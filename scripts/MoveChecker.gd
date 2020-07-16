#var PointScript = preload( "res://scripts/Point.gd" )
#var PieceConstantsPath = preload( "res://scripts/PieceConstants.gd" )
#var TilePath = preload( "res://scripts/Tile.gd" )
#var PieceScript = preload( "res://scripts/Piece.gd" )

class_name MoveChecker

static func canHeldPieceMoveToTile( tile, piece, board ):
	var pieceMoves = piece.getAllPossibleMovesOnBoard( board )
	var tileCoords = tile.getCoordsInArray()
	
	print_debug(pieceMoves)
	if( tileCoords in pieceMoves ):
		return true
	return false

static func isPlayerMakingRochade( tile, piece, isWhiteMove ):
	var isAttackingOtherPiece = tile.hasPiece() and tile.getPiece() != piece
	var isAttackingSelf = isAttackingOtherPiece and tile.getPiece().isColor( isWhiteMove )
	if( isAttackingSelf ):
		return true
	return false
