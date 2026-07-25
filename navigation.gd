class_name Navigation
extends Node

static var instance := self

static var tile_size := 32

static var maxX := 50
static var maxY := 50

#2d array of units on the grid
static var grid: Array[Array]

#1d list of units
static var units: Array[Unit]

static var nests: Array[Nest]

@export var obstacles_tilemap: TileMapLayer
@export var highlights_tilemap: TileMapLayer
@export var visual_path_line2d: Line2D

# call this function to move a unit around
static func moveUnit(X, Y, toX, toY) -> void:
	if grid[toX][toY] != null:
		return
	var unit := grid[X][Y] as Unit
	if not unit:
		return
	grid[X][Y] = null
	grid[toX][toY] = unit
	unit.X = toX
	unit.Y = toY

static func getUnitAtPosition(X, Y) -> Unit:
	if X >= 0 and X < maxX and Y >= 0 and Y < maxY:
		return grid[X][Y]
	else:
		return null

func highlight_tiles_in_range(center: Unit, distance: int):
	var condition = func(x: int, y: int) -> bool:
		var pathlength := pathfind(center, Vector2i(x,y)).size()
		return pathlength > 0 and pathlength <= distance + 1
		
	highlight_tiles(condition)

func highlight_tiles(condition: Callable):
	for i in range(maxX):
		for j in range(maxY):
			if condition.call(i, j):
				#highlight a tile (right now the highlight sprite is a placeholder)
				highlights_tilemap.set_cell(Vector2i(i, j), 0, Vector2i(0, 8))
			else:
				highlights_tilemap.set_cell(Vector2i(i, j), -1)

func unhighlight_tiles():
	highlights_tilemap.clear()

func get_pathfinding_distance(subject: Unit, target: Vector2i) -> int:
	return pathfind(subject, target, true).size()

func pathfind(subject: Unit, target: Vector2i, allow_solid_destination := false) -> PackedVector2Array:
	var pathfinding_grid : AStarGrid2D = AStarGrid2D.new()
	pathfinding_grid.region = obstacles_tilemap.get_used_rect()
	pathfinding_grid.cell_size = Vector2(tile_size, tile_size)
	pathfinding_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	pathfinding_grid.update()
	
	for tile in obstacles_tilemap.get_used_cells():
		pathfinding_grid.set_point_solid(tile)
	
	for unit in units:
		if unit.Team != subject.Team or unit.get_pos() == target:
			pathfinding_grid.set_point_solid(Vector2i(unit.X, unit.Y), true)
	
	pathfinding_grid.set_point_solid(subject.get_pos(), false)
	if allow_solid_destination:
		pathfinding_grid.set_point_solid(target, false)
	var path := pathfinding_grid.get_point_path(subject.get_pos(), target)
	return path

func _ready() -> void:	
	instance = self
	
	maxX = obstacles_tilemap.get_used_rect().end.x
	maxY = obstacles_tilemap.get_used_rect().end.y
	
	# initialize empty 2d array grid
	grid = []
	for i in range(maxX):
		var column := []
		for j in range(maxY):
			column.append(null)
		grid.append(column)
