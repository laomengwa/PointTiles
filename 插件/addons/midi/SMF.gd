##
## Standard MIDI File reader/writer by Yui Kinomoto @arlez80
##

class_name SMF

# -----------------------------------------------------------------------------
# 定数

# Control Numbers
const control_number_bank_select_msb:int = 0x00
const control_number_modulation:int = 0x01
const control_number_breath_controller:int = 0x02
const control_number_foot_controller:int = 0x04
const control_number_portamento_time:int = 0x05
const control_number_data_entry_msb:int = 0x06
const control_number_volume:int = 0x07
const control_number_balance:int = 0x08
const control_number_pan:int = 0x0A
const control_number_expression:int = 0x0B

const control_number_bank_select_lsb:int = 0x20
const control_number_modulation_lsb:int = 0x21
const control_number_breath_controller_lsb:int = 0x22
const control_number_foot_controller_lsb:int = 0x24
const control_number_portamento_time_lsb:int = 0x25
const control_number_data_entry_lsb:int = 0x26
const control_number_channel_volume_lsb:int = 0x27
const control_number_calance_lsb:int = 0x28
const control_number_pan_lsb:int = 0x2A
const control_number_expression_lsb:int = 0x2B
const control_number_effect_control1:int = 0x2C
const control_number_effect_control2:int = 0x2D

const control_number_hold:int = 0x40		# Sustain Pedal
const control_number_portament:int = 0x41	# miss spell for compatible older version
const control_number_portamento:int = 0x41
const control_number_sostenuto:int = 0x42
const control_number_soft_pedal:int = 0x43
const control_number_legato_foot_switch:int = 0x44
const control_number_freeze:int = 0x45
const control_number_sound_variation:int = 0x46
const control_number_timbre:int = 0x47
const control_number_release_time:int = 0x48
const control_number_attack_time:int = 0x49
const control_number_brightness:int = 0x4A
const control_number_vibrato_rate:int = 0x4B
const control_number_vibrato_depth:int = 0x4C
const control_number_vibrato_delay:int = 0x4D

const control_number_source_note:int = 0x54

const control_number_high_res_velovity_prefix:int = 0x58

const control_number_reverb_send_level:int = 0x5B	# Effect 1
const control_number_tremolo_depth:int = 0x5C		# Effect 2
const control_number_chorus_send_level:int = 0x5D	# Effect 3
const control_number_celeste_depth:int = 0x5E		# Effect 4
const control_number_phaser_depth:int = 0x5F		# Effect 5

const control_number_data_increment:int = 0x60
const control_number_data_decrement:int = 0x61
const control_number_nrpn_lsb:int = 0x62
const control_number_nrpn_msb:int = 0x63
const control_number_rpn_lsb:int = 0x64
const control_number_rpn_msb:int = 0x65
const control_number_tkool_loop_point:int = 0x6F	# CC111
const control_number_all_sound_off:int = 0x78
const control_number_all_note_off:int = 0x7B

# RPN Control Numbers: 0x00
const rpn_control_number_pitch_bend_sensitivity:int = 0x00
const rpn_control_number_channel_fine_tune:int = 0x01
const rpn_control_number_channel_cource_tune:int = 0x02
const rpn_control_number_tune_program_change:int = 0x03
const rpn_control_number_tune_bank_select:int = 0x04
const rpn_control_number_modulation_sensitivity:int = 0x05
# RPN Control Numbers: 0x3D
const rpn_control_number_3D_azimuth_angle:int = 0x00
const rpn_control_number_3D_elevation_angle:int = 0x01
const rpn_control_number_3D_gain:int = 0x02
const rpn_control_number_3D_distance_ratio:int = 0x03
const rpn_control_number_3D_maximum_distance:int = 0x04
const rpn_control_number_3D_gain_at_maximum_distance:int = 0x05
const rpn_control_number_3D_referance_distance_raito:int = 0x06
const rpn_control_number_3D_pan_spread_angle:int = 0x07
const rpn_control_number_3D_roll_angle:int = 0x08

# Manufacture ID
const manufacture_id_universal_nopn_realtime_sys_ex:int = 0x7E
const manufacture_id_universal_realtime_sys_ex:int = 0x7F
const manufacture_id_kawai_musical_instruments_mfg_co_ltd:int = 0x40
const manufacture_id_roland_corporation:int = 0x41
const manufacture_id_korg_inc:int = 0x42
const manufacture_id_yamaha_corporation:int = 0x43
const manufacture_id_casio_computer_co_ltd:int = 0x44
const manufacture_id_kamiya_studio_co_ltd:int = 0x46
const manufacture_id_akai_electric_co_ltd:int = 0x47

