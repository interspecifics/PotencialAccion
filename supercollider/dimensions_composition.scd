//Adapted for Eli Fieldsteel


(
SynthDef(\compo, {
	arg atk=1 , sus=0.5, rel=1, c1=1, c2=(-1),
	freq=400, cf=1500, rq=0.2, amp=1, gate= 0, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0, 1, 0],[atk, sus, rel], [c1,0,c2]),gate, doneAction:2);
	sig = Saw.ar(freq);
	sig = BPF.ar(sig, cf, rq);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).play;


(
[28, 35, 48, 73].midicps.do{
	arg f;
	Synth(
		\compo,
		[
			\freq, f,
			\amp, 0.5,
			\cf, f * exprand(1,12),
			\rq, exprand(0.01, 0.5),
			\sus, 0.1,
			\gate, 1
		]
	);
};
)
)


Scale.directory;

//Adapted for Eli Fieldsteel#2


(
SynthDef(\compo, {
	arg atk=2 , sus=0, rel=3, c1=1, c2=(-1),
	freq=400, detune=0.2,
	cfmin=500, cfmax=2000, rqmin=0.2, rqmax=0.2, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]),doneAction:2);
	sig = Saw.ar(freq * LFNoise1.kr(0.5,detune). midiratio);
	sig = BPF.ar(sig, LFNoise1.kr(0.2).exprange(cfmin,cfmax),LFNoise1.kr(0.1).exprange(rqmin, rqmax));
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;

10.do{Synth(\compo, [\amp, 0.1, \detune, 2])};
)

//Adapted for Eli Fieldsteel#3


(
SynthDef(\compo, {
	arg atk=2 , sus=0, rel=3, c1=1, c2=(-1),
	freq=500, detune=0.2,
	cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk, sus, rel], [c1,0,c2]),doneAction:2);
	sig = Saw.ar(freq * LFNoise1.kr(0.5,detune).midiratio);
	sig = BPF.ar(
		sig,
		LFNoise1.kr(0.2).exprange(cfmin, cfmax),
		LFNoise1.kr(0.1).exprange(rqmin, rqmax));
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
10.do{
Synth(
	\compo,
	[
		\freq, 50;
		\amp, 0.2,
		\cfmin, 50*2,
		\cfmax, 50*50,
		],
	);
};
)