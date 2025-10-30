extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		sprite.play("jump")


	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		sprite.play("jump")
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")		
	if direction:
		velocity.x = direction * SPEED
		if not velocity.y:
			sprite.play("move")
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			sprite.play("default")

	move_and_slide()
