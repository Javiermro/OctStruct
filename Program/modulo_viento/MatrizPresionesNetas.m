function [m_MatPresNet_vpc,m_MatPresNet_vnc,m_EtiqMatPresNet_vpc,m_EtiqMatPresNet_vnc,Estados] = MatrizPresionesNetas(z,L,B,theta,qz,GCpi,Estados,ModeloCerch,Flecha)
%
% Se arman matrices con todos los coeficientes necesarios para realizar la
% totalidad del cálculo de las presiones netas.
% Determinación del coeficiente Cp en función de los descrito en la Figura
% 3 del Reglamento CIRSOC 102 (Ed. 2005). pág. "Figuras 32".
% OutPut: N/m2

RelPlanta = L/B;
if (RelPlanta<=0)
    error('Error en dimensiones de planta de la estructura.')
end

% Nota '**' en la determinación del Cp para cubiertas
% Area para el viento normal a la cumbrera:
CoefArea_VNC = L*B/2;
if CoefArea_VNC <= 10
    n_Fact = 1;
elseif CoefArea_VNC > 10 && CoefArea_VNC < 100
    TabCoefArea = [10 25 100];
    TabFact = [1.0 0.9 0.8];
    n_Fact = interp1(TabCoefArea,TabFact,CoefArea_VNC);
elseif CoefArea_VNC >= 100
    n_Fact = 0.8;
end
Cp_Red_VNC = -1.3*n_Fact;

% Area para el viento paralelo a la cumbrera:
CoefArea_VPC = B*z(end)/2;
if CoefArea_VPC <= 10
    n_Fact = 1;
elseif CoefArea_VPC > 10 && CoefArea_VPC < 100
    TabCoefArea = [10 25 100];
    TabFact = [1.0 0.9 0.8];
    n_Fact = interp1(TabCoefArea,TabFact,CoefArea_VPC);
elseif CoefArea_VPC >= 100
    n_Fact = 0.8;
end

Cp_Red_VPC = -1.3*n_Fact;

%% Coeficientes de presión en paredes
% Paredes a barlovento
Cp_ParBar = 0.8;

% Paredes a sotavento viento paralelo a la cumbrera / viento normal a la
% pendiente
if RelPlanta<=1
    Cp_ParSot_pc = -0.5;
elseif RelPlanta>1 && RelPlanta<4
    LsobB = [1 2 4];
    Cp_neg = [-0.5 -0.3 -0.2];
    Cp_ParSot_pc = interp1(LsobB,Cp_neg,RelPlanta);
elseif RelPlanta>= 4
    Cp_ParSot_pc = -0.2;
end
% Paredes a sotavento viento normal a la cumbrera / viento paralelo a la
% pendiente
if (1/RelPlanta)<=1
    Cp_ParSot_nc = -0.5;
elseif (1/RelPlanta)>1 && (1/RelPlanta)<4
    LsobB = [1 2 4];
    Cp_neg = [-0.5 -0.3 -0.2];
    Cp_ParSot_nc = interp1(LsobB,Cp_neg,RelPlanta);
elseif (1/RelPlanta)>= 4
    Cp_ParSot_nc = -0.2;
end
% Paredes laterales
Cp_ParLat = -0.7;

