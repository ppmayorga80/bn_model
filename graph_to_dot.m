function fp=graph_to_dot(varargin)

    mylabels={
		'(A)\nCAMP',
		'(B)\nGLUCOSE',
		'(C)\nLACTOSE',
		'(D)\nREPRESSOR'
    };        	
		
	defp = struct(...
		'A'        , rand(4,4)>0.7 ,...
		'labels'   , [] ,...
		'filename' , 'tmp.dot',...
        'width'    , 4,...
        'height'   , 4,...
        'weights'  , []...
	);


	prop = getopt(defp,varargin{:});												%get default and user parameters
	A        = prop.A;
	labels   = prop.labels;
	filename = prop.filename;
	width    = prop.width;
	height   = prop.height;
	W        = prop.weights;
    
    if isempty(labels)
        labels = mylabels;
    end

    %=====================================================================
    
    fp = fopen(filename,'w');
    if fp==-1
       return 
    end
    
    [n n]=size(A);
    
    fprintf(fp,'digraph G {\n');
    fprintf(fp,'\tcenter=1;\n');
    fprintf(fp,'\tsize="%d,%d";\n',width,height);    
    
    for i=1:n
       fprintf(fp,'\t%d [label = "%s"];\n',i,labels{i}); 
    end
    
    if isempty(W)==1
        %find arcs
        [rows cols] = find(A==1);
        m = length(rows);
        for i=1:m
           fprintf(fp,'\t%d -> %d;\n',rows(i),cols(i));         
        end
    else        
        C=abs(W);
        z1=min(C(:));
        z2=max(C(:));
        dz=z2-z1;
        if z2-z1<1.0E-6,dz=1.0,end;
        
        [rows cols] = find(A==1);
        m = length(rows);
        for i=1:m
           r=rows(i);
           c=cols(i);
           x = C(r,c);
           y = W(r,c);
           p = (x-z1)/dz*9+1;
           if y>0 color='#0000FF';
           else   color='#FF0000';
           end
           
           fprintf(fp,'\t%d -> %d [label="%3.1f",penwidth=%d,color="%s"];\n',r,c,y,round(p),color);
        end
        
    end
    
    fprintf(fp,'}\n');
    fclose(fp);
    
    