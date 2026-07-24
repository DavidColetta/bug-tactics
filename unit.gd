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

#unit stats
var unit_name = "Ant"
var health = 10
var life_span = 4
var movement_type = "Swarm"
var num_moves = 3
var vision = 2

func get_pos() -> Vector2i:
	return Vector2i(X, Y)

func move_to(target: Vector2i):
	var path = Navigation.instance.pathfind(get_pos(), target)
	Navigation.instance.visual_path_line2d.points = path # display the path
	path.remove_at(0) #remove the first step on the path, since we are already there
	
	for step in path: #wait briefly and then move to the next step on the path
		await get_tree().create_timer(0.25).timeout
		Navigation.moveUnit(X, Y, step.x/Navigation.tile_size, step.y/Navigation.tile_size)

func _on_position_updated() -> void:
	position.x = X * Navigation.tile_size
	position.y = Y * Navigation.tile_size
	
	if Navigation.instance and Selection.selected_unit == self:
		Navigation.instance.highlight_tiles_in_range(get_pos(), 5)

func _ready() -> void:
	_on_position_updated()
	Navigation.grid[X][Y] = self
	
	#example of pathfinding
	move_to(Vector2i(7,6))