%% Coeficientes de presión en cubiertas
HsobL = [0.25 0.5 1.0];
if any(ModeloCerch == [1 2 3 5 6])
    if theta > 45
        error('IMPORTANTE: Se consideran pendientes 0 <= theta <= 45°');
    end
    thetaBar = [10 15 20 25 30 35 45];
    RelAlt = z(end)/B;
    if any(Estados(1:4))
        % Viento normal a la cumbrera && theta >= 10
        % Armado de datos de las tablas: IMPORTANTE: Se consideran hasta 45°
        Cp_CubBarNegTab = [-0.7 -0.5 -0.3 -0.2 -0.2  0.0 0.0;
                           -0.9 -0.7 -0.4 -0.3 -0.2 -0.2 0.0;
                     Cp_Red_VNC -1.0 -0.7 -0.5 -0.3 -0.3 0.0];
        Cp_CubBarPosTab = [0.0 0.0 0.2 0.3 0.3 0.4 0.4;
            0.0 0.0 0.0 0.2 0.2 0.3 0.4;
            0.0 0.0 0.0 0.0 0.2 0.2 0.3];
        Cp_CubSotNegTab = [-0.3 -0.5 -0.6;
            -0.5 -0.5 -0.6;
            -0.7 -0.6 -0.6];
        if RelAlt <= 0.25
            Cp_CubBarNeg_nc = interp1(thetaBar, Cp_CubBarNegTab(1,:), theta);
            Cp_CubBarPos_nc = interp1(thetaBar, Cp_CubBarPosTab(1,:), theta);
            if theta >= 20
                Cp_CubSotNeg_nc = -0.6;
            else
                Cp_CubSotNeg_nc = interp1(thetaBar(1:3), Cp_CubSotNegTab(1,:), theta);
            end
        elseif RelAlt > 0.25 && RelAlt < 1
            [DatosCol, DatosFil] = meshgrid(thetaBar,HsobL);
            Cp_CubBarNeg_nc = interp2(DatosCol, DatosFil, Cp_CubBarNegTab, theta, RelAlt);
            Cp_CubBarPos_nc = interp2(DatosCol, DatosFil, Cp_CubBarPosTab, theta, RelAlt);
            if theta >= 20
                Cp_CubSotNeg_nc = -0.6;
            else
                [DatosCol, DatosFil] = meshgrid(thetaBar(1:3),HsobL);
                Cp_CubSotNeg_nc = interp2(DatosCol, DatosFil, Cp_CubSotNegTab, theta, RelAlt);
            end
        elseif RelAlt >= 1.0
            Cp_CubBarNeg_nc = interp1(thetaBar, Cp_CubBarNegTab(3,:), theta);
            Cp_CubBarPos_nc = interp1(thetaBar, Cp_CubBarPosTab(3,:), theta);
            if theta >= 20
                Cp_CubSotNeg_nc = -0.6;
            else
                Cp_CubSotNeg_nc = interp1(thetaBar(1:3), Cp_CubSotNegTab(3,:), theta);
            end
        end
    end
elseif ModeloCerch == 4
    RelAlt = z(end)/B;
    coef_r = Flecha/B;
    Cp_CubAboMitadCen_nc = -0.7 - coef_r;
    Cp_CubAboCuartSot_nc = -0.5;
    if coef_r < 0
        error('La relación entre flecha y luz es negativa. Revisar coeficientes')
    elseif 0 < coef_r && coef_r < 0.2
        Cp_CubAboCuartBarPos_nc = 0;
        Cp_CubAboCuartBarNeg_nc = -0.9;
        Estados([1,3]) = 0;
    elseif 0.2 <= coef_r && coef_r < 0.3
        Cp_CubAboCuartBarPos_nc = 1.5*coef_r - 0.3;
        Cp_CubAboCuartBarNeg_nc = 6*coef_r - 2.1;
        
    elseif 0.3 <= coef_r && coef_r <= 0.6
        Cp_CubAboCuartBarPos_nc = 0;
        Cp_CubAboCuartBarNeg_nc = 2.75*coef_r - 0.7;
        Estados([1,3]) = 0;
    elseif coef_r > 0.6
        error('La relación entre flecha y luz es mayor a la contemplada por el reglamento. No se proporcionan coeficientes de presión.')
    end
else
    error('Modelo de cercha incorrecto')
end

% Viento paralelo a la cumbrera y normal con theta<10
%               0 a h/2  ; h/2 a h  ;  h a 2h  ;  >2h
Cp_CubTab = [-0.9        -0.9       -0.5       -0.3;
    Cp_Red_VPC      -0.7       -0.7       -0.7];
if any(ModeloCerch == [5 6]) %ModeloCerch == 5
%     warning('va el modelo 6 igual al 5?')
    RelAlt = z(end)/L;
