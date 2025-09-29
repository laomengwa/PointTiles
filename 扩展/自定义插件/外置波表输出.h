#ifndef GDEXAMPLE_H
#define GDEXAMPLE_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/input_event_midi.hpp>
namespace godot {
//继承Node对象
class 外置波表输出 : public Node {
	GDCLASS(外置波表输出, Node)
	private:
	protected:
		static void _bind_methods();
	public:
		int 输出音符(const Ref<InputEventMIDI>&信息) const;
		void _ready();
	};
}
#endif