# 7F

# -----------------------------------------------------------------------------
# Enums

## SMF 格式 (MIDI格式)
enum SMFFormat {
	format_0 = 0,						## 单一轨道
	format_1 = 1,						## 多个轨道（同步）
	format_2 = 2						## 多个轨道（异步）
}

## MIDI 事件
enum MIDIEventType {
	note_off = 0x80,					## 音符松开
	note_on = 0x90,						## 音符按下
	polyphonic_key_pressure = 0xA0,		## 多声部按键压力
	control_change = 0xB0,				## 控制更改
	program_change = 0xC0,				## 乐器更改
	channel_pressure = 0xD0,			## 通道压力
	pitch_bend = 0xE0,					## 弯音
	system_event = 0xF0,				## 系统事件
}

## MIDI 系统事件(元事件)
enum MIDISystemEventType {
	sys_ex = 0x10000,					## 系统独占
	divided_sys_ex = 0x10001,			## 设备音序

	sequence_number = 0x00,				## 歌曲文本备注信息
	text_event = 0x01,					## 音轨文本备注信息
	copyright = 0x02,					## 著作权信息
	track_name = 0x03,					## 曲目名称
	instrument_name = 0x04,				## 楽器名
	lyric = 0x05,						## 歌詞
	marker = 0x06,						## 标记
	cue_point = 0x07,					## 提示点

	midi_channel_prefix = 0x20,			## MIDI 通道前缀
	midi_port_prefix = 0x21,			##  MIDI 端口前缀
	end_of_track = 0x2F,				## 曲目结束

	set_tempo = 0x51,					## 速度设定

	smpte_offset = 0x54,				## MIDI 时间码偏移

	beat = 0x58,						## 拍子
	key = 0x59,							## 键

	unknown = 0xFFFF,					## 不明
}

# -----------------------------------------------------------------------------
# クラス

## MIDI 块数据
class MIDIChunkData:
	## 4文字ID
	var id:String

	## 块大小
	var size:int

	## 数据
	var stream:StreamPeerBuffer

## SMF解析结果
class SMFParseResult:
	## 错误代码
	var error:int = OK

	## 解析的数据
	var data:SMFData = null

	func _init():
		pass

## SMF数据本体
class SMFData:
	## SMF格式
	var format_type:SMFFormat
	## 轨道数量
	var track_count:int
	## 基础时间
	var timebase:int
	## 轨道数据
	var tracks:Array[MIDITrack]

	## 构造函数
	## @param	_format_type	SMF格式
	## @param	_track_count	轨道数量
	## @param	_timebase	基础时间
	## @param	_tracks	轨道数据
	func _init(_format_type:SMFFormat = SMFFormat.format_0,_track_count:int = 0,_timebase:int = 480,_tracks:Array[MIDITrack] = []):
		self.format_type = _format_type
		self.track_count = _track_count
		self.timebase = _timebase
		self.tracks = _tracks

## MIDI轨道
class MIDITrack:
	## 轨道编号
	var track_number:int
	## 事件列表
	var events:Array[MIDIEventChunk]

	## 构造函数
	## @param	_track_number	轨道编号
	## @param	_events			事件
	func _init(_track_number:int = 0,_events:Array = []):	# Array[MIDIEventChunk]
		self.track_number = _track_number
		self.events = _events

class MIDIEventChunk:
	## 絶対時間 (基于时间)
	var time:int
	## 通道编号
	var channel_number:int
	## 事件
	var event:MIDIEvent

	## 构造函数
	## @param	_time			絶対時間 (基于时间)
	## @param	_channel_number	 通道编号
	## @param	_event			事件
	func _init(_time:int = 0,_channel_number:int = 0,_event:MIDIEvent = null):
		self.time = _time
		self.channel_number = _channel_number
		self.event = _event

## 基础MIDI事件
class MIDIEvent:
	## 種類
	var type:MIDIEventType

