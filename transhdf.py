import h5py
import numpy as np

with h5py.File("jieguo/pgan.h5") as ipt:
    hg=ipt["Answer"][()]

leng=len(hg)
newans=np.empty(leng,dtype=[('EventID',np.int16),('ChannelID',np.int16),('PETime',np.int16),('Weight',np.float32)])

newans['EventID']=hg[:,0]
newans['ChannelID']=hg[:,1]
newans['PETime']=hg[:,2]
newans['Weight']=hg[:,3]
print(newans)
with h5py.File("pgtestnew.h5","w") as opt:
    opt.create_dataset("Answer",data=newans)

