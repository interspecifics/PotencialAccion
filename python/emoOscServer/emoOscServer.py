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

    headset = Emotiv(serial_number="UD202103210058A5", vendor_id=1234, product_id=2)
    gevent.spawn(headset.setup)
    gevent.sleep(0)

    try:
        while True:
            packet = headset.dequeue()
            for k,v in packet.sensors.iteritems():
                if ((k in SENSOR_LIST) and ('value' in v) and ('quality' in v)):
                    mOscMessage.clear("/emokit/"+k+"/")
                    mOscMessage.append(v['value'])
                    mOscMessage.append(v['quality'])
                    mOscClient.send(mOscMessage)

            gevent.sleep(0)
    except KeyboardInterrupt:
        headset.close()
    finally:
        headset.close()
