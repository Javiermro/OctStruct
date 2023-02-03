function eval_viento
% Evaluación de la función 'main viento' para el caso de cubierta a dos
% aguas. 
addpath(genpath('./../'))

% Datos de exposición de la estructura.
% EjemploMoro
% Ejemplo07
% Ejemplo09
EjemploCubAisl_UnAgua
% EjemploCubiertaAbovedada

if h_al > 5
    z = [5 h_al];
else
    z = [h_al-0.5 h_al];
end

CotaTramoMedio1 = h_al + (h_cumb - h_al)/3;
CotaTramoMedio2 = h_al + (h_cumb - h_al)*2/3;
z = [z CotaTramoMedio1 CotaTramoMedio2 h_cumb h_med];

[m_CargasE,Data] = main_viento(V,Exp,Cat,Edif,z,L,B,SepCerch,theta,ModeloCerch,Flecha,epsReg,PosBloqueo,PrintTable);

% eval_informeViento(m_CargasE)

end