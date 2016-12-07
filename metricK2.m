%Function	: metricaK2 {evaluate the K2 metric}
%Date			: June 18, 2009
%Author		: Pedro Mayorga
%Email 		: mayorga@cimat.mx

%This function evaluates the population with the K2 metric
%It requires:
% 	binary population $X$ of size(m1,n^2)
%	dataset $D$ with binary observed values of size (m2,n)
%It computes for each $x \in X$, the value of $-\ln(P(G|D))$:
%\begin{eqnarray}
% G \leftarrow Net(x) \\
% P(G|D) \prop \prod_{i=1}^{n}\prod_{j=1}^{q_i} 
%		\frac{\Gamma(N_{ij}')}{\Gamma(N_{ij}'+N_{ij})}
%		\prod_{k=1}^{r_i}
%			\frac{\Gamma(N_{ijk}'+N_{ijk})}{\Gamma(N_{ijk}')}
%\end{eqnarray}
%Where $N_{ijk}'=1, \forall i,j,k$.


function [f] = metricK2(varargin)
	%define default values
	defp = struct(...
		'G',rand(4,4)>0.7	,...
		'D',rand(10,4)>0.5   ...
	);
	prop = getopt(defp,varargin{:});												%get default and user parameters
	G = prop.G;																			%G is a aciclyc net
	D = prop.D;																			%D is a enuf dataset
	%----------------------------------
	[n,n1] = size(G);
	[m,n2] = size(D);
			
	nparent = sum(G);																	%number of parents for each variable
	ncombin = 2.^nparent;															%total combinations for each variable
	
	lnP=0;
	for i=1:n
		pi_id = find(G(:,i)==1)';													%index of parents
		if length(pi_id)==0 															%prevent size [0x1]
			pi_id = [];
		end
		pi_ii = [pi_id,i];															%index of parents and its children
		npi = nparent(i);																%number of parents
		nci = ncombin(i);																%total of instantiations of parents
		for vi = 0 : nci-1
			qi=real2bin(vi,0,2^npi-1,npi);										%a instantiation of the parent set
			qi0 = [qi,0];																%parents with the children=0
			qi1 = [qi,1];																%parents with the children=1
			
			Nij0 = sum(sum(D(:,pi_ii)==ones(m,1)*qi0,2)==npi+1);			%Sum for rows, +1 children
			Nij1 = sum(sum(D(:,pi_ii)==ones(m,1)*qi1,2)==npi+1);			%Sum for rows, +1 children
			
			%K2 metric evaluation in a $log$ form
			lnP = lnP + gammaln(1+Nij0) + gammaln(1+Nij1) - gammaln(2+Nij0+Nij1)  ;
			
		end 																				%for vi= 0:nci-1
		
	end 																					%for i=1:n
	f=lnP;
end 																						%function
