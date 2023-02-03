% Se arma un scrip para rellenar todos los datos necesarios a introducir en
% el informe. Se colocan a pata aquí y luego Javier los pone en el DAT.
Prob_data.Rell.Info.Ubic = '?UBICACION';
Prob_data.Rell.Info.Dest = '?DESTINO';
Prob_data.Rell.Proyect = Proyect;
% Impresión de los esfuerzos en barras
for i = 1:length(Elem_data)
    Prob_data.Tablas.Secciones{i} = Elem_data(i).Seccion.Tipo;
    Prob_data.Tablas.Long(i) = Elem_data(i).L; 
    if min(Elem_data(i).N(2,:)) > 0
        Prob_data.Tablas.CompMax(i) = 0;
        Prob_data.Tablas.TracMax(i) = max(Elem_data(i).N(2,:));
    else
        Prob_data.Tablas.CompMax(i) = min(Elem_data(i).N(2,:));
        Prob_data.Tablas.TracMax(i) = 0;
    end
    
    if i<=9
        if Elem_data(i).conec(3) == 10
            Prob_data.Tablas.Ubic{i} = ['S0' num2str(i)];
        elseif Elem_data(i).conec(3) == 20
            Prob_data.Tablas.Ubic{i} = ['I0' num2str(i)];
        elseif Elem_data(i).conec(3) == 30
            Prob_data.Tablas.Ubic{i} = ['D0' num2str(i)];
        elseif Elem_data(i).conec(3) == 31
            Prob_data.Tablas.Ubic{i} = ['D0' num2str(i)];
        elseif Elem_data(i).conec(3) == 0
            Prob_data.Tablas.Ubic{i} = ['C0' num2str(i)];
        else
            error('Designación desconocida de elementos de cercha')
        end
    else
        if Elem_data(i).conec(3) == 10
            Prob_data.Tablas.Ubic{i} = ['S' num2str(i)];
        elseif Elem_data(i).conec(3) == 20
            Prob_data.Tablas.Ubic{i} = ['I' num2str(i)];
        elseif Elem_data(i).conec(3) == 30
            Prob_data.Tablas.Ubic{i} = ['D' num2str(i)];
        elseif Elem_data(i).conec(3) == 31
            Prob_data.Tablas.Ubic{i} = ['D' num2str(i)];
        elseif Elem_data(i).conec(3) == 0
            Prob_data.Tablas.Ubic{i} = ['C' num2str(i)];
        else
            error('Designación desconocida de elementos de cercha')
        end
    end
end
Prob_data.Tablas.Ubic = string(Prob_data.Tablas.Ubic);
Prob_data.Tablas.Secciones = string(Prob_data.Tablas.Secciones);

% Datos de los perfiles diseñados
NdCS = [] ;
NdCI = [] ;
NdDI = [] ;
NdDA = [] ;
for ielem=1:nelem
    if Elem_data(ielem).conec(3)==10 % CS
        NdCS = [NdCS ; ielem Elem_data(ielem).N(2,:)] ;
    elseif Elem_data(ielem).conec(3)==20 % CI
        NdCI = [NdCI ; ielem Elem_data(ielem).N(2,:)] ;
    elseif Elem_data(ielem).conec(3)==30 % DI
        NdDI = [NdDI ; ielem Elem_data(ielem).N(2,:)] ;
    elseif Elem_data(ielem).conec(3)>=31 % DA
        NdDA = [NdDA ; ielem Elem_data(ielem).N(2,:)] ;
    end 
end
%% CS
[n1M,m1M]=max(NdCS(:,[2:end]));
[n2M,m2M]=max(n1M);
[n1m,m1m]=min(NdCS(:,[2:end]));
[n2m,m2m]=min(n1m);
Design.CS.Ap = Elem_data(m1m(m2m)).Seccion.Geom.Ap;
Design.CS.Bp = Elem_data(m1m(m2m)).Seccion.Geom.Bp;
Design.CS.Cp = Elem_data(m1m(m2m)).Seccion.Geom.Cp;
Design.CS.t = Elem_data(m1m(m2m)).Seccion.Geom.t;
Design.CS.r = Elem_data(m1m(m2m)).Seccion.Geom.r;
Design.CS = p_IngresoDatos([],Prob_data.Predim.CS,'CompSimple');
Design.CS = p_PropGeom(Design.CS);
Design.CS = p_TensComp(Design.CS);
Design.CS = p_AreaEfect(Design.CS);
Design.CS.Tipo = Prob_data.Predim.CS(1);
Design.CS.Nmax = [m1M(m2M) n1M(m2M) Elem_data(m1M(m2M)).L];
Design.CS.Nmin = [m1m(m2m) n1m(m2m) Elem_data(m1m(m2m)).L]; % [IDelem]

