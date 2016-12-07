%Function	: metricaMDL {evaluate the Minimum Description Length (MDL) metric}
%Date		   : June 19, 2009
%Author		: Pedro Mayorga
%Email 		: mayorga@cimat.mx

%This function evaluates the population with the K2 metric
%It requires:
% 	binary population $X$ of size(m1,n^2)
%	dataset $D$ with binary observed values of size (m2,n)
%It computes for each $x \in X$, the value of $-\ln(P(G|D))$:
%\begin{eqnarray}
% G \leftarrow Net(x) \\
% P(G|D) = \log P(G) + 
% \sum_{i=1}^{n}{
%    \sum_{j=1}^{q_i}{
%       \sum_{k=1}^{r_i}{
%            N_{ijk}\log\frac{N_{ijk}}{N_{ij}}
%       }
%    }
% }
%-\frac{1}{2}
%   \sum_{i=1}^{n}{
%      q_i(r_i-1)\log(N)
%   }
%\end{eqnarray}


function [f] = metricMDL(varargin)
	%define default values
	defp = struct(...
		'G',rand(4,4)>0.7	,...
		'D',rand(10,4)>0.5   ...
	);
	prop = getopt(defp,varargin{:});									%get the default values
	G = prop.G;																%G is a aciclyc net	
	D = prop.D;																%D is a enuf dataset
	%----------------------------------
	[n,n1] = size(G);
	[m,n2] = size(D);
			
	nparent = sum(G);														%number of parents for each variable
	ncombin = 2.^nparent;												%total combinations for each variable
	
	lnP=0;
	for i=1:n
		pi_id = find(G(:,i)==1)';										%index of parents
		if length(pi_id)==0 												%prevent size [0x1]
			pi_id = [];
		end
		pi_ii = [pi_id,i];												%index of parents and its children
		npi = nparent(i);													%number of parents
		nci = ncombin(i);													%total of instantiations of parents
		for vi = 0 : nci-1
			qi=real2bin(vi,0,2^npi-1,npi);							%a instantiation of the parent set
			qi0 = [qi,0];													%parents with the children=0
			qi1 = [qi,1];													%parents with the children=1
			
			%The first $+1$ is to correct the MDL metric
			Nij0 = 1+sum(sum(D(:,pi_ii)==ones(m,1)*qi0,2)==npi+1);		%Sum for rows, +1 children
			Nij1 = 1+sum(sum(D(:,pi_ii)==ones(m,1)*qi1,2)==npi+1);		%Sum for rows, +1 children
			Nij  = Nij0 + Nij1;			
			
			%MDL metric evaluation
			lnP = lnP + Nij0*log(Nij0/Nij) + Nij1*log(Nij1/Nij);
			
		end 																	%for vi= 0:nci-1
		
		lnP = lnP - 0.5*npi*log(m);
		
	end 																		%for i=1:n
	f=lnP;
end 																			%function

