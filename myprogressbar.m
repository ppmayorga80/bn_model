function myprogressbar(varargin)
	defp = struct(...
		'axesname', []   ,...
        'width'   , 1.0  ,...
        'height'  , 0.1  ,...
        'v'       , 0.5  ,...
		'fgcolor' , 'r'  ,...
		'bgcolor' , 'w'  ,...
		'legend1' , ''   ,...
		'legend2' , '%' ...
	);

	prop = getopt(defp,varargin{:});
	axesname = prop.axesname;
	width    = prop.width;
	height   = prop.height;
	v        = prop.v;
	fgcolor  = prop.fgcolor;
	bgcolor  = prop.bgcolor;
    legend1  = prop.legend1;
    legend2  = prop.legend2;

    if isempty(axesname)
        figure(1)
    else
        axes(axesname)
    end
    
    str = sprintf('%s %5.1f %s',legend1,v*100,legend2)
    
    cla
    axis off
    daspect([ 1 1 1 ])
    axis([0 width 0 height])
    
    %text(width/2,height/2,str,'HorizontalAlignment','center','EraseMode','xor')
    text(width/2,height/2,str,'HorizontalAlignment','center')
    
    rectangle('Position',[0 0 width height],'FaceColor',bgcolor)
    rectangle('Position',[0 0 v height],'FaceColor',fgcolor,'EdgeColor','None')
    drawnow