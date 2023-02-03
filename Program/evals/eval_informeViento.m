function eval_informeViento(m_CargasE)
addpath(genpath('./../'));
%% Informe
% FMT: publish('informe.m','codeToEvaluate','informe(Prob_data)','format','pdf','outputDir',[pwd '/Informe'],'showCode',false)   ;
% 
DatosIntra.m_CargasE = m_CargasE;
% options = struct('format','pdf');
options.format = 'pdf';
options.outputDir = [pwd '/Informe'];
options.showCode = false;
options.codeToEvaluate = 'informe_viento(m_CargasE)';
publish('informe_viento.m','codeToEvaluate','informe_viento(DatosIntra);','format','pdf','outputDir',[pwd '/Informe'],'showCode',false);
% publish('informe_viento.m',options) ;


end