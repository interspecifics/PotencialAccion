//hacer synthdefs
{ Resonz.ar(SinOsc.ar(SinOsc.kr([440, 400], 20, 100, 100), 0, 25),2,1,1)}.play

(
SynthDef.new(\low, {
	arg mul, gate;
	var freq, sig, amp, env;
	freq = Impulse.kr([600, 600], 0.7, mul);
	amp = 30;
	env = EnvGen.ar(Env.adsr(0.01, 0.01, 1, 0.5), gate, doneAction:2);
	sig = LFPar.ar(freq) * amp * env;
	Out.ar(0, sig);
}).add;
)
x=Synth.new(\low, [\mul, 30, \gate, 1]);
x.set(\mul, 50)
x.free;


(SynthDef.new(\EEG1, {
	arg ampHz=3, fund=30, maxPartial=3,width=0.5;
	var amp1, amp2, freq1, freq2, sig1, sig2;
	amp1 = LFSaw.kr(ampHz, 0, 0.5) * 0.25;
	amp2 = LFSaw.kr(ampHz, 0, 0.5) * 0.25;
	freq1 = LFClipNoise.kr(3).exprange(fund, fund*maxPartial);
	freq2 = LFClipNoise.kr(3).exprange(fund, fund*maxPartial);
	sig1 = LFPulse.ar(freq1, 0.5, width, amp1);
	sig2 = LFPar.ar(freq2, 0, width, amp2);
	Out.ar(0, sig1);
	Out.ar(1, sig2);
}).add;
)

y = Synth.new(\EEG1)
y.set(\ampHz, );
y.set(\fund, 40);
y.free;


(
SynthDef(\alpha,
	{
var drumosc, filterenv, drumoutput, volenv;
		filterenv = {Line.ar(1, 0, 0.2)};
		volenv = {Line.ar(1, 0, 0.6, doneAction:2)};
		drumosc = {SinOsc.ar(100)};
		drumoutput = {LPF.ar(drumosc,(filterenv *1000) +1000)};
		Out.ar(0, Pan2.ar(drumoutput * volenv, 0))
}).add;
)

t = Synth(\alpha);




(
SynthDef(\prophet5pwmstrings,{|out= 0 freq = 440 amp = 1.0 gate=1 lforate = 10 lfowidth= 0.5 cutoff= 12000 rq=0.5 pan = 0.0|

	var lfo, pulse, filter, env;

	lfo = LFTri.kr(lforate*[1,1.01],Rand(0,2.0)!2);

	pulse = Pulse.ar(freq*[1,1.01],lfo*lfowidth+0.5);

	filter = RLPF.ar(pulse,cutoff,rq);

	env = EnvGen.ar(Env.adsr(0.01,0.0,1.0,0.5),gate,doneAction:2);

	Out.ar(out,Pan2.ar(Mix(filter)*env*amp*0.5,pan));

}).play;
)