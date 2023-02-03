function Prob_data = model5(Prob_data)  

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
        lc=vx/cosd(alp)/n(in); 
%             if (n(in)*lc*cosd(alp))>=vx 
%                 sol=acosd(vx/(n(in)*lc(il))) ; % angulo en grados 
%                 if sol<am||sol>aM ; sol = NaN ; end ;
%             else
%                 sol = NaN ;
%             end 
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
% m1 = tand(-alphi) ; m2 = tand(-alphi-90) ; 


vertex(1,:) = [0.0 0.0] ; 
vertex(2,:) = [(L+Bc) -(L+Bc)*tand(alphi)] ;
vertex(3,:) = [(L+Bc) -(L*tand(alphi)+h/cosd(alphi)) ] ; 
vertex(4,:) = [ L     vertex(3,2)] ;
vertex(5,:) = [ Bc    -(h/cosd(alphi)+Bc*tand(alphi))] ;
vertex(6,:) = [0.0    vertex(5,2) ] ;












% pm = Prob_data.Geom.pend(1) ; %pendiente minima 2.5%
% pM = Prob_data.Geom.pend(2) ; %pendiente maxima 35% 
% Bc = Prob_data.Geom.Bc ;
% Hc = Prob_data.Geom.Hc ;
% L  = Prob_data.Geom.L ; 
% vx = (L-Bc) ;
% 
% % Variable de entrada: h alpha lc
% lc    = Prob_data.Geom.lc ;           % Separación entre correas [1.0  1.5] 
% h     = Prob_data.Geom.h ;           % round(0.03*L,2)  % Se adopta h igual a 3% de L
% vertex = [] ;
%%
% if pm<pM
%     am = atand(pm) ; %angulo en grad para pendiente minima 2.5%
%     aM = atand(pM) ; %angulo en grad para pendiente maxima 35% 
%     lm = vx/cosd(am) ;
%     lM = vx/cosd(aM) ;
%     n = floor(lm/max(lc)):floor(lM/min(lc)) ;  
%     b = h ; 
%     syms t;  
%     s=zeros(size(n,2),size(lc,2)) ; 
%     for in=1:size(n,2)
%         for il=1:size(lc,2)     
%             if (n(in)*lc(il))>=vx 
%                 sol=acosd(vx/(n(in)*lc(il))) ; % angulo en grados 
%                 if sol<am||sol>aM ; sol = NaN ; end ;
%             else
%                 sol = NaN ;
%             end
%             s(in,il) = sol ;
%         end
%     end
%     ind = find(~isnan(s)) ;
%     col = ceil(ind/size(s,1)) ;
%     row = ind-(ceil(ind/size(s,1))-1)*size(s,1) ; 
% 
%     fprintf('--- Geometrías admisibles \n')   
%     fprintf('| Geom. | Angulo     | Sep.Correa | Cant.Divisiones | Long.Aprox. | \n' );                       
%     long = [];       
%     for i=1:size(ind,1)
%         long = [long f_long_aprox(n(row(i)),lc(col(i)),h,s(ind(i)),model)] ;
%         if i>9 ; format1='|    %i |'; else; format1='|     %i |'; end  
%         if s(ind(i))>9 ; format2='  %f |'; else; format2='   %f |'; end  
%         format3='   %f |' ;
%         if n(row(i))>9 ; format4='              %i |'; else ; format4='               %i |'; end
%         if long(i)>100 ; format5='  %f |'; else ; format5='   %f |'; end
%         format=[format1 format2 format3 format4 format5 '\n'] ; 
%         fprintf(format,i,s(ind(i)),lc(col(i)),n(row(i)),long(i));
%     end
%     [~,dd]=min(long) ;  
%     fprintf('--- Seleccionar la geometría, por defecto [%i]:',dd)  ;
%     prompt = ' ' ;
%     geom = input(prompt) ; 
%     if isempty(geom) ; geom = dd; end ;
% 
%     na = n(row(geom)) ;
%     la = lc(col(geom)) ;
%     Prob_data.Geom.pend(1) = tand(s(ind(geom))) ; % tangente angulo en grados
%     Prob_data.Geom.lc = la ;
% 
%     alphi = s(ind(geom)) ;  
%     vertex(1,:) = [0.0 0.0] ; 
%     vertex(2,:) = [(L+Bc) -(L+Bc)*tand(alphi)] ;
%     vertex(3,:) = [(L+Bc) -(L*tand(alphi)+h/cosd(alphi)) ] ; 
%     vertex(4,:) = [ L     vertex(3,2)] ;
%     vertex(5,:) = [ Bc    -(h/cosd(alphi)+Bc*tand(alphi))] ;
%     vertex(6,:) = [0.0    vertex(5,2) ] ; 
%             
% elseif pm==pM 
% %% Pendiente de cumbrera definida
%     alphi = atand(Prob_data.Geom.pend(1)) ; %angulo en grad para pendiente dato
%     m1 = tand(-alphi) ; m2 = tand(-alphi-90) ;  
%     Lt = vx/cosd(alphi) ;
%     na = floor(Lt/lc) ; 
%     la = lc ;
%      
%     vertex(1,:) = [0.0 0.0] ; 
%     vertex(2,:) = [(L+Bc) -(L+Bc)*tand(alphi)] ;
%     vertex(3,:) = [(L+Bc) -(L*tand(alphi)+h/cosd(alphi)) ] ; 
%     vertex(4,:) = [ L     vertex(3,2)] ;
%     vertex(5,:) = [ Bc    -(h/cosd(alphi)+Bc*tand(alphi))] ;
%     vertex(6,:) = [0.0    vertex(5,2) ] ;
% end
li = Bc/cosd(alphi) + abs(vertex(6,2))*sind(alphi) + la/2 ;

