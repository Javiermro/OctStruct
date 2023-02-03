function  informe(Prob_data,Design) 
% RellenosParaInforme
%% *Memoria de cálculo: Estructura de techo*
fprintf(' %s \n',Prob_data.Info.title) ;
fprintf('\n   \n') ;
fprintf(' FECHA: %s \n',Prob_data.Info.date) ;
fprintf(' CALCULISTA: %s \n',Prob_data.Info.calc) ;
fprintf(' SOLICITANTE: %s \n',Prob_data.Info.solic) ;
fprintf('\n   ') ;

%%
% *1.- Consideraciones generales*
%
% En la presente memoria de cálculo se emplearán los siguientes lineamientos:
% 
% * Para la determinación de las cargas de viento, se emplearán el Reglamento argentino de acción del viento sobre las construcciones CIRSOC 102 (edición de Julio 2005) y los Comentarios al reglamento argentino de acción del viento sobre las construcciones CIRSOC 102 (edición de Julio 2005).
%
% * Con respecto a la verificación de la estructura principal y secundaria, de chapa plegada, tanto como correas y vigas cajón, el procedimiento de cálculo será basado por la recomendación al CIRSOC 302 (Edición de Noviembre de 2001).
%
% * Para el dimensionamiento de los elementos de hormigón armado será empleado el reglamento CIRSOC 201.

%%
% *2.- Datos generales de la estructura*
%
% Se adjunta al presente informe la planta de estructura.
fprintf('Lado Mayor L: %1.2fm.\n',Prob_data.Geom.Lt);
fprintf('Lado Menor B: %1.2fm.\n',Prob_data.Geom.L);
fprintf('Altura de cabeza de columna h: %1.2fm.\n',Prob_data.Geom.Hc);
if isfield(Prob_data.Geom,'f')
    fprintf('Flecha: %1.2fº \n',atand(Prob_data.Geom.f(1)));
else
    fprintf('Pendiente: %1.2fº \n',atand(Prob_data.Geom.pend(1)));
end
fprintf('Ubicación: %s. \n',Prob_data.Rell.Info.Ubic);
fprintf('Destino: %s. \n',Prob_data.Rell.Info.Dest);

%% 
% *3.- Determinación de las cargas de viento*
%
% _*3.1.- Determinación de la Presión Dinámica (CIRSOC 102-2005, Art.
% 5.10)*_
%
% *q = 0.613 · kz · kzt · kd · I · v²*
%
% Características de la estructura según reglamento:
fprintf('Exposición: %s. \n', Prob_data.Cargas.Exp) ;
fprintf('Factor topográfico: Kzt = %1.2f. \n',Prob_data.Cargas.Kzt) ;
fprintf('Factor de direccionalidad. Kd = %1.2f. \n',Prob_data.Cargas.Kd) ;
fprintf('Factor de Importancia: I = %1.0f. \n',Prob_data.Cargas.I) ;
fprintf('Velocidad básica de viento: v = %1.2f [m/s].  \n',Prob_data.Cargas.V) ;
fprintf('Coeficiente de exposición para la presión dinámica en función de la altura de la estructura (Art. 5.6.4.):  \n');
%%
% 
fprintf('|| Z[m] |  Kz  | q[N/m²]|| \n');
for i=1:size(Prob_data.Cargas.ZKzqz,1)
    fprintf('|| %1.2f | %1.2f | %1.2f || \n',[Prob_data.Cargas.ZKzqz(i,1),Prob_data.Cargas.ZKzqz(i,2),Prob_data.Cargas.ZKzqz(i,3)]);
end
%%
% _Tabla 1: Factores Kz y presión qz._
%%
% Donde la última fila corresponde a la altura media de la cubierta, la cual definirá la presión *qh*.
%%
% _*3.2.- Determinación de las presiones de diseño.*_
%
% Su determinación está definida según reglamento por la siguiente expresión:
%
% *p = q · G · Cp - qi · (GCpi) [N/m2]*
%
% *q = qz* para paredes a barlovento evaluada a la altura z sobre el terreno;
%
% *q = qh* para paredes a sotavento, paredes laterales y cubiertas, evaluada a la altura media de cubierta, h ;
%
% *qi = qh* para paredes a barlovento, paredes laterales, paredes a sotavento y cubiertas de edificios cerrados y para la evaluación de la presión interna negativa en edificios parcialmente cerrados;
%
% *qi = qz* para la evaluación de la presión interna positiva en edificios parcialmente cerrados donde la altura z está definida como el nivel de la abertura mas elevada del edificio que podría afectar la presión interna positiva. Para edificios ubicados en regiones donde se pueda dar el arrastre de partículas por el viento, el vidriado en los 20 m inferiores que no sea resistente a impactos o no esté protegido con una cubierta resistente a impactos, se debe tratar como una abertura de acuerdo con el artículo 5.9.3. Para la evaluación de la presión interna positiva, qi se puede calcular conservadoramente a la altura h (qi = qh );
%
% *G* el factor de efecto de ráfaga según el artículo 5.8.;
%
% *Cp* el coeficiente de presión externa de la Figura 3 o de la Tabla 8;
%
% *(GCpi)* el coeficiente de presión interna de la Tabla 7.

fprintf('Presión dinámica para la altura media qh = %1.2f \n', Prob_data.Cargas.ZKzqz(end,3)) ;
fprintf('Factor de efecto ráfaga G = %1.2f \n', 0.85) ;

