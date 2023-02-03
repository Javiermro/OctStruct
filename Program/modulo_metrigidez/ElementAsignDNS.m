 function [Elem_data] = ElementAsignDNS(Prob_data,Elem_data,ielem)

elem = Prob_data.conec(ielem,3) ;

if elem~=0
    Elem_data(ielem).Mat = Prob_data.Mat.Acero ;
else
    Elem_data(ielem).Seccion.Tipo = Prob_data.Mat.Hormigon.Tipo ;
    Elem_data(ielem).Mat = Prob_data.Mat.Hormigon.Mat ;
    Elem_data(ielem).Seccion.Geom = Prob_data.Mat.Hormigon.Geom ;
    return ;
end 

switch elem 
    case 10 
        Elem_data(ielem).Seccion.Tipo = Prob_data.Predim.CS ; 
    case 20 
        Elem_data(ielem).Seccion.Tipo = Prob_data.Predim.CI ; 
    case 30 
        Elem_data(ielem).Seccion.Tipo = Prob_data.Predim.DI ; 
    case 31 
        Elem_data(ielem).Seccion.Tipo = Prob_data.Predim.DA ; 
    case 40 
        Elem_data(ielem).Seccion.Tipo = Prob_data.Predim.MO ; 
    otherwise
        error('ElementAsign - Elemento de cercha')
end 

tipo = Elem_data(ielem).Seccion.Tipo ;
 
Perfil = textscan([tipo '-'],'%s%f%f%f%f','delimiter','-');
Datos.Tipo = Perfil{1}{1};
% Datos.Ap = Perfil{2}/10;
% Datos.Bp = Perfil{3}/10;
% Datos.Cp = Perfil{4}/10;
% Datos.t =  Perfil{5}/10;  
%% pasaje de mm a cm
Datos.Ap = Perfil{2}/10;
Datos.Bp = Perfil{3}/10;
Datos.Cp = Perfil{4}/10;
Datos.t =  Perfil{5}/10;  
% Datos.Ap = Datos.Ap/10 ;
% Datos.Bp = Datos.Bp/10 ; 
% Datos.Cp = Datos.Cp/10 ;
% Datos.t  = Datos.t/10 ;   
%%

if Datos.Tipo=='U' && Datos.Cp~=0
    error('ElementAsign - Perfil U con rigidizador')
elseif Datos.Tipo~='U' && Datos.Cp==0
    error('ElementAsign - Perfil G o C sin rigidizador')
end

Datos.r = 1.5*Datos.t;
Datos.R = Datos.t;

Datos = n_PropGeom(Datos) ;
Elem_data(ielem).Seccion.Geom = Datos ;


end