extends Area2D
const SPEED = 400
var velocity = Vector2()
var direction = 1

func _ready():

	pass 

func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("fire")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Area2D_body_entered(body):
	$AnimatedSprite.play("die")
	if "IceWalker" in body.name:
		body.dead(10)
	if "Alien" in body.name:
		body.dead(10)
	if "drakeIce" in body.name:
		body.dead(10)
	if "MonsterBall" in body.name:
		body.dead(10)
	if "BossMageFirst" in body.name:
		body.dead(10)
	if "BossMageRes" in body.name:
		body.dead(10)
	queue_free()
