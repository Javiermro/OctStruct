function [Prob_data] = Geometry(Prob_data) 

global model 

switch model
    case 1 % Dos aguas CS perpendicular a Diagonal
        fprintf('Modelo de cercha %3i \n',model)
        Prob_data = model1(Prob_data) ;
        aguas = 1;
    case 2 % Dos aguas Diagonal vertical 
        fprintf('Modelo de cercha %3i \n',model)
        Prob_data = model2(Prob_data) ;
        aguas = 2; %1;
    case 3 % Dos aguas montantes verticales 
        fprintf('Modelo de cercha %3i \n',model)
        Prob_data = model3(Prob_data) ;
        aguas = 3; %1;
    case 4 % Dos aguas curvo
        fprintf('Modelo de cercha %3i \n',model)
        aguas = 4; %3;
        Prob_data = model4(Prob_data) ;
    case 5 % Un agua 
        fprintf('Modelo de cercha %3i \n',model)
        aguas = 5; %2;
        Prob_data = model5(Prob_data) ; 
    case 6 % Un agua 
        fprintf('Modelo de cercha %3i \n',model)
        aguas = 6; %2;
        Prob_data = model6(Prob_data) ; 
    otherwise
        error('Modelo de cercha no implementado')
end 
% StructurePlot(conec,nodos) ; 

Prob_data.Cargas.estados = 1 ; % Peso propio + Cargas de uso (si las hay)
Prob_data.Cargas.Viento = [] ;

if Prob_data.Cargas.Factor(2)~=0.0
    [m_CargasEySE,Data] = test_viento(Prob_data,aguas) ; % m , N/m
% La matriz de m_CargasEySE tiene la siguiente estructura:
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
    Prob_data.Cargas.estados = Prob_data.Cargas.estados + ...
        size(m_CargasEySE,1) -1 ;        
    Prob_data.Cargas.Viento = m_CargasEySE ;
    Prob_data.Cargas.Kzt = Data.Kzt;
    Prob_data.Cargas.Kd = Data.Kd;
    Prob_data.Cargas.I = Data.I;
    Prob_data.Cargas.G = Data.G;
    Prob_data.Cargas.ZKzqz = Data.ZKzqz;   
else
    Prob_data.Cargas.Carac = 'Otro' ;
end  

switch Prob_data.Cargas.Carac
    case {'PCerrad','Cerrado'}
        Prob_data.Cargas.p_vnc = Data.p_vnc;
        Prob_data.Cargas.p_vpc = Data.p_vpc;
    case 'Aislado'
        Prob_data.Cargas.p_v = Data.p_v;
        Prob_data.Cargas.m_Cpn = Data.m_Cpn;
end 
