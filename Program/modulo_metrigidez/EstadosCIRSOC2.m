function [Prob_data] = EstadosCIRSOC2(Prob_data,est)
global nload model

lc = Prob_data.Geom.lc ;
Hc = Prob_data.Geom.Hale ; % Adopto altura del alero que es un poco mas grande que Hc Prob_data.Geom.Hc ;
na = Prob_data.Geom.na ; 
coord = Prob_data.coord ;

if isempty(est)
%% Peso propio cubierta+correas
    nodfz=zeros(size((Prob_data.Cargas.NodCubPP),1),3) ;
    icub = Prob_data.Cargas.NodCubPP(:,1) ; 
    nodfz = [icub nodfz ];    
    nodfz(Prob_data.Cargas.NodCubPP(icub,1),2:4) = nodfz(Prob_data.Cargas.NodCubPP(icub,1),2:4) + ...
        Prob_data.Cargas.Factor(1).*[zeros(size(icub,1),1)  Prob_data.Cargas.NodCubPP(icub,2)  zeros(size(icub,1),1) ] ; 
    Prob_data.Cargas.qCO = [];
%% Sobre carga de uso en nodos del CS
    nodfz(Prob_data.Cargas.NodCubPP(icub,1),2:4) = nodfz(Prob_data.Cargas.NodCubPP(icub,1),2:4) + ...
        Prob_data.Cargas.Factor(3).*[zeros(size(icub,1),1)  Prob_data.Cargas.NodCubSC(icub,2)  zeros(size(icub,1),1) ] ; 
    
else
switch model
    case {1,2,3}  
        alphi = atand(Prob_data.Geom.pend(1)) ; 
        co = cosd(alphi) ; se = sind(alphi) ;
        nod_cs=[2*(na+1)+1:-1:(na+3) 1:+1:(na+2)] ; 
        if model==3 
            col_sota_2 = 3*na + 5 ;
            col_sota_1 = 4*na + 6 + 1 ; 
            col_barl_2 = 4*na + 6 ;
            col_barl_1 = 4*na + 6 + 2 ; 
        else
            col_sota_2 = 3*na + 5 ;
            col_sota_1 = 4*na + 7 + 1 ; 
            col_barl_2 = 4*na + 7 ;
            col_barl_1 = 4*na + 7 + 2 ;
        end
        icum = floor(size(nod_cs,2)/2)+1 ;
        