end
if RelAlt <= 0.5
    Cp_Cub_pt = Cp_CubTab(1,:);
elseif RelAlt > 0.5 && RelAlt < 1
    for i = 1:length(Cp_CubTab(1,:))
        Cp_Cub_pt(i) = interp1(HsobL(2:3), Cp_CubTab(:,i), RelAlt);
    end
elseif RelAlt >= 1
    Cp_Cub_pt = Cp_CubTab(2,:);
end

%% Matriz de presiones netas - Viento normal a la cumbrera

% Defino el qi = qh
qi = qz(end);

% El primer valor de z siempre va a corresponder a la pared a barlovento.
% Paredes a barlovento
%                     z   q     G     Cp      qi  GCpi     E1      E2     E3      E4    E5    E6     pi
m_MatPresNet_vnc = [z(1) qz(1) 0.85 Cp_ParBar qi  GCpi(1)  1        1      0       0     1   0       1;
                    z(1) qz(1) 0.85 Cp_ParBar qi  GCpi(2)  0        0      1       1     0   1       2];
% Se arma un vector con las etiquetas de lo guardado en 'm_MatPresNet_vnc'
m_EtiqMatPresNet_vnc{1,1} = {'Pared a barlovento'}; n_AcumEtiq = 2;
m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Pared a barlovento'}; n_AcumEtiq = n_AcumEtiq + 1;
if length(z) == 6
    % Si se cumple, el 2do valor del vector z tambien corresponde a la pared a
    % barlovento
    % Paredes a barlovento
    %        z    q     G     Cp      qi  GCpi      E1      E2      E3      E4    E5   E6   pi
    m_MatPresNet_vnc = [m_MatPresNet_vnc;
        z(2) qz(2) 0.85 Cp_ParBar qi  GCpi(1)    1        1      0       0     1   0    3;
        z(2) qz(2) 0.85 Cp_ParBar qi  GCpi(2)    0        0      1       1     0   1    4];
    m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Pared a barlovento'}; n_AcumEtiq = n_AcumEtiq + 1;
    m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Pared a barlovento'}; n_AcumEtiq = n_AcumEtiq + 1;
end
%            z    q     G     Cp      qi  GCpi      E1      E2      E3      E4    E5  E6  pi
m_MatPresNet_vnc = [m_MatPresNet_vnc;
    % Paredes a sotavento
    -1   qi    0.85 Cp_ParSot_nc qi  GCpi(1)     1        1      0       0     1   0    5;
    -1   qi    0.85 Cp_ParSot_nc qi  GCpi(2)     0        0      1       1     0   1    6;
    % Paredes a laterales
    -1   qi    0.85 Cp_ParLat    qi  GCpi(1)     1        1      0       0     1   0    7;
    -1   qi    0.85 Cp_ParLat    qi  GCpi(2)     0        0      1       1     0   1    8];
