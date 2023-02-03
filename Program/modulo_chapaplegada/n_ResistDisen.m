function [Pn,Md_1,Md_2,Md_2b,Vd,Pd_1,Pd_2] = n_ResistDisen(Datos)
%
% Determinación de resistencia de diseño. Tipos de cálculo:
% Resistencia de diseño a la compresión axil. C.303 C.4
% Resistencia de diseño a la flexión simple. C.303 C.3.1
%   Viga lateralmente arriostrada en forma contínua.
% Pn,Md_2,Md_2b,Vd,Pd_1,Pd_2
% Recolección de datos
Fn = Datos.Fn;
Aefect = Datos.Aefect;
Area = Datos.Area; PerfilTipo = Datos.PerfilTipo;
Sx = Datos.Sx; Sy = Datos.Sy; Fy = Datos.Fy; ky = Datos.ky; kt = Datos.kt;
Ly = Datos.Ly; E = Datos.E; G = Datos.G; J = Datos.J; ry = Datos.ry;
r0 = Datos.r0; Cw = Datos.Cw; c = Datos.c; Iyc = Datos.Iyc;
m = Datos.m; Ap = Datos.Ap; a = Datos.a; t = Datos.t; Poi = Datos.Poi;
Nap = Datos.Nap; Ntr = Datos.Ntr; R = Datos.R;
L_Ntr = Datos.L_Ntr; theta = Datos.theta;

