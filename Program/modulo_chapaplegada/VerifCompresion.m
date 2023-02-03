function [Nultimo] = VerifCompresion(Datos,L)
%
% Ingreso de todos los datos geométricos y de materiales del perfil a
% verificar. Se diferenciarán entre tres tipos de perfiles: C, U y
% G (Galera).
% Variables: Se seguirán las definiciones del Reglamento CIRSOC-303
% Unidades: 
% Medidas de la sección: cm. % Longitudes en gral: m

% % Datos reglamentarios
% Datos.AceroTipo = 'F24';
% Datos.Fy = 235; % [MPa]
% Datos.E = 200000; % [MPa]
% Datos.G = 77200; % [MPa]
% Datos.Poi = 0.30;
% Datos.DilTer = 12e-6; % [cm/cmºC]
% Datos.PesEsp = 77.3; % [kN/m³]
% 
% % Datos de condiciones de borde del perfil
Datos.kx = 1; Datos.ky = 1; Datos.kt = 1;
Datos.Lx = 120; Datos.Ly = 120; Datos.Lt = 120;

% Datos del perfil adoptado
s = 'C-280-80-30-2.5'; %'U-83.2-40-0-1.6';% 'C-200-70-25-2'; %'C-160-60-20-2.5';
% 
Perfil = textscan(s,'%s%f%f%f%f','delimiter','-');
Datos.PerfilTipo = string(Perfil{1});
Datos.Ap = Perfil{2}/10;
Datos.Bp = Perfil{3}/10;
Datos.Cp = Perfil{4}/10;
Datos.t =  Perfil{5}/10;
Datos.r = 1.5*Datos.t;
Datos.R = Datos.t;

% Datos constructivos para verificar la resistencia a pandeo localizado
% Datos.Nap = 4; % cm de apoyo
% Datos.Ntr = 5; % cm de carga
% Datos.L_Ntr = 40; % cm distancia entre punto de aplicación de la carga y apoyo

% if Datos.L_Ntr > (.5*Datos.kx*Datos.Lx) || Datos.L_Ntr > (.5*Datos.ky*Datos.Ly) || Datos.L_Ntr > (.5*Datos.kt*Datos.Lt)
%     error('Corregir el valos de distancia entre punto de aplicación de carga puntual y apoyo de viga.')
% end
% Datos.theta = 90*pi()/180; % No sé que es esto.

% Tipo de análisis
% CompSimple: Compresión simple
% FlexEjMay: Flexión y corte, considerando el eje de mayor inercia.
Datos.Analisis = 'CompSimple'; %'FlexEjMay'; %
% disp('Hipótesis generales del cálculo:...')

% Se frena el análisis si se ingresa un perfil que no es C
if ~strcmp(Datos.PerfilTipo,'C') && strcmp(Datos.Analisis,'FlexEjMay')
    error('Para análisis de flexión solo se consideran perfiles tipo C, considerando carga normal al eje de mayor inercia.')
end

Datos = PropGeom(Datos);

VerRelEsbltz(Datos);

Datos = p_TensComp(Datos);

Datos = AnchoEfect(Datos);

%Datos = AreaEfect(Datos);

Pn = ResistDisen(Datos);


end