idx_vpc_pb = intersect(Prob_data.Cargas.p_vpc(:,end),[23:33]');
vpc_pb = [];
for i = 1:length(idx_vpc_pb)
    vpc_pb = [vpc_pb; Prob_data.Cargas.p_vpc(idx_vpc_pb(i) == Prob_data.Cargas.p_vpc(:,end),1)];
end
vpc_pb = reshape(vpc_pb,2,[])';

idx_vpc_ps = intersect(Prob_data.Cargas.p_vpc(:,end),[34:35]');
vpc_ps = [];
for i = 1:length(idx_vpc_ps)
    vpc_ps = [vpc_ps; Prob_data.Cargas.p_vpc(idx_vpc_ps(i) == Prob_data.Cargas.p_vpc(:,end),1)];
end
vpc_ps = reshape(vpc_ps,2,[])';

idx_vpc_pl = intersect(Prob_data.Cargas.p_vpc(:,end),[36:37]');
vpc_pl = [];
for i = 1:length(idx_vpc_pl)
    vpc_pl = [vpc_pl; Prob_data.Cargas.p_vpc(idx_vpc_pl(i) == Prob_data.Cargas.p_vpc(:,end),1)];
end
vpc_pl = reshape(vpc_pl,2,[])';

idx_vpc_cu = intersect(Prob_data.Cargas.p_vpc(:,end),[38:45]');
vpc_cu = [];
for i = 1:length(idx_vpc_cu)
    vpc_cu = [vpc_cu; Prob_data.Cargas.p_vpc(idx_vpc_cu(i) == Prob_data.Cargas.p_vpc(:,end),1)];
end
vpc_cu = reshape(vpc_cu,2,[])';

%%
% Viento paralelo a la cumbrera
fprintf('||   pn (GCpi>0) |     pn (GCpi<0)  || \n');
fprintf('||        Paredes a Barlovento      || \n');
fprintf('||   %1.2f      |       %1.2f     || \n',[vpc_pb]);
fprintf('||        Paredes a Sotavento       || \n');
fprintf('||   %1.2f      |       %1.2f    || \n',[vpc_ps]);
fprintf('||        Paredes Laterales         || \n');
fprintf('||   %1.2f      |       %1.2f    || \n',[vpc_pl]);
fprintf('||              Cubierta             || \n');
fprintf('||   %1.2f      |       %1.2f    || \n',[vpc_cu]);

idx_vnc_pb = intersect(Prob_data.Cargas.p_vnc(:,end),[1:4]');
vnc_pb = [];
for i = 1:length(idx_vnc_pb)
    vnc_pb = [vnc_pb; Prob_data.Cargas.p_vnc(idx_vnc_pb(i) == Prob_data.Cargas.p_vnc(:,end),1)];
end
vnc_pb = reshape(vnc_pb,2,[])';

idx_vnc_ps = intersect(Prob_data.Cargas.p_vnc(:,end),[5:6]');
vnc_ps = [];
for i = 1:length(idx_vnc_ps)
    vnc_ps = [vnc_ps; Prob_data.Cargas.p_vnc(idx_vnc_ps(i) == Prob_data.Cargas.p_vnc(:,end),1)];
end
vnc_ps = reshape(vnc_ps,2,[])';

idx_vnc_pl = intersect(Prob_data.Cargas.p_vnc(:,end),[7:8]');
vnc_pl = [];
for i = 1:length(idx_vnc_pl)
    vnc_pl = [vnc_pl; Prob_data.Cargas.p_vnc(idx_vnc_pl(i) == Prob_data.Cargas.p_vnc(:,end),1)];
end
vnc_pl = reshape(vnc_pl,2,[])';

idx_vnc_cu = intersect(Prob_data.Cargas.p_vnc(:,end),[9:22 46:53]');
vnc_cu = [];
for i = 1:length(idx_vnc_cu)
    vnc_cu = [vnc_cu; Prob_data.Cargas.p_vnc(idx_vnc_cu(i) == Prob_data.Cargas.p_vnc(:,end),1)];
end
vnc_cu = reshape(vnc_cu,2,[])';

%%
% Viento normal a la cumbrera
fprintf('||   pn (GCpi>0) |     pn (GCpi<0)  || \n');
fprintf('||        Paredes a Barlovento      || \n');
fprintf('||   %1.2f      |       %1.2f       || \n',[vnc_pb]);
fprintf('||        Paredes a Sotavento       || \n');
fprintf('||   %1.2f      |       %1.2f       || \n',[vnc_ps]);
fprintf('||        Paredes Laterales         || \n');
fprintf('||   %1.2f      |       %1.2f       || \n',[vnc_pl]);
fprintf('||              Cubierta             || \n');
fprintf('||   %1.2f      |       %1.2f       || \n',[vnc_cu]);
%%
% _Tabla 2: Presiones Resultantes_

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
fprintf('D = %1.2fN/m',PesoTotal);
%%
% _*4.2.- Determinación de W actuante en las correas:*_
% 
% _Succión:_
fprintf('W = %1.2fN/m \n',[Design.CO.q(1)])
%%
% _Presión:_
fprintf('W = %1.2fN/m\n',[Design.CO.q(2)])
%%
% Por lo tanto, las cargas de diseño para las correas serán dos.
% Para el caso predominante de succión:
fprintf('qSuc = %1.2fN/m\n',[Design.CO.q(1)*Prob_data.Cargas.Factor(2)+PesoTotal*Prob_data.Cargas.Factor(1)])
%%
% Para el caso predominante de presión:
fprintf('qPre = %1.2fN/m\n',[Design.CO.q(2)*Prob_data.Cargas.Factor(2)+PesoTotal*Prob_data.Cargas.Factor(1)])
%%
%
% *5- Solicitaciones en las correas.*
%
% Se presentan a continuación las solicitaciones para el caso de carga
% concentrada y un caso de solicitación por carga de viento.
%
% _*5.1.- Carga Puntual en tramo exterior.*_
%
copyfile('./Informes/Fig_Correas_Mf1.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_Correas_Mf1.png'])
delete('./Informes/Fig_Correas_Mf1.png')
%%
% <<Fig_Correas_Mf1.png>>
copyfile('./Informes/Fig_Correas_Q1.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_Correas_Q1.png'])
delete('./Informes/Fig_Correas_Q1.png')
%%
% <<Fig_Correas_Q1.png>>
%
%%
% _*5.2.- Carga Puntual en tramo interior.*_
%
copyfile('./Informes/Fig_Correas_Mf2.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_Correas_Mf2.png'])
delete('./Informes/Fig_Correas_Mf2.png')
%%
% <<Fig_Correas_Mf2.png>>
%
copyfile('./Informes/Fig_Correas_Q2.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_Correas_Q2.png'])
delete('./Informes/Fig_Correas_Q2.png')
%%
% <<Fig_Correas_Q2.png>>
%

%%
% _*5.3.- Carga de viento en correas (Succión).*_
%
copyfile('./Informes/Fig_Correas_Mf3.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_Correas_Mf3.png'])
delete('./Informes/Fig_Correas_Mf3.png')
%%
% <<Fig_Correas_Mf3.png>>
%
copyfile('./Informes/Fig_Correas_Q3.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_Correas_Q3.png'])
delete('./Informes/Fig_Correas_Q3.png')
%%
% <<Fig_Correas_Q3.png>>
%
%%
% _*5.4.- Carga de viento en correas (Presión).*_
%
copyfile('./Informes/Fig_Correas_Mf4.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_Correas_Mf4.png'])
delete('./Informes/Fig_Correas_Mf4.png')
%%
% <<Fig_Correas_Mf4.png>>
%
copyfile('./Informes/Fig_Correas_Q4.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_Correas_Q4.png'])
delete('./Informes/Fig_Correas_Q4.png')
%%
% <<Fig_Correas_Q4.png>>
%

