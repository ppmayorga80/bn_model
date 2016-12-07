function displayNet(varargin)
    global dot_prg

	%Default Parameters
	mylabels={																		    %default labels
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
		
	defp = struct(...
		'x'        , round(rand(1,144)) ,...
		'labels'   , [] ,...
		'filename' , 'tmp.png',...
		'display'  , 1,...
		'bsave'    , 1 ...
	);

    %prop.labels=mylabels;

	prop = getopt(defp,varargin{:});												%get default and user parameters
	x        = prop.x;									
	labels   = prop.labels;
	filename = prop.filename;
	display  = prop.display;
    bsave    = prop.bsave;
    
    if(display==0 && bsave==0)  
        return
    end
    
	[m,n]=size(x);                                                              %n must be square
	nnet = round(sqrt(n));
	
	if(m==n)																	%detect if 
		Gi = x;																	%x is a square matrix [n,n]
	else																		%or is a
		Gi = reshape(x,[nnet,nnet])';											%vector [1,n^2]
    end
    Gin = Gi^nnet;
	cyclic = (sum(Gin(:)) ~= 0);											%evaluate if Gi is cyclic

	if(0)
		disp('x = [');															%print the square matrix
		disp(Gi);
		disp(']');
	end
	str1=sprintf('N.Arcs = %d',sum(Gi(:)));
	str2=sprintf('cyclic = %d',cyclic);
    disp(str1);
    disp(str2);

    
	%labels1={'A','B','C','D','E',
	%			 'T','U','V','W','X','Y','Z'};
	
    if exist(dot_prg)    
        file1 = sprintf('%s.dot',filename);											%save the filename in dot format
        file2 = sprintf('%s.eps',filename);											%and in png format
        file3 = sprintf('%s.png',filename);											%and in png format
    
    	cmd2  = sprintf('more %s | %s -Tpng > %s',file1,dot_prg,file3);				    %save command to convert from dot 

    	graph_to_dot('A',Gi,'labels',labels,'filename',file1);			            %Make the dot file
    	system(cmd2);																%Make the png file

    	if display==1
    		img = imread(file3);
    		imshow(img);
    	end
    end

