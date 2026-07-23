extends Node

var gridObjects: Array[Array] #2d array

func moveUnit(X, Y, toX, toY):
	var unit := gridObjects[X][Y] as Unit
	if not unit:
		return
	gridObjects[X][Y] = null
	gridObjects[toX][toY] = unit
	unit.X = toX
	unit.Y = toY
