function eval_columna
%
% Se verifican a la flexión simple y al corte las columnas de HºAº, con las
% dimensiones y armaduras que el usuario provee.

addpath(genpath('./../'))

%% Datos de entrada
% Materiales
TipoHA = 210;
TipoAcero = 420; % MPa

% Solicitaciones
Mmax = 7.81*100; % [t*cm]
Qmax = 7.18; % [tn]
LongC = 435; % [cm] Longitud de Columna 

% Geometría de la sección
ac = 45; % [cm] Lado de la columna de hormigón, normal a cumbrera
bc = 20; % [cm] Lado de la columna de hormigón, paralelo a cumbrera
Recub = 3; % [cm] Recubrimiento

% Geometría de las armaduras
Diam_Asext = 16; % [mm] Diámetro de los hierros en la cara externa
n_Asext = 5; % Cantidad de hierros en cara externa
Diam_Estr = 6; % [mm] Diámetro de los estribos
Sep_Estr = 10; % [cm] Separación entre estribos

Verif_Columna(Mmax, Qmax, LongC, TipoHA, TipoAcero, ac, bc, Diam_Asext,...
              n_Asext, Recub, Diam_Estr, Sep_Estr);

end
