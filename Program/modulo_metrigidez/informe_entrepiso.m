function  informe(Prob_data,Design) 
%%
% *4.- Análisis de cargas*
%
% De acuerdo con el artículo A.4.3 del CIRSOC 303-2009 la resistencia requerida de la estructura y de sus distintos
% componentes estructurales se determinará a partir de la combinación de acciones mayoradas más desfavorables. Se
% tendrá en cuenta que muchas veces la mayor resistencia requerida resulta de una combinación en que una o más
% acciones no están actuando.
fprintf('1.2·D + 1.6·Lr + 0.8·W    (A.4.3-3) \n');
fprintf('1.2·D + 1.6·W + f1·Lr     (A.4.3-4) (1)\n');
fprintf('%1.2f·D + %1.2f·W          (A.4.3-6) (2)\n',[Prob_data.Cargas.Factor(1) Prob_data.Cargas.Factor(2)]);
%%
% (1) f1 = 0,5 para otras configuraciones de cargas según el artículo A.4.3
% del CIRSOC 303-2009.
%
% (2) Se podrá usar 1,5 como factor de carga para viento (W) cuando se
% consideren las velocidades básicas de viento _V_ del reglamento CIRSOC
% 102-2005.


%%
% Analizando la combinación de cargas de la expresión (A.4.3-3), que tiene en cuenta una sobrecarga de uso por montaje o
% reparaciones más la carga de viento obtenida en función de una ráfaga de viento de 50 años de recurrencia, se llega a la
% conclusión de su poca probabilidad de ocurrencia y a fin de maximizar la eficiencia de la estructura se considera como
% carga de diseño a la determinada por la expresión (A.4.3-6).

%%
% Se procederá a la alineación de las cargas sobre las correas
% cuya separación es:
fprintf('SepCorreas = %1.2fm\n', Prob_data.Geom.lc);
%%
% Se considera la presión global del viento sobre la estructura.
%
% _*4.1.- Determinación de D:*_
%
% Peso Propio de cubiertas de chapas:
fprintf('PPcub = %1.2fN/m²·%1.2fm = %1.2fN/m\n', [Prob_data.Cargas.PPCub Prob_data.Geom.lc Prob_data.Cargas.PPCub*Prob_data.Geom.lc]);
%%
% Peso Propio de correas:
Area = p_PropGeomArea(Prob_data.Predim.CO) ; % en cm^2
PPcor = Area*(1/10000)*Prob_data.Mat.Acero.PesEsp*1000  ; %PesEsp en [kN/m^3]
fprintf('PPcorr = %1.2fN/m\n',PPcor);
%%
% Peso total:
PesoTotal = PPcor+Prob_data.Cargas.PPCub*Prob_data.Geom.lc;
fprintf('D = %1.2fN/m·cos(%1.1f) = %1.2f N/m',[PesoTotal atand(Prob_data.Geom.pend(1)) PesoTotal*cosd(atand(Prob_data.Geom.pend(1)))]);

%%
%
% *5- Solicitaciones en las correas.*
%
% Se presentan a continuación las solicitaciones para el caso de carga
% concentrada y un caso de solicitación por carga de viento.
%
% _*5.1.- Carga Puntual en tramo exterior.*_
%
% <<Fig_Correas_Mf1.png>>
% 
% <<Fig_Correas_Q1.png>>
%
%%
% _*5.2.- Carga Puntual en tramo interior.*_
%
% <<Fig_Correas_Mf2.png>>
%
% <<Fig_Correas_Q2.png>>
%

%%
% _*5.3.- Carga de viento en correas.*_
%
% <<Fig_Correas_Mf3.png>>
%
% <<Fig_Correas_Q3.png>>
%

%%
% *6.- Dimensionamiento y verificación de las correas de la estructura*
%
% Se procede a la verificación de un perfil abierto C según los requerimientos establecidos 
% por la norma CIRSOC 303-2009 para la resistencia a la flexión y a corte para las 
% solicitaciones de la carga de diseño y la resistencia de diseño a carga concentrada. 
%
% <<Perfil-C.png>>
%
% Fig: Esquema del perfil adoptado para correas.
fprintf('Perfil %s\n',[Prob_data.Predim.CO]) 

