function StructurePlot(bar,nodo)

    for ibar=1:size(bar,1)
        hold on
        for inod=1:2 
            xini=nodo(bar(ibar,1),1);
            yini=nodo(bar(ibar,1),2);
            xfin=nodo(bar(ibar,2),1);
            yfin=nodo(bar(ibar,2),2); 
            plot([xini;xfin],[yini;yfin],'-k','LineWidth',2)
        end
        hold off
%         grid
        axis equal
    end

end 