extends Spatial

var link = preload("res://link.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Instance two links of a chain
	var node1 = link.instance()
	var node2 = link.instance()
	
	# Add them to the scene tree
	self.add_child(node1)
	self.add_child(node2)
	
	# Create joint
	var joint = ConeTwistJoint.new()
	
	# Visualize joint location with a box
	var vis_box = CSGBox.new()
	
	# Get nodepaths to each link
	var path1 = get_path_to(node1)
	var path2 = get_path_to(node2)
	
	# Attach joint to each node
	joint.set_node_a(path1)
	joint.set_node_b(path2)
	
	# Add joint and visualizing box to scene tree
	self.add_child(joint)
	joint.add_child(vis_box)
