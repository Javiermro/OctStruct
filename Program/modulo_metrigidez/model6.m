function Prob_data = model3(Prob_data)  

global model nelem npoin nfixe

pm = Prob_data.Geom.pend(1) ; %pendiente minima 2.5%
pM = Prob_data.Geom.pend(2) ; %pendiente maxima 35%
am = atand(pm) ;  %angulo en grados
aM = atand(pM) ;  
Bc = Prob_data.Geom.Bc ;
Hc = Prob_data.Geom.Hc ;
L  = Prob_data.Geom.L ; 
vx = (L-Bc) ; 
if am==aM
    nt=1;
else
    nt = 1000; % cantidad de divisiones de la pendiente
end      
lcm = Prob_data.Geom.lc(1);
lcM = Prob_data.Geom.lc(2) ;   
h   = Prob_data.Geom.h ;           % round(0.03*L,2)  % Se adopta h igual a 3% de L
vertex = [] ;
%%
lm = vx/cosd(am) ;
lM = vx/cosd(aM) ;
n = floor(lm/lcM):floor(lM/lcm) ;  

% iiter=1; niter=0; 
sol=[];
for in=1:size(n,2)
    alp=am;
    for it=1:nt 
        alp=alp+(aM-am)/nt;
%         lc=(vx + h*sind(alp))/cosd(alp)/(n(in)+0.5);
        lc=vx/cosd(alp)/n(in);
        if (lc<lcm || lc>lcM)
            sol = [sol ; NaN NaN NaN];
        else
            sol = [sol ; lc n(in) alp];
        end 
%         iiter=iiter+1;
%         if iiter>niter
%             niter=niter+size(lc,2)*size(n,2)/70 ; 
%             fprintf('.')
%         end
    end  
end
% fprintf('  \n')
ind = find(~isnan(sol(:,1))) ;

fprintf('--- Geometrías admisibles \n')    
fprintf('| Geom. | Angulo     | Sep.Correa | Cant.Divisiones | Long.Aprox. | \n' );                       
long = [];       
for i=1:size(ind,1)
    long = [long f_long_aprox(sol(ind(i),2),sol(ind(i),1),h,sol(ind(i),3),model)] ;
        formats='|     %i |  %f |   %f |               %i |   %f |\n' ;
    if sol(ind(i),2)>9
        formats='|     %i |  %f |   %f |              %i |   %f |\n' ;
    end
    if sol(ind(i),3)<10    
        formats='|     %i |   %f |   %f |              %i |   %f |\n' ;        
    end
    if (sol(ind(i),2)<10 && sol(ind(i),3)<10)
        formats='|     %i |   %f |   %f |               %i |   %f |\n' ;        
    end
    fprintf(formats,i,sol(ind(i),3),sol(ind(i),1),sol(ind(i),2),long(i));
end
[~,dd]=min(long) ;  
fprintf('--- Seleccionar la geometría, por defecto [%i]:',dd)  ;
prompt = ' ' ;
geom = input(prompt) ; 
if isempty(geom) ; geom = dd; end ;

na = sol(ind(geom),2);
la = sol(ind(geom),1);
Prob_data.Geom.pend(1) = tand(sol(ind(geom),3)) ; % tangente angulo en grados
Prob_data.Geom.lc = la ;

alphi = sol(ind(geom),3) ; 

if (alphi==0) ; alphi=1E-12 ; end 
m1 = tand(-alphi) ; m2 = tand(-alphi-90) ;  

vertex(1,:) = [0.0 0.0] ; 
vertex(2,:) = [0.0 0.0] ;  
vertex(3,:) = [(L+Bc)      -((na*la+2*Bc/cosd(alphi))*sind(alphi)+h)] ;
vertex(4,:) = [L            vertex(3,2)] ;
vertex(5,:) = [Bc           vertex(3,2)] ;
vertex(6,:) = [0.0          vertex(3,2)] ;
vertex(2,:) = [vertex(3,1)  m1*vertex(3,1)] ; 

