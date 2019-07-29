import h5py
import tables
import numpy as np
import matplotlib
matplotlib.use("Agg")
from matplotlib import pyplot as plt

# Read hdf5 file
h5file = tables.open_file("./data/atraining-0.h5", "r")
WaveformTable = h5file.root.Waveform
GroundTruthTable = h5file.root.GroundTruth

sinevet,sinchan,sintime=[],[],[]

i=1
while i <10000000:
    
    if GroundTruthTable[i]['ChannelID']!=GroundTruthTable[i-1]['ChannelID'] and GroundTruthTable[i]['ChannelID']!=GroundTruthTable[i+1]['ChannelID']:
        sinevet.append(GroundTruthTable[i]['EventID'])
        sintime.append(GroundTruthTable[i]['PETime'])
        sinchan.append(GroundTruthTable[i]['ChannelID'])
    i+=1

def ht(ht0,PEt):
    h=np.empty(1029,dtype=np.int16)
    for ite in range(1029):
        if ite<1029-PEt:
            h[ite]=ht0[ite+PEt]
        else:
            h[ite]=ht0[ite+PEt-1029]
    return h

sumwave=0
sinlen=len(sinevet)
for x in range(sinlen):
    leng=100000
    posi=0
    while posi < leng:
        if WaveformTable[posi]["EventID"]==sinevet[x]:
            if WaveformTable[posi]["ChannelID"]==sinchan[x]:
                break
        posi+=1
    sumwave+=ht(WaveformTable[posi]['Waveform'],sintime[x])-972

averwave=sumwave/sinlen
print(min(sumwave))
print(averwave.dtype)

plt.plot(averwave)
plt.xlabel('Time [ns]')
plt.ylabel('Voltage [ADC]')
plt.savefig("wave.png")

h5file.close()