## MIDI事件：音符松开
class MIDIEventNoteOff extends MIDIEvent:
	## 音符编号
	var note:int
	## 音符力度 (0)
	var velocity:int

	## 构造函数
	## @param	_node		音符编号
	## @param	_velocity	音符力度
	func _init(_note:int = 0,_velocity:int = 0):
		self.type = MIDIEventType.note_off
		self.note = _note
		self.velocity = _velocity

## MIDI事件：音符按下
class MIDIEventNoteOn extends MIDIEvent:
	## 音符编号
	var note:int
	## 音符力度
	var velocity:int

	## 构造函数
	## @param	_node		音符编号
	## @param	_velocity	音符力度
	func _init(_note:int = 0,_velocity:int = 0):
		self.type = MIDIEventType.note_on
		self.note = _note
		self.velocity = _velocity

## MIDIイベント:ポリフォニックキープレッシャー
class MIDIEventPolyphonicKeyPressure extends MIDIEvent:
	## ノート番号
	var note:int
	## 値
	var value:int

	## コンストラクタ
	## @param	_node		ノート番号
	## @param	_velocity	値
	func _init(_note:int = 0,_value:int = 0):
		self.type = MIDIEventType.polyphonic_key_pressure
		self.note = _note
		self.value = _value

## MIDIイベント:コントロールチェンジ
class MIDIEventControlChange extends MIDIEvent:
	## コントロール番号
	var number:int
	## 値
	var value:int

	## コンストラクタ
	## @param	_number		コントロール番号
	## @param	_velocity	値
	func _init(_number:int = 0,_value:int = 0):
		self.type = MIDIEventType.control_change
		self.number = _number
		self.value = _value

## MIDIイベント:プログラムチェンジ
class MIDIEventProgramChange extends MIDIEvent:
	## プログラム番号
	var number:int

	## コンストラクタ
	## @param	_number		プログラム番号
	func _init(_number:int = 0):
		self.type = MIDIEventType.program_change
		self.number = _number

## MIDIイベント:チャンネルプレッシャー
class MIDIEventChannelPressure extends MIDIEvent:
	## 値
	var value:int

	## コンストラクタ
	## @param	_value	値
	func _init(_value:int = 0):
		self.type = MIDIEventType.channel_pressure
		self.value = _value

## MIDIイベント:ピッチベンド
class MIDIEventPitchBend extends MIDIEvent:
	## 値
	var value:int

	## コンストラクタ
	## @param	_value	値
	func _init(_value:int = 0):
		self.type = MIDIEventType.pitch_bend
		self.value = _value

## MIDIイベント:システムイベント
class MIDIEventSystemEvent extends MIDIEvent:
	## 引数
	var args:Dictionary

	## コンストラクタ
	## @param	_args	引数
	func _init(_args:Dictionary = {}):
		self.type = MIDIEventType.system_event
		self.args = _args

# -----------------------------------------------------------------------------
# 読み込み : Reader

## 最後のイベントタイプ (ランニングステータス用)
var last_event_type:int = 0

## ファイルから読み込み
## @param	path	ファイルパス
## @return	SMFParseResult
func read_file( path:String ) -> SMFParseResult:
	var result: = SMFParseResult.new( )

	var f: = FileAccess.open( path, FileAccess.READ )
	if f.get_error( ) != OK:
		result.error = f.get_error( )
		return result
	var stream:StreamPeerBuffer = StreamPeerBuffer.new( )
	stream.set_data_array( f.get_buffer( f.get_length( ) ) )
	stream.big_endian = true

	result.data = self._read( stream )
	if result.data == null:
		result.error = ERR_PARSE_ERROR
	return result

## 配列から読み込み
## @param	data	データ
## @return	SMFParseResult
func read_data( data:PackedByteArray ) -> SMFParseResult:
	var stream:StreamPeerBuffer = StreamPeerBuffer.new( )
	stream.set_data_array( data )
	stream.big_endian = true

	var result: = SMFParseResult.new( )
	result.data = self._read( stream )
	if result.data == null:
		result.error = ERR_PARSE_ERROR
	return result

## ストリームから読み込み
## @param	input	ストリーム
## @return	smf
func _read( input:StreamPeerBuffer ) -> SMFData:
	var header:MIDIChunkData = self._read_chunk_data( input )
	if header.id != "MThd" and header.size != 6:
		print( "expected MThd header" )
		return null

	var smf:SMFData = SMFData.new( )

	smf.format_type = header.stream.get_u16( )
	smf.track_count = header.stream.get_u16( )
	smf.timebase = header.stream.get_u16( )

	for i in range( 0, smf.track_count ):
		var track = self._read_track( input, i )
		if track == null:
			return null
		smf.tracks.append( track )

	return smf

