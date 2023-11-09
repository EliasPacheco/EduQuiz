# AudioManager.gd
extends Node

var audio_player : AudioStreamPlayer
var saved_playback_position : float = 0.0
var is_audio_enabled : bool = true
var current_volume_db : float = -50.0  # Defina o valor inicial de volume desejado

var current_audio_stream_player : AudioStreamPlayer


func _ready():
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)

	# Configura o volume ao iniciar
	set_volume_db(current_volume_db)

func save_playback_position():
	saved_playback_position = audio_player.get_playback_position()

func restore_playback_position():
	audio_player.seek(saved_playback_position)

func play_sound(audio_stream: AudioStream):
	if is_audio_enabled:
		restore_playback_position()
		audio_stream = set_volume_in_audio_stream(audio_stream, current_volume_db)
		audio_player.stream = audio_stream
		audio_player.play()

# AudioManager.gd
func stop_current_sound():
	if current_audio_stream_player:
		current_audio_stream_player.stop()
		print("stop_current_sound() chamado")


# Função para ajustar o volume em um AudioStream
func set_volume_in_audio_stream(audio_stream: AudioStream, volume_db: float) -> AudioStream:
	var new_audio_stream: AudioStream

	if audio_stream is AudioStreamSample:
		var audio_sample = audio_stream as AudioStreamSample
		audio_sample.volume_db = volume_db
		new_audio_stream = audio_sample
	elif audio_stream is AudioStreamOGGVorbis:
		var ogg_vorbis = audio_stream as AudioStreamOGGVorbis
		ogg_vorbis.volume_db = volume_db
		new_audio_stream = ogg_vorbis
	elif audio_stream is AudioStreamMP3:
		var mp3 = audio_stream as AudioStreamMP3
		mp3.volume_db = volume_db
		new_audio_stream = mp3
	else:
		new_audio_stream = audio_stream

	return new_audio_stream

# Função para ajustar o volume durante a execução
func set_volume_db(volume_db: float):
	current_volume_db = volume_db
	audio_player.volume_db = volume_db
