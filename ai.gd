extends Node

var ai_pennies := 50

func run_ai():
	for unit in Combat.units:
		if unit.Team != Combat.Team.PLAYER:
			#for each non-player unit,
			var candidate_unit_targets := []
			#decide what to do with this unit:
			for other_unit in Combat.units:
				if other_unit.Team != unit.Team and Navigation.instance.get_pathfinding_distance(unit, other_unit.get_pos()) <= unit.move_range:
					candidate_unit_targets.append(other_unit)
			
			if candidate_unit_targets.size() > 0:
				var target_unit = candidate_unit_targets[randi_range(0, candidate_unit_targets.size()-1)] as Unit
				
				var path_to_target = Navigation.instance.pathfind(unit, target_unit.get_pos(), true)
				
				path_to_target.remove_at(0)
				path_to_target.remove_at(path_to_target.size()-1)
				
				for step in path_to_target: #wait briefly and then move to the next step on the path
					await get_tree().create_timer(0.25).timeout
					Navigation.moveUnit(unit.X, unit.Y, step.x/Navigation.tile_size, step.y/Navigation.tile_size)
				
				#now attack target
				Combat.make_unit_attack_other_unit(unit, target_unit)
			else:
				var closest_enemy_nest = null
				var distance_to_closest_enemy_nest := 9999
				
				for nest in Navigation.nests:
					var distance = Navigation.instance.get_pathfinding_distance(unit, nest.get_pos())
					if nest.Team != unit.Team and distance < distance_to_closest_enemy_nest:
						closest_enemy_nest = nest
						distance_to_closest_enemy_nest = distance
				
				if distance_to_closest_enemy_nest <= unit.move_range:
					var path_to_target = Navigation.instance.pathfind(unit, closest_enemy_nest.get_pos(), true)
					
					path_to_target.remove_at(0)
					
					for step in path_to_target: #wait briefly and then move to the next step on the path
						await get_tree().create_timer(0.25).timeout
						Navigation.moveUnit(unit.X, unit.Y, step.x/Navigation.tile_size, step.y/Navigation.tile_size)
					
					closest_enemy_nest.attack_nest(unit)
				
				else: # no nests or enemies in range
					if closest_enemy_nest:
						var path_to_target = Navigation.instance.pathfind(unit, closest_enemy_nest.get_pos(), true)
						path_to_target.remove_at(0)
						for i in range(distance_to_closest_enemy_nest - unit.move_range):
							path_to_target.remove_at(path_to_target.size()-1)
						
						for step in path_to_target: #wait briefly and then move to the next step on the path
							await get_tree().create_timer(0.25).timeout
							Navigation.moveUnit(unit.X, unit.Y, step.x/Navigation.tile_size, step.y/Navigation.tile_size)
					else: #no enemy nests
						pass
	
	#end enemy turn
	Selection.end_ai_turn()

#func _ready() -> void:
	#run_ai()