## トラックの読み込み
## @param	input			ストリーム
## @param	track_number	トラック番号
## @return	track data or null(read error)
func _read_track( input:StreamPeerBuffer, track_number:int ) -> MIDITrack:
	var track_chunk:MIDIChunkData = self._read_chunk_data( input )
	if track_chunk.id != "MTrk":
		print( "Unknown chunk: " + track_chunk.id )
		return null

	var stream:StreamPeerBuffer = track_chunk.stream
	var time:int = 0
	var events:Array[MIDIEventChunk] = []

	while 0 < stream.get_available_bytes( ):
		var delta_time:int = self._read_variable_int( stream )
		time += delta_time
		var event_type_byte:int = stream.get_u8( )

		var event:MIDIEvent
		if self._is_system_event( event_type_byte ):
			var args = self._read_system_event( stream, event_type_byte )
			if args == null: return null
			event = MIDIEventSystemEvent.new( args )
		else:
			event = self._read_event( stream, event_type_byte )
			if event == null: return null

			# running status
			if ( event_type_byte & 0x80 ) == 0:
				event_type_byte = self.last_event_type

		events.append( MIDIEventChunk.new( time, event_type_byte & 0x0f, event ) )

	return MIDITrack.new( track_number, events )

## システムイベントか否かを返す
## @param	b	イベント番号
## @return	システムイベントならtrueを返す
func _is_system_event( b:int ) -> bool:
	return ( b & 0xf0 ) == 0xf0

## 读取系统事件
## @param	stream	数据流
## @param	event_type_byte
## @return	系统事件数据，出错时返回 null
func _read_system_event( stream:StreamPeerBuffer, event_type_byte:int ):
	if event_type_byte == 0xff:
		var meta_type:int = stream.get_u8( )
		var size:int = self._read_variable_int( stream )

		match meta_type:
			MIDISystemEventType.sequence_number:
				return { "type": MIDISystemEventType.sequence_number, "number": stream.get_u16( ) }
			MIDISystemEventType.text_event, MIDISystemEventType.copyright, MIDISystemEventType.track_name, MIDISystemEventType.instrument_name, MIDISystemEventType.lyric, MIDISystemEventType.cue_point, MIDISystemEventType.marker:
				return { "type": meta_type, "text": self._read_string( stream, size ) }

			MIDISystemEventType.midi_channel_prefix:
				if size != 1:
					print( "MIDI Channel Prefix length is not 1 byte" )
					return null
				return { "type": MIDISystemEventType.midi_channel_prefix, "channel": stream.get_u8( ) }
			MIDISystemEventType.midi_port_prefix:
				if size != 1:
					print( "MIDI Port Prefix length is not 1 byte" )
					return null
				return { "type": MIDISystemEventType.midi_port_prefix, "port": stream.get_u8( ) }
			MIDISystemEventType.end_of_track:
				if size != 0:
					print( "End of track with unknown data" )
					return null
				return { "type": MIDISystemEventType.end_of_track }
			MIDISystemEventType.set_tempo:
				if size != 3:
					print( "Tempo length is not 3 bytes" )
					return null
				# beat per microseconds
				var bpm:int = stream.get_u8( ) << 16
				bpm |= stream.get_u8( ) << 8
				bpm |= stream.get_u8( )
				return { "type": MIDISystemEventType.set_tempo, "bpm": bpm }
			MIDISystemEventType.smpte_offset:
				if size != 5:
					print( "SMPTE length is not 5 bytes" )
					return null
				var hr:int = stream.get_u8( )
				var mm:int = stream.get_u8( )
				var se:int = stream.get_u8( )
				var fr:int = stream.get_u8( )
				var ff:int = stream.get_u8( )
				return {
					"type": MIDISystemEventType.smpte_offset,
					"hr": hr,
					"mm": mm,
					"se": se,
					"fr": fr,
					"ff": ff,
				}
			MIDISystemEventType.beat:
				if size != 4:
					print( "Beat length is not 4 bytes" )
					return null
				var numerator:int = stream.get_u8( )
				var denominator:int = stream.get_u8( )
				var clock:int = stream.get_u8( )
				var beat32:int = stream.get_u8( )
				return {
					"type": MIDISystemEventType.beat,
					"numerator": numerator,
					"denominator": denominator,
					"clock": clock,
					"beat32": beat32,
				}
			MIDISystemEventType.key:
				if size != 2:
					print( "Key length is not 2 bytes" )
					return null
				var sf:int = stream.get_u8( )
				var minor:int = stream.get_u8( ) == 1
				return {
					"type": MIDISystemEventType.key,
					"sf": sf,
					"minor": minor,
				}
			_:
				return {
					"type": MIDISystemEventType.unknown,
					"meta_type": meta_type,
					"data": stream.get_partial_data( size )[1],
				}
	elif event_type_byte == 0xf0:
		var size:int = self._read_variable_int( stream )
		return {
			"type": MIDISystemEventType.sys_ex,
			"manifacture_id": stream.get_u8( ),
			"data": stream.get_partial_data( size - 1 )[1],
		}
	elif event_type_byte == 0xf7:
		var size:int = self._read_variable_int( stream )
		return {
			"type": MIDISystemEventType.divided_sys_ex,
			"manifacture_id": stream.get_u8( ),
			"data": stream.get_partial_data( size - 1 )[1],
		}

	print( "Unknown system event type: %x" % event_type_byte )
	return null

