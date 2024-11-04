extends AspectRatioContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.custom_minimum_size[1]=self.size[0]*(1/self.ratio)
	pass
