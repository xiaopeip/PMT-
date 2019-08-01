(* ::Package:: *)

spe=Import["D:\\bigdata\\project-2-pmt-go\\singlewave.h5","spe"];
aver=Import["D:\\bigdata\\project-2-pmt-go\\average.csv"][[1]][[1]];
SPE=Import["D:\\bigdata\\project-2-pmt-go\\data\\SPE.h5","SPE"];

opt={};
For[j=1,j<=7770,j++,
ipt=Import["D:\\bigdata\\project-2-pmt-go\\data\\playground-data.h5","Waveform","TakeElements"->{j}][[1]];
wave=ipt["Waveform"]-972-aver;
event=ipt["EventID"];
channel=ipt["ChannelID"];
lowp=Flatten[Position[wave,x_/;x<-10]];
newfla=lowp-9;
bianl=Table[b[y],{y,newfla}];
For[restr=bianl[[1]]>=0;i=2,i<=Length[bianl],i=i+1,restr=(restr&&bianl[[i]]>=0)];
mne=Table[spe[[Piecewise[{{x-y+1,x-y+1>0}},x-y+1030]]],{x,lowp},{y,newfla}];
ans=TimeConstrained[bianl/.FindMinimum[{Norm[mne.bianl-wave[[lowp]]],restr},bianl][[2]],.3,
TimeConstrained[bianl/.FindMinimum[{Norm[Table[SPE[[Piecewise[{{x-y+1,x-y+1>0}},x-y+1030]]],{x,lowp},{y,newfla}].bianl-wave[[lowp]]],restr},bianl][[2]],.22]
]//Round;

If[AllTrue[ans,#<=0&],
	
	AppendTo[opt,{<|"EventID"->event,"ChannelID"->channel,"PETime"->FirstPosition[wave,Min[wave]][[1]]-8,"Weight"->1|>}],
	For[k=1,k<=Length[ans],k++,
		If[ans[[k]]>0,
		AppendTo[opt,{<|"EventID"->event,"ChannelID"->channel,"PETime"->newfla[[k]],"Weight"->ans[[k]]|>}]]],
	AppendTo[opt,{<|"EventID"->event,"ChannelID"->channel,"PETime"->FirstPosition[wave,Min[wave]][[1]]-8,"Weight"->1|>}];
	];
Print[j]
]

Export["D:\\bigdata\\project-2-pmt-go\\pgan.h5",{"Answer"->opt},"Datasets"]