## 正常事件加载
## @param	stream			流数据
## @param	event_type_byte	事件类型编号
## @return	MIDIEvent
func _read_event( stream:StreamPeerBuffer, event_type_byte:int ) -> MIDIEvent:
	var param:int = 0

	if ( event_type_byte & 0x80 ) == 0:
		# running status
		param = event_type_byte
		event_type_byte = self.last_event_type
	else:
		param = stream.get_u8( )
		self.last_event_type = event_type_byte

	var event_type:int = event_type_byte & 0xf0

	match event_type:
		0x80:
			return MIDIEventNoteOff.new( param, stream.get_u8( ) )
		0x90:
			var velocity:int = stream.get_u8( )
			if velocity == 0:
				return MIDIEventNoteOff.new( param, velocity )
			else:
				return MIDIEventNoteOn.new( param, velocity )
		0xA0:
			return MIDIEventPolyphonicKeyPressure.new( param, stream.get_u8( ) )
		0xB0:
			return MIDIEventControlChange.new( param, stream.get_u8( ) )
		0xC0:
			return MIDIEventProgramChange.new( param )
		0xD0:
			return MIDIEventChannelPressure.new( param )
		0xE0:
			return MIDIEventPitchBend.new( param | ( stream.get_u8( ) << 7 ) )

	print( "unknown event type: %d" % event_type_byte )
	return null

## 可変長数値の読み込み
## @param	stream	ストリームデータ
## @return	数値
func _read_variable_int( stream:StreamPeerBuffer ) -> int:
	var result:int = 0

	while true:
		var c:int = stream.get_u8( )
		if ( c & 0x80 ) != 0:
			result |= c & 0x7f
			result <<= 7
		else:
			result |= c
			break

	return result

## チャンクデータの読み込み
## @param	stream	ストリーム
## @return	chunk data
func _read_chunk_data( stream:StreamPeerBuffer ) -> MIDIChunkData:
	var mcd:MIDIChunkData = MIDIChunkData.new( )
	mcd.id = self._read_string( stream, 4 )
	mcd.size = stream.get_32( )
	var new_stream:StreamPeerBuffer = StreamPeerBuffer.new( )
	new_stream.set_data_array( stream.get_partial_data( mcd.size )[1] )
	new_stream.big_endian = true
	mcd.stream = new_stream

	return mcd

## 读取字符串
## @param	stream	流
## @param	size	文字数
## @return 文字列
func _read_string( stream:StreamPeerBuffer, size:int ) -> String:
	return stream.get_partial_data( size )[1].get_string_from_utf8( )

# -----------------------------------------------------------------------------
# 書き込み: Writer

## 写入操作
## @param	smf	SMF structure
## @param	running_status	use running status
## @return	PackedByteArray
func write( smf:SMF, running_status:bool = false ):
	var stream:StreamPeerBuffer = StreamPeerBuffer.new( )
	stream.big_endian = true
	
	if stream.put_data( "MThd".to_ascii_buffer( ) ) != OK:
		return null

	stream.put_u32( 6 )
	stream.put_u16( smf.format_type )
	stream.put_u16( len( smf.tracks ) )
	stream.put_u16( smf.timebase )

	for t in smf.tracks:
		if not self._write_track( stream, t, running_status ):
			return null

	return stream.data_array

