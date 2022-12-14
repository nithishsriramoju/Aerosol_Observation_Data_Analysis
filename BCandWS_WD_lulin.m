clearvars ;clc;
Filename = ('Met data_Lulin.xlsx');
A = readtable(Filename);
Filename = ('BC Data_Lulin.xlsx');
B = readtable(Filename);
for i = 1:length(B.DM)
    x = B.DM(i);
    l = strcmpi(A.DM,x);
    a(i) = find(l == 1);
end 
[win,~] = find(( A.Mon(a) == 12)|(A.Mon(a) == 1)|(A.Mon(a) == 2));
x = A.WD(win);
y = A.WS(win);
[win1,~] = find(( B.Mon == 12)|(B.Mon == 1)|(B.Mon == 2));
z = B.conc_6_(win1);
figure
[h,c] = ScatterWindRose(x,y,z);
c.Label.String = "[BC]_{880} [ng/m^3]";
c.Label.FontWeight = "bold";
title('WINTER (DJF)');
colormap('jet');

% [spr,~] = find(( A.Mon(a) == 3)|(A.Mon(a) == 4)|(A.Mon(a) == 5));
% x = A.WD(spr);
% y = A.WS(spr);
% [spr1,~] = find(( B.Mon == 3)|(B.Mon == 4)|(B.Mon == 5));
% z = B.conc_6_(spr1);
% figure
% [h,c] = ScatterWindRose(x,y,z);
% colormap('jet');

[sum,~] = find(( A.Mon(a) == 6)|(A.Mon(a) == 7)|(A.Mon(a) == 8));
x = A.WD(sum);
y = A.WS(sum);
[sum1,~] = find(( B.Mon == 6)|(B.Mon == 7)|(B.Mon == 8));
z = B.conc_6_(sum1);
figure
[h,c] = ScatterWindRose(x,y,z);
c.Label.String = "[BC]_{880} [ng/m^3]";
c.Label.FontWeight = "bold";
title('SUMMER (JJA)');
colormap('jet');

[fall,~] = find(( A.Mon(a) == 9)|(A.Mon(a) == 10)|(A.Mon(a) == 11));
x = A.WD(fall);
y = A.WS(fall);
[fall1,~] = find(( B.Mon == 9)|(B.Mon == 10)|(B.Mon == 11));
z = B.conc_6_(fall1);
figure
[h,c] = ScatterWindRose(x,y,z);
c.Label.String = "[BC]_{880} [ng/m^3]";
c.Label.FontWeight = "bold";
title('FALL (SON)');
colormap('jet');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [varargout] =ScatterWindRose(X,Y,varargin)
%%
% [varargout] =ScatterWindRose(X,Y,varargin) creates a scatter polar plot
% with 2 to 3 variables as input
%
%% Input:
% varargin: 1 to 6 inputs :
% #1 Direction ; type: float ; size: [1 x N] in DEGREES
% #2 variable associated to direction (ex: speed); type: float; size: [1 x N]
% #3 limits associated to #2; type: float ; size [1x2] -> if empty variable '[]' is written, the [min(#2),max(#2)] is used
% #4 name of variable #2; type: string;
% #5 variable associated to #2 and #1; type: float; size: [1 x N]
% #6 name of variable #5; type: string;
%
%% Syntax : 
% [hpol] =ScatterWindRose(Dir,U)
% [hpol,c] =ScatterWindRose(Dir,U)
%% OUTPUT
% optionals: 
% varargout{1}: scatter handle
% varargout{2}: colorbar handle
% 
%% Author info
% Author: E. Cheynet, UiB, Norway
% Last modified: 2020-06-25
%% Input parser
% Number of outputs must be >=3 and <=4.
nargoutchk(0,2)
% force columns vectors
X = X(:);    Y=Y(:);
X(X<0)=X(X<0)+360;
[cax,~,~] = axescheck(X);
% options: default values
p = inputParser();
p.CaseSensitive = false;
p.addOptional('Z',[]);
p.addOptional('Ylim',[min(Y),max(Y)]);
p.addOptional('labelZ','');
p.addOptional('labelY','');
p.addOptional('myMarker','+');
p.addOptional('myColor','k');
% p.addOptional('plotType','scatter');
p.parse(varargin{:});
% shorthen the variables name
labelZ = p.Results.labelZ;
labelY = p.Results.labelY;
Z = p.Results.Z(:);
myMarker = p.Results.myMarker;
myColor  = p.Results.myColor;
Ylim = p.Results.Ylim;
% plotType = p.Results.plotType;
%% Check errors
if Ylim(1)>Ylim(2),
    warning('you have specified Ylim(1)>Ylim(2); The two limits are flipped so that Ylim(1)<Ylim(2).');
elseif Ylim(1)==Ylim(2),
    error('you have specified Ylim(1)=Ylim(2). You need to choose Ylim(1)~=Ylim(2).');
end
if isnumeric(labelZ),    error('labelZ must be a string');end
if isnumeric(labelY),    error('labelY must be a string');end
if ischar(X) || ischar(Y)
    error('MATLAB:polar:InvalidInputType', 'Input arguments must be numeric.');
