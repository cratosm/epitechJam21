extends Area2D
export(PackedScene) var target_scene

func _ready():
	$AnimatedSprite.play("default")
	pass
	
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if !target_scene:
			print("no scene load")
			return
		if get_overlapping_bodies().size() > 1:
			next_level()

func next_level():
	var ERR = get_tree().change_scene_to(target_scene)
	if ERR != OK:
		print("error")
