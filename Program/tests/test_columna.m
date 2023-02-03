function test_columna(Prob_data,Elem_data,ie)
% Se verifican a la flexión simple y al corte las columnas de HºAº, con las
% dimensiones y armaduras que el usuario provee.
global model
%% Datos de entrada
% Materiales
TipoHA = str2num(Prob_data.Mat.Hormigon.Tipo(2:end))*10; 
TipoAcero = 420; % MPa

% Solicitaciones
switch model
    case 1 
        col_der = Prob_data.Geom.na*8 + 11 + 1 ;
        col_izq = Prob_data.Geom.na*8 + 11 + 2 ; 
    case 2 
        col_der = Prob_data.Geom.na*8 + 11 + 1 ;
        col_izq = Prob_data.Geom.na*8 + 11 + 2 ; 
    case 3 
        col_der = Prob_data.Geom.na*8 + 9 + 1 ;
        col_izq = Prob_data.Geom.na*8 + 9 + 2 ; 
    case 4 
        col_der = Prob_data.Geom.na*4 + 7 + 1 ;
        col_izq = Prob_data.Geom.na*4 + 7 + 2 ; 
    case 5 
        col_der = Prob_data.Geom.na*4 + 9 ;
        col_izq = Prob_data.Geom.na*4 + 8 ; 
    case 6 
        col_der = Prob_data.Geom.na*4 + 10 ;
        col_izq = Prob_data.Geom.na*4 + 11 ; 
end
LongC = Prob_data.Geom.Hc*100 ;

% Geometría de la sección
% ac = 45; % [cm] Lado de la columna de hormigón, normal a cumbrera
% bc = 20; % [cm] Lado de la columna de hormigón, paralelo a cumbrera
ac = Prob_data.Mat.Hormigon.Geom.h*100 ; % en [cm]
bc = Prob_data.Mat.Hormigon.Geom.b*100 ; % en [cm]
Recub = 3; % [cm] Recubrimiento

% Geometría de las armaduras
Diam_Asext = Prob_data.Mat.Hormigon.Geom.Db ; %  16; % [mm] Diámetro de los hierros en la cara externa
n_Asext = Prob_data.Mat.Hormigon.Geom.Nb ; %5; % Cantidad de hierros en cara externa
Diam_Estr = Prob_data.Mat.Hormigon.Geom.De ; %6; % [mm] Diámetro de los estribos
Sep_Estr = Prob_data.Mat.Hormigon.Geom.Se*100 ; %10; % [cm] Separación entre estribos
NumRam_Estr = Prob_data.Mat.Hormigon.Geom.nm ; % Nro de ramas en estribos

for icol=1:2
    if icol==1
       fprintf('\n*** Inicio de verificación de la columna izquierda de HA, para estado %2i ***\n',ie) 
       Mmax = max(abs(Elem_data(col_der).FLbar([3 6]))) ;  % N.m
       Qmax = max(abs(Elem_data(col_der).FLbar([2 5]))) ;  % N     
    elseif icol==2
       fprintf('\n*** Inicio de verificación de la columna derecha de HA, para estado %2i ***\n',ie) 
       Mmax = max(abs(Elem_data(col_izq).FLbar([3 6]))) ;  % N.m
       Qmax = max(abs(Elem_data(col_izq).FLbar([2 5]))) ;  % N
    end
    Mmax = Mmax*100/1000*0.10197 ; % pasaje de N.m a t.cm
    Qmax = Qmax/1000*0.10197 ; % pasaje de N a t
    
    Verif_Columna(Mmax, Qmax, LongC, TipoHA, TipoAcero, ac, bc, Diam_Asext,...
                      n_Asext, Recub, Diam_Estr, Sep_Estr, NumRam_Estr) ;
end
