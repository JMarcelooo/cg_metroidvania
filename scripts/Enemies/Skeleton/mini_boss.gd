extends CharacterBody2D

@onready var attack_sound = $attack_sound
@onready var dying_sound = $dying_sound
@export var time = 1.5
@export var gravity = 30
@onready var healthbar = $CanvasLayer/Healthbar
var SPEED = 60
const JUMP_FORCE = -400
var facing_right = true
var is_attacking = false
var was_attacked = false
var life = 10


func _ready() -> void:
	var flip_timer = $Timer
	flip_timer.start(time)
	$Atack/CollisionShape2D.set_disabled(true)
	print(life)
	healthbar.init_health(life)
	
func attack_player():
	attack_sound.play()
	if not is_attacking:
		SPEED = 0
		$AnimationPlayer.play("atack")
		
		if was_attacked:
			if life <=0:
				die()
				await $AnimationPlayer.animation_finished
				queue_free()
		
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
	#if was_attacked:
	#	if life <= 0:
	#		$AnimationPlayer.play("Dead")
	#		dying_sound.play()
	#		SPEED = 0
	#		await $AnimationPlayer.animation_finished
	#		queue_free()
	#	life -= 1
	
	
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
		if life <=0:
			die()
		else:
			life -=1
			healthbar._set_health(life)
			print(life)
			was_attacked = true
	

func _on_atack_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_data.life -= 1.0
		print(player_data.life)



func die():
	player_data.max_jump = 2
	dying_sound.play()
	$AnimationPlayer.play("Dead")
	await $AnimationPlayer.animation_finished
	SPEED = 0
	$"../../Player".max_jump = 2
	$"../../GUI/PuloDuplo".show()
	$"../../GUI/PuloDuplo/Barradialogo".show()
	$"../../GUI/PuloDuplo/Ok".show()
	$"../../GUI/PuloDuplo/Label4".show()
	$"../../GUI/PuloDuplo/Label5".show()
	queue_free()

func _on_atack_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		$CanvasLayer.show()



func _on_bar_show_collider_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$CanvasLayer.show()


func _on_bar_show_collider_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		$CanvasLayer.show()
