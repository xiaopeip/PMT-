(* ::Package:: *)

spe1=Import["D:\\bigdata\\project-2-pmt-go\\singlewave1.h5","spe"];
aver=Import["D:\\bigdata\\project-2-pmt-go\\average1.h5","averzero"];
spe2=Import["D:\\bigdata\\project-2-pmt-go\\singlewave2.h5","spe"];
opt={};

For[j=1,j<=7770,j++,
ipt=Import["D:\\bigdata\\project-2-pmt-go\\data\\playground-data.h5","Waveform","TakeElements"->{j}][[1]];
wave=ipt["Waveform"]-972-aver;
event=ipt["EventID"];
channel=ipt["ChannelID"];

lowp=Flatten[Position[wave,x_/;x<-9.5]];
nihep=Union@@Table[lowp+n,{n,-7,15}];
xuhao=Position[Table[wave[[i+1]]-wave[[i]]-wave[[i-1]]+wave[[i-2]],{i,lowp}],x_/;x>1.6]//Flatten;
newfla=Union[lowp[[xuhao]]-10,lowp[[xuhao]]-9,lowp[[xuhao]]-8];

bianl=Table[b[y],{y,newfla}];
For[restr=bianl[[1]]>=0;i=2,i<=Length[bianl],i=i+1,restr=(restr&&bianl[[i]]>=0)];
mne=Table[spe1[[Piecewise[{{x-y+1,x-y+1>0}},x-y+1030]]],{x,nihep},{y,newfla}];
ans=TimeConstrained[bianl/.FindMinimum[{Norm[mne.bianl-wave[[nihep]]],restr},bianl][[2]],.25,
TimeConstrained[bianl/.FindMinimum[{Norm[Table[spe2[[Piecewise[{{x-y+1,x-y+1>0}},x-y+1030]]],{x,nihep},{y,newfla}].bianl-wave[[nihep]]],restr},bianl][[2]],.25]
]//Round;


If[AllTrue[ans,#<=0&],
	
	AppendTo[opt,{event,channel,FirstPosition[wave,Min[wave]][[1]]-8,1}],
	For[k=1,k<=Length[ans],k++,
		If[ans[[k]]>0,
		AppendTo[opt,{event,channel,newfla[[k]],ans[[k]]}]]],
	AppendTo[opt,{event,channel,FirstPosition[wave,Min[wave]][[1]]-8,1}];
	];

If[Mod[j,10]==0,Print[j]];
]
Export["D:\\bigdata\\project-2-pmt-go\\pgan.h5",{"Answer"->opt},"Datasets"]



