extends CharacterBody2D

var player: CharacterBody2D
@onready var mainStatus = $MainStatus
@export var GravityForce = 200
@onready var hpShow = $EnemyHealthBar

func _ready() -> void:
	hpShow.init_health(mainStatus.Health)
	mainStatus.died.connect(_on_enemy_died)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GravityForce * delta
	else:
		velocity.y = 0  # stay grounded when on floor
	move_and_slide()

func _on_take_damage_area_entered(area: Area2D) -> void:
	if area.is_in_group("AreaDealDamage"):
		var parent = area.get_parent()
		player = parent
		if parent.has_node("PlayerStats"):
			var player_stats = parent.get_node("PlayerStats")
			var damage = player_stats.deal_damage()
			var currentHp = mainStatus.take_damage(damage)
			hpShow.set_health(currentHp)

func _on_enemy_died(Amount: Dictionary) -> void:
	if player.has_node("PlayerStats"):
		print("gold added")
		var gold = player.get_node("PlayerStats")
		gold.get_money_drop(Amount)
