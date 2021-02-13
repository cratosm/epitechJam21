extends KinematicBody2D
#GRAVITY
const UP = Vector2(0, -1)
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
var Jump = "Jump"
var Fall = "Fall"
var Die = "Die"
var Idle_and_Shoot = "Idle and Shoot"
var Run_and_Shoot = "Idle and Shoot"
var Jump_and_Shoot = "Idle and Shoot"
var buffer = ""
var max_speed = 290

func manageShoot():
	if fireball_power == 1:
		fireball = FIREBALL.instance()
	elif fireball_power == 2:
		fireball = FIREBALLUP.instance()
	if sign(posTarget.position.x) == 1:
		fireball.set_fireball_direction(1)
	else:
		fireball.set_fireball_direction(-1)
	get_parent().add_child(fireball)
	fireball.position =  posTarget.global_position
	pass

func manageRun():#RUN
	if Input.is_action_just_pressed(SHOOT) && Input.is_action_pressed("ui_right"):
		$Sprite.flip_h = true
		if sign(posTarget.position.x) == -1:
			posTarget.position.x *= -1
			$Sprite/Cac/hitboxCac.position.x *= -1
			$Sprite/Cac/PositionArm.position.x *= -1
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
	motion.y += GRAVITY
	posTarget = $Position2D
	manageRun()
	manageJump()
	motion = move_and_slide(motion, UP)
	pass
