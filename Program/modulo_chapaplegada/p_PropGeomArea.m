function Area = p_PropGeomArea(tipo) 
% Calcula el area en cm^2
 
Perfil = textscan([tipo '-'],'%s%f%f%f%f','delimiter','-');
% Datos.Tipo = string(Perfil{1}); 
%% pasaje de mm a cm
##Ap = Perfil{2}/10;
##Bp = Perfil{3}/10;
##Cp = Perfil{4}/10;
##t =  Perfil{5}/10; 
Ap = Perfil{2}/10;
Bp = Perfil{3}/10;
Cp = Perfil{4}/10;
t =  Perfil{5}/10; 
r = 1.5*t; 

%% Párametros básicos
switch tipo(1) %string(Perfil{1}) %PerfilTipo
    case {'C','G'}
        alpha = 1;
    case 'U'
        alpha = 0;
end
a = Ap - (2*r+t); 
b = Bp - (r+t/2+alpha*(r+t/2)); 
c = alpha*(Cp - (r + t/2)); 
u = pi()*r/2;
 
Area = t*(a+2*(b+u)+2*alpha*(c+u)); 

