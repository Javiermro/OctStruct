function [Prob_data] = Read_data(path_file,file) 
% Lee los datos  
global model nelem nnodo npoin nfixe ndofs nload
nnodo = 2 ; ndofs = 3 ;

Prob_data = struct('Info',[],'Geom',[],'Mat',[],'Estados',[],'conec',[],'coord',[],'fixed',[]) ; %,'nodfz',nodfz,'barfz',barfz,'qtype',qtype,'fixed',fixed,'esc',esc);

file_open = fullfile(path_file,file);
fid = fopen(file_open,'r');

%% LEE DATOS DEL INFORME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seccion = f_ProxString2(fid);
f_VerifNom(seccion,'TITULO',...
   'No esta definido el inicio con "TITULO".')  
title = f_ProxString2(fid);  
if size(title,2)==5
    if (title=='FECHA')
        seccion=title ;
        title='Proyecto de estructura' ;
    else
        seccion = f_ProxString2(fid);
    end  
else
    seccion = f_ProxString2(fid);
end

f_VerifNom(seccion,'FECHA',...
   'No esta definido el inicio con "FECHA".')  
fecha =  f_ProxString2(fid) ;  
if size(fecha,2)==10
    if (fecha=='CALCULISTA')
        seccion=fecha ;
        fecha=date ;
    else
        seccion = f_ProxString2(fid);
    end  
else
    seccion = f_ProxString2(fid);
end  
   
f_VerifNom(seccion,'CALCULISTA',...
   'No esta definido el inicio con "CALCULISTA".')  
calc = f_ProxString2(fid) ;  
if size(calc,2)==11
    if (calc=='SOLICITANTE')
        seccion=calc ;
        calc='Calculista' ; 
    else
        seccion = f_ProxString2(fid);
    end  
else
    seccion = f_ProxString2(fid);
end
  
f_VerifNom(seccion,'SOLICITANTE',...
   'No esta definido el inicio con "SOLICITANTE".')  
solic = f_ProxString2(fid); 
if size(solic,2)==6
    if (solic=='MODELO')
        seccion=solic ;
        solic='Solicitante' ; 
    else
        seccion = f_ProxString2(fid);
    end  
else
    if(solic(1:6)=='MODELO')
        model = str2num(solic(8)) ;
        solic='Solicitante' ; 
        seccion = 'MODELO' ;
    else
        seccion = f_ProxString(fid);
    end
end
  
info = struct('title',title,'date',fecha,'calc',calc,'solic',solic) ;

%% LEE DATOS DEL PROBLEMA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
f_VerifNom(seccion,'MODELO',...
   'No esta definido el inicio con "MODELO".')  
matrix = textscan(fid,'%u');%,nElem,'CollectOutput',1,'CommentStyle','$');
if (isempty(model)) ; model = [matrix{1}] ; end
if ~(model==1||model==2||model==3||model==4||model==5||model==6)
    error(['MODELO: Datos de MODELO incorrecto'])
end

%% LEE DATOS DE LA GEOMETRIA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seccion = f_ProxString(fid);
f_VerifNom(seccion,'PENDIENTE/FLECHA','Datos de geometria: No esta definido el inicio con "PENDIENTE".')
matrix = textscan(fid,'%f %f'); 
if (isempty(matrix{1}))  
    alpha = [0.025  0.350] ;  
elseif size(matrix,2)==2
    if isempty(matrix{2})||isnan(matrix{2})
        alpha = [matrix{1} matrix{1}];
    else
        alpha = [matrix{1} matrix{2}];
    end 
    if alpha(2)<alpha(1) 
        error(['PENDIENTE/FLECHA: pendiente (o flecha) minima mayor que la maxima'])
    end 
end 

seccion = f_ProxString(fid);
f_VerifNom(seccion,'CORREAS','Datos de geometria: No esta definido el inicio con "CORREAS".') 
matrix = textscan(fid,'%f %f'); 
if (isempty(matrix{1}))  
    lc = [1.00  1.50] ;  
elseif size(matrix,2)==2
    if isempty(matrix{2})||isnan(matrix{2})
        lc = [matrix{1} matrix{1}];
    else
        lc = [matrix{1} matrix{2}];
    end 
    if lc(2)<lc(1) 
        error(['CORREAS: separacion de correas minima mayor que la maxima'])
    end 
end  
% matrix = textscan(fid,'%f'); 
% lc = [matrix{1}];
% if (isempty(lc)) ; lc = [1.50 1.45 1.40 1.35 1.30 1.25 1.20 1.15 1.10 1.05 1.0] ; end 

seccion = f_ProxString(fid);
f_VerifNom(seccion,'BRAZO','Datos de geometria: No esta definido el inicio con "CORREAS".') 
matrix = textscan(fid,'%f'); 
h = [matrix{1}];
if (isempty(h)) ; 
    if model==5
        h = 0.05 ;
    else
        h = 0.03 ;
    end
end

