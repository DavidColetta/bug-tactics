extends Node2D

@export var enemy_prefabs: Array[PackedScene] = [
	preload("res://prefabs/ant.tscn"),
	preload("res://prefabs/ant.tscn"),
	preload("res://prefabs/ant.tscn"),
	preload("res://prefabs/ant.tscn"),
	preload("res://prefabs/ant.tscn"),
	preload("res://prefabs/ant.tscn"),
	preload("res://prefabs/beetle.tscn"),
	preload("res://prefabs/beetle.tscn"),
	preload("res://prefabs/beetle.tscn"),
	preload("res://prefabs/spider.tscn"),
	preload("res://prefabs/spider.tscn"),
	preload("res://prefabs/stagbeetle.tscn"),
	preload("res://prefabs/dragonfly.tscn"),
	preload("res://prefabs/moth.tscn"),
	preload("res://prefabs/cockroach.tscn"),
	preload("res://prefabs/cockroach.tscn"),
	preload("res://prefabs/cockroach.tscn")
]

# Settings for grid dimensions
@export var spawn_column: int = 30
@export var min_y: int = 0
@export var max_y: int = 10


func spawn_wave(amount: int = 2) -> void:
	var spawned_count = 0
	var max_attempts = 30 # prevents an infinite loop
	var attempts = 0
	
	# 1. First make sure index 20 actually exists in the navigation grid
	if spawn_column >= Navigation.grid.size():
		print("Error: spawn_column (", spawn_column, ") is wider than grid size (", Navigation.grid.size(), ")!")
		return

	while spawned_count < amount and attempts < max_attempts:
		attempts += 1
		var enemy_scene = enemy_prefabs.pick_random()
		var random_y = randi_range(min_y, max_y)
		
		# 2. Check Y bounds as well to prevent index crashes on rows
		if random_y >= Navigation.grid[spawn_column].size():
			continue
			
			
		if Navigation.grid[spawn_column][random_y] == null:
			var enemy = enemy_scene.instantiate() as Unit
			
			enemy.Team = Combat.Team.ENEMY
			enemy.X = spawn_column
			enemy.Y = random_y
			
			get_node("../Combatants").add_child(enemy)
			
			spawned_count += 1
