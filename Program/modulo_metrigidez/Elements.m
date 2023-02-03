function [Elem_data] = Elements(Prob_data,Elem_data) 

global nelem

for ielem=1:nelem 
    elem = Prob_data.conec(ielem,3) ;
    conec = Prob_data.conec(ielem,:) ; 
    xnodi = Prob_data.coord(conec(1),1) ;
    ynodi = Prob_data.coord(conec(1),2) ;
    xnodf = Prob_data.coord(conec(2),1);
    ynodf = Prob_data.coord(conec(2),2) ;
    if ( xnodf>xnodi && ynodf>ynodi )        % 1er cuadrante
        tita = [ atand((ynodf-ynodi)/(xnodf-xnodi))] ;
    elseif ( xnodf<xnodi && ynodf>ynodi )    % 2do cuadrante
        tita = [ (180+atand((ynodf-ynodi)/(xnodf-xnodi)))] ;
    elseif ( xnodf<xnodi && ynodf<ynodi )    % 3er cuadrante
        tita = [ (180+atand((ynodf-ynodi)/(xnodf-xnodi)))] ;
    elseif ( xnodf>xnodi && ynodf<ynodi )    % 4to cuadrante
        tita = [ atand((ynodf-ynodi)/(xnodf-xnodi))] ;
    elseif ((ynodf-ynodi)==0 && (xnodf-xnodi)<0)
        tita = [ 180] ;
    elseif ((xnodf==xnodi)&&(ynodf-ynodi)>0)
        tita = [ 90] ;
    elseif ((xnodf==xnodi)&&(ynodf-ynodi)<0)
        tita = [-90] ;
    else
        tita = [ atand((ynodf-ynodi)/(xnodf-xnodi))] ;
    end 
    L = [long_elem2D(xnodi,ynodi,xnodf,ynodf)] ; 
    s = sind(tita) ;
    c = cosd(tita) ; 
    
    [Elem_data] = ElementAsignDNS(Prob_data,Elem_data,ielem) ;
    
    if elem~=0     
        I = Elem_data(ielem).Seccion.Geom.Ix   ; % en cm^4
        A = Elem_data(ielem).Seccion.Geom.Area ; % en cm^2
        I = I/100000000 ;  % pasaje a m^4
        A = A/10000 ; % pasaje a m^2
    else
        I = Elem_data(ielem).Seccion.Geom.Ix   ; % en m^4
        A = Elem_data(ielem).Seccion.Geom.Area ; % en m^2
    end
    E = Elem_data(ielem).Mat.E ; % en Pa

    Kloc = [E*A/L   0.0         0.0       -E*A/L   0.0        0.0       ;
        0.0     12*E*I/L^3  6*E*I/L^2  0.0   -12*E*I/L^3  6*E*I/L^2 ;
        0.0     6*E*I/L^2   4*E*I/L    0.0   -6*E*I/L^2   2*E*I/L   ;
        -E*A/L  0.0         0.0        E*A/L  0.0         0.0       ;
        0.0    -12*E*I/L^3 -6*E*I/L^2  0.0    12*E*I/L^3 -6*E*I/L^2 ;
        0.0     6*E*I/L^2   2*E*I/L    0.0   -6*E*I/L^2   4*E*I/L ]  ;       

    RT = [  c  s  0  0  0  0 ;
           -s  c  0  0  0  0 ;
            0  0  1  0  0  0 ;
            0  0  0  c  s  0 ;
            0  0  0 -s  c  0 ;
            0  0  0  0  0  1 ] ;
         
    Elem_data(ielem).conec = conec ;
    Elem_data(ielem).RT = RT ;
    Elem_data(ielem).KGele = RT'*Kloc*RT ;
    Elem_data(ielem).L = L ;
    Elem_data(ielem).tita = tita ; 

%% Calcula los esfuerzos de empotramiento perfecto en coordenadas locales    
%  peso propio: carga uniformemente distribuida
    pp    = A*Elem_data(ielem).Mat.PesEsp*Prob_data.Cargas.Factor(1) ; % A[m^2] * PesEsp[kN/m^3] * Coef de norma 
    pp    = pp*1000 ; % pasaje de kN/m a N/m
    sen_t = sind(tita) ;
    cos_t = cosd(tita) ; 

    N  = sen_t*pp*L/2 ;
    M  = cos_t*pp*L^2/12 ;
    Q  = cos_t*pp*L/2 ;
    AL = [N Q M  N Q -M]' ;   
        
    Elem_data(ielem).ALbar = AL ;
    Elem_data(ielem).AGbar = Elem_data(ielem).RT'*AL ; 
end  


