function GA_bnsearch_experiment

%rand seed to the closest prime to the present: June of 2009.
rand('state',2011);																						


%three independent experiment for K2 metric and MDL score.
n1=1000				
n2=100
n3=10

%-------------------------------------------------------------------------------
%INITIAL POPULATION
	%The BN of CPN model
	C1=[
		0 0 0 0 0 1 1 0 0 0 0 0
		1 0 0 0 0 0 0 0 0 0 0 0
		0 0 0 0 0 0 0 1 0 0 0 0
		0 0 0 0 0 0 0 1 0 0 0 0 
		0 0 0 0 0 1 1 0 0 0 0 0
		0 0 0 0 0 0 0 0 1 0 0 0
		0 0 0 0 0 0 0 0 0 0 0 0
		0 0 0 0 0 0 0 0 0 1 1 0
		0 0 0 0 0 0 0 0 0 1 1 0
		0 0 0 0 0 0 0 0 0 0 0 1
		0 0 0 0 0 0 0 0 0 0 0 0
		0 0 0 0 0 0 0 0 0 0 0 0
	];
	X1 = reshape(C1',1,144);
	
	NARCS = 12;                                                                     %define the average of arc count
	PSIZE = 50;																		%default population size	
	P0 = rand(PSIZE,NARCS^2)>0.85;													%initial random population
	P0(1,:)=zeros(1,NARCS^2);														%force a structure with no arcs
	P0(2,:)= reshape(triu(ones(12,12),1)',[1,144]);								    %force a structure with full conection
	P0(3,:)=X1;																		%force a bayesian network as CPN without transitions
%-------------------------------------------------------------------------------

[x1,f1,a1,c1] = GA_bnsearch('P',P0,'fileout','K2best','fitness','fitnessK2','end_ngen',n1,'display',1);
save -text 'K2best.vars.dat'  x1 f1 a1 c1

[x1,f1,a1,c1] = GA_bnsearch('P',P0,'fileout','K2middle','fitness','fitnessK2','end_ngen',n2,'display',1);
save -text 'K2middle.vars.dat'  x1 f1 a1 c1

[x1,f1,a1,c1] = GA_bnsearch('P',P0,'fileout','K2worst','fitness','fitnessK2','end_ngen',n3,'display',1);
save -text 'K2worst.vars.dat'  x1 f1 a1 c1

%Get the best,midle,worst net using the MDL metric

[x1,f1,a1,c1] = GA_bnsearch('P',P0,'fileout','MDLbest','fitness','fitnessMDL','end_ngen',n1,'display',1);
save -text 'MDLbest.vars.dat'  x1 f1 a1 c1

[x1,f1,a1,c1] = GA_bnsearch('P',P0,'fileout','MDLmiddle','fitness','fitnessMDL','end_ngen',n2,'display',1);
save -text 'MDLmiddle.vars.dat'  x1 f1 a1 c1

[x1,f1,a1,c1] = GA_bnsearch('P',P0,'fileout','MDLworst','fitness','fitnessMDL','end_ngen',n3,'display',1);
save -text 'MDLworst.vars.dat'  x1 f1 a1 c1

