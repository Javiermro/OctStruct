function [Elem_data,OK] = Verificacion(Prob_data,Elem_data,estado,OK,fig)
global nelem 
 
if fig~=0 ; figure(fig+4) ; hold on ; end

for ielem=1:nelem
    elem = Prob_data.conec(ielem,3) ;
    if elem==0 
        N = Elem_data(ielem).N(2,estado) ; 
        Elem_data(ielem).Sol_max(1,estado)=max(abs(Elem_data(ielem).FLbar([1 4]))) ; % Q [N]
        Elem_data(ielem).Sol_max(2,estado)=max(abs(Elem_data(ielem).FLbar([2 5]))) ; % N [N]
        Elem_data(ielem).Sol_max(3,estado)=max(abs(Elem_data(ielem).FLbar([3 6]))) ; % M [N.m]
    else
        N = Elem_data(ielem).N(2,estado) ;
        Elem_data(ielem).OK(estado) = true ;
        if N < 0   % Compresión
            [Pn,~] = p_Comp_MainProgram(Elem_data(ielem).Seccion.Tipo,Elem_data(ielem).L) ;
            Pn = Pn*9.8067*1000 ; % pasaje de tn a kN y luego N
            if abs(N) >= Pn
                Elem_data(ielem).OK(estado) = false ; OK = false ; 
            end
            ArEspNec = (abs(N)-Pn)/abs(N) ;
            Elem_data(ielem).Nadm(estado) = Pn ;
        else % Tracción
            Ny = 0.9*Elem_data(ielem).Mat.Fy*Elem_data(ielem).Seccion.Geom.Area/10000 ; % se pasa el area de cm^2 a m^2; 0.9: Art. C.2. C303
            if N >= Ny
                Elem_data(ielem).OK(estado) = false ; OK = false ;
            end
            ArEspNec = (abs(N)-Ny)/abs(N) ;
            Elem_data(ielem).Nadm(estado) = Ny ;
        end

        if fig~=0
            k=1;
            xini = 0.0; yini = 0.0 ; xfin = 0.0 ; yfin = 0.0;
            xini = Prob_data.coord(Elem_data(ielem).conec(k),1);
            yini = Prob_data.coord(Elem_data(ielem).conec(k),2) ; 

            k=k+1; 
            xfin = Prob_data.coord(Elem_data(ielem).conec(k),1);
            yfin = Prob_data.coord(Elem_data(ielem).conec(k),2);

            linecolor = '-r' ;  textcolor = 'red' ;
            if Elem_data(ielem).OK(estado) ; linecolor = '-g' ;  textcolor = 'green' ; end

            plot([xini;xfin],[yini;yfin],linecolor,'LineWidth',2)
            text(mean([xini xfin]),mean([yini yfin]),num2str(round(ArEspNec,2)),'Color',textcolor) ; 
        end
    end
end

if fig~=0
    axis equal
    title('Verificación [%]')
    grid
    hold off
end
