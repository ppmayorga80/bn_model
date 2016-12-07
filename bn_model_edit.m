function varargout = bn_model_edit(varargin)
% BN_MODEL_EDIT MATLAB code for bn_model_edit.fig
%      BN_MODEL_EDIT, by itself, creates a new BN_MODEL_EDIT or raises the existing
%      singleton*.
%
%      H = BN_MODEL_EDIT returns the handle to a new BN_MODEL_EDIT or the handle to
%      the existing singleton*.
%
%      BN_MODEL_EDIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BN_MODEL_EDIT.M with the given input arguments.
%
%      BN_MODEL_EDIT('Property','Value',...) creates a new BN_MODEL_EDIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bn_model_edit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bn_model_edit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bn_model_edit

% Last Modified by GUIDE v2.5 31-Aug-2012 15:11:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bn_model_edit_OpeningFcn, ...
                   'gui_OutputFcn',  @bn_model_edit_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before bn_model_edit is made visible.
function bn_model_edit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bn_model_edit (see VARARGIN)

% Choose default command line output for bn_model_edit
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bn_model_edit wait for user response (see UIRESUME)
% uiwait(handles.figure1);
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg
    
    %if bn_matrix is set become active
    n = length(bn_nodenames);
    if isempty(bn_matrix)
        bn_matrix = logical(zeros(n,n) );
    end
    bn_matrix = logical(bn_matrix);
    
    set(handles.uitable1,'Data',bn_matrix);
    set(handles.uitable1,'RowName',bn_nodeshortnames);
    set(handles.uitable1,'ColumnName',bn_nodeshortnames);
    set(handles.uitable1,'ColumnEditable',logical(ones(1,n)));
    
    update_gui(handles)
    
% --- Outputs from this function are returned to the command line.
function varargout = bn_model_edit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    p1 = get(hObject,'Position')
    p2 = get(handles.uipanel1,'Position');

    q2 = [0 0 p1(3) p2(4)];
    set(handles.uipanel1,'Position',q2);

    h = p1(4)-p2(4);
    q3 = [0 p2(4) p1(3) h];
    set(handles.uitable1,'Position',q3);
    


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
    update_gui(handles)

