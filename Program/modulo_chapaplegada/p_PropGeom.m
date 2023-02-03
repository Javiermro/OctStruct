function Datos = p_PropGeom(Datos)
%
% Calculo de las propiedades geometricas de los perfiles. Se utiliza el
% método lineal; la nomeclatura y el procedimiento está tomado del archivo
% Prop_geometricas_perfiles.pdf
% Unidades: In-> mm; Calculos-> cm; Out-> cm
% Stage = 1, se realiza el cálculo habitual. 
% Stage = 2, cálculo con las secciones reducidas por el análisis de sección efectiva a la flexión.

PerfilTipo = Datos.PerfilTipo;
Ap = Datos.Ap;
Bp = Datos.Bp;
Cp = Datos.Cp;
t = Datos.t;
r = Datos.r;

%% Párametros básicos
switch PerfilTipo
    case {'C','G'}
        alpha = 1;
    case 'U'
        alpha = 0;
end
a = Ap - (2*r+t);
ar = Ap - t;
b = Bp - (r+t/2+alpha*(r+t/2));
br = Bp - (t/2+alpha*t/2);
c = alpha*(Cp - (r + t/2));
cr = alpha*(Cp - t/2);
u = pi()*r/2;

%% Área de la sección
Area = t*(a+2*(b+u)+2*alpha*(c+u));

%% Momento de inercia y radio de giro con respecto al eje X
switch PerfilTipo
    case {'C','U'}
        epsx = 0.0833*c^3+c/4*(a-c)^2+u*(a/2+0.637*r)^2+0.149*r^2;
    case 'G'
        epsx = 0.0833*c^3+c/4*(a+c+4*r)^2+u*(a/2+1.363*r)^2+0.149*r^3;
end
Ix = 2*t*(0.0417*a^3 + b*(a/2+r)^2 + u*(a/2+0.637*r)^2 + 0.149*r^3 + alpha*epsx);
rx = sqrt(Ix/Area);

%% Distancia entre centroide y línea central del alma
xr = 2*t/Area * ( b*(b/2+r) + u*(0.363*r) + alpha*(u*(b+1.673*r) + c*(b+2*r))  );

%% Momento de inercia y radio de giro con respecto al eje Y
epsy = c*(b+2*r)^2 + u*(b+1.637*r)^2 + 0.149*r^3;
Iy = 2*t*(b*(b/2+r)^2 + 0.0833*b^3 + 0.356*r^3 + alpha*epsy) - Area*xr^2;
ry = sqrt(Iy/Area);

%% Distancia entre centro cortante y línea central del alma
switch PerfilTipo
    case {'C','U'}
        m = br*( (3*ar^2*br + alpha*cr*(6*ar^2-8*cr^2)) /  (ar^3+6*ar^2*br+alpha*cr*(8*cr^2-12*ar*cr+6*ar^2)) );
    case 'G'
        m = br*( (3*ar^2*br + alpha*cr*(6*ar^2-8*cr^2)) /  (ar^3+6*ar^2*br+alpha*cr*(8*cr^2+12*ar*cr+6*ar^2)) );
end

%% Distancia entre centroide y centro de cortante 
% El signo negativo indica que se mide en dirección negativa del eje X
x0 = -(m + xr);
r0 = sqrt(rx^2+ry^2+x0^2);
%% Constante torsionante de St. Venant
J = t^3/3 * (a + 2*(b+u) + 2*alpha*(c+u));

%% Constante de alabeo
switch PerfilTipo
    case {'C','U'}
        eps_al = 48*cr^4 + 112*br*cr^3 + 8*ar*cr^3 + 48*ar*br*cr^2 + 12*ar^2*cr^2 + 12*ar^2*br*cr + 6*ar^3*cr;
        Cw = ar^2*br^2*t/12*((2*ar^3*br + 3*ar^2*br^2 + alpha*eps_al) / (6*ar^2*br + (ar+2*cr*alpha)^3 -24*ar*cr^2*alpha));
    case 'G'
        eps_al = 48*cr^4 + 112*br*cr^3 + 8*ar*cr^3 - 48*ar*br*cr^2 - 12*ar^2*cr^2 + 12*ar^2*br*cr + 6*ar^3*cr;
        Cw = ar^2*br^2*t/12*((2*ar^3*br + 3*ar^2*br^2 + alpha*eps_al) / (6*ar^2*br + (ar+2*cr*alpha)^3));
end

%% Parámetros beta
bet_w = -(t*xr*ar^3/12 + t*xr^3*ar);
bet_f = t/2*((br-xr)^4-xr^4) + t*ar^2/4*((br-xr)^2-xr^2);
switch PerfilTipo
    case {'C','U'}
        bet_l = alpha*(2*cr*t*(br-xr)^3 + 2/3*t*(br-xr)*(ar/2)^3-(ar/2-cr)^3);
    case 'G'
        bet_l = 2*cr*t*(br-xr)^3 + 2/3*t*(br-xr)*((ar/2+cr)^3 -(ar/2)^3);
end
j  = 1/2/Iy * (bet_w + bet_f + bet_l) - x0;

%% Propiedades geométricas de elementos aislados
% Elemento 1 - Rigidizador
% Momento de inercia del labio rigidizador respecto de su eje baricéntrico
% paralelo al ala
Is_E1 = t*c^3/12;
% Momento de inercia necesario del labio rigidizador


%% Pasaje de datos a estructura
Datos.a = a; Datos.ar = ar; Datos.b = b; Datos.br = br; Datos.c = c; Datos.cr = cr;
Datos.Area = Area; Datos.Ix = Ix; Datos.Iy = Iy; Datos.Iyc = Iy/2; Datos.xr = xr;
Datos.rx = rx; Datos.ry = ry; 
Datos.Sx = Ix/(Ap/2); 
Datos.Sy = Iy/(Bp-t/2-xr); % Momento resistente respecto a la fibra del rigidizador
Datos.m = m; Datos.x0 = x0; Datos.r0 = r0;
Datos.J = J; Datos.Cw = Cw; Datos.j = j;
Datos.Is_E1 = Is_E1;
end