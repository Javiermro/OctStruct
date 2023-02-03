function [Pn,Efectiv] = Flex_MainProgram(PerfPred,Lx)
%
% Programa para el cálculo de la fuerza de compresión de diseño para un
% perfil C, U ó Galera. 
% Los datos se ingresan por "IngresoDatos".

if nargin==0
    Lx = [];
end

Datos = p_IngresoDatos(Lx,PerfPred,'FlexEjMay');

Datos = p_PropGeom(Datos);

p_VerRelEsbltz(Datos);

Datos.Fn = 0; % TensComp(Datos);

Datos = p_AreaEfect(Datos);

RellenosParaInforme

[~,Md_1,Md_2,~,Vd,~,~] = n_ResistDisen(Datos);

Efectiv = Datos.Efectiv;
end