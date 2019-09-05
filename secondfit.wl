(* ::Package:: *)

BeginPackage["only`"];
winstring="C:/xiaopeip/PMT-/";
yuanru=Import[winstring<>"result/"<>"play-plan.h5","Answer"];

evep=yuanru[[1]][[1]];
chap=yuanru[[1]][[2]];
jiedian={1};

length=Length[yuanru];


For[n=1,n<=length,n=n+1,

    If[yuanru[[n]][[1]]!=evep || yuanru[[n]][[2]]!=chap,
        AppendTo[jiedian,n];
        {evep,chap}={yuanru[[n]][[1]],yuanru[[n]][[2]]}];
]
Print[jiedian[[1;;10]]] 
AppendTo[jiedian,n];

For[i=1,i<=Length[jiedian]-1,i=i+1,
    time=yuanru[[jiedian[[i]];;jiedian[[i+1]]-1]][[3]];
    weight=yuanru[[jiedian[[i]];;jiedian[[i+1]]-1]][[4]];
    
    mne=Table[spe1[[Piecewise[{{x-y+1,x-y+1>0}},x-y+1030]]],{x,nihep},{y,possible}];
    newfla=Tuples[Transpose[{Floor[weight],Cell[weight]}]];
    MinimalBy[newfla,Norm[mne.#-wave[[nihep]]]&];
    
    If[Mod[i,1000]==0,Print[i]];
    ]







