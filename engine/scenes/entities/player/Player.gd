extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 1.5
@export var recoil_speed = 4000

var last_char_direction = Vector2(0,0)
var can_shoot = true

func push_player_back():
	velocity = -last_char_direction * recoil_speed


func get_inputs():
	var input_direction = Input.get_vector("left", "right", "up", "down")

	if input_direction != Vector2(0,0):
		last_char_direction = input_direction

	look_at(global_position + input_direction)

	velocity = input_direction * speed

	if Input.is_action_pressed("main_action") and input_direction:
		velocity = Vector2(0, 0)
	
	if Input.is_action_just_released("main_action") and can_shoot:
		can_shoot = false
		push_player_back()
		$Timer.start()


func _physics_process(delta):
	if can_shoot:
		get_inputs()

	move_and_slide()


func _on_timer_timeout():
	can_shoot = true
