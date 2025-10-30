extends Node2D

@onready var health_label = $Number_of_lives/Label

func _ready():
	print("Health label: ", health_label)  # چک کن null نباشه
	
	if health_label:
		health_label.text = "Health: 100"
		health_label.modulate = Color.WHITE
		print("Health label setup successful!")
	else:
		print("ERROR: Health label is null!")
		
		# سعی کن دستی پیدا کنی
		find_health_label()

func find_health_label():
	var canvas = $CanvasLayer
	if canvas:
		print("CanvasLayer found")
		
		# همه فرزندان CanvasLayer رو چک کن
		for child in canvas.get_children():
			print("Child: ", child.name, " Type: ", child.get_class())
			if child is Label:
				print("Found Label: ", child.name)
				child.text = "Health: 100"
				child.modulate = Color.WHITE
				return child
	else:
		print("ERROR: CanvasLayer not found!")
	
	return null
