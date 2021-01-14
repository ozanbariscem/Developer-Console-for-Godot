class_name DeveloperConsole
extends Node2D


signal console_toggle() # You can use this to ignore camera shortcut keys while console is open

# Examples
signal clear()
signal echo(input)
signal multiply(a, b)


var text: RichTextLabel = null
var edit: LineEdit = null
var console: Node2D = null

var command_history: Array = []
var command_history_count: int = 0
var at_command_index: int = 0

var last_typed: String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	text = $"Console/Text"
	text.text = ""
	
	edit = $"Console/LineEdit"
	edit.text = ""
	
	console = $Console
	console.visible = false
	pass # Replace with function body.


func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_QUOTELEFT:
			emit_signal("console_toggle")
		elif console.visible:
			if event.scancode == KEY_UP:
				if command_history_count > 0 and at_command_index != 0:
					if at_command_index == command_history_count:
						last_typed = edit.text

					at_command_index -= 1
					edit.text = command_history[at_command_index]

			if event.scancode == KEY_DOWN:
				if command_history_count > 0 and at_command_index != command_history_count:
					at_command_index += 1

				if at_command_index == command_history_count:
					edit.text = last_typed
				else:
					edit.text = command_history[at_command_index]


func _on_LineEdit_text_entered(new_text):
	edit.text = ""
	new_command(new_text)


func new_command(comm) -> void:
	add_to_history(comm)
	
	text.text += "in: " + comm + "\n"
	
	var args = comm.split(" ")
	var arg_len = len(args)
	
	match arg_len:
		1:
			emit_signal(args[0])
		2:
			emit_signal(args[0], args[1])
		3:
			emit_signal(args[0], args[1], args[2])
		_:
			pass
	pass # Replace with function body.


func add_to_history(comm) -> void:
	if command_history_count == 0 or command_history[command_history_count - 1] != comm:
		command_history_count += 1
		command_history += [comm]
	at_command_index = command_history_count


func output(addition) -> void:
	text.text += "out: " + addition + "\n"


func _on_DeveloperConsole_clear():
	text.text = ""
	pass


func _on_DeveloperConsole_multiply(a, b):
	output(str(int(a) * int(b)))
	pass # Replace with function body.


func _on_DeveloperConsole_echo(input):
	output(input)
	pass # Replace with function body.


func _on_DeveloperConsole_console_toggle():
	print("?")
	console.visible = !console.visible
	pass # Replace with function body.
