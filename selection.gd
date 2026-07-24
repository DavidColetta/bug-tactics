class_name Selection
extends Node

static var selected_unit: Unit

static var is_player_turn := true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# clicking on a highlighted tile should take precedence over clicking on a unit
		var highlights_local_pos = $Navigation.highlights_tilemap.get_local_mouse_position()
		var highlights_cell_coords = $Navigation.highlights_tilemap.local_to_map(highlights_local_pos)
		var cell_highlighted = $Navigation.highlights_tilemap.get_cell_tile_data(highlights_cell_coords) != null
		
		# Get click position local to the tilemap (which tilemap doesn't matter)
		var obstacles_local_pos = $Navigation.obstacles_tilemap.get_local_mouse_position()
		var obstacles_cell_coords = $Navigation.obstacles_tilemap.local_to_map(obstacles_local_pos)
		
		var new_selected_unit = Navigation.getUnitAtPosition(obstacles_cell_coords.x, obstacles_cell_coords.y)
		if cell_highlighted and selected_unit.is_player_team:
			print("Selected highlighted cell")
			selected_unit.move_to(highlights_cell_coords)
			Navigation.instance.unhighlight_tiles()
			await Events.move_animation_ended
			$UI/ActionMenu.visible = true
		elif new_selected_unit:
			selected_unit = new_selected_unit
			print("Selected "+selected_unit.name)
			Navigation.instance.highlight_tiles_in_range(selected_unit.get_pos(), selected_unit.move_range)
			Events.unit_clicked.emit(selected_unit)
		else:
			print("Selected empty")
			Navigation.instance.unhighlight_tiles()
			Events.empty_clicked.emit()

func _ready() -> void:
	is_player_turn = true
	selected_unit = null
