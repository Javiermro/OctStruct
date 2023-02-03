function Datos = n_AnchoEfect(Datos)
%
% Determinación de anchos efectivos de elementos comprimidos para
% resistencia
wfbwrgbwqrthqr
% Extracción de datos
Cp = Datos.Cp;
a = Datos.a;
A = Datos.Ap;
b = Datos.b;
B = Datos.Bp;
c = Datos.c;
t = Datos.t;
r = Datos.r;
Is_E1 = Datos.Is_E1;
Poi = Datos.Poi;
Fy = Datos.Fy; E = Datos.E; Fn = Datos.Fn;
Analisis = Datos.Analisis; PerfilTipo = Datos.PerfilTipo;
Area = Datos.Area;
%% Elemento 1 - Rigidizador
switch Analisis
    case 'CompSimple'
        %Elemento no rigidizado uniformemente comprimido
        % C.303.Sec.B.3.1
        % "f se adopta igual a Fn de acuerdo con lo determinado en los artículos
        % C.4..."
        f = Fn;
        k = 0.43;
        Fcr = k*(pi()^2*E)/(12*(1-Poi^2))*(t/c)^2;
        lambda_E1 = sqrt(f/Fcr);
        rho_E1 = (1-0.22/lambda_E1)/lambda_E1;
        be_E1 = (lambda_E1 <= 0.673) * c + (lambda_E1 > 0.673) * rho_E1*c;
    case 'FlexEjMay'
        %Elemento no rigidizado con tensiones linealmente variables
        % C.303.Sec.B.3.2. pág 26
        f = 235; % [MPa]
        k = 0.43;
        Fcr = k*(pi()^2*E)/(12*(1-Poi^2))*(t/c)^2;
        lambda_E1 = sqrt(f/Fcr);
        rho_E1 = (1-0.22/lambda_E1)/lambda_E1;
        be_E1 = (lambda_E1 <= 0.673) * c + (lambda_E1 > 0.673) * rho_E1*c;
end
% Efectividad del elemento
efec_1 = (be_E1 == c);

%% Elemento 2 - Pliegue: Es todo efectivo por ser el pliegue de la sección transversal
be_E2 = pi()*r/2;

%% Elemento 3 - Ala
switch Analisis
    case {'CompSimple','FlexEjMay'}
        %Elemento uniformemente comprimido con rigidizador de borde
        % C.303.Sec.B.4.2
        S = 1.28*sqrt(E/f);
        if b/t > 0.328*S
            Ia_E1 = min([399*t^4*((b/t)/S-0.328)^3,t^4*(115*((b/t)/S)+5)]);
            RI = min([Is_E1/Ia_E1,1]);
            n = max([(0.582-(b/t)/(4*S)),1/3]);
            % Determinación del coeficientes de abolladura k (Tabla B.4-1)
            k_E3 = (Cp/b < 0.25) * min([((3.57*RI)^n+0.43),4]) ...
                + (0.25 < Cp/b)*(Cp/b < 0.8) * min([((4.82-5*Cp/b)*RI^n+.43),4]);
            Fcr = k_E3*pi()^2*E/(12*(1-Poi^2))*(t/b)^2; % [MPa]
            lambda_E3 = sqrt(f/Fcr);
            rho_E3 = (1-0.22/lambda_E3)/lambda_E3;
            be_E3 = (lambda_E3 <= 0.673) * b + (lambda_E3 > 0.673) * rho_E3*b;
            be_E1 = be_E1*RI;
            %be2 = be_E3-be1;
            if be_E3 == b && RI == 1
                % El elemento 3 es totalmente efectivo
            end
        else
            Ia_E1 = 0; % No se requiere rigidizador de borde
            be_E3 = b;
            %be1 = b/2;
            %be2 = b/2;
        end
end
efec_3 = (be_E3 == b);
%% Elemento 4 - Alma
switch Analisis
    case {'CompSimple'}
        % Elemento rigidizado uniformemente comprimido
        k_E4 = 4;
        Fcr_E4 = k_E4*(pi()^2*E)/(12*(1-Poi^2)) * (t/a)^2;
        lambda_E4 = sqrt(f/Fcr_E4);
        rho_E4 = (1-.22/lambda_E4)/lambda_E4;
        be_E4 = (lambda_E4 <= 0.673) * a + (lambda_E4 > 0.673) * rho_E4*a;
    case {'FlexEjMay'}
        % Elemento rigidizado con tensiones linealmente variables
        Psi = 1; % Flexión simple
        k_E4 = 4+2*(1+Psi)^3 + 2*(1+Psi);
        f = Fy*(a/2)/(A/2);
        Fcr = k_E4*pi()^2*E/(12*(1-.3^2))*(t/a)^2;
        lambda_E4 = sqrt(f/Fcr);
        rho_E4 = (1-.22/lambda_E4)/lambda_E4;
        bee = rho_E4*a;
        if A/B <= 4
            be1 = bee/(3+Psi);
            be2 = (Psi>0.236) * (bee/2) + (Psi<=.236) * (bee-be1);
            if (be1+be2) > (a/2)
                be_E4 = (a/2); %alma totalmente efectiva
            else
                be_E4 = be1 + be2;
            end
            % warning('Falta verificar el maximo de be1+be2')
        else
            be1 = bee / (3+Psi);
            be2 = bee / (1+Psi) - be1;
            be_E4 = be1 + be2;
        end
end
efec_4 = (be_E4 == a/2);
%% Área efectiva
% El área efectiva se determinará sumando todas las áreas efectivas
% determinadas para cada elemento.
switch PerfilTipo
    case {'C','G'}
        Aefect = t* (2*be_E1 + 4*be_E2 + 2*be_E3 + 2*be_E4);
    case 'U'
        Aefect = t* (2*be_E2 + 2*be_E3 + 2*be_E4);
end

if (Aefect-Area)<1e-4 && (efec_1+efec_3+efec_4==3)
%     disp('Perfil totalmente efectivo')
elseif Aefect==Area && (efec_1+efec_3+efec_4~=3)
    error('*** Hay un problema en el cálculo de la efectividad de la sección')
%     keyboard
else
%     disp('Perfil parcialmente efectivo')
    if strcmp(Datos.Analisis,'FlexEjMay')
        keyboard
        Datos = PropGeomFlex(Datos);
    end
end

%% Recopilación de datos
%Datos.be_E1 = be_E1; Datos.be_E2 = be_E2; Datos.be_E3 = be_E3; Datos.be_E4 = be_E4;
Datos.Aefect = Aefect;

end
