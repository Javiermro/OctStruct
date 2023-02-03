function Prob_data = model4(Prob_data)  

global model nelem npoin nfixe
 
Bc = Prob_data.Geom.Bc ;
Hc = Prob_data.Geom.Hc ;
L  = Prob_data.Geom.L ; 
f = Prob_data.Geom.f ; 
Rm = f(1)/2 + ((L-Bc)^2)/8/f(1) ; % Radio mínimo
RM = f(2)/2 + ((L-Bc)^2)/8/f(2) ; % Radio Máximo

%% prueba
% f = Prob_data.Geom.f(1) ;  R = f/2 + ((L-Bc)^2)/8/f ;
% A=[0; -h] ; B=[ (L-Bc)/2; -f-h] ; C=[-(L-Bc)/2; -f-h] ;
% c=[0,-R-h] ;
% pts =[A B C]' ; 
% tita=0:0.01:pi() ; 
% x=c(1)+R*cos(tita) ;
% y=c(2)+R*sin(tita) ;
% hold on
%     plot(x,y)
%     plot(pts(:,1),pts(:,2),'-')
%     plot(c(1),c(2),'or')
% %     plot(cinf(:,1),cinf(:,2),'+')
%     plot(nodos(:,1),nodos(:,2),'o')
%     axis equal
%     grid
% hold off
%%
pm = Prob_data.Geom.f(1) ; %flecha minima 2.5%
pM = Prob_data.Geom.f(2) ; %flecha maxima 35%
fm = pm ;  %angulo en grados
fM = pM ;  
Bc = Prob_data.Geom.Bc ;
Hc = Prob_data.Geom.Hc ;
L  = Prob_data.Geom.L ;  
if fm==fM
    nt=1;
else
    nt = 1000; % cantidad de divisiones de la flecha
end      
lcm = Prob_data.Geom.lc(1);
lcM = Prob_data.Geom.lc(2) ;   
h   = Prob_data.Geom.h ;           % round(0.03*L,2)  % Se adopta h igual a 3% de L
vertex = [] ;
%%
Rm = (fm/2 + ((L-Bc)^2)/8/fm);
tm = 2*atan((L-Bc)/2/(Rm-fm));
RM = (fM/2 + ((L-Bc)^2)/8/fM);
tM = 2*atan((L-Bc)/2/(RM-fM));
n = floor(tm*Rm/lcM):floor(tM*RM/lcm);    
n = n(find(mod(n,2))) ; % solo n impar

sol=[];
for in=1:size(n,2)
    fl=fm;
    for ifl=1:nt 
        fl = fl + (fM-fm)/nt;
        R  = (fl/2 + ((L-Bc)^2)/8/fl);
        tita = 2*atan((L-Bc)/2/(R-fl));
%         li = R/n(in)*tita;
        alp=tita/n(in);
        lc = 2*R*sin(alp/2);
%         eqn = n(in)*asin(lc(il)/2/(F/2 + ((L-Bc)^2)/8/F))-atan((L-Bc)/2/((F/2 + ((L-Bc)^2)/8/F)-F)) ;
%         lc=(vx + h*sind(alp))/cosd(alp)/(n(in)+0.5);
%         lc=vx/cosd(alp)/n(in);
        if (lc<lcm || lc>lcM)
            sol = [sol ; NaN NaN NaN];
        else
            sol = [sol ; lc n(in) fl];
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
fprintf('| Geom. | Flecha     | Sep.Correa | Cant.Divisiones | Long.Aprox. | \n' );                       
long = [];       
for i=1:size(ind,1)
%     long = [long f_long_aprox(n(row(i)),lc(col(i)),h,s(ind(i)),model)] ;
    long = [long f_long_aprox(sol(ind(i),2),sol(ind(i),1),h,sol(ind(i),3),model)] ;
    format='|     %i |  %f |   %f |               %i |   %f |\n' ;
    if sol(ind(i),2)>9
        format='|     %i |  %f |   %f |              %i |   %f |\n' ;
    end
    if sol(ind(i),3)<10    
        format='|     %i |   %f |   %f |              %i |   %f |\n' ;        
    end
    if (sol(ind(i),2)<10 && sol(ind(i),3)<10)
        format='|     %i |   %f |   %f |               %i |   %f |\n' ;        
    end
    fprintf(format,i,sol(ind(i),3),sol(ind(i),1),sol(ind(i),2),long(i));
end
[~,dd]=min(long) ;  
fprintf('--- Seleccionar la geometría, por defecto [%i]:',dd)  ;
prompt = ' ' ;
geom = input(prompt) ; 
if isempty(geom) ; geom = dd; end ;
 
na = sol(ind(geom),2);
Prob_data.Geom.f = sol(ind(geom),3) ; % flecha
Prob_data.Geom.li = sol(ind(geom),1) ; % separacion nudos cordon inferior 
 