end
if ~isequal(size(X),size(Y))
    error('MATLAB:polar:InvalidInput', 'X and Y must be the same size.');
end
%% Initialisation of figure
% get hold state
cax = newplot(cax);
if ~ishold(cax);
    % make a radial grid
    hold(cax,'on');
    % Get limits
    Ymax = Ylim(2);
    Ymin = Ylim(1);
    % limits from Ymin to Ymax
    X = X(Y>= Ymin & Y<=Ymax);
    % limit from Zmin to Zmax, if variable Z is included
    if ~isempty(Z),
        Z = Z(Y>= Ymin & Y<=Ymax);
    end
    Y = Y(Y>= Ymin & Y<=Ymax);
    
    %% Create circles and radius
    % define a circle
    Ncirc = 4;
    createCircles(Ncirc,Ymax,Ymin,labelY)
    % create radius
    createRadius(Ymax,Ymin)
    % set view to 2-D
    view(cax,2);
    % set axis limits
    axis(cax,(Ymax-Ymin)*[-1 1 -1.15 1.15]);
    setappdata( cax, 'rMin', Ymin );
else
    %Try to find the inner radius of the current axis.
    if (isappdata ( cax, 'rMin' ) )
        Ymin = getappdata(cax, 'rMin' );
    else
        Ymin = 0;
    end
end
%%                  --------------------------
%                         PLOT the data
%                   --------------------------
% transform data to Cartesian coordinates.
xx = (Y - Ymin).*cosd(90-X);
yy = (Y - Ymin).*sind(90-X);
% plot data on top of grid
if ~isempty(Z),
    h = scatter(xx,yy,25,Z,'filled');
    set(h,'MarkerEdgeColor','k')
    c =colorbar;
    set(c,'location','NorthOutside','TickLabelInterpreter','latex');
    title(c,labelZ,'interpreter','latex')
else
    h = plot(xx,yy,[myMarker,myColor]);
end
if nargout == 1
    varargout{1} = h;
elseif nargout == 2
    varargout{1} = h;
    varargout{2} = c;
end
set(cax,'dataaspectratio',[1 1 1]), axis(cax,'off');
set(get(cax,'xlabel'),'visible','on')
set(get(cax,'ylabel'),'visible','on')
set(gcf,'color','w');
uistack(h, 'bottom')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nested functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function createCircles(Ncirc,Ymax,Ymin,labelY)
        theta = linspace(0,360,100);
        xunit = cosd(theta);
        yunit = sind(theta);
        cos_scale = cosd(-20);
        sin_scale = sind(-20);
        % draw radial circles
        for ii = 1:Ncirc
            if ii<Ncirc
                COLOR = [0.5,0.5,0.5];
            else
                COLOR = [0.2 0.2 0.2];
            end
            line(xunit*ii.*(Ymax-Ymin)./Ncirc,...
                yunit*ii.*(Ymax-Ymin)./Ncirc,'color',COLOR,...
                'linestyle','-');
            if ii >= Ncirc,
                text(ii.*(Ymax-Ymin)./Ncirc.*cos_scale,...
                    ii.*(Ymax-Ymin)./Ncirc.*sin_scale, ...
                    [' ',num2str((Ymin+ii.*(Ymax-Ymin)./Ncirc),2),' ',...
                    '   ',...
                    labelY],'verticalalignment','bottom','interpreter','latex');
            else
                text(ii.*(Ymax-Ymin)./Ncirc.*cos_scale,...
                    ii.*(Ymax-Ymin)./Ncirc.*sin_scale, ...
                    [' ',num2str((Ymin+ii.*(Ymax-Ymin)./Ncirc),2)],...
                    'verticalalignment','bottom','interpreter','latex');
            end
        end
    end
    function createRadius(Ymax,Ymin)
        % origin aligned with the NORTH
        thetaLabel = [[90,60,30],[360:-30:120]];
        theta = 0:30:360;
        cs = [-cosd(theta); cosd(theta)];
        sn = [-sind(theta); sind(theta)];
        line((Ymax-Ymin)*cs,(Ymax-Ymin)*sn,'color',[0.5,0.5,0.5],...
            'linestyle','-')
        % annotate spokes in degrees
        rt = 1.1*(Ymax-Ymin);
        for iAngle = 1:numel(thetaLabel),
            if theta(iAngle) ==0,
                text(rt*cosd(theta(iAngle)),rt*sind(theta(iAngle)),'E',...
                    'horizontalalignment','center');
            elseif theta(iAngle) == 90,
                text(rt*cosd(theta(iAngle)),rt*sind(theta(iAngle)),'N',...
                    'horizontalalignment','center');
            elseif theta(iAngle) == 180,
                text(rt*cosd(theta(iAngle)),rt*sind(theta(iAngle)),'W',...
                    'horizontalalignment','center');
            elseif theta(iAngle) == 270,
                text(rt*cosd(theta(iAngle)),rt*sind(theta(iAngle)),'S',...
                    'horizontalalignment','center');
            else
                text(rt*cosd(theta(iAngle)),rt*sind(theta(iAngle)),int2str(abs(thetaLabel(iAngle))),...
                    'horizontalalignment','center');
            end
        end
        
    end
end
