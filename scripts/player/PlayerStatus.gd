extends Node

@export var player_stats = Resource

var FinalAttack = 0
var FinalHealth = 0
var FinalDefense = 0

var MoneyCurrent: Dictionary = {
	"bronze": 0,
	"silver": 0,
	"gold": 0
}

signal died

func _ready() -> void:
	player_stats.calc_final()
	FinalAttack = player_stats.FinalAttack
	FinalHealth = player_stats.FinalHealthPoints
	FinalDefense = player_stats.FinalDefense
	MoneyCurrent = player_stats.get_money()

func take_damage(incomingDamage: int) -> int:
	var roll = round(randf_range(0.0, 1.0) * 100) / 100.0
	if player_stats.Dodge >= roll:
		print("Dodge!")
		return FinalHealth
	incomingDamage -= (incomingDamage * player_stats.DamageReduction)
	incomingDamage -= (FinalDefense* 0.75)
	FinalHealth -= max(0, incomingDamage)
	if FinalHealth <= 0:
		emit_signal("died")
	return FinalHealth
	
func deal_damage() -> int:
	var roll = round(randf_range(0.0, 1.0) * 100) / 100.0
	if player_stats.CriticalChance >= roll:
		FinalAttack = FinalAttack * player_stats.Critical
		return FinalAttack
	return FinalAttack

func get_money_drop(amount: Dictionary):
	MoneyCurrent["bronze"] += amount["bronze"]
	MoneyCurrent["silver"] += amount["silver"]
	MoneyCurrent["gold"] += amount["gold"]
	
