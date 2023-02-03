function [m_CargasEySE,Data] = test_viento(Prob_data,model) 

% Datos de exposición de la estructura.
Exp = Prob_data.Cargas.Exp ;
Cat = Prob_data.Cargas.Cat ;
V   = Prob_data.Cargas.V ;
Edif= Prob_data.Cargas.Carac; %'EdCerr';'EdParCerr'; 'EdAbierto';

if strcmp(Edif, 'Aislado')
    Epsilon = Prob_data.Cargas.Epsilon;
    PosBloq = Prob_data.Cargas.PosBloqueo;
else
    Epsilon = [];
    PosBloq = [];
end

% Datos geométricos de la estructura.
L = Prob_data.Geom.Lt ;
B = Prob_data.Geom.L ;
% Bc = Prob_data.Geom.Bc ;
if model~=4
    theta = atand(Prob_data.Geom.pend(1));
else
    % Cubierta curva, se toma la Flecha
    theta = Prob_data.Geom.f;
end
h_al = Prob_data.Geom.Hc ;
h_cumb = Prob_data.Geom.Hmax;
h_med = (h_cumb+h_al)/2;
SepCerch = Prob_data.Geom.Sep;

if h_al > 5
    z = [5 h_al];
else
    z = [h_al];
end

CotaTramoMedio1 = h_al + (h_cumb - h_al)/3;
CotaTramoMedio2 = h_al + (h_cumb - h_al)*2/3;
z = [z CotaTramoMedio1 CotaTramoMedio2 h_cumb h_med];
[m_CargasEySE,Data] = main_viento(V,Exp,Cat,Edif,z,L,B,SepCerch,theta,model,Epsilon,PosBloq);

end
