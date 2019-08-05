(* ::Package:: *)

opt={};

For[j=1,j<=7770,j++,
ipt=Import["D:\\bigdata\\project-2-pmt-go\\data\\playground-data.h5","Waveform","TakeElements"->{j}][[1]];
wave=ipt["Waveform"]-972;
event=ipt["EventID"];
channel=ipt["ChannelID"];

lowp=Flatten[Position[wave,x_/;x<-9.5]];
newfla=lowp-8;
xuhao=Position[Table[wave[[i+1]]-wave[[i]]-wave[[i-1]]+wave[[i-2]],{i,lowp}],x_/;x>3.6]//Flatten;
ans=newfla[[xuhao]];
If[ans=={},
	
	AppendTo[opt,{event,channel,FirstPosition[wave,Min[wave]][[1]]-8,1}],
	For[k=1,k<=Length[ans],k++,
	If[k<Length[k]&&(ans[[k+1]]==ans[[k]]+1),
		AppendTo[opt,{event,channel,ans[[k]],1}];++k,
		AppendTo[opt,{event,channel,ans[[k]]-0.5,1}]]],
	AppendTo[opt,{event,channel,FirstPosition[wave,Min[wave]][[1]]-8,1}];
	];

If[Mod[j,100]==0,Print[j]];
]
Export["D:\\bigdata\\project-2-pmt-go\\playg\\pgan.h5",{"Answer"->opt},"Datasets"]



