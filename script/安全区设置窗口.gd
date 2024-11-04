extends Node

func 水平缩放(value):
	$'表格/垂直调整/滑块'.value=0.0
	$'表格/水平调整/滑块'.value=0.0
	$'表格/水平缩放/数字'.text=var_to_str(value)
	$'/root/根场景/根界面'.offset_left=value*4
	$'/root/根场景/根界面'.offset_right=-value*4
	$'/root/根场景/根界面/设置'.屏幕安全区数据[0]=value
	pass # Replace with function body.


func 垂直缩放(value):
	$'表格/垂直调整/滑块'.value=0.0
	$'表格/水平调整/滑块'.value=0.0
	$'表格/垂直缩放/数字'.text=var_to_str(value)
	$'/root/根场景/根界面'.offset_top=value*4
	$'/root/根场景/根界面'.offset_bottom=-value*4
	$'/root/根场景/根界面/设置'.屏幕安全区数据[1]=value
	pass # Replace with function body.
	
func 水平调整(value):
	$'表格/水平调整/数字'.text=var_to_str(value)
	$'/root/根场景/根界面/设置'.屏幕安全区数据[2]=value
	if value<=0:
		$'/root/根场景/根界面'.offset_left=-value*4
	else:
		$'/root/根场景/根界面'.offset_right=-value*4
	pass # Replace with function body.
	
func 垂直调整(value):
	$'表格/垂直调整/数字'.text=var_to_str(value)
	$'/root/根场景/根界面/设置'.屏幕安全区数据[3]=value
	if value<=0:
		$'/root/根场景/根界面'.offset_top=-value*4
	else:
		$'/root/根场景/根界面'.offset_bottom=-value*4
	pass # Replace with function body.


func 重置():
	$'表格/垂直调整/滑块'.value=0.0
	$'表格/水平调整/滑块'.value=0.0
	$'表格/垂直缩放/滑块'.value=0.0
	$'表格/水平缩放/滑块'.value=0.0
	$'/root/根场景/根界面'.offset_top=0
	$'/root/根场景/根界面'.offset_bottom=0
	$'/root/根场景/根界面'.offset_left=0
	$'/root/根场景/根界面'.offset_right=0
	$'/root/根场景/根界面/设置'.屏幕安全区数据=[0.0,0.0,0.0,0.0]
	pass # Replace with function body.
