function [Pn,Efectiv] = p_FlexComp_Correas(PerfPred,Lx)
%
% Programa para el cálculo de la fuerza de compresión de diseño para un
% perfil C, U ó Galera. 
% Los datos se ingresan por "IngresoDatos".

if nargin==0
    Lx = [];
end
Lx  = Lx*100 ; % pasaje a cm 

Datos = p_IngresoDatos(Lx,PerfPred,'CompSimple');

Datos = p_PropGeom(Datos);

p_VerRelEsbltz(Datos);

Datos = p_TensComp(Datos);

Datos = p_AreaEfect(Datos);

% Pn = p_ResistDisenComp(Datos);
Pn = n_ResistDisen(Datos);

Efectiv = Datos.Efectiv;

end