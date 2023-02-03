% Script de datos de ejemplo Moro.
% Se ubican los datos coincidiendo con el orden del Zonda para un trabajo
% de comparación mas expeditivo.
% Tipo de cubierta
ModeloCerch = 1; % 1: Dos aguas, 2: Pendiente única, 3: Cub Abovedada
% Ancho, B
B = 20; % Luz de cercha.
% Altura del alero Ha
h_al = 6.51;
%%%%%%%%%%%%%%%
% Datos que no se ingresan
theta = 21.95;
%%%%%%%%%%%%%%%

% Altura de cumbrera, Hc
h_cumb = h_al + B/2*tan(pi()/180*theta);
% Longitud
L = 60; % Longitud paralela a la cumbrera
% Categoria de la estructura
Cat = 'II';
% Clasificación
Edif = 'Cerrado'; %'Aislado';  'PCerrado'; 'CubAislada';
% Velocidad
V = 40.0;
% Categoría de exposición
Exp = 'C';
% Altura de bloqueo
AltBlo = 0;
epsReg = AltBlo/h_al;
% Posición bloqueo
PosBloqueo = 0; % 0: en alero mas bajo. 1: en alero mas alto.

%%%%%%%%%%%%%%%
% Datos que no se ingresan
h_med = (h_cumb+h_al)/2;
SepCerch = 5;
Flecha = [];
%%%%%%%%%%%%%%%

% Impresión de resultados de viento
PrintTable = 1;