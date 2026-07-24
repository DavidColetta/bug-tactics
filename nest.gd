extends Node2D

@export var X = 0
@export var Y = 0

@export var HP = 100:
	set(new_value):
		HP = new_value
		$HP_Bar/ProgressBar.value = new_value

func get_pos() -> Vector2i:
	return Vector2i(X, Y)

func _ready() -> void:
	position.x = X * Navigation.tile_size
	position.y = Y * Navigation.tile_size
	#Navigation.grid[X][Y] = self
	#Navigation.units.append(self)
	
	$HP_Bar/ProgressBar.value = HP
