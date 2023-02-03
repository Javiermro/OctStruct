function [Elem_data] = Solicitaciones(Elem_data,estado,despG)
% Calcula los esfuerzos de empotramiento perfecto en coordenadas locales
global nelem  ndofs  

for ielem=1:nelem
    npos = Elem_data(ielem).conec([1 2])-1 ; 
    D = despG([npos(1)*ndofs+[1:ndofs]  npos(2)*ndofs+[1:ndofs]]) ;
    S = Elem_data(ielem).KGele ;
    FG = S*D + Elem_data(ielem).AGbar ; 
    Elem_data(ielem).FLbar = Elem_data(ielem).RT*FG ;    % Fuerza en extremo de barra en coord. locales

    Elem_data(ielem).N(1:2,estado) = [Elem_data(ielem).RT([1 4],:)*FG]  ;   
    Elem_data(ielem).Q(1:2,estado) = [Elem_data(ielem).RT([2 5],:)*FG] ; 
    Elem_data(ielem).M(1:2,estado) = [Elem_data(ielem).RT([3 6],:)*FG] ; 
end
