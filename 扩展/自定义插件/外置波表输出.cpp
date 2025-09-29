#include "外置波表输出.h"
#include <godot_cpp/core/class_db.hpp>
#include <fluidsynth.h>
#include <stdlib.h>
#include <unistd.h>
using namespace godot;
fluid_synth_t* 合成器;
//初始化
void 外置波表输出::_ready(){
	fluid_settings_t* 设置;
    fluid_audio_driver_t* 音频设备;
    int 声音字体状态;

    // 初始化 FluidSynth
    设置 = new_fluid_settings();
    fluid_settings_setstr(设置, "audio.driver", "alsa"); // 使用 ALSA 音频驱动
    合成器 = new_fluid_synth(设置);
    音频设备 = new_fluid_audio_driver(设置, 合成器);

    // 加载声音字体
    声音字体状态 = fluid_synth_sfload(合成器, "/usr/share/soundfonts/FluidR3_GM.sf2", 1);
    if (声音字体状态 == FLUID_FAILED) {
        UtilityFunctions::printerr(L"声音字体加载失败!");
    }
}

int 外置波表输出::输出音符(const Ref<InputEventMIDI>&信息) const{
    // 选择音色（0号通道，0号为钢琴）
	switch (信息->get_message())
		{
		case MIDI_MESSAGE_PROGRAM_CHANGE:
			//乐器更改
			fluid_synth_program_change(合成器,信息->get_channel(),信息->get_instrument());
			break;
		case MIDI_MESSAGE_NOTE_OFF:
			//音符释放
			fluid_synth_noteoff(合成器,信息->get_channel(),信息->get_pitch());
			break;
		case MIDI_MESSAGE_NOTE_ON:
			//音符按下
			fluid_synth_noteon(合成器,信息->get_channel(),信息->get_pitch(),信息->get_velocity());
			break;
		case MIDI_MESSAGE_CONTROL_CHANGE:
			//控制器更改
			fluid_synth_cc(合成器,信息->get_channel(),信息->get_controller_number(),信息->get_controller_value());
			break;
		case MIDI_MESSAGE_PITCH_BEND:
			//弯音
			fluid_synth_pitch_bend(合成器, 信息->get_channel(), 信息->get_pitch());
			break;
		default:
			break;
	}
    // 播放音符序列
	return 0;
}

//连接方法到Godot游戏引擎里面
//使用Unicode字符当作方法名必须在字符串前输入”L“
void 外置波表输出::_bind_methods() {
	ClassDB::bind_method(D_METHOD(L"输出音符",L"数字输出事件"),&外置波表输出::输出音符);
}