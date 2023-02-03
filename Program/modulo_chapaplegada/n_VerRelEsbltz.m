function [Verificaciones] = n_VerRelEsbltz(Datos)
%
% Verificación de las relaciones de esbeltez: Relaciones máximas entre
% ancho plano y espesor de elementos comprimidos. Sección 13.2.1.(a) pág
% 293

% Extracción de datos
PerfilTipo = Datos.PerfilTipo; a = Datos.a; b = Datos.b;
c = Datos.c; t = Datos.t;
Analisis = Datos.Analisis;

% Cálculo de coeficientes según el tipo de análisis
switch Analisis
    case 'CompSimple'
        CoefEsbAlma = 500;
    case 'FlexEjMay'
        CoefEsbAlma = 200;
end

%% Verificación de las esbelteces
switch PerfilTipo
    case {'C','G'}
        % Esb_Alm: Caso (2) g 18. Elem.Comp. Rigid.
        Verificaciones.V_RelEsbALMA = true*(a/t < CoefEsbAlma)+false*(a/t > CoefEsbAlma);
        % Esb_Ala: Caso (1) pág. 18. Labio simple
        Verificaciones.V_RelEsbALA = true*(b/t < 60)+false*(b/t > 60);
        % Esb_Labio: Caso (3) g 18. Elem.Comp. NO Rigid.
        Verificaciones.V_RelEsbLABIO = true*(c/t < 60)+false*(c/t > 60);
    case 'U'
        % Esb_Ala: Caso (3) g 18. Elem.Comp. NO Rigid.
        Verificaciones.V_RelEsbALA = true*(c/t < 60)+false*(c/t > 60);
        % Esb_Alm: Caso (2) g 18. Elem.Comp. Rigid.
        Verificaciones.V_RelEsbALMA = true*(a/t < CoefEsbAlma)+false*(a/t > CoefEsbAlma);
end

%% Impresión de verificaciones no cumplidas
if ~any([Verificaciones.V_RelEsbALMA, Verificaciones.V_RelEsbALA, Verificaciones.V_RelEsbLABIO])
    print('Incumplimiento de una o más relaciones de esbeltez')
    if ~Verificaciones.V_RelEsbALMA
        print(['Esbeltez ALMA: a/t =' num2str(a) '/' num2str(t) '=' num2str(a/t) '>' num2str(CoefEsbAlma)])
    elseif ~Verificaciones.V_RelEsbALA
        print(['Esbeltez ALA: b/t =' num2str(b) '/' num2str(t) '=' num2str(b/t) '> 60'])
    elseif ~Verificaciones.V_RelEsbLABIO
        print(['Esbeltez LABIO: c/t =' num2str(c) '/' num2str(t) '=' num2str(c/t) '> 60'])
    end
    error('Se detiene el cálculo al no verificar una o mas relaciones de esbeltez.')
end

end
