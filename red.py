import h5py
import numpy as np

with h5py.File("pgan.h5") as ipt:
    hg=ipt["Answer"][()]

leng=len(hg)
newans=np.empty(leng,dtype=[('EventID',np.int16),('ChannelID',np.int16),('PETime',np.int16),('Weight',np.int16)])
print(hg['EventID'])
newans['EventID']=np.transpose(hg['EventID'])
newans['ChannelID']=np.transpose(hg['ChannelID'])
newans['PETime']=np.transpose(hg['PETime'])
newans['Weight']=np.transpose(hg['Weight'])
print(newans.dtype)
with h5py.File("pgtest.h5","w") as opt:
    opt.create_dataset("Answer",data=newans)

