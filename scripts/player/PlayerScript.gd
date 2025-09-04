extends CharacterBody2D

@onready var PlayerSprite: AnimatedSprite2D = $LancerSprite
@onready var PlayerHp = $CanvasLayer/PlayerHealthBar
@onready var GoldLabel = $CanvasLayer/gold
@onready var SilverLabel = $CanvasLayer/silver
@onready var BronzeLabel = $CanvasLayer/bronze
@export var GravityForce: float = 600.0 # downward pull
@export var MoveSpeed: float = 200.0   # movement speed
@onready var playerStats = $PlayerStats
var is_knockback: bool = false

# Physics values
var gravity: float = 900.0
var move_speed: float = 200.0

# Knockback values
var knockback_force: float = 150.0   # backward push
var knockback_up: float = -200.0     # upward launch
var is_dead: bool = false
var playOnce: int = 0

func _ready() -> void:
	PlayerSprite.play("idle")
	PlayerHp.init_hp(playerStats.FinalHealth)
	playerStats.connect("died", Callable(self, "_on_player_stats_died"))
	BronzeLabel.text = "%d" % [playerStats.MoneyCurrent["bronze"]]
	SilverLabel.text = "%d" % [playerStats.MoneyCurrent["silver"]]
	GoldLabel.text = "%d" % [playerStats.MoneyCurrent["gold"]]
	

func _physics_process(delta: float) -> void:
	if is_on_floor():
		if is_dead:
			if playOnce == 0:
				PlayerSprite.play("death")
				await PlayerSprite.animation_finished
				playOnce += 1
			velocity = Vector2.ZERO
			return  # stop all input and physics when dead
	# Always apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_knockback:
		# During knockback, player has no control
		move_and_slide()

		# Once they land, stop knockback
		if is_on_floor():
			is_knockback = false
	else:
		# Normal movement only if not knocked back
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

func _on_deal_damage_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyTakeDamage"):
		var enemy = area.get_parent()
		if enemy.has_node("MainStatus"):
			var enemy_stats = enemy.get_node("MainStatus")
			var enemy_attack = enemy_stats.Attack
			
			var current_hp = playerStats.take_damage(enemy_attack)
			PlayerHp.set_hp(current_hp)
			
			
			# Play hurt animation
			PlayerSprite.play("hurt")

			# Knockback direction (left/right depending on enemy position)
			var dir = sign(global_position.x - enemy.global_position.x)

			# Apply both backward + upward velocity
			velocity.x = dir * knockback_force
			velocity.y = knockback_up
			is_knockback = true
			
			

func apply_knockback(force: Vector2) -> void:
	# If your player is a CharacterBody2D
	velocity = force
	# Optionally: start a timer to stop knockback after a short time
	var knockback_timer = get_tree().create_timer(0.2) # 0.2 sec knockback
	knockback_timer.timeout.connect(func ():
		velocity = Vector2.ZERO
	)
	
# -------------------------------
# ALL CALLBACKS
# -------------------------------
func _on_player_stats_died() -> void:
	is_dead = true
