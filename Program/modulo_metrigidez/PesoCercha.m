function Peso = PesoCercha(Prob_data,Elem_data) 

Vol  = 0.0 ; 
for ielem=1:size(Prob_data.conec,1)
    elem = Prob_data.conec(ielem,3) ; 
    if elem==0 ; 
        continue ;  
    end    
    A = Elem_data(ielem).Seccion.Geom.Area ; % en cm^2
    A = A/10000 ; % pasaje a m^2
    L = Elem_data(ielem).L ; % en m
    Vol = Vol + A*L ;
end

Peso = Vol*Prob_data.Mat.Acero.PesEsp*1000 ; % [m^3]*[kN/m^3]*[1000N/1kN] 