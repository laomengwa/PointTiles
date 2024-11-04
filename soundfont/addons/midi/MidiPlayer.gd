##
##	100% pure GDScript MIDI Player [Godot MIDI Player] by あるる（きのもと 結衣） @arlez80
##
##	MIT 协议
##
##插件原作者: あるる（きのもと 結衣）
##
##注释使用机器翻译（原语言为日语）
@icon("icon.png")
class_name MidiPlayer

extends Node

# -----------------------------------------------------------------------------
# 预加载
const ADSR = preload( "ADSR.tscn" )

# -------------------------------------------------------
# 定数

## 最大曲目数
const max_track:int = 16
## 最大通道数
const max_channel:int = 16
## 最大音符数
const max_note_number:int = 128
## 最大程序编号
const max_program_number:int = 128
## 鼓轨道通道数
const drum_track_channel:int = 0x09

## MIDI 主总线名称
const midi_master_bus_name:String = "arlez80_GMP_MASTER_BUS"
## MIDI 通道总线名称
const midi_channel_bus_name:String = "arlez80_GMP_CHANNEL_BUS%d"

# -----------------------------------------------------------------------------
# Classes

## 每个通道的效果管理
class GodotMIDIPlayerChannelAudioEffect:
	## 声道均衡
	var ae_panner:AudioEffectPanner = null
	## 混响
	var ae_reverb:AudioEffectReverb = null
	## 合唱
	var ae_chorus:AudioEffectChorus = null

## 系统独占管理
class GodotMIDIPlayerSysEx:
	## GS Reset
	## 波表合成器重置
	var gs_reset:bool
	## GM System オン
	## GM 系统打开
	var gm_system_on:bool
	## XG System オン
	## XG 系统打开
	var xg_system_on:bool

	## 构造函数
	func _init():
		self.initialize( )

	## 初期化
	##
	## 全部未收到的情况下
	func initialize( ) -> void:
		self.gs_reset = false
		self.gm_system_on = false
		self.xg_system_on = false

## 播放曲目状态
class GodotMIDIPlayerTrackStatus:
	## 事件
	var events:Array[SMF.MIDIEventChunk] = []
	## 事件指针
	var event_pointer:int = 0

## 通道状态
class GodotMIDIPlayerChannelStatus:
	## 通道号
	var number:int
	## 曲目名称
	var track_name:String
	## 乐器名
	var instrument_name:String
	## 清单上的注释
	var note_on:Dictionary
	## 通道静音
	var mute:bool

	## 选择乐器组编号
	var bank:int
	## 程序编号
	var program:int
	## 弯音值
	var pitch_bend:float

	## 音量値
	var volume:float
	## 表达式值
	var expression:float
	## 混响：效果 1
	var reverb:float
	## 颤音：效果 2
	var tremolo:float
	## 合唱：效果 3
	var chorus:float
	## 钢片音：效果 4
	var celeste:float
	## 音色调制：效果 5
	var phaser:float
	## 调制
	var modulation:float
	## 保持/阻尼器（保持 1）
	var hold:bool
	## 滑音
	var portamento:float
	## 踏板延音
	var sostenuto:float
	## 冻结
	var freeze:bool
	## 声道均衡
	var pan:float

	## 鼓声轨道
	var drum_track:bool

	## RPN 统计数字
	var rpn:GodotMIDIPlayerChannelStatusRPN

	## 构造函数
	## @param	_number		通道号
	## @param	_bank		引用乐器组编号
	## @param	_drum_track	 鼓声轨道
	func _init(_number:int,_bank:int = 0,_drum_track:bool = false):
		self.number = _number
		self.track_name = "Track %d" % _number
		self.instrument_name = "Track %d" % _number
		self.mute = false
		self.bank = _bank
		self.drum_track = _drum_track
		self.rpn = GodotMIDIPlayerChannelStatusRPN.new( )
		self.initialize( )

	## 通知（用于内存丢弃）
	## @param	what	通知要因
	func _notification( what:int ):
		if what == NOTIFICATION_PREDELETE:
			self.note_on.clear( )

	##  通道初始化
	func initialize( ) -> void:
		self.note_on = {}
		self.program = 0

		self.pitch_bend = 0.0
		self.volume = 100.0 / 127.0
		self.expression = 1.0
		self.reverb = 0.0
		self.tremolo = 0.0
		self.chorus = 0.0
		self.celeste = 0.0
		self.phaser = 0.0
		self.modulation = 0.0
		self.hold = false
		self.portamento = 0.0
		self.sostenuto = 0.0
		self.freeze = false
		self.pan = 0.5

		self.rpn.initialize( )

## RPN 通道状态
class GodotMIDIPlayerChannelStatusRPN:
	## 选定的 MSB
	var selected_msb:int
	## 选定的 LSB
	var selected_lsb:int
	
	## 弯音
	var pitch_bend_sensitivity:float
	var pitch_bend_sensitivity_msb:float
	var pitch_bend_sensitivity_lsb:float
	
	## 调制
	var modulation_sensitivity:float
	var modulation_sensitivity_msb:float
	var modulation_sensitivity_lsb:float

	## 约束
	func _init():
		self.initialize( )

	## RPN初期化
	func initialize( ) -> void:
		self.selected_msb = 0
		self.selected_lsb = 0
		
		self.pitch_bend_sensitivity = 2.0
		self.pitch_bend_sensitivity_msb = 2.0
		self.pitch_bend_sensitivity_lsb = 0.0
		
		self.modulation_sensitivity = 0.25
		self.modulation_sensitivity_msb = 0.25
		self.modulation_sensitivity_lsb = 0.0

