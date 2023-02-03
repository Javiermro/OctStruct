function Prob_data=test_correas(Prob_data)

global model

fprintf('\n*** Inicio de verificación de las Correas para 4 estados de carga ***\n') 

%% DATOS
ncor = Prob_data.Geom.Lt/Prob_data.Geom.Sep ;
tipo = Prob_data.Predim.CO ; 
fig = Prob_data.Cargas.estados ;
%% Peso propio cubierta+correas 
% Carga distribuída debida al viento sobre correas
pp = [min(Prob_data.Cargas.NodCubPP(:,2)) max(Prob_data.Cargas.NodCubPP(:,2))]/Prob_data.Geom.Sep ; % en N/m
pp = pp*Prob_data.Cargas.Factor(1) ;

if isempty(Prob_data.Cargas.qCO) 
    q = pp(1) ;
else 
% peor condicion de carga
    suc = min(min(Prob_data.Cargas.qCO))*Prob_data.Cargas.Factor(2) ; % en N/m, (-) succion; (+) presion
    pre = max(max(Prob_data.Cargas.qCO))*Prob_data.Cargas.Factor(2) ; % en N/m, (-) succion; (+) presion

% se asume que el peso propio es perpendicular a la cumbrera 
    suc = -suc + pp(2) ; % succion (-) va hacia y+
    pre = -pre + pp(1) ; % presion (+) va hacia y-
    if suc<=0 ; suc = [] ; end
    if pre>=0 ; pre = [] ; end
    q = [suc pre] ; 
end 

%% PROPIEDADES MATERIALES  
E = Prob_data.Mat.Acero.E ;
L = Prob_data.Geom.Sep ;

%% DATOS para analisis de flexo-compresion
Lx  = L*100 ; % pasaje a cm 

Datos = p_IngresoDatos(Lx,tipo,'FlexEjMay');
Datos = p_PropGeom(Datos);
p_VerRelEsbltz(Datos);
Datos = p_TensComp(Datos);
Datos = p_AreaEfect(Datos);

% Md_1 = []; % Resistencia de diseño a la flexión para elementos arriostrados en toda su longitud.
% Md_2 = []; % Resistencia de diseño a la flexión para elementos arriostrados en los tercios de la luz.
% Md_2b = []; % IDEM anterior, con corrección de aplicación de cargas en el eje y
% Vd = []; % Resistencia de diseño al esfuerzo de corte.
% Pd_1 = []; % Resistencia de diseño al pandeo localizado del alma - Reacción en el apoyo.
% Pd_2 = []; % Resistencia de diseño al pandeo localizado del alma - Carga concentrada en el tramo.
[~,Md_1,~,Md_2b,Vd,Pd_1,Pd_2] = n_ResistDisen(Datos) ; % en kN*m y kN

Prob_data.Predim.DatosCO = Datos;

p_VerRelEsbltz(Datos);
Datos = p_TensComp(Datos);
Datos = p_AreaEfect(Datos);

%% METODO DE LA RIGIDEZ
I = Datos.Ix/100000000   ; % en cm^4 y pasaje a m^4
A = Datos.Area/10000 ; % en cm^2 y pasaje a m^2  

Kloc = [E*A/L   0.0         0.0       -E*A/L   0.0        0.0       ;
    0.0     12*E*I/L^3  6*E*I/L^2  0.0   -12*E*I/L^3  6*E*I/L^2 ;
    0.0     6*E*I/L^2   4*E*I/L    0.0   -6*E*I/L^2   2*E*I/L   ;
    -E*A/L  0.0         0.0        E*A/L  0.0         0.0       ;
    0.0    -12*E*I/L^3 -6*E*I/L^2  0.0    12*E*I/L^3 -6*E*I/L^2 ;
    0.0     6*E*I/L^2   2*E*I/L    0.0   -6*E*I/L^2   4*E*I/L ]  ; 

KGlob = zeros((ncor+1)*3,(ncor+1)*3) ;
for inod=1:ncor
    ind = (inod-1)*3+[1:6] ;
    KGlob(ind,ind) = KGlob(ind,ind) + Kloc ;
end

icond = zeros(1,(ncor+1)*3) ;
icond(1)=1; 
icond(2:3:(ncor+1)*3)=1 ;
 
nfix = find(icond==0) ;

