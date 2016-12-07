%Function	: GA_bnsearch {Genetic Algorithm}
%Date			: June 17, 2009
%Author		: Pedro Mayorga
%Email 		: mayorga@cimat.mx

%----------------------------------
% THE GENETIC ALGORITHM, MINIMIZES THE FITNESS FUNCTION
% You must provide the next parameters
% P0        : initial population of size (m,n)
% fitness   : fitness function that computes for all individuals
% pmut      : mutation probability
% nelit     : number of the best individuals remainding through generations
% end_ngen  : ending if the number of generations is achieved
% end_pconv : ending if the population convergence is achieved
    
%The program return the next values
% x		: the best solution found
% f		: the fitness of x
% info	: structure with information
%			info.generations : number of generations executed
% 			info.convergence : population convergence
%			info.evaluations : number of function evaluations in total
%			info.exit_status : the reason of exit {max-generations,convergence}

%CRUZA -> MUTACION -> {EVALUACION} -> SELECCION -> {ELITISMO}

function [ret_x,ret_f,ret_a,ret_con,gen] = GA_bnsearch(varargin)
    global bn_stopGA
																						%default parameters
	
    bayes12 = rand(100,12)>0.5;                                                                                    
	NARCS = 12;																			%define the average of arc count
	SIGMA = 0.75;																		%deviation of narcs for penalization

	P0 = rand(10,NARCS^2)>0.85;  													%initial random population
		
	labels={																		    %default labels
		'(A)\nCAMP',
		'(B)\nGLUCOSE',
		'(C)\nLACTOSE',
		'(D)\nREPRESSOR',
		'(E)\nCAP',
		'(T)\nCOMPLEX\nCAMP-CAP',
		'(U)\nNO COMPLEX\nFORMED',
		'(V)\nOPERATOR',
		'(W)\nCAP-SITE',
		'(X)\nPROMOTER',
		'(Y)\nOPERATOR BINDING\nby a REPRESSOR',
		'(Z)\nGENE\nTRANSCRIPTION'};
																								
	defp = struct(...																%Default Parameters
		'labels'      , []   ,...													%labels, defined bellow
		'fileout'     , 'tmp',...													%output filename
		'display'     , 1    ,...													%whether is displayer or not
		'P'           , P0   ,...													%initial population
		'fitness'     , 'fitnessMDL' ,...										    %fitness function
		'Dataset'     , bayes12     ,...											%dataset
		'NARCS'       , NARCS    ,...												%arcs number
		'SIGMA'       , SIGMA    ,...												%arcs number deviation
		'pcross'      , 0.95     ,...												%cross probability
		'pmut'        , 0.50     ,...												%mutation probability
		'nelit'       , 5        ,...												%number of individiduals to make elitism
		'end_ngen'    , 10       ,...												%max number of generations
		'end_pconv'   , 0.95     ,...  												%percentage of population convergence
        'axes_fitness',[],...
        'axes_graph',[],...
        'axes_progress1',[],...
        'axes_progress2',[],...
        'edit_fitness1',[] ...
	);

	prop = getopt(defp,varargin{:});												%get default or user defined paremeters

	if isempty(prop.labels)															%set default label names
		%take the default values
	else
		labels = prop.labels;
	end

	fileout   = prop.fileout;
	display   = prop.display;
	
	fitness   = prop.fitness;
	D         = prop.Dataset;
	NARCS     = prop.NARCS;
	SIGMA     = prop.SIGMA;
	pcross    = prop.pcross;
	pmut	  = prop.pmut;
	nelit	  = prop.nelit;
	end_ngen  = prop.end_ngen;
	end_pconv = prop.end_pconv;
	
    axes_fitness = prop.axes_fitness;
    axes_graph = prop.axes_graph;
    axes_progress1 = prop.axes_progress1;
    axes_progress2 = prop.axes_progress2;
    edit_fitness1 = prop.edit_fitness1;
    
	
	[m,n] = size(prop.P);														%get size of population
	m12 = round(m*1/2);															%set 1/2 of population
	m13 = round(m*1/3);															%set 1/3 of population
	
	x = zeros(end_ngen+1,n);													%array of the best individuals in each generation
	f = zeros(end_ngen+1,1);			    									%and the fitness associated
    a = zeros(end_ngen+1,1);
    con = zeros(end_ngen+1,1);
    
	P = prop.P; 																%Every iteration, $P$ is initialized
		
	disp('Executing : Fitness function...');
	Pfun   = feval(fitness,'X',P,'D',D,'NARCS',NARCS,'SIGMA',SIGMA,...
        'axes_progress',axes_progress2);                            		    %fitness evaluation
		
	disp('Executing : Sorting population...');
	A = sortrows([P,Pfun],n+1);													%sorting by fitness and take:
	A0 = A((1    ):m12 , : );													%the 1/2 top
	A1 = A((m12+1):m   , : );													%the 1/3 bottom

    x(1,:) = A(1,1:n);                                                          %best individual at t=1
    f(1)   = A(1,n+1);                                                          %best fitness value
    a(1)   = sum(A(1,1:n));                                                      %number of arcs of the best
    con(1) = mean(P(:));
    nfun   = m;
    		
	for gen=1:end_ngen  														%starting a new iteration
	    
        if bn_stopGA
            disp('Stopping GA...')
            break
        end
        
		disp('Executing : Cross operator...');
		B0 = GA_CrossOperator(A0,pcross,m13);	   								%Cross the best and get 1/3 of the offspring
		B1 = GA_CrossOperator(A1,pcross,m13);     								%Cross the worst and get 1/3 of the offspring
		B2 = GA_CrossOperator(A ,pcross,m-2*m13);  								%Cross all population and get 1/3 of the offspring
		B  = [B0;B1;B2];														%Concatenate all offspring
			
		disp('Executing : Mutation operator...');
		C = GA_MutationOperator(B,pmut);										%Apply the Mutation Operator ...
		disp('Executing : Fitness function...');
		Cfun = feval(fitness,'X',C,'D',D,'NARCS',NARCS,'SIGMA',SIGMA,...
            'axes_progress',axes_progress2);                        		    %and Evaluate the Fitness
			
		nfun = nfun + m;							                            %update the info structure
	
		Q = [C,Cfun];															%form a matrix for sorting ...
		
		disp('Executing : Selection process...');
		E = A(1:nelit,:);														%Elitism
		S = sortrows( [E;Q] , n+1 );											%Selection
	
		P = S(1:m,1:n);															%population of next generation
		Pfun = S(1:m,n+1);														%fitness    of next generation

        x(gen+1,:)=P(1,:);
        f(gen+1)=Pfun(1);   													%save the best solution
        a(gen+1)=sum(P(1,:));   												%and the arcs

                                                                                %display fitness plot
        if ~isempty(axes_fitness)
            axes(axes_fitness)
        else
            figure(1); 
        end
        nw=20;
        g1 = floor((gen+1)/nw)*nw;
        g2 = gen;
        if g1>0
            g1 = gen-nw+1;
        end
        plot(g1:g2,f(g1+1:g2+1))
        xlim([g1 g2])
        grid on
        %drawnow

		str=sprintf('Gen [%d/%6d]: f = %f\t',gen,end_ngen,Pfun(1));				%Print messages
        disp(str);
        if ~isempty(edit_fitness1)
           set(edit_fitness1,'String',sprintf('%f',Pfun(1))); 
        end
        if  ~isempty(axes_progress1)
            myprogressbar('axesname',axes_progress1,'v',gen/end_ngen,'legend1','Generations')
        end
        
        
                
        if  ~isempty(axes_fitness)
            axes(axes_graph)
        else
            figure(2); 
        end
		displayNet('x',P(1,:),'labels',labels,'filename',fileout,'display',display);    %display net
		
		%----------------------------------------------------------
		disp('Executing : Sorting population...');
		A = [P,Pfun];           													    %sorting by fitness and
		A0 = A((1    ):m12 , : );														%take the 1/2 from top and
		A1 = A((m12+1):m   , : );														%take the 1/3 from bottom
				
		con(gen+1)=mean(P(:));											            %save info structure
		if con(gen+1)>end_pconv
			break
		end
		
	end
	

	if nargout==0
		x;
		f;
		a;
		con;
	end
	if nargout>=1; ret_x = x;	end														%return output parameters
	if nargout>=2; ret_f = f;	end														
	if nargout>=3; ret_a = a;	end
	if nargout>=4; ret_con = con;	end

