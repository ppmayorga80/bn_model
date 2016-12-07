function fp=graph_to_dot_cmp(varargin)

    mylabels={
		'(A)\nCAMP',
		'(B)\nGLUCOSE',
		'(C)\nLACTOSE',
		'(D)\nREPRESSOR'
    };        	
		
	defp = struct(...
		'A'        , rand(4,4)>0.7 ,...
		'B'        , rand(4,4)>0.3 ,...
		'labels'   , [] ,...
		'filename' , 'tmp.dot',...
        'width'    , 10,...
        'height'   , 10 ...
	);


	prop = getopt(defp,varargin{:});												%get default and user parameters
	A        = prop.A;
	B        = prop.B;
	labels   = prop.labels;
	filename = prop.filename;
	width = prop.width;
	height = prop.height;
    
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
    
    %find equal arcs and draw with gray color #DDDDDD
    [rows cols] = find(B==A & B==1);
    m = length(rows);
    for i=1:m
       fprintf(fp,'\t%d -> %d [color="#DDDDDD"];\n',rows(i),cols(i));         
    end
    
    %find new arcs and draw with blue color
    [rows cols] = find(B~=A & B==1);
    m = length(rows);
    for i=1:m
       fprintf(fp,'\t%d -> %d [color="#0000FF"];\n',rows(i),cols(i));         
    end
    
    %find deleted arcs and draw with dotted red color
    [rows cols] = find(B~=A & B==0);
    m = length(rows);
    for i=1:m
       fprintf(fp,'\t%d -> %d [style=dotted,color="#FF0000"];\n',rows(i),cols(i));         
    end
    
    fprintf(fp,'}\n');
    fclose(fp);
    
    