R = (sol(ind(geom),3)/2 + ((L-Bc)^2)/8/sol(ind(geom),3)) ;
alpha = 2*asin(sol(ind(geom),1)/2/R) ;


% % Variable de entrada: h alpha lc
% lc    = Prob_data.Geom.lc ;           % Separación entre correas [1.0  1.5] 
% h     = Prob_data.Geom.h ;           % round(0.03*L,2)  % Se adopta h igual a 3% de L
% Titam = 2*atan((L-Bc)/2/(Rm-f(1))) ; 
% TitaM = 2*atan((L-Bc)/2/(RM-f(2))) ; 
% lm    = Titam*Rm ;
% lM    = TitaM*RM ;
% vertex = [] ;
% %%
% if f(1)<f(2) 
%     n = floor(lm/max(lc)):floor(lM/min(lc)) ;  
%     n = n(find(mod(n,2)==1)) ; % solo n impar
%     syms F;  
%     s=zeros(size(n,2),size(lc,2)) ; 
%     for in=1:size(n,2)
%         for il=1:size(lc,2)      
%             eqn = n(in)*asin(lc(il)/2/(F/2 + ((L-Bc)^2)/8/F))-atan((L-Bc)/2/((F/2 + ((L-Bc)^2)/8/F)-F)) ;
%             sol = eval(vpasolve(eqn,F,[f(1) f(2)]));%,'Real',true,'PrincipalValue',true)) ;
%             if ~isempty(sol); s(in,il) = sol ; end
%         end
%     end 
%     ind = find(~s==0) ;
%     col = ceil(ind/size(s,1)) ;
%     row = ind-(ceil(ind/size(s,1))-1)*size(s,1) ; 
% 
%     fprintf('--- Geometrías admisibles \n')    
%     fprintf('| Geom. | Flecha     | Sep.Correa | Cant.Divisiones | Long.Aprox. | \n' );                       
%     long = [];       
%     for i=1:size(ind,1)
%         long = [long f_long_aprox(n(row(i)),lc(col(i)),h,s(ind(i)),model)] ;
%         format='|     %i |  %f |   %f |               %i |   %f |\n' ;
%         if n(row(i))>9
%             format='|     %i |  %f |   %f |              %i |   %f |\n' ;
%         end
%         if s(ind(i))<10    
%             format='|     %i |   %f |   %f |              %i |   %f |\n' ;        
%         end
%         if (n(row(i))<10 && s(ind(i))<10)
%             format='|     %i |   %f |   %f |               %i |   %f |\n' ;        
%         end
%         fprintf(format,i,s(ind(i)),lc(col(i)),n(row(i)),long(i));
%     end
%     [~,dd]=min(long) ;  
%     fprintf('--- Seleccionar la geometría, por defecto [%i]:',dd)  ;
%     prompt = ' ' ;
%     geom = input(prompt) ; 
%     if isempty(geom) ; geom = dd; end ;
% 
%     na = n(row(geom)) ; 
%     Prob_data.Geom.f = s(ind(geom)) ; % flecha
%     Prob_data.Geom.li = lc(col(geom)) ; % separacion nudos cordon inferior 
%     
%     f = s(ind(geom)) ;
%     R = (f/2 + ((L-Bc)^2)/8/f) ;
%     alpha = 2*asin(lc(col(geom))/2/R) ;
%     
% elseif f(1)==f(1) 
%     n = floor(lm/max(lc)) ;   
%     n = n-(1-mod(n,2)) ; % solo n impar
%     f = f(1) ; 
% 
%     na = n  ; 
%     Prob_data.Geom.f = f(1) ; % flecha
%     Prob_data.Geom.li = lc  ; % separacion nudos cordon inferior
%     
%     R = (f/2 + ((L-Bc)^2)/8/f) ;
%     alpha = 2*asin(lc/2/R) ;
% end

%% NODOS

alphi = alpha/2 ;
alphs = alpha ;
cinf=[] ; csup=[] ;
for ic=1:floor(na/2)
    cinf = [cinf ; [R*sin(alphi) -(R+h-R*cos(alphi))]] ;
    alphi = alphi + alpha ;
    csup = [csup ; [(R+h)*sin(alphs) -((R+h)-(R+h)*cos(alphs))] ];
    alphs = alphs + alpha ;
end
cinf = [cinf ; [R*sin(alphi) -(R+h-R*cos(alphi))]] ;
cinf = [cinf ; [cinf(end,1)+Bc  cinf(end,2)]] ;
cinf = [cinf ; [-cinf(:,1) cinf(:,2)]] ;

