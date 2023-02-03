function Datos = AreaEfect(Datos)
%
% Determinación del área efectiva del perfil sometido a compresión simple.

% Extracción de datos
t = Datos.t;
be_E1 = Datos.be_E1;
be_E2 = Datos.be_E2;
be_E3 = Datos.be_E3;
be_E4 = Datos.be_E4;




% Recolección de datos
Datos.Aefect = Aefect;


end