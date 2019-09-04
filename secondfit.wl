(* ::Package:: *)

BeginPackage["only`"];
winstring="./";
yuanru=Import[winstring<>"result/"<>"play-plan.h5"];

evep=yuanru[[1]][[1]];
chap=yuanru[[1]][[2]];
jiedian={1};

length=Length[yuanru];
For[n=1,n<=length,n=n+1,
    If[yuanru[[n]][[1]]!=evep Or yuanru[[n]][[2]]!=chap,
        AppendTo[jiedian,n];
        {evep,chap}={yuanru[[n]][[1]],yuanru[[n]][[2]]}];
]

AppendTo[jiedian,n];

For[i=1,i<=Length[jiedian]-1,i=i+1,
    copy=yuanru[[jiedian[[i]];;jiedian[[i+1]]-1]];
    (*For[j=1,j<=Length[copy],j=j+1,
        ];*)
    If[Mod[i,1000]==0,Print[i]];
    ]

