extends Area2D
const SPEED = 400
var velocity = Vector2()
var direction = 1
var fire = "fire"
var die = "die"

func _ready():
	pass 

func MonkeyAttack():
	fire = "fireMonkey"

func AttackModern():
	fire = "fire"

func AttackFutur():
	fire = "fireFutur"

func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play(fire)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_shoot_body_entered(body):
	$AnimatedSprite.play(die)
	if "Dinausore" in body.name:
		body.dead(1)
	if "Alien" in body.name:
		body.dead(1)
	if "Trex" in body.name:
		body.dead(1)
	if "military" in body.name:
		body.dead(1)
	if "BossMageFirst" in body.name:
		body.dead(1)
	if "BossMageRes" in body.name:
		body.dead(1)
	queue_free()
