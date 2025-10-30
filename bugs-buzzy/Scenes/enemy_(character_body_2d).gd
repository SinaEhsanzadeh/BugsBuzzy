extends CharacterBody2D

# سرعت حرکت دشمن
@export var speed: int = 50
# محدوده حرکت به واحد پیکسل
@export var patrol_range: float = 50.0
# میزان آسیب دشمن
@export var damage_amount: int = 10

# نقطه شروع حرکت
var start_position: Vector2
# جهت حرکت (1 برای راست، -1 برای چپ)
var direction: int = 1

func _ready():
	# موقعیت اولیه دشمن را ذخیره می‌کنیم
	start_position = position
	$AnimatedSprite2D.play("walk")
	add_to_group("enemies")  # دشمن رو به گروه enemies اضافه کن

func _physics_process(delta):
	# حرکت رفت و برگشتی
	patrol_movement(delta)
	
	# حرکت و چک کردن برخورد
	move_and_slide()
	
	# چک کن ببین با پلییر برخورد کرده یا نه
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		# اگر با پلییر برخورد کردی
		if collider != null and collider.is_in_group("player"):
			# به پلییر آسیب بزن
			collider.take_damage(damage_amount)

func patrol_movement(_delta):
	# اگر از محدوده مجاز خارج شد، جهت حرکت را عکس کن
	if position.x > start_position.x + patrol_range:
		direction = -1
	elif position.x < start_position.x - patrol_range:
		direction = 1
		
	# اگر به سمت چپ حرکت می‌کنیم، اسپرایت را برگردان
	if direction == -1:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		
	# سرعت را در جهت مورد نظر تنظیم کن
	velocity.x = direction * speed
	# سرعت در راستای Y را صفر نگه دار
	velocity.y = 0
