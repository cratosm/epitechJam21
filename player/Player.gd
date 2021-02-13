extends KinematicBody2D
#GRAVITY
const UP = Vector2(0, -1)
export(int) var hp = 10
const GRAVITY = 20
#RUN
const MAX_SPEED = 500
const ACCELERATION = 50
#JUMP
const JUMP = -450
var Jumps = 1#(+1)
#MOVE
var motion = Vector2()
var stack = 0
var fireball_power = 1
var fireball = null
const FIREBALL = preload("res://Objects/shoot.tscn")
const FIREBALLUP = preload("res://Objects/FireballUp.tscn")
const SHOOT = "ui_focus_next"
var posTarget = null
const MAXSTACK = 20
var Dead = "Dead"
var Run = "Run"
var Idle = "Idle"
var MonkeyIdle = "IdleMonkey"
var MonkeyRun = "RunMonkey"
var MonkeyHit = "HitMonkey"
var MonkeyJump = "JumpMonkey"
var MonkeyFall = "JumpMonkey"
var FuturIdle = "IdleFutur"
var FuturRun = "RunFutur"
var FuturyHit = "HitFutur"
var FuturJump = "JumpFutur"
var FuturFall = "JumpFutur"
var FuturDie = "JumpFutur"
var Jump = "Jump"
var Fall = "Fall"
var Die = "Die"
var Idle_and_Shoot = "Idle and Shoot"
var Run_and_Shoot = "Idle and Shoot"
var Jump_and_Shoot = "Idle and Shoot"
var buffer = ""
var max_speed = 290
var monkey = false
var is_dead = false

func monkeyMode():
	if (monkey == true):
		return
	Jump = MonkeyJump
	Fall = MonkeyFall
	Idle = MonkeyIdle
	Run = MonkeyRun
	#Die
	Idle_and_Shoot = MonkeyHit
	Run_and_Shoot = MonkeyHit
	Jump_and_Shoot = MonkeyHit
	$CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2DMonkey.set_deferred("disabled", false)
	$Position2D.position.y -= 13
	monkey = true
	
func manageShoot():
	if fireball_power == 1:
		fireball = FIREBALL.instance()
	elif fireball_power == 2:
		fireball = FIREBALLUP.instance()
	if sign(posTarget.position.x) == 1:
		fireball.set_fireball_direction(1)
	else:
		fireball.set_fireball_direction(-1)
	if (monkey == true):
		fireball.MonkeyAttack()
	get_parent().add_child(fireball)
	fireball.position =  posTarget.global_position
	pass

func damage(dmg):#TAKE DMG
	hp -= dmg
	if hp < 1:
		is_dead = true
		motion = Vector2(0, 0)
		$Sprite.play(Die)
	else:
		$Sprite.play(Fall)
	pass

func manageRun():#RUN
	if Input.is_action_just_pressed(SHOOT) && Input.is_action_pressed("ui_right"):
		$Sprite.flip_h = true
		if sign(posTarget.position.x) == -1:
			posTarget.position.x *= -1
		stack = MAXSTACK
		buffer = Run_and_Shoot
		manageShoot()
		motion.x = min(motion.x + ACCELERATION, max_speed);
	elif Input.is_action_pressed("ui_right"):
		$Sprite.flip_h = true
		if sign(posTarget.position.x) == -1:
			posTarget.position.x *= -1
		$Sprite.play(Run)
		motion.x = min(motion.x + ACCELERATION, max_speed);
	elif Input.is_action_just_pressed(SHOOT) && Input.is_action_pressed("ui_left"):
		$Sprite.flip_h = false
		if sign(posTarget.position.x) == 1:
			posTarget.position.x *= -1
		stack = MAXSTACK
		buffer = Run_and_Shoot
		manageShoot()
		motion.x = max(motion.x - ACCELERATION, -max_speed);
	elif Input.is_action_pressed("ui_left"):
		$Sprite.flip_h = false
		if sign(posTarget.position.x) == 1:
			posTarget.position.x *= -1
		$Sprite.play(Run)
		motion.x = max(motion.x - ACCELERATION, -max_speed);
	else:
		$Sprite.play(Idle)
		if Input.is_action_just_pressed(SHOOT):
			stack = MAXSTACK
			buffer = Idle_and_Shoot
			manageShoot()
		motion.x = lerp(motion.x, 0, 0.2)
	if (stack != 0):
		$Sprite.play(buffer)
		stack -= 1
	pass

func manageJump():#JUMP
	if is_on_floor():
		Jumps = 1
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP
	else:
		if motion.y > 0:
			$Sprite.play(Fall)
		else:
			$Sprite.play(Jump)
			if Input.is_action_just_pressed(SHOOT):
				stack = MAXSTACK
				buffer = Jump_and_Shoot
				manageShoot()
		motion.x = lerp(motion.x, 0, 0.05)
		if Input.is_action_just_pressed("ui_up") && Jumps != 0:
			motion.y = JUMP
			Jumps -= 1
	if (stack > 0):
		$Sprite.play(buffer)
		stack -= 1
	else:
		buffer = ""
	pass

func _physics_process(delta):#MAIN
	monkeyMode()
	motion.y += GRAVITY
	posTarget = $Position2D
	manageRun()
	manageJump()
	motion = move_and_slide(motion, UP)
	pass
