extends Node

var enemy: KinematicBody2D
export var speed = 1.0
var velocity = Vector2()
var sprite: AnimatedSprite

func _ready():
	enemy = get_parent() as KinematicBody2D
	sprite = enemy.get_node("AnimatedSprite")

func _physics_process(delta: float) -> void:
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	velocity = input_vector * speed * 100.0
	enemy.move_and_slide(velocity)
	
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true