# -----------------------------------------------------------------------------
# Export

## 最大发音数
@export_range (0, 1024) var max_polyphony:int = 96 : set = set_max_polyphony
## 文件
@export_file ("*.mid") var file:String = "" : set = set_file
## 自动播放
@export var playing:bool = false
## 再生速度
@export_range (0.0, 100.0) var play_speed:float = 1.0
## 音量
@export_range (-80.0, 0.0) var volume_db:float = -20.0 : set = set_volume_db
## 半音偏移
@export var key_shift:int = 0
## 循环
@export var loop:bool = false
## 循环播放的开始位置
@export var loop_start:float = 0.0
## 使用声音字体文件中的所有乐器声音
@export var load_all_voices_from_soundfont:bool = true
## 声音字体文件
@export_file ("*.sf2") var soundfont:String = "" : set = set_soundfont
## 合成
@export var mix_target:AudioStreamPlayer.MixTarget = AudioStreamPlayer.MIX_TARGET_STEREO
## 出力先
@export var bus:StringName = &"Master"
## 1 秒的处理次数
@export_range (10, 480) var sequence_per_seconds:int = 120

# -----------------------------------------------------------------------------
# 変数

## MIDI 数据
var smf_data:SMF.SMFData = null : set = set_smf_data
## MIDI 轨道数据 包含从smf_data处理以进行播放的数据。
@onready var track_status:GodotMIDIPlayerTrackStatus = GodotMIDIPlayerTrackStatus.new( )
## 当前速度
var tempo:float = 120.0 : set = set_tempo
## 秒 -> 基于时间的转换系数
var seconds_to_timebase:float = 2.3
## 基于时间 -> 秒変換係数
var timebase_to_seconds:float = 1.0 / seconds_to_timebase
## 位置
var position:float = 0.0
## 最終位置
var last_position:int = 0
## 通道状态
var channel_status:Array[GodotMIDIPlayerChannelStatus]
## 为播放而修改的声音字体文件
var bank:Bank = null
## 用于播放的 AudioStreamPlayer 列表
var audio_stream_players:Array[AudioStreamPlayerADSR] = []
## 鼓轨道的分配组
var drum_assign_groups:Dictionary = {
	# Hi-Hats
	42: 42,	# Closed Hi-Hat
	44: 42,	# Pedal Hi-Hat
	46: 42,	# Pedal Hi-Hat
	# Whistle
	71: 71,	# Short Whistle
	72: 71,	# Long Whistle
	# Guiro
	73: 73,	# Short Guiro
	74: 73,	# Long Guiro
	# Cuica
	78: 78,	# Mute Cuica
	79: 78,	# Open Cuica
}
## 系统独占管理
@onready var sys_ex:GodotMIDIPlayerSysEx = GodotMIDIPlayerSysEx.new( )

## MIDI 通道前缀
var _midi_channel_prefix:int = 0
## 包含歌曲正在使用的节目编号
var _used_program_numbers:Array[int] = []
## MIDI 通道效果
var channel_audio_effects:Array[GodotMIDIPlayerChannelAudioEffect] = []
## 定义声道平衡的强度
var pan_power:float = 1.0
## 定义混响的强度
var reverb_power:float = 0.5
## 定义合唱的强度
var chorus_power:float = 0.7
## 准备播放状态
var prepared_to_play:bool = false
## 初始化 AudioServer
var is_audio_server_inited:bool = false
## 播放时间？
var _previous_time:float

# -----------------------------------------------------------------------------
# 信号

## 节奏变化
signal changed_tempo( tempo )
## 文本事件
signal appeared_text_event( text )
## 著作権情報
signal appeared_copyright( copyright )
## 曲目名称
signal appeared_track_name( channel_number, name )
## 楽器名
signal appeared_instrument_name( channel_number, name )
## 歌詞
signal appeared_lyric( lyric )
## 标记
signal appeared_marker( marker )
## 提示点
signal appeared_cue_point( cue_point )
## GM 系统打开
signal appeared_gm_system_on
## GS重置
signal appeared_gs_reset
## XG 系统打开
signal appeared_xg_system_on
## 原始 MIDI 事件
signal midi_event( channel, event )
## 在循环中
signal looped
## 終了
signal finished

