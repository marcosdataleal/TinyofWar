extends Node2D

func _ready():
	pass 

func iniciar():
	get_tree().change_scene("res://test_scene/test_player.tscn")

func About_us():
	get_tree().change_scene("res://sobre.tscn")
