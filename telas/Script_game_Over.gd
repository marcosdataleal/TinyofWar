extends Node2D

func _ready():
	pass 

func Yes_again():
	get_tree().change_scene("res://test_scene/test_player.tscn")


func No_Again():
	get_tree().change_scene("res://telas/cena_tela_inicio.tscn")
