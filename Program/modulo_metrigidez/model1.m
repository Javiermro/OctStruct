function Prob_data = model1(Prob_data)  

global model nelem npoin nfixe

pm = Prob_data.Geom.pend(1) ; %pendiente minima 2.5%
pM = Prob_data.Geom.pend(2) ; %pendiente maxima 35%
am = atand(pm) ;  %angulo en grados
aM = atand(pM) ;  
Bc = Prob_data.Geom.Bc ;
Hc = Prob_data.Geom.Hc ;
L  = Prob_data.Geom.L ; 
vx = (L-Bc)/2 ; 
if am==aM;
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
        lc=(vx + h*sind(alp))/cosd(alp)/(n(in)+0.5);
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
vertex(3,:) = [(L+Bc)/2     -((na+1/2)*la*sind(alphi)+h*cosd(alphi))] ;
vertex(4,:) = [(L-Bc)/2     vertex(3,2)] ;
vertex(5,:) = [0.0          -(h/cosd(alphi))] ;
vertex(2,:) = [(vertex(3,2)-m2*vertex(3,1))/(m1-m2)  m1*(vertex(3,2)-m2*vertex(3,1))/(m1-m2) ] ;
            
    
    
    





% if pm<pM %isempty(Prob_data.Geom.pend) 
%     am = atand(pm) ; %angulo en grad para pendiente minima 2.5%
%     aM = atand(pM) ; %angulo en grad para pendiente maxima 35% 
%     lm = vx/cosd(am) ;
%     lM = vx/cosd(aM) ;
%     n = floor(lm/max(lc)):floor(lM/min(lc)) ;  
%     b = h ; 
%     syms t;  
%     s=zeros(size(n,2),size(lc,2)) ; iiter=1; niter=0; 
%     for in=1:size(n,2)
%         for il=1:size(lc,2)    
%             a=n(in)*lc(il)+lc(il)/2 ; 
%             if a>=vx 
%                 eqn(t) = a*cosd(t)-b*sind(t)-vx ;
%                 sol = eval(solve(eqn,t,'Real',true,'PrincipalValue',true)) ;
%                 if sol<am||sol>aM ; sol = NaN ; end ;
%             else
%                 sol = NaN ;
%             end
%             s(in,il) = sol ; 
%             iiter=iiter+1;
%             if iiter>niter
%                 niter=niter+size(lc,2)*size(n,2)/70 ; 
%                 fprintf('.')
%             end
%         end  
%     end
%     fprintf('  \n')
%     ind = find(~isnan(s)) ;
%     col = ceil(ind/size(s,1)) ;
%     row = ind-(ceil(ind/size(s,1))-1)*size(s,1) ; 
% 
%     fprintf('--- Geometrías admisibles \n')    
%     fprintf('| Geom. | Angulo     | Sep.Correa | Cant.Divisiones | Long.Aprox. | \n' );                       
%     long = [];       
%     for i=1:size(ind,1)
%         long = [long f_long_aprox(n(row(i)),lc(col(i)),h,s(ind(i)),model)] ;
%             format='|     %i |  %f |   %f |               %i |   %f |\n' ;
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
%     la = lc(col(geom)) ;
%     Prob_data.Geom.pend(1) = tand(s(ind(geom))) ; % tangente angulo en grados
%     Prob_data.Geom.lc = la ;
%   
%     alphi = s(ind(geom)) ; 
%     m1 = tand(-alphi) ; m2 = tand(-alphi-90) ; 
%     vertex(1,:) = [0.0 0.0] ; 
%     vertex(2,:) = [0.0 0.0] ;  
%     vertex(3,:) = [(L+Bc)/2     -((na+1/2)*la*sind(alphi)+h*cosd(alphi))] ;
%     vertex(4,:) = [(L-Bc)/2     vertex(3,2)] ;
%     vertex(5,:) = [0.0          -(h/cosd(alphi))] ;
%     vertex(2,:) = [(vertex(3,2)-m2*vertex(3,1))/(m1-m2)  m1*(vertex(3,2)-m2*vertex(3,1))/(m1-m2) ] ;
%             
% elseif pm==pM 
%     am = atand(pm) ; %angulo en grad para pendiente minima 2.5%
%     lm = vx/cosd(am) ;  
%     n = floor(lm/max(lc)):floor(lm/min(lc)) ;  
%     b = h ; 
%     s=zeros(size(n,2),size(lc,2)) ; iiter=1; niter=0; 
%     for in=1:size(n,2)
%         lc
%         
%         for il=1:size(lc,2)    
%             a=n(in)*lc(il)+lc(il)/2 ;  
%             err= a*cosd(am)-b*sind(am)-vx ;
%             if abs(err)<dlc
%                 sol = am;
%             else
%                 sol = NaN; 
%             end  
%             s(in,il) = sol ; 
%             iiter=iiter+1;
%             if iiter>niter
%                 niter=niter+size(lc,2)*size(n,2)/70 ; 
%                 fprintf('.')
%             end
%         end  
%     end    
%     
%     fprintf('  \n')
%     ind = find(~isnan(s)) ;
%     col = ceil(ind/size(s,1)) ;
%     row = ind-(ceil(ind/size(s,1))-1)*size(s,1) ; 
% 
%     fprintf('--- Geometrías admisibles \n')    
%     fprintf('| Geom. | Angulo     | Sep.Correa | Cant.Divisiones | Long.Aprox. | \n' );                       
%     long = [];       
%     for i=1:size(ind,1)
%         long = [long f_long_aprox(n(row(i)),lc(col(i)),h,s(ind(i)),model)] ;
%             format='|     %i |  %f |   %f |               %i |   %f |\n' ;
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
%     if isempty(geom) ; geom = dd; end 
%     
%     na = n(row(geom)) ;
%     la = lc(col(geom)) ;
%     Prob_data.Geom.pend(1) = tand(s(ind(geom))) ; % tangente angulo en grados
%     Prob_data.Geom.lc = la ;
%     
%     
% %     na = n  ;
% %     la = lc  ; 
% %     Prob_data.Geom.lc = la ;
% 
%     alphi = atand(Prob_data.Geom.pend(1)) ; 
%     if (alphi==0) ; alphi=1E-12 ; end
%     
%     m1 = tand(-alphi) ; m2 = tand(-alphi-90) ; 
%      
%     vertex(1,:) = [0.0 0.0] ; 
%     vertex(2,:) = [0.0 0.0] ;  
%     vertex(3,:) = [(L+Bc)/2     -((na+1/2)*la*sind(alphi)+h*cosd(alphi))] ;
%     vertex(4,:) = [(L-Bc)/2     vertex(3,2)] ;
%     vertex(5,:) = [0.0          -(h/cosd(alphi))] ;
%     vertex(2,:) = [(vertex(3,2)-m2*vertex(3,1))/(m1-m2)  m1*(vertex(3,2)-m2*vertex(3,1))/(m1-m2) ] ;    
%  
% end
 
