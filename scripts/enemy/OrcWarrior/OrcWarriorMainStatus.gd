extends Node

@export var Attack = 0
@export var Defense = 0
@export var Health = 0

var GoldDrop = 0
signal died(gold_amount: int) # 🔹 signal for when this enemy dies

func _ready() -> void:
	var level = randi_range(1, 10)
	Attack = 8 + level
	Defense = 4 + level
	Health = 25 + level
	GoldDrop = 5 + level

func take_damage(incoming: int) -> int:
	Health -= incoming
	if Health < 0:
		emit_signal("died", GoldDrop) # 🔹 notify listeners
		get_parent().queue_free()
		return Health
	return Health
