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
while i <10000:
    
    if GroundTruthTable[i]['ChannelID']!=GroundTruthTable[i-1]['ChannelID'] and GroundTruthTable[i]['ChannelID']!=GroundTruthTable[i+1]['ChannelID']:
        sinevet.append(GroundTruthTable[i]['EventID'])
        sintime.append(GroundTruthTable[i]['PETime'])
        sinchan.append(GroundTruthTable[i]['ChannelID'])
    i+=1



sumwave=np.zeros(1029,dtype=np.int32)
sinlen=len(sinevet)
for x in range(sinlen):
    posi=0
    while True:
        if WaveformTable[posi]["EventID"]==sinevet[x] and WaveformTable[posi]["ChannelID"]==sinchan[x]:
            break
        posi+=1
    sumwave+=np.append(WaveformTable[posi]['Waveform'][sintime[x]:],WaveformTable[posi]['Waveform'][:sintime[x]])-972

averwave=sumwave/sinlen
print(min(sumwave))
print(sumwave.dtype)
print(averwave.dtype)
averzero=np.average(averwave[100:])
spe=averwave-averzero

with open("average.csv", "w") as opt1:
    np.savetxt(opt1, np.array([averzero]))
with h5py.File('singlewave.h5',"w") as opt2:
    opt2.create_dataset("spe",data=spe,compression="gzip", shuffle=True)

plt.plot(spe)
plt.xlabel('Time [ns]')
plt.ylabel('Voltage [ADC]')
plt.savefig("singlewave.png")

h5file.close()
