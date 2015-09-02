#Code actualization during the Hack the brain at Waag Society Amsterdam
#Team: David Goedicke, Leslie Garcia, Paloma Lopez (need the other team names)
#June 2015

import numpy as np
import math
import scipy.fftpack
from emokit.emotiv import Emotiv
from OSC import OSCClient, OSCMessage
import gevent

OSC_OUT_HOST = "localhost"
OSC_OUT_PORT = 8444
SENSOR_LIST = 'AF3 F7 F3 F4 F8 AF4'

if __name__ == "__main__":
    mOscClient = OSCClient()
    mOscClient.connect( (OSC_OUT_HOST,OSC_OUT_PORT) )
    mOscMessage = OSCMessage()

    headset = Emotiv(serial_number="SN201405232628GM", vendor_id=8609, product_id=1)
    gevent.spawn(headset.setup)
    gevent.sleep(0)

    chanHist = [[0 for x in range(0)] for x in range(6)]
    N = 128 #We always take 128 chunks so we get to slighly above 60hz
    T = 1.0 / (N*1) # We know that the emotive delivers 128 samples persecond
    count=0
    try:
        while True:
            packet = headset.dequeue()
            cCount=0
            for k,v in packet.sensors.iteritems():
                if ((k in SENSOR_LIST) and ('value' in v) and ('quality' in v)):
                    chanHist[cCount].append(v['value'])
                    cCount += 1
                    mOscMessage.clear("/emokit/"+k+"/")
                    mOscMessage.append(v['value'])
                    mOscMessage.append(v['quality'])
                    mOscClient.send(mOscMessage)
            count += 1
            if count >=N:
                for i in range(0,len(chanHist)):
                    output=[1 for x in range(7)]
                    norm=[1 for x in range(7)]
                    yf = np.abs(scipy.fftpack.fft(chanHist[i]))
                    n = len(chanHist[i])
                    freq = np.fft.fftfreq(n, T)
                    xf = np.linspace(0.0, 1.0/(2.0*T), N/2)
                    j=2
                    while freq[j+1]>freq[j] :
                        # delta 0.5 - 3 hz
                        if round(freq[j])>0.5 and round(freq[j])<3 :
                            norm[0]+=1
                            output[0]+=yf[j]
                        # theta 4 - 7 hz
                        elif round(freq[j])>4 and round(freq[j])<7 :
                            norm[1]+=1
                            output[1]+=yf[j]
                        # alpha 8 - 12 hz
                        elif round(freq[j])>8 and round(freq[j])<12 :
                            norm[2]+=1
                            output[2]+=yf[j]
                        # SMR beta 12.5 - 15 hz
                        elif round(freq[j])>12.5 and round(freq[j])<15 :
                            norm[3]+=1
                            output[3]+=yf[j]
                        # Mid beta 15.5 - 18 hz
                        elif round(freq[j])>15.5 and round(freq[j])<18 :
                            norm[4]+=1
                            output[4]+=yf[j]
                        # High beta 22 - 35 hz
                        elif round(freq[j])>22 and round(freq[j])<35 :
                            norm[5]+=1
                            output[5]+=yf[j]
                        # Gama 35 - 80 hz
                        elif round(freq[j])>35 and round(freq[j])<80 :
                            norm[6]+=1
                            output[6]+=yf[j]
                        j = j+1
                        if norm[0]!=0 and norm[1]!=0 and norm[2]!=0 and norm[3]!=0 and norm[4]!=0 and norm[5]!=0 and norm[6]!=0:
                            mOscMessage.clear("/brainWaves/"+SENSOR_LIST.split(' ')[i]+"/")
                            mOscMessage.append(output[0]/norm[0])
                            mOscMessage.append(output[1]/norm[1])
                            mOscMessage.append(output[2]/norm[2])
                            mOscMessage.append(output[3]/norm[3])
                            mOscMessage.append(output[4]/norm[4])
                            mOscMessage.append(output[5]/norm[5])
                            mOscMessage.append(output[6]/norm[6])
                            mOscClient.send(mOscMessage)
                            #Here we create and send an oscMessage
                           # print str(output[0]/norm[0])+"\t"+str(output[1]/norm[1])+"\t"+str(output[2]/norm[2])+"\t"+str(output[3]/norm[3])
                count=0 #After the analysis we recet our counter
                chanHist = [[0 for x in range(0)] for x in range(6)] #and the channel history
            cCount=0
            gevent.sleep(0)
    except KeyboardInterrupt:
        headset.close()
    finally:
        headset.close()