## トラックデータソート用
class TrackEventSorter:
	static func sort( a, b ):
		if a.time < b.time:
			return true
		return false

## 可変長数字を書き込む
## @param	stream
## @param	i
func _write_variable_int( stream:StreamPeerBuffer, i:int ):
	var numbers:Array[int] = []

	while true:
		var v:int = i & 0x7f
		i >>= 7
		numbers.append( v )
		if i == 0:
			break

	for k in range( numbers.size( ) - 1 ):
		stream.put_u8( numbers.pop_back( ) | 0x80 )
	stream.put_u8( numbers.pop_back( ) )

## 写入音轨数据
## @param	stream
## @param	track
## @param	running_status
func _write_track( stream:StreamPeerBuffer, track, running_status:bool ) -> bool:
	var events:Array[MIDIEventChunk] = track.events.duplicate( )
	events.sort_custom(Callable(TrackEventSorter,"sort"))

	var buf:StreamPeerBuffer = StreamPeerBuffer.new( )
	buf.big_endian = true
	var time:int = 0
	var last_event_type_seq:int = -2

	for ec in events:
		var event_omit:bool = false
		var current_event_type:int = -1
		self._write_variable_int( buf, ec.time - time )
		time = ec.time
		var e = ec.event
		match e.type:
			MIDIEventType.note_off:
				current_event_type = 0x80 | ec.channel_number
				if running_status:
					event_omit = current_event_type == last_event_type_seq
				if not event_omit:
					buf.put_u8( current_event_type )
				buf.put_u8( e.note )
				buf.put_u8( e.velocity )
			MIDIEventType.note_on:
				current_event_type = 0x90 | ec.channel_number
				if running_status:
					event_omit = current_event_type == last_event_type_seq
				if not event_omit:
					buf.put_u8( current_event_type )
				buf.put_u8( e.note )
				buf.put_u8( e.velocity )
			MIDIEventType.polyphonic_key_pressure:
				current_event_type = 0xA0 | ec.channel_number
				if running_status:
					event_omit = current_event_type == last_event_type_seq
				if not event_omit:
					buf.put_u8( current_event_type )
				buf.put_u8( e.note )
				buf.put_u8( e.value )
			MIDIEventType.control_change:
				current_event_type = 0xB0 | ec.channel_number
				if running_status:
					event_omit = current_event_type == last_event_type_seq
				if not event_omit:
					buf.put_u8( current_event_type )
				buf.put_u8( e.number )
				buf.put_u8( e.value )
			MIDIEventType.program_change:
				current_event_type = 0xC0 | ec.channel_number
				if running_status:
					event_omit = current_event_type == last_event_type_seq
				if not event_omit:
					buf.put_u8( current_event_type )
				buf.put_u8( e.number )
			MIDIEventType.channel_pressure:
				current_event_type = 0xD0 | ec.channel_number
				if running_status:
					event_omit = current_event_type == last_event_type_seq
				if not event_omit:
					buf.put_u8( current_event_type )
				buf.put_u8( e.value )
			MIDIEventType.pitch_bend:
				current_event_type = 0xE0 | ec.channel_number
				if running_status:
					event_omit = current_event_type == last_event_type_seq
				if not event_omit:
					buf.put_u8( current_event_type )
				buf.put_u8( e.value & 0x7f )
				buf.put_u8( ( e.value >> 7 ) & 0x7f )
			MIDIEventType.system_event:
				self._write_system_event( buf, e )
				current_event_type = -3
		last_event_type_seq = current_event_type

	var track_size:int = buf.get_size( )
	if stream.put_data( "MTrk".to_ascii_buffer( ) ) != OK:
		push_error( "cant write track" )
		return false
	stream.put_u32( track_size )
	if stream.put_data( buf.data_array ) != OK:
		push_error( "cant write track" )
		return false

	return true

