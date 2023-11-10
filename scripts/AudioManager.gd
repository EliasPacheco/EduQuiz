# AudioManager.gd
extends Node

var audio_player : AudioStreamPlayer
var current_audio_stream : AudioStream
var saved_playback_position : float = 0.0
var is_audio_enabled : bool = true
var current_volume_db : float = 0.0  # Ajuste o valor para diminuir o volume
var music_playing : bool = false

# Configuração do singleton
func _ready():
	var root = get_tree().get_root()
	if not root.has_node(self.get_path()):
		root.add_child(self)

	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	set_volume_db(current_volume_db)

func save_playback_position():
	if audio_player != null:
		saved_playback_position = audio_player.get_playback_position()

func restore_playback_position():
	if audio_player != null:
		audio_player.seek(saved_playback_position)

func play_sound(audio_stream: AudioStream):
	if is_audio_enabled:
		restore_playback_position()

		# Verifica se a mesma instância do áudio está sendo reproduzida
		if audio_stream != current_audio_stream:
			audio_stream = set_volume_in_audio_stream(audio_stream, current_volume_db)

			if audio_player == null:
				audio_player = AudioStreamPlayer.new()
				add_child(audio_player)

			audio_player.stream = audio_stream
			current_audio_stream = audio_stream

			if audio_player != null:
				audio_player.play()

			music_playing = true  # Marca que a música está sendo reproduzida

# Adiciona uma função para verificar se a música está sendo reproduzida
func is_background_audio_playing() -> bool:
	return music_playing

# Adiciona uma função para iniciar a música
func start_background_audio():
	var audio_stream = load("res://audio/sound.ogg")
	play_sound(audio_stream)

func stop_current_sound():
	if audio_player != null:
		audio_player.stop()

func set_volume_in_audio_stream(audio_stream: AudioStream, volume_db: float) -> AudioStream:
	if audio_stream is AudioStreamSample:
		var audio_sample = audio_stream as AudioStreamSample
		audio_sample.volume_db = volume_db

	return audio_stream

func set_volume_db(volume_db: float):
	current_volume_db = volume_db
	if audio_player != null:
		audio_player.volume_db = volume_db

# Adiciona uma função para retomar a música
func resume_background_audio():
	if music_playing:
		restore_playback_position()
		audio_player.play()