## 準備
func _ready( ):
	if AudioServer.get_bus_index( self.midi_master_bus_name ) == -1:
		AudioServer.add_bus( -1 )
		var midi_master_bus_idx:int = AudioServer.get_bus_count( ) - 1
		AudioServer.set_bus_name( midi_master_bus_idx, self.midi_master_bus_name )
		AudioServer.set_bus_send( midi_master_bus_idx, self.bus )
		AudioServer.set_bus_volume_db( AudioServer.get_bus_index( self.midi_master_bus_name ), self.volume_db )

		for i in range( 0, 16 ):
			AudioServer.add_bus( -1 )
			var midi_channel_bus_idx:int = AudioServer.get_bus_count( ) - 1
			AudioServer.set_bus_name( midi_channel_bus_idx, self.midi_channel_bus_name % i )
			AudioServer.set_bus_send( midi_channel_bus_idx, self.midi_master_bus_name )
			AudioServer.set_bus_volume_db( midi_channel_bus_idx, 0.0 )

			var cae: = GodotMIDIPlayerChannelAudioEffect.new( )
			cae.ae_panner = AudioEffectPanner.new( )
			cae.ae_reverb = AudioEffectReverb.new( )
			cae.ae_reverb.wet = 0.03
			cae.ae_chorus = AudioEffectChorus.new( )
			cae.ae_chorus.wet = 0.0
			AudioServer.add_bus_effect( midi_channel_bus_idx, cae.ae_chorus )
			AudioServer.add_bus_effect( midi_channel_bus_idx, cae.ae_panner )
			AudioServer.add_bus_effect( midi_channel_bus_idx, cae.ae_reverb )
			self.channel_audio_effects.append( cae )
	else:
		for i in range( 0, 16 ):
			var midi_channel_bus_idx:int = 0
			for k in range( AudioServer.get_bus_count( ) ):
				if AudioServer.get_bus_name( k ) == self.midi_channel_bus_name % i:
					midi_channel_bus_idx = k
					break

			var cae: = GodotMIDIPlayerChannelAudioEffect.new( )
			for k in range( AudioServer.get_bus_effect_count( midi_channel_bus_idx ) ):
				var ae: = AudioServer.get_bus_effect( midi_channel_bus_idx, k )
				if ae is AudioEffectPanner:
					cae.ae_panner = ae
				elif ae is AudioEffectReverb:
					cae.ae_reverb = ae
				elif ae is AudioEffectChorus:
					cae.ae_chorus = ae
			self.channel_audio_effects.append( cae )
	self.is_audio_server_inited = true

	self.channel_status = []
	for i in range( max_channel ):
		var drum_track:bool = ( i == drum_track_channel )
		var _bank:int = 0
		if drum_track:
			_bank = Bank.drum_track_bank
		self.channel_status.append( GodotMIDIPlayerChannelStatus.new( i, _bank, drum_track ) )

	self.set_max_polyphony( self.max_polyphony )
	self.set_volume_db( self.volume_db )

	if self.playing:
		self.play( )

## 通知
## @param	what	通知要因
func _notification( what:int ):
	# 破棄時
	if what == NOTIFICATION_PREDELETE:
		pass
		#我决定不删除它，因为我会重复使用它。
		#AudioServer.remove_bus( AudioServer.get_bus_index( self.midi_master_bus_name ) )
		#for i in range( 0, 16 ):
		#	AudioServer.remove_bus( AudioServer.get_bus_index( self.midi_channel_bus_name % i ) )

## 播放前的初始化
func _prepare_to_play( ) -> bool:
	# midi文件加载
	if self.smf_data == null:
		var smf_reader: = SMF.new( )
		var result: = smf_reader.read_file( self.file )
		#解析成功
		if result.error == OK:
			self.smf_data = result.data
			self.playing = true
		#解析失败
		else:
			self.smf_data = null
			self.playing = false
			return false
	self.sys_ex.initialize( )
	#分析音轨？
	self._init_track( )
	#分析事件?
	self._analyse_smf( )
	self._init_channel( )

	# 重新加载 SoundFonts
	if not self.load_all_voices_from_soundfont:
		self.set_soundfont( self.soundfont )

	return true

## 跟踪初始化
func _init_track( ) -> void:
	var track_status_events:Array[SMF.MIDIEventChunk] = []
	#单个音轨
	if len( self.smf_data.tracks ) == 1:
		track_status_events = self.smf_data.tracks[0].events
	else:
		# 将多个音轨混音为单个音轨
		var tracks:Array[Dictionary] = []
		var track_id:int = 0
		for track in self.smf_data.tracks:
			tracks.append({"track_id": track_id, "pointer":0, "events":track.events, "length": len( track.events )})
			track_id += 1

		var time:int = 0
		var finished:bool = false
		while not finished:
			finished = true

			var next_time:int = 0x7fffffff
			for track in tracks:
				var p = track.pointer
				if track.length <= p: continue
				finished = false
				
				var e:SMF.MIDIEventChunk = track.events[p]
				var e_time:int = e.time
				if e_time == time:
					track_status_events.append( e )
					track.pointer += 1
					next_time = e_time
				elif e_time < next_time:
					next_time = e_time
			time = next_time
	GlobalScript.数码乐谱文件数据=smf_data
	self.last_position = track_status_events[len(track_status_events)-1].time
	self.track_status.events = track_status_events
	self.track_status.event_pointer = 0

