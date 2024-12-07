extends CharacterBody2D

var SPEED = 60
@export var time = 1.5
const JUMP_FORCE = -400
@export var gravity = 30
var facing_right = true
var is_attacking = false


func _ready() -> void:
	var flip_timer = $Timer
	flip_timer.start(time)
	
func attack_player():
	# Executa ataque apenas se não estiver atacando
	if not is_attacking:
		SPEED = 0
		
		$AnimationPlayer.play("atack")
		
		await $AnimationPlayer.animation_finished
		if facing_right:
			SPEED = abs(SPEED)
		else:
			SPEED = -abs(SPEED)
		is_attacking = true
		
	if is_attacking:
		SPEED = 60
		$AnimationPlayer.play("Walk")
		is_attacking = false
		


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimationPlayer.play("Walk")
	
	velocity.x = SPEED
	move_and_slide()
	
	var raycast = $RayCast2D
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.name == "Player":
			attack_player()
		


func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1
	if facing_right:
		SPEED = abs(SPEED)
	else:
		SPEED = abs(SPEED) * -1


func _on_timer_timeout() -> void:
	flip()
	$Timer.start(time)


func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.name == "sword":
		$AnimationPlayer.play("Dead")
		print("ataque")
		SPEED = 0
		await $AnimationPlayer.animation_finished
		queue_free()
	

func _on_atack_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_data.life -= 1
		print(player_data.life)
		if player_data.life == 0:
			get_tree().reload_current_scene()
	
