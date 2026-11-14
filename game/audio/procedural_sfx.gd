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
		&"telegraph_sweep":  # anúncio do golpe horizontal: sobe
			s = _tones([[150.0, 0.0, 0.7, 0.3], [225.0, 0.25, 0.45, 0.25], [300.0, 0.5, 0.25, 0.2]], 0.8)
		&"telegraph_lunge":  # anúncio do avanço: duas batidas graves (diferente do varrido)
			s = _tones([[95.0, 0.0, 0.3, 0.45], [95.0, 0.45, 0.45, 0.5]], 0.95)
		&"impact":  # golpe que entra
			s = _tones([[0.0, 0.0, 0.12, 0.35], [90.0, 0.0, 0.18, 0.4]], 0.2)
		&"block":  # metal no escudo
			s = _tones([[1250.0, 0.0, 0.25, 0.18], [1830.0, 0.0, 0.18, 0.12], [0.0, 0.0, 0.05, 0.2]], 0.3)
		&"parry":  # aparo: anel brilhante
			s = _tones([[987.8, 0.0, 0.7, 0.25], [1318.5, 0.02, 0.6, 0.2]], 0.75)
		&"hurt":  # jogador atingido: baque surdo
			s = _tones([[70.0, 0.0, 0.25, 0.5], [0.0, 0.0, 0.08, 0.2]], 0.3)
		&"intervention":  # Intervenção: swell + estalo
			s = _tones([[110.0, 0.0, 0.6, 0.4], [440.0, 0.35, 0.4, 0.25], [0.0, 0.35, 0.06, 0.3]], 0.8)
		&"table_murmur":  # mesa ao longe: ruído suave em ondas + grave morno (placeholder de risos abafados)
			s = _tones([[0.0, 0.0, 0.9, 0.05], [0.0, 0.6, 0.8, 0.07], [0.0, 1.2, 1.0, 0.06], [0.0, 1.9, 0.9, 0.05],
				[196.0, 0.0, 2.6, 0.08], [246.9, 0.4, 2.2, 0.06]], 2.8)
		&"warm_chord":  # acorde maior suave, sem ataque: momento de ternura (não é voz falsa)
			s = _tones([[261.6, 0.0, 2.2, 0.16], [329.6, 0.05, 2.1, 0.13], [392.0, 0.1, 2.0, 0.12], [523.3, 0.3, 1.6, 0.05]], 2.4)
		&"fizzle":  # Intervenção sem alvo/Pulso: nada responde
			s = _tones([[180.0, 0.0, 0.15, 0.15], [150.0, 0.08, 0.15, 0.12]], 0.25)
		_:
			push_error("som desconhecido: %s" % sound)
			s = _tones([], 0.05)
	_cache[sound] = s
	return s


## tones: [freq, início_s, duração_s, amplitude]; freq 0 = ruído (semente fixa: som determinístico).
## Envelope ataque/decay suave para evitar cliques.
static func _tones(tones: Array, total_sec: float) -> AudioStreamWAV:
	var n := int(total_sec * RATE)
	var buf := PackedFloat32Array()
	buf.resize(n)
	var rng := RandomNumberGenerator.new()
	rng.seed = 1337
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
			var wave := rng.randf_range(-1.0, 1.0) if f == 0.0 else sin(TAU * f * i / RATE)
			buf[idx] += wave * amp * env
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
