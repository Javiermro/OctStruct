% Script de datos para ejemplo de cubierta aislada
% Se ubican los datos coincidiendo con el orden del Zonda para un trabajo
% de comparación mas expeditivo.

% Tipo de cubierta
ModeloCerch = 2; % 1: Dos aguas, 2: Pendiente única, 3: Cub Abovedada
% Ancho, B
B = 30;
% Altura del alero Ha
h_al = 6;
%%%%%%%%%%%%%%%
% Datos que no se ingresan
theta = 5.71;
%%%%%%%%%%%%%%%

% Altura de cumbrera, Hc
h_cumb = h_al + B*tan(pi()/180*theta);
% Longitud
L = 60; % Longitud paralela a la cumbrera
% Categoria de la estructura
Cat = 'I';
% Clasificación
Edif = 'CubAislada';%'Cerrado'; %'Aislado';  'PCerrado'; 
% Velocidad
V = 50.0;
% Categoría de exposición
Exp = 'B';
% Altura de bloqueo
AltBlo = 5;
epsReg = AltBlo/h_al;
% Posición bloqueo
PosBloqueo = 0; % 0: en alero mas bajo. 1: en alero mas alto.

%%%%%%%%%%%%%%%
% Datos que no se ingresan
h_med = h_al + 0.3*B*sin(5.71*pi()/180);
SepCerch = 6;
Flecha = [];
%%%%%%%%%%%%%%%

PrintTable = 1;