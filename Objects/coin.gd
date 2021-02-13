extends Area2D

func _ready():
	$AnimatedSprite.play("default")
	pass


func _on_Area2D_body_entered(body):
	queue_free()
	pass # Replace with function body.
