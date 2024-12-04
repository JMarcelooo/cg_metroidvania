extends CharacterBody2D

var SPEED = 60
@export var time = 1.5
const JUMP_FORCE = -400
@export var gravity = 30
var facing_right = true


func _ready() -> void:
	var flip_timer = $Timer
	flip_timer.start(time)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimatedSprite2D.play("Walking")
	
	velocity.x = SPEED
	move_and_slide()


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
		$AnimatedSprite2D.play("Dead")
		SPEED = 0
		await $AnimatedSprite2D.animation_finished
		queue_free()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("colisão")
		var animation = body.get_node("AnimationPlayer")
		if animation:
			animation.play("Dead")
			await animation.animation_finished
			queue_free()
