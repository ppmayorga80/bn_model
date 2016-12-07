function GA_bnsearch_eval

%rand seed to the closest prime to the present: June of 2009.
%rand("state",2011);																						


%three independent experiment for K2 metric and MDL score.


load("-ascii","eval.dat");	
n1=500					%the number or generations
	
X=[
	0 1 1 1 0 0
	0 0 1 1 0 0
	0 0 0 0 0 0
	0 0 0 0 0 0
	0 0 0 0 0 0
	0 0 0 0 0 0
]
	
NARCS = 6;																		%define the average of arc count
PSIZE = 100;																		%default population size	
P0 = rand(PSIZE,NARCS^2)>0.85;													%initial random population
P0(1,:)=zeros(1,NARCS^2);														%force a structure with no arcs
P0(2,:)= reshape(triu(ones(NARCS,NARCS),1)',[1,NARCS^2]);								    %force a structure with full conection
P0(3,:)= reshape(X,[1,NARCS^2]);
%-------------------------------------------------------------------------------

labels={"P1","P2","P3","P4","P5","P6"};

[x1,f1,a1,c1] = GA_bnsearch('Dataset',eval,'labels',labels,'P',P0,'fileout','eval_K2best','fitness','fitnessK2','end_ngen',n1,'display',1);
save -text 'eval_K2best.vars.dat'  x1 f1 a1 c1

[x1,f1,a1,c1] = GA_bnsearch('Dataset',eval,'labels',labels,'P',P0,'fileout','eval_MDLbest','fitness','fitnessMDL','end_ngen',n1,'display',1);
save -text 'eval_MDLbest.vars.dat'  x1 f1 a1 c1

