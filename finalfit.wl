(* ::Package:: *)

BeginPackage["only`"];
args=$ScriptCommandLine[[2]];
numargs=ToExpression[args];
winstring="./";
spe1=Import[winstring<>"singlewave1.h5","spe"];
aver=Import[winstring<>"average1.h5","averzero"];
spe2=Import[winstring<>"singlewave2.h5","spe"];
opt={};
defround[x_]:=Piecewise[{{x,x>0.1}},0];

For[j=1000*(numargs-1)+1,j<=Piecewise[{{1796736,numargs==1797}},1000*numargs],j++,
ipt=Import[winstring<>"data/alpha-problem.h5","Waveform","TakeElements"->{j}][[1]];
wave=ipt["Waveform"]-972-aver;
event=ipt["EventID"];
channel=ipt["ChannelID"];

lowp=Flatten[Position[wave,x_/;x<-6.5]];
If[lowp!={},
If[lowp[[-1]]>1028,lowp=Drop[lowp,-1]];
If[lowp[[1]]<2,lowp=Drop[lowp,1]];
nihep=Union@@Table[lowp+n,{n,-7,15}];
If[nihep[[-1]]>1029,nihep=Drop[nihep,-(nihep[[-1]]-1029)]];
If[nihep[[1]]<1,nihep=Drop[nihep,1-nihep[[1]]]];

xuhao=Position[Table[wave[[i+1]]-wave[[i]]-wave[[i-1]]+wave[[i-2]],{i,lowp}],x_/;x>1.6]//Flatten;
newfla=Union[lowp[[xuhao]]-10,lowp[[xuhao]]-9,lowp[[xuhao]]-8];

bianl=Table[b[y],{y,newfla}];
For[restr=bianl[[1]]>=0;i=2,i<=Length[bianl],i=i+1,restr=(restr&&bianl[[i]]>=0)];
mne=Table[spe1[[Piecewise[{{x-y+1,x-y+1>0}},x-y+1030]]],{x,nihep},{y,newfla}];
ans=defround/@TimeConstrained[FindArgMin[{Norm[mne.bianl-wave[[nihep]]],restr},bianl],.25,
TimeConstrained[FindArgMin[{Norm[Table[spe2[[Piecewise[{{x-y+1,x-y+1>0}},x-y+1030]]],{x,nihep},{y,newfla}].bianl-wave[[nihep]]],restr},bianl],.25]
]
];

If[Context[]!="only`",BeginPackage["only`"]];
If[AllTrue[ans,#<=0.05&],
	AppendTo[opt,{event,channel,FirstPosition[wave,Min[wave]][[1]]-9,1.}],
	For[k=1,k<=Length[ans],k++,
		If[ans[[k]]>0.05,
		AppendTo[opt,{event,channel,newfla[[k]]-1,ans[[k]]}]]],
	AppendTo[opt,{event,channel,FirstPosition[wave,Min[wave]][[1]]-9,1.}];
	];
 
If[Mod[j,100]==0,Print[j];Print[Context[]]];
];
Export[winstring<>"jieguo/"<>args<>"-pgan.h5",{"Answer"->opt},"Datasets"];

EndPackage[]




