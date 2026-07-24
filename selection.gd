class_name Selection
extends Node

static var selected_unit: Unit

static var is_player_turn := true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Get click position local to the tilemap (which tilemap doesn't matter)
		var local_pos = $Navigation.obstacles_tilemap.get_local_mouse_position()
		var cell_coords = $Navigation.obstacles_tilemap.local_to_map(local_pos)
		
		
		selected_unit = Navigation.getUnitAtPosition(cell_coords.x, cell_coords.y)
		if selected_unit:
			print("Selected "+selected_unit.name)
			Navigation.instance.highlight_tiles_in_range(selected_unit.get_pos(), selected_unit.move_range)
		else:
			print("Selected empty")
			Navigation.instance.unhighlight_tiles()

func _ready() -> void:
	is_player_turn = true
	selected_unit = null