m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Pared a sotavento'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Pared a sotavento'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Pared lateral    '}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Pared lateral    '}; n_AcumEtiq = n_AcumEtiq + 1;
if any(ModeloCerch == [1 2 3 5 6]) %ModeloCerch == 1 || ModeloCerch == 2
    if any(Estados(1:4))
        % Cubierta a barlovento positivo
        %    z   q      G           Cp      qi  GCpi      E1      E2      E3     E4    E5  E6  pi
        m_MatPresNet_vnc = [m_MatPresNet_vnc;
            -1   qi    0.85 Cp_CubBarPos_nc qi  GCpi(1)    1      0       0      0     0   0  9;
            -1   qi    0.85 Cp_CubBarPos_nc qi  GCpi(2)    0      0       1      0     0   0  10;
            % Cubierta a barlovento negativo
            -1   qi    0.85 Cp_CubBarNeg_nc qi  GCpi(1)    0      1       0      0     0   0  11;
            -1   qi    0.85 Cp_CubBarNeg_nc qi  GCpi(2)    0      0       0      1     0   0  12;
            % Cubierta a sotavento
            -1   qi    0.85 Cp_CubSotNeg_nc qi  GCpi(1)    1      1       0      0     0   0 13;
            -1   qi    0.85 Cp_CubSotNeg_nc qi  GCpi(2)    0      0       1      1     0   0 14];
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta barlovento positivo'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta barlovento positivo'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta barlovento negativo'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta barlovento negativo'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta sotavento'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta sotavento'}; n_AcumEtiq = n_AcumEtiq + 1;
    else
        %    z   q      G           Cp   qi    GCpi      E1      E2      E3     E4    E5  E6  pi
        m_MatPresNet_vnc = [m_MatPresNet_vnc;
            -1   qi    0.85 Cp_Cub_pt(1) qi  GCpi(1)      1       1       0      0     1   0 15;
            -1   qi    0.85 Cp_Cub_pt(1) qi  GCpi(2)      0       0       1      1     0   1 16;
            -1   qi    0.85 Cp_Cub_pt(2) qi  GCpi(1)      1       1       0      0     1   0 17;
            -1   qi    0.85 Cp_Cub_pt(2) qi  GCpi(2)      0       0       1      1     0   1 18;
            -1   qi    0.85 Cp_Cub_pt(3) qi  GCpi(1)      1       1       0      0     1   0 19;
            -1   qi    0.85 Cp_Cub_pt(3) qi  GCpi(2)      0       0       1      1     0   1 20;
            -1   qi    0.85 Cp_Cub_pt(4) qi  GCpi(1)      1       1       0      0     1   0 21;
            -1   qi    0.85 Cp_Cub_pt(4) qi  GCpi(2)      0       0       1      1     0   1 22];
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta < h/2'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta < h/2'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta < h'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta < h'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta < 2*h'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta < 2*h'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta > 2*h'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cubierta > 2*h'}; n_AcumEtiq = n_AcumEtiq + 1;
    end
elseif ModeloCerch == 4 %3
        % Cuarto a barlovento positivo
        %    z   q      G                   Cp      qi  GCpi      E1      E2      E3     E4    E5  E6  pi
        m_MatPresNet_vnc = [m_MatPresNet_vnc;
            -1   qi    0.85 Cp_CubAboCuartBarPos_nc qi  GCpi(1)    1      0       0      0     0   0  46;
            -1   qi    0.85 Cp_CubAboCuartBarPos_nc qi  GCpi(2)    0      0       1      0     0   0  47;
        % Cuarto a barlovento negativo
            -1   qi    0.85 Cp_CubAboCuartBarNeg_nc qi  GCpi(1)    0      1       0      0     0   0  48;
            -1   qi    0.85 Cp_CubAboCuartBarNeg_nc qi  GCpi(2)    0      0       0      1     0   0  49;
         % Mitad central
            -1   qi    0.85 Cp_CubAboMitadCen_nc qi     GCpi(1)    1      1       0      0     0   0  50;
            -1   qi    0.85 Cp_CubAboMitadCen_nc qi     GCpi(2)    0      0       1      1     0   0  51;
        % Cuarto a sotavento
            -1   qi    0.85 Cp_CubAboCuartSot_nc qi     GCpi(1)    1      1       0      0     0   0  52;
            -1   qi    0.85 Cp_CubAboCuartSot_nc qi     GCpi(2)    0      0       1      1     0   0  53];
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cuarto a barlovento positivo'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cuarto a barlovento positivo'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cuarto a barlovento negativo'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cuarto a barlovento negativo'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Mitad Central'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Mitad Central'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cuarto a sotavento'}; n_AcumEtiq = n_AcumEtiq + 1;
        m_EtiqMatPresNet_vnc{1,n_AcumEtiq} = {'Cuarto a sotavento'}; n_AcumEtiq = n_AcumEtiq + 1;
end