%%
% *6.- Dimensionamiento y verificación de las correas de la estructura*
%
% Se procede a la verificación de un perfil abierto C según los requerimientos establecidos 
% por la norma CIRSOC 303-2009 para la resistencia a la flexión y a corte para las 
% solicitaciones de la carga de diseño y la resistencia de diseño a carga concentrada. 
%
copyfile('./Informes/FigurasFijas/Perfil-C.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Perfil-C.png'])
%%
% <<Perfil-C.png>>
%
% Fig: Esquema del perfil adoptado para correas.
fprintf('Perfil %s\n',[Prob_data.Predim.CO]) 

%%
% Propiedades del perfil:
fprintf('B = %1.1fmm    t = %1.2fmm\n',[Design.CO.Bp*10 Design.CO.t*10])
fprintf('R = %1.2fmm    Ht = %1.2fmm\n',[Design.CO.r*10 Design.CO.Ap*10])
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
% b) Resistencia al pandeo lateral torsional. (Art. C.3.1.1): Se adoptan arriostramientos a los tercios de la luz.
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
%
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
copyfile('./Informes/Fig_struture.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_structure.png'])
delete('./Informes/Fig_struture.png')
%%
% <<Fig_structure.png>>
%
% 
copyfile('./Informes/Fig_state1.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_state1.png'])
delete('./Informes/Fig_state1.png')
%%
% <<Fig_state1.png>>
%
% Esquema de estructura con cargas aplicadas, correspondientes al estado 1
% debido a Viento.
idx = 0:10:length(Prob_data.Tablas.TracMax);
Encabezado = '||Barra |      Perfil      | Long.[m] |Comp.Máx.[N]|Trac.Máx[N]||\n';
fprintf(Encabezado);
for i=1:length(Prob_data.Tablas.TracMax)
     fprintf('|| %s  |  %s  |  %1.2f    |   %1.0f    |    %1.0f   ||\n',...
         [ Prob_data.Tablas.Ubic(i)  Prob_data.Tablas.Secciones(i) Prob_data.Tablas.Long(i) Prob_data.Tablas.CompMax(i) Prob_data.Tablas.TracMax(i)]);
     if ~mod(i,10)
         fprintf(' \n');
         fprintf(Encabezado);
     end
end
fprintf(Encabezado);
%%
% _Tabla 3: se detallan los elementos que conforman la cercha
% con los perfiles adoptados para cada caso.
% También se detallan los máximos esfuerzos en cada
% cordón, con los cuales serán verificados._
%
%%
% Nota: Los casos nulos en la tabla anterior corresponden a barras que no
% presentaron esfuerzos de tracción o compresión, según corresponda.
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
    copyfile('./Informes/FigurasFijas/Perfil-U.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/perfilCS.png']) 
elseif Design.CS.Tipo == 'G'
    copyfile('./Informes/FigurasFijas/Perfil-G.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/perfilCS.png'])
end
%%
% <<perfilCS.png>>
%
% Fig: Esquema del perfil adoptado para el cordón superior.
%
% Propiedades del perfil:
if Design.CS.Tipo == 'G'
    fprintf('B = %1.1fmm    t = %1.2fmm\n',[Design.CS.Bp*10 Design.CS.t*10])
    fprintf('R = %1.2fmm    Ht = %1.2fmm\n',[Design.CS.r*10 Design.CS.Ap*10])
    fprintf('A = %1.2fcm²\n',[Design.CS.Area])
    fprintf('Ixx = %1.2fcm⁴  Iyy = %1.2fcm⁴\n',[Design.CS.Ix Design.CS.Iy])
    fprintf('rx = %1.2fcm    ry = %1.2fcm\n',[Design.CS.rx Design.CS.ry])
    fprintf('Cw = %1.2fcm⁶  J = %1.2fcm⁴\n',[Design.CS.Cw Design.CS.J])
    fprintf('x0 = %1.2fcm    r0 = %1.2fcm\n',[Design.CS.x0 Design.CS.r0])
elseif Design.CS.Tipo == 'U'
    fprintf('B = %1.1fmm    t = %1.2fmm\n',[Design.CS.Bp*10 Design.CS.t*10])
    fprintf('R = %1.2fmm    Ht = %1.2fmm\n',[Design.CS.r*10 Design.CS.Ap*10])
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
% estados límites de (a) fluencia en la sección bruta, (b) rotura en la
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

fprintf(['Td = Øt·Ag·Fy·0.1 = 0.9·%1.0f·%1.2f·0.1 = ' VerifFluBru],[Design.CS.Fy Design.CS.Area 0.9*Design.CS.Fy*Design.CS.Area*0.1 Design.CS.Nmax(2)/1000])
%%
%  (b) Rotura en la sección neta (Art. C.2-2)
if 0.75*Design.CS.Fu*Design.CS.Area*0.1>Design.CS.Nmax(2)/1000
    VerifRotNet = '%1.2fkN > %1.2fkN  B.C.\n';
