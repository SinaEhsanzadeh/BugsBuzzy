extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var attacking = false
@onready var isgoingleft = false
@onready var hurtboxsprite = $Hurtbox/AnimatedSprite2D
const SPEED = 200.0
const JUMP_VELOCITY = -300.0

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	hurtboxsprite.play("slash")

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		sprite.play("jump")


	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		sprite.play("jump")
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("ui_left", "ui_right")		
	if direction:
		velocity.x = direction * SPEED
		if not velocity.y:
			sprite.play("move")
			
		if direction < 0 and not isgoingleft:
			self.scale.x = -1
			isgoingleft = true
		
		if direction > 0 and isgoingleft:
			self.scale.x = -1
			isgoingleft = false
			
		
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			sprite.play("default")

	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		pass
