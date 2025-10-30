extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var hurtboxsprite = $Hurtbox/AnimatedSprite2D

var attacking = false
var isgoingleft = false
var health: int = 100  # سلامت پلییر

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	attacking = true
	hurtboxsprite.play("slash")
	# بعد از اتمام انیمیشن حمله، attacking رو false کن
	await hurtboxsprite.animation_finished
	attacking = false

func _physics_process(delta: float) -> void:
	# اضافه کردن گرانش
	if not is_on_floor():
		velocity.y += gravity * delta
		if not attacking:
			sprite.play("jump")

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		if not attacking:
			sprite.play("jump")
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("ui_left", "ui_right")		
	if direction and not attacking:
		velocity.x = direction * SPEED
		if is_on_floor():
			sprite.play("move")
			
		if direction < 0 and not isgoingleft:
			self.scale.x = -1
			isgoingleft = true
		
		if direction > 0 and isgoingleft:
			self.scale.x = -1
			isgoingleft = false
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and not attacking:
			sprite.play("default")

	move_and_slide()

# تابع برای دریافت آسیب
func take_damage(amount: int):
	health -= amount
	print("Player health: ", health)
	
	if health <= 0:
		die()

func die():
	print("Player Died!")
	get_tree().reload_current_scene()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		# وقتی دشمن لمس میشه، آسیب دریافت کن
		take_damage(10)
