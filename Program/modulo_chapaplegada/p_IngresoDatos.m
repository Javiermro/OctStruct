function Datos = p_IngresoDatos(LongTest,PerfPred,Analisis)
%
% Ingreso de todos los datos geométricos y de materiales del perfil a
% verificar. Se diferenciarán entre tres tipos de perfiles: C, U y
% G (Galera).
% Variables: Se seguirán las definiciones del Reglamento CIRSOC-303
% Unidades: 
% Medidas de la sección: cm. % Longitudes en gral: m

% Datos reglamentarios
Datos.AceroTipo = 'F24';
Datos.Fy = 235; % [MPa]
Datos.Fu = 310; % [MPa]
Datos.E = 200000; % [MPa]
Datos.G = 77200; % [MPa]
Datos.Poi = 0.30;
Datos.DilTer = 12e-6; % [cm/cmºC]
Datos.PesEsp = 77.3; % [kN/m³]

% Datos de condiciones de borde del perfil
Datos.kx = 1; Datos.ky = 1; Datos.kt = 1;

if isempty(LongTest) 
    Datos.Lx = 120; Datos.Ly = 120; Datos.Lt = 120;
else
    Datos.Lx = LongTest; Datos.Ly = LongTest; Datos.Lt = LongTest;
end
% Se introducen 3 longitudes de luz no arriostrada a analizar. Por defecto,
% uno se dejaen es 100%
% Por ahora esto no se debe/puede modificar
Datos.L1 = 1; % LTotal / L1
Datos.L2 = 2; 
Datos.L3 = 3;

% Tipo de análisis
% CompSimple: Compresión simple
% FlexEjMay: Flexión y corte, considerando el eje de mayor inercia.
Datos.Analisis = Analisis; %'CompSimple'; %'FlexEjMay'; %
% Datos del perfil adoptado
s = PerfPred;
Perfil = textscan([s ' '],'%s%f%f%f%f','delimiter','-');
Datos.PerfilTipo = char(Perfil{1}); %FMT: Datos.PerfilTipo = string(Perfil{1});
Datos.Ap = Perfil{2}/10;
Datos.Bp = Perfil{3}/10;
Datos.Cp = Perfil{4}/10;
Datos.t =  Perfil{5}/10;
Datos.R = Datos.t;  % SE ADOPTA RADIO DE GIRO IGUAL AL ESPESOR
% Datos.R = Perfil{6}/10;
Datos.r = 1.5*Datos.R  ;
if strcmp(Datos.Analisis,'FlexEjMay')
    Datos.Apt = Perfil{2}/10;
    Datos.Bpt = Perfil{3}/10;
    Datos.Cpt = Perfil{4}/10;
end

% Datos constructivos para verificar la resistencia a pandeo localizado
Datos.Nap = 4; % cm de apoyo
Datos.Ntr = 5; % cm de carga
Datos.L_Ntr = 40; % cm distancia entre punto de aplicación de la carga y apoyo
Datos.theta = 90*pi()/180; % No sé que es esto.

% Se frena el análisis si se ingresa un perfil que no es C
if ~strcmp(Datos.PerfilTipo,'C') && strcmp(Datos.Analisis,'FlexEjMay')
    error('Para análisis de flexión solo se consideran perfiles tipo C, considerando carga normal al eje de mayor inercia.')
end

if strcmp(Datos.Analisis,'FlexEjMay') && (Datos.L_Ntr > (.5*Datos.kx*Datos.Lx) ||...
        Datos.L_Ntr > (.5*Datos.ky*Datos.Ly) || Datos.L_Ntr > (.5*Datos.kt*Datos.Lt))
    error('Corregir el valos de distancia entre punto de aplicación de carga puntual y apoyo de viga.')
end


end