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

@export var tilemap_layer_node: TileMapLayer
@export var visual_path_line2d: Line2D

var pathfinding_grid : AStarGrid2D = AStarGrid2D.new()

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

func pathfind(subject: Unit, target: Vector2i):
	visual_path_line2d.global_position = Vector2(tile_size/2.0, tile_size/2.0)
	
	pathfinding_grid.region = tilemap_layer_node.get_used_rect()
	pathfinding_grid.cell_size = Vector2(tile_size, tile_size)
	pathfinding_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	pathfinding_grid.update()
	
	for tile in tilemap_layer_node.get_used_cells():
		pathfinding_grid.set_point_solid(tile)
	
	for unit in units:
		pathfinding_grid.set_point_solid(Vector2i(unit.X, unit.Y), true)
	
	var path := pathfinding_grid.get_point_path(subject.get_pos(), target)
	visual_path_line2d.points = path



func _ready() -> void:	
	instance = self
	# initialize empty 2d array grid
	grid = []
	for i in range(maxX):
		var column := []
		for j in range(maxY):
			column.append(null)
		grid.append(column)
