extends Node

@export var Attack = 0
@export var Defense = 0
@export var Health = 0

var GoldDrop = 0

func _ready() -> void:
	Attack = randi_range(5, 8)
	Defense = randi_range(5, 9)
	Health = randi_range(15, 25)
	GoldDrop = randi_range(5, 24)
