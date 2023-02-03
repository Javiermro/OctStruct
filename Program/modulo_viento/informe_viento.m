function informe_viento(DatosIntra)
fprintf('\n MEMORIA DE CÁLCULO - Análsis de viento CIRSOC 102 (Ed. Julio 2005)\n') ;
% fprintf(' %s \n',Prob_data.Info.title) ;
fprintf('\n   \n');
fprintf(' FECHA: %f \n',DatosIntra.m_CargasE(1,1));
% fprintf(' CALCULISTA: %s \n',Prob_data.Info.calc) ;
% fprintf(' SOLICITANTE: %s \n',Prob_data.Info.solic) ;
 


fprintf('\n   ') ;
fprintf('\n 1) NORMAS DE CÁLCULO \n') ;

fprintf('Para la determinación de las cargas de viento, se empleará: \n') ;
fprintf('­Reglamento argentino de acción del viento sobre las construcciones CIRSOC 102, edición de Julio 2005. \n') ;
fprintf('­Comentarios al reglamento argentino de acción del viento sobre las construcciones CIRSOC 102, edición de Julio 2005. \n') ;
% fprintf('Con respecto a la verificación de la estructura principal y secundaria, de chapa plegada, tanto como correas y vigas cajón, el procedimiento de cálculo será basado por la recomendación al CIRSOC 303, para Estructuras livianas de acero, Edición de Noviembre de 2001.\n') ;
% fprintf('Para el dimensionamiento de los elementos de hormigón armado será empleado el reglamento CIRSOC 201, edición de Julio de 1982.\n') ;


fprintf('\n 2) PLANTA DE ESTRUCTURA. \n') ;
fprintf('Se adjunta al final del documento la planta de estructura. \n') ;

fprintf('\n 3) DETERMINACION DE LAS CARGAS DE VIENTO. \n') ;
% fprintf('Se adjunta al final del documento la planta de estructura. \n') ;


fprintf('\n 4) SOLICITACIONES Y DIMENSIONAMIENTO DE LA ESTRUCTURA METÁLICA. \n') ;
fprintf('\n 4.1) CORREAS. \n') ;
fprintf('\n 4.1.1) SOLICITACIONES DE LAS CORREAS. \n') ;
fprintf('\n 4.1.2) DIMENSIONAMIENTO DE LAS CORREAS. \n') ;


fprintf('\n 4.2) CERCHA. \n') ;
fprintf('\n 4.2.1) SOLICITACIONES DE LA CERCHA. \n') ;
fprintf('\n 4.2.2) PLANILLA RESUMEN \n') ;
fprintf('\n 4.2.3) DIMENSIONAMIENTO DE LOS CORDONES. \n') ;

fprintf('\n 4.3) COLUMNAS. \n') ;
fprintf('\n 4.3.1) SOLICITACIONES DE LAS COLUMNAS. \n') ;
fprintf('\n 4.3.2) DIMENSIONAMIENTO DE LAS COLUMNAS. \n') ;

fprintf('\n 4.4) FUNDACIONES. \n') ;
fprintf('\n 4.4.1) SOLICITACIONES EN LAS FUNDACIONES. \n') ;
fprintf('\n 4.4.2) DIMENSIONAMIENTO DE LAS FUNDACIONES. \n') ;
 


% PlotStructure(Prob_data,1)
end