%%
csup = [vertex(1,:) ;[Bc Bc*m1] ; [Bc+la.*(1:na).*cosd(alphi)  ;Bc*m1-la.*(1:na).*sind(alphi) ]'; vertex(2,:)] ;
% csup = [csup ; [-la.*(1:1:na).*cosd(alphi)  ;-la.*(1:1:na).*sind(alphi)]' ; [-vertex(2,1) vertex(2,2)]] ; 
  
cinf = [csup(:,1) vertex(3,2)*ones(na+3,1)] ;
% cinf = [vertex(5,:) ; cinf ; [-cinf(:,1) cinf(:,2)]] ;

nodos = [csup ; cinf ] ; 
barcs = [1:(na+2) ; 2:(na+3)]' ;
barci = [(na+4):(2*na+5) ; (na+5):(2*na+6)]' ;

bardi = [(na+4):(2*na+5) ; 2:(na+3)]' ;
bardd = [(na+4):(2*na+6) ; 1:(na+3)]' ;
conec = [[barcs ones(size(barcs,1),1)*10] ; [barci ones(size(barci,1),1).*20] ;...
    [bardi ones(size(bardi,1),1).*30] ; [bardd ones(size(bardd,1),1).*30]] ;
conec([2*na+5  3*na+6  3*na+7  4*na+9],3) = 31 ;


cold  = [nodos(2*na+6,1)  nodos(2*na+6,2)-Hc] ;
coli  = [nodos(na+4,1)  nodos(na+4,2)-Hc] ;

nodos = [nodos ; coli; cold ] ;
conec = [conec ; [2*na+7  na+4  0] ; [2*na+8   2*na+6  0] ] ;
fixed = [2*na+7  2*na+8] ; 

% StructurePlot(conec,nodos) ;

nelem = size(conec,1) ;
npoin = size(nodos,1) ;
nfixe = size(fixed,2) ;

Prob_data.conec = conec;
Prob_data.coord = nodos;
Prob_data.fixed = fixed; 
Prob_data.Geom.Hmax = (nodos(1,2)-nodos(end,2)) ; 
Prob_data.Geom.Hale = Prob_data.Geom.Hmax-(-vertex(2,2)) ; 
% Prob_data.Geom.Le   = abs(vertex(2,1)*2) ; 
Prob_data.Geom.na = na ;
 
%% Nodos con peso propio de cubierta+correas 
pp = [] ;  sc = [] ;
Area = p_PropGeomArea(Prob_data.Predim.CO) ; % en cm^2

PPcor = Area*(1/10000)*Prob_data.Geom.Sep*Prob_data.Mat.Acero.PesEsp*1000  ; %PesEsp en [kN/m^3]

PPcub = Prob_data.Cargas.PPCub ; % = 40; % N/m^2 
SCcub = Prob_data.Cargas.Sobre ;
for ic=1:(na+3)
    if ic==1 
        lcor=sqrt((nodos(ic,1)-nodos(ic+1,1))^2 + (nodos(ic,2)-nodos(ic+1,2))^2)/2 ;
    elseif ic==(na+3)
        lcor=sqrt((nodos(ic,1)-nodos(ic-1,1))^2 + (nodos(ic,2)-nodos(ic-1,2))^2)/2 ;
    else
        lcor=sqrt((nodos(ic,1)-nodos(ic+1,1))^2 + (nodos(ic,2)-nodos(ic+1,2))^2)/2 +...
            sqrt((nodos(ic,1)-nodos(ic-1,1))^2 + (nodos(ic,2)-nodos(ic-1,2))^2)/2 ;
    end
    pp=[pp lcor*Prob_data.Geom.Sep*PPcub+PPcor] ;
    sc=[sc lcor*Prob_data.Geom.Sep*SCcub] ;
end  
% pp = [pp pp(2:end)]   ; 
% sc = [sc sc(2:end)]   ; 
Prob_data.Cargas.NodCubPP = [1:(na+3) ; -pp]' ; % Nodos con peso propio de cubierta+correas
Prob_data.Cargas.NodCubSC = [1:(na+3) ; -sc]' ; % Nodos con del CS con sobre carga 




