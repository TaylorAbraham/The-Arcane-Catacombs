extends AudioStreamPlayer2D

func play_sound(audio_stream: AudioStreamSample):
	set_stream(audio_stream)
	play()

func _on_AudioStreamPlayer2D_finished() -> void:
	queue_free()