else
    VerifRotNet = '%1.2fkN < %1.2fkN  M.C.!!! NO VERIFICA REDIMENSIONAR ?\n';
end
fprintf(['Td = Øt·An·Fu·0.1 = 0.75·%1.2f·%1.2f·0.1 = ' VerifRotNet],[Design.CS.Area Design.CS.Fu 0.75*Design.CS.Fu*Design.CS.Area*0.1 Design.CS.Nmax(2)/1000])
%%
% _*8.2.- Verificación del cordón inferior.*_
%
% Se procede a la verificación del perfil adoptado según los requerimientos
% establecidos por la norma CIRSOC 303-2009 para la resistencia a la
% compresión axil.
if Design.CI.Tipo == 'U'
    copyfile('./Informes/FigurasFijas/Perfil-U.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/perfilCI.png']) 
elseif Design.CI.Tipo == 'G'
    copyfile('./Informes/FigurasFijas/Perfil-G.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/perfilCI.png'])
end
%%
% <<perfilCI.png>>
%
% Fig: Esquema del perfil adoptado para cordón inferior.
%
% Propiedades del perfil:
if Design.CI.Tipo == 'G'
    fprintf('B = %1.1fmm    t = %1.2fmm\n',[Design.CI.Bp*10 Design.CI.t*10])
    fprintf('R = %1.2fmm    Ht = %1.2fmm\n',[Design.CI.r*10 Design.CI.Ap*10])
    fprintf('A = %1.2fcm²\n',[Design.CI.Area])
    fprintf('Ixx = %1.2fcm⁴  Iyy = %1.2fcm⁴\n',[Design.CI.Ix Design.CI.Iy])
    fprintf('rx = %1.2fcm    ry = %1.2fcm\n',[Design.CI.rx Design.CI.ry])
    fprintf('Cw = %1.2fcm⁶  J = %1.2fcm⁴\n',[Design.CI.Cw Design.CI.J])
    fprintf('x0 = %1.2fcm    r0 = %1.2fcm\n',[Design.CI.x0 Design.CI.r0])
elseif Design.CI.Tipo == 'U'
    fprintf('B = %1.1fmm    t = %1.2fmm\n',[Design.CI.Bp*10 Design.CI.t*10])
    fprintf('R = %1.2fmm    Ht = %1.2fmm\n',[Design.CI.r*10 Design.CI.Ap*10])
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
% estados límites de (a) fluencia en la sección bruta, (b) rotura en la
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

fprintf(['Td = Øt·Ag·Fy·0.1 = 0.9·%1.0f·%1.2f·0.1 = ' VerifFluBru],[Design.CI.Area Design.CI.Fy 0.9*Design.CI.Fy*Design.CI.Area*0.1 Design.CI.Nmax(2)/1000])
%%
%  (b) Rotura en la sección neta (Art. C.2-2)
if 0.75*Design.CI.Fu*Design.CI.Area*0.1>Design.CI.Nmax(2)/1000
    VerifRotNet = '%1.2fkN > %1.2fkN  B.C.\n';
else
    VerifRotNet = '%1.2fkN < %1.2fkN  M.C.!!! NO VERIFICA REDIMENSIONAR ?\n';
end
fprintf(['Td = Øt·An·Fu·0.1 = 0.75·%1.2f·%1.2f·0.1 = ' VerifRotNet],[Design.CI.Area Design.CI.Fu 0.75*Design.CI.Fu*Design.CI.Area*0.1 Design.CI.Nmax(2)/1000])

%%
% _*8.3.- Verificación de las diagonales.*_
%
% Se procede a la verificación del perfil adoptado según los requerimientos
% establecidos por la norma CIRSOC 303-2009 para la resistencia a la
% compresión axil.
if Design.DI.Tipo == 'U'
    copyfile('./Informes/FigurasFijas/Perfil-U.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/perfilDI.png']) 
elseif Design.DI.Tipo == 'C'
    copyfile('./Informes/FigurasFijas/Perfil-C.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/perfilDI.png'])
end
%%
% <<perfilDI.png>>
%
% Fig: Esquema del perfil adoptado para las diagonales.
%
% Propiedades del perfil:
if Design.DI.Tipo == 'C'
    fprintf('B = %1.1fmm    t = %1.2fmm\n',[Design.DI.Bp*10 Design.DI.t*10])
    fprintf('R = %1.2fmm    Ht = %1.2fmm\n',[Design.DI.r*10 Design.DI.Ap*10])
    fprintf('A = %1.2fcm²\n',[Design.DI.Area])
    fprintf('Ixx = %1.2fcm⁴  Iyy = %1.2fcm⁴\n',[Design.DI.Ix Design.DI.Iy])
    fprintf('rx = %1.2fcm    ry = %1.2fcm\n',[Design.DI.rx Design.DI.ry])
    fprintf('Cw = %1.2fcm⁶  J = %1.2fcm⁴\n',[Design.DI.Cw Design.DI.J])
    fprintf('x0 = %1.2fcm    r0 = %1.2fcm\n',[Design.DI.x0 Design.DI.r0])
elseif Design.DI.Tipo == 'U'
    fprintf('B = %1.1fmm    t = %1.2fmm\n',[Design.DI.Bp*10 Design.DI.t*10])
    fprintf('R = %1.2fmm    Ht = %1.2fmm\n',[Design.DI.r*10 Design.DI.Ap*10])
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
% estados límites de (a) fluencia en la sección bruta, (b) rotura en la
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

fprintf(['Td = Øt·Ag·Fy·0.1 = 0.9·%1.0f·%1.2f·0.1 = ' VerifFluBru],[Design.DI.Area Design.DI.Fy 0.9*Design.DI.Fy*Design.DI.Area*0.1 Design.DI.Nmax(2)/1000])
%%
%  (b) Rotura en la sección neta (Art. C.2-2)
if 0.75*Design.DI.Fu*Design.DI.Area*0.1>Design.DI.Nmax(2)/1000
    VerifRotNet = '%1.2fkN > %1.2fkN  B.C.\n';
