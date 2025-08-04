extends Node2D

var multiplayer_peer = ENetMultiplayerPeer.new()

func _ready():
	join("127.0.0.1", 9999)

func join(ip, port):
	multiplayer_peer.create_client(ip, port)
	multiplayer.multiplayer_peer = multiplayer_peer
	
func send_move(start_pos, end_pos, promotion = null):
	rpc_id(1, "send_move_info", start_pos, end_pos, promotion)

@rpc
func send_move_info():
	pass

@rpc("authority")
func return_enemy_move(start_pos, end_pos, promotion):
	$Board.set_move(start_pos, end_pos, promotion)

@rpc("authority")
func give_turn(turn):
	$Board.set_turn(turn)
