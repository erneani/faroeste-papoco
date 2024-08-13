extends CharacterBody2D

@export var speed = 400

var rotation_x = 0
var rotation_y = 0

func get_inputs():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var is_shoot_pressed = Input.is_action_pressed("main_action")

	velocity = input_direction * speed
	
	if is_shoot_pressed:
		velocity = Vector2(0, 0)


func _physics_process(delta):
	get_inputs()
	
	print(rotation_x, " ", rotation_y)
	
	move_and_slide()
