enum PieceColor {
	Black = 0,
	 White = 1
	}

enum PieceType {
		Pawn,
		Rook,
		Knight,
		Bishop,
		Queen,
		King
}

const rowNumbers = [ 1, 2, 3, 4, 5, 6, 7, 8 ]
const columnLetters = [ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' ]
	
static func getMouseScaledPos( mousepos ):
	var x_scale = 512.0/720.0
	var y_scale = 512.0/565.0
	mousepos.x *= x_scale
	mousepos.y *= y_scale
	return mousepos
