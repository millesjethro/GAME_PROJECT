extends CharacterBody2D

@onready var PlayerSprite = $LancerSprite
@onready var PlayerHp = $CanvasLayer/PlayerHealthBar
@onready var OnStageStats = $PlayerStatus/OnStageStatus

@export var GravityForce: float = 600.0 # downward pull
@export var MoveSpeed: float = 200.0   # movement speed

func _ready() -> void:
	PlayerSprite.play("idle")
	print(OnStageStats.FinalHealthPoints)
	PlayerHp.init_health(OnStageStats.FinalHealthPoints)

func _physics_process(delta: float) -> void:
	PlayerMovement(delta)

# --------------------------------
# Player Movement Function
# --------------------------------
func PlayerMovement(DeltaForce: float):
	if not is_on_floor():
		velocity.y += GravityForce * DeltaForce
	else:
		velocity.y = 0  # stay grounded when on floor
	
	# Left/Right input
	var Direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = Direction * MoveSpeed
		# Flip + Animation
	PlayerMovementSprite(Direction)
	move_and_slide()

# --------------------------------
# Player Sprite Functions
# --------------------------------
func PlayerMovementSprite(Direction: int):
	if Direction > 0:
		PlayerSprite.flip_h = false
		PlayerSprite.play("walking")
	elif Direction < 0:
		PlayerSprite.flip_h = true
		PlayerSprite.play("walking")
	else:
		PlayerSprite.play("idle")
