 function [L] = f_long_aprox(na,la,h,alp,model)  

Bc = 0.4 ; % adopto Bc=0.4

switch model
    case {1,2} % Modif jma 1||2
        x1 = la*cosd(alp) ;
        y1 = la*sind(alp) ;
        x2 = la/2*cosd(alp) - h*sind(alp) ;
        y2 = la/2*sind(alp) + h*cosd(alp) ;
        D  = sqrt((x1-x2)^2 + (y1-y2)^2) ;
        L = la*(na+1) + la*na + D*na*2 + h + la ;
        L = L*2 ;
    case 3 
        x1 = la*cosd(alp) ;
        y1 = -la*sind(alp) ;
        x2 = 0 ; 
        y2 = -((na*la+Bc/cosd(alp))*sind(alp) + h)  ;
        DM = sqrt((x1-x2)^2 + (y1-y2)^2) ;
        MM = abs(y2-y1) ;
         
        x1 = (na*la+Bc/cosd(alp))*cosd(alp) ; 
        y1 = -(na*la+Bc/cosd(alp))*sind(alp) ; 
        x2 = (na*la)*cosd(alp) ;  
        y2 = -((na*la+Bc/cosd(alp))*sind(alp)+h) ;  
        Dm = sqrt((x1-x2)^2 + (y1-y2)^2) ;
        Mm = h ;
        
        L = (na*la+Bc/cosd(alp)) + (na*la+Bc/cosd(alp))*cosd(alp) +...
            (DM+MM+Dm+Mm)/2*(na+1) ;        
        L = L*2 + abs(y2); 
    case 4
        lcs = (na+1)*la ;
        lci = na*la ;
        D  = sqrt((la/2)^2 + h^2) ;
        lD = D*2*(na+2)+2*h ;
        L  = lcs+lci+lD ;
    case 5 
        D  = sqrt(h^2 + (la/2)^2) ;
        L = na*la + Bc/cosd(alp)*2 + 2*D*(na+1) + 2*h ;  

    case 6 
        x1 = la*cosd(alp) ;
        y1 = -la*sind(alp) ;
        x2 = 0 ; 
        y2 = -((na*la+2*Bc/cosd(alp))*sind(alp) + h)  ;
        DM = sqrt((x1-x2)^2 + (y1-y2)^2) ;
        MM = abs(y2-y1) ;
         
%         x1 = (na*la+Bc/cosd(alp))*cosd(alp) ; 
%         y1 = -(na*la+Bc/cosd(alp))*sind(alp) ; 
%         x2 = (na*la)*cosd(alp) ;  
%         y2 = -((na*la+Bc/cosd(alp))*sind(alp)+h) ;  
        Dm = sqrt(Bc^2 + h^2) ;
        Mm = h ;
        
        L = (na*la+2*Bc/cosd(alp)) + (na*la+2*Bc/cosd(alp))*cosd(alp) +...
            (DM+MM+Dm+Mm)/2*(na+2) ;        
        L = L + abs(y2);         
    otherwise
        error('Modelo de cercha no implementado')
end 