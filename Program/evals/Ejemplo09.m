% Script de datos del ejemplo 09 de la guía del Reglamento C.102.
% Se ubican los datos coincidiendo con el orden del Zonda para un trabajo
% de comparación mas expeditivo.

% Tipo de cubierta
ModeloCerch = 2; % 1: Dos aguas, 2: Pendiente única, 3: Cub Abovedada
% Ancho, B
B = 12;
% Altura del alero Ha
h_al = 4.5;
%%%%%%%%%%%%%%%
% Datos que no se ingresan
theta = 14;
%%%%%%%%%%%%%%%

% Altura de cumbrera, Hc
h_cumb = h_al + B*tan(pi()/180*theta);
% Longitud
L = 24; % Longitud paralela a la cumbrera
% Categoria de la estructura
Cat = 'II';
% Clasificación
Edif = 'Cerrado'; %'Aislado';  'PCerrado'; 'CubAislada';
% Velocidad
V = 50.0;
% Categoría de exposición
Exp = 'B';
% Altura de bloqueo
AltBlo = 0;
epsReg = AltBlo/h_al;
% Posición bloqueo
PosBloqueo = 0; % 0: en alero mas bajo. 1: en alero mas alto.

%%%%%%%%%%%%%%%
% Datos que no se ingresan
h_med = (h_cumb+h_al)/2;
SepCerch = 6;
Flecha = [];
%%%%%%%%%%%%%%%

PrintTable = 1;