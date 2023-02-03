function PlotMfCorreas(L,ncor,FG,iq,fig)  
 
Q = [] ;  for ibar=1:ncor ;  Q = [Q FG(ibar,2)] ; end
M = [] ;  for ibar=1:ncor ;  M = [M FG(ibar,3)] ; end
  
escM = (0.05*L*ncor)/max(abs(M/1000)) ; % se pasa de N a kN
escQ = (0.05*L*ncor)/max(abs(Q/1000)) ; % se pasa de N a kN
escA = 0.02*L ; % escala de apoyos
med = round(ncor/2) ; % barra central

%% MOMENTO FLECTOR 
f = figure ;  
% f = figure(fig)  ; 
% f.WindowState ='maximized';  
f.Visible = 'off' ; 
f.Units = 'inches';
SizeOuterPos = [0.25 0.25 10 5];
f.OuterPosition = SizeOuterPos;
hold on
xini = 0.0 ; xfin = L ; M = [] ; 
plot([xini ; -escA*L ; escA*L ; xini],[0.0 ; -escA*L ; -escA*L ; 0.0],'-k','LineWidth',1) % Apoyo fijo
for ibar=1:ncor     
    plot([xini;xfin],[0.0 ; 0.0],'-k','LineWidth',2) 
    plot([xfin ; xfin-escA*L ; xfin+escA*L ; xfin],[0.0 ; -escA*L ; -escA*L ; 0.0],'-k','LineWidth',1)   % Apoyo movil 
    plot([xfin-escA*L ; xfin+escA*L ],[-escA*L*1.3 ; -escA*L *1.3],'-k','LineWidth',1)                  % Apoyo movil
    
    Mi = escM*FG(ibar,3)/1000 ;   % se pasa de N a kN
    Mf = -escM*FG(ibar,6)/1000 ;   % se pasa de N a kN 
 
    Qi = escM*FG(ibar,2)/1000 ;   % se pasa de N a kN
    Mm = Mi - Qi*L/2 ;
    xm = (xini+xfin)/2  ;  
    
    if iq>2
        A = [xini^2  xini  1 ; xm^2  xm  1 ; xfin^2  xfin  1 ] ;
        b = [Mi Mm Mf ] ;
        ti = inv(A)*b' ; 

        xL = xini:(xfin-xini)/10:xfin ; 
        Mfx = [xL'.^2  xL' ones(size(xL,2),1)]*ti ;  
    else
        xL = xm ; %[] ;
        Mfx = Mm ; % [] ;
    end

    text(xm,Mm,num2str(round(Mm/escM,2))) ;   
 
    plot([xini;xini;xL';xfin;xfin],[0.0;Mi;Mfx;Mf;0.0],'-b') 
    text(xini,Mi,num2str(round(Mi/escM,2))) ;
    text(xfin,Mf,num2str(round(Mf/escM,2))) ;  
    M = [M [Mi Mfx' Mf]] ; 
    
    xini = xini + L ;
    xfin = xfin + L ; 
end 
axis equal
axis off
axis([ncor*L*[-0.05 1.05] [min(M) max(M)]*1.2])
title('Momento Flector [kN.m]')
grid
hold off 
%saveas(gcf,['./Informes/Fig_Correas_Mf' num2str(iq) '.png'])
exportgraphics(gcf,['./Informes/Fig_Correas_Mf' num2str(iq) '.png'])
close(f) ;

%% CORTE 
f = figure;
% f = figure(fig+1)  ; 
% f.WindowState ='maximized';
f.Visible = 'off' ; 
f.Units = 'inches';
f.OuterPosition = SizeOuterPos;
hold on
xini = 0.0 ; xfin = L ; Q = [] ;
plot([xini ; -escA*L ; escA*L ; xini],[0.0 ; -escA*L ; -escA*L ; 0.0],'-k','LineWidth',1) % Apoyo fijo
for ibar=1:ncor     
    plot([xini;xfin],[0.0 ; 0.0],'-k','LineWidth',2) 
    plot([xfin ; xfin-escA*L ; xfin+escA*L ; xfin],[0.0 ; -escA*L ; -escA*L ; 0.0],'-k','LineWidth',1)   % Apoyo movil 
    plot([ xfin-escA*L ; xfin+escA*L ],[-escA*L*1.3 ; -escA*L *1.3],'-k','LineWidth',1)                  % Apoyo movil
     
    Qi = escQ*FG(ibar,2)/1000 ;   % se pasa de N a kN
    Qf = -escQ*FG(ibar,5)/1000 ;   % se pasa de N a kN 
    
    if (iq==1 && ibar==1) % Carga puntual en primer tramo
        Qmi = Qi ; 
        Qmj = Qi - escQ*1 ; % Peso de 1kN
        xm = (xini+xfin)/2  ; 

        xL = [xm xm] ; 
        Qx = [Qmi Qmj] ;  
        text(xm,Qmi,num2str(round(Qmi/escQ,2))) ; 
        text(xm,Qmj,num2str(round(Qmj/escQ,2))) ; 
    elseif (iq==2 && ibar==med) % Carga puntual en tramo central
        Qmi = Qi ; 
        Qmj = Qi - escQ*1 ; % Peso de 1kN
        xm = (xini+xfin)/2  ; 

        xL = [xm xm] ; 
        Qx = [Qmi Qmj] ;    
        text(xm,Qmi,num2str(round(Qmi/escQ,2))) ; 
        text(xm,Qmj,num2str(round(Qmj/escQ,2))) ;   
    else
        xL = [] ;
        Qx = [] ;
    end
    
    plot([xini;xini;xL';xfin;xfin],[0.0;Qi;Qx';Qf;0.0],'-b') 
    text(xini,Qi,num2str(round(Qi/escQ,2))) ;
    text(xfin,Qf,num2str(round(Qf/escQ,2))) ;  
    Q = [Q [Qi Qx Qf]] ; 
    
    xini = xini + L ;
    xfin = xfin + L ; 
end 
axis equal
axis off
axis([ncor*L*[-0.05 1.05] [min(Q) max(Q)]*1.2])
title('Esfuerzo de Corte [kN]')
grid 
hold off
%saveas       (gcf,['./Informes/Fig_Correas_Q' num2str(iq) '.png'])
exportgraphics(gcf,['./Informes/Fig_Correas_Q' num2str(iq) '.png'])
close(f) ;

