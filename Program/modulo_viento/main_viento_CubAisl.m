function [m_CargasE,Data]= main_viento_CubAisl(V,Exp,Cat,Edif,z,L,B,SepCerch,theta,ModeloCerch,Flecha,epsReg,PosBloqueo,PrintTable)
%
% Determinación de las cargas de viento sobre la estructura
% Reglamento CIRSOC 102 (Ed. 2005)
% El procedimiento de diseño se desarrolla en la sección 5.3 PROCEDIMIENTO
% DE DISEÑO. pág. Cap. 5-13
% Se toma como procedimiento modelo el ejemplo 7 de la "Guía para el uso...
% CIRSOC 102" pág. "Guía Cap. 3 - 54"

%% Presión dinámica qz

% Kz: Coeficiente de exposición para la presión dinámica. Tabla 5 (pág. "Tablas 52)
% Se determinan los coeficientes alpha y zg:
alpha = 5.0 * (strcmp(Exp,'A')) + 7.0 * (strcmp(Exp,'B')) + 9.5 * (strcmp(Exp,'C')) + 11.5 * (strcmp(Exp,'D')) ;
zg = 457 * (strcmp(Exp,'A')) + 366 * (strcmp(Exp,'B')) + 274 * (strcmp(Exp,'C')) + 213 * (strcmp(Exp,'D')) ;

for i = 1:length(z)
    if (z(i) > 5) && (5 <= zg)
        Kz(i) = 2.01 * (z(i)/zg)^(2/alpha);
    elseif z(i) <= 5
        Kz(i) = 2.01 * (5/zg)^(2/alpha);
    end
end

% Kzt: Factor topográfico .
% Se adopta la unidad para casos de topografía plana. En caso de buscar un
% valor distinto, leer el artículo 5.7 EFECTOS TOPOGRÁFICOS pág. "Cap.
% 5-16".
Kzt = 1;

% Factor de direccionalidad del viento para sistema principal resistente a
% la fuerza de viento:
% Ver: Leer pág. Cap. 2-4;
%      Factor obtenido de Tabla 6, pág. "Tablas - 53"
Kd = 0.85; % Se adopta la unidad para ser conservador.

% Tabla 1 - pág. Tablas 45.
I = 0.87 * (strcmp(Cat,'I')) + 1.00 * (strcmp(Cat,'II')) +...
    1.15 * (strcmp(Cat,'III')) + 1.15 * (strcmp(Cat,'IV'));
if I==0; error('Error de carga de datos de viento, main_viento') ;end


qz = 0.613 * Kz' * Kzt * Kd * V^2 * I;

% Datos de distribución de cerchas.
numCerch = L / SepCerch + 1;
h_med = z(end);

%% Estados
% Caso de cubiertas total o parcialmente cerradas:
% Los Estados pueden ser, como máximo, 8 en total , en función de los casos
% de carga que comprende el Reglamento y la pendiente de la cubierta. 
% Inicialmente se consideran que los 8 existen y a medida que las 
% condiciones de verifican, se van eliminando aquellos que no son válidos 
% para el presente caso. Los estados son:
% E1 = VNC + Theta >= 10 + GCpi > 0 + Cp(CubiertaBarlov) > 0
% E2 = VNC + Theta >= 10 + GCpi > 0 + Cp(CubiertaBarlov) < 0
% E3 = VNC + Theta >= 10 + GCpi < 0 + Cp(CubiertaBarlov) > 0
% E4 = VNC + Theta >= 10 + GCpi < 0 + Cp(CubiertaBarlov) < 0

% E5 = VNC + Theta < 10  + GCpi > 0
% E6 = VNC + Theta < 10  + GCpi < 0

% E7 = VPC + GCpi > 0
% E8 = VPC + GCpi < 0

% Caso de cubiertas aisladas:
% En este caso solo se contempla un estado. Sin embargo está subdividido en
% 'Presiones Globales' y 'Presiones Locales'. A su vez, dentro de PL se 
% tienen valores máximos y valores mínimos. De esta forma, los estados
% correspondientes a este caso serán 1: PG-max, 2: PG-min, 3: PL-max y 
% 4: PL-min
% E1 = Presiones Globales - Max
% E2 = Presiones Globales - Min
% E3 = Presiones Locales - Max
% E4 = Presiones Locales - Min

% El reglamento no contempla cubiertas aisladas de forma abovedada:
if ModeloCerch == 3 && strcmp(Edif,'CubAislada')
    error('El Reglamento CIRSOC 102 NO contempla cubiertas aisladas de forma abovedada')
end

Estados(1) = 1; Estados(2) = 1; Estados(3) = 1; Estados(4) = 1;
Estados(5) = 1; Estados(6) = 1; Estados(7) = 1; Estados(8) = 1;

if ~strcmp(Edif,'CubAislada')
    if theta >= 10  || ModeloCerch == 3
        Estados(5) = 0; Estados(6) = 0;
    elseif theta < 10
        Estados(1) = 0; Estados(2) = 0;
        Estados(3) = 0; Estados(4) = 0;
    end
else
    Estados(5) = 0;
    Estados(6) = 0; 
    Estados(7) = 0; 
    Estados(8) = 0;
end

%% Presiones de viento de diseño para el SPRFV
% q = qz para pared a barlovento a la altura z sobre el terreno
% q = qh para pared a sotavento, paredes laterales y cubierta
% qi = qh para paredes a barlovento, paredes laterales, paredes a sotavento
%         y cubiertas de edificios cerrados y para la evaluación de la presión
%         interna en edificios parcialmente cerrados.
% qi = qz para la evaluación de la presión interna positiva en edificios
% parcialmente cerrados, donde la altura z está definida como el nivel de
% la abertura mas elevada del edificio que puede afectar la presión interna
% positiva. Para la evaluación de la presión interna positiva, qi se puede
% calcular conservativamente a la altura h (qi = qh)

% G = 0.85 Art. 5.8.1
G = 0.85;
% GCpi
switch Edif
    case 'PCerrado'
        GCpi = [+0.55 -0.55];
    case 'Cerrado'
        GCpi = [+0.18 -0.18];
    case 'CubAislada'
        GCpi = [ ];
end

switch Edif
    case {'PCerrado','Cerrado'}
        % Cp: figura 3
        [m_MatPresNet_vpc,m_MatPresNet_vnc,m_EtiqMatPresNet_vpc,m_EtiqMatPresNet_vnc] = MatrizPresionesNetas(z,L,B,theta,qz,GCpi,Estados,ModeloCerch,Flecha);
        % z    q     G     Cp      qi  GCpi
        p_vnc = [m_MatPresNet_vnc(:,2).*m_MatPresNet_vnc(:,3).*m_MatPresNet_vnc(:,4) ...
            - m_MatPresNet_vnc(:,5).*m_MatPresNet_vnc(:,6), m_MatPresNet_vnc(:,7:13) ];
        p_vpc = [m_MatPresNet_vpc(:,2).*m_MatPresNet_vpc(:,3).*m_MatPresNet_vpc(:,4) ...
            - m_MatPresNet_vpc(:,5).*m_MatPresNet_vpc(:,6), m_MatPresNet_vpc(:,7:9)];
        %p = q * G * Cp - qi * GCpi;
    case 'CubAislada'
        [m_Cpn,m_EtiqMatPresNet] = MatrizPresionesNetas_CubAisl(theta,ModeloCerch,epsReg,PosBloqueo);
        p_v = qz(end) .* G .* m_Cpn;
end
%% Impresión por pantalla de los resultados
if PrintTable
    ImpresionResultados(m_MatPresNet_vpc,m_MatPresNet_vnc,m_EtiqMatPresNet_vpc,m_EtiqMatPresNet_vnc,p_vpc,p_vnc)
end
%% Matriz de Estados
% Los Estados posibles son 8 en total como máximo, en función de los casos de carga
% que comprende el Reglamento. Sin embargo, solo puede haber un máximo de
% 6.

% La matriz de Est tiene la siguiente estructura:
% EySE = [ Ei   CrchNro  L_Tr(1:7)   pi(1:7)   ]
% * Ei: nro de estado de la carga. 1 <= i <= 8
% * CrchNro: nro de cercha de la que se detalla la carga.
% * L_Tr: vector de longitudes de los tramos donde se encuentran aplicadas las cargas
%         1 <= i <= 8, con:
% ** L1 y L2: tramos de la columna a barlovento (o de la izq). Si el alero es
%            de h <= 5mts, L2 = 0.
% ** L3 a L6: tramos sobre el desarrollo de la pendiente completa..
%             L3 = h_med/2; L4 = h_med, L5 = 2*h_med; L6 = LongTotalCub
% ** L7: tramo de la columna a sotavento (o de la derecha). Siempre va a ser
%        un solo tramo.
% * Pi: Vector de presiones (N/m) sobre los tramos. 1 <= i <= 7.
m_CargasE = [];

%% Parámetros geométricos para el armado de las matrices de presiones

% Longitud de los tramos en que se dividen las cargas distribuídas
% Estados 1 a 4
L_Tr14(1) = z(1);
if length(z) == 5
    L_Tr14(2) = 0;
    L_Tr14(7) = z(1);
else
    L_Tr14(2) = z(2);
    L_Tr14(7) = z(2);
end

if ModeloCerch == 1 || ModeloCerch == 2
    LongCubIncl = 2*(B/2)/cos(theta*pi()/180);
    L_Tr14(3) = LongCubIncl/2;
    L_Tr14(4) = LongCubIncl;
    L_Tr14(5) = 0;
    L_Tr14(6) = 0;
elseif ModeloCerch == 3
    % Radio del arco de circunferencia
    radio = Flecha/2 + B^2/8/Flecha;
    % Ángulo entre los vectores que forman el extremo del arco
    alpha = acos((-B^2/4+(radio-Flecha)^2)/(B^2/4+(radio-Flecha)^2))*180/pi();
    LongCubIncl = 2*pi()*radio*alpha/360;
    L_Tr14(3) = LongCubIncl/4;
    L_Tr14(4) = LongCubIncl*3/4;
    L_Tr14(5) = LongCubIncl;
    L_Tr14(6) = 0;
end

% Estados 5 a 6
L_Tr56(1) = z(1);
if length(z) == 5
    L_Tr56(2) = 0;
    L_Tr56(7) = z(1);
else
    L_Tr56(2) = z(2);
    L_Tr56(7) = z(2);
end
LongCubIncl = 2*(B/2)/cos(theta*pi()/180);
L_Tr56(3) = h_med/2;
L_Tr56(4) = h_med;
L_Tr56(5) = 2*LongCubIncl;
L_Tr56(6) = LongCubIncl;

% Estados 7 a 8
if length(z) == 5
    L_Tr78(1) = z(1);
    L_Tr78(2) = 0;
    L_Tr78(7) = z(1);
else
    L_Tr78(1) = z(2);
    L_Tr78(2) = 0;
    L_Tr78(7) = z(2);
end
LongCubIncl = 2*(B/2)/cos(theta*pi()/180);
L_Tr78(3) = LongCubIncl;
L_Tr78(4) = 0;
L_Tr78(5) = 0;
L_Tr78(6) = 0;


%% Estados 1, 2 ,3 y 4

if ModeloCerch == 1 || ModeloCerch == 2
    iTr = [1 3  9 13 5;  % E1
           1 3 11 13 5;  % E2
           2 4 10 14 6;  % E3
           2 4 12 14 6]; % E4
    for iEst = 1:4
        if Estados(iEst)
            aux_vect = [];
            for j_iTr = 1:size(iTr,2)
                aux_vect = [aux_vect p_vnc(p_vnc(:,end)==iTr(iEst,j_iTr),1)*SepCerch];
            end
            m_CargasE = [m_CargasE;   iEst    2      L_Tr14      aux_vect(1:4) 0 0 aux_vect(5)];
        end
    end
elseif ModeloCerch == 3
    iTr = [1 3 46 50 52 5;  % E1
           1 3 48 50 52 5;  % E2
           2 4 47 51 53 6;  % E3
           2 4 49 51 53 6]; % E4
    for iEst = 1:4
        if Estados(iEst)
            aux_vect = [];
            for j_iTr = 1:size(iTr,2)
                aux_vect = [aux_vect p_vnc(p_vnc(:,end)==iTr(iEst,j_iTr),1)*SepCerch];
            end
            m_CargasE = [m_CargasE;   iEst    2      L_Tr14      aux_vect(1:5) 0 aux_vect(6)];
        end
    end
end



%% Estados 5 y 6

iTr = [1 3 15 17 19 21 5;  % E5
       2 4 16 18 20 22 6]; % E6

for iEst = 1:2 % Estados 5 a 6
    if Estados(iEst+4)
        aux_vect = [];
        for j_iTr = 1:size(iTr,2)
            aux_vect = [aux_vect p_vnc(p_vnc(:,end)==iTr(iEst,j_iTr),1)*SepCerch];
        end
        m_CargasE = [m_CargasE;   iEst    2      L_Tr56      aux_vect];
    end
end

%% Estados 7 y 8: Cargas sobre cada cercha en sentido longitudinal

% Para cada estado de VPC, se determinan las cargas sobre cada cercha.
% Luego se busca aquella con resultante mayor y la misma se pasa al módulo
% de solicitaciones.
% (*N1): Para los Estados 7 y 8, las presiones siempre serán negativas
% (succión) y constantes a lo largo de toda una cercha, por lo que es
% válido sólo analizar aquella cercha que tiene mayor valor absoluto de
% carga.

%
CotaProgCercha = [0:SepCerch:L];%CotaPtos
AreaInflCercha = [SepCerch/2 repmat(SepCerch,1,numCerch-2) SepCerch/2];
CotaCargas = [h_med/2 h_med 2*h_med L];%
CotaCargasAbs = CotaCargas(1);
for i = 2:length(CotaCargas)
    CotaCargasAbs = [CotaCargasAbs CotaCargas(i)-CotaCargas(i-1)];
end

% Estado 7
Carga_VPC_E7_Cumb = 0;
Carga_VPC_E7_Col = 0;
if Estados(7)
    iTrE7 = [38 40 42 44]; % E7
    CargasE7 = [];
    for j = 1:length(iTrE7)
        CargasE7 = [CargasE7 p_vpc(p_vpc(:,end)==iTrE7(j))];
    end
    Carga_VPC_E7_Cumb = InterpCargas(CotaProgCercha,AreaInflCercha,CotaCargas,CargasE7);
    Carga_VPC_E7_Col = [p_vpc(p_vpc(:,end)==36)*SepCerch/2 repmat(p_vpc(p_vpc(:,end)==36)*SepCerch,1,numCerch-2) p_vpc(p_vpc(:,end)==36)*SepCerch/2];
    % Matriz de cargas
    % Nro de cercha con mayor valor absoluto de carga (*N1)
    [~,CerchNro]=max(abs(Carga_VPC_E7_Cumb));
    %                 E       SE    L1 P1
    m_CargasE = [m_CargasE; 7  CerchNro L_Tr78  Carga_VPC_E7_Col(CerchNro) 0 Carga_VPC_E7_Cumb(CerchNro) 0 0 0 Carga_VPC_E7_Col(CerchNro)];
end

% Estado 8
Carga_VPC_E8_Cumb = 0;
Carga_VPC_E8_Col = 0;
if Estados(8)
    iTrE8 = [39 41 43 45]; % E7
    CargasE8 = [];
    for j = 1:length(iTrE8)
        CargasE8 = [CargasE8 p_vpc(p_vpc(:,end)==iTrE8(j))];
    end
    Carga_VPC_E8_Cumb = InterpCargas(CotaProgCercha,AreaInflCercha,CotaCargas,CargasE8);
    Carga_VPC_E8_Col = [p_vpc(p_vpc(:,end)==37)*SepCerch/2 repmat(p_vpc(p_vpc(:,end)==37)*SepCerch,1,numCerch-2) p_vpc(p_vpc(:,end)==37)*SepCerch/2];
    % Matriz de cargas
    % Nro de cercha con mayor valor absoluto de carga (*N1)
    [~,CerchNro] = max(abs(Carga_VPC_E8_Cumb));
    %                 E       SE    L1 P1
    m_CargasE = [m_CargasE; 8  CerchNro  L_Tr78 Carga_VPC_E8_Col(CerchNro) 0 Carga_VPC_E8_Col(CerchNro) 0 0 0 Carga_VPC_E8_Col(CerchNro)];
end

% Medida del error, distinto de cero cuando en un solo tramo existen mas de
% dos saltos
% (sum(Carga_VPC_E7)-sum(CargasE7.*CotaCargasAbs))/sum(CargasE7.*CotaCargasAbs)*100

%% Recolección de datos
Data.Theta = theta;
Data.h_med = h_med;
Data.GCpi = GCpi;
keyboard
end