%% Cargas viento cubierta
        q_cs = est(12:15) ;  % (-) succion; (+) presion 
        q_cota = est(5:8) ;
        qco = [] ; % carga de viento sobre correas

        ind = find(est(5:8)~=0) ; 
        CotaCargas = q_cota(ind) ; 
        CargasDistr = q_cs(ind) ;

        cota = 0.0 ;
        qm = q_cs(1) ;
        i = 1 ;  

        for ics=2:size(nod_cs,2)-1
            lcs1 = long_elem2D(coord(nod_cs(ics-1),1), coord(nod_cs(ics-1),2), coord(nod_cs(ics),1), coord(nod_cs(ics),2)) ;
            lcs2 = long_elem2D(coord(nod_cs(ics),1), coord(nod_cs(ics),2), coord(nod_cs(ics+1),1), coord(nod_cs(ics+1),2)) ;    

            cota = cota + lcs1 ;
            if (cota>CotaCargas(i)) ; i=i+1 ; end
            qm(ics) = CargasDistr(i) ; 

            if ics==2 % nodo inicial 
                P = [qm(1)*lcs1/2 ; qm(2)*(lcs1+lcs2)/2] ;
                nodfz = [nod_cs([1 2])' P.*[se -co]] ;

            elseif ((ics>2) && (ics<icum)) % nodos izq.
                P = qm(ics)*(lcs1+lcs2)/2 ;
                nodfz = [nodfz ; nod_cs(ics) P*[se -co] ] ;  

            elseif ics==icum % cumbrera 

            elseif ((ics>icum) && (ics<size(nod_cs,2)-1)) % nodos der.
                P = qm(ics)*(lcs1+lcs2)/2 ;
                nodfz = [nodfz ; nod_cs(ics) P*[-se -co] ] ; 

            elseif ics==(size(nod_cs,2)-1) % nodo final
                P = [qm(ics)*(lcs1+lcs2)/2 ; qm(ics)*lcs2/2] ;
                nodfz = [nodfz ; nod_cs([ics ics+1])' P.*[-se -co]] ; 
            end
            qco = [qco ; P] ;
        end
        qco = [qco ; qm(icum-1)*lc/2 ; qm(icum+1)*lc/2] ; 
        
        P = [qm(icum-1)*lc/2*[se -co] + qm(icum+1)*lc/2*[-se -co]] ; 
        nodfz = [nodfz ; nod_cs(icum) P] ;
        nodfz = [nodfz  zeros(size(nodfz,1),1)] ;
        
    case 4 % Dos aguas curvo       
        nod_cs=[(na+2):-1:((na+3)/2+1)  1:+1:((na+3)/2)] ; 

        col_sota_2 = (3*na + 7)/2 ; % der.
        col_sota_1 = 2*na + 6 ; 
        col_barl_2 = 2*na + 5 ;  % izq.
        col_barl_1 = 2*na + 7 ;  
        
%% Cargas viento cubierta
        q_cs = est(12:15) ;  % (-) succion; (+) presion  q_cs=[10 10 10 10]
        q_cota = est(5:8) ;
        qco = [] ; % carga de viento sobre correas

        ind = find(est(5:8)~=0) ; 
        CotaCargas = q_cota(ind) ; 
        CargasDistr = q_cs(ind) ;

        cota = 0.0 ;
        qm = q_cs(1) ;
        i = 1 ;  

        for ics=2:size(nod_cs,2)-1
            lcs1 = long_elem2D(coord(nod_cs(ics-1),1), coord(nod_cs(ics-1),2), coord(nod_cs(ics),1), coord(nod_cs(ics),2)) ;
            lcs2 = long_elem2D(coord(nod_cs(ics),1), coord(nod_cs(ics),2), coord(nod_cs(ics+1),1), coord(nod_cs(ics+1),2)) ;    
            alp1 = atan((coord(nod_cs(ics),2) - coord(nod_cs(ics-1),2))/(coord(nod_cs(ics),1) - coord(nod_cs(ics-1),1)) ) ;
            alp2 = atan((coord(nod_cs(ics+1),2) - coord(nod_cs(ics),2))/(coord(nod_cs(ics+1),1) - coord(nod_cs(ics),1)) ) ;
            
            co1 = cos(alp1) ; se1 = sin(alp1) ;            
            co2 = cos(alp2) ; se2 = sin(alp2) ;
            
            cota = cota + lcs1 ;
            if (cota>CotaCargas(i)) ; i=i+1 ; end
            qm(ics) = CargasDistr(i) ; 

            if ics==2 % nodo inicial 
                P = [qm(1)*lcs1/2*[se1 -co1] ; ...
                    qm(1)*lcs1/2*[se1 -co1]+qm(1)*lcs2/2*[se2 -co2]] ;
                nodfz = [nod_cs([1 2])'  P] ;   
                qco = [qco ; sign(qm(1))*sqrt(P(1,1)^2+P(1,2)^2)] ;
                qco = [qco ; sign(qm(ics))*sqrt(P(2,1)^2+P(2,2)^2)] ;
            elseif ics==(size(nod_cs,2)-1) % nodo final
                P = [qm(ics)*lcs1/2*[se1 -co1]+qm(ics)*lcs2/2*[se2 -co2] ; ...
                    qm(ics)*lcs2/2*[se2 -co2]] ;
                nodfz = [nodfz ; nod_cs([ics ics+1])' P ] ; 
                qco = [qco ; sign(qm(ics))*sqrt(P(1,1)^2+P(1,2)^2)] ;
                qco = [qco ; sign(qm(ics))*sqrt(P(2,1)^2+P(2,2)^2)] ;
            else % if (ics>2) % nodos intermedios 
                P = [qm(ics)*lcs1/2*[se1 -co1]+qm(ics)*lcs2/2*[se2 -co2]] ;
                nodfz = [nodfz ; nod_cs(ics) P ] ; 
                qco = [qco ; sign(qm(ics))*sqrt(P(1)^2+P(2)^2)] ;  
            end 
        end
        nodfz = [nodfz  zeros(size(nodfz,1),1)] ;
        
        
    case {5,6}  % Un agua 
%     warning('va el modelo 6 igual al 5?')
        alphi = atand(Prob_data.Geom.pend(1)) ; 
        co = cosd(alphi) ; se = sind(alphi) ;
        
        if model==5 
            nod_cs=[(na+2):-1:1] ;    
            col_sota_2 = na + 3 ;
            col_sota_1 = 2*na + 7 ; 
            col_barl_2 = 2*na + 5 ;
            col_barl_1 = 2*na + 6 ;
        elseif model==6
            nod_cs=[(na+3):-1:1] ;    
            col_sota_2 = na + 4 ;
            col_sota_1 = 2*na + 7 ; 
            col_barl_2 = 2*na + 6 ;
            col_barl_1 = 2*na + 8 ;
%             col_sota_2 = 3*na + 5 ;
%             col_sota_1 = 4*na + 7 + 1 ; 
%             col_barl_2 = 4*na + 7 ;
%             col_barl_1 = 4*na + 7 + 2 ;
        end
         
        
%% Cargas viento cubierta
        q_cs = est(12:15) ; % (-) succion; (+) presion 
        q_cota = est(5:8) ;
        qco = [] ; % carga de viento sobre correas

        ind = find(est(5:8)~=0) ; 
        CotaCargas = q_cota(ind) ; 
        CargasDistr = q_cs(ind) ;

        cota = 0.0 ;
        qm = q_cs(1) ;
        i = 1 ;  

        for ics=2:size(nod_cs,2)-1
            lcs1 = long_elem2D(coord(nod_cs(ics-1),1), coord(nod_cs(ics-1),2), coord(nod_cs(ics),1), coord(nod_cs(ics),2)) ;
            lcs2 = long_elem2D(coord(nod_cs(ics),1), coord(nod_cs(ics),2), coord(nod_cs(ics+1),1), coord(nod_cs(ics+1),2)) ;    

            cota = cota + lcs1 ;
            if (cota>CotaCargas(i)) ; i=i+1 ; end
            qm(ics) = CargasDistr(i) ; 

            if ics==2 % nodo inicial 
                P = [qm(1)*lcs1/2 ; qm(2)*(lcs1+lcs2)/2] ;
                nodfz = [nod_cs([1 2])' P.*[se -co]] ; 
            elseif ics==(size(nod_cs,2)-1) % nodo final
                P = [qm(ics)*(lcs1+lcs2)/2 ; qm(ics)*lcs2/2] ; 
                nodfz = [nodfz ; nod_cs([ics ics+1])' P.*[se -co]] ;                 
            elseif ics>2   % nodos izq.
                P = qm(ics)*(lcs1+lcs2)/2 ;
                nodfz = [nodfz ; nod_cs(ics) P*[se -co]] ;  
            end 
            qco = [qco ; P] ;
        end
        
        nodfz = [nodfz  zeros(size(nodfz,1),1)] ; 
        
    otherwise
        error('Modelo de cercha no implementado')
end

[~,b] = sort(nodfz(:,1)) ;
nodfz = nodfz(b,:) ;

L = Hc ;
##warning('ver si esto sirve para un agua');
if Prob_data.Cargas.Carac=='Aislado' 
%% cargas laterales barlovento
    qe = est(1,[10]) ;
    c  = est(1,[3]) ;  
    a = c/2 ;
    b = L-a ;
    M12 = -qe*a*b*c/(2*L^2)*(L+a-c^2/(4*b)) ;
    M22 = 0.0 ; 
    R12 = qe*a*c/L-M12/L ;
    R22 = qe*b*c/L+M12/L ; 
    
    Mb1 =  M12 ;
    Mb2 = 0.0;            
    Rb1 =  R12 ;     
    Rb2 =  R22 ;
%% cargas laterales sotavento
    qe = est(1,[16]) ;
    c  = est(1,[9]) ;    
    a = c/2 ;
    b = L-a ;
    M12 = -qe*a*b*c/(2*L^2)*(L+a-c^2/(4*b)) ;
    M22 = 0.0 ; 
    R12 = qe*a*c/L-M12/L ;
    R22 = qe*b*c/L+M12/L ;  
    
    Ms1 = M12;
    Ms2 = 0.0;          
    Rs1 = R12 ;
    Rs2 = R22 ; 
else
%% cargas laterales barlovento
    if Hc>5  
        qe = est(1,[10 11]) ;
        c = 5 ;
        b = c/2 ;
        a = L-b ;
        M11 = -qe(1,1)*a*b*c/(2*L^2)*(L+a-c^2/(4*b)) ;
        M21 = 0.0 ; 
        R11 = qe(1,1)*a*c/L-M11/L ;
        R21 = qe(1,1)*b*c/L+M11/L ;      

        c = Hc-5 ;
        a = c/2 ;
        b = L-a ;
        M12 = -qe(1,2)*a*b*c/(2*L^2)*(L+a-c^2/(4*b)) ;
        M22 = 0.0 ; 
        R12 = qe(1,2)*a*c/L-M12/L ;
        R22 = qe(1,2)*b*c/L+M12/L ; 

        Mb1 = M11 + M12 ;
        Mb2 = 0.0;            
        Rb1 = R11 + R12 ;     
        Rb2 = R21 + R22 ;
    else
        qe = est(1,[10]) ;
        Mb1 = -qe(1,1)*L^2/8 ;
        Mb2 = 0.0;          
        Rb1 = 5/8*qe(1,1)*L ;
        Rb2 = 3/8*qe(1,1)*L ;
    end 
%% cargas laterales sotavento
    qe = est(1,16) ;
    L = Hc ;
    Ms1 = qe(1,1)*L^2/8 ;
    Ms2 = 0.0;          
    Rs1 = -5/8*qe(1,1)*L ;
    Rs2 = -3/8*qe(1,1)*L ; 
end

nodfz = [nodfz ;
        [col_sota_2  Rs2  0.0   Ms2 ;
         col_barl_2  Rb2  0.0   Mb2 ;
         col_sota_1  Rs1  0.0   Ms1 ;
         col_barl_1  Rb1  0.0   Mb1 ]];  
     
nodfz = [nodfz(:,1) nodfz(:,2:end).*Prob_data.Cargas.Factor(2)] ;     

%% Peso propio cubierta+correas
icub = Prob_data.Cargas.NodCubPP(:,1) ; 
nodfz(Prob_data.Cargas.NodCubPP(icub,1),2:4) = nodfz(Prob_data.Cargas.NodCubPP(icub,1),2:4) + ...
    Prob_data.Cargas.Factor(1).*[zeros(size(icub,1),1)  Prob_data.Cargas.NodCubPP(icub,2)  zeros(size(icub,1),1) ] ; 

Prob_data.Cargas.qCO = [Prob_data.Cargas.qCO; [min(qco) max(qco)]./Prob_data.Geom.Sep] ; % Carga distribuída debida al viento sobre correas % (-) succion; (+) presion

%% Sobre carga de uso en nodos del CS
nodfz(Prob_data.Cargas.NodCubPP(icub,1),2:4) = nodfz(Prob_data.Cargas.NodCubPP(icub,1),2:4) + ...
    Prob_data.Cargas.Factor(3).*[zeros(size(icub,1),1)  Prob_data.Cargas.NodCubSC(icub,2)  zeros(size(icub,1),1) ] ; 

end
%%
nload = size(nodfz,1) ;
Prob_data.nodfz = nodfz ;