else
    VerifRotNet = '%1.2fkN < %1.2fkN  M.C.!!! NO VERIFICA REDIMENSIONAR ?\n';
end
fprintf(['Td = Øt·An·Fu·0.1 = 0.75·%1.2f·%1.2f·0.1 = ' VerifRotNet],[Design.DI.Area Design.DI.Fu 0.75*Design.DI.Fu*Design.DI.Area*0.1 Design.DI.Nmax(2)/1000])

%%
% _*8.4.- Verificación de las barras de apoyos de la cercha.*_
%
% Se procede a la verificación del perfil adoptado según los requerimientos
% establecidos por la norma CIRSOC 303-2009 para la resistencia a la
% compresión axil.
if Design.DA.Tipo == 'U'
    copyfile('./Informes/FigurasFijas/Perfil-U.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/perfilDA.png']) 
elseif Design.DA.Tipo == 'C'
    copyfile('./Informes/FigurasFijas/Perfil-C.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/perfilDA.png'])
end
%%
% <<perfilDA.png>>
%
% Fig: Esquema del perfil adoptado para barras de apoyo de la cercha.
%
% Propiedades del perfil:
if Design.DA.Tipo == 'C'
    fprintf('B = %1.1fmm    t = %1.2fmm\n',[Design.DA.Bp*10 Design.DA.t*10])
    fprintf('R = %1.2fmm    Ht = %1.2fmm\n',[Design.DA.r*10 Design.DA.Ap*10])
    fprintf('A = %1.2fcm²\n',[Design.DA.Area])
    fprintf('Ixx = %1.2fcm⁴  Iyy = %1.2fcm⁴\n',[Design.DA.Ix Design.DA.Iy])
    fprintf('rx = %1.2fcm    ry = %1.2fcm\n',[Design.DA.rx Design.DA.ry])
    fprintf('Cw = %1.2fcm⁶  J = %1.2fcm⁴\n',[Design.DA.Cw Design.DA.J])
    fprintf('x0 = %1.2fcm    r0 = %1.2fcm\n',[Design.DA.x0 Design.DA.r0])
elseif Design.DA.Tipo == 'U'
    fprintf('B = %1.1fmm    t = %1.2fmm\n',[Design.DA.Bp*10 Design.DA.t*10])
    fprintf('R = %1.2fmm    Ht = %1.2fmm\n',[Design.DA.r*10 Design.DA.Ap*10])
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
% estados límites de (a) fluencia en la sección bruta, (b) rotura en la
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

fprintf(['Td = Øt·Ag·Fy·0.1 = 0.9·%1.0f·%1.2f·0.1 = ' VerifFluBru],[Design.DA.Area Design.DA.Fy 0.9*Design.DA.Fy*Design.DA.Area*0.1 Design.DA.Nmax(2)/1000])
%%
%  (b) Rotura en la sección neta (Art. C.2-2)
if 0.75*Design.DA.Fu*Design.DA.Area*0.1>Design.DA.Nmax(2)/1000
    VerifRotNet = '%1.2fkN > %1.2fkN  B.C.\n';
else
    VerifRotNet = '%1.2fkN < %1.2fkN  M.C.!!! NO VERIFICA REDIMENSIONAR ?\n';
end
fprintf(['Td = Øt·An·Fu·0.1 = 0.75·%1.2f·%1.2f·0.1 = ' VerifRotNet],[Design.DA.Area Design.DA.Fu 0.75*Design.DA.Fu*Design.DA.Area*0.1 Design.DA.Nmax(2)/1000])

%%
% *9.- Dimensionamiento de las columnas.* 
%
% Según el artículo 10.8 del CIRSOC el lado mínimo de una columna debe ser
% mayor a 200mm y el diámetro de las barras no menor a 12mm.
%
% _*9.1.- Predimensionamiento.*_
%
% Dimensiones de la columna:
fprintf('Lado menor: bc = %1.0fcm\n',[Prob_data.Mat.Hormigon.Geom.b*100])
fprintf('Lado mayor: ac = %1.0fcm\n',[Prob_data.Mat.Hormigon.Geom.h*100])
% Donde *Ag* es el área bruta de la columna: 
Ag = Prob_data.Mat.Hormigon.Geom.h*100*Prob_data.Mat.Hormigon.Geom.b*100;
fprintf('Ag = %1.0fcm·%1.0fcm = %1.0fcm²',[Prob_data.Mat.Hormigon.Geom.h*100 Prob_data.Mat.Hormigon.Geom.b*100 Ag])
%%
% Además, se considera un recubrimiento de 3cm.
%%
% _Armadura adoptada_: El acero es de tipo 420.
AstPred = Prob_data.Mat.Hormigon.Geom.Nb*(Prob_data.Mat.Hormigon.Geom.Db/10)^2*pi()/4;
fprintf('Armadura principal por cara: Ast = %1.0fØ%1.0f = %1.2fcm²\n',[Prob_data.Mat.Hormigon.Geom.Nb Prob_data.Mat.Hormigon.Geom.Db AstPred])
%AsEstr = (Diam_Estr/10)^2*pi()/4*(TipoAcero*10/1.75*2/bc/Sep_Estr)
AePred = (Prob_data.Mat.Hormigon.Geom.De/10)^2*pi()/4*(420*10/1.75*2/Prob_data.Mat.Hormigon.Geom.b/100/Prob_data.Mat.Hormigon.Geom.Se/100);
fprintf('Armadura de corte: Ae = Ø%1.0fc/%1.0fcm\n',[Prob_data.Mat.Hormigon.Geom.De Prob_data.Mat.Hormigon.Geom.Se*100])