## SMF解析
func _analyse_smf( ) -> void:
	var channels:Array[Dictionary] = []
	for i in range( max_channel ):
		channels.append({ "number": i, "bank": 0, })
	self.loop_start = 0.0
	self._used_program_numbers = [0, Bank.drum_track_bank << 7]	# GrandPiano and Standard Kit
	#循环 track_status.events 的所有事件?
	for event_chunk in self.track_status.events:
		var channel_number:int = event_chunk.channel_number
		var channel = channels[channel_number]
		var event = event_chunk.event
		match event.type:
			SMF.MIDIEventType.program_change:
				var program_number:int = event.number | ( channel.bank << 7 )
				if not( event.number in self._used_program_numbers ):
					self._used_program_numbers.append( event.number )
				if not( program_number in self._used_program_numbers ):
					self._used_program_numbers.append( program_number )
			SMF.MIDIEventType.control_change:
				match event.number:
					SMF.control_number_bank_select_msb:
						if channel.number == drum_track_channel:
							channel.bank = Bank.drum_track_bank
						else:
							channel.bank = ( channel.bank & 0x7F ) | ( event.value << 7 )
					SMF.control_number_bank_select_lsb:
						if channel.number == drum_track_channel:
							channel.bank = Bank.drum_track_bank
						else:
							channel.bank = ( channel.bank & 0x3F80 ) | ( event.value & 0x7F )
					SMF.control_number_tkool_loop_point:
						self.loop_start = float( event_chunk.time )
			_:
				pass

## 通道初始化
func _init_channel( ) -> void:
	for channel in self.channel_status:
		channel.initialize( )

## 再生
## @param	from_position	再生位置
func play( from_position:float = 0.0 ) -> void:
	self._previous_time = 0.0
	if not self._prepare_to_play( ):
		self.playing = false
		return
	self.playing = true
	if from_position == 0.0:
		self.position = 0.0
		self.track_status.event_pointer = 0
	else:
		self.seek( from_position )

## 请求
## @param	from_position	再生位置
func seek( to_position:float ) -> void:
	self._previous_time = 0.0
	self._stop_all_notes( )
	self.position = to_position

	var pointer:int = 0
	var new_position:int = int( floor( self.position ) )
	var length:int = len( self.track_status.events )
	for event_chunk in self.track_status.events:
		if new_position <= event_chunk.time:
			break

		var channel:GodotMIDIPlayerChannelStatus = self.channel_status[event_chunk.channel_number]
		var event:SMF.MIDIEvent = event_chunk.event
		match event.type:
			SMF.MIDIEventType.program_change:
				channel.program = ( event as SMF.MIDIEventProgramChange ).number
			SMF.MIDIEventType.control_change:
				var event_control_change:SMF.MIDIEventControlChange = event as SMF.MIDIEventControlChange
				self._process_track_event_control_change( channel, event_control_change.number, event_control_change.value )
			SMF.MIDIEventType.pitch_bend:
				self._process_pitch_bend( channel, ( event as SMF.MIDIEventPitchBend ).value )
			SMF.MIDIEventType.system_event:
				self._process_track_system_event( channel, event as SMF.MIDIEventSystemEvent )
			_:
				# 無視
				pass
		pointer += 1
	self.track_status.event_pointer = pointer

## 停止
func stop( ) -> void:
	self._previous_time = 0.0
	self._stop_all_notes( )
	self.playing = false

## 强制复位指令
func send_reset( ) -> void:
	self._process_track_sys_ex_reset_all_channels( )

## 文件修改
## @param	path	文件路径
func set_file( path:String ) -> void:
	file = path
	self.stop( )
	self.smf_data = null

## 同时发音数量更改
## @param	mp	同時発音数
func set_max_polyphony( mp:int ) -> void:
	max_polyphony = mp

	# 删除多余音频节点
	for asp in self.audio_stream_players:
		self.remove_child( asp )

	# 再重新生成节点
	self.audio_stream_players = []
	for i in range( max_polyphony ):
		var audio_stream_player:AudioStreamPlayerADSR = ADSR.instantiate( )
		audio_stream_player.mix_target = self.mix_target
		audio_stream_player.bus = self.bus
		self.add_child( audio_stream_player )
		self.audio_stream_players.append( audio_stream_player )

## SoundFont 更改
## @param	path	设置soundfont文件路径
func set_soundfont( path:String ) -> void:
	soundfont = path

	if path == null or path == "":
		self.bank = null
		return

	var sf_reader: = SoundFont.new( )
	var result: = sf_reader.read_file( soundfont )

	if result.error == OK:
		self.bank = Bank.new( )
		if self.load_all_voices_from_soundfont:
			self.bank.read_soundfont( result.data )
		else:
			self.bank.read_soundfont( result.data, self._used_program_numbers )

## SMF 数据更新
## @param	sd	SMF 数据
func set_smf_data( sd:SMF.SMFData ) -> void:
	smf_data = sd
	
	self.stop( )

## 速度设定
## @param	bpm	速度
func set_tempo( bpm:float ) -> void:
	tempo = bpm
	self.seconds_to_timebase = tempo / 60.0
	self.timebase_to_seconds = 60.0 / tempo
	self.emit_signal( "changed_tempo", bpm )

## 音量設定
## @param	vdb	音量
func set_volume_db( vdb:float ) -> void:
	volume_db = vdb
	if not self.is_audio_server_inited:
		return

	AudioServer.set_bus_volume_db( AudioServer.get_bus_index( self.midi_master_bus_name ), self.volume_db )