%% Matriz de presiones netas - Viento paralelo a la cumbrera
% El primer valor de z siempre va a corresponder a la pared a barlovento.
% Paredes a barlovento
%                     z   q     G     Cp      qi  GCpi    E7    E8
m_MatPresNet_vpc = [z(1) qz(1) 0.85 Cp_ParBar qi  GCpi(1)  1     0  23;
                    z(1) qz(1) 0.85 Cp_ParBar qi  GCpi(2)  0     1  24;
                    z(2) qz(2) 0.85 Cp_ParBar qi  GCpi(1)  1     0  25;
                    z(2) qz(2) 0.85 Cp_ParBar qi  GCpi(2)  0     1  26;
                    z(3) qz(3) 0.85 Cp_ParBar qi  GCpi(1)  1     0  27;
                    z(3) qz(3) 0.85 Cp_ParBar qi  GCpi(2)  0     1  28;
                    z(4) qz(4) 0.85 Cp_ParBar qi  GCpi(1)  1     0  29;
                    z(4) qz(4) 0.85 Cp_ParBar qi  GCpi(2)  0     1  30];
m_EtiqMatPresNet_vpc{1,1} = {'Paredes a barlovento'}; n_AcumEtiq = 2;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Paredes a barlovento'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Paredes a barlovento'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Paredes a barlovento'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Paredes a barlovento'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Paredes a barlovento'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Paredes a barlovento'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Paredes a barlovento'}; n_AcumEtiq = n_AcumEtiq + 1;

if length(z) == 6
    % Si se cumple, el 2do valor del vector z tambien corresponde a la pared a
    % barlovento
    % Paredes a barlovento
    %            z    q     G     Cp      qi  GCpi
    m_MatPresNet_vpc = [m_MatPresNet_vpc;
        z(5) qz(5) 0.85 Cp_ParBar qi  GCpi(1)  1     0  32;
        z(5) qz(5) 0.85 Cp_ParBar qi  GCpi(2)  0     1  33];
    m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Paredes a barlovento'}; n_AcumEtiq = n_AcumEtiq + 1;
    m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Paredes a barlovento'}; n_AcumEtiq = n_AcumEtiq + 1;
end
m_MatPresNet_vpc = [m_MatPresNet_vpc;
    % Paredes a sotavento
    -1   qi    0.85 Cp_ParSot_pc qi  GCpi(1)  1     0  34;
    -1   qi    0.85 Cp_ParSot_pc qi  GCpi(2)  0     1  35;
    % Paredes a laterales
    -1   qi    0.85 Cp_ParLat    qi  GCpi(1)  1     0  36;
    -1   qi    0.85 Cp_ParLat    qi  GCpi(2)  0     1  37;
    % Cubierta
    -1   qi    0.85 Cp_Cub_pt(1) qi  GCpi(1)  1     0  38;
    -1   qi    0.85 Cp_Cub_pt(1) qi  GCpi(2)  0     1  39;
    -1   qi    0.85 Cp_Cub_pt(2) qi  GCpi(1)  1     0  40;
    -1   qi    0.85 Cp_Cub_pt(2) qi  GCpi(2)  0     1  41;
    -1   qi    0.85 Cp_Cub_pt(3) qi  GCpi(1)  1     0  42;
    -1   qi    0.85 Cp_Cub_pt(3) qi  GCpi(2)  0     1  43;
    -1   qi    0.85 Cp_Cub_pt(4) qi  GCpi(1)  1     0  44;
    -1   qi    0.85 Cp_Cub_pt(4) qi  GCpi(2)  0     1  45];
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Paredes a sotavento'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Paredes a sotavento'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Paredes laterales'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Paredes laterales'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Cubierta'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Cubierta'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Cubierta'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Cubierta'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Cubierta'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Cubierta'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Cubierta'}; n_AcumEtiq = n_AcumEtiq + 1;
m_EtiqMatPresNet_vpc{1,n_AcumEtiq} = {'Cubierta'}; n_AcumEtiq = n_AcumEtiq + 1;

if sum(Estados([3,4,6,8])) == 0
    m_MatPresNet_vnc = m_MatPresNet_vnc(1:2:end,:);
    m_MatPresNet_vpc = m_MatPresNet_vpc(1:2:end,:);
end

end