%%
% Propiedades del perfil:
fprintf('B = %1.1fmm    t = %1.0fmm\n',[Design.CO.Bp*10 Design.CO.t*10])
fprintf('R = %1.2fmm    Ht = %1.0fmm\n',[Design.CO.r*10 Design.CO.Ap*10])
fprintf('A = %1.2fcm²\n',[Design.CO.Area])
fprintf('Ixx = %1.2fcm⁴  Iyy = %1.2fcm⁴\n',[Design.CO.Ix Design.CO.Iy])
fprintf('rx = %1.2fcm    ry = %1.2fcm\n',[Design.CO.rx Design.CO.ry])
fprintf('Cw = %1.2fcm⁶  J = %1.2fcm⁴\n',[Design.CO.Cw Design.CO.J])
fprintf('x0 = %1.2fcm    r0 = %1.2fcm\n',[Design.CO.x0 Design.CO.r0])
%%
% 1) Verificación de la relación de esbeltez
%
% *Elemento 1 - Alma*:
fprintf('h/t = %1.0f   <  500 B.C.\n',Design.CO.a/Design.CO.t) 
%%
%
% *Elemento 2 - Ala*:
fprintf('d/t = %1.0f   <  60 B.C.\n',Design.CO.b/Design.CO.t) 
%%
%
% *Elemento 3 - Labio*:
if Design.CO.Tipo == 'C'
    fprintf('b1/t = %1.2f   <  60 B.C.\n',Design.CO.c/Design.CO.t) 
elseif Design.CO.Tipo == 'U'
    fprintf('No corresponde.\n') 
end
%%
%
% 2) Verificación de la efectividad de la sección
%
% En función de los Arts. B.2.1, B.3.1 y B.4.2 se determina lo siguiente
% con respecto a la efectividad de la sección del perfil:
%
%
if Design.CO.Area >= Design.CO.Aefect
    fprintf('El área del perfil A = %1.2fcm² es totalmente efectiva.\n', Design.CO.Area) 
elseif Design.CO.Area < Design.CO.Aefect
    fprintf('El área efectiva del perfil es Aefec = %1.2fcm², menor al área total A = %1.2fcm².\n', [Design.CO.Aefect Design.CO.Area]) 
end
%%
% 3) Resistencia de diseño a la flexión.
%
% a) Resistencia nominal por viga lateral arriostrada en forma continua sección 
% totalmente efectiva y con sección transversal simétrica respecto al eje
% de flexión. (Art. C.3.1.1)
fprintf('Md = Mn·Ø = %1.2fkNm > Mmáx = %1.2fkNm  B.C.\n',[Design.CO.Mmax(2) Design.CO.Mmax(1)])
%%
%
% b) Resistencia al pandeo lateral torsional. (Art. C.3.1.1): Se adopta arriostramientos a los tercios de la luz.
fprintf('Md = Øb·Mn = 0.9·Sc·Fc·0.001 = %1.2fkNm > Mmáx = %1.2fkNm  B.C.\n',[Design.CO.Mmin(2) Design.CO.Mmin(1)])
%%
% *Aclaración:* Para la resistencia al Pandeo Lateral Torsional se tomó a la
% correa como arriostrada (inferiormente) en los tercios de la luz. Además
% se realizó una reducción del Mmáx de trabajo, al considerar una
% corrección por cargas no aplicadas en el centro de corte de la sección
% (Ver _'Estructuras de Acero,  Parte II - Gabriel Troglia'_ Ej.n°9, Pág.
% 77.)
%%
%
% 4) Resistencia de Diseño al corte. (Art. C.3.2.1)
%
fprintf('Vd = Øv·Vn = 0.95·Aw·Fv·0.01 = %1.2fkN > Vmáx = %1.2fkN  B.C.\n',[Design.CO.Qmax(2) Design.CO.Qmax(1)])
%%
%
% 5) Resistencia de diseño al pandeo localizado en el alma.
%
% Se realiza el siguiente análisis para cargas concentradas de uso de 1Kn para 
% almas sin perforaciones (Art. C.3.4.1.)
%
% a) Reacción en el apoyo 
% El ala se encuentra unida al apoyo y se considera una longitud de apoyo igual a 4cm, 
% y la distancia entre el borde del apoyo al extremo de la barra igual a 1,5h = 16,8cm.
if Design.CO.Rmax(2) > Design.CO.Rmax(1)
    fprintf('Pd = ØN·PN = %1.2fkN > %1.2fkN  B.C.\n',[Design.CO.Rmax(2) Design.CO.Rmax(1)])
else
    fprintf('Pd = ØN·PN = %1.2fkN < %1.2fkN  M.C. ?\n',[Design.CO.Rmax(2) Design.CO.Rmax(1)])
    fprintf('Se debe realizar un refuerzo al perfil en el apoyo para evitar el pandeo localizado.\n')
end
%%
% 6) Verificación de las deformaciones en estado de servicio. (Art.
% A.4.4.)
%
% Se verifica con carga de servicio:
if Design.CO.flecha(1) < Design.CO.flecha(2)
    fprintf('fx = %1.2fcm < %1.2fcm = fmáx = L/250   B.C.\n',[Design.CO.flecha(1) Design.CO.flecha(2)])