%% CI
[n1M,m1M]=max(NdCI(:,[2:end])) ;
[n2M,m2M]=max(n1M) ;
[n1m,m1m]=min(NdCI(:,[2:end])) ;
[n2m,m2m]=min(n1m) ;
Design.CI.Ap = Elem_data(m1m(m2m)).Seccion.Geom.Ap;
Design.CI.Bp = Elem_data(m1m(m2m)).Seccion.Geom.Bp;
Design.CI.Cp = Elem_data(m1m(m2m)).Seccion.Geom.Cp;
Design.CI.t = Elem_data(m1m(m2m)).Seccion.Geom.t;
Design.CI.r = Elem_data(m1m(m2m)).Seccion.Geom.r;
Design.CI = p_IngresoDatos([],Prob_data.Predim.CI,'CompSimple');
Design.CI = p_PropGeom(Design.CI);
Design.CI = p_TensComp(Design.CI);
Design.CI = p_AreaEfect(Design.CI);
Design.CI.Tipo = Prob_data.Predim.CI(1);
Design.CI.Nmax = [m1M(m2M) n1M(m2M) Elem_data(m1M(m2M)).L] ;
Design.CI.Nmin = [m1m(m2m) n1m(m2m) Elem_data(m1m(m2m)).L] ;

%% DI
[n1M,m1M]=max(NdDI(:,[2:end])) ;
[n2M,m2M]=max(n1M) ;
[n1m,m1m]=min(NdDI(:,[2:end])) ;
[n2m,m2m]=min(n1m) ;
Design.DI.Ap = Elem_data(m1m(m2m)).Seccion.Geom.Ap;
Design.DI.Bp = Elem_data(m1m(m2m)).Seccion.Geom.Bp;
Design.DI.Cp = Elem_data(m1m(m2m)).Seccion.Geom.Cp;
Design.DI.t = Elem_data(m1m(m2m)).Seccion.Geom.t;
Design.DI.r = Elem_data(m1m(m2m)).Seccion.Geom.r;
Design.DI = p_IngresoDatos([],Prob_data.Predim.DI,'CompSimple');
Design.DI = p_PropGeom(Design.DI);
Design.DI = p_TensComp(Design.DI);
Design.DI = p_AreaEfect(Design.DI);
Design.DI.Tipo = Prob_data.Predim.DI(1);
Design.DI.Nmax = [m1M(m2M) n1M(m2M) Elem_data(m1M(m2M)).L] ;
Design.DI.Nmin = [m1m(m2m) n1m(m2m) Elem_data(m1m(m2m)).L] ;

%% DA
[n1M,m1M]=max(NdDA(:,[2:end])) ;
[n2M,m2M]=max(n1M) ;
[n1m,m1m]=min(NdDA(:,[2:end])) ;
[n2m,m2m]=min(n1m) ;
Design.DA.Ap = Elem_data(m1m(m2m)).Seccion.Geom.Ap;
Design.DA.Bp = Elem_data(m1m(m2m)).Seccion.Geom.Bp;
Design.DA.Cp = Elem_data(m1m(m2m)).Seccion.Geom.Cp;
Design.DA.t = Elem_data(m1m(m2m)).Seccion.Geom.t;
Design.DA.r = Elem_data(m1m(m2m)).Seccion.Geom.r;
Design.DA = p_IngresoDatos([],Prob_data.Predim.DA,'CompSimple');
Design.DA = p_PropGeom(Design.DA);
Design.DA = p_TensComp(Design.DA);
Design.DA = p_AreaEfect(Design.DA);
Design.DA.Tipo = Prob_data.Predim.DA(1);
Design.DA.Nmax = [m1M(m2M) n1M(m2M) Elem_data(m1M(m2M)).L] ; % Elemento Nmax [N] Long. [m]
Design.DA.Nmin = [m1m(m2m) n1m(m2m) Elem_data(m1m(m2m)).L] ; % Elemento Nmin [N] Long. [m]

