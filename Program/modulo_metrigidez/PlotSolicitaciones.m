function PlotSolicitaciones(Prob_data,Elem_data,despG,fig) 
global model nelem nnodo npoin nfixe ndofs nload

N = [] ;  for ielem=1:nelem ;  N = [N Elem_data(ielem).FLbar(4)] ; end
M = [] ;  for ielem=1:nelem ;  M = [M Elem_data(ielem).FLbar(6)] ; end

escN = (0.1*Prob_data.Geom.L)/max(abs(N/1000)) ;   % se pasa de N a kN
escM = (0.1*Prob_data.Geom.L)/max(abs(M/1000)) ;   % se pasa de N a kN
escE = 1 ; % factor de escala x100 

%% ELASTICA
bar  = Prob_data.conec ;
nodo = Prob_data.coord ; 
 
corda = actual_coord2D(Prob_data.coord,despG*escE);

figure(fig+1) ; hold on
for ibar=1:size(bar,1)  
    xini=nodo(bar(ibar,1),1);    yini=nodo(bar(ibar,1),2);
    xfin=nodo(bar(ibar,2),1);    yfin=nodo(bar(ibar,2),2);     
    plot([xini;xfin],[yini;yfin],'-k','LineWidth',1)     
end
nodo = corda ;
for ibar=1:size(bar,1)  
    xini=nodo(bar(ibar,1),1);    yini=nodo(bar(ibar,1),2);
    xfin=nodo(bar(ibar,2),1);    yfin=nodo(bar(ibar,2),2);     
    plot([xini;xfin],[yini;yfin],'-r','LineWidth',1) 
end
axis equal
title('Deformada x 1')
grid
hold off 
 
%% NORMAL        
    figure(fig+2) ;hold on 
    for ielem=1:nelem
        k=1;
        xini = 0.0; yini = 0.0 ; xfin = 0.0 ; yfin = 0.0;
        xini = Prob_data.coord(Elem_data(ielem).conec(k),1);
        yini = Prob_data.coord(Elem_data(ielem).conec(k),2) ; 

        k=k+1; 
        xfin = Prob_data.coord(Elem_data(ielem).conec(k),1);
        yfin = Prob_data.coord(Elem_data(ielem).conec(k),2);

%         N = Elem_data(ielem).N/1000 ;  % se pasa de N a kN
        N = Elem_data(ielem).FLbar(4)/1000 ;  % se pasa de N a kN
        if N<0 ; 
            linecolor = '-r' ; textcolor = 'red' ;
        else ; 
            linecolor = '-g' ; textcolor = 'green' ;
        end

        plot([xini;xfin],[yini;yfin],linecolor,'LineWidth',2)

        text(mean([xini xfin]),mean([yini yfin]),num2str(round(N,2)),'Color',textcolor) ; 
    end
    axis equal
    title('Normal [kN]')
    grid
    hold off

%% MOMENTO FLECTOR        
    figure(fig+3) ;hold on
    
    for ielem=1:nelem
        k=1;
        xini = 0.0; yini = 0.0 ; xfin = 0.0 ; yfin = 0.0;
        xini = Prob_data.coord(Elem_data(ielem).conec(k),1);
        yini = Prob_data.coord(Elem_data(ielem).conec(k),2) ; 

        k=k+1; 
        xfin = Prob_data.coord(Elem_data(ielem).conec(k),1);
        yfin = Prob_data.coord(Elem_data(ielem).conec(k),2);

        plot([xini;xfin],[yini;yfin],'-k','LineWidth',2)
        Mi = escM*Elem_data(ielem).FLbar(3)/1000 ;   % se pasa de N a kN
        Mf = escM*Elem_data(ielem).FLbar(6)/1000 ;   % se pasa de N a kN
        tita = Elem_data(ielem).tita ;

        Mxi = xini + (Mi)*(cosd(tita+90)) ;
        Myi = yini + (Mi)*(sind(tita+90)) ;
        Mxf = xfin - (Mf)*(cosd(tita+90)) ;
        Myf = yfin - (Mf)*(sind(tita+90)) ; 
        
        xL=[]; Mfx=[];
        plot([xini;Mxi;xL';Mxf;xfin],[yini;Myi;Mfx;Myf;yfin],'-b') 
        text(Mxi,Myi,num2str(round(Mi/escM,2))) ;
        text(Mxf,Myf,num2str(round(Mf/escM,2))) ;
    end
    axis equal
    title('Momento Flector [kN.m]')
    grid
    hold off
     