## 停止整个音符
func _stop_all_notes( ) -> void:
	for audio_stream_player in self.audio_stream_players:
		audio_stream_player.hold = false
		audio_stream_player.note_stop( )

	for channel in self.channel_status:
		channel.note_on.clear( )

## 逐帧处理
## @param	delta
func _process( delta:float ) -> void:
	if self.smf_data != null:
		if self.playing:
			self.position += float( self.smf_data.timebase ) * delta * self.seconds_to_timebase * self.play_speed
			self._process_track( )

	for asp in self.audio_stream_players:
		asp._update_adsr( delta )

## 轨道处理
## @return	执行事件数
#处理轨道事件？
func _process_track( ) -> int:
	var track:GodotMIDIPlayerTrackStatus = self.track_status
	if track.events == null:
		return 0

	var length:int = len( track.events )

	if length <= track.event_pointer:
		#检测播放器是否循环状态
		if self.loop:
			var diff:float = self.position - track.events[len( track.events ) - 1].time
			self.seek( self.loop_start )
			self.emit_signal( "looped" )
			self.position += diff
		else:
			self.playing = false
			self.emit_signal( "finished" )
			return 0

	var execute_event_count:int = 0
	var current_position:int = int( ceil( self.position ) )

	while track.event_pointer < length:
		var event_chunk:SMF.MIDIEventChunk = track.events[track.event_pointer]
		if current_position <= event_chunk.time:
			break
		track.event_pointer += 1
		execute_event_count += 1

		var channel:GodotMIDIPlayerChannelStatus = self.channel_status[event_chunk.channel_number]
		var event:SMF.MIDIEvent = event_chunk.event

		self.emit_signal( "midi_event", channel, event )
		match event.type:
			SMF.MIDIEventType.note_off:
				self._process_track_event_note_off( channel, ( event as SMF.MIDIEventNoteOff ).note )
			SMF.MIDIEventType.note_on:
				var event_note_on:SMF.MIDIEventNoteOn = event as SMF.MIDIEventNoteOn
				self._process_track_event_note_on( channel, event_note_on.note, event_note_on.velocity )
			SMF.MIDIEventType.program_change:
				channel.program = ( event as SMF.MIDIEventProgramChange ).number
			SMF.MIDIEventType.control_change:
				var event_control_change:SMF.MIDIEventControlChange = event as SMF.MIDIEventControlChange
				self._process_track_event_control_change( channel, event_control_change.number, event_control_change.value )
			SMF.MIDIEventType.pitch_bend:
				self._process_pitch_bend( channel, ( event as SMF.MIDIEventPitchBend ).value )
			SMF.MIDIEventType.system_event:
				self._process_track_system_event( channel, event as SMF.MIDIEventSystemEvent )
			_:
				# 無視
				pass
	return execute_event_count

## 原始 MIDI 消息处理
## @param	input_event	事件
func receive_raw_midi_message( input_event:InputEventMIDI ) -> void:
	var channel:GodotMIDIPlayerChannelStatus = self.channel_status[input_event.channel]
	channel.program = input_event.instrument
	match input_event.message:
		#按键松开
		MIDI_MESSAGE_NOTE_OFF:
			self._process_track_event_note_off( channel, input_event.pitch )
		#按键放下
		MIDI_MESSAGE_NOTE_ON:
			self._process_track_event_note_on( channel, input_event.pitch, input_event.velocity )
		MIDI_MESSAGE_AFTERTOUCH:
			# 播放器本身未实现
			pass
		MIDI_MESSAGE_CONTROL_CHANGE:
			self._process_track_event_control_change( channel, input_event.controller_number, input_event.controller_value )
		MIDI_MESSAGE_PROGRAM_CHANGE:
			channel.program = input_event.instrument
		MIDI_MESSAGE_CHANNEL_PRESSURE:
			# 播放器本身未实现
			pass
		MIDI_MESSAGE_PITCH_BEND:
			var fixed_pitch:int = input_event.pitch
			self._process_pitch_bend( channel, fixed_pitch )
		0x0F:
			# InputEventMIDI 不会跳过 MIDI 系统事件！
			pass
		_:
			print( "unknown message %x" % input_event.message )
			breakpoint

## 音高弯曲处理
## @param	channel	通道状态
## @param	value	設定値
func _process_pitch_bend( channel:GodotMIDIPlayerChannelStatus, value:int ) -> void:
	var pb:float = float( value ) / 8192.0 - 1.0
	var pbs:float = channel.rpn.pitch_bend_sensitivity
	channel.pitch_bend = pb

	self._apply_channel_pitch_bend( channel )

## 跟踪事件：注解处理
## @param	channel				通道状态
## @param	note				音符编号
## @param	force_disable_hold	强制 hold1 被忽略
func _process_track_event_note_off( channel:GodotMIDIPlayerChannelStatus, note:int, force_disable_hold:bool = false ) -> void:
	var track_key_shift:int = self.key_shift if not channel.drum_track else 0
	var key_number:int = note + track_key_shift
	if channel.note_on.erase( key_number ):
		pass

	if channel.drum_track: return

	for asp in self.audio_stream_players:
		if asp.channel_number == channel.number and asp.key_number == key_number:
			if force_disable_hold: asp.hold = false
			asp.start_release( )

