function Mensaje1 = Verificacion_Fundacion_Arranc(H,t,a,b,ac,bc,PesEspHA,PP_Est,P_arranc)

% Resultante de cargas verticales.
PesoTotal = t*a*b/100^3*PesEspHA + ac*bc*H/100^3*PesEspHA + PP_Est;

% Verificación.
Mensaje1 = PesoTotal > P_arranc;


end
