extends Node2D

export var regeneration_amount: int = 30

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Object) -> void:
	if body.is_in_group("player") and body is Player:
		var player: Player = body
		player.heal(regeneration_amount)
		queue_free()





	



