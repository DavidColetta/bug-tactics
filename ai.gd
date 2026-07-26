extends Node

var ai_pennies := 50

func run_ai():
	for unit in Combat.units:
		if unit.Team != Combat.Team.PLAYER:
			# for each non-player unit,
			var candidate_unit_targets := []
			# decide what to do with this unit:
			for other_unit in Combat.units:
				if other_unit.Team != unit.Team and Navigation.instance.get_pathfinding_distance(unit, other_unit.get_pos()) <= unit.move_range:
					candidate_unit_targets.append(other_unit)
			
			if candidate_unit_targets.size() > 0:
				var target_unit = candidate_unit_targets[randi_range(0, candidate_unit_targets.size()-1)] as Unit
				
				var path_to_target = Navigation.instance.pathfind(unit, target_unit.get_pos(), true)
				
				path_to_target.remove_at(0)
				if path_to_target.size() > 0:
					path_to_target.remove_at(path_to_target.size()-1)
				
				# 1. FIXED: Replace the first movement loop here
				if path_to_target.size() > 0:
					var dest = path_to_target[-1]
					await unit.move_to(Vector2i(dest.x / Navigation.tile_size, dest.y / Navigation.tile_size))
				
				# now attack target
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
					
					# 2. FIXED: Uses unit.move_to() for nest attacks
					if closest_enemy_nest:
						await unit.move_to(closest_enemy_nest.get_pos())
					
					closest_enemy_nest.attack_nest(unit)
				
				else: # no nests or enemies in range
					if closest_enemy_nest:
						var path_to_target = Navigation.instance.pathfind(unit, closest_enemy_nest.get_pos(), true)
						path_to_target.remove_at(0)
						for i in range(distance_to_closest_enemy_nest - unit.move_range):
							if path_to_target.size() > 0:
								path_to_target.remove_at(path_to_target.size()-1)
						
						# 3. FIXED: Uses unit.move_to() for moving toward nests
						if path_to_target.size() > 0:
							var dest = path_to_target[-1]
							await unit.move_to(Vector2i(dest.x / Navigation.tile_size, dest.y / Navigation.tile_size))
					else: # no enemy nests
						pass
	
	# end enemy turn
	Selection.end_ai_turn()
