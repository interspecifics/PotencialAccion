from emokit.emotiv import Emotiv
from OSC import OSCClient, OSCMessage
import gevent

OSC_OUT_HOST = "localhost"
OSC_OUT_PORT = 8444
SENSOR_LIST = 'AF3 F7 F3 FC5 T7 P7 O1 O2 P8 T8 FC6 F4 F8 AF4'

if __name__ == "__main__":
    mOscClient = OSCClient()
    mOscClient.connect( (OSC_OUT_HOST,OSC_OUT_PORT) )
    mOscMessage = OSCMessage()

    headset = Emotiv(serial_number="SN201405", vendor_id=0x21a1, product_id=0x0001)
    gevent.spawn(headset.setup)
    gevent.sleep(0)

    try:
        while True:
            packet = headset.dequeue()
            for k,v in packet.sensors.iteritems():
                if k in SENSOR_LIST:
                    for kk,vv in v.iteritems():
                        mOscMessage.clear("/emokit/"+k+"/"+kk)
                        mOscMessage.append(vv)
                        mOscClient.send(mOscMessage)

            gevent.sleep(0)
    except KeyboardInterrupt:
        headset.close()
    finally:
        headset.close()
