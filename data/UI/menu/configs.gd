extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
			get_parent().remove_child(self)



func _on_item_selected(index: int) -> void:
	print("a")
	match index:
		0:
			#get_tree().root.content_scale_size = Vector2i(1920, 1080)
			#get_tree().root.set_size(Vector2i(1920, 1080))
			pass
		
		1:
			#get_tree().root.content_scale_size = Vector2i(1280, 720)
			#get_tree().root.set_size(Vector2i(1280, 720))
			pass
		2:
			#get_tree().root.content_scale_size = Vector2i(640, 360)
			#get_tree().root.set_size(Vector2i(640, 360))
			pass


#func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	#if toggled_on:
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	#else:
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
