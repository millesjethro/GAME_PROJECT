extends Node

@export var Attack = 0
@export var Defense = 0
@export var Health = 0

var MoneyDrop: Dictionary = {
	"bronze": 0,
	"silver": 0,
	"gold": 0
}
signal died(amount: Dictionary) # 🔹 signal for when this enemy dies

func _ready() -> void:
	var level = randi_range(1, 10)
	Attack = 8 + level
	Defense = 4 + level
	Health = 25 + level
	if level > 5:
		MoneyDrop["bronze"] += 2 + level
		MoneyDrop["silver"] += 1 + level/2
	elif level == 10:
		MoneyDrop["bronze"] += 4 + level
		MoneyDrop["silver"] += 3 + level/2
		MoneyDrop["gold"] += 1
	else:
		MoneyDrop["bronze"] += 2 + level

func take_damage(incoming: int) -> int:
	Health -= incoming
	if Health < 0:
		emit_signal("died", MoneyDrop) # 🔹 notify listeners
		get_parent().queue_free()
		return Health
	return Health