Mmax = [] ; Mmin = [] ; Qmax = [] ; f = [] ; R = [] ;
for iq=1:size(q,2)+2    
    fig = fig + 2 ;
    FGlob = zeros((ncor+1)*3,1) ;
    despG = zeros((ncor+1)*3,1) ; 
    FG =  zeros(ncor,6) ; 
    AL =  zeros(ncor,6) ;     
    P = 1*1000 ; % Peso de 1 kN
    
    if iq==1 % Carga puntual en el primer tramo
        N = 0.0 ;
        M = P*L/8 ;
        Q = P/2 ;
        AL(1,:) = [N Q M  N Q -M]' ;   
        FGlob(2,1) = -Q ; FGlob(3,1) = -M ;
        FGlob(5,1) = -Q ; FGlob(6,1) =  M ;
    elseif iq==2 % Carga puntual en el tramo central
        N = 0.0 ;
        M = P*L/8 ;
        Q = P/2 ;
        med = round(ncor/2) ;
        AL(med,:) = [N Q M  N Q -M]' ; 
        ind = (med-1)*3+[1:6] ;   
        FGlob(ind(2),1) = -Q ; FGlob(ind(3),1) = -M ;
        FGlob(ind(5),1) = -Q ; FGlob(ind(6),1) =  M ; 
    else % Cargas districuidas min (presion) y max (succion)        
        N  = 0.0 ;
        M  = -q(iq-2)*L^2/12 ;
        Q  = -q(iq-2)*L/2 ;
        AL = repmat([N Q M  N Q -M],ncor,1)  ;   
        FGlob(3,1) = -M ;
        FGlob(end,1) = M ;
        ind = (2:3:(ncor+1)*3) ;   
        FGlob(ind,1) = -2*Q ;  
        FGlob([2 ((ncor+1-1)*3+2)],1) = -Q ;
    end 
    
    despl = KGlob(nfix,nfix)\FGlob(nfix,1) ; despG(find(icond==1)) = 0.0 ; despG(find(icond==0)) = despl ;
   
    for icor=1:ncor
        ind = (icor-1)*3+[1:6] ;
        D = despG([ind]) ;
        FG(icor,:) = (Kloc*D)' + AL(icor,:) ;             
    end
    
    R = [R ; KGlob*despG-FGlob] ;
    
    if iq==1 % Carga puntual en el primer tramo
        Q = FG(1,2) ;
        Mt = -Q*L/2; 
        fp = P*L^3/(48*E*I) ;
        fm = -(FG(1,6)*L^2/4)*(3/2)/(6*E*I) ;
        f = [f ; abs(fp) - abs(fm)] ;
    elseif iq==2 % Carga puntual en el tramo central 
        med = round(ncor/2) ;
        Q = FG(med,2) ;
        Mt = -Q*L/2+FG(med,3) ;  
        fp = P*L^3/(48*E*I) ;
        fm = (FG(med,3)*L^2/4)*(3/2 - FG(med,6)/FG(med,3)*3/2)/(6*E*I) ;
        f = [f ; abs(fp) - abs(fm)] ;
    else % Cargas districuidas min (presion) y max (succion)  
        Mt = [] ;
        fq = (5*q(iq-2)*L^4)/(384*E*I) ;
        for icor=1:ncor 
            Mt = [Mt -FG(icor,2) *L/2 + FG(icor,3)] ;
            if icor==1
                fm = -(FG(1,6)*L^2/4)*(3/2)/(6*E*I) ;
            elseif icor==ncor
                fm = -(FG(ncor,3)*L^2/4)*(3/2)/(6*E*I) ;
            else
                fm = -(FG(icor,3)*L^2/4)*(3/2 - FG(icor,6)/FG(icor,3)*3/2)/(6*E*I) ;
            end
            f = [f ; abs(fq) - abs(fm)] ;
        end 
    end   
    
    f=max(f);
    Mmax = [Mmax max([max(FG(:,[3 6])) Mt]) ] ; % traccion arriba
    Mmin = [Mmin min([min(FG(:,[3 6])) Mt]) ] ; % traccion abajo
    Qmax = [Qmax max([max(abs(FG(:,[2 5])))]) ] ;
 
    PlotMfCorreas(L,ncor,FG,iq,fig) 
end 

if max(Mmax)>Md_1*1000 % Verificación cordon arriostrado
    error(' CORREAS: no verifica la flexion del borde arriostrado, REDIMENSIONAR, Mmax = %f, Madm = %f',max(Mmax),Md_1*1000) ;
else    
    fprintf('    Verifica la flexion del borde arriostrado, Mmax = %f, Madm = %f \n',max(Mmax),Md_1*1000) ;
end

if max(abs(Mmin))>Md_2b*1000 % Verificación cordon arriostrado
    error(' CORREAS: no verifica la flexion del borde arriostrado en los tercios de la luz, REDIMENSIONAR, Mmax = %f, Madm = %f',max(abs(Mmin)),Md_2b*1000) ;
else    
    fprintf('    Verifica la flexion del borde arriostrado en los tercios de la luz, Mmax = %f, Madm = %f \n',max(abs(Mmin)),Md_2b*1000) ;
end 
    
if max(Qmax)>Vd*1000 % Verificación cordon arriostrado
    error(' CORREAS: no verifica el esfuerzo de corte máximo, REDIMENSIONAR, Qmax = %f, Qadm = %f',max(Qmax),Vd*1000) ;
else    
    fprintf('    Verifica el esfuerzo de corte máximo, Qmax = %f, Qadm = %f \n',max(Qmax),Vd*1000) ;
end

if abs(f)>L/250 % Verificación flecha
    warning(' CORREAS: no verifica la flecha máxima, se recomienda REDIMENSIONAR, f= %f, fmax=L/250= %f',abs(f),L/250) ;
else    
    fprintf('    Verifica la flecha máxima, f= %f, fmax=L/250= %f \n',abs(f),L/250) ;
end

% Resistencia de diseño a la flexión para elementos arriostrados en toda la luz
Prob_data.Predim.Correas.Mmax = [max(Mmax) Md_1*1000] ;
% Resistencia de diseño a la flexión para elementos arriostrados en los tercios de la luz con corrección de aplicación de cargas en el eje y
Prob_data.Predim.Correas.Mmin = [max(abs(Mmin)) Md_2b*1000] ; 
% Resistencia de diseño al esfuerzo de corte.
Prob_data.Predim.Correas.Qmax = [max(Qmax) Vd*1000] ; 
Prob_data.Predim.Correas.Datos = Datos ;
Prob_data.Predim.Correas.fmax = [f  L/250] ; % flecha max [m] . flecha admisible
Prob_data.Predim.Correas.Rmax = [max(abs(R)) Pd_1*1000 Pd_2*1000]; % Reaccion máxima [N] , Pd_1 [N] , Pd_2 [N]
Prob_data.Predim.Correas.q = q; % succion (-), presion (+)


 