csup = [vertex(1,:) ; [li*cosd(alphi) -li*sind(alphi)] ; ...
    [[(li + la.*(1:(na-1))).*cosd(alphi)]' -[(li + la.*(1:(na-1))).*sind(alphi)]'] ; ...
    vertex(2,:) ] ;

cinf = [vertex(6,:) ; vertex(5,:) ; [[Bc+(la.*(1:na)).*cosd(alphi)]' [vertex(5,2)-(la.*(1:na)).*sind(alphi)]'] ; ...
    vertex(3,:) ] ;

nodos = [csup ; cinf ] ; 
nodos(:,1) = -nodos(:,1) ;

cold  = [nodos(2*na+5,1)  nodos(2*na+5,2)-Hc] ;
coli  = [nodos(na+3,1)    cold(1,2)] ;

nodos = [nodos ; cold ; coli] ; 

barcs = [[1:(na+1) ; 2:(na+2)]'] ;
barci = [(na+3):(2*na+5-1) ; (na+3+1):(2*na+5)]' ; 

bardi = [1:(na+2) ; (na+3):(2*na+4)]' ;
bardd = [1:(na+2) ; (na+4):(2*na+5)]' ;

conec = [[barcs ones(size(barcs,1),1)*10] ; [barci ones(size(barci,1),1).*20] ;...
    [bardi ones(size(bardi,1),1).*30] ; [bardd ones(size(bardd,1),1).*30]] ;
conec([na+2  2*na+3  2*na+4  3*na+5  3*na+6  4*na+7],3) = 31 ; 

conec = [conec ; [2*na+6  2*na+5  0] ; [2*na+7  na+3  0] ] ;
fixed = [2*na+6  2*na+7] ; 

% StructurePlot(conec,nodos) ;

nelem = size(conec,1) ;
npoin = size(nodos,1) ;
nfixe = size(fixed,2) ;

Prob_data.conec = conec;
Prob_data.coord = nodos;
Prob_data.fixed = fixed;  
Prob_data.Geom.Hmax = (nodos(1,2)-nodos(end,2)) ; 
Prob_data.Geom.Hale = Prob_data.Geom.Hmax-(-vertex(2,2)) ; 
Prob_data.Geom.Le   = abs(vertex(2,1)) ; 
Prob_data.Geom.na = na ;

%% Nodos con peso propio de cubierta+correas 
pp = [] ; sc = [] ;
Area = p_PropGeomArea(Prob_data.Predim.CO) ; % en cm^2

PPcor = Area*(1/10000)*Prob_data.Geom.Sep*Prob_data.Mat.Acero.PesEsp*1000  ; %PesEsp en [kN/m^3]

PPcub = Prob_data.Cargas.PPCub ; % = 40; % N/m^2 
SCcub = Prob_data.Cargas.Sobre ; % 6; % kN/m^2 para el entrepiso liviano
for ic=1:(na+2)
    if ic==1
        lcor=sqrt((nodos(ic,1)-nodos(ic+1,1))^2 + (nodos(ic,2)-nodos(ic+1,2))^2)/2 ;
    elseif ic==(na+2)
        lcor=sqrt((nodos(ic,1)-nodos(ic-1,1))^2 + (nodos(ic,2)-nodos(ic-1,2))^2)/2 ;
    else
        lcor=sqrt((nodos(ic,1)-nodos(ic+1,1))^2 + (nodos(ic,2)-nodos(ic+1,2))^2)/2 +...
            sqrt((nodos(ic,1)-nodos(ic-1,1))^2 + (nodos(ic,2)-nodos(ic-1,2))^2)/2 ;
    end
    pp=[pp lcor*Prob_data.Geom.Sep*PPcub+PPcor] ;
    sc=[sc lcor*Prob_data.Geom.Sep*SCcub] ;
end 
Prob_data.Cargas.NodCubPP = [1:(na+2) ; -pp]' ; % Nodos con peso propio de cubierta+correas
Prob_data.Cargas.NodCubSC = [1:(na+2) ; -sc]' ; % Nodos con del CS con sobre carga 


