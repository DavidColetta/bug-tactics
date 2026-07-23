class_name Unit
extends Node2D

# position (please move unit by calling MoveUnit in Navigation)
@export var X = 0:
	set(new_value):
		X = new_value
		_on_position_updated()
@export var Y = 0:
	set(new_value):
		Y = new_value
		_on_position_updated()

func get_pos() -> Vector2i:
	return Vector2i(X, Y)

func _on_position_updated() -> void:
	position.x = X * Navigation.tile_size
	position.y = Y * Navigation.tile_size

func _ready() -> void:
	_on_position_updated()
	Navigation.grid[X][Y] = self
	
	#example of pathfinding
	Navigation.instance.pathfind(self, Vector2i(2,6))
