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

func move_to(target: Vector2i):
	var path = Navigation.instance.pathfind(self, target)
	
	for step in path:
		Navigation.moveUnit(X, Y, step.x/Navigation.tile_size, step.y/Navigation.tile_size)
		await get_tree().create_timer(0.15).timeout

func _on_position_updated() -> void:
	position.x = X * Navigation.tile_size
	position.y = Y * Navigation.tile_size

func _ready() -> void:
	_on_position_updated()
	Navigation.grid[X][Y] = self
	
	#example of pathfinding
	#Navigation.instance.pathfind(self, Vector2i(7,6))
	
	move_to(Vector2i(7,6))