else
    fprintf('fx = %1.2fcm > %1.2fcm = fmáx = L/250   Malas condiciones de deformación   ?\n',[Design.CO.flecha(1) Design.CO.flecha(2)])
end

%%
% *7.- Cálculo de las solicitaciones de los elementos de la cercha y las
% columnas.*
% 
% <<Fig_struture.png>>
%
% En la siguiente tabla se detallan los elementos que conforman la cercha
% con los perfiles adoptados para cada caso.
% También se detallan los máximos esfuerzos en cada
% cordón, con los cuales serán verificados.
%
idx = 0:10:length(Prob_data.Tablas.TracMax);
Encabezado = '|Barra |      Perfil      | Long.[m] |Comp.Máx.[N]|Trac.Máx[N]|\n';
fprintf(Encabezado);
for i=1:length(Prob_data.Tablas.TracMax)
     fprintf('| %s  |  %s  |  %1.2f    |   %1.0f    |    %1.0f   |\n',[ Prob_data.Tablas.Ubic(i)  Prob_data.Tablas.Secciones(i) Prob_data.Tablas.Long(i) Prob_data.Tablas.CompMax(i) Prob_data.Tablas.TracMax(i)]);
     if ~mod(i,10)
         fprintf(' \n');
         fprintf(Encabezado);
     end
end
fprintf(Encabezado);
%%
% 
% *8.- Dimensionamiento de la cercha*
%
% _*8.1.- Verificación del cordón superior.*_
%
% Se procede a la verificación del perfil adoptado según los requerimientos
% establecidos por la norma CIRSOC 303-2009 para la resistencia a la
% compresión axil.
if Design.CS.Tipo == 'U'
    copyfile ./Informe/Perfil-U.png ./Informe/perfilCS.png 
elseif Design.CS.Tipo == 'G'
    copyfile ./Informe/Perfil-G.png ./Informe/perfilCS.png 
end
%%
% <<perfilCS.png>>
%
% Fig: Esquema del perfil adoptado para el cordón superior.
%
% Propiedades del perfil:
if Design.CS.Tipo == 'G'
    fprintf('B = %1.1fmm    t = %1.0fmm\n',[Design.CS.Bp*10 Design.CS.t*10])
    fprintf('R = %1.2fmm    Ht = %1.0fmm\n',[Design.CS.r*10 Design.CS.Ap*10])
    fprintf('A = %1.2fcm²\n',[Design.CS.Area])
    fprintf('Ixx = %1.2fcm⁴  Iyy = %1.2fcm⁴\n',[Design.CS.Ix Design.CS.Iy])
    fprintf('rx = %1.2fcm    ry = %1.2fcm\n',[Design.CS.rx Design.CS.ry])
    fprintf('Cw = %1.2fcm⁶  J = %1.2fcm⁴\n',[Design.CS.Cw Design.CS.J])
    fprintf('x0 = %1.2fcm    r0 = %1.2fcm\n',[Design.CS.x0 Design.CS.r0])
elseif Design.CS.Tipo == 'U'
    fprintf('B = %1.1fmm    t = %1.0fmm\n',[Design.CS.Bp*10 Design.CS.t*10])
    fprintf('R = %1.2fmm    Ht = %1.0fmm\n',[Design.CS.r*10 Design.CS.Ap*10])
    fprintf('A = %1.2fcm²\n',[Design.CS.Area])
    fprintf('Ixx = %1.2fcm⁴  Iyy = %1.2fcm⁴\n',[Design.CS.Ix Design.CS.Iy])
    fprintf('rx = %1.2fcm    ry = %1.2fcm\n',[Design.CS.rx Design.CS.ry])
    fprintf('Cw = %1.2fcm⁶  J = %1.2fcm⁴\n',[Design.CS.Cw Design.CS.J])
    fprintf('x0 = %1.2fcm    r0 = %1.2fcm\n',[Design.CS.x0 Design.CS.r0])
end
%%
% 1) Verificación de la relación de esbeltez
%
% *Elemento 1 - Alma*:
fprintf('h/t = %1.0f   <  500 B.C.\n',Design.CS.a/Design.CS.t) 
%%
%
% *Elemento 2 - Ala*:
fprintf('d/t = %1.0f   <  60 B.C.\n',Design.CS.b/Design.CS.t) 
%%
%
% *Elemento 3 - Labio*:
if Design.CS.Tipo == 'G'
    fprintf('b1/t = %1.2f   <  60 B.C.\n',Design.CS.c/Design.CS.t) 
