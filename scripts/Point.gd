class_name Point

var top_left_x
var top_left_y

func _init( t_top_left_x = 0, t_top_left_y = 0 ):
	self.top_left_x = t_top_left_x
	self.top_left_y = t_top_left_y

func get_left_top_x():
	return self.top_left_x

func get_left_top_y():
	return self.top_left_y
