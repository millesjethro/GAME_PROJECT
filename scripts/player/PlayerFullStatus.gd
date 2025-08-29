extends Node

@onready var MainStats = $MainStatus
@onready var SubStats = $SubStatus
@onready var OnStageStatus = $OnStageStatus

func _ready() -> void:
	PassingSubStats()
	PassingOnstageStats()


func PassingSubStats():
	var values: Dictionary = {}
	values["Strength"] = MainStats.FinalStrength
	values["Agility"] = MainStats.FinalAgility
	values["Intelligence"] = MainStats.FinalIntelligence
	SubStats.GettingValues(values)

func PassingOnstageStats():
	var value: Dictionary = {}
	value["FinalAttack"] = SubStats.calc_FinalAttack()
	value["FinalDefense"] = SubStats.calc_FinalDefense()
	value["FinalHealthPoints"] = SubStats.calc_FinalHealthPoints()
	value["CritChance"] = SubStats.calc_Final_CriticalChance()
	value["DodgeChance"] = SubStats.calc_DodgeChance()
	value["DamageReduction"] = SubStats.calc_DamageReduction()
	value["Critical"] = SubStats.calc_Critical()
	OnStageStatus._calc_stats(value)
