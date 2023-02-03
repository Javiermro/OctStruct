function PlotApoyos(x0,y0,esc,type,ang)
global nelem nnodo ndime ndofs npoin nfixe nload

% if type == 'ASyy'
% % Apoyo simple y-y
% esc = 0.7*esc ;
% hold on
% x = [-0.5 0.5 0 -0.5]';
% y = [-sind(60) -sind(60) 0 -sind(60)]' ;
% x1=[-0.5 0.5] ; y1 = 1.3*[-sind(60) -sind(60)] ;
% plot([x0+esc*x],[y0+esc*y],'-k','LineWidth',2)
% plot([x0+esc*x1],[y0+esc*y1],'-k','LineWidth',2)
% hold off

if type == 'ASxx'
% Apoyo simple x-x
esc = 0.7*esc ;
hold on
x = [-0.5 0.5 0 -0.5]';
y = [-sind(60) -sind(60) 0 -sind(60)]' ;
x1=[-0.5 0.5] ; y1 = 1.3*[-sind(60) -sind(60)] ;
tita  = 90   ;     
R = [cosd(tita) sind(tita) ; -sind(tita) cosd(tita) ] ;
xy = R*[x y]' ;
x=xy(1,:)' ; y=xy(2,:)' ;
xy1 = R*[x1' y1']' ;
x1=xy1(1,:)' ; y1=xy1(2,:)' ;
plot([x0+esc*x],[y0+esc*y],'-k','LineWidth',2)
plot([x0+esc*x1],[y0+esc*y1],'-k','LineWidth',2)
hold off


elseif type == 'ASyy'
% Apoyo simple y-y
esc = 0.7*esc ;
hold on
x = [-0.5 0.5 0 -0.5]';
y = [-sind(60) -sind(60) 0 -sind(60)]' ;
x1=[-0.5 0.5] ; y1 = 1.3*[-sind(60) -sind(60)] ;
tita  = 90   ;     
R = [cosd(tita) sind(tita) ; -sind(tita) cosd(tita) ] ;
xy = R*[x y]' ;
x=xy(1,:)' ; y=xy(2,:)' ;
xy1 = R*[x1' y1']' ;
x1=xy1(1,:)' ; y1=xy1(2,:)' ;
plot([x0+esc*x],[y0+esc*y],'-k','LineWidth',2)
plot([x0+esc*x1],[y0+esc*y1],'-k','LineWidth',2)
hold off


elseif type == 'ADob'
% Apoyo doble
esc = 0.7*esc ;
hold on
x = [-0.5 0.5 0 -0.5]';
y = [-sind(60) -sind(60) 0 -sind(60)]' ;
x1=[-0.5 -0.3] ; y1 = [-0.2-sind(60) -sind(60)] ;
x2=[-0.3 -0.1] ; y2 = [-0.2-sind(60) -sind(60)] ;
x3=[-0.1  0.1] ; y3 = [-0.2-sind(60) -sind(60)] ;
x4=[ 0.1  0.3] ; y4 = [-0.2-sind(60) -sind(60)] ;
x5=[ 0.3  0.5] ; y5 = [-0.2-sind(60) -sind(60)] ;
plot([x0+esc*x],[y0+esc*y],'-k','LineWidth',2)
plot([x0+esc*x1],[y0+esc*y1],'-k','LineWidth',2)
plot([x0+esc*x2],[y0+esc*y2],'-k','LineWidth',2)
plot([x0+esc*x3],[y0+esc*y3],'-k','LineWidth',2)
plot([x0+esc*x4],[y0+esc*y4],'-k','LineWidth',2)
plot([x0+esc*x5],[y0+esc*y5],'-k','LineWidth',2)
hold off


elseif type == 'Empo'
% Empotramiento
hold on
ang=ang-180;
x = [-0.5 0.5 ]' ; y  = [ 0   0]' ;
x1= [-0.5 -0.3]  ; y1 = [-0.2 0] ;
x2= [-0.3 -0.1]  ; y2 = y1 ; 
x3= [-0.1  0.1]  ; y3 = y1 ;
x4= [ 0.1  0.3]  ; y4 = y1 ;
x5= [ 0.3  0.5]  ; y5 = y1 ;
R = [cosd(ang) sind(ang) ; -sind(ang) cosd(ang) ] ;
xy = R*[x y]' ;
x=xy(1,:)' ; y=xy(2,:)' ;
xy1 = R*[x1' y1']' ;
xy2 = R*[x2' y2']' ;
xy3 = R*[x3' y3']' ;
xy4 = R*[x4' y4']' ;
xy5 = R*[x5' y5']' ;
x1=xy1(1,:)' ; y1=xy1(2,:)' ;
x2=xy2(1,:)' ; y2=xy2(2,:)' ;
x3=xy3(1,:)' ; y3=xy3(2,:)' ;
x4=xy4(1,:)' ; y4=xy4(2,:)' ;
x5=xy5(1,:)' ; y5=xy5(2,:)' ;
plot([x0+ esc*x],[y0+ esc*y],'-k','LineWidth',2)
plot([x0+esc*x1],[y0+esc*y1],'-k','LineWidth',2)
plot([x0+esc*x2],[y0+esc*y2],'-k','LineWidth',2)
plot([x0+esc*x3],[y0+esc*y3],'-k','LineWidth',2)
plot([x0+esc*x4],[y0+esc*y4],'-k','LineWidth',2)
plot([x0+esc*x5],[y0+esc*y5],'-k','LineWidth',2)
% x = [-0.5 0.5 ]';
% y = [ 0   0]' ;
% x1=[-0.5 -0.3] ; y1 = [-0.2 0] ;
% x2=[-0.3 -0.1] ; y2 = y1 ; 
% x3=[-0.1  0.1] ; y3 = y1 ;
% x4=[ 0.1  0.3] ; y4 = y1 ;
% x5=[ 0.3  0.5] ; y5 = y1 ;
% plot([x0+esc*x],[y0+esc*y],'-k','LineWidth',2)
% plot([x0+esc*x1],[y0+esc*y1],'-k','LineWidth',2)
% plot([x0+esc*x2],[y0+esc*y2],'-k','LineWidth',2)
% plot([x0+esc*x3],[y0+esc*y3],'-k','LineWidth',2)
% plot([x0+esc*x4],[y0+esc*y4],'-k','LineWidth',2)
% plot([x0+esc*x5],[y0+esc*y5],'-k','LineWidth',2)
hold off

end
