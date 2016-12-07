%Function	: real2bin {Convert real values in a given interval to binary values with a given length}
%Date		: June 17, 2009
%Author		: Pedro Mayorga
%Email 		: mayorga@cimat.mx

function [b] = real2bin(x,xmin,xmax,n)
	if xmax==xmin; xmax = xmin + 1; end				%make sure the interval is defined

	bmin = 0;												%binary interval
	bmax = 2^n-1;											%[0,2^n)

	z = (x-xmin)/(xmax-xmin)*(bmax-bmin);			%maps z
	b = zeros(1,n);										%create a binary vector
																%to save data
	k=(bmax+1)/2;				
	for i=1:n												%apply the algorithm
		b(i) = floor(z/k);								%to get the binary vector
		z = z - k*b(i);									
		k = k/2;
	end

end