csup = [vertex(1,:) ;[la.*(1:na).*cosd(alphi)  ;-la.*(1:na).*sind(alphi) ]'; vertex(2,:)] ;
csup = [csup ; [-la.*(1:1:na).*cosd(alphi)  ;-la.*(1:1:na).*sind(alphi)]' ; [-vertex(2,1) vertex(2,2)]] ; 

p1 = [0.0 vertex(5,2)] ;
p2 = ([csup(2,:)]).*0.5 ;
pi = [(-m2*p2(1)+p2(2)-p1(2))/(m1-m2) ; m1*(-m2*p2(1)+p2(2)-p1(2))/(m1-m2)+p1(2)] ;

cinf = [[pi(1)+la.*(0:1:(na-1)).*cosd(alphi) ; pi(2)-la.*(0:1:(na-1)).*sind(alphi)]' ; vertex(4,:); vertex(3,:)];
cinf = [ cinf ; [-cinf(:,1) cinf(:,2)]] ;

%% intersección de dos rectas      m = tand(alphi+180) ;     n = tand(alphi+180-90) ; %tand(atand(1/tand(m))+m*2) ;     vertex(5,:) = [ (-m*vertex(4,1)+vertex(4,2))/(n-m)   n*(-m*vertex(4,1)+vertex(4,2))/(n-m) ] ;
nodos = [csup ; cinf ] ;
size(csup,1) ;
barcs = [[1:(na+1); 2:(na+2)]' ; [[1 (na+3):((na+3)+na-1)] ; [(na+3):((na+3)+na)]]' ] ; % barras cordon sup.
barci = [[(size(csup,1)+1) ((size(csup,1)+1)+na+2)] ;[(size(csup,1)+1):((size(csup,1)+1)+na) ; (size(csup,1)+2):((size(csup,1)+1)+na+1)]' ; ...
        [((size(csup,1)+1)+na+2):(((size(csup,1)+1)+na+2)+na) ; ((size(csup,1)+1)+na+3):(((size(csup,1)+1)+na+2)+na+1) ]'] ; % barras cordon inf.
bardi = [[1:(na+2) ; (size(csup,1)+1):((size(csup,1)+1)+na+1)]' ; [2:(na+2) ;(size(csup,1)+1):((size(csup,1)+1)+na)]'] ;
bardd = [[[1 (na+3):((na+3)+na)] ; ((size(csup,1)+1)+na+2):(((size(csup,1)+1)+na+2)+na+1)]' ; ...
        [(na+3):((na+3)+na) ; ((size(csup,1)+1)+na+2):(((size(csup,1)+1)+na+2)+na)]' ] ;
conec = [[barcs ones(size(barcs,1),1)*10] ; [barci ones(size(barci,1),1).*20] ;...
    [bardi ones(size(bardi,1),1).*30] ; [bardd ones(size(bardd,1),1).*30]] ;
conec([5*na+6 5*na+7 6*na+8 7*na+9 7*na+10 8*na+11],3) = 31 ;


cold  = [nodos(3*na+5,1)  nodos(3*na+5,2)-Hc] ;
coli  = [nodos(4*na+7,1)  nodos(4*na+7,2)-Hc] ;
nodos = [nodos ; cold ; coli] ;
conec = [conec ; [4*na+8  3*na+5  0] ; [4*na+9  4*na+7  0] ] ;
fixed = [4*na+8  4*na+9] ; 

% StructurePlot(conec,nodos) ;

nelem = size(conec,1) ;
npoin = size(nodos,1) ;
nfixe = size(fixed,2) ;

Prob_data.conec = conec;
Prob_data.coord = nodos;
Prob_data.fixed = fixed; 
Prob_data.Geom.Hmax = (nodos(1,2)-nodos(end,2)) ; 
Prob_data.Geom.Hale = Prob_data.Geom.Hmax-(-vertex(2,2)) ; 
Prob_data.Geom.Le   = abs(vertex(2,1)*2) ; 
Prob_data.Geom.na = na ;

% Prob_data.Cargas.PPcub = [1:(2*(na+1)+1)] ; % Nodos con peso propio de cubierta+correas
%% Nodos con peso propio de cubierta+correas 
pp = [] ;  sc = [] ;
Area = p_PropGeomArea(Prob_data.Predim.CO) ; % en cm^2

PPcor = Area*(1/10000)*Prob_data.Geom.Sep*Prob_data.Mat.Acero.PesEsp*1000  ; %PesEsp en [kN/m^3]

PPcub = Prob_data.Cargas.PPCub ; % = 40; % N/m^2 
SCcub = Prob_data.Cargas.Sobre ; %N/m^2
for ic=1:(na+2)
    if ic==1
        lcor=(sqrt((nodos(ic,1)-nodos(ic+1,1))^2 + (nodos(ic,2)-nodos(ic+1,2))^2)/2)*2 ;
    elseif ic==(na+2)
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
Prob_data.Cargas.NodCubPP = [[1:(na+2) (na+3):(2*(na+1)+1)] ; -pp]' ; % Nodos con peso propio de cubierta+correas
Prob_data.Cargas.NodCubSC = [[1:(na+2) (na+3):(2*(na+1)+1)] ; -sc]' ; % Nodos con del CS con sobre carga 