elseif Design.CS.Tipo == 'U'
    fprintf('No corresponde.\n') 
end
%%
%
% 2) Verificación de la efectividad de la sección
%
% En función de los Arts. B.2.1, B.3.1 y B.4.2 se determina lo siguiente
% con respecto a la efectividad de la sección del perfil:
%
%
if Design.CS.Area >= Design.CS.Aefect
    fprintf('El área del perfil A = %1.2fcm² es totalmente efectiva.\n', Design.CS.Area) 
elseif Design.CS.Area < Design.CS.Aefect
    fprintf('El área efectiva del perfil es Aefec = %1.2fcm², menor al área total A = %1.2fcm².\n', [Design.CS.Aefect Design.CS.Area]) 
end
%%
% 3) Verificación a la compresión: 
%
% • Articulo C.4: Este artículo se aplica a barras en las cuales la
% resultante de todas las cargas actuantes es una carga axial a lo largo
% del eje del baricentro de la sección efectiva calculada para la tensión
% Fn (MPa).
%
fprintf('Pd = Øc·Fn·Ae·0.1 = 0.85·%1.0f·%1.2f·0.1 = %1.2fkN > %1.2fkN  B.C.\n',[Design.CS.Fn Design.CS.Aefect 0.85*Design.CS.Fn*Design.CS.Aefect*0.1 abs(Design.CS.Nmin(2)/1000)])
%%
% 4) Verificación a la tracción:
% 
% Según el artículo C.2, para barras solicitadas a tracción, la resistencia
% nominal a tracción, *Td*, en kN deberá ser el menor valor obtenido de los
% estados limites de (a) fluencia en la sección bruta, (b) rotura en la
% sección neta fuera de las uniones y (c) rotura en la sección neta
% efectiva en la unión.
%
% En el presente análisis se analiza los primeros dos casos, dejando a lo
% último las verificaciones de las uniones. Al no presentar uniones por
% bulones, la sección bruta es igual a la sección neta efectiva.
%
%  (a) Fluencia en la sección bruta (Art. C.2-1)
if 0.9*Design.CS.Fy*Design.CS.Area*0.1>Design.CS.Nmax(2)/1000
    VerifFluBru = '%1.2fkN > %1.2fkN  B.C.\n';
else
    VerifFluBru = '%1.2fkN < %1.2fkN  M.C.!!! NO VERIFICA REDIMENSIONAR ?\n';
end

fprintf(['Td = Øt·Fy·Ag·0.1 = 0.9·%1.0f·%1.2f·0.1 = ' VerifFluBru],[Design.CS.Fy Design.CS.Area 0.9*Design.CS.Fy*Design.CS.Area*0.1 Design.CS.Nmax(2)/1000])
%%
%  (b) Rotura en la sección neta (Art. C.2-2)
if 0.6*Design.CS.Fu*0.9*Design.CS.Area*0.1>Design.CS.Nmax(2)/1000
    VerifRotNet = '%1.2fkN > %1.2fkN  B.C.\n';
else
    VerifRotNet = '%1.2fkN < %1.2fkN  M.C.!!! NO VERIFICA REDIMENSIONAR ?\n';
end
fprintf(['Td = Øt·Fu·Ae·0.1 = 0.6·%1.2f·0.9·%1.2f·0.1 = ' VerifRotNet],[Design.CS.Fu Design.CS.Area 0.6*Design.CS.Fu*0.9*Design.CS.Area*0.1 Design.CS.Nmax(2)/1000])
%%
% _*8.2.- Verificación del cordón inferior.*_
%
% Se procede a la verificación del perfil adoptado según los requerimientos
% establecidos por la norma CIRSOC 303-2009 para la resistencia a la
% compresión axil.
if Design.CI.Tipo == 'U'
    copyfile ./Informe/Perfil-U.png ./Informe/perfilCI.png 
elseif Design.CI.Tipo == 'G'
    copyfile ./Informe/Perfil-G.png ./Informe/perfilCI.png 
end
%%
% <<perfilCI.png>>
%
% Fig: Esquema del perfil adoptado para cordón inferior.
%
% Propiedades del perfil:
if Design.CI.Tipo == 'G'
    fprintf('B = %1.1fmm    t = %1.0fmm\n',[Design.CI.Bp*10 Design.CI.t*10])
    fprintf('R = %1.2fmm    Ht = %1.0fmm\n',[Design.CI.r*10 Design.CI.Ap*10])
    fprintf('A = %1.2fcm²\n',[Design.CI.Area])
    fprintf('Ixx = %1.2fcm⁴  Iyy = %1.2fcm⁴\n',[Design.CI.Ix Design.CI.Iy])
    fprintf('rx = %1.2fcm    ry = %1.2fcm\n',[Design.CI.rx Design.CI.ry])
    fprintf('Cw = %1.2fcm⁶  J = %1.2fcm⁴\n',[Design.CI.Cw Design.CI.J])
    fprintf('x0 = %1.2fcm    r0 = %1.2fcm\n',[Design.CI.x0 Design.CI.r0])
