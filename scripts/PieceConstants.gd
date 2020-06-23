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

static func getMouseScaledPos( mousepos ):
	var x_scale = 512.0/720.0
	var y_scale = 512.0/565.0
	mousepos.x *= x_scale
	mousepos.y *= y_scale
	return mousepos
