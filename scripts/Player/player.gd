extends CharacterBody2D

@onready var healthbar = $CanvasLayer/Healthbar

@onready var attack_sound = $AudioStreamPlayer2D
var input
@export var speed = 100.0
@export var gravity = 10
var is_dead = false
var current_health = player_data.life

#Variável para pular
var jump_count = 0
var max_jump = player_data.max_jump
@export var jump_force = 500

#MÁQUINA DE ESTADO PARA O ATACK
var current_state = player_states.MOVE
enum player_states {MOVE, SWORD, DEAD, DAMAGE, HEAL}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$sword/atack_collider.disabled = true
	var health = player_data.life
	healthbar.init_health(current_health)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player_data.life <= 0:
		current_state = player_states.DEAD
	
	if player_data.life < current_health:
		current_state = player_states.DAMAGE
	if player_data.life > current_health:
		current_state = player_states.HEAL
	
	match current_state:
		player_states.MOVE:
			movement(delta)
		player_states.SWORD:
			sword(delta)
		player_states.DEAD:
			dead(delta)
		player_states.DAMAGE:
			damage(delta)
		player_states.HEAL:
			heal()


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
		attack_sound.play()
		current_state = player_states.SWORD
	
	gravity_force()
	move_and_slide()
	

func heal():
	current_state = player_states.MOVE
	if player_data.life > 3:
		player_data.life = 3
	current_health = player_data.life
	$CanvasLayer/Healthbar._set_health(player_data.life)

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

func dead(delta):
	if not is_dead:
		is_dead = true
		print("Player morreu")
		max_jump = 1
		player_data.max_jump = 1
		$AnimationPlayer.play("Dead")
		await $AnimationPlayer.animation_finished
		current_state = player_states.MOVE
		player_data.life = 3
		get_tree().change_scene_to_file("res://components/tela_game_over.tscn")

func damage(delta):
	$AnimationPlayer.play("Damage")
	current_health = player_data.life
	await $AnimationPlayer.animation_finished
	$CanvasLayer/Healthbar._set_health(player_data.life)
	current_state = player_states.MOVE

func reset_state():
	current_state = player_states.MOVE
