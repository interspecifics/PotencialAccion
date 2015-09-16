
NetAddr.langPort; // retrieve the current port SC is listening to
NetAddr.localAddr; // retrieve the current IP and port

(
thisProcess.recvOSCfunc = { |time, addr, msg|
	if(msg[0] != 'status.reply') {
		"time: % sender: %\nmessage: %\n".postf(time, addr, msg)};
}
);

// stop posting.
thisProcess.recvOSCfunc = nil;


o = OSCresponder(nil, '/AF3', {arg time, responder, msg, addr;
		[time, responder, msg, addr].postln;
	}).add;
	o.remove;

	(
	// synth
	x = SynthDef(\sine, {arg freq=440;
		Out.ar(0, (SinOsc.ar([freq, freq * 1.015], 0, 0.1)))})
		.play;

	// make the responder
	o = OSCresponder(nil, '/AF3', {arg time, responder, msg, addr;
		msg.postln;
		x.set(\freq,msg[1]);
	}).add;
	)
	o.remove;