elseif Design.CI.Tipo == 'U'
    fprintf('B = %1.1fmm    t = %1.0fmm\n',[Design.CI.Bp*10 Design.CI.t*10])
    fprintf('R = %1.2fmm    Ht = %1.0fmm\n',[Design.CI.r*10 Design.CI.Ap*10])
    fprintf('A = %1.2fcm²\n',[Design.CI.Area])
    fprintf('Ixx = %1.2fcm⁴  Iyy = %1.2fcm⁴\n',[Design.CI.Ix Design.CI.Iy])
    fprintf('rx = %1.2fcm    ry = %1.2fcm\n',[Design.CI.rx Design.CI.ry])
    fprintf('Cw = %1.2fcm⁶  J = %1.2fcm⁴\n',[Design.CI.Cw Design.CI.J])
    fprintf('x0 = %1.2fcm    r0 = %1.2fcm\n',[Design.CI.x0 Design.CI.r0])
end
%%
% 1) Verificación de la relación de esbeltez
%
% *Elemento 1 - Alma*:
fprintf('h/t = %1.0f   <  500 B.C.\n',Design.CI.a/Design.CI.t) 
%%
%
% *Elemento 2 - Ala*:
fprintf('d/t = %1.0f   <  60 B.C.\n',Design.CI.b/Design.CI.t) 
%%
%
% *Elemento 3 - Labio*:
if Design.CI.Tipo == 'G'
    fprintf('b1/t = %1.2f   <  60 B.C.\n',Design.CI.c/Design.CI.t) 
elseif Design.CI.Tipo == 'U'
    fprintf('No corresponde.\n') 
end
%%
%
% 2) Verificación de la efectividad de la sección
%
% En función de los Arts. B.2.1, B.3.1 y B.4.2 se determina lo siguiente
% con respecto a la efectividad de la sección del perfil:
%
%
if Design.CI.Area >= Design.CI.Aefect
    fprintf('El área del perfil A = %1.2fcm² es totalmente efectiva.\n', Design.CI.Area) 
elseif Design.CI.Area < Design.CI.Aefect
    fprintf('El área efectiva del perfil es Aefec = %1.2fcm², menor al área total A = %1.2fcm².\n', [Design.CI.Aefect Design.CI.Area]) 
end
%%
% 3) Verificación a la compresión: 
%
% • Articulo C.4: Este artículo se aplica a barras en las cuales la
% resultante de todas las cargas actuantes es una carga axial a lo largo
% del eje del baricentro de la sección efectiva calculada para la tensión
% Fn (MPa).
%
fprintf('Pd = Øc·Fn·Ae·0.1 = 0.85·%1.0f·%1.2f·0.1 = %1.2fkN > %1.2fkN  B.C.\n',[Design.CI.Fn Design.CI.Aefect 0.85*Design.CI.Fn*Design.CI.Aefect*0.1 abs(Design.CI.Nmin(2)/1000)])
%%
% 4) Verificación a la tracción:
% 
% Según el artículo C.2, para barras solicitadas a tracción, la resistencia
% nominal a tracción, *Td*, en kN deberá ser el menor valor obtenido de los
% estados limites de (a) fluencia en la sección bruta, (b) rotura en la
% sección neta fuera de las uniones y (c) rotura en la sección neta
% efectiva en la unión.
%
% En el presente análisis se analiza los primeros dos casos, dejando a lo
% último las verificaciones de las uniones. Al no presentar uniones por
% bulones, la sección bruta es igual a la sección neta efectiva.
%
%  (a) Fluencia en la sección bruta (Art. C.2-1)
if 0.9*Design.CI.Fy*Design.CI.Area*0.1>Design.CI.Nmax(2)/1000
    VerifFluBru = '%1.2fkN > %1.2fkN  B.C.\n';
else
    VerifFluBru = '%1.2fkN < %1.2fkN  M.C.!!! NO VERIFICA REDIMENSIONAR ?\n';
end

fprintf(['Td = Øt·Fy·Ag·0.1 = 0.9·%1.0f·%1.2f·0.1 = ' VerifFluBru],[Design.CI.Fy Design.CI.Area 0.9*Design.CI.Fy*Design.CI.Area*0.1 Design.CI.Nmax(2)/1000])
%%
%  (b) Rotura en la sección neta (Art. C.2-2)
if 0.6*Design.CI.Fu*0.9*Design.CI.Area*0.1>Design.CI.Nmax(2)/1000
    VerifRotNet = '%1.2fkN > %1.2fkN  B.C.\n';