## システムイベント書き込み
## @param	stream
## @param	event
func _write_system_event( stream:StreamPeerBuffer, event ):
	event = event.args
	match event.type:
		MIDISystemEventType.sys_ex:
			stream.put_u8( 0xF0 )
			self._write_variable_int( stream, event.data.size( ) + 1 )
			stream.put_u8( event.manifacture_id )
			if stream.put_data( event.data ) != OK:
				push_error( "cant write event data" )
				breakpoint
		MIDISystemEventType.divided_sys_ex:
			stream.put_u8( 0xF7 )
			self._write_variable_int( stream, event.data.size( ) + 1 )
			stream.put_u8( event.manifacture_id )
			if stream.put_data( event.data ) != OK:
				push_error( "cant write event data" )
				breakpoint

		MIDISystemEventType.text_event:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x01 )
			self._write_variable_int( stream, event.text.to_ascii_buffer( ).size( ) )
			if stream.put_data( event.text.to_ascii_buffer( ) ) != OK:
				push_error( "cant write text event" )
				breakpoint
		MIDISystemEventType.copyright:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x02 )
			self._write_variable_int( stream, event.text.to_ascii_buffer( ).size( ) )
			if stream.put_data( event.text.to_ascii_buffer( ) ) != OK:
				push_error( "cant write copyright text" )
				breakpoint
		MIDISystemEventType.track_name:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x03 )
			self._write_variable_int( stream, event.text.to_ascii_buffer( ).size( ) )
			if stream.put_data( event.text.to_ascii_buffer( ) ) != OK:
				push_error( "cant write track name text" )
				breakpoint
		MIDISystemEventType.instrument_name:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x04 )
			self._write_variable_int( stream, event.text.to_ascii_buffer( ).size( ) )
			if stream.put_data( event.text.to_ascii_buffer( ) ) != OK:
				push_error( "cant write instrument name" )
				breakpoint
		MIDISystemEventType.lyric:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x05 )
			self._write_variable_int( stream, event.text.to_ascii_buffer( ).size( ) )
			if stream.put_data( event.text.to_ascii_buffer( ) ) != OK:
				push_error( "cant write lyric text" )
				breakpoint
		MIDISystemEventType.marker:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x06 )
			self._write_variable_int( stream, event.text.to_ascii_buffer( ).size( ) )
			if stream.put_data( event.text.to_ascii_buffer( ) ) != OK:
				push_error( "cant write marker text" )
				breakpoint
		MIDISystemEventType.cue_point:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x07 )
			self._write_variable_int( stream, event.text.to_ascii_buffer( ).size( ) )
			if stream.put_data( event.text.to_ascii_buffer( ) )!= OK:
				push_error( "cant write cue point" )
				breakpoint

		MIDISystemEventType.midi_channel_prefix:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x20 )
			stream.put_u8( 0x01 )
			stream.put_u8( event.prefix )
		MIDISystemEventType.midi_port_prefix:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x21 )
			stream.put_u8( 0x01 )
			stream.put_u8( event.prefix )
		MIDISystemEventType.end_of_track:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x2F )
			stream.put_u8( 0x00 )
		MIDISystemEventType.set_tempo:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x51 )
			stream.put_u8( 0x03 )
			stream.put_u8( ( event.bpm >> 16 ) & 0xFF )
			stream.put_u8( ( event.bpm >> 8 ) & 0xFF )
			stream.put_u8( event.bpm & 0xFF )
		MIDISystemEventType.smpte_offset:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x54 )
			stream.put_u8( 0x05 )
			stream.put_u8( event.hr )
			stream.put_u8( event.mm )
			stream.put_u8( event.se )
			stream.put_u8( event.fr )
			stream.put_u8( event.ff )
		MIDISystemEventType.beat:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x58 )
			stream.put_u8( 0x04 )
			stream.put_u8( event.numerator )
			stream.put_u8( event.denominator )
			stream.put_u8( event.clock )
			stream.put_u8( event.beat32 )
		MIDISystemEventType.key:
			stream.put_u8( 0xFF )
			stream.put_u8( 0x59 )
			stream.put_u8( 0x02 )
			stream.put_u8( event.sf )
			stream.put_u8( 1 if event.minor else 0 )
		MIDISystemEventType.unknown:
			stream.put_u8( 0xFF )
			stream.put_u8( event.meta_type )
			stream.put_u8( len( event.data ) )
			if stream.put_data( event.data ) != OK:
				push_error( "cant write event data" )
				breakpoint
		_:
			push_error( "not implemented! %d" % event.type )
			breakpoint
