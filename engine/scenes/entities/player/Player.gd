extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 1.5
@export var bullet_recoil = 10

func get_inputs():
	var input_direction = Input.get_vector("left", "right", "up", "down")

	look_at(global_position + input_direction)

	velocity = input_direction * speed

	if Input.is_action_pressed("main_action") and input_direction:
		velocity = Vector2(0, 0)
	
	if Input.is_action_just_released("main_action"):
		velocity = -velocity * bullet_recoil



func _physics_process(delta):
	get_inputs()

	move_and_slide()