seccion = f_ProxString(fid);
f_VerifNom(seccion,'GEOMETRIA','Datos de geometria: No esta definido el inicio con "GEOMETRIA".') 
matrix = textscan(fid,'%f %f %f'); 
matrix = [matrix{1} matrix{2} matrix{3} ];% alpha lc] ;  
if(find(isnan(matrix),1))
    error(['ERROR: Datos de GEOMETRIA incompletos, Bc Hc L Lc'])
end
h = round(h*matrix(1)*100)/100 ;   % Se adopta h igual a 3% de L
Geom.L   = matrix(1) ;
Geom.Lt  = matrix(2) ; % longitud de la cumbrera [m]
Geom.Sep = matrix(3) ; % Separacion entre cerchas
if (model==4 && alpha(1)==0.025 && alpha(2)==0.35) 
    Geom.f = alpha*Geom.L ; 
elseif model==4  
    Geom.f = alpha ; 
else
    Geom.pend = alpha ;
end 
Geom.lc = lc;
Geom.h = h ;

if (Geom.Lt/Geom.Sep - fix(Geom.Lt/Geom.Sep ))~=0
    error('ERROR: Datos de GEOMETRIA, la separación entre cerchas no es multiplo del largo total')
end

%% LEE DATOS DE LOS MATERIALES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seccion = f_ProxString(fid);
f_VerifNom(seccion,'ACERO','Datos de geometria: No esta definido el inicio con "ACERO".') 
F = f_ProxString(fid); 
if F=='F24'
    Mat.Acero.AceroTipo = 'F24';
    Mat.Acero.Fy = 235*1000*1000 ;  % [Pa]   235 MPa
    Mat.Acero.E = 210*1000*1000*1000;       % [Pa] 210 GPa 
    Mat.Acero.PesEsp = 78.5 ;    % [kN/m^3] 
else
    error(['ACERO: Datos de MATERIAL incompletos'])
end

seccion = f_ProxString(fid);
f_VerifNom(seccion,'HORMIGON','Datos: No esta definido el inicio con "HORMIGON".') 
H = f_ProxString(fid); 

seccion = f_ProxString(fid);
f_VerifNom(seccion,'COLUMNAS','Datos: No esta definido el inicio con "COLUMNAS".') 
matrix = textscan(fid,'%f %f %f %f %f %f %f %f'); 
if (isempty(H)) 
    error(['ERROR: Datos de MATERIAL incompletos']) 
else
    Mat.Hormigon.Tipo = H ;
    Mat.Hormigon.Mat.E     = 21*1000*1000*1000;  % [Pa] 21 GPa
    Mat.Hormigon.Mat.PesEsp= 23.54 ;    % [kN/m^3]
    Mat.Hormigon.Geom.Area = matrix{3}*matrix{2} ;
    Mat.Hormigon.Geom.Ix   = (matrix{3}*matrix{2}^3)/12 ;
    
    Mat.Hormigon.Geom.Hc = matrix{1} ; % altura de columna [m]
    Mat.Hormigon.Geom.Bc = matrix{2} ; % ancho (de flexion) de columna, es perpendicular a cumbrera [m]

    Mat.Hormigon.Geom.h    = matrix{2} ;    
    Mat.Hormigon.Geom.b    = matrix{3} ; % ancho paralelo a cumbrera [m]
    Mat.Hormigon.Geom.Db   = matrix{4} ; % Diámetro de barras (mm)
    Mat.Hormigon.Geom.Nb   = matrix{5} ; % Nro de barras
    Mat.Hormigon.Geom.De   = matrix{6} ; % Diámetro de estribos (mm)
    Mat.Hormigon.Geom.Se   = matrix{7} ; % Separación de estribos (m)
    Mat.Hormigon.Geom.nm   = matrix{8} ; % número de ramas de estribos

    Geom.Bc = Mat.Hormigon.Geom.Bc ;
    Geom.Hc = Mat.Hormigon.Geom.Hc ; 
end   

seccion = f_ProxString(fid);
f_VerifNom(seccion,'FUNDACIONES','Datos: No esta definido el inicio con "FUNDACIONES".') 
matrix = textscan(fid,'%f %f %f %f %f %f %f'); 
if (isempty(matrix{1})) 
    error(['ERROR: Datos de FUNDACIONES incompletos']) 
else
    Mat.Hormigon.Fund.Hf = matrix{1} ; % (m)
    Mat.Hormigon.Fund.t  = matrix{2} ; % (m)
    Mat.Hormigon.Fund.a  = matrix{3} ; % (m)
    Mat.Hormigon.Fund.b  = matrix{4} ; % (m)
    Mat.Hormigon.Fund.C  = matrix{5} ;
    Mat.Hormigon.Fund.am = matrix{6} ; 
    Mat.Hormigon.Fund.gm = matrix{7} ; 
end   

