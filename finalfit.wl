(* ::Package:: *)

BeginPackage["only`"];(*\:9650\:5b9a\:547d\:540d\:7a7a\:95f4\:ff08\:4e0a\:4e0b\:6587\:ff09*)
(*args=$ScriptCommandLine[[2]];numargs=ToExpression[args];\:8bfb\:53d6\:547d\:4ee4\:884c\:53c2\:6570\:ff0c\:5e76\:8f6c\:5316\:4e3a\:6570\:5b57\:7c7b\:578b*)
(*\:8bfb\:5165\:4e4b\:524d\:751f\:6210\:7684\:5355\:5149\:5b50\:66f2\:7ebf\:548c\:57fa\:51c6\:7535\:538b*)
winstring="./";
spe1=Import[winstring<>"medium/singlewave1.h5","spe"];
aver=Import[winstring<>"medium/average1.h5","averzero"];
spe2=Import[winstring<>"medium/singlewave2.h5","spe"];

defround[x_]:=Piecewise[{{x,x>0.06}},0];(*\:5b9a\:4e49\:5c06\:5c0f\:4e8e0.1\:7684\:6570\:53d8\:4e3a0\:ff0c\:5927\:4e8e0.1\:7684\:6570\:4e0d\:53d8\:7684\:51fd\:6570*)
opt={};(*\:521d\:59cb\:5316\:8f93\:51fa*)

For[j=1,j<=7770,j++,(*\:6839\:636e\:547d\:4ee4\:884c\:53c2\:6570\:786e\:5b9a\:5faa\:73af\:8303\:56f4*)
(*\:5f00\:59cb\:5faa\:73af\:ff0c\:8bfb\:5165\:6570\:636e\:5e76\:5c06\:6ce2\:5f62\:51cf\:53bb\:57fa\:51c6\:7535\:538b*)
ipt=Import[winstring<>"data/playground-data.h5","Waveform","TakeElements"->{j}][[1]];
wave=ipt["Waveform"]-972-aver;
event=ipt["EventID"];
channel=ipt["ChannelID"];

(*\:627e\:5230\:4f4e\:4e8e\:9608\:503c\:7535\:538b\:ff08-6.5\:ff09\:7684\:70b9lowp\:5e76\:6390\:5934\:53bb\:5c3e*)
lowp=Flatten[Position[wave,x_/;x<-6.5]];
If[lowp!={},(*lowp\:4e3a\:7a7a\:5219\:8df3\:8fc7\:540e\:9762\:7684\:62df\:5408\:6b65\:9aa4*)
If[lowp[[-1]]>1028,lowp=Drop[lowp,-1]];
If[lowp[[1]]<2,lowp=Drop[lowp,1]];

(*\:627e\:5230\:6240\:6709lowp\:5468\:56f4\:ff08\:5de67\:5230\:53f315\:ff09\:7684\:70b9\:96c6\:ff0c\:5254\:9664\:8d8a\:754c\:7684\:70b9\:ff0c\:4f5c\:4e3a\:53c2\:4e0e\:62df\:5408\:7684\:70b9nihep*)
nihep=Union@@Table[lowp+n,{n,-7,15}];
If[nihep[[-1]]>1029,nihep=Drop[nihep,-(nihep[[-1]]-1029)]];
If[nihep[[1]]<1,nihep=Drop[nihep,1-nihep[[1]]]];

(*\:627e\:5230\:4e8c\:9636\:5bfc\:5927\:4e8e1.5\:70b9\:5411\:524d\:5e73\:79fb9ns\:ff0c\:5e76\:8054\:5408\:5176\:5de6\:53f3\:7684\:70b9\:4f5c\:4e3a\:5bfb\:6839\:7684\:96c6\:5408possible*)
xuhao=Position[Table[wave[[i+1]]-wave[[i]]-wave[[i-1]]+wave[[i-2]],{i,lowp}],x_/;x>1.5]//Flatten;
possible=Union[lowp[[xuhao]]-10,lowp[[xuhao]]-9,lowp[[xuhao]]-8];

bianl=Table[b[y],{y,possible}];(*\:751f\:6210\:62df\:5408\:7cfb\:6570b[n]\:ff0c\:4e0b\:6807n\:5728\:96c6\:5408possible\:4e2d*)
restr=VectorGreaterEqual[{bianl,0}];(*\:751f\:6210\:7ea6\:675f\:8868\:8fbe\:5f0fb[n]>=0*)
mne=Table[spe1[[Piecewise[{{x-y+1,x-y+1>0}},x-y+1030]]],{x,nihep},{y,possible}];(*\:5355\:5149\:5b50\:66f2\:7ebf\:5e73\:79fb\:751f\:6210\:77e9\:9635mne*)

(*\:6c42\:6700\:5c0f\:5747\:65b9\:8ddd\:79bb\:5bf9\:5e94\:7684\:7cfb\:6570b[n]\:ff0c\:9650\:5b9a\:6c42\:89e3\:65f6\:95f4\:4e3a0.25\:79d2\:ff0c\:5c06\:7cfb\:6570\:ff08\:5c0f\:4e8e0.1\:7f6e\:4e3a0\:ff09\:4fdd\:5b58\:5728ans\:4e2d*)
ans=defround/@TimeConstrained[FindArgMin[{Norm[mne.bianl-wave[[nihep]]],restr},bianl],.25,
TimeConstrained[FindArgMin[{Norm[Table[spe2[[Piecewise[{{x-y+1,x-y+1>0}},x-y+1030]]],{x,nihep},{y,possible}].bianl-wave[[nihep]]],restr},bianl],.25]
],ans={}];

(*\:4e0b\:9762\:8f93\:51fa\:7ed3\:679c*)
If[Context[]!="only`",BeginPackage["only`"]];(*\:9632\:6b62\:547d\:540d\:7a7a\:95f4\:88ab\:7be1\:6539*)
If[AllTrue[ans,#<=0.05&],
	AppendTo[opt,{event,channel,FirstPosition[wave,Min[wave]][[1]]-9,1.}],(*\:5982\:679c\:6ca1\:6709\:5728\:4e0a\:9762\:6b65\:9aa4\:4e2d\:627e\:5230\:7ed3\:679c\:ff0c\:5219\:8f93\:51fa\:7535\:538b\:6700\:5c0f\:503c\:5bf9\:5e94\:7684\:5750\:6807*)
	For[k=1,k<=Length[ans],k++,
		If[ans[[k]]>0.05,
		AppendTo[opt,{event,channel,possible[[k]]-1,ans[[k]]}]]],(*\:5c06\:5927\:4e8e0.1\:7684\:7cfb\:6570\:4f5c\:4e3aweight\:8f93\:51fa\:ff0c\:5bf9\:5e94\:7684possible\:4e3aPETime*)
	AppendTo[opt,{event,channel,FirstPosition[wave,Min[wave]][[1]]-9,1.}];
	];
 
If[Mod[j,100]==0,Print[j];Print[Context[]]];(*\:6bcf\:5b8c\:6210100\:4e2a\:6ce2\:5f62\:8fdb\:884c\:4e00\:6b21\:6253\:5370*)
];(*\:7ed3\:675f\:5faa\:73af*)

(*\:8f93\:51fa\:5230\:6587\:4ef6*)
Export[winstring<>"result/play-plan.h5",{"Answer"->opt},"Datasets"];
EndPackage[]




