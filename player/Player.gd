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

func manageRun():#RUN
	if Input.is_action_pressed("ui_right"):
		$Sprite.flip_h = false
		$Sprite.play("Run")
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED);
	elif Input.is_action_pressed("ui_left"):
		$Sprite.flip_h = true
		$Sprite.play("Run")
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED);
	else:
		$Sprite.play("Idle")
		motion.x = 0
	pass

func manageJump():#JUMP
	if is_on_floor():
		Jumps = 1
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP
	else:
		if motion.y > 0:
			$Sprite.play("Fall")
		else:
			$Sprite.play("Jump")

	if Input.is_action_just_pressed("ui_up") && Jumps != 0:
		motion.y = JUMP
		#Jumps -= 1
	pass

func _physics_process(delta):#MAIN
	motion.y += GRAVITY
	manageRun()
	manageJump()
	motion = move_and_slide(motion, UP)
	pass
