
% Programa para el calculo de solidos 2D con elementos de barra lineales
% con grados de liberad de desplazamiento y rotacion
% Autor: Dr. Ing. Javier L. Mroginski
% Version: 2.0 (2017) 

clc;
clear all;
close all;
tic ;

fprintf('------------------------ MRigid --------------------------------------\n') 
fprintf(' Programa para el calculo de cerchas planas empleando el Met. Rigidez \n')
fprintf(' Autores: Dr. Ing. J.L. Mroginski & Dr. Ing. J.M. Podestá \n')
fprintf(' Version: 4.7 (2022)\n')
fprintf('----------------------------------------------------------------------\n') 

global model nelem nnodo npoin nfixe ndofs nload
addpath(genpath('./Data'))
addpath(genpath('./Program'))

%% INTRODUCCION DE ARCHIVO DE DATOS
%%%%%%%%%%%%%%%%%%%%%%%%
Proyect = 'CerchaTipo01-Ab';'RuralCtes';'CerchaModeloInforme'; 'CerchaTipo04-Ce';
%%%%%%%%%%%%%%%%%%%%%%%%
  
file = [Proyect '.dat'];
mkdir([pwd '/Informes/Proyecto_' Proyect]) 
diary([pwd '/Informes/Proyecto_' Proyect '/InformeErrores.txt'])
diary on 

% addpath([pwd '/modulo_chapaplegada']); 
% addpath([pwd '/modulo_HA']);
% addpath([pwd '/modulo_metrigidez']);
% addpath([pwd '/modulo_viento']);
% addpath([pwd '/tests']);
% addpath([pwd '/DXFLib']);
path_file = [pwd '/Data/']; 

OK = false ;

fig = 0 ;
Elem_data = [] ;
[Prob_data] = Read_data(path_file,file) ;

[Prob_data] = Geometry(Prob_data) ;

if strcmp(file,'15xGalva_entrepiso.dat')
    na = Prob_data.Geom.na ;
    fixed = [na+3 (na+3 + 2*na+5)/2 2*na+5   2*na+6  2*na+7] ;  
    nfixe = size(fixed,2) ; 
    Prob_data.fixed = fixed;   
end

