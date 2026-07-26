class_name Unit
extends Node2D

@export var Team := Combat.Team.PLAYER

@onready var animated_sprite = $AnimatedSprite2D

# position (please move unit by calling MoveUnit in Navigation)
@export var X = 0:
	set(new_value):
		X = new_value
		_on_position_updated()
@export var Y = 0:
	set(new_value):
		Y = new_value
		_on_position_updated()

@export var HP = 100:
	set(new_value):
		HP = new_value
		if not find_child("HP_Bar"):
			return
		if $HP_Bar/ProgressBar.max_value < HP:
			$HP_Bar/ProgressBar.max_value = HP
		$HP_Bar/ProgressBar.value = new_value
		if HP <= 0:
			die()

#@export var Species := Combat.UnitSpecies.INFANTRY

@export var Type := Combat.UnitTypes.Swarm

@export var DAMAGE_TO_TYPES := [50, 50, 25]

@export var move_range = 4

@export var min_attack_range = 1

@export var max_attack_range = 1

@export var moved = false

@export var lifetime := 5

func get_pos() -> Vector2i:
	return Vector2i(X, Y)

func move_to(target: Vector2i):
	var path = Navigation.instance.pathfind(self, target)
	Navigation.instance.visual_path_line2d.global_position = Vector2(Navigation.tile_size/2.0, Navigation.tile_size/2.0)
	Navigation.instance.visual_path_line2d.points = path # display the path
	path.remove_at(0) #remove the first step on the path, since we are already there
	
	for step in path: #wait briefly and then move to the next step on the path
		await get_tree().create_timer(0.25).timeout
		
		# 1. Convert pixel step to grid coordinates
		var next_x = int(step.x / Navigation.tile_size)
		var next_y = int(step.y / Navigation.tile_size)
		
		# 2. Calculate direction from CURRENT grid position (X, Y)
		var dir_x = next_x - X
		var dir_y = next_y - Y
		# print("called")
		if dir_x < 0:
			animated_sprite.rotation_degrees = -90
			print("right")
		elif dir_x > 0:
			animated_sprite.rotation_degrees = 90
			print("left")
		elif dir_y > 0:
			animated_sprite.rotation_degrees = -180
			print("down")
		elif dir_y < 0:
			animated_sprite.rotation_degrees = 0
			print("up")
		
		# 4. Move the unit (this updates X and Y for the NEXT iteration)
		Navigation.moveUnit(X, Y, next_x, next_y)
		animated_sprite.play("walk")
		
	animated_sprite.play("idle")
	Events.move_animation_ended.emit()

func _on_position_updated() -> void:
	position.x = X * Navigation.tile_size
	position.y = Y * Navigation.tile_size

func finished_move():
	moved = true
	Selection.middle_of_move = false
	Selection.is_attacking = false
	UI.instance.hide_ui()

func _ready() -> void:
	_on_position_updated()
	Navigation.grid[X][Y] = self
	Navigation.units.append(self)
	
	$HP_Bar/ProgressBar.max_value = HP
	$HP_Bar/ProgressBar.value = HP
	
	#example of pathfinding
	#move_to(Vector2i(6,4))
	
func ifIWasBlueIDie(enable: bool = true) -> void:
	if enable:
		modulate = Color(0.3, 0.5, 1.0, 0.6)
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)

func die() -> void:
	if Team != Combat.Team.PLAYER:
		Selection.player_pennies += 100
	Navigation.grid[X][Y] = null
	Navigation.units.erase(self)
	queue_free()
