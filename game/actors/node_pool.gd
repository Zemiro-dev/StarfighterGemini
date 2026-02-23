extends Resource
class_name NodePool

var nodes: Array[Node] = []
var pack: PackedScene
var last_used: int = 0
var spawn_signal: Signal

func fill(_pack: PackedScene, size: int) -> void:
	for node in nodes:
		node.queue_free()
	nodes = []
	pack = _pack
	add(size)
	last_used = nodes.size() - 1


func add(amount: int) -> void:
	for i in range(amount):
		if pack.can_instantiate():
			var node = pack.instantiate()
			node.ready.connect(func(): nodes.append(node))
			spawn_signal.emit(node)
			


func get_nodes(amount: int) -> Array[Node]:
	var available_nodes: Array[Node] = []
	var i = next_pool_index(last_used)
	var next_last_used: int = last_used
	while available_nodes.size() < amount && i != last_used:
		if !!nodes[i].get("is_available"):
			nodes[i].is_available = false
			available_nodes.append(nodes[i])
			next_last_used = i
		i = next_pool_index(i)
	if available_nodes.size() < amount:
		print("could not satisfy request")
	return available_nodes


func next_pool_index(last: int):
	return (last + 1) % nodes.size()
