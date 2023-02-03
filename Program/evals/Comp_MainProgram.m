function [Pn,Efectiv] = Comp_MainProgram(PerfPred,Lx)
%
% Programa para el cálculo de la fuerza de compresión de diseño para un
% perfil C, U ó Galera. 
% Los datos se ingresan por "IngresoDatos".

if nargin==0
    Lx = [];
end

Datos = p_IngresoDatos(Lx,PerfPred,'CompSimple');

Datos = p_PropGeom(Datos);

p_VerRelEsbltz(Datos);

Datos = p_TensComp(Datos);

Datos = p_AreaEfect(Datos);

Pn = p_ResistDisenComp(Datos);

Efectiv = Datos.Efectiv;

end