import h5py
import numpy as np

with h5py.File("pgan.h5") as ipt:
    hg=ipt["Answer"][()]

leng=len(hg)
newans=np.empty(leng,dtype=[('EventID',np.int16),('ChannelID',np.int16),('PETime',np.float16),('Weight',np.int8)])

newans['EventID']=hg[:,0]
newans['ChannelID']=hg[:,1]
newans['PETime']=hg[:,2]
newans['Weight']=hg[:,3]
print(newans.dtype)
with h5py.File("pgtest.h5","w") as opt:
    opt.create_dataset("Answer",data=newans)