end %function GA

function B = GA_CrossOperator(A,pc,k)
%Apply the Cross operator over Population with Fitness column A( 1:m , 1:n+1 )
%with cross probability pc
%and Return $k$ offsprings
	
	[m,np1] = size(A);
	n = np1-1;
	k_2 = ceil(k/2);																			%number of crosses
	knw = 2*k_2;
	
	B = zeros(knw,n);																			%Cross output
	
	kp1 = unidrnd(m,[k_2,1]);                                                        	%fathers op1
	kp2 = unidrnd(m,[k_2,1]);                                                            %fathers op2
	km1 = unidrnd(m,[k_2,1]);                     										%mothers op1
	km2 = unidrnd(m,[k_2,1]);                                                          	%mothers op2
	
   %k3 = discrete_rnd(k_2,1:(n-1),ones(1,n-1)./(n-1)); 							        %cross point
	k3 = unidrnd(n-1,[k_2,1]);                           						        %cross point
	pu = rand(1,k_2);																	%crossing probability

	j=0;
	for i=1:k_2																			%for i=1,3,5,...
		fp1 = A(kp1(i),n+1);															%fitness of candidate 1 to be father
		fp2 = A(kp2(i),n+1);															%fitness of candidate 2 to be father
		if fp1 < fp2 																	%select the best to be father
			father = A(kp1(i),1:n);						
		else
			father = A(kp2(i),1:n);
		end
		
		fm1 = A(km1(i),n+1);															%fitness of candidate 1 to be mother
		fm2 = A(km2(i),n+1);															%fitness of candidate 2 to be mother
		if fm1 < fm2 																	%select the best to be mother
			mother = A(km1(i),1:n);
		else
			mother = A(km2(i),1:n);
		end

		if pu(i) < pc																	%if we can apply the cross operator
			son1 = [ father(1:k3(i)) , mother(k3(i)+1:n) ];							    %1 point crossover 
			son2 = [ mother(1:k3(i)) , father(k3(i)+1:n) ];							
		else
			son1 = father;																		
			son2 = mother;
		end
		B(j+1,:) = son1;																%save the two offspring
		B(j+2,:) = son2;
		j = j+2;
	end
	
	B = B(1:k,:);
	
end	
	
function C = GA_MutationOperator(B,pmut)
%Apply the Mutation operator over Population A without Fitness column
%Return Mutated offspring 
	[m,n] = size(B);
	
	C=B;
	p = rand(m,1);
	%k = discrete_rnd(m,1:n,ones(1,n)./n); 												%mutation point
	k = unidrnd(n,[m,1]); 												%mutation point
	for i=1:m																			%for all individuals
		if p(i)<pmut																	%if we can mutate
			C(i,k(i)) = C(i,k(i)) == 0;													%change the $k^{th}$ bit
		end
	end		
end

