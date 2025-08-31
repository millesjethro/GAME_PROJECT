extends Node

@export var Gold: int = 0

func add_gold(amount: int) -> void:
	Gold += amount
	print("Gold now: ", Gold)
