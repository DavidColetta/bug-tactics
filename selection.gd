class_name Selection
extends Node

static var selected_unit: Unit
static var prev_position: Vector2i
static var middle_of_move := false:
	set(mid):
		middle_of_move = mid
		if middle_of_move:
			EndTurn.instance.disabled = true
		else:
			EndTurn.instance.disabled = false
static var is_player_turn := true

static var selected_nest: Nest

func back_button_pressed(btn_idx: int):
	if ActionMenu.instance.get_item_text(btn_idx) == "Back":
		Navigation.moveUnit(selected_unit.X, selected_unit.Y, prev_position.x, prev_position.y)
		Navigation.instance.highlight_tiles_in_range(selected_unit, selected_unit.move_range)
		middle_of_move = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if middle_of_move: # if you're already moving a unit, you can't select a new one
			return
		
		# clicking on a highlighted tile should take precedence over clicking on a unit
		var highlights_local_pos = $Navigation.highlights_tilemap.get_local_mouse_position()
		var highlights_cell_coords = $Navigation.highlights_tilemap.local_to_map(highlights_local_pos)
		var cell_highlighted = $Navigation.highlights_tilemap.get_cell_tile_data(highlights_cell_coords) != null
		
		# Get click position local to the tilemap (which tilemap doesn't matter)
		var obstacles_local_pos = $Navigation.obstacles_tilemap.get_local_mouse_position()
		var obstacles_cell_coords = $Navigation.obstacles_tilemap.local_to_map(obstacles_local_pos)
		
		var new_selected_unit = Navigation.getUnitAtPosition(obstacles_cell_coords.x, obstacles_cell_coords.y)
		var new_selected_nest = Navigation.getNestAtPosition(obstacles_cell_coords.x, obstacles_cell_coords.y)

		if cell_highlighted and selected_unit.Team == Combat.Team.PLAYER and is_player_turn:
			print("Selected highlighted cell")
			prev_position = selected_unit.get_pos()
			selected_unit.move_to(highlights_cell_coords)
			middle_of_move = true
			Navigation.instance.unhighlight_tiles()
			if highlights_cell_coords != selected_unit.get_pos():
				await Events.move_animation_ended
			print("move anim ended")
			if new_selected_nest and new_selected_nest.Team != selected_unit.Team: #enable Claim action
				set_capture_btn_disabled(false)
			else:
				set_capture_btn_disabled(true)
			#check if on top of a nest that isnt on player's team
			#check if any enemies in attack range
			ActionMenu.instance.visible = true
		elif new_selected_nest and new_selected_nest.Team == Combat.Team.PLAYER and not new_selected_unit:
			selected_unit = null
			selected_nest = new_selected_nest
			print("Selected Nest "+selected_nest.name)
			$UI/ShopMenu.visible = true
		elif new_selected_unit and not new_selected_unit.moved:
			selected_nest = null
			$UI/ShopMenu.visible = false
			selected_unit = new_selected_unit
			print("Selected "+selected_unit.name)
			Navigation.instance.highlight_tiles_in_range(selected_unit, selected_unit.move_range)
			Events.unit_clicked.emit(selected_unit)
		else:
			$UI/ShopMenu.visible = false
			print("Selected empty")
			Navigation.instance.unhighlight_tiles()
			Events.empty_clicked.emit()

func _ready() -> void:
	is_player_turn = true
	selected_unit = null
	selected_nest = null
	ActionMenu.instance.item_selected.connect(back_button_pressed)
	ActionMenu.instance.item_selected.connect(capture_button_pressed)

func set_capture_btn_disabled(disabled):
	for i in ActionMenu.instance.item_count:
		if ActionMenu.instance.get_item_text(i) == "Capture":
			ActionMenu.instance.set_item_disabled(i, disabled)
			break

func can_attack():
	pass

func capture_button_pressed(btn_idx):
	if ActionMenu.instance.get_item_text(btn_idx) != "Capture":
		return
	print("capturing nest")
	var unit_pos = selected_unit.get_pos()
	var nest = Navigation.getNestAtPosition(unit_pos.x, unit_pos.y)
	nest.attack_nest(selected_unit)
	selected_unit.finished_move()

func end_turn():
	#if is_player_turn:
		#for nest in Navigation.nests:
			#if nest.Team != Combat.Team.PLAYER:
				#for unit in Navigation.units:
					#if unit.get_pos() == nest.get_pos() and unit.Team == Combat.Team.PLAYER:
						#nest.attack_nest(unit)
	#else:
		#for nest in Navigation.nests:
			#if nest.Team != Combat.Team.ENEMY:
				#for unit in Navigation.units:
					#if unit.get_pos() == nest.get_pos() and unit.Team == Combat.Team.ENEMY:
						#nest.attack_nest(unit)
	Navigation.instance.unhighlight_tiles()
	is_player_turn = !is_player_turn
	
	