function update_gui(handles)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg
    
    A=logical(bn_matrix);
    B=get(handles.uitable1,'Data');

    [n n] = size(A);
    
    %Evaluate Fitness
    A_K2 = fitnessK2(...
        'X',reshape(A',1,n^2),...
        'D',bn_dataset,...
        'NARCS',n,...
        'SIGMA',0.75);
    A_MDL = fitnessMDL(...
        'X',reshape(A',1,n^2),...
        'D',bn_dataset,...
        'NARCS',n,...
        'SIGMA',0.75);
    B_K2 = fitnessK2(...
        'X',reshape(B',1,n^2),...
        'D',bn_dataset,...
        'NARCS',n,...
        'SIGMA',0.75);
    B_MDL = fitnessMDL(...
        'X',reshape(B',1,n^2),...
        'D',bn_dataset,...
        'NARCS',n,...
        'SIGMA',0.75);
        
    set(handles.edit1,'String',sprintf('%f',A_K2));
    set(handles.edit3,'String',sprintf('%f',A_MDL));
    set(handles.edit2,'String',sprintf('%f',B_K2));
    set(handles.edit4,'String',sprintf('%f',B_MDL));
    
    %Show Status:
    if B_K2 < A_K2
        set(handles.text7,'String','the new K2 is better');        
    else
        set(handles.text7,'String','the new K2 is worse');                
    end
    if B_MDL < A_MDL
        set(handles.text8,'String','the new MDL is better');        
    else
        set(handles.text8,'String','the new MDL is worse');                
    end
    
    %Draw nets
    dot_file = 'tmp2.dot';
    png_file = 'tmp2.png';
    graph_to_dot_cmp(...
        'labels'  ,bn_nodenames,...
        'A'       ,A,...
        'B'       ,B,...
        'filename',dot_file,...
        'width'   ,20,...
        'height'  ,20 ...
    );

    cmd = sprintf('cat %s | %s -Tpng > %s',dot_file,dot_prg,png_file);
    system(cmd);
    
    I=imread(png_file);
    figure(1)
    imshow(I)

    %Draw nets
    dot_file = 'tmp3.dot';
    png_file = 'tmp3.png';
    graph_to_dot(...
        'labels'  ,bn_nodenames,...
        'A'       ,B,...
        'filename',dot_file,...
        'weights' ,corrcoef(bn_dataset),...
        'width'   ,20,...
        'height'  ,20 ...
        );

    cmd = sprintf('cat %s | %s -Tpng > %s',dot_file,dot_prg,png_file);
    system(cmd);
    
    I=imread(png_file);
    figure(2)
    imshow(I)
        
    
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function OpenG2_Callback(hObject, eventdata, handles)
% hObject    handle to OpenG2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg

    [filename,pathname] = uigetfile('*.mat','Open Network','bn_network test1.mat');
    if ~filename, return, end
    
    fullfilename=fullfile(pathname,filename);
    load(fullfilename);
    
    if ~exist('bn_nodenames1','var')
       wait(errordlg('The File does not contains a Network','Open Network'))        
       return 
    end
    if length(bn_nodenames)~=length(bn_nodenames1)
       wait(errordlg('The Open Network does not contain the same number of Random Variables','Open Network'))        
       return
    end

    B = logical(bn_matrix1);
    set(handles.uitable1,'Data',B);
    
    update_gui(handles)
    
% --------------------------------------------------------------------
function Best2G2_Callback(hObject, eventdata, handles)
% hObject    handle to Best2G2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg

    B = logical(bn_matrix);
    set(handles.uitable1,'Data',B);

    update_gui(handles)

% --------------------------------------------------------------------
function File1_Callback(hObject, eventdata, handles)
% hObject    handle to File1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SaveG2_Callback(hObject, eventdata, handles)
% hObject    handle to SaveG2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg

    [filename,pathname] = uiputfile('*.mat','Save Network','bn_network test1.mat');
    if ~filename, return, end

    bn_matrix1 = get(handles.uitable1,'Data');
    bn_nodenames1 = bn_nodenames;
    
    fullfilename=fullfile(pathname,filename);
    save(fullfilename,'bn_matrix1','bn_nodenames1');    


% --------------------------------------------------------------------
function ExportG2_Callback(hObject, eventdata, handles)
% hObject    handle to ExportG2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg

    [filename,pathname,filterIdx] = uiputfile(...
        {'*.pdf','PDF files (*.pdf)';
         '*.eps','Encapsulated PostScript (*.eps)';
         '*.png','PNG files (*.png)';
         '*.tif','Tiff files (*.tif)';
         },...
         'Save Network','bn_network test1.pdf');
    if ~filename, return, end
    fullfilename=fullfile(pathname,filename);

    filter={'pdf','eps','png' ,'tif'};
    sizes =[20 20; 4 4 ; 20 20;20 20]
    
    bn_matrix1 = get(handles.uitable1,'Data');
    dot_file = 'tmp3.dot';
    graph_to_dot(...
        'A'       ,bn_matrix1,...
        'labels'  ,bn_nodenames,...
        'filename',dot_file,...
        'width'   ,sizes(filterIdx,1),...
        'height'  ,sizes(filterIdx,2)...
        );

    cmd = sprintf('more %s | %s -T%s > "%s"',dot_file,dot_prg,filter{filterIdx},fullfilename);
    system(cmd);


% --------------------------------------------------------------------
function ExportG2W_Callback(hObject, eventdata, handles)
% hObject    handle to ExportG2W (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg

    [filename,pathname,filterIdx] = uiputfile(...
        {'*.pdf','PDF files (*.pdf)';
         '*.eps','Encapsulated PostScript (*.eps)';
         '*.png','PNG files (*.png)';
         '*.tif','Tiff files (*.tif)';
         },...
         'Save Network','bn_network test1.pdf');
    if ~filename, return, end
    fullfilename=fullfile(pathname,filename);

    filter={'pdf','eps','png' ,'tif'};
    sizes =[20 20; 4 4 ; 20 20;20 20]
    
    bn_matrix1 = get(handles.uitable1,'Data');
    dot_file = 'tmp3.dot';
    graph_to_dot(...
        'A'       ,bn_matrix1,...
        'labels'  ,bn_nodenames,...
        'filename',dot_file,...
        'width'   ,sizes(filterIdx,1),...
        'height'  ,sizes(filterIdx,2),...
        'weights' ,corrcoef(bn_dataset)...
        );

    cmd = sprintf('more %s | %s -T%s > "%s"',dot_file,dot_prg,filter{filterIdx},fullfilename);
    system(cmd);



% --------------------------------------------------------------------
function OpenG1_Callback(hObject, eventdata, handles)
% hObject    handle to OpenG1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg

    [filename,pathname] = uigetfile('*.mat','Open Network','bn_network test1.mat');
    if ~filename, return, end
    
    fullfilename=fullfile(pathname,filename);
    load(fullfilename);
    
    if ~exist('bn_nodenames1','var')
       wait(errordlg('The File does not contains a Network','Open Network'))        
       return 
    end
    if length(bn_nodenames)~=length(bn_nodenames1)
       wait(errordlg('The Open Network does not contain the same number of Random Variables','Open Network'))        
       return
    end

    B = logical(bn_matrix1);
    bn_matrix = B;
    set(handles.uitable1,'Data',B);
    
    update_gui(handles)

    
