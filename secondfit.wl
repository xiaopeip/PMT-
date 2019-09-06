(* ::Package:: *)

BeginPackage["only`"];
opt={};
winstring="./";
yuanru=Import[winstring<>"result/"<>"play-plan.h5","Answer"];
SPE=Import[winstring<>"medium/SPE.h5","SPE"];
spe1=Import[winstring<>"medium/singlewave1.h5","spe"];
aver=Import[winstring<>"medium/average1.h5","averzero"];
spe2=Import[winstring<>"medium/singlewave2.h5","spe"];

evep=yuanru[[1]][[1]];
chap=yuanru[[1]][[2]];
jiedian={1};

length=Length[yuanru];
For[n=1,n<=length,n=n+1,

    If[yuanru[[n]][[1]]!=evep || yuanru[[n]][[2]]!=chap,
        AppendTo[jiedian,n];
        {evep,chap}={yuanru[[n]][[1]],yuanru[[n]][[2]]}];
]

AppendTo[jiedian,n];

For[j=1,j<=7770,j=j+1,
	copy=yuanru[[jiedian[[j]];;jiedian[[j+1]]-1]];
	event=copy[[1,1]];
	channel=copy[[1,2]];
    time=copy[[All,3]];
    weight=copy[[All,4]];
    ipt=Import[winstring<>"data/playground-data.h5","Waveform","TakeElements"->{j}][[1]];
	wave=ipt["Waveform"]-972-aver;
	Assert[event=ipt["EventID"]&&channel=ipt["ChannelID"]];
	
	(*Flatten[weight]//Print;
	Print[time];
	Print[Norm[mne.Flatten[weight]-wave[[nihep]]]];
	Print[Norm[mne2.Flatten[weight]-wave[[nihep]]]];*)
	
	fixed=Position[time,x_/;NumericQ[x]&&FreeQ[time,x+1|x-1|x+2|x-2],1]//Flatten;
	weight[[fixed]]=Round[weight[[fixed]]]+0.;
	
	tire:=Length[weight]-Length[fixed];
	
	If[tire>17,
		fixed=TakeSmallestBy[weight->"Index",Abs[#-Round[#]]&,Length[weight]-17];
		weight[[fixed]]=Round[weight[[fixed]]]+0.;
		];
	(*Print[tire];*)
	
	lowp=Flatten[Position[wave,x_/;x<-6.5]];
	If[lowp!={},(*lowp\:4e3a\:7a7a\:5219\:8df3\:8fc7\:540e\:9762\:7684\:62df\:5408\:6b65\:9aa4*)
	If[lowp[[-1]]>1028,lowp=Drop[lowp,-1]];
	If[lowp[[1]]<2,lowp=Drop[lowp,1]];

	nihep=Union@@Table[lowp+n,{n,-7,15}];
	If[nihep[[-1]]>1029,nihep=Drop[nihep,-(nihep[[-1]]-1029)]];
	If[nihep[[1]]<1,nihep=Drop[nihep,1-nihep[[1]]]];
    
    mne=Table[spe1[[Piecewise[{{x-y+1,x-y+1>0}},x-y+1030]]],{x,nihep},{y,time}];
    mne2=Table[SPE[[Piecewise[{{x-y+1,x-y+1>0}},x-y+1030]]],{x,nihep},{y,time}];
    newfla=Tuples[Union/@Transpose[{Floor[weight],Ceiling[weight]}]];
    (*MinimalBy[newfla,Norm[mne2.#-wave[[nihep]]]&][[1]]//AbsoluteTiming//Print;*)
    ans=MinimalBy[Norm[mne2.#-wave[[nihep]]]&][newfla][[1]];
    (*TimeConstrained[0.5,,weight];*)
	(*Print[weight];
	Print[Norm[mne.ans-wave[[nihep]]]];
	Print[Norm[mne2.ans-wave[[nihep]]]];
	Print[ans];*)
	
    ,ans={}];
    If[AllTrue[ans,#<=0.05&],
	AppendTo[opt,{event,channel,FirstPosition[wave,Min[wave]][[1]]-9,1.}],(*\:5982\:679c\:6ca1\:6709\:5728\:4e0a\:9762\:6b65\:9aa4\:4e2d\:627e\:5230\:7ed3\:679c\:ff0c\:5219\:8f93\:51fa\:7535\:538b\:6700\:5c0f\:503c\:5bf9\:5e94\:7684\:5750\:6807*)
	For[k=1,k<=Length[ans],k++,
		If[ans[[k]]>0.05,
		AppendTo[opt,{event,channel,time[[k]],ans[[k]]}]]],(*\:5c06\:5927\:4e8e0.1\:7684\:7cfb\:6570\:4f5c\:4e3aweight\:8f93\:51fa\:ff0c\:5bf9\:5e94\:7684possible\:4e3aPETime*)
	AppendTo[opt,{event,channel,FirstPosition[wave,Min[wave]][[1]]-9,1.}];
	
	];
    If[Mod[j,100]==0,Print[j]];
 ]

Export[winstring<>"result/play-resu.h5",{"Answer"->opt},"Datasets"];

EndPackage[]







