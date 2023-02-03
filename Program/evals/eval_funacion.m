function test_fundac
%
%

H = 630; % [cm] Altura de la cabeza de la columna.
t = 160; % [cm] Altura de la base de hormigón.
a = 80; % [cm] Lado de la base de hormigón, normal a cumbrera.
b = 80; % [cm] Lado de la base de hormigón, paralelo a cumbrera.
ac = 30; % [cm] Lado de la columna de hormigón, normal a cumbrera.
bc = 20; % [cm] Lado de la columna de hormigón, paralelo a cumbrera.
PP_Est = 561; % [kg] Peso propio de la estructura de cercha y techo.
FzaV = 1200; % [kg] Carga vertical producida por el estado de viento analizado, 
             % puede ser de tracción o compresión.
FzaH = 300; % [kg] Carga horizontal en la cabeza de columna producida por el estado
            % de viento analizado.
C = 5; % Coeficiente de Balasto a 2mts de profundidad[kg/cm3]
tgAlpha = 0.01; % Valor adoptado del giro permitido de la base.
PesEspHA = 2500; % [kg/m3] Peso especifico del HºAº.
GammaMin = 1.5; % Mínima relación entre los momentos dados por Sulzberguer 
                % y el momento de volcamiento.

fprintf('Inicio de análisis al volcamiento de la fundación, según la teoría de Sulzberguer: \n')
Mensaje1 = FundacSulzberguer(H,C,t,tgAlpha,a,b,ac,bc,PesEspHA,PP_Est,FzaV,FzaH,GammaMin);
if Mensaje1
    fprintf('La fundación verifica al volcamiento. \n')
else
    fprintf('La fundación NO VERIFICA al volcamiento. \n')
end

fprintf('Inicio de análisis al arrancamiento de la fundación: \n')

Mensaje2 = FundacArranc(H,t,a,b,ac,bc,PesEspHA,PP_Est,FzaV);
if Mensaje2
   fprintf('La fundación verifica al arrancamiento. \n')
else
   fprintf('La fundación NO VERIFICA al arrancamiento. \n')
end


end