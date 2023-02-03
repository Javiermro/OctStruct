function [Elem_data] = f_CargasTramo(ielem,H,V,a,Elem_data) 
 
%% Calcula los esfuerzos de empotramiento perfecto en coordenadas locales    
%  peso propio: carga uniformemente distribuida

L = Elem_data(ielem).L;
b = L - a ;

N1 = -H*b/L ;
N2 = -H*a/L ;

Q1 = -V*b^2/L^3*(L+2*a) ;%+3/2*M/L ;
Q2 = -V*a^2/L^3*(L+2*b) ;%-3/2*M/L ;

M1 = -V*a*b^2/L^2; %V*L/8 + M/4 ; 
M2 =  V*a^2*b/L^2; %-V*L/8 + M/4 ; 

AL = [N1 Q1 M1  N2 Q2 M2]' ;   

Elem_data(ielem).ALbar = Elem_data(ielem).ALbar + AL ;
Elem_data(ielem).AGbar = Elem_data(ielem).AGbar + Elem_data(ielem).RT'*AL ;  

