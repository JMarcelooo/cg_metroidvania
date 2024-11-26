extends CharacterBody2D

@onready var healthbar = $CanvasLayer/Healthbar


var input
@export var speed = 100.0
@export var gravity = 10

#Variável para pular
var jump_count = 0
@export var max_jump = 2
@export var jump_force = 500

#MÁQUINA DE ESTADO PARA O ATACK
var current_state = player_states.MOVE
enum player_states {MOVE, SWORD, DEAD}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$sword/atack_collider.disabled = true
	var health = player_data.life
	healthbar.init_health(health)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match current_state:
		player_states.MOVE:
			movement(delta)
		player_states.SWORD:
			sword(delta)


func movement(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	
	#MOVIMENTAÇÃO
	if input != 0: 
		if input > 0:
			
			velocity.x += speed * delta
			velocity.x = clamp(speed, 100.0, speed)
			$Sprite2D.scale.x = 1
			$sword.position.x = 16
			$AnimationPlayer.play("Walk") 
			
		if input < 0:
			
			velocity.x -= speed * delta
			velocity.x = clamp(-speed, 100.0, -speed)
			$Sprite2D.scale.x = -1
			$sword.position.x = -19
			$AnimationPlayer.play("Walk") 
	
	else :
		velocity.x = 0
		$AnimationPlayer.play("Idle") 
		
	
	#PULOS
	
	if is_on_floor():
		jump_count = 0
	
	
	if !is_on_floor():
		if velocity.y < 0:
			if jump_count == 0:
				$AnimationPlayer.play("Jump")
			else:
				$AnimationPlayer.play("Jump")
		if velocity.y > 0:
			$AnimationPlayer.play("Fall")
	
	
	if Input.is_action_just_pressed("ui_accept") && is_on_floor() && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump_force
		velocity.x = input
	
	if !is_on_floor() && Input.is_action_just_pressed("ui_accept") && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump_force * 1.2
		velocity.x = input

	if !is_on_floor() && Input.is_action_just_released("ui_accept") && jump_count < max_jump:
		velocity.y = gravity
		velocity.x = input
	else: gravity_force()
	
	if Input.is_action_just_pressed("ui_sword"):
		current_state = player_states.SWORD
	
	gravity_force()
	move_and_slide()
	

func input_movement(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if input != 0: 
		if input > 0:
			velocity.x += speed * delta
			velocity.x = clamp(speed, 100.0, speed)
			$Sprite2D.scale.x = 1
			$sword.position.x = 16
		if input < 0:
			velocity.x -= speed * delta
			velocity.x = clamp(-speed, 100.0, -speed)
			$Sprite2D.scale.x = -1
			$sword.position.x = -19
	else :
		velocity.x = 0
	gravity_force()
	move_and_slide()



func gravity_force():
	velocity.y += gravity
	

func sword(delta):
	$AnimationPlayer.play("Sword")
	input_movement(delta)

func reset_state():
	current_state = player_states.MOVE
