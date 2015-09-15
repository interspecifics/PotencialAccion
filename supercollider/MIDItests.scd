

~frecuenciasEEG = Array.newClear(128);

//CHANNEL 2

(
MIDIdef.noteOn(\OnChan2, {
	arg  vel, nn, chan;
	[vel, nn, chan].postln;
	~frecuenciasEEG[nn] = Synth.new(
		\trial2,
		[
			\freq, nn.midicps,
			\amp, vel.linexp(1, 127, 0.01, 0.3),
	        \gate, 1,
	]
	);
	}, chan:1);

MIDIdef.noteOff(\OffChan2, {
arg vel, nn, chan;
	[vel, nn, chan].postln;
	~frecuenciasEEG[nn].set(\gate, 0);
	~frecuenciasEEG[nn] = nil;
});

SynthDef.new(\trial2, {
	arg freq=700, amp=0.5, gate=0;
	var sig, env;
		sig = SinOsc.ar(freq)!2;
		env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		sig = sig * env * amp;
	    Out.ar(0, sig);
}).add;
)




///CHANNEL 1 ANTERIOR SOSTENIDO FUNCIONA

(
MIDIdef.noteOn(\chan0, {
	arg vel, nn, chan;
	[vel, nn, chan].postln;
	Synth.new(\esm, [\cutoff, 2000, \fdec, 3, \fint, 1, \od, 0.5, \glide, 0.5]);
	}, chan:0);

SynthDef(\esm, {|freq=440, mix=0.5, glide=0, cutoff=20000, rq=1, fdec=0, fint=1,
	vel=1, fvel=1, t_gate=1, vdec=1, vvel=0, od=0, mul=0.1, pan=0, out=0|
	var sig, saw, rect, fstart, fenv, vstart, venv;

	freq = freq.lag(glide);

	// oscillators
	saw = LFSaw.ar(freq, 0, 1);
	rect = LFPulse.ar(freq, 0, 0.5, 1);
	sig = Mix([saw * (1-mix), rect * mix]);

	// filter
	fstart = vel.linlin(0, fvel, 0, fint).linexp(0, 1, cutoff, 20000);
	fenv = EnvGen.kr(Env([fstart, fstart, cutoff], [0.001, fdec]), t_gate);
	sig = LPF.ar(sig, fenv, rq);

	// volume env
	vstart = vel.linlin(0, vvel.max(10e-1), 0, 1);
	venv = EnvGen.ar(Env([vstart, vstart, 0], [0.01, vdec], \cub), t_gate);
	sig = sig * venv;

	// distortion
	sig = sig * od.linlin(0, 1, 1, 100).clip2(mul);

	Out.ar(out,
		Pan2.ar(sig, pan);
	)
}).add;

)