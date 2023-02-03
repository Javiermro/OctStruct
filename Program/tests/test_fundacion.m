function test_fundacion(Prob_data,Elem_data,ie)

global model

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

H = (Prob_data.Mat.Hormigon.Fund.Hf - Prob_data.Mat.Hormigon.Fund.t)*100 ; % altura del fuste pasado a cm
t = Prob_data.Mat.Hormigon.Fund.t*100 ; % Altura de la base de hormigón pasado a cm
a = Prob_data.Mat.Hormigon.Fund.a*100 ; % Lado de la base de hormigón, normal a cumbrera pasado a cm
b = Prob_data.Mat.Hormigon.Fund.b*100 ; % Lado de la base de hormigón, paralelo a cumbrera pasado a cm
bc= Prob_data.Mat.Hormigon.Geom.b*100 ; % Lado de la columna de hormigón, paralelo a cumbrera pasado a cm
ac= Prob_data.Mat.Hormigon.Geom.h*100 ; % Lado de la columna de hormigón, perpendicular a cumbrera pasado a cm

% PesoC  = Prob_data.Mat.Hormigon.Geom.b*Prob_data.Mat.Hormigon.Geom.h*Prob_data.Geom.Hc*...
%     Prob_data.Mat.Hormigon.Mat.PesEsp ; %Peso de columna en kN 
% PesoR  = PesoCercha(Prob_data,Elem_data) ; % Peso propio de la estructura de cercha y techo [kN] 
% PP_Est = (PesoC+PesoR)*0.10197*1000/2; % pasaje de kN a Kgf
% PP_Est = Elem_data(77).FLbar(1) ; %Reacción vertical en el empotramiento [N] (positivo hacia abajo)

C = Prob_data.Mat.Hormigon.Fund.C ; %5; % Coeficiente de Balasto a 2mts de profundidad[kg/cm3]
tgAlpha = Prob_data.Mat.Hormigon.Fund.am ; %0.01; % Valor adoptado del giro permitido de la base.
GammaMin = Prob_data.Mat.Hormigon.Fund.gm ; %1.5; % Mínima relación entre los momentos dados por Sulzberguer 
                % y el momento de volcamiento.
PesEspHA = Prob_data.Mat.Hormigon.Mat.PesEsp*0.10197*1000; % [kg/m3] Peso especifico del HºAº.
                

for ifun=1:2
    if ifun==1
        fprintf('\n*** Inicio de análisis al arrancamiento y volcamiento de la fundación izquierda, según la teoría de Sulzberguer: \n')
%        fprintf('\n*** Inicio de verificación de la columna izquierda de HA, para estado %2i ***\n',ie) 
%        FzaV [kg] Carga vertical producida por el estado de viento analizado, 
%             puede ser de tracción o compresión (positivo: fuerza vertical hacia abajo).
%        FzaH [kg] Carga horizontal en la cabeza de columna producida por el estado
%             de viento analizado.  
%        FzaV = Elem_data(col_izq).FLbar(1)*0.10197 ; % pasaje de N a Kgf
%        FzaH = Elem_data(col_izq).FLbar(2)*0.10197 ; % pasaje de N a Kgf
%        M    = Elem_data(col_izq).FLbar(3)*0.10197*100;  % pasaje de N.m a Kgf.cm
       FzaV = -Elem_data(col_izq).FLbar(1)*0.10197 ; % pasaje de N a Kgf
       FzaH = -Elem_data(col_izq).FLbar(2)*0.10197 ; % pasaje de N a Kgf
       M    = -Elem_data(col_izq).FLbar(3)*0.10197*100;  % pasaje de N.m a Kgf.cm
    elseif ifun==2
        fprintf('\n*** Inicio de análisis al arrancamiento y volcamiento de la fundación derecha, según la teoría de Sulzberguer: \n')
%        fprintf('\n*** Inicio de verificación de la columna derecha de HA, para estado %2i ***\n',ie) 
%        Mmax = max(abs(Elem_data(col_izq).FLbar([3 6]))) ;  % N.m
%        Qmax = max(abs(Elem_data(col_izq).FLbar([1 4]))) ;  % N
%        FzaV = Elem_data(col_der).FLbar(1)*0.10197 ; % pasaje de N a Kgf
%        FzaH = Elem_data(col_der).FLbar(2)*0.10197 ; % pasaje de N a Kgf
%        M    = Elem_data(col_der).FLbar(3)*0.10197*100;  % pasaje de N.m a Kgf.cm
       FzaV = -Elem_data(col_der).FLbar(1)*0.10197 ; % pasaje de N a Kgf
       FzaH = -Elem_data(col_der).FLbar(2)*0.10197 ; % pasaje de N a Kgf
       M    = -Elem_data(col_der).FLbar(3)*0.10197*100;  % pasaje de N.m a Kgf.cm
    end 
    [Mensaje1,Mensaje2] = Verificacion_Fundacion_Sulzberguer(H,C,t,tgAlpha,a,b,...
    ac,bc,PesEspHA,FzaV,FzaH,M,GammaMin); 
    if Mensaje1
        fprintf('    La fundación verifica al volcamiento \n')
    else
        warning('    La fundación NO VERIFICA al volcamiento \n')
    end
    if Mensaje2
       fprintf('    La fundación verifica al arrancamiento \n')
    else
       warning('    La fundación NO VERIFICA al arrancamiento \n')
    end     
end   