else
    VerifRotNet = '%1.2fkN < %1.2fkN  M.C.!!! NO VERIFICA REDIMENSIONAR ?\n';
end
fprintf(['Td = Øt·Fu·Ae·0.1 = 0.6·%1.2f·0.9·%1.2f·0.1 = ' VerifRotNet],[Design.CI.Fu Design.CI.Area 0.6*Design.CI.Fu*0.9*Design.CI.Area*0.1 Design.CI.Nmax(2)/1000])

%%
% _*8.3.- Verificación de las diagonales.*_
%
% Se procede a la verificación del perfil adoptado según los requerimientos
% establecidos por la norma CIRSOC 303-2009 para la resistencia a la
% compresión axil.
if Design.DI.Tipo == 'U'
    copyfile ./Informe/Perfil-U.png ./Informe/perfilDI.png 
elseif Design.DI.Tipo == 'C'
    copyfile ./Informe/Perfil-C.png ./Informe/perfilDI.png 
end
%%
% <<perfilDI.png>>
%
% Fig: Esquema del perfil adoptado para las diagonales.
%
% Propiedades del perfil:
if Design.DI.Tipo == 'C'
    fprintf('B = %1.1fmm    t = %1.0fmm\n',[Design.DI.Bp*10 Design.DI.t*10])
    fprintf('R = %1.2fmm    Ht = %1.0fmm\n',[Design.DI.r*10 Design.DI.Ap*10])
    fprintf('A = %1.2fcm²\n',[Design.DI.Area])
    fprintf('Ixx = %1.2fcm⁴  Iyy = %1.2fcm⁴\n',[Design.DI.Ix Design.DI.Iy])
    fprintf('rx = %1.2fcm    ry = %1.2fcm\n',[Design.DI.rx Design.DI.ry])
    fprintf('Cw = %1.2fcm⁶  J = %1.2fcm⁴\n',[Design.DI.Cw Design.DI.J])
    fprintf('x0 = %1.2fcm    r0 = %1.2fcm\n',[Design.DI.x0 Design.DI.r0])
elseif Design.DI.Tipo == 'U'
    fprintf('B = %1.1fmm    t = %1.0fmm\n',[Design.DI.Bp*10 Design.DI.t*10])
    fprintf('R = %1.2fmm    Ht = %1.0fmm\n',[Design.DI.r*10 Design.DI.Ap*10])
    fprintf('A = %1.2fcm²\n',[Design.DI.Area])
    fprintf('Ixx = %1.2fcm⁴  Iyy = %1.2fcm⁴\n',[Design.DI.Ix Design.DI.Iy])
    fprintf('rx = %1.2fcm    ry = %1.2fcm\n',[Design.DI.rx Design.DI.ry])
    fprintf('Cw = %1.2fcm⁶  J = %1.2fcm⁴\n',[Design.DI.Cw Design.DI.J])
    fprintf('x0 = %1.2fcm    r0 = %1.2fcm\n',[Design.DI.x0 Design.DI.r0])
end
%%
% 1) Verificación de la relación de esbeltez
%
% *Elemento 1 - Alma*:
fprintf('h/t = %1.0f   <  500 B.C.\n',Design.DI.a/Design.DI.t) 
%%
%
% *Elemento 2 - Ala*:
fprintf('d/t = %1.0f   <  60 B.C.\n',Design.DI.b/Design.DI.t) 
%%
%
% *Elemento 3 - Labio*:
if Design.DI.Tipo == 'C'
    fprintf('b1/t = %1.2f   <  60 B.C.\n',Design.DI.c/Design.DI.t) 
elseif Design.DI.Tipo == 'U'
    fprintf('No corresponde.\n') 
end
%%
%
% 2) Verificación de la efectividad de la sección
%
% En función de los Arts. B.2.1, B.3.1 y B.4.2 se determina lo siguiente
% con respecto a la efectividad de la sección del perfil:
%
%
if Design.DI.Area >= Design.DI.Aefect
    fprintf('El área del perfil A = %1.2fcm² es totalmente efectiva.\n', Design.DI.Area) 
elseif Design.DI.Area < Design.DI.Aefect
    fprintf('El área efectiva del perfil es Aefec = %1.2fcm², menor al área total A = %1.2fcm².\n', [Design.DI.Aefect Design.DI.Area]) 
