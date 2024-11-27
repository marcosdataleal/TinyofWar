class_name Player
extends KinematicBody2D

export var speed: float = 200
export var sword_damage: int = 3
onready var sprite: Sprite = $Sprite
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var SwordArea: Area2D = $SwordArea
onready var HitboxArea: Area2D = $HitboxArea
onready var health_progress_bar: ProgressBar = $HealthProgressBar
export var health: int = 100
var is_dead := false
export var death_prefab: PackedScene
export var max_health: int = 100

var is_running: bool = false
var is_attacking: bool = false
var hitbox_cooldown: float = 0.0
var player_velocity: Vector2 = Vector2()  

func _physics_process(delta: float) -> void:
	GameManager.player_position = position
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_velocity = input_vector * speed
	if is_attacking:
		target_velocity *= 0.25
	player_velocity = lerp(player_velocity, target_velocity, 0.05)
	move_and_slide(player_velocity)
	
	var was_running = is_running
	is_running = not input_vector.is_equal_approx(Vector2.ZERO)
	
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")
		if input_vector.x > 0:
			sprite.flip_h = false
		elif input_vector.x < 0:
			sprite.flip_h = true
		if Input.is_action_just_pressed("attack"):
			attack()
	process(delta)

func process(delta: float) -> void:
	# Atualiza o cooldown do dano
	if hitbox_cooldown > 0:
		hitbox_cooldown -= delta
	else:
		hitbox_cooldown = 0

	update_hitbox_detection(delta)

func attack() -> void:
	if is_attacking:
		return
	animation_player.play("side_attach1")
	is_attacking = true
	deal_damage_to_enemies()
	is_attacking = false  

func deal_damage_to_enemies() -> void:
	var bodies = SwordArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.3:
				enemy.damage(sword_damage)

func update_hitbox_detection(delta: float) -> void:
	if hitbox_cooldown > 0:
		return
	
	var bodies = HitboxArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body as Enemy
			var damage_amount = 10  
			damage(damage_amount)
			hitbox_cooldown = 0.5  
			break  

func damage(amount: int) -> void:
	if health <= 0: 
		return
	
	health -= amount
	health_progress_bar.value = health 
	
	modulate = Color.red
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.white, 0.3)
	
	if health <= 0:
		is_dead = true
		get_tree().change_scene("res://telas/Cena_game_Over.tscn")
		die()

func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instance()
		death_object.position = position
		get_parent().add_child(death_object)
		
	queue_free()

func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	health_progress_bar.value = health 
	return health











