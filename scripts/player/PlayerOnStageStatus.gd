extends Node
class_name Player_On_Stage_Status

# ---------------------
# Finalized Stats
# ---------------------
var FinalAttack: int = 0
var FinalHealthPoints: int = 0
var FinalDefense: int = 0
var DodgeChance: float = 0.0
var DamageReduction: float = 0.0
var CritChance: float = 0.0
var Critical: float = 0.0

# ---------------------
# References
# ---------------------
@onready var PlayerSubStats: Player_Sub_Status = get_parent().get_node_or_null("SubStatus")
@onready var PlayerHealthBar: PlayerHpBar = get_parent().get_node_or_null("CanvasLayer/PlayerHealthBar")
# ---------------------
# Setup
# ---------------------
func _ready():
	if PlayerSubStats == null:
		push_error("❌ SubStatus not found under MainPlayer!")
	else:
		_calc_stats()
# ---------------------
# Recalculate Final Stats
# ---------------------
func _calc_stats() -> void:
	if PlayerSubStats == null: return
	
	FinalAttack       = PlayerSubStats.calc_FinalAttack()
	FinalDefense      = PlayerSubStats.calc_FinalDefense()
	FinalHealthPoints = PlayerSubStats.calc_FinalHealthPoints()
	CritChance        = PlayerSubStats.calc_Final_CriticalChance()
	DodgeChance       = PlayerSubStats.calc_DodgeChance()
	DamageReduction   = PlayerSubStats.calc_DamageReduction()
	Critical          = PlayerSubStats.calc_Critical()
	PlayerHealthBar.init_health(FinalHealthPoints)

# ---------------------
# Damage To Enemy
# ---------------------
func _calc_damage() -> int:
	if PlayerSubStats == null: return 0
	
	var roll = randf()  # already returns [0, 1), no need for round()
	if roll <= CritChance:
		return int(FinalAttack * Critical)
	return FinalAttack

# ---------------------
# Incoming Damage
# ---------------------
func _take_damage(incoming_damage: int) -> int:
	if PlayerSubStats == null: return FinalHealthPoints
	
	# Step 1: Dodge roll
	if randf() <= DodgeChance:
		return FinalHealthPoints  # no damage taken
	
	# Step 2: Apply Damage Reduction
	var damage_taken = int(incoming_damage * (1.0 - DamageReduction))
	
	# Step 3: Apply Defense Reduction
	damage_taken = max(0, damage_taken - int(FinalDefense * 0.75))
	
	# Step 4: Reduce HP
	FinalHealthPoints = max(0, FinalHealthPoints - damage_taken)
	PlayerHealthBar.init_health(FinalHealthPoints)
	return FinalHealthPoints