end
%%
% 3) Verificación a la compresión: 
%
% • Articulo C.4: Este artículo se aplica a barras en las cuales la
% resultante de todas las cargas actuantes es una carga axial a lo largo
% del eje del baricentro de la sección efectiva calculada para la tensión
% Fn (MPa).
%
fprintf('Pd = Øc·Fn·Ae·0.1 = 0.85·%1.0f·%1.2f·0.1 = %1.2fkN > %1.2fkN  B.C.\n',[Design.DI.Fn Design.DI.Aefect 0.85*Design.DI.Fn*Design.DI.Aefect*0.1 abs(Design.DI.Nmin(2)/1000)])
%%
% 4) Verificación a la tracción:
% 
% Según el artículo C.2, para barras solicitadas a tracción, la resistencia
% nominal a tracción, *Td*, en kN deberá ser el menor valor obtenido de los
% estados limites de (a) fluencia en la sección bruta, (b) rotura en la
% sección neta fuera de las uniones y (c) rotura en la sección neta
% efectiva en la unión.
%
% En el presente análisis se analiza los primeros dos casos, dejando a lo
% último las verificaciones de las uniones. Al no presentar uniones por
% bulones, la sección bruta es igual a la sección neta efectiva.
%
%  (a) Fluencia en la sección bruta (Art. C.2-1)
if 0.9*Design.DI.Fy*Design.DI.Area*0.1>Design.DI.Nmax(2)/1000
    VerifFluBru = '%1.2fkN > %1.2fkN  B.C.\n';
else
    VerifFluBru = '%1.2fkN < %1.2fkN  M.C.!!! NO VERIFICA REDIMENSIONAR ?\n';
end

fprintf(['Td = Øt·Fy·Ag·0.1 = 0.9·%1.0f·%1.2f·0.1 = ' VerifFluBru],[Design.DI.Fy Design.DI.Area 0.9*Design.DI.Fy*Design.DI.Area*0.1 Design.DI.Nmax(2)/1000])
%%
%  (b) Rotura en la sección neta (Art. C.2-2)
if 0.6*Design.DI.Fu*0.9*Design.DI.Area*0.1>Design.DI.Nmax(2)/1000
    VerifRotNet = '%1.2fkN > %1.2fkN  B.C.\n';
else
    VerifRotNet = '%1.2fkN < %1.2fkN  M.C.!!! NO VERIFICA REDIMENSIONAR ?\n';
end
fprintf(['Td = Øt·Fu·Ae·0.1 = 0.6·%1.2f·0.9·%1.2f·0.1 = ' VerifRotNet],[Design.DI.Fu Design.DI.Area 0.6*Design.DI.Fu*0.9*Design.DI.Area*0.1 Design.DI.Nmax(2)/1000])

%%
% _*8.4.- Verificación de las barras de apoyos de la cercha.*_
%
% Se procede a la verificación del perfil adoptado según los requerimientos
% establecidos por la norma CIRSOC 303-2009 para la resistencia a la
% compresión axil.
if Design.DA.Tipo == 'U'
    copyfile ./Informe/Perfil-U.png ./Informe/perfilDA.png 
elseif Design.DI.Tipo == 'C'
    copyfile ./Informe/Perfil-C.png ./Informe/perfilDA.png 
end
%%
% <<perfilDA.png>>
%
% Fig: Esquema del perfil adoptado para barras de apoyo de la cercha.
%
% Propiedades del perfil:
if Design.DA.Tipo == 'C'
    fprintf('B = %1.1fmm    t = %1.0fmm\n',[Design.DA.Bp*10 Design.DA.t*10])
    fprintf('R = %1.2fmm    Ht = %1.0fmm\n',[Design.DA.r*10 Design.DA.Ap*10])
    fprintf('A = %1.2fcm²\n',[Design.DA.Area])
    fprintf('Ixx = %1.2fcm⁴  Iyy = %1.2fcm⁴\n',[Design.DA.Ix Design.DA.Iy])
    fprintf('rx = %1.2fcm    ry = %1.2fcm\n',[Design.DA.rx Design.DA.ry])
    fprintf('Cw = %1.2fcm⁶  J = %1.2fcm⁴\n',[Design.DA.Cw Design.DA.J])
    fprintf('x0 = %1.2fcm    r0 = %1.2fcm\n',[Design.DA.x0 Design.DA.r0])