%%
% _*9.2.- Verificaciones.*_
%
% La armadura mínima es:
Astmin = 0.01*Ag;
if Astmin < AstPred
    fprintf('Astmin = 0.01·Ag = 0.01·%1.0fcm² = %1.2fcm² < Ast = %1.2fcm²   B.C.',[Ag 0.01*Ag AstPred])
else
    fprintf('MALAS CONDICIONES: Se debe redimensionar la armadura a flexión, ya que no cumple con la cuantía mínima.?')
end

%%
% La armadura mínima por retracción y fragüe:
Asmin = 0.0018*Ag;
if Asmin < AstPred
    fprintf('Asmín = 0.0018·bc·ac = 0.0018·%1.0fcm·%1.0f = %1.2fcm² < Ast = %1.2fcm²   B.C.',[Prob_data.Mat.Hormigon.Geom.b*100 Prob_data.Mat.Hormigon.Geom.h*100 Asmin AstPred])
else
    fprintf('MALAS CONDICIONES: Se debe redimensionar la armadura de flexión. La misma no cumple al mínimo por retracción y fragüe ?')
end
%% 
% La armadura por flexión:

[FlexVerif, CorteVerif, kh, ks_res, As_nec, tau, ZonaCorte, TensCorte, TensAsEstr] = Verif_Columna(Design.HA.Mmax(Prob_data.Mat.Hormigon.Fund.MinGamm)/100, ...
    Design.HA.Qmax(Prob_data.Mat.Hormigon.Fund.MinGamm)/10000, -1, Design.HA.TipoHA, Design.HA.TipoAcero, Prob_data.Mat.Hormigon.Geom.h*100, ...
    Prob_data.Mat.Hormigon.Geom.b*100, Prob_data.Mat.Hormigon.Geom.Db,...
                      Prob_data.Mat.Hormigon.Geom.Nb, 3, Prob_data.Mat.Hormigon.Geom.De, Prob_data.Mat.Hormigon.Geom.Se*100, Prob_data.Mat.Hormigon.Geom.nm);
%%
% Para la determinación de la armadura de flexión:
fprintf('kh = %1.2f, por lo tanto:  ks = %1.2f. \n', [kh ks_res])

if FlexVerif
    fprintf('Astmín = %1.2fcm² < Ast = %1.2fcm²    B.C.\n',[As_nec AstPred])
else
    fprintf('MALAS CONDICIONES: Se debe redimensionar la armadura de flexión. ?\n')
end

%%
% La armadura por corte:
fprintf('Tau = %1.2fkg/cm²; por lo tanto:  Zona de Corte: %1.0f; y la Tensión de Corte: %1.2fkg/cm² \n',[tau ZonaCorte TensCorte])
if CorteVerif
    fprintf('TensCorte = %1.2fkg/cm² < Ase = %1.2fkg/cm² B.C.\n',[TensCorte TensAsEstr])
else
    fprintf('MALAS CONDICIONES: Se debe redimensionar la armadura de corte. ?\n')
end

%%
% *10.- Determinación del momento estabilizador de la fundación por el
% método de SULZBERGER*
%
% El método se basa en un postulado que establece que para inclinaciones
% límites del conjunto soporte (fundación) en un ángulo “α” respecto de la
% vertical, tal que “tg(α)≤0,01”, el terreno se comportará de forma
% elástica. De esta forma se obtiene además de una reacción en el fondo de
% la fundación, una reacción de las paredes verticales, ambas definirán un
% momento estabilizador que se opondrá al momento de vuelco provocado por
% las cargas exteriores. Por esta razón, se adopta una inclinación del
% conjunto fundación-soporte tal que tg(α)=0,01, pretendiendo aprovechar al
% máximo el comportamiento elástico del suelo.
%
% _*10.1.- Características del suelo.*_
%
% 
SigAdm = 110; %kN/m2
fprintf('σadm = %1.0fkN/m² (%1.1fkg/cm²) ?\n',[SigAdm SigAdm/100])
%%
% 
fprintf('C = %1.0fkN/m³ (%1.0fkg/cm³)\n',[Prob_data.Mat.Hormigon.Fund.C*10000 Prob_data.Mat.Hormigon.Fund.C])
%%
%  Coeficiente de fricción entre el terreno y el hormigón:
mu = 0.4;
fprintf('μ = %1.1f\n',mu)
%%
% Tangente del ángulo de giro *α* permitido de la base:
fprintf('tg(α) = %1.2f\n',Prob_data.Mat.Hormigon.Fund.am)
%%
% Mínima relación entre los momentos dados por Sulzberguer y el momento de
% volcamiento:
fprintf('Gamma = %1.2f\n',Prob_data.Mat.Hormigon.Fund.gm)
%%
% _*10.2.- Características de los elementos estructurales.*_
%
% Profundidad de fundación:
fprintf('H = %1.2fm\n',Prob_data.Mat.Hormigon.Fund.Hf)
%%
% Altura de la base de hormigón:
fprintf('t = %1.2fm\n',Prob_data.Mat.Hormigon.Fund.t)
%%
% Lados de la base de hormigón, normal y paralelo a la cumbrera, respectivamente:
fprintf('af = %1.2fm;    bf = %1.2fm',[Prob_data.Mat.Hormigon.Fund.a Prob_data.Mat.Hormigon.Fund.b])
[Mensaje1, Mensaje2, G, Mequil, Mv, Ms, Mb] = Verificacion_Fundacion_Sulzberguer((Prob_data.Mat.Hormigon.Fund.Hf - Prob_data.Mat.Hormigon.Fund.t)*100,...
        Prob_data.Mat.Hormigon.Fund.C, Prob_data.Mat.Hormigon.Fund.t*100, Prob_data.Mat.Hormigon.Fund.am, ...
        Prob_data.Mat.Hormigon.Fund.a*100, Prob_data.Mat.Hormigon.Fund.b*100, Prob_data.Mat.Hormigon.Geom.h*100, ...
        Prob_data.Mat.Hormigon.Geom.b*100, Prob_data.Mat.Hormigon.Mat.PesEsp*100, Design.HA.Fund.FzaV(Prob_data.Mat.Hormigon.Fund.MinGamm), Design.HA.Fund.FzaH(Prob_data.Mat.Hormigon.Fund.MinGamm), Design.HA.Fund.M(Prob_data.Mat.Hormigon.Fund.MinGamm), Prob_data.Mat.Hormigon.Fund.gm);