%% Inicialización de datos
Pn = []; % Resistencia de diseño a la compresión simple
Md_1 = []; % Resistencia de diseño a la flexión para elementos arriostrados en toda su longitud.
Md_2 = []; % Resistencia de diseño a la flexión para elementos arriostrados en los tercios de la luz.
Md_2b = []; % IDEM anterior, con corrección de aplicación de cargas en el eje y
Vd = []; % Resistencia de diseño al esfuerzo de corte.
Pd_1 = []; % Resistencia de diseño al pandeo localizado del alma - Reacción en el apoyo.
Pd_2 = []; % Resistencia de diseño al pandeo localizado del alma - Carga concentrada en el tramo.
%% Resistencia de diseño a la compresión axil
switch Datos.Analisis
    case {'CompSimple'}
        fic = 0.85;
        Pn = fic * Aefect * Fn * 0.1; % [kN]
        Pn = 0.101972 * Pn; % Pasaje a toneladas
    case {'FlexEjMay'}
        %% Resistencia de diseño a la flexión simple
        % a) Para viga lateralmente arriostrada en forma continua. Procedimiento I
        switch PerfilTipo
            case {'C','G'}
                phib = 0.95; % Sección con ala comprimida rigidizada total o parcialmente.
            case 'U'
                phib = 0.90; % Sección con ala comprimida no rigidizada.
        end
        if (Area-Aefect)<1e-4 % se alcanza Fy en ambas fibras extremas
            Mn = Sx*Fy*10^-3;
            % Resistencia nominal de secciones lateralmente arriostradas en
            % forma continua.
            Md_1 = phib*Mn;
        else
            error('Correas: *** Area efectiva < 100%, REDIMENSIONAR***')
        end
        % b) Resistencia al pandeo lateral torsional Determinación de la tensión
        % crítica a pandeo lateral (Fc)
        % Teniendo en cuenta long total
        L(1) = Ly;
        Mmax1 = 1;
        MA1 = 0.75;
        MB1 = 1;
        MC1 = 0.75;
        Cb(1) = 12.5*Mmax1 /(2.5*Mmax1+3*MA1+4*MB1+3*MC1);
        % Teniendo en cuenta long total/2
        L(2) = Ly/2;
        Mmax2 = 1;
        MA2 = 0.438;
        MB2 = 0.75;
        MC2 = 0.938;
        Cb(2) = 12.5*Mmax2 /(2.5*Mmax2+3*MA2+4*MB2+3*MC2);

        L(3) = Ly/3;
        Mmax3 = 1;
        MA3 = 0.97;
        MB3 = 1;
        MC3 = 0.97;
        Cb(3) = 12.5*Mmax3 /(2.5*Mmax3+3*MA3+4*MB3+3*MC3); % Teniendo en cuenta long total
        % Cálculo de la tensión elástica del pandeo lateral (pandeo flexional respecto de eje "y")
        % Ec. C.3.1.2.1-8 pág. 42
        sig_ey = pi()^2 .* E ./(ky.*L./ry).^2;
        sig_t = 1./(Area.*r0^2).*(G.*J+pi().^2.*E.*Cw./(kt*L).^2);
        Fe(:,1) = Cb.*r0*Area/Sx.*sqrt(sig_ey.*sig_t);
        Fe(:,2) = Cb.*pi()^2*E*(10*c)*Iyc./(Sx*(ky*L).^2);
        for i=1:length(Fe(:,1))
            if Fe(i,1)<0.56*Fy
                Fc(i,1) = Fe(i,1);
            elseif 0.56*Fy<Fe(i,1) && Fe(i,1)<2.78*Fy
                Fc(i,1) = 10/9*Fy*(1-10*Fy/36/Fe(i,1));
            elseif Fe(i,1)>2.78*Fy
                Fc(i,1) = Fy;
            else
                error('*** El Fc no pudo ser calculado')
            end
            
            if Fe(i,2)<0.56*Fy
                Fc(i,2) = Fe(i,2);
            elseif 0.56*Fy<Fe(i,2) && Fe(i,2)<2.78*Fy
                Fc(i,2) = 10/9*Fy*(1-10*Fy/36/Fe(i,1));
            elseif Fe(i,2)>2.78*Fy
                Fc(i,2) = Fy;
            else
                error('*** El Fc no pudo ser calculado')
            end
        end
        C1 = 7.72/Area/E*(ky.*Fy.*Sx./(Cb*pi()*ry)).^2;
        C2 = pi()^2*E*Cw/(kt).^2;
        % Proc (a) Tensión elástica crítica a pandeo lateral-torsional (F e ).
        % Sección de simetría simple y flexión alrededor del eje de simetría.
        Lu(:,1) = [(G*J./2./C1+(C2./C1+(G*J./2./C1).^2).^.5).^0.5]';
        % Proc (b) Tensión crítica elástica a pandeo lateral (Fe) según
        % C303 - C.3.1.2.1(b). Sección C de simetría simple; flexión alrededor del
        % eje baricéntrico normal al alma.
        Lu(:,2) = [(0.36.*Cb.*pi()^2*E*(10*c)*Iyc./(Fy*Sx)).^0.5]';

        % Determinación de la Resistencia de Diseño a pandeo lateral torsional
        % warning('Resistencia de diseño al pandeo lateral torsional:\n Se utilizan los valores obtenidos en el procedimiento (b)\n por ser mas conservadores en el campo elástico.')
        fprintf('    Consideraciones para la resistencia de diseño al pandeo lateral torsional:\n      Sección totalmente efectiva. \n      Longitud arriostrada a un tercio de la luz.\n')
        phi_b = 0.90;
        Mn = Sx.*Fc(:,2).*(10^-3); % [kNm]
        Md = phi_b.*Mn;
        Md_2 = Md(3);
        % Para cargas que no pasan por el centro de corte se debe aplicar un factor
        % de reducción R0: Torsión producida entre puntos lateralmente arriostrados
        % para Flexión Simple.
        % Se suponen las cargas aplicadas en el alma:
        R0(1) = Ap*Sy/(Ap*Sy+2*m*Sx);
        R0(2) = 2*Ap*Sy/(2*Ap*Sy+m*Sx);
        R0(3) = Ap*Sy/(Ap*Sy+.2*m*Sx);
        Md_R0 = Md.*R0';
        Md_2b = Md_R0(3); % [kNm]

        %% Resistencia de diseño al corte
        kv = 5.34; % Alma no rigidizada.
        if 0 < a/t && a/t <= sqrt(E*kv/Fy)
            Fv = 0.6*Fy;
        elseif a/t > sqrt(E*kv/Fy) && a/t <= 1.51*sqrt(E*kv/Fy)
            Fv = 0.6*sqrt(E*kv*Fy)/(a/t);
        elseif a/t > 1.51*sqrt(E*kv/Fy)
            Fv = pi()^2*E*kv/(12*(1-Poi^2)*(a/t)^2);
        else
            error('')
        end
        Aw = a*t;% Área del alma de la barra.
        Vn = Aw .* Fv .* (10^-1);
        phi_v = 0.95;
        Vd = phi_v.*Vn; % [kN]
        
        %% Resistencia de diseño a pandeo localizado del alma
        % Alma sin perforaciones. Cargas concentradas.
        % -> Reacción sobre apoyo
        % Verificaiones de condicionamientos para el uso de la tabla C.3-3.
        if Nap < 2
            warning('*** La longitud de apoyo seleccionada no es suficiente ***')
            Verif(1) = 0;
        else
            Verif(1) = 1;
        end
        if a/t < 200, Verif(2) = 1;else, Verif(2) = 0; end
        if Nap/t < 210, Verif(3) = 1;else, Verif(3) = 0; end
        if Nap/a < 2, Verif(4) = 1;else, Verif(4) = 0; end
        if R/t < 9, Verif(5) = 1;else, Verif(5) = 0; end % Este caso corresponde a un límite "interior" de la tabla
        if any(Verif==0)
            error('*** El perfil seleccionado no cumple con las condiciones para el uso de la tabla C.3-3')
        end
%         warning('Los coeficientes obtenidos de la tabla C.3-3 aún no están automatizados')
        C = 4;
        CR = 0.14; CN = 0.35; Ch = 0.02; phi_w = 0.85;
        Pn = C*t^2*Fy*sin(theta)*(1-CR*sqrt(R/t))*(1+CN*sqrt(Nap/t))*(1-Ch*sqrt(a/t))*10^(-1);
        Pd_1 = phi_w * Pn; % [kN]
        % -> Para carga concentrada en el tramo
        if Ntr < 2
            warning('*** La longitud de apoyo seleccionada para la carga puntual no es suficiente ***')
            Verif(1) = 0;
        else
            Verif(1) = 1;
        end
        if L_Ntr > 1.5*a
            CargInt = 1;
        else
            CargInt = 0;
        end
%         warning('Siempre se supone ala unida al apoyo.')
%         warning('Siempre se supone carga sobre un ala.')
        C = 13; CR = 0.23; CN = 0.14; Ch = 0.01; phi_w = 0.90;
        Pn = C*t^2*Fy*sin(theta)*(1-CR*sqrt(R/t))*(1+CN*sqrt(Nap/t))*(1-Ch*sqrt(a/t))*10^(-1);
        Pd_2 = phi_w * Pn; % [kN]
end

end
