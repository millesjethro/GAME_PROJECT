extends ProgressBar
class_name PlayerHpBar

@onready var DamageBar = $DamageBar
@onready var DamageBarTimer = $DamageBarTimer
@onready var HealthRemain = $HealthRemain 
var _target_hp: int

# ---------------------
# Initialize Bars
# ---------------------
func init_health(hp: int):
	max_value = hp
	value = hp
	DamageBar.max_value = hp
	DamageBar.value = hp
	HealthRemain.text = "HEALTH: %d/%d" % [value, max_value]
# ---------------------
# Update Health
# ---------------------
func set_health(hp: int):
	value = hp
	_target_hp = hp  # store target for DamageBar
	DamageBarTimer.start() # wait before tweening
	HealthRemain.text = "HEALTH: %d/%d" % [value, max_value]

# ---------------------
# Tween after timer
# ---------------------
func _on_damage_bar_timer_timeout() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(DamageBar, "value", _target_hp, 0.5)
