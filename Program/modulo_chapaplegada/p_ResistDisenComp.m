function Pn = p_ResistDisenComp(Datos)
%
% Funcion para la determinación de resistencia de diseño. Tipos de cálculo:
% Resistencia de diseño a la compresión axil. C.303 C.4

% Recolección de datos
Fn = Datos.Fn;
Aefect = Datos.Aefect;

%% Resistencia de diseño a la compresión axil
fic = 0.85;
Pn = fic * Aefect * Fn * 0.1;
Pn = 0.101972 * Pn; % Pasaje a toneladas
end