extends TextureRect

var unit: Unit:
	set(new_unit):
		unit = new_unit
		update_display()

func unit_type_to_str(unit_type):
	if unit_type == Combat.UnitTypes.Swarm:
		return "Swarm"
	elif unit_type == Combat.UnitTypes.Crawler:
		return "Crawler"
	else:
		return "Air"

func update_display():
	$VBoxContainer/UnitType.text = "Type: " + unit_type_to_str(unit.Type)
	$VBoxContainer/MoveRange.text = "Movement Range: " + str(unit.move_range)
	$VBoxContainer/AttackRange.text = "Attack Range: " + str(unit.min_attack_range)
	if unit.min_attack_range != unit.max_attack_range:
		$VBoxContainer/AttackRange.text += "-" + str(unit.max_attack_range)
	#text = "Name: " + unit.unit_name 
	#text += "\nHealth: " + str(unit.health)
	#text += "\nMovement: " + str(unit.num_moves)
	#text += "\nType: " + unit.movement_type
	#text += "\nVision: " + str(unit.vision)
	#text = "placeholder (need to update to use actual unit data)"
	#$HBoxContainer/SpriteDisplay.texture = 1
