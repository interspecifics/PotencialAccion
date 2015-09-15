s.boot;
//if server gets stuck
Server.killAll;

MIDIClient.init; // connnection with OS
MIDIClient.sources; //availables source devices
MIDIIn.connect(0)// para conectar solo uno en el paréntesis el index
MIDIIn.connectAll; //conectarlos todos
MIDIIn.release; // end connection

(
    MIDIIn.noteOff = { arg src, chan, num, vel;
	[chan,num,vel / 127].postln; };

    MIDIIn.noteOn = { arg src, chan, num, vel;
	[chan,num,vel,src / 127].postln; };

    MIDIIn.polytouch = { arg src, chan, num, vel;
	[chan,num,vel / 127].postln; };

	MIDIIn.control = { arg src, chan, num, val;
	[chan,num,val].postln; };

	MIDIIn.program = { arg src, chan, prog;
	[chan,prog].postln; };

	MIDIIn.touch = { arg src, chan, pressure;
	[chan,pressure].postln; };

	MIDIIn.bend = { arg src, chan, bend;
	[chan,bend - 8192].postln; };

	MIDIIn.sysex = { arg src, sysex;
	sysex.postln; };

	MIDIIn.sysrt = { arg src, chan, val;
	[chan,val].postln; };

	MIDIIn.smpte = { arg src, chan, val;
	[chan,val].postln; };
)

// PARA MIDIdefs
//Prueba note On
MIDIdef.noteOn(\Pd, {"recibiendo".postln});
// able or disable
MIDIdef(\Pd).disable;
// free one
MIDIdef(\Pd).free;
//freeAll
MIDIdef.freeAll;



///CHANNEL 1

(

SynthDef.new(\trial1, {
	arg freq=700, amp=0.5, gate=0;
	var sig, env;
		sig = SinOsc.ar(freq)!2;
		env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		sig = sig * env * amp;
	    Out.ar(0, sig);
}).add;

MIDIdef.noteOn(\OnChan1, {
	arg  vel, nn, chan;
	[vel, nn, chan].postln;
	~frecuenciasEEG[nn] = Synth.new(
		\trial1,
		[
			\freq, nn.midicps,
			\amp, vel.linexp(1, 127, 0.01, 0.3),
			\gate, 1,
		]
	);
}, chan:0);

MIDIdef.noteOff(\OffChan1, {
arg vel, nn, chan;
	[vel, nn, chan].postln;
	~frecuenciasEEG[nn].set(\gate, 0);
	~frecuenciasEEG[nn] = nil;
});

)


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



///CHANNEL 3

(
MIDIdef.noteOn(\OnChan3, {
	arg  vel, nn, chan;
	[vel, nn, chan].postln;
	~frecuenciasEEG[nn] = Synth.new(
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
	~frecuenciasEEG[nn].set(\gate, 0);
	~frecuenciasEEG[nn] = nil;
});

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

(
MIDIdef.noteOn(\OnChan4, {
	arg  vel, nn, chan;
	[vel, nn, chan].postln;
	~frecuenciasEEG[nn] = Synth.new(
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
	~frecuenciasEEG[nn].set(\gate, 0);
	~frecuenciasEEG[nn] = nil;
});

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

(
MIDIdef.noteOn(\OnChan5, {
	arg  vel, nn, chan;
	[vel, nn, chan].postln;
	~frecuenciasEEG[nn] = Synth.new(
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
	~frecuenciasEEG[nn].set(\gate, 0);
	~frecuenciasEEG[nn] = nil;
});

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

(
MIDIdef.noteOn(\OnChan6, {
	arg  vel, nn, chan;
	[vel, nn, chan].postln;
	~frecuenciasEEG[nn] = Synth.new(
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
	~frecuenciasEEG[nn].set(\gate, 0);
	~frecuenciasEEG[nn] = nil;
});

SynthDef.new(\trial6, {
	arg freq=700, amp=0.5, gate=0;
	var sig, env;
		sig = SinOsc.ar(freq)!2;
		env = EnvGen.kr(Env.adsr, gate, doneAction:2);
		sig = sig * env * amp;
	    Out.ar(0, sig);
}).add;
)