lc = sqrt(csup(1,1)^2+csup(1,2)^2) ;
Prob_data.Geom.lc = lc ;
csup((na+1)/2,:) = [(L+Bc)/2  -(R+h-sqrt((R+h)^2 - ((L+Bc)/2)^2))] ;
csup = [csup ; [-csup(:,1) csup(:,2)]] ;
csup = [[0.0  0.0]; csup] ;

nodos = [csup ; cinf ] ;  
 
%% BARRAS
barcs = [[1:(na+3)/2-1 ; 2:(na+3)/2]' ; [[1 ((na+3)/2+1):(na+2-1)] ; ((na+3)/2+1):(na+2)]' ] ; % barras cordon sup.
barci = [[(na+3):((3*na+7)/2-1) ; (na+3+1):((3*na+7)/2)]' ; ...
    [[na+3 ((3*na+7)/2+1):(2*na+5-1)]'  [((3*na+7)/2+1):(2*na+5)]']] ;

bardi = [[1:(na+3)/2 ; (na+3):((3*na+7)/2)]' ;[2:(na+3)/2 ; (na+3):((3*na+7)/2-1)]'] ;
bardd = [[[1 ((na+3)/2+1):(na+2)] ; [((3*na+7)/2+1):(2*na+5)]]' ; ...
    [((na+3)/2+1):(na+2) ; ((3*na+7)/2+1):(2*na+5-1)]'] ;
     
conec = [[barcs ones(size(barcs,1),1)*10] ; [barci ones(size(barci,1),1).*20] ;...
    [bardi ones(size(bardi,1),1).*30] ; [bardd ones(size(bardd,1),1).*30]] ;
conec([(na+1)/2   (na+1)  (3*na+5)/2  (2*na+3)  (5*na+9)/2  (3*na+5)  (7*na+13)/2  (4*na+7)],3) = 31 ;


cold  = [nodos((3*na+7)/2,1)  nodos((3*na+7)/2,2)-Hc] ;
coli  = [nodos(2*na+5,1)  nodos(2*na+5,2)-Hc] ;
nodos = [nodos ; cold ; coli] ;
conec = [conec ; [2*na+6  (3*na+7)/2  0] ; [2*na+7  2*na+5  0] ] ;
fixed = [2*na+6  2*na+7] ; 

% StructurePlot(conec,nodos) ;

nelem = size(conec,1) ;
npoin = size(nodos,1) ;
nfixe = size(fixed,2) ;

Prob_data.conec = conec;
Prob_data.coord = nodos;
Prob_data.fixed = fixed; 
Prob_data.Geom.Hmax = (nodos(1,2)-nodos(end,2)) ; 
Prob_data.Geom.Hale = Prob_data.Geom.Hmax-(nodos(2*na+5,2)) ;  % Hc
Prob_data.Geom.Le   = abs(nodos(2*na+5,1)*2) ; 
Prob_data.Geom.na = na ;
 
%% Nodos con peso propio de cubierta+correas 
pp = [] ;  sc = [] ;
Area = p_PropGeomArea(Prob_data.Predim.CO) ; % en cm^2

PPcor = Area*(1/10000)*Prob_data.Geom.Sep*Prob_data.Mat.Acero.PesEsp*1000  ; %PesEsp en [kN/m^3]

PPcub = Prob_data.Cargas.PPCub ; % = 40; % N/m^2 
SCcub = Prob_data.Cargas.Sobre ;
for ic=1:(na+3)/2
    if ic==1
        lcor=(sqrt((nodos(ic,1)-nodos(ic+1,1))^2 + (nodos(ic,2)-nodos(ic+1,2))^2)/2)*2 ;
    elseif ic==(na+3)/2
        lcor=sqrt((nodos(ic,1)-nodos(ic-1,1))^2 + (nodos(ic,2)-nodos(ic-1,2))^2)/2 ;
    else
        lcor=sqrt((nodos(ic,1)-nodos(ic+1,1))^2 + (nodos(ic,2)-nodos(ic+1,2))^2)/2 +...
            sqrt((nodos(ic,1)-nodos(ic-1,1))^2 + (nodos(ic,2)-nodos(ic-1,2))^2)/2 ;
    end
    pp=[pp lcor*Prob_data.Geom.Sep*PPcub+PPcor] ;
    sc=[sc lcor*Prob_data.Geom.Sep*SCcub] ;
end 
pp = [pp pp(2:end)]   ; 
sc = [sc sc(2:end)]   ; 
Prob_data.Cargas.NodCubPP = [[1:(na+3)/2  ((na+3)/2+1):(na+2)] ; -pp]' ; % Nodos con peso propio de cubierta+correas
Prob_data.Cargas.NodCubSC = [[1:(na+3)/2  ((na+3)/2+1):(na+2)] ; -sc]' ; % Nodos con del CS con sobre carga 




