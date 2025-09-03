extends Node

@export var player_stats = Resource

var FinalAttack = 0
var FinalHealth = 0
var FinalDefense = 0

func _ready() -> void:
	player_stats.calc_final()
	FinalAttack = player_stats.FinalAttack
	FinalHealth = player_stats.FinalHealthPoints
	FinalDefense = player_stats.FinalDefense

func take_damage(incomingDamage: int) -> int:
	var roll = round(randf_range(0.0, 1.0) * 100) / 100.0
	if player_stats.Dodge >= roll:
		print("Dodge!")
		return FinalHealth
	incomingDamage -= (incomingDamage * player_stats.DamageReduction)
	incomingDamage -= (FinalDefense* 0.75)
	FinalHealth -= max(0, incomingDamage)
	return FinalHealth
	
func deal_damage() -> int:
	var roll = round(randf_range(0.0, 1.0) * 100) / 100.0
	if player_stats.CriticalChance >= roll:
		print("Critical")
		FinalAttack = FinalAttack * player_stats.Critical
		return FinalAttack
	return FinalAttack
