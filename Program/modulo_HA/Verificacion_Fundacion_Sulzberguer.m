function [Mensaje1, Mensaje2, G, Mequil, Mv, Ms, Mb] = Verificacion_Fundacion_Sulzberguer(H,C,t,tgAlpha,...
    a,b,ac,bc,PesEspHA,FzaV,FzaH,M,GammaMin)

% Coeficiente de Balasto en la base de la fundación
Ct = C*t/200;
% Coeficiente de Balasto vertical del fondo
Cb = 1.2*Ct;
% Resultante de cargas verticales.
% Se invierte el signo, se toman positivas las cargas gravitatorias. Por
% ello a la variable 'FzaV' se le cambia el signo.
G = (t*a*b/100^3*PesEspHA + ac*bc*H/100^3*PesEspHA) - FzaV;
if G < 0 
    Mensaje1 = 0 ; 
    Mensaje2 = 0 ; 
else
    Mensaje2 = 1 ;
end
% Momento debido a las paredes verticales en resistencia pasiva, en el
% instante de desplazamiento de la base.
Ms = Ct/36*b*tgAlpha*t^3;
% Momento debido a la base
Mb = G*(a/2-0.47*sqrt(G/(b*Cb*tgAlpha))); % kg*cm
Mequil = Ms + Mb;
Mv = abs(FzaH*(H+2/3*t)-M);
Gamma = Mequil/Mv;
Mensaje1 = Gamma > GammaMin;
end