## 跟踪事件：注释处理
## @param	channel				通道状态
## @param	note				音符编号
## @param	velocity			速度
func _process_track_event_note_on( channel:GodotMIDIPlayerChannelStatus, note:int, velocity:int ) -> void:
	if channel.mute: return
	if self.bank == null: return

	var track_key_shift:int = self.key_shift if not channel.drum_track else 0
	var key_number:int = note + track_key_shift
	var preset:Bank.Preset = self.bank.get_preset( channel.program, channel.bank )
	if key_number > preset.instruments.size():
		return
	elif preset.instruments[key_number] == null:
		return
	var instruments:Array = preset.instruments[key_number]	# Array[Bank.Instrument]

	var assign_group:int = key_number
	if channel.drum_track:
		if key_number in self.drum_assign_groups:
			assign_group = self.drum_assign_groups[key_number]

	if channel.note_on.has( assign_group ):
		self._process_track_event_note_off( channel, note, true )

	var polyphony_count:int = 0
	for instrument in instruments:
		if instrument.vel_range_min <= velocity and velocity <= instrument.vel_range_max:
			polyphony_count += 1

	for instrument in instruments:
		if instrument.vel_range_min <= velocity and velocity <= instrument.vel_range_max:
			var note_player:AudioStreamPlayerADSR = self._get_idle_player( )
			if note_player != null:
				note_player.channel_number = channel.number
				note_player.key_number = key_number
				note_player.bus = self.midi_channel_bus_name % channel.number
				note_player.velocity = velocity
				note_player.pitch_bend = channel.pitch_bend
				note_player.pitch_bend_sensitivity = channel.rpn.pitch_bend_sensitivity
				note_player.modulation = channel.modulation
				note_player.modulation_sensitivity = channel.rpn.modulation_sensitivity
				note_player.auto_release_mode = channel.drum_track
				note_player.polyphony_count = float( polyphony_count )
				note_player.note_stop( )
				note_player.set_instrument( instrument )
				note_player.hold = channel.hold
				note_player.note_play( 0.0 )

	channel.note_on[ assign_group ] = true

## 跟踪事件：注释处理
## @param	channel	通道编号
## @param	number	事件编号
## @param	value	値
func _process_track_event_control_change( channel:GodotMIDIPlayerChannelStatus, number:int, value:int ) -> void:
	match number:
		SMF.control_number_volume:
			channel.volume = float( value ) / 127.0
			self._apply_channel_volume( channel )
		SMF.control_number_modulation:
			channel.modulation = float( value ) / 127.0
			self._apply_channel_modulation( channel )
		SMF.control_number_expression:
			channel.expression = float( value ) / 127.0
			self._apply_channel_volume( channel )
		SMF.control_number_reverb_send_level:
			channel.reverb = float( value ) / 127.0
			self._apply_channel_reverb( channel )
		SMF.control_number_tremolo_depth:
			channel.tremolo = float( value ) / 127.0
		SMF.control_number_chorus_send_level:
			channel.chorus = float( value ) / 127.0
			self._apply_channel_chorus( channel )
		SMF.control_number_celeste_depth:
			channel.celeste = float( value ) / 127.0
		SMF.control_number_phaser_depth:
			channel.phaser = float( value ) / 127.0
		SMF.control_number_pan:
			channel.pan = float( value ) / 127.0
			self._apply_channel_pan( channel )
		SMF.control_number_hold:
			channel.hold = 64 <= value
			self._apply_channel_hold( channel )
		SMF.control_number_portamento:
			channel.portamento = float( value ) / 127.0
		SMF.control_number_sostenuto:
			channel.sostenuto = float( value ) / 127.0
		SMF.control_number_freeze:
			channel.freeze = float( value ) / 127.0
		SMF.control_number_bank_select_msb:
			if channel.drum_track:
				channel.bank = Bank.drum_track_bank
			else:
				if value == 1:
					# 避免在 SoundFont 中使用 MSB = 1，因为它是鼓轨道。
					value = 0
				channel.bank = ( channel.bank & 0x7F ) | ( value << 7 )
		SMF.control_number_bank_select_lsb:
			if channel.drum_track:
				channel.bank = Bank.drum_track_bank
			else:
				channel.bank = ( channel.bank & 0x3F80 ) | ( value & 0x7F )
		SMF.control_number_rpn_lsb:
			channel.rpn.selected_lsb = value
		SMF.control_number_rpn_msb:
			channel.rpn.selected_msb = value
		SMF.control_number_data_entry_msb:
			self._process_track_event_control_change_rpn_data_entry_msb( channel, value )
		SMF.control_number_data_entry_lsb:
			self._process_track_event_control_change_rpn_data_entry_lsb( channel, value )
		SMF.control_number_all_sound_off:
			self._stop_all_notes( )
		SMF.control_number_all_note_off:
			for asp in self.audio_stream_players:
				if asp.channel_number == channel.number:
					asp.hold = false
					asp.start_release( )
					if channel.note_on.erase( asp.key_number ):
						pass
		_:
			# 無視
			pass

