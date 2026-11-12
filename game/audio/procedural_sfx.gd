## Sons placeholder sintetizados em código (originais, sem licença de terceiros). Serão substituídos no art proof (G3).
## Cada som é gerado uma vez e reaproveitado.
class_name ProceduralSfx
extends RefCounted

const RATE := 22050

static var _cache := {}


## Nomes: resonance_swell, monitor_beep, chime_solved, dissonant, candle_toggle.
static func get_stream(sound: StringName) -> AudioStreamWAV:
	if _cache.has(sound):
		return _cache[sound]
	var s: AudioStreamWAV
	match sound:
		&"resonance_swell":  # grave que cresce e some: o mundo "afinando" (Véu → Eco)
			s = _tones([[110.0, 0.0, 1.4, 0.45], [164.8, 0.05, 1.35, 0.25], [220.0, 0.15, 1.1, 0.12]], 1.5)
		&"monitor_beep":  # continuidade sino → pulso eletrônico (Audio Bible §1)
			s = _tones([[880.0, 0.0, 0.12, 0.35], [880.0, 0.9, 0.12, 0.35], [880.0, 1.8, 0.12, 0.35]], 2.1)
		&"chime_solved":  # resolução: três notas ascendentes, timbre quente
			s = _tones([[392.0, 0.0, 0.9, 0.3], [493.9, 0.18, 0.9, 0.25], [587.3, 0.36, 1.2, 0.25]], 1.7)
		&"dissonant":  # falha não punitiva: trítono curto e baixo
			s = _tones([[233.1, 0.0, 0.5, 0.25], [329.6, 0.0, 0.5, 0.2]], 0.6)
		&"candle_toggle":
			s = _tones([[660.0, 0.0, 0.08, 0.15]], 0.12)
		_:
			push_error("som desconhecido: %s" % sound)
			s = _tones([], 0.05)
	_cache[sound] = s
	return s


## tones: [freq, início_s, duração_s, amplitude]; envelope ataque/decay suave para evitar cliques.
static func _tones(tones: Array, total_sec: float) -> AudioStreamWAV:
	var n := int(total_sec * RATE)
	var buf := PackedFloat32Array()
	buf.resize(n)
	for t: Array in tones:
		var f: float = t[0]
		var start := int(t[1] * RATE)
		var length := int(t[2] * RATE)
		var amp: float = t[3]
		var attack := mini(int(0.02 * RATE), length / 4)
		for i in length:
			var idx := start + i
			if idx >= n:
				break
			var env := minf(1.0, float(i) / maxf(1.0, attack)) * pow(1.0 - float(i) / length, 1.6)
			buf[idx] += sin(TAU * f * i / RATE) * amp * env
	var bytes := PackedByteArray()
	bytes.resize(n * 2)
	for i in n:
		bytes.encode_s16(i * 2, int(clampf(buf[i], -1.0, 1.0) * 32767.0))
	var s := AudioStreamWAV.new()
	s.format = AudioStreamWAV.FORMAT_16_BITS
	s.mix_rate = RATE
	s.stereo = false
	s.data = bytes
	return s
