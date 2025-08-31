extends Node

@export var Gold: int = 0

func _ready() -> void:
	_load_status()

func add_gold(amount: int) -> void:
	Gold += amount
	print("Gold now: ", Gold)
	_save_status()

func gold_return() -> int:
	return Gold

func _save_status():
	var config = ConfigFile.new()
	config.set_value("Currency", "Gold", Gold)
	config.save("user://PlayerStatus.cfg")

func _load_status():
	var config = ConfigFile.new()
	var err = config.load("user://PlayerStatus.cfg")
	if err == OK:
		Gold = config.get_value("Currency", "Gold", 0)