Mequil = Mequil/100/101.97;
Ms = Ms/100/101.97;
Mv = Mv/100/101.97;
Mb = Mb/100/101.97;
G = G/101.97;
%%
% _*10.3.- Determinación del momento estabilizante.*_ 
% 
% El momento estabilizante *Me* producido por la fundación está conformado
% por dos momentos:
%%
% 
% # Momento de empotramiento *Ms* debido a las reacciones de las
% paredes verticales de la fundación y a la fricción entre el suelo y el
% hormigón.
% # Momento de reacción de fondo *Mb* debido a la reacción de fondo
% de la fundación, provocado por las cargas verticales actuantes.
% 
% _*Cálculo de Ms:*_ El método de Sulzberger acepta que la profundidad de
% entrada del bloque dentro del terreno depende de la resistencia
% específica o “presión admisible del suelo” contra la presión externa en
% el lugar considerado. Esta presión es igual a la profundidad multiplicada
% por el índice de compresibilidad *C*.
%
% *σ = C.λ*
% 
% Donde *λ* es la deformación del suelo producida por la fuerza externa y *C*
% esta expresado en kN/m³.
%
copyfile('./Informes/FigurasFijas/Fig_Sulz01.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_Sulz01.png'])
%%
% <<Fig_Sulz01.png>>
%
% Considerando que la fricción en el fondo de la excavación actúa en su
% valor total, el eje de giro del bloque se ubica en la base del mismo. Una
% inclinación con ángulo α corresponde a un movimiento transversal de la
% superficie “bf.dy” igual a “y.tg(α)”, donde “bf” es la dimensión del
% bloque normal a la fuerza F, mientras que “y” es la distancia entre la
% superficie mencionada y la base del bloque. Siendo Cy el índice de
% compresibilidad del terreno en la profundidad considerada, la presión
% unitaria será igual a:
%
% *σy = Cy·y·tg(α)*
%
% Expresión similar a la escrita anteriormente. La fuerza de reacción de la
% pared de excavación será:
%
% *dFy =Cy·y·tg(α)·b·dy*
%
% El momento respecto al eje de giro en la base será: 
%
% *dMs = Cy·b·dy·y²·tg(α)*
% 
copyfile('./Informes/FigurasFijas/Fig_Sulz02.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_Sulz02.png'])
%%
% <<Fig_Sulz02.png>>
%
% Donde “Cy·b·dy·y²” representa el momento de inercia de la superficie de
% carga “Cy·b·dy” con respecto al eje de giro. Entonces se puede escribir
% como:
%
% *dMs = dI·tg(α)* 
%
% El índice C es una función lineal de la profundidad, por lo que se puede
% decir que la superficie total de carga tiene la forma de un triángulo
% isósceles con la base igual a “Ct·b” y una altura “t”. Designado el valor
% de “C” en la profundidad “t” por “Ct” se puede establecer:
%
% *Cy = Ct · (1 - y/t)*
%
% Entonces: *dI = Ct·(1 - y/t)·b·y²·dy*
% 
% Por lo tanto: *I = (Ct·b·t³) / 12*
%
% Siendo el momento de empotramiento:
%
% *Ms = (1/12)·(bf·t³)·Ct·tg(α)*
%
% *Momento de empotramiento considerando el centro de giro actuando en la
% base, cuando es inminente el desplazamiento de la base en el fondo.*
%
% Una vez excedida la capacidad friccional del fondo el eje empieza a
% levantarse de su posición en el fondo de la excavación por lo que para
% determinar el ángulo α que corresponde al momento se procede de la
% siguiente forma. La presión unitaria en la profundidad “t-y” es igual a:
%
% *σy = Cy·λy*       pero con       *λy = y·tg(α)*
%
% Siendo:   *Cy = Ct·(1 - y/t)*      →     *σy = Ct·(1-y/t)·y·tg(α)*
% 
% Por lo que *σy* representa una función parabólica simétrica en relación con
% la recta *y = t/2* (Ver figura).
% 
% Designando con *R = µ.G* la resultante de las fuerzas de resistencia de
% la pared considerada, se puede escribir como:
% 
% *Ms = μ·G·t/2*
%
copyfile('./Informes/FigurasFijas/Fig_Sulz03.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_Sulz03.png'])
%%
% <<Fig_Sulz03.png>>
% 
% Siendo *G* la resultante de las cargas verticales y *μ* el coeficiente de
% fricción estática entre la tierra y el hormigón al fondo de excavación.
% Se considera que el eje de giro empieza a levantarse y el ángulo que
% corresponde a este momento se puede calcular de la siguiente forma:
%
% *μ·G·t/2 = (1/12)·b·t³·Ct·tg(α)*
%
% siendo
%
% *tg(α) =  (6·μ·G) / (b·Ct·t²)*
% 
% Con el aumento del ángulo α disminuye la fricción hasta desaparecer. Por
% lo tanto, se desprecia la fricción de fondo y se obtiene una situación en
% la que el eje de giro se encuentra en el centro de gravedad de la
% superficie de carga a una distancia igual a 1/3 de la profundidad *t*.
% Por lo que el momento de inercia del triángulo con respecto al eje que
% pasa por su baricentro es:
% 
% *I=(1/36)·bf·t³·Ct*    por lo tanto     *Ms = (1/36)·bf·t³·Ct·tg(α)*
% 
% Entonces el momento de empotramiento para el bloque de fundación con las
% características mencionadas anteriormente considerando que el eje se
% levanta de su posición en el fondo, será:
% 
fprintf('Ms = bf·t³/36·Ct·tg(α) = %1.2fkNm',Ms)

