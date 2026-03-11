extends CanvasLayer
@onready var anim = $AnimationPlayer

## Animações disponíveis:
## [br]
## 1 -> sharp_in [br]
## 2 -> sharp_out
enum Transition {
	SHARP_IN,
	SHARP_OUT,
	FADE_IN,
	FADE_OUT
}

var dict = {
	Transition.SHARP_IN : "transition_sharp_In",
	Transition.SHARP_OUT : "transition_sharp_out",
	Transition.FADE_IN : "Fade_In",
	Transition.FADE_OUT : "Fade_Out",
}

func _ready() -> void:
	visible = false


## Veja o [enum Transition] para pegar a animação correta
func play(animation : Transition):
	visible = true
	if anim.has_animation(dict[animation]):
		anim.play(dict[animation])
	await anim.animation_finished
	get_tree().paused = false
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
