function ImpresionResultados(Edif,PrintData)
% Se imprimen los resultados de las presiones de viento de forma ordenada,
% por pantalla o por PDF. El orden se adopta igual al Zonda para realizar
% una comparación expeditiva.
switch Edif
    case {'PCerrado','Cerrado'}
        m_MatPresNet_vpc = PrintData.m_MatPresNet_vpc;
        m_MatPresNet_vnc = PrintData.m_MatPresNet_vnc;
        m_EtiqMatPresNet_vpc = PrintData.m_EtiqMatPresNet_vpc;
        m_EtiqMatPresNet_vnc = PrintData.m_EtiqMatPresNet_vnc;
        p_vpc = PrintData.p_vpc;
        p_vnc = PrintData.p_vnc;
        %% Presiones SPRFV
        % VIENTO PARALELO A LA CUMBRERA
        fprintf(['VIENTO PARALELO A LA CUMBRERA \n'])
        fprintf([' h/m  Kh   Kzt     Cp    qh/qz       pn       GCpi\n'])
        for i = 1:length(m_EtiqMatPresNet_vpc)
            fprintf('%3.2f   X     X   %3.2f   %3.2f   %3.2f    (%3.2f) ',[m_MatPresNet_vpc(i,1) m_MatPresNet_vpc(i,4) m_MatPresNet_vpc(i,2) p_vpc(i,1)  m_MatPresNet_vpc(i,6)])
            fprintf(['     ' cell2mat(m_EtiqMatPresNet_vpc{i}) ' \n'])
        end
        % VIENTO NORMAL A LA CUMBRERA
        fprintf([' \n'])
        fprintf(['VIENTO NORMAL A LA CUMBRERA \n'])
        fprintf([' h/m  Kh   Kzt     Cp    qh/qz       pn       GCpi\n'])
        for i = 1:length(m_EtiqMatPresNet_vnc)
            fprintf('%3.2f   X     X   %3.2f   %3.2f   %3.2f    (%3.2f) ',[m_MatPresNet_vnc(i,1) m_MatPresNet_vnc(i,4) m_MatPresNet_vnc(i,2) p_vnc(i,1)  m_MatPresNet_vnc(i,6)])
            fprintf(['     ' cell2mat(m_EtiqMatPresNet_vnc{i}) ' \n'])
        end
    case 'Aislado'
        p_v = PrintData.p_v;
        m_EtiqMatPresNet = PrintData.m_EtiqMatPresNet;
        fprintf([' \n'])
        fprintf(['PRESIONES GLOBALES\n'])
        fprintf(['Zona Kh   Kztn     Cpn    qh     p \n'])
        for i = 1:length(m_EtiqMatPresNet)
            fprintf([cell2mat(m_EtiqMatPresNet{i})  '   X    X    X    X   ' num2str(p_v(i)) '\n'])
        end
end

end