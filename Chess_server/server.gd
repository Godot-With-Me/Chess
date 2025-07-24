extends Node2D

var multiplayer_peer = ENetMultiplayerPeer.new()

var connected_peer_ids = []

var turn = true if randi_range(0, 1) else false

func _ready():
	host(9999)

func host(port):
	multiplayer_peer.create_server(port)
	multiplayer.multiplayer_peer = multiplayer_peer
	
	multiplayer_peer.peer_connected.connect(
		func(peer_id = multiplayer.get_unique_id()):
			add_player(peer_id)
	)
	
	multiplayer_peer.peer_disconnected.connect(
		func(peer_id = multiplayer.get_unique_id()):
			remove_player(peer_id)
	)
	
func add_player(peer_id):
	if connected_peer_ids.size() < 2:
		connected_peer_ids.append(peer_id)
		if connected_peer_ids.size() == 2:
			rpc_id(connected_peer_ids[0], "give_turn", turn)
			rpc_id(connected_peer_ids[1], "give_turn", !turn)

func remove_player(peer_id):
	connected_peer_ids.erase(peer_id)

@rpc("any_peer")
func send_move_info(id, start_pos, end_pos, promotion):
	if id == connected_peer_ids[0] && turn:
		rpc_id(connected_peer_ids[1], "return_enemy_move", start_pos, end_pos, promotion)
		turn = !turn
	elif id == connected_peer_ids[1] && !turn:
		rpc_id(connected_peer_ids[0], "return_enemy_move", start_pos, end_pos, promotion)
		turn = !turn
	
@rpc("authority")
func return_enemy_move():
	pass
	
@rpc("authority")
func give_turn():
	pass