%% CO
Design.CO.Ap = Prob_data.Predim.Correas.Datos.Ap ; % en [cm]
Design.CO.Bp = Prob_data.Predim.Correas.Datos.Bp; % en [cm]
Design.CO.Cp = Prob_data.Predim.Correas.Datos.Cp; % en [cm]
Design.CO.t = Prob_data.Predim.Correas.Datos.t; % en [cm]
Design.CO.r = Prob_data.Predim.Correas.Datos.r; % en [cm]
Design.CO = p_IngresoDatos([],Prob_data.Predim.CO,'CompSimple');
Design.CO = p_PropGeom(Design.CO);
Design.CO = p_TensComp(Design.CO);
Design.CO = p_AreaEfect(Design.CO);
Design.CO.Tipo = Prob_data.Predim.CO(1);
% Resistencia de diseño a la flexión para elementos arriostrados en toda la luz
Design.CO.Mmax = Prob_data.Predim.Correas.Mmax; % M de diseño, M admisible [N*m]
% Resistencia de diseño a la flexión para elementos arriostrados en los tercios de la luz con corrección de aplicación de cargas en el eje y
Design.CO.Mmin = Prob_data.Predim.Correas.Mmin; % M de diseño, M admisible [N*m]
Design.CO.Qmax = Prob_data.Predim.Correas.Qmax;
Design.CO.flecha = Prob_data.Predim.Correas.fmax ;
Design.CO.Rmax = Prob_data.Predim.Correas.Rmax ; % Reaccion máxima [N] , Pd_1 [N] , Pd_2 [N]
if Prob_data.Predim.Correas.q(1)<0
    Design.CO.q = Prob_data.Predim.Correas.q; % succion (-), presion (+)
else
    Design.CO.q(1) = Prob_data.Predim.Correas.q(2); % succion (-), presion (+)
    Design.CO.q(2) = Prob_data.Predim.Correas.q(1); % succion (-), presion (+)
end

%% HA
Design.HA.Geom = Elem_data(end).Seccion.Geom ;
Design.HA.Mmax = [max(abs([Elem_data(end-1).M  Elem_data(end).M]))] ; % N*m
Design.HA.Qmax = [max(abs([Elem_data(end-1).Q  Elem_data(end).Q]))] ; % N
Design.HA.TipoHA = str2num(Prob_data.Mat.Hormigon.Tipo(2:end))*10;
Design.HA.TipoAcero = 420;
%% Fundaciones:
Design.HA.Fund.FzaV = -([Elem_data(end-1).N(1,:) Elem_data(end).N(1,:)])*.10197; 
Design.HA.Fund.FzaH = -([Elem_data(end-1).Q(1,:) Elem_data(end).Q(1,:)])*.10197; 
Design.HA.Fund.M    = -([Elem_data(end-1).M(1,:) Elem_data(end).M(1,:)])*.10197*100; 
Design.HA.Fund.Hc   =  [Elem_data(end-1).L  Elem_data(end).L]; 

for i = 1:length(Design.HA.Fund.FzaV)
    [Mensaje1, Mensaje2, G(i), Mequil(i), Mv(i), ~, ~] = Verificacion_Fundacion_Sulzberguer((Prob_data.Mat.Hormigon.Fund.Hf - Prob_data.Mat.Hormigon.Fund.t)*100,...
        Prob_data.Mat.Hormigon.Fund.C, Prob_data.Mat.Hormigon.Fund.t*100, Prob_data.Mat.Hormigon.Fund.am, ...
        Prob_data.Mat.Hormigon.Fund.a*100, Prob_data.Mat.Hormigon.Fund.b*100, Prob_data.Mat.Hormigon.Geom.h*100, ...
        Prob_data.Mat.Hormigon.Geom.b*100, Prob_data.Mat.Hormigon.Mat.PesEsp*100, Design.HA.Fund.FzaV(i), Design.HA.Fund.FzaH(i), Design.HA.Fund.M(i), Prob_data.Mat.Hormigon.Fund.gm);
    if ~Mensaje1 || ~Mensaje2
        warning('Una base no verifica al volcamiento')
    end
end
[~,MinGamm] = min(Mequil./Mv);
Prob_data.Mat.Hormigon.Fund.MinGamm = MinGamm;
Prob_data.Mat.Hormigon.Fund.MaxFzaBase = abs(min(Design.HA.Fund.FzaV))/1000;