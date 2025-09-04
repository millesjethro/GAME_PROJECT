extends AnimatedSprite2D

@onready var labelText = $health_left
var max_hp: int = 0
func _ready() -> void:
	set_frame_and_progress(0,0)

func init_hp(health: int):
	max_hp = health
	labelText.text = "100%"

func set_hp(health: int):
	var hp_left: int = (health/max_hp) * 100
	labelText.text = [hp_left,"%"]