Prob_data.Predim.Orig=Prob_data.Predim;
iter= 0 ; Prob_sect.CS = {} ; flag = 0 ;
[Prob_sect.CS,flag] = Read_section(path_file,Prob_data.Predim.CS,Prob_data.Predim.Fix(1:4),'Perfiles/Cordon.dat') ;
if flag ; warning(['*** Se emplea un perfil que no esta tabulado ***']) ; end
for ics=1:size(Prob_sect.CS,2)  
    Ap = f_FindFix(Prob_sect.CS{ics}) ;
    Prob_data.Predim.Fix(5:4:16) = Ap(1) ;      
    [Prob_sect.CI,flag] = Read_section(path_file,Prob_data.Predim.CI,Prob_data.Predim.Fix(5:8),'Perfiles/Cordon.dat') ; 
    if flag  
        if isempty(find(Prob_data.Predim.Fix(5:8)==999))
           warning(['*** Se emplea un perfil que no esta tabulado ***']) ; 
        else
            continue; 
        end
    end
    
    for ici=1:size(Prob_sect.CI,2)       
        [Prob_sect.DI,flag] = Read_section(path_file,Prob_data.Predim.DI,Prob_data.Predim.Fix(9:12),'Perfiles/Diagonal.dat') ; 
        if flag  
            if isempty(find(Prob_data.Predim.Fix(9:12)==999))
               warning(['*** Se emplea un perfil que no esta tabulado ***']) ; 
            else
                continue; 
            end
        end            
        for idi=1:size(Prob_sect.DI,2)
            if idi==1
                Ap = f_FindFix(Prob_sect.DI{idi}) ;
                Prob_data.Predim.Fix(13:1:15) = Ap(1:3) ;             
                Prob_data.Predim.DA(1) = Prob_sect.DI{idi}(1); 
                [Prob_sect.DA,flag] = Read_section(path_file,Prob_data.Predim.DA,Prob_data.Predim.Fix(13:16),'Perfiles/Diagonal.dat') ; 
                if flag  
                    if isempty(find(Prob_data.Predim.Fix(13:16)==999))
                       warning(['*** Se emplea un perfil que no esta tabulado ***']) ; 
                    else
                        continue; 
                    end
                end     
            end
            for ida=1:size(Prob_sect.DA,2)
                iter = iter + 1 ; 
                Prob_data.Predim.CS=Prob_sect.CS{ics} ; 
                Prob_data.Predim.CI=Prob_sect.CI{ici} ;
                Prob_data.Predim.DI=Prob_sect.DI{idi} ;
                Prob_data.Predim.DA=Prob_sect.DA{ida} ;  
                
                despG = zeros(ndofs*npoin,1) ;    
                [Elem_data] = Elements(Prob_data,Elem_data) ;
                OK = true ;  
                Prob_data.Cargas.qCO = [] ;
                for ie=1:Prob_data.Cargas.estados 
                    if isempty(Prob_data.Cargas.Viento)
                        [Prob_data] = EstadosCIRSOC2(Prob_data,[]) ;
                    else
                        [Prob_data] = EstadosCIRSOC2(Prob_data,...
                            Prob_data.Cargas.Viento(ie,:)) ;
                        if strcmp(file,'15xGalva.dat')
                            V=0.0; H = 71031; la = 3 ; % altura del entrepiso %V = 571874; H = 71092; 
                            [Elem_data] = f_CargasTramo(nelem-1,-H,-V,la,Elem_data) ;
                            [Elem_data] = f_CargasTramo(nelem  ,-H, V,la,Elem_data) ;
                        end
                    end
                    
                    [FGlob] = EnsamblajeF(Prob_data.nodfz) ;
                    [KGlob,FGlob] = EnsamblajeK(Prob_data.conec,Elem_data,FGlob) ;
                    [KGcon,FGcon,ifixe] = CondBorde(KGlob,FGlob,Prob_data.fixed) ;

                    despl=KGcon\FGcon ; despG(find(ifixe(:,1)==1)) = 0.0 ; despG(find(ifixe(:,1)==0)) = despl ; 

                    [Elem_data] = Solicitaciones(Elem_data,ie,despG) ; 
                    [Elem_data,OK] = Verificacion(Prob_data,Elem_data,ie,OK,fig) ; 
%                     fig = fig + 1;PlotSolicitaciones(Prob_data,Elem_data,despG,fig)
                end

                Peso = PesoCercha(Prob_data,Elem_data) ; % peso en N        
                fprintf('Iteración: %u , Peso de la cercha (tn): %12.5e , Verificación: %u  \n',iter , Peso/9.8067, OK )

                Prob_sol.Dim.OK(iter) = OK;
                Prob_sol.Dim.Peso(iter) = Peso/1000/9.8067; % [N]*[1kN/1000N]*[1tn/9.8067kN]
                Prob_sol.Dim.CS{iter} = Prob_sect.CS{ics} ;
                Prob_sol.Dim.CI{iter} = Prob_sect.CI{ici} ;
                Prob_sol.Dim.DI{iter} = Prob_sect.DI{idi} ;
                Prob_sol.Dim.DA{iter} = Prob_sect.DA{ida} ; 
    
            end
            Prob_data.Predim.DA=Prob_data.Predim.Orig.DA;
        end
        Prob_data.Predim.DI=Prob_data.Predim.Orig.DI;
    end
    Prob_data.Predim.CI=Prob_data.Predim.Orig.CI;
end 
     
[~,nv] = find(Prob_sol.Dim.OK==1) ;
[p,np] = min(Prob_sol.Dim.Peso(nv));

if isempty(np)
    error('*** NINGUN PERFIL CUMPLE LOS REQUERIMIENTOS ***') ;
end

