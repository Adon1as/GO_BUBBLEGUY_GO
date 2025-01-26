extends TextureButton

@onready var label: Label = $Label

@export var text_button: String = "BUTTON";

const HOVER_SCALE: Vector2 = Vector2(1.1, 1.1);
const DEFAULT_SCALE: Vector2 = Vector2(1.0, 1.0);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = text_button;

func _on_mouse_entered() -> void:
	scale = HOVER_SCALE;

func _on_mouse_exited() -> void:
	scale = DEFAULT_SCALE;
