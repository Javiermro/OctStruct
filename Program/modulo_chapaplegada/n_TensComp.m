function Datos = n_TensComp(Datos)
%
% Determinación de la tensión de compresión de los elementos

% Pasaje de datos
E = Datos.E; Fy = Datos.Fy;
ky = Datos.ky; Ly = Datos.Ly; ry = Datos.ry;
kx = Datos.kx; Lx = Datos.Lx; rx = Datos.rx;
kt = Datos.kt; Lt = Datos.Lt;
x0 = Datos.x0; G = Datos.G; J = Datos.J;
Cw = Datos.Cw; Area = Datos.Area; r0 = Datos.r0;

% Tensión de pandeo elástico flexional alrededor del eje y-y (eje ppal
% normal al eje de simetría). 
Fey = pi()^2*E/(ky*Ly/ry)^2; % [MPa]

% Tensión de pandeo elástico flexotorsional alrededor del eje x-x (eje de
% simetría). 
sig_ex = pi()^2*E/(kx*Lx/rx)^2; % [MPa]

sig_t = 1/(Area*r0^2)*(G*J+pi()^2*E*Cw/(kt*Lt)^2); % [MPa]

beta = 1-(x0/r0)^2;
Fe = 1/2/beta*(sig_ex+sig_t-sqrt((sig_ex+sig_t)^2-4*beta*sig_ex*sig_t)); %[MPa]

Fe = min([Fe,Fey]);

% Tensión de compresión Fn
lamb_c = sqrt(Fy/Fe);
Fn = (lamb_c < 1.5)*(0.658^(lamb_c^2))*Fy + (lamb_c >= 1.5)*(0.877/lamb_c^2)*Fy;
% if lamb_c < 1.5
%     Fn = (0.658^(lamb_c^2))*Fy;
% else
%     Fn = (0.877/lamb_c^2)*Fy;
% end

% Recolección de nuevos datos
Datos.Fe = Fe;
Datos.Fn = Fn;

end
