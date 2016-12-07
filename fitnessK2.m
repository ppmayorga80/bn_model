%Function	: populationMetricaK2 {evaluate the K2 metric over a population of vectors}
%Date		   : June 18, 2009
%Author		: Pedro Mayorga
%Email 		: mayorga@cimat.mx

function [f] = fitnessK2(varargin)

	%define default values
	defp = struct(...
		'X',rand(3,16)>0.7	,...
		'D',rand(10,4)>0.5  ,...
		'NARCS',4           ,...
		'SIGMA',0.25        ,...
        'axes_progress',[]  ...        
	);
	prop = getopt(defp,varargin{:});												%get default and user parameters
	P = prop.X;
	D = prop.D;
	NARCS = prop.NARCS;
	SIGMA = prop.SIGMA;
    
    axes_progress = prop.axes_progress;
    
	%----------------------------------
	[m,n] = size(P);																	%n must be a square
	nnet  = round(sqrt(n));															%nnet size of square matrix
	
	f = zeros(m,1);																	%initialize the fitness vector

    if isempty(axes_progress)
        for i=1:m        
    		percent=i/m*100;																%print the total amount of progress
    		str=sprintf('\rFitness progress : %4.1f %%',percent);
            disp(str);
        	
    		Gi = reshape(P(i,:),[nnet,nnet])';										%extract the $i^{th}$ structure
            Gin = Gi^nnet
    		cyclic = sum(Gin(:));												%verify if the structure is cylic
    		n_arcs = sum(Gi(:));															%counts the arcs number
		
    		pen_cyclic = ( m * n ) * (cyclic)^2 ;									%penalization if cyclic
        	pen_narcs  = ( m * n ) * (n_arcs - NARCS)^2/SIGMA^2 ;				%penalization if NARCS is not the average
    		f(i,1) = -metricK2('G',Gi,'D',D) + pen_cyclic + pen_narcs ;		%evalutes the K2 metric with penalization
        	%f(i,1) = -metricK2('G',Gi,'D',D) + pen_cyclic;						
        end
    else
        for i=1:m        
            
            myprogressbar('axesname',axes_progress,'v',i/m,'legend1','Fitness')
            
    		Gi = reshape(P(i,:),[nnet,nnet])';										%extract the $i^{th}$ structure
            Gin = Gi^nnet
    		cyclic = sum(Gin(:));												%verify if the structure is cylic
    		n_arcs = sum(Gi(:));															%counts the arcs number
		
    		pen_cyclic = ( m * n ) * (cyclic)^2 ;									%penalization if cyclic
        	pen_narcs  = ( m * n ) * (n_arcs - NARCS)^2/SIGMA^2 ;				%penalization if NARCS is not the average
    		f(i,1) = -metricK2('G',Gi,'D',D) + pen_cyclic + pen_narcs ;		%evalutes the K2 metric with penalization
        	%f(i,1) = -metricK2('G',Gi,'D',D) + pen_cyclic;						
        end        
	end
	disp('Fitness progress : Done!..');
	
end

