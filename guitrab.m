function varargout = guitrab(varargin)
% GUITRAB MATLAB code for guitrab.fig
%      GUITRAB, by itself, creates a new GUITRAB or raises the existing
%      singleton*.
%
%      H = GUITRAB returns the handle to a new GUITRAB or the handle to
%      the existing singleton*.
%
%      GUITRAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUITRAB.M with the given input arguments.
%
%      GUITRAB('Property','Value',...) creates a new GUITRAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guitrab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guitrab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guitrab

% Last Modified by GUIDE v2.5 13-Sep-2018 04:44:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guitrab_OpeningFcn, ...
                   'gui_OutputFcn',  @guitrab_OutputFcn, ...
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

% --- Executes just before guitrab is made visible.
function guitrab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guitrab (see VARARGIN)
ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
bg = imread('images/bg.jpg'); imagesc(bg);
set(ah,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');
% Choose default command line output for guitrab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guitrab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guitrab_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

uiwait(msgbox('Escolha um sinal'));
[file,path]=uigetfile;
run(strcat(path,file));
global t;
global signal;
global T;
global linf;
global lsup;
global calc;
global x;
global ak;
global bk;
global ck;
global ok;
ak=0;
bk=0;
ck=0;
ok=0;
calc=0;
t=a(:,1);
signal=a(:,2);
esp = (t(end)-t(1))/length(t);
ac=xcorr(signal,signal); 
[~,locs]=findpeaks(ac); 
T = mean(diff(locs)*esp); 
linf=1;
lsup=2;
while((t(lsup)-t(linf))<T)
    lsup=lsup+1;
end;





% --- Executes on button press in coefcalc.
function coefcalc_Callback(hObject, eventdata, handles)
global t;
global signal;
global T;
global linf;
global lsup;
global x;
global calc;
global ak;
global bk;
global ck;
global ok;
ak=0;
bk=0;
ck=0;
ok=0;
prompt = {'Numero de Harmonicos'};
title = 'Numero de Harmonicos';
n=inputdlg(prompt,title);
n=str2num(n{1});
k=1;
a0=trapz(t(linf:lsup),signal(linf:lsup))/T;
x=a0;
wo=(2*pi/T);
while(k<=n)
    ak(k)=(2/T)*trapz(t(linf:lsup),signal(linf:lsup).*cos(wo*k*t(linf:lsup)));
    bk(k)=(2/T)*trapz(t(linf:lsup),signal(linf:lsup).*sin(wo*k*t(linf:lsup)));
    ck(k)=sqrt(ak(k)^2 + bk(k)^2);
    ok(k)=atan(-bk(k)/ak(k));
    x=x+(ak(k)*cos(wo*k*t))+(bk(k)*sin(wo*k*t));
    k=k+1;
end;
calc=1;
suc=imread('images/suc.jpg');
msgbox('Coeficientes calculados com sucesso!','Coeficientes','custom',suc)






function periodcalc_Callback(hObject, eventdata, handles)

global T;
imperiod=imread('images/period.jpg');
msgbox(sprintf('Periodo = %g s\n',T),'Periodo','custom',imperiod);


function mv_Callback(hObject, eventdata, handles)
global t;
global signal;
global T;
global linf;
global lsup;
a0=trapz(t(linf:lsup),signal(linf:lsup))/T;
average=imread('images/average.jpg');
msgbox(sprintf('Valor Medio(Componente DC)=%g\n',a0),'DC component','custom',average);


% --- Executes on button press in originalgraphic.
function originalgraphic_Callback(hObject, eventdata, handles)
global signal;
global t;
figure;
plot(t,signal);
title('Sinal Original');
xlabel('t');
ylabel('x(t)');

function recgraphic_Callback(hObject, eventdata, handles)
global x;
global t;
global calc;
if calc==1
    figure;
    plot(t,x);
    title('Sinal Reconstruido');
    xlabel('t');
    ylabel('x(t)');
else
    msgbox('Calcule os coeficientes de Fourier primeiro', 'Erro','error');
end

function ampspec_Callback(hObject, eventdata, handles)
global ck;
global calc;
global T;
if calc==1
    figure;
    k=(1:length(ck));
    k=k*(2*pi/T);
    stem(k,ck);
    title('Espectro de amplitude');
    xlabel('kWo');
    ylabel('Ck');
else
    msgbox('Calcule os coeficientes de Fourier primeiro', 'Erro','error');
end

function phasespec_Callback(hObject, eventdata, handles)
global ok;
global calc;
global T;
if calc==1
    figure;
    k=(1:length(ok));
    k=k*(2*pi/T);
    stem(k,ok);
    title('Espectro de amplitude');
    xlabel('kWo');
    ylabel('\thetak');
else
    msgbox('Calcule os coeficientes de Fourier primeiro', 'Erro','error');
end



function tab_Callback(hObject, eventdata, handles)
global ak;
global bk;
global ck;
global ok;
global calc;
if calc==1
   k=(1:length(ak));
   TB=table(k(:),ak(:),bk(:),ck(:),ok(:));
   TB.Properties.VariableNames={'K','ak','bk','ck','ok'};
   figure;
   uitable('Data',TB{:,:},'ColumnName',TB.Properties.VariableNames,...
    'RowName',TB.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);
else
    msgbox('Calcule os coeficientes de Fourier primeiro', 'Erro','error');
end


function comp_Callback(hObject, eventdata, handles)
global t;
global signal;
global T;
global linf;
global lsup;
global x;
global ak;
global bk;
ak=0;
bk=0;
prompt = {'Numero de Harmonicos'};
titulo = 'Numero de Harmonicos';
n=inputdlg(prompt,titulo);
n=str2num(n{1});
k=1;
figure;
a0=trapz(t(linf:lsup),signal(linf:lsup))/T;
x(1:length(t))=a0;
plot(t,x);
title('Sinal composto pela componente DC');
xlabel('t');
ylabel('x(t)');
wo=(2*pi/T);
while(k<=n)
    pause(1)
    ak(k)=(2/T)*trapz(t(linf:lsup),signal(linf:lsup).*cos(wo*k*t(linf:lsup)));
    bk(k)=(2/T)*trapz(t(linf:lsup),signal(linf:lsup).*sin(wo*k*t(linf:lsup)));
    x=x+(ak(k)*cos(wo*k*t))+(bk(k)*sin(wo*k*t)); 
    plot(t,x);
    title(['Sinal composto por ' num2str(k) ' componentes']);
    xlabel('t');
    ylabel('x(t)');
    k=k+1;  
end;



function about_Callback(hObject, eventdata, handles)
fou=imread('images/fourier.jpg');
figure;
imshow(fou);