fprintf('\n---DIMENSIONAMIENTO RECOMENDADO---\n') ;
fprintf('\n Peso de la cercha (tn):  %12.5e \n',Prob_sol.Dim.Peso(nv(np)) ) ;
fprintf(' Verificación:  %u \n',Prob_sol.Dim.OK(nv(np)) ) ;
fprintf(' Cordón superior (CS): %s \n',Prob_sol.Dim.CS{nv(np)} ) ;
fprintf(' Cordón inferior (CI): %s \n',Prob_sol.Dim.CI{nv(np)} ) ;
fprintf(' Cordón diagonal (DI): %s \n',Prob_sol.Dim.DI{nv(np)} ) ;
fprintf(' Cordón d. apoyo (DA): %s \n',Prob_sol.Dim.DA{nv(np)} ) ; 

Prob_data.Predim.CS=Prob_sol.Dim.CS{nv(np)} ;
Prob_data.Predim.CI=Prob_sol.Dim.CI{nv(np)} ;
Prob_data.Predim.DI=Prob_sol.Dim.DI{nv(np)} ;
Prob_data.Predim.DA=Prob_sol.Dim.DA{nv(np)} ; 

despG = zeros(ndofs*npoin,1) ;    
[Elem_data] = Elements(Prob_data,Elem_data) ;
fig = 0 ;
Prob_data.Cargas.qCO = [] ;

for ie=1:Prob_data.Cargas.estados
    fprintf('\n*** ESTADO %2i ***********************\n',ie) 
    if isempty(Prob_data.Cargas.Viento)
        [Prob_data] = EstadosCIRSOC2(Prob_data,[]) ;
    else
        [Prob_data] = EstadosCIRSOC2(Prob_data, Prob_data.Cargas.Viento(ie,:)) ;
        if strcmp(file,'15xGalva.dat') 
            [Elem_data] = f_CargasTramo(nelem-1,-H,-V,la,Elem_data) ;
            [Elem_data] = f_CargasTramo(nelem  ,-H, V,la,Elem_data) ;
        end
    end
    PlotStructure(Prob_data,1) ;

    FGlob = EnsamblajeF(Prob_data.nodfz) ;
    [KGlob,FGlob] = EnsamblajeK(Prob_data.conec,Elem_data,FGlob) ;
    [KGcon,FGcon,ifixe] = CondBorde(KGlob,FGlob,Prob_data.fixed) ;

    despl=KGcon\FGcon ; despG(find(ifixe(:,1)==1)) = 0.0 ; despG(find(ifixe(:,1)==0)) = despl ; 
    R = KGlob*despG-FGlob ;
    [Elem_data] = Solicitaciones(Elem_data,ie,despG) ; 
%     PlotSolicitaciones(Prob_data,Elem_data,despG,fig) ; 
    [Elem_data,OK] = Verificacion(Prob_data,Elem_data,ie,OK,fig) ; 
    %% Columnas y Fundaciones
    if ~strcmp(file,'15xGalva_entrepiso.dat')
    test_columna(Prob_data,Elem_data,ie); 
    test_fundacion(Prob_data,Elem_data,ie);
    end
end                
Prob_data = test_correas(Prob_data);

%% Informe
RellenosParaInformeJLM
if ispc
    FileFormat = 'doc';
else
    FileFormat = 'html';
end
if ~strcmp(Prob_data.Cargas.Carac,'Aislado')
    publish('informe.m','codeToEvaluate','informe(Prob_data,Design)','format',FileFormat,'outputDir',[pwd '/Informes/Proyecto_' Proyect],'showCode',false);
else
    publish('informeCubAis.m','codeToEvaluate','informeCubAis(Prob_data,Design)','format',FileFormat,'outputDir',[pwd '/Informes/Proyecto_' Proyect],'showCode',false);
end

%% Generación del plano
FID = dxf_open([pwd '/Informes/Proyecto_' Proyect '/' Proyect '.dxf']);
for k = 1:length(Prob_data.conec(:,1))
    dxf_polyline(FID,Prob_data.coord([Prob_data.conec(k,1) Prob_data.conec(k,2)]',1),Prob_data.coord([Prob_data.conec(k,1) Prob_data.conec(k,2)]',2),[0 0]');
end
dxf_close(FID);

%% Finalización
fclose('all') ;  
toc
diary off
