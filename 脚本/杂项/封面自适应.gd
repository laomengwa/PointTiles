extends AspectRatioContainer

#封面自适应
func _process(帧处理):
	self.custom_minimum_size[1]=self.size[0]*(1/self.ratio)
	pass