%% LEE DATOS DE USO Y CARGAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seccion = f_ProxString(fid);
f_VerifNom(seccion,'FACTORES','Datos de estados: No esta definido ') ; 
matrix = textscan(fid,'%f %f %f'); 
factor = [matrix{1} matrix{2} matrix{3}] ; 
if (isempty(factor)) ; 
    error(['ERROR: Datos de FACTORES incompletos'])
end 

seccion = f_ProxString(fid);
f_VerifNom(seccion,'CARGAS','Datos de cargas: No esta definido ') ; 
matrix = textscan(fid,'%f %f'); 
cargas = [matrix{1} matrix{2}] ; 
if (isempty(cargas)) ; 
    error(['ERROR: Datos de CARGAS incompletos'])
end 
 
seccion = f_ProxString(fid);
f_VerifNom(seccion,'USO','Datos de estados: No esta definido ') ;
Exp = f_ProxString(fid); 
Cat = f_ProxString(fid); 
matrix = textscan(fid,'%f'); 
carac = f_ProxString(fid); 
if carac=='Abierto'; carac='Aislado'; end
if (isempty(Exp)) ; 
    error(['ERROR: Datos de USO incompletos'])
end 
Cargas.Factor = factor ; 
Cargas.Exp = Exp ;
Cargas.Cat = Cat ;
Cargas.V = matrix{1} ;
Cargas.Carac = carac ;
Cargas.PPCub = cargas(1) ; % peso propio cubierta [N/m^2]
Cargas.Sobre = cargas(2) ; % Sobrecarga de uso [N/m^2] 
if(isempty(matrix{1})) ; error(['ERROR: Datos de USO incompletos']) ; end
if (carac=='Aislado') 
    matrix = textscan(fid,'%f %f'); 
    if( (matrix{1}>1) || (matrix{1}<0) || (matrix{2}~=0 && matrix{2}~=1))    
        error(['ERROR: Datos de USO incompletos o incorrectos para cubiertas Aisladas']) ;
    end
    Cargas.Epsilon = matrix{1} ;
    Cargas.PosBloqueo = matrix{2} ;
end

%% LEE DATOS DEL PREDIMENSIONADO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seccion = f_ProxString(fid);
f_VerifNom(seccion,'PREDIMENSIONADO','Datos de geometria: No esta definido el inicio con "ACERO".') 
if seccion=='PREDIMENSIONADO'
    barra='not'; 
    fixe = [] ; 
    while ~isempty(barra)
        barra = f_ProxString(fid);
        if size(barra,2)==2; 
            if barra == 'CS'
                Predim.CS = f_ProxString(fid);   
                fix_cs = [f_FindFix(Predim.CS)] ; 
                if(~isempty(find(Predim.CS=='=')) )
                    error(['ERROR: Datos de PREDIMENISIONAMIENTO, CS']) ;
                end 
            elseif barra == 'CI'
                Predim.CI = f_ProxString(fid);
                fix_ci = [f_FindFix(Predim.CI)] ;                 
            elseif barra == 'DI'
                Predim.DI = f_ProxString(fid);
                fix_di = [f_FindFix(Predim.DI)] ; 
            elseif barra == 'DA'
                Predim.DA = f_ProxString(fid);
                fix_da = [f_FindFix(Predim.DA)] ;  
            elseif barra == 'CO'
                Predim.CO = f_ProxString(fid);
            else
                break ; 
            end
        else
            break ; 
        end
    end
    
    if ~isfield(Predim,'CS')
        error(['ERROR: Datos de PREDIMENISIONAMIENTO incompletos, CS'])
    elseif ~isfield(Predim,'CI')
        error(['ERROR: Datos de PREDIMENISIONAMIENTO incompletos, CI'])
    elseif ~isfield(Predim,'DI')
        error(['ERROR: Datos de PREDIMENISIONAMIENTO incompletos, DI'])
    elseif ~isfield(Predim,'DA')
        error(['ERROR: Datos de PREDIMENISIONAMIENTO incompletos, DA'])
    elseif ~isfield(Predim,'CO')
        error(['ERROR: Datos de PREDIMENISIONAMIENTO incompletos, CO'])
    end
    fixe = [fix_cs fix_ci fix_di fix_da] ;
    alma = [fix_cs(1) fix_ci(1) fix_di(1) fix_da(1)];
    diag = [fix_di(2:3)-fix_da(2:3)] ;
    ia = find(alma<999) ;
    for i=1:size(ia,2)-1
        if (alma(ia(i))~=alma(ia(i+1)) )
            warning('ERROR: deben coincidir las almas de los perfiles predimensionados') ;
            %error('ERROR: deben coincidir las almas de los perfiles predimensionados') ;
        end
    end
    
    if find(diag~=0)
        error('ERROR: las diagonales de apoyo DA, solo pueden diferir en el espesor con las diagonales de tramo DI') ;
    end
    
    Predim.Fix = fixe ; 
     
else
    Predim = [] ;
end
 
Prob_data = struct('Info',info,'Geom',Geom,'Mat',Mat,'Cargas',Cargas,...
    'Predim',Predim,'conec',[],'coord',[],'fixed',[]) ; 


