function PlotStructure(Prob_data,fig)
bar  = Prob_data.conec ;
nodo = Prob_data.coord ;
eps = [0.0 0.0];
SizeOutPos = [0.25 0.25 9 6];
if fig==1
    f = figure ;
    % f.WindowState ='maximized';
    f.Visible = 'off' ;
    f.Units = 'inches';
    f.OuterPosition = SizeOutPos;
    hold on
    for ibar=1:size(bar,1)
        xini=nodo(bar(ibar,1),1);
        yini=nodo(bar(ibar,1),2);
        xfin=nodo(bar(ibar,2),1);
        yfin=nodo(bar(ibar,2),2);
        
        plot([xini;xfin],[yini;yfin],'-k','LineWidth',2)
        
        if bar(ibar,3)>=10 && bar(ibar,3)<20
            tex=[' S' num2str(ibar)] ; eps = [0.0 0.1];
        elseif bar(ibar,3)>=20 && bar(ibar,3)<30
            tex=[' I' num2str(ibar)] ; eps = [0.0 -0.1];
        elseif bar(ibar,3)>=30 && bar(ibar,3)<40
            tex=[' D' num2str(ibar)] ; eps = [0.1 0.0];
        elseif bar(ibar,3)>=40 && bar(ibar,3)<50
            tex=[' M' num2str(ibar)] ; eps = [0.1 0.0];
        else
            tex='';
        end
        text(mean([xini xfin])+eps(1),mean([yini yfin])+eps(2),tex,'Color','black') ;
    end
    axis equal
    title('Estructura')
    grid
    hold off
    exportgraphics(gcf,'./Informes/Fig_struture.png')
    close(f)
    
    
    %% Dibuja las cargas en nodos
    if isfield(Prob_data,'nodfz')
        f = figure   ;
        % f.WindowState ='maximized';
        f.Visible = 'off' ;
        f.Units = 'inches';
        f.OuterPosition = SizeOutPos;
        hold on
        for ibar=1:size(bar,1)
            xini=nodo(bar(ibar,1),1);
            yini=nodo(bar(ibar,1),2);
            xfin=nodo(bar(ibar,2),1);
            yfin=nodo(bar(ibar,2),2);
            
            plot([xini;xfin],[yini;yfin],'-k');%,'LineWidth',2)
        end
        
        for infor=1:size(Prob_data.nodfz,1)
            escF = 0.1*(Prob_data.Geom.L)/max(max(abs(Prob_data.nodfz(:,2:3)))) ;   % se pasa de N a kN
            inod = Prob_data.nodfz(infor,1) ;
            x0 = nodo(inod,1) ; y0 = nodo(inod,2) ;
            
            if (Prob_data.nodfz(infor,2)~=0 || Prob_data.nodfz(infor,3)~=0) % Fuerza
                Px = escF*Prob_data.nodfz(infor,2) ;
                Py = escF*Prob_data.nodfz(infor,3) ;
                Pt =sqrt(Prob_data.nodfz(infor,2)^2 + Prob_data.nodfz(infor,3)^2);
                quiver(x0-Px,y0-Py,Px,Py,'-r','LineWidth',1)
                text(mean([x0 x0-Px]) , mean([y0 y0-Py]) ,num2str(Pt/1000),'Color','red') ;
            end
        end
        axis equal
        title('Cargas [kN]')
        grid
        hold off
        exportgraphics(gcf,['./Informes/Fig_state' num2str(fig) '.png'])
        close(f)
    end
end
 