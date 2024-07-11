extends Node2D

# Trocar esses valores para os melhores, pode ser feito aqui ou no menu do nó na cena
@export var MAX_ANGLE: int = 70
@export var THRESHOLD: float = 0.5
@export var HOST: String = "127.0.0.1"
@export var PORT: int = 1111
const RECONNECT_TIMEOUT: float = 3.0

# Parte do funcionamento do cliente TCP daqui https://www.bytesnsprites.com/posts/2021/creating-a-tcp-client-in-godot/

const Client = preload("res://Server/ControllerClient.gd")
var _client: Client = Client.new()

func _ready() -> void:
	_client.connect("connected", _handle_client_connected)
	_client.connect("disconnected", _handle_client_disconnected)
	_client.connect("error", _handle_client_error)
	_client.connect("data", _handle_client_data)
	add_child(_client)
	_client.connect_to_host(HOST, PORT)

func _connect_after_timeout(timeout: float) -> void:
	await get_tree().create_timer(timeout).timeout # Delay for timeout
	_client.connect_to_host(HOST, PORT)

func _handle_client_connected() -> void:
	print("Conectei no servidor TCP.")

func _handle_client_data(data) -> void:
	#  { x: leftToRight, y: frontToBack, z: rotateDegrees  };
	var size = Vector2(
		$Joystick.texture.get_width(), 
		$Joystick.texture.get_height()
	)
		
	var input_vector = Vector2(
		clamp(data.x, -MAX_ANGLE, MAX_ANGLE)/MAX_ANGLE,
		clamp(data.y, -MAX_ANGLE, MAX_ANGLE)/MAX_ANGLE
	)
	
	Input.action_press("ui_left", 1 if input_vector.x <= -THRESHOLD else 0)
	Input.action_press("ui_right", 1 if input_vector.x >= THRESHOLD else 0) 
	Input.action_press("ui_down", 1 if input_vector.y >= THRESHOLD else 0.0)
	Input.action_press("ui_up", 1 if input_vector.y <= -THRESHOLD else 0.0)
	
	var newPos = Vector2(
		size.x/2*input_vector.x,
		size.y/2*input_vector.y
	)
		
	$Joystick/Position.position = newPos

func _handle_client_disconnected() -> void:
	print("Client disconnected from server.")
	_connect_after_timeout(RECONNECT_TIMEOUT) # Try to reconnect after 3 seconds

func _handle_client_error() -> void:
	print("Client error.")
	_connect_after_timeout(RECONNECT_TIMEOUT) # Try to reconnect after 3 seconds