%%
% _*Cálculo de Mb:*_ Las cargas verticales hacen que el bloque se
% introduzca en el terreno hasta una profundidad igual a:
%
% *λ0 = G/(af·bf·Cb)*  (cm)
% 
% Donde:
% *G*: Es la resultante de las cargas verticales.
% *af·bf*: Son las dimensiones de la base rectangular.
% *Cb*: Índice de compresibilidad en el fondo.
% 
% Bajo la acción del momento exterior de volcamiento aplicado en la
% estructura, el bloque de fundación se inclina un ángulo “α” levantándose
% en un extremo y bajándose en el opuesto.
%
% La resultante de las fuerzas de reacción de fondo es igual a G. Donde G
% es la suma de las acciones verticales de la superestructura más el peso
% propio de la fundación más el peso del talud de suelo gravante. Con
% aumento del ángulo “α” se acorta el prisma de tensiones generado por la
% resultante G. Por lo que el centro de giro debe encontrarse por encima
% del centro de gravedad del prisma, siendo para condiciones de equilibrio
% cuando la base del bloque toca el fondo de excavación en su superficie
% total, se puede establecer lo siguiente:
%
% *Mb = G·s*           siendo      *s =  af/2 - c*
%
% Con   *c = (af/3)·[(λ0+λ')+2·(λ0-λ')] / [(λ0+λ')+(λ0-λ')]
% = af·[0,5 - λ'/(6·λ0)]*
% 
% *λ' = af/2·tg(α)*;      *λ0 = G / (af·bf·Cb)*
% 
% →     *s = (af³·bf·Cb)/(12·G)·tg(α)*
%
% ∴  *Mb =  (1/12)·bf·af³·Cb·tg(α)*
% 
copyfile('./Informes/FigurasFijas/Fig_Sulz04.png', ['./Informes/Proyecto_' Prob_data.Rell.Proyect '/Fig_Sulz04.png'])
%%
% <<Fig_Sulz04.png>>
% 
% La posición externa se caracteriza por un ángulo *α* obtenido de la
% siguiente forma:
% 
% *af·tg(α) = 2·λ0*   ∴  *tg(α) = (2·G)/(af·bf·Cb)*
% 
% En condiciones en que la base se levante hasta el punto en que no toque
% el fondo, se puede calcular el momento de la siguiente forma:
% 
% *Mb = G·s = G·(af/2 - x/3)*
% 
% Siendo el volumen del prisma de tensiones igual a:
% 
% *G = σ·bf·x/2*
% 
% Donde *σ* es la tensión máxima del terreno al fondo de la excavación:
% 
% *σ = Cb·(λ0 + λ') = Cb·x·tg(α)*
% ∴ *G = 1/2·x²·bf·Cb·tg(α)*
% 
% Siendo:    *x = [(2·G)/(bf·Cb·tg(α))]*
% 
% Por lo tanto, sustituyendo dichos valores en la ecuación del momento *Mb*, se tiene:
% 
fprintf('Mb = G·[af/2-0.471·( G / sqrt(bf·Cb·tgα))]')
%%
% 
% Se procede al cálculo del momento de fondo considerando que la base se
% levanta hasta no tocar dicha superficie, se tiene:
%
% *G = Gc + Gb*
%
% *Gc = γh·(ac.bc.h)*
% 
% *Gb = γh·(af.bf.t)*
%
% Siendo *Cb = 1,2.Ct*. Por lo tanto se tiene:
% 
fprintf('Mb = G·[af/2-0.471·sqrt(G/(bf·Cb·tgα))] = %1.2fkNm', Mb)
%%
% 
% Y el momento estabilizador será: 
fprintf('Me = Ms + Mb = %1.2fkNm + %1.2fkNm = %1.2fkNm',[Ms Mb Mequil])
%%
%
% Por otro lado, el momento de volcamiento se determina de la siguiente
% manera:
fprintf('Mv = MaxFzaH·(H + 2/3·t) + M = %1.2fkNm\n', Mv)
if Mensaje1
    fprintf('Me = %1.2fkNm > %1.2fkNm = gamma·Mv    B.C.\n',[Mequil Prob_data.Mat.Hormigon.Fund.gm*Mv])
else
    fprintf('Me = %1.2fkNm < %1.2fkNm = gamma·Mv.... MALAS CONDICIONES ? La base no verifica al volcamiento.\n',[Mequil Prob_data.Mat.Hormigon.Fund.gm*Mv])
end
%%
% _*10.4.- Verificación al arrancamiento.*_
% 
% La resultante de cargas verticales *G* debe cumplir:
if Mensaje2
    fprintf('G = %1.2fkN > %1.2fkN B.C. para la verificación al arrancamiento.\n',[G max(Design.HA.Fund.FzaV)])
    if all(Design.HA.Fund.FzaV<0)
        fprintf('El peso propio proporciona una resultante hacia abajo, como acción contraria para todos los casos de succión de viento.')
    end
else
    fprintf('MALAS CONDICIONES: NO VERIFICA AL ARRANCAMIENTO ? ')
end
%%
% _*10.5.- Verificación de tensión máxima del suelo.*_
%
% Las cargas gravitatorias máximas son:
FVMax = Prob_data.Mat.Hormigon.Fund.MaxFzaBase;
fprintf('FVertMáx = %1.2fkN', [FVMax])
%%
% Por lo tanto, la relación entre tensión de trabajo y tensión admisible
% del suelo es:
SigAdm = 110; %kN/m2
SigTra = FVMax/(Prob_data.Mat.Hormigon.Fund.a*Prob_data.Mat.Hormigon.Fund.b);
if SigAdm/SigTra > 1
    fprintf('σadm/σtrb = %1.0fkN/m²/%1.0fkN/m² = %1.0f ? > 1    B.C.\n',[SigAdm SigTra SigAdm/SigTra])
else
    fprintf('σadm/σtrb = %1.0fkN/m²/%1.0fkN/m² = %1.0fkN/m² ? < 1    MALAS CONDICIONES A LA TENSIÓN DE TRABAJO DEL SUELO\n',[SigAdm SigTra SigAdm/SigTra])
end
