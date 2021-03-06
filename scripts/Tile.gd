class_name Tile

var PointScript
var point
var piece
var width
var height
var horizontalNumber
var verticalLetter
var PieceConstantsPath

func _init( top_left_x, top_left_y, t_horizontalNumber, t_verticalLetter,
			 t_width, t_height, t_piece = null ):
	loadScripts()
	setPiece( t_piece )
	setPointCoords( top_left_x, top_left_y )
	setTileSize( t_width, t_height )
	setTileSigns( t_horizontalNumber, t_verticalLetter )
	
func setTileSigns( t_horizontalNumber, t_verticalLetter ):
	horizontalNumber = t_horizontalNumber
	verticalLetter = t_verticalLetter

func setPointCoords( top_left_x, top_left_y ):
	setPoint(Point.new( top_left_x, top_left_y ))

func setPoint( t_point ):
	point = t_point

func getPoint():
	return point

func setPiece( t_piece ):
	piece = t_piece

func removePiece():
	piece = null

func hasPiece():
	if ( piece != null ):
		return true
	return false

func getPiece():
	return piece

func loadScripts():
	pass
	#PieceConstantsPath = preload( "res://scripts/PieceConstants.gd" )
	#PointScript = preload( "res://scripts/Point.gd" )

func setTileSize( t_width, t_height ):
	width = t_width
	height = t_height

func isPointInsideTile( t_point ):
	if(isPointInsideVertically( t_point ) and isPointInsideHorizontally( t_point )):
		return true
	return false
	
func isPointInsideVertically( t_point ):
	var self_y = point.get_left_top_y()
	var passed_y = t_point.get_left_top_y() 
	if( passed_y > self_y and passed_y < ( self_y + height ) ):
		return true
	return false

func isPointInsideHorizontally( t_point ):
	var self_x = point.get_left_top_x()
	var passed_x = t_point.get_left_top_x() 
	if( passed_x > self_x and passed_x < ( self_x + width ) ):
		return true
	return false

func getCoordsInArray():
	return [ verticalLetter, horizontalNumber ]

func canTileBeShiftedBy( shift_x, shift_y ):
	var letterColumnIndex = getArrayIndexFromLetterColumn()
	var numberRowIndex = getArrayIndexFromNumberRow()
	var newLetterIndex = letterColumnIndex + shift_x
	var newNumberIndex = numberRowIndex + shift_y
	if (newLetterIndex < 0 or newLetterIndex > 7 
		or newNumberIndex < 0 or newNumberIndex > 7):
			return false
	return true

func getCoordsInArrayShiftedBy( shift_x, shift_y ):
	var letterColumnIndex = getArrayIndexFromLetterColumn()
	var rowNumberIndex = getArrayIndexFromNumberRow()
	letterColumnIndex += shift_x
	rowNumberIndex += shift_y
	var letter = getLetterFromIndex( letterColumnIndex )
	var number = getNumberFromIndex( rowNumberIndex )
	return [ letter, number ]

func getArrayIndexFromLetterColumn( vLetter = "" ):
	if vLetter == "":
		vLetter = verticalLetter
	return PieceConstants.columnLetters.find( vLetter )

func getArrayIndexFromNumberRow( hNumber = -1 ):
	if hNumber == -1:
		hNumber = horizontalNumber
	return PieceConstants.rowNumbers.find( hNumber )

func getLetterFromIndex( letterIndex ):
	return PieceConstants.columnLetters[ letterIndex ]

func getNumberFromIndex( numberIndex ):
	return PieceConstants.rowNumbers[ numberIndex ]