## 频道状态更新
## @param	channel	通道状态
func update_channel_status( channel:GodotMIDIPlayerChannelStatus ) -> void:
	self._apply_channel_volume( channel )
	self._apply_channel_pitch_bend( channel )
	self._apply_channel_modulation( channel )
	self._apply_channel_hold( channel )
	self._apply_channel_reverb( channel )
	self._apply_channel_chorus( channel )
	self._apply_channel_pan( channel )

## 将音量应用于通道
## @param	channel	通道状态
func _apply_channel_volume( channel:GodotMIDIPlayerChannelStatus ) -> void:
	AudioServer.set_bus_volume_db( AudioServer.get_bus_index( self.midi_channel_bus_name % channel.number ), linear_to_db( channel.volume * channel.expression ) )

## 应用于通道的弯距弯曲
## @param	channel	通道状态
func _apply_channel_pitch_bend( channel:GodotMIDIPlayerChannelStatus ) -> void:
	var pbs:float = channel.rpn.pitch_bend_sensitivity
	var pb:float = channel.pitch_bend
	for asp in self.audio_stream_players:
		if asp.channel_number == channel.number and ( not asp.request_release ):
			asp.pitch_bend_sensitivity = pbs
			asp.pitch_bend = pb

## 将混响应用于通道
## @param	channel	通道状态
func _apply_channel_reverb( channel:GodotMIDIPlayerChannelStatus ) -> void:
	self.channel_audio_effects[channel.number].ae_reverb.wet = channel.reverb * self.reverb_power

## 将合唱应用于通道
## @param	channel	通道状态
func _apply_channel_chorus( channel:GodotMIDIPlayerChannelStatus ) -> void:
	self.channel_audio_effects[channel.number].ae_chorus.wet = channel.chorus * self.chorus_power

## 平移到频道
## @param	channel	通道状态
func _apply_channel_pan( channel:GodotMIDIPlayerChannelStatus ):
	self.channel_audio_effects[channel.number].ae_panner.pan = ( ( channel.pan * 2 ) - 1.0 ) * self.pan_power

## 应用于通道的调制
## @param	channel	通道状态
func _apply_channel_modulation( channel:GodotMIDIPlayerChannelStatus ) -> void:
	var ms:float = channel.rpn.modulation_sensitivity
	var m:float = channel.modulation
	for asp in self.audio_stream_players:
		if asp.channel_number == channel.number and ( not asp.request_release ):
			asp.modulation_sensitivity = ms
			asp.modulation = m

## 将 Hold1 应用于通道
## @param	channel	通道状态
func _apply_channel_hold( channel:GodotMIDIPlayerChannelStatus ) -> void:
	var hold:bool = channel.hold
	for asp in self.audio_stream_players:
		if asp.channel_number == channel.number:
			asp.hold = hold and ( not asp.request_release )

## 跟踪事件：为 RPN 数据设置 MSB
## @param	channel	通道状态
## @param	value	値
func _process_track_event_control_change_rpn_data_entry_msb( channel:GodotMIDIPlayerChannelStatus, value:int ) -> void:
	match channel.rpn.selected_msb:
		0:
			match channel.rpn.selected_lsb:
				SMF.rpn_control_number_pitch_bend_sensitivity:
					channel.rpn.pitch_bend_sensitivity_msb = float( value )
					if 12 < channel.rpn.pitch_bend_sensitivity_msb: channel.rpn.pitch_bend_sensitivity_msb = 12
					channel.rpn.pitch_bend_sensitivity = channel.rpn.pitch_bend_sensitivity_msb + channel.rpn.pitch_bend_sensitivity_lsb / 100.0
				SMF.rpn_control_number_modulation_sensitivity:
					channel.rpn.modulation_sensitivity_msb = float( value )
					channel.rpn.modulation_sensitivity = channel.rpn.modulation_sensitivity_msb + channel.rpn.modulation_sensitivity_lsb / 100.0
				_:
					pass
		_:
			pass

## 跟踪事件：为 RPN 数据设置 LSB
## @param	channel	通道状态
## @param	value	値
func _process_track_event_control_change_rpn_data_entry_lsb( channel:GodotMIDIPlayerChannelStatus, value:int ) -> void:
	match channel.rpn.selected_msb:
		0:
			match channel.rpn.selected_lsb:
				SMF.rpn_control_number_pitch_bend_sensitivity:
					channel.rpn.pitch_bend_sensitivity_lsb = float( value )
					channel.rpn.pitch_bend_sensitivity = channel.rpn.pitch_bend_sensitivity_msb + channel.rpn.pitch_bend_sensitivity_lsb / 100.0
				SMF.rpn_control_number_modulation_sensitivity:
					channel.rpn.modulation_sensitivity_lsb = float( value )
					channel.rpn.modulation_sensitivity = channel.rpn.modulation_sensitivity_msb + channel.rpn.modulation_sensitivity_lsb / 100.0
				_:
					pass
		_:
			pass

