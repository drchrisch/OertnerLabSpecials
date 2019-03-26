function varargout = OertnerLabSpecials(varargin)
% OERTNERLABSPECIALS MATLAB code for OertnerLabSpecials.fig
%      OERTNERLABSPECIALS, by itself, creates a new OERTNERLABSPECIALS or raises the existing
%      singleton*.
%
%      H = OERTNERLABSPECIALS returns the handle to a new OERTNERLABSPECIALS or the handle to
%      the existing singleton*.
%
%      OERTNERLABSPECIALS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OERTNERLABSPECIALS.M with the given input arguments.
%
%      OERTNERLABSPECIALS('Property','Value',...) creates a new OERTNERLABSPECIALS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OertnerLabSpecials_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OertnerLabSpecials_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OertnerLabSpecials

% Last Modified by GUIDE v2.5 25-Mar-2019 11:58:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @OertnerLabSpecials_OpeningFcn, ...
    'gui_OutputFcn',  @OertnerLabSpecials_OutputFcn, ...
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

% --- Executes just before OertnerLabSpecials is made visible.
function OertnerLabSpecials_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OertnerLabSpecials (see VARARGIN)

movegui(hObject, 'southwest')

% Choose default command line output for OertnerLabSpecials
handles.output = hObject;

% Add OLS data to base workspace as soon as it is constructed!
OLS_init(handles)
OLS_setter('abs', 'absSwitch', 0);
OLS_setter('abs', 'pwr1', 0);
OLS_setter('abs', 'pwr2', 0);

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = OertnerLabSpecials_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global OLS

selection = questdlg(...
    'Close OertnerLabSpecials Figure, sure?',...
    'Close OLS',...
    'Yes','No','No');
switch selection
    case 'Yes'
        % Remove OLS data from base workspace!
        evalin('base', 'clearvars(''global'', ''OLS'')');
        delete(hObject)
    case 'No'
        return
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in abs_radiobutton.
function abs_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to abs_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

OLS_setter('abs', 'absSwitch', hObject.Value);

switch hObject.Value
    case 0
        hObject.FontWeight = 'normal';
        hObject.BackgroundColor = [250 249 250] ./ 255;
    case 1
        hObject.FontWeight = 'bold';
        hObject.BackgroundColor = [0.4 .9 0.4];
end

return

% --- Executes on button press in reset_abs_pushbutton.
function reset_abs_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to reset_abs_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

OLS_setter('abs', 'absSwitch', 0);

handles.abs_radiobutton.Value = 0;
handles.abs_radiobutton.FontWeight = 'normal';
handles.abs_radiobutton.BackgroundColor = [250 249 250] ./ 255;

OLS_setter('abs', 'pwr1', 0);
OLS_setter('abs', 'pwr2', 0);
handles.pwr1_edit.String = '0';
handles.pwr2_edit.String = '0';

return

% --- Executes on button press in help_abs_pushbutton.
function help_abs_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to help_abs_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

helpFile = which('OertnerLabSpecials.pdf');
open(helpFile)

return

function pwr1_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pwr1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pwr1_edit as text
%        str2double(get(hObject,'String')) returns contents of pwr1_edit as a double

pwr = pwr_check(str2double(get(hObject,'String')));
hObject.String = num2str(pwr);
OLS_setter('abs', 'pwr1', pwr);

return

function pwr2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pwr2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pwr2_edit as text
%        str2double(get(hObject,'String')) returns contents of pwr2_edit as a double

pwr = pwr_check(str2double(get(hObject,'String')));
hObject.String = num2str(pwr);
OLS_setter('abs', 'pwr2', pwr);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function OLS_init(handles)

OLS = handles;
OLS.abs = [];
OLS.abs.absSwitch = 0;
OLS.abs.pwr = [0, 0];

OLS.otherCoolStuff = [];

OLSBasename = 'OLS';
assignin('base', OLSBasename, OLS);

return

function OLS_setter(varargin)

OLS_feature = varargin{1};
OLS_params = regexp(varargin{2}, '^\D*|\d*$', 'match');
OLS_value = varargin{3};

OLS = evalin('base', 'OLS');

if eq(numel(OLS_params), 1)
    OLS.(OLS_feature).(OLS_params{1}) = OLS_value;
else
    OLS.(OLS_feature).(OLS_params{1})(str2num(OLS_params{2})) = OLS_value;
end

OLSBasename = 'OLS';
assignin('base', OLSBasename, OLS);

return

function pwr_out = pwr_check(varargin)
% Check power values (eventuallz check for power limit)!

pwr_in = varargin{1};

if ~isnumeric(pwr_in) || isempty(pwr_in) || isnan(pwr_in)
    pwr_out = 0.1;
else
    pwr_out = round(pwr_in, 1);
    if lt(pwr_in, 0.1)
        pwr_out = 0.1;
    end
    if gt(pwr_in, 100)
        pwr_out = 100.0;
    end
end

return
