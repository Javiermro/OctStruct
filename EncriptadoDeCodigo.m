% Copiado del código. En caso de nuevas subrutinas, se deben agregar los
% nombres de las mismas.
copyfile ./Data/* ./../OctStructProyect/Data/
copyfile ./Informes/FigurasFijas/* ./../OctStructProyect/Informes/FigurasFijas/
copyfile ./Program/DXFLib/* ./../OctStructProyect/Program/DXFLib/
copyfile ./Program/evals/* ./../OctStructProyect/Program/evals/
copyfile ./Program/modulo_HA/* ./../OctStructProyect/Program/modulo_HA/
copyfile ./Program/modulo_chapaplegada/* ./../OctStructProyect/Program/modulo_chapaplegada/
copyfile ./Program/modulo_metrigidez/* ./../OctStructProyect/Program/modulo_metrigidez/
copyfile ./Program/modulo_viento/* ./../OctStructProyect/Program/modulo_viento/
copyfile ./Program/tests/* ./../OctStructProyect/Program/tests/
copyfile ./MANUAL/Manual_Usuario.pdf ./../OctStructProyect/MANUAL/Manual_Usuario.pdf
copyfile ./Program.m ./../OctStructProyect/Program.m
copyfile ./informe.m ./../OctStructProyect/informe.m
copyfile ./informeCubAis.m ./../OctStructProyect/informeCubAis.m

% Encriptado 
cd ./../OctStructProyect/Program/DXFLib
pcode('*.m')

cd ./../modulo_chapaplegada
pcode("*.m")

cd ./../modulo_viento
pcode("*.m")

cd ./../modulo_metrigidez
pcode("*.m")
% pcode('CondBorde.m','EstadosCIRSOC2.m','f_ProxString.m','model4.m','PlotPerfil.m',...
%     'RellenosParaInformeJLM.m','ElementAsignDNS.m','f_CargasTramo.m','f_VerifNom.m',...
%     'long_elem2D.m','model5.m','PlotSolicitaciones.m','Solicitaciones.m','Elements.m',...
%     'f_FindFix.m','Geometry.m','model1.m','PesoCercha.m','PlotStructure.m',...
%     'StructurePlot.m','EnsamblajeF.m','f_long_aprox.m','model2.m','PlotApoyos.m',...
%     'Read_data.m','Verificacion.m','EnsamblajeK.m','f_ProxString2.m','model3.m',...
%     'PlotMfCorreas.m','Read_section.m')
