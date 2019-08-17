Dimensions
=========

Dimensions is a sonification and visualisation system of brain waves activity, using topographic values from energy pointers. The main technique is to map every electro and represent the dominant frequencies, looking for possible power, phase, or trigger correlations. 

# Relation of parameters:

     1. Space: every electrode analyzed have their own distinctive note

     2. Time: one bang is create every time a specific dominate frequency appears

     3. Frequency: every frequency response to and specific sonic processor

If a frequency meets over the six possible analysis levels we receive a true message that sends a bang. Here and examples using beta values for analysis modules, every frequency have their own maximum (positive) and minimum (negative) thresholds and the phases in in between.

![values](https://github.com/Lessnullvoid/PotencialAccion/blob/master/img/rangos.png?raw=true )

Those bangs are converter into specify note and channels depending on the electrode and the frequency:

![notes](https://github.com/Lessnullvoid/PotencialAccion/blob/master/img/noteandchannel.png?raw=true ) ![notes](https://github.com/Lessnullvoid/PotencialAccion/blob/master/img/notechannel2.png?raw=true)

**Distribution of elements:** 

     - Frencuency =  channel
     - Electrode = note 
     - Time =  time (number of times a note is play )

**Number of frequencies: 6**
     1. delta
     2. theta
     3. alpha
     4. smBeta
     5. midBeta
     6. HighBeta

**Electrodes to notes:** (static version)
     AF3 = 70,  F7 = 60,  F4 = 50,  F3 = 55, F8 = 65, AF4 = 75

**Number of Instruments: 6**
General description of the instruments

![sc instruments](https://github.com/Lessnullvoid/PotencialAccion/blob/master/img/supercolliderchannels.png?raw=true)

# Displacement of forces over time
This system enables the user to be aware of the displacement of energies moving on the brain. One can notice correlation such as symmetry on electrodes of the same order, same frequency domains in all electrodes, or asymmetrical correlation on left and right side of the brain.

**Scenarios:**

1. all electrodes playing the same channel:
When all the electrodes are playing the same channel, we are listening to the same interment bing interpreted by 6 possible notes. This means that all the electrodes are correlating the same frequency domain

2. every electrode plays a channel:
This scenario shows that all de frequencies are in different states in all the electrodes

3. groups of electrodes plays specific channels:
Every electrode have 6 different possibilities for play a channel over time, this represents the level of energy or the frequency domain that is detected by the system.

Our patch is design to trigger one bang every time one of the possible levels of frequencies are meet.

The rows represents the electrodes, every row has six different levels of frequency  responding form 0.5 HZ to 30 Hz.

Cartesian distribution of elements:

     X = electrodes
     Y =  frequencies (High - Low)

The following images show some of the possible arrangements for the electrodes to play over time on different frequency levels

![all alpha](https://github.com/Lessnullvoid/PotencialAccion/blob/master/img/allAlpha.png?raw=true)
All electrodes in alpha energy

![beta curve](https://github.com/Lessnullvoid/PotencialAccion/blob/master/img/betaCurve.png?raw=true)
A curve from SMR beta to Hight beta

![diagonal](https://github.com/Lessnullvoid/PotencialAccion/blob/master/img/diagonalfromDeltatoBeta.png?raw=true)
A diagonal movement from left to right 

**OSC data manager**

The data manager receives messages from our custom osc processing server and distributes them into electrodes and frequencies. A simple low pass filter is apply for every data set.
![diagonal](https://github.com/Lessnullvoid/PotencialAccion/blob/master/img/OSCreceiver.png?raw=true)

**Correlations**

This part is in charge of the data analysis for the every electrode, If two electrodes meet the same level of frequency over time, and special especial event is trigger over OSC and midi.

![correlations](https://github.com/Lessnullvoid/PotencialAccion/blob/master/img/Correlations.png?raw=true)



Install Potencial Accion SDK
===============

Is a series of open source tools for brain wave data analysis and interpretation 

Librerías para OS X
===================

- pyOsc:```sudo easy_install pyOsc ``` (descargar manualmente, navegar a la carpeta e instalar como:: ```sudo ./setup.py install```

- hidapi:```brew install hidapi ```

- pycrypto:```sudo easy_install pycrypto ```

- gevent:```sudo easy_install gevent ```

- cython-hidapi:  https://github.com/gbishop/cython-hidapi 
  download and ```python setup-mac.py build ``` /```sudo python setup-mac.py install ```

- realpath:  ```sudo port install realpath ``` 
using brew: ( ```brew tap iveney/mocha ```) ( ```brew install realpath ```)

emoOscServer
=========

Para correr el emoOscServer es necesario instalar Emokit, recomendamos el fork de Thiago Hersan para esto:

https://github.com/thiagohersan/emokit navega hasta la carpeta de python y desde la terminal: 

```sudo python setup.py install```


Después vamos a instalar varias librerías, para esto se recomienda configurar `setuptools`, esto lo puedes hacer instalando brew. En la terminal: 

```ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"``` 

una vez terminada la instalación: 

```export PATH=/usr/local/bin:/usr/local/sbin:$PATH```


Tools
=========

• csvtoOsc 
Esta herramienta te permite leer archivos csv, para esto solo tienes que correr la aplicación y seleccionar el archivo que deseas transmitir en formato OSC. 

________________________________________

• PotencialServer
El potencialServer corre en conjunto con el emoOscServer, primero te recomendamos correr el programa en processing, depués en la terminal navegar hasta el archivo `emoOscServer.py` para ejecutarlo en la terminal:

python emoOscServer.py

NOTA: es importante que edite el archivo y lo actualices con los datos Serial Number: vendor id: y product id: que corresponden a tu kit epoc específico. 