elseif Design.DA.Tipo == 'U'
    fprintf('B = %1.1fmm    t = %1.0fmm\n',[Design.DA.Bp*10 Design.DA.t*10])
    fprintf('R = %1.2fmm    Ht = %1.0fmm\n',[Design.DA.r*10 Design.DA.Ap*10])
    fprintf('A = %1.2fcm²\n',[Design.DA.Area])
    fprintf('Ixx = %1.2fcm⁴  Iyy = %1.2fcm⁴\n',[Design.DA.Ix Design.DA.Iy])
    fprintf('rx = %1.2fcm    ry = %1.2fcm\n',[Design.DA.rx Design.DA.ry])
    fprintf('Cw = %1.2fcm⁶  J = %1.2fcm⁴\n',[Design.DA.Cw Design.DA.J])
    fprintf('x0 = %1.2fcm    r0 = %1.2fcm\n',[Design.DA.x0 Design.DA.r0])
end
%%
% 1) Verificación de la relación de esbeltez
%
% *Elemento 1 - Alma*:
fprintf('h/t = %1.0f   <  500 B.C.\n',Design.DA.a/Design.DA.t) 
%%
%
% *Elemento 2 - Ala*:
fprintf('d/t = %1.0f   <  60 B.C.\n',Design.DA.b/Design.DA.t) 
%%
%
% *Elemento 3 - Labio*:
if Design.DA.Tipo == 'C'
    fprintf('b1/t = %1.2f   <  60 B.C.\n',Design.DA.c/Design.DA.t) 
elseif Design.DA.Tipo == 'U'
    fprintf('No corresponde.\n') 
end
%%
%
% 2) Verificación de la efectividad de la sección
%
% En función de los Arts. B.2.1, B.3.1 y B.4.2 se determina lo siguiente
% con respecto a la efectividad de la sección del perfil:
%
%
if Design.DA.Area >= Design.DA.Aefect
    fprintf('El área del perfil A = %1.2fcm² es totalmente efectiva.\n', Design.DA.Area) 
elseif Design.DA.Area < Design.DA.Aefect
    fprintf('El área efectiva del perfil es Aefec = %1.2fcm², menor al área total A = %1.2fcm².\n', [Design.DA.Aefect Design.DA.Area]) 
end
%%
% 3) Verificación a la compresión: 
%
% • Articulo C.4: Este artículo se aplica a barras en las cuales la
% resultante de todas las cargas actuantes es una carga axial a lo largo
% del eje del baricentro de la sección efectiva calculada para la tensión
% Fn (MPa).
%
fprintf('Pd = Øc·Fn·Ae·0.1 = 0.85·%1.0f·%1.2f·0.1 = %1.2fkN > %1.2fkN  B.C.\n',[Design.DA.Fn Design.DA.Aefect 0.85*Design.DA.Fn*Design.DA.Aefect*0.1 abs(Design.DA.Nmin(2)/1000)])
%%
% 4) Verificación a la tracción:
% 
% Según el artículo C.2, para barras solicitadas a tracción, la resistencia
% nominal a tracción, *Td*, en kN deberá ser el menor valor obtenido de los
% estados limites de (a) fluencia en la sección bruta, (b) rotura en la
% sección neta fuera de las uniones y (c) rotura en la sección neta
% efectiva en la unión.
%
% En el presente análisis se analiza los primeros dos casos, dejando a lo
% último las verificaciones de las uniones. Al no presentar uniones por
% bulones, la sección bruta es igual a la sección neta efectiva.
%
%  (a) Fluencia en la sección bruta (Art. C.2-1)
if 0.9*Design.DA.Fy*Design.DA.Area*0.1>Design.DA.Nmax(2)/1000
    VerifFluBru = '%1.2fkN > %1.2fkN  B.C.\n';
else
    VerifFluBru = '%1.2fkN < %1.2fkN  M.C.!!! NO VERIFICA REDIMENSIONAR ?\n';
end

fprintf(['Td = Øt·Fy·Ag·0.1 = 0.9·%1.0f·%1.2f·0.1 = ' VerifFluBru],[Design.DA.Fy Design.DA.Area 0.9*Design.DA.Fy*Design.DA.Area*0.1 Design.DA.Nmax(2)/1000])
%%
%  (b) Rotura en la sección neta (Art. C.2-2)
if 0.6*Design.DA.Fu*0.9*Design.DA.Area*0.1>Design.DA.Nmax(2)/1000
    VerifRotNet = '%1.2fkN > %1.2fkN  B.C.\n';
else
    VerifRotNet = '%1.2fkN < %1.2fkN  M.C.!!! NO VERIFICA REDIMENSIONAR ?\n';
end
fprintf(['Td = Øt·Fu·Ae·0.1 = 0.6·%1.2f·0.9·%1.2f·0.1 = ' VerifRotNet],[Design.DA.Fu Design.DA.Area 0.6*Design.DA.Fu*0.9*Design.DA.Area*0.1 Design.DA.Nmax(2)/1000])

end