## MIDI 系统事件
## @param	channel	通道状态
## @param	event	事件数据
func _process_track_system_event( channel:GodotMIDIPlayerChannelStatus, event:SMF.MIDIEventSystemEvent ) -> void:
	match event.args.type:
		SMF.MIDISystemEventType.set_tempo:
			self.tempo = 60000000.0 / float( event.args.bpm )
		SMF.MIDISystemEventType.text_event:
			self.emit_signal( "appeared_text_event", event.args.text )
		SMF.MIDISystemEventType.copyright:
			self.emit_signal( "appeared_copyright", event.args.text )
		SMF.MIDISystemEventType.track_name:
			self.emit_signal( "appeared_track_name", self._midi_channel_prefix, event.args.text )
			self.channel_status[self._midi_channel_prefix].track_name = event.args.text
		SMF.MIDISystemEventType.instrument_name:
			self.emit_signal( "appeared_instrument_name", self._midi_channel_prefix, event.args.text )
			self.channel_status[self._midi_channel_prefix].instrument_name = event.args.text
		SMF.MIDISystemEventType.lyric:
			self.emit_signal( "appeared_lyric", event.args.text )
		SMF.MIDISystemEventType.marker:
			self.emit_signal( "appeared_marker", event.args.text )
		SMF.MIDISystemEventType.cue_point:
			self.emit_signal( "appeared_cue_point", event.args.text )
		SMF.MIDISystemEventType.midi_channel_prefix:
			self._midi_channel_prefix = event.args.channel
		SMF.MIDISystemEventType.sys_ex:
			self._process_track_sys_ex( channel, event.args )
		SMF.MIDISystemEventType.divided_sys_ex:
			self._process_track_sys_ex( channel, event.args )
		_:
			# 無視
			pass

## MIDI 系统事件：跟踪系统 ex 处理
## @param	channel		通道状态
## @param	event_args	事件数据
func _process_track_sys_ex( channel:GodotMIDIPlayerChannelStatus, event_args ) -> void:
	# ==将其转换为比较
	var event_data: = Array( event_args.data )
	var event_data_without_first_data: = event_data.slice( 1, len( event_args.data ) )

	match event_args.manifacture_id:
		SMF.manufacture_id_universal_nopn_realtime_sys_ex:
			if event_data == [0x7f,0x09,0x01,0xf7]:
				self.sys_ex.gm_system_on = true
				self.emit_signal( "appeared_gm_system_on" )
				self._process_track_sys_ex_reset_all_channels( )
		SMF.manufacture_id_roland_corporation:
			if event_data_without_first_data == [0x42,0x12,0x40,0x00,0x7f,0x00,0x41,0xf7]:
				self.sys_ex.gs_reset = true
				self.emit_signal( "appeared_gs_reset" )
				self._process_track_sys_ex_reset_all_channels( )
		SMF.manufacture_id_yamaha_corporation:
			if event_data_without_first_data == [0x4c,0x00,0x00,0x7E,0x00,0xf7]:
				self.sys_ex.xg_system_on = true
				self.emit_signal( "appeared_xg_system_on" )
				self._process_track_sys_ex_reset_all_channels( )

## MIDI 系统事件：重置
func _process_track_sys_ex_reset_all_channels( ) -> void:
	for audio_stream_player in self.audio_stream_players:
		audio_stream_player.hold = false
		audio_stream_player.start_release( )

	for channel in self.channel_status:
		channel.initialize( )

		AudioServer.set_bus_volume_db( AudioServer.get_bus_index( self.midi_channel_bus_name % channel.number ), linear_to_db( float( channel.volume * channel.expression ) ) )
		self.channel_audio_effects[channel.number].ae_reverb.wet = channel.reverb * self.reverb_power
		self.channel_audio_effects[channel.number].ae_chorus.wet = channel.chorus * self.chorus_power
		self.channel_audio_effects[channel.number].ae_panner.pan = ( ( channel.pan * 2 ) - 1.0 ) * self.pan_power

## 获取未使用的 AudioStreamPlayerADSR
## 如果没有未使用的，则返回自 NoteOn 以来运行时间最长的 AudioStreamPlayerADSR。
## @return	AudioStreamPlayerADSR
func _get_idle_player( ) -> AudioStreamPlayerADSR:
	var released_audio_stream_player:AudioStreamPlayerADSR = null
	var minimum_volume_db:float = -80.0
	# var releasing_audio_stream_player:AudioStreamPlayerADSR = null
	var oldest_audio_stream_player:AudioStreamPlayerADSR = null
	var oldest:float = -1.0

	for audio_stream_player in self.audio_stream_players:
		if not audio_stream_player.playing:
			return audio_stream_player
		if audio_stream_player.releasing and audio_stream_player.volume_db < minimum_volume_db:
			released_audio_stream_player = audio_stream_player
			minimum_volume_db = audio_stream_player.volume_db
		if oldest < audio_stream_player.using_timer:
			oldest_audio_stream_player = audio_stream_player
			oldest = audio_stream_player.using_timer

	if released_audio_stream_player != null:
		return released_audio_stream_player

	return oldest_audio_stream_player

## 返回当前正在发音的音调数
## @warning	声音字体（SoundFont）具有多种发音乐器的影响。 如果您想获得纯同步音符检查编号，请参阅所有通道状态的note_on。
## @return		现在发音中的音色数
func get_now_playing_polyphony( ) -> int:
	var polyphony:int = 0
	for audio_stream_player in self.audio_stream_players:
		if audio_stream_player.playing:
			polyphony += 1
	return polyphony
