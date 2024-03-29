s.reboot;
//if server gets stuck
Server.killAll;

MIDIClient.init; // connnection with OS
MIDIIn.connectAll; //conectarlos todos
MIDIIn.release; // end connection
MIDIdef.freeAll;

///CHANNEL 1

(
var notes1, on, off;

notes1 = Array.newClear(128);

on = MIDIdef.noteOn(\OnChan1, {
	arg  vel, nn, chan;
	[vel, nn, chan].postln;
	~delta[nn] = Synth(
		\delta,
		[\freq, nn.midicps,\gate, 1]);
}, chan:0);

off = MIDIdef.noteOff(\OffChan1, {
arg vel, nn, chan;
	[vel, nn, chan].postln;
	notes1[nn].set(\gate, 0);
	notes1[nn] = nil;
}, chan:0);


SynthDef(\delta,{
	arg freq = 400, gate=0;
	var sig, env;
	env = EnvGen.kr(Env.new([0, 1, 0, 0],[0.3, 0.3],[3, -3, 1]),gate,
	    doneAction:2);
	sig = Pulse.ar(freq)!2;
	sig = sig * env;
		Out.ar(0,sig);
}).add;
)



//CHANNEL 2

(
var notes2, on, off;

notes2 = Array.newClear(128);

on = MIDIdef.noteOn(\OnChan2, {
	arg  vel, nn, chan;
	[vel, nn, chan].postln;
	~theta[nn] = Synth.new(
		\theta,[\freq, nn.midicps,\gate, 1]);
	}, chan:1);

off = MIDIdef.noteOff(\OffChan2, {
arg vel, nn, chan;
	[vel, nn, chan].postln;
	~theta[nn].set(\gate, 0);
	~theta[nn] = nil;
},chan:1);

SynthDef(\theta, {
	arg freq=40, gate=0;
	var temp, sum, env;
	sum = 0;
	env = EnvGen.kr(
		Env.new([0, 1, 0, 0],[0.3, 0.3],[3, -3, 1]),gate,
	    doneAction:2);
	10.do {
	temp = VarSaw.ar(
			freq,
			{Rand(0.0, 1.0)}!2,
			{ExpRand(0.005, 0.05)}!2,
	);
	sum = sum + temp;
	};
	sum = sum * 0.3 * env;
	Out.ar(0, sum);
}).add;
)


///CHANNEL 3

(
n = Array.newClear(128);

(
MIDIdef.noteOn(\OnChan3, {
	arg  vel, nn, chan;
	[vel, nn, chan].postln;
	~alpha[nn] = Synth.new(
		\trial3,
		[
			\freq, nn.midicps,
			\amp, vel.linexp(1, 127, 0.01, 0.3),
	        \gate, 1,
	]
	);
	}, chan:2);

MIDIdef.noteOff(\OffChan3, {
arg vel, nn, chan;
	[vel, nn, chan].postln;
	~alpha[nn].set(\gate, 0);
	~alpha[nn] = nil;
}, chan:2);

SynthDef.new(\trial3, {
	arg freq=700, amp=0.5, gate=0;
	var sig, env;
		sig = SinOsc.ar(freq)!2;
		env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		sig = sig * env * amp;
	    Out.ar(0, sig);
}).add;
)

///CHANNEL 4

~beta1 = Array.newClear(128);

(
MIDIdef.noteOn(\OnChan4, {
	arg  vel, nn, chan;
	[vel, nn, chan].postln;
	~beta1[nn] = Synth.new(
		\trial4,
		[
			\freq, nn.midicps,
			\amp, vel.linexp(1, 127, 0.01, 0.3),
	        \gate, 1,
	]
	);
	}, chan:3);

MIDIdef.noteOff(\OffChan4, {
arg vel, nn, chan;
	[vel, nn, chan].postln;
	~beta1[nn].set(\gate, 0);
	~beta1[nn] = nil;
}, chan:3);

SynthDef.new(\trial4, {
	arg freq=700, amp=0.5, gate=0;
	var sig, env;
		sig = SinOsc.ar(freq)!2;
		env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		sig = sig * env * amp;
	    Out.ar(0, sig);
}).add;
)

///CHANNEL 5

~beta2 = Array.newClear(128);

(
MIDIdef.noteOn(\OnChan5, {
	arg  vel, nn, chan;
	[vel, nn, chan].postln;
	~beta2[nn] = Synth.new(
		\trial5,
		[
			\freq, nn.midicps,
			\amp, vel.linexp(1, 127, 0.01, 0.3),
	        \gate, 1,
	]
	);
	}, chan:4);

MIDIdef.noteOff(\OffChan5, {
arg vel, nn, chan;
	[vel, nn, chan].postln;
	~beta2[nn].set(\gate, 0);
	~beta2[nn] = nil;
}, chan:4);

SynthDef.new(\trial5, {
	arg freq=700, amp=0.5, gate=0;
	var sig, env;
		sig = SinOsc.ar(freq)!2;
		env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		sig = sig * env * amp;
	    Out.ar(0, sig);
}).add;
)

///CHANNEL 6
~gama = Array.newClear(128);

(
MIDIdef.noteOn(\OnChan6, {
	arg  vel, nn, chan;
	[vel, nn, chan].postln;
	~gama[nn] = Synth.new(
		\trial6,
		[
			\freq, nn.midicps,
			\amp, vel.linexp(1, 127, 0.01, 0.3),
	        \gate, 1,
	]
	);
	}, chan:5);

MIDIdef.noteOff(\OffChan6, {
arg vel, nn, chan;
	[vel, nn, chan].postln;
	~gama[nn].set(\gate, 0);
	~gama[nn] = nil;
}, chan:5);

SynthDef.new(\trial6, {
	arg freq=700, amp=0.5, gate=0;
	var sig, env;
		sig = SinOsc.ar(freq)!2;
		env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		sig = sig * env * amp;
	    Out.ar(0, sig);
}).add;
)
