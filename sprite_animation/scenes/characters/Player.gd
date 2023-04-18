extends KinematicBody2D

const ACCEL = 500
const MAX_SPEED = 80
const FRICTION = 500

var velocity = Vector2.ZERO
onready var state_machine = $AnimationTree.get("parameters/playback")
var health = 10

func _input(event):
	if Input.is_action_just_pressed("damage"):
		health -= 1
		print("health: ", health)

func _physics_process(delta):
	# entrada de movimiento
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	print(input_vector)
	
	if input_vector != Vector2.ZERO:
		# jugador en movimiento
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL * delta)
		state_machine.travel("player_run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		state_machine.travel("player_idle")
	
	# atacar
	if Input.is_action_just_pressed("attack"):
		state_machine.travel("player_attack")
	
	#Sprint
	if Input.is_action_pressed("sprint"):
		state_machine.travel("player_run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED * MAX_SPEED, ACCEL * delta)
	#Saltar
	if Input.is_action_just_pressed("saltar"):
		state_machine.travel("Saltar")
		
	#Saltar Atacar
	if Input.is_action_pressed("saltaratacar"):
		state_machine.travel("SaltarAtaque")
		
	# morir
	if health <= 0:
		state_machine.travel("player_death")
		velocity = Vector2.ZERO
	
	if velocity.x < 0:
		$Sprite.scale.x = -1
		$Sprite.scale.y = 1
	elif velocity.x > 0:
		$Sprite.scale.x = 1
		$Sprite.scale.y = 1
	#ejecutar movimiento
	velocity = move_and_slide(velocity)
	

