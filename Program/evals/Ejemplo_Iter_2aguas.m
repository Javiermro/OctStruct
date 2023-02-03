clear all, close all, clc
addpath(genpath('./../'))


% Ancho, B
B = 8:1:60;
% Altura del alero Ha
h_al = 4.5:0.5:15;
% Pendiente cubierta
theta = 5:5:30;
% Longitud
L = 20:2:60; % Longitud paralela a la cumbrera
% Categoria de la estructura
Cat = {'I','II','III','IV'};
% Clasificación
Edif = {'Cerrado','PCerrado'};%'Cerrado'; %'Aislado';  'PCerrado'; 'CubAislada';
% Velocidad
V = [30:5:70];
% Categoría de exposición
Exp = {'A','B','C','D'};

%%%%%%%%%%%%%%%
% Datos que no cambian
ModeloCerch = 1; % 1: Dos aguas
% Altura de bloqueo
AltBlo = 0;
% Posición bloqueo
PosBloqueo = 0; % 0: en alero mas bajo. 1: en alero mas alto.
SepCerch = 2;
Flecha = [];
PrintTable = 0;
%%%%%%%%%%%%%%%
AuxVar = 0;
NumExam = 0;
for i = 1:length(B)
    for j = 1:length(h_al)
        for k = 1:length(theta)
            for l = 1:length(L)
                for m = 1:size(Cat,2)
                    for n = 1:size(Edif,2)
                        for v = 1:length(V)
                            for p = 1:size(Exp,2)
                                epsReg = AltBlo/h_al(j);
                                h_cumb = h_al(j) + B(i)/2*tan(pi()/180*theta(k));
                                h_med = (h_cumb+h_al(j))/2;
                                NumExam = NumExam + 1;
                                try 
                                    eval_viento_try(B(i),h_al(j),theta(k),L(l),cell2mat(Cat(m)),cell2mat(Edif(n)),V(v),cell2mat(Exp(p)),ModeloCerch,epsReg,PosBloqueo,SepCerch,Flecha,PrintTable,h_cumb,h_med)
                                catch
                                    AuxVar = AuxVar + 1;
                                    %EstructuraNum(AuxVar,:) = [B(i),h_al(j),theta(k),L(l),V(v),ModeloCerch,epsReg,PosBloqueo,SepCerch,Flecha,PrintTable,h_cumb,h_med];
                                    EstructuraData{AuxVar} = {B(i),h_al(j),theta(k),L(l),cell2mat(Cat(m)),cell2mat(Edif(n)),V(v),cell2mat(Exp(p)),ModeloCerch,epsReg,PosBloqueo,SepCerch,Flecha,PrintTable,h_cumb,h_med};
                                    
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
save
