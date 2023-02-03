function [m_Cpn,m_EtiqMatPresNet] = MatrizPresionesNetas_CubAisl(theta,ModeloCerch,epsReg,PosBloqueo)
%

if theta > 30
    error('El reglamento no contempla pendientes de cubiertas superiores a 30 grados');
end

epsBar = [0 1];
if any(ModeloCerch == [5 6]) %ModeloCerch == 5 % Pendiente simple
    warning('va el modelo 6 igual al 5?')
    thetaBar = [0 5 10 15 20 25 30];
    CoefGlobMax = [0.2 0.4 0.5 0.7 0.8 1.0 1.2; % Coef Global Max
%                    0.5 0.8 1.2 1.4 1.7 2.0 2.2; % Coef Local Max A
%                    1.8 2.1 2.4 2.7 2.9 3.1 3.2; % Coef Local Max B
%                    1.1 1.3 1.6 1.8 2.1 2.3 2.4; % Coef Local Max C
        ];
    
    if PosBloqueo
        CoefGlobMinE =  [-0.5 -0.7 -0.9 -1.1 -1.3 -1.6 -1.8; % Coef Global Min-e0
                         -1.2 -1.4 -1.4 -1.5 -1.5 -1.4 -1.4; % Coef Global Min-e1
%                          -0.6 -1.1 -1.5 -1.8 -2.2 -2.6 -3.0; % Coef Local Min-e0 A
%                          -1.3 -1.4 -1.4 -1.5 -1.5 -1.4 -1.4; % Coef Local Min-e1 A
%                          -1.3 -1.7 -2.0 -2.4 -2.8 -3.2 -3.8; % Coef Local Min-e0 B
%                          -1.8 -2.6 -2.6 -2.9 -2.9 -2.5 -2.0; % Coef Local Min-e1 B
%                          -1.4 -1.8 -2.1 -2.5 -2.9 -3.2 -3.6; % Coef Local Min-e0 C
%                          -2.2 -2.6 -2.7 -2.8 -2.7 -2.5 -2.3]; % Coef Local Min-e1 C
                            ];
    else
        CoefGlobMinE =  [-0.5 -0.7 -0.9 -1.1 -1.3 -1.6 -1.8; % Coef Global Min-e0
                         -1.2 -1.2 -1.1 -1.0 -0.9 -0.8 -0.8; % Coef Global Min-e1
%                          -0.6 -1.1 -1.5 -1.8 -2.2 -2.6 -3.0; % Coef Local Min-e0 A
%                          -1.3 -1.2 -1.1 -1.0 -0.9 -0.8 -0.8; % Coef Local Min-e1 A
%                          -1.3 -1.7 -2.0 -2.4 -2.8 -3.2 -3.8; % Coef Local Min-e0 B
%                          -1.8 -2.6 -2.6 -2.9 -2.9 -2.5 -2.0; % Coef Local Min-e1 B
%                          -1.4 -1.8 -2.1 -2.5 -2.9 -3.2 -3.6; % Coef Local Min-e0 C
%                          -2.2 -2.1 -1.8 -1.6 -1.5 -1.4 -1.2]; % Coef Local Min-e1 C
                        ];
    end
elseif any(ModeloCerch == [1,2,3]) % Pendiente doble
    thetaBar = [-20 -15 -10 -5  5 10 15 20 25 30];
    CoefGlobMax = [0.7 0.5 0.4 0.3 0.3 0.4 0.4 0.6 0.7 0.9; % Coef Global Max
%         0.8 0.6 0.6 0.5 0.6 0.7 0.9 1.1 1.2 1.3; % Coef Local Max A
%         1.6 1.5 1.4 1.5 1.8 1.8 1.9 1.9 1.9 1.9; % Coef Local Max B
%         0.6 0.7 0.8 0.8 1.3 1.4 1.4 1.5 1.6 1.6; % Coef Local Max C
%         1.7 1.4 1.1 0.8 0.4 0.4 0.4 0.4 0.5 0.7];  % Coef Local Max D
                ];
    CoefGlobMinE = [-0.7 -0.6 -0.6 -0.5 -0.6 -0.7 -0.8 -0.9 -1.0 -1.0; % Coef Global Min-e0
                    -1.5 -1.5 -1.4 -1.4 -1.2 -1.2 -1.2 -1.2 -1.2 -1.2; % Coef Global Min-e1
%         -0.9 -0.8 -0.8 -0.5 -0.6 -0.7 -0.9 -1.2 -1.4 -1.4; % Coef Local Min-e0 A
%         -1.5 -1.5 -1.4 -1.4 -1.2 -1.2 -1.2 -1.2 -1.2 -1.2; % Coef Local Min-e1 A
%         -1.3 -1.3 -1.3 -1.3 -1.4 -1.5 -1.7 -1.8 -1.9 -1.9; % Coef Local Min-e0 B
%         -2.4 -2.7 -2.5 -2.3 -2.0 -1.8 -1.6 -1.5 -1.4 -1.3; % Coef Local Min-e1 B
%         -1.6 -1.6 -1.5 -1.6 -1.4 -1.4 -1.4 -1.4 -1.4 -1.4; % Coef Local Min-e0 C
%         -2.4 -2.6 -2.5 -2.4 -1.8 -1.6 -1.3 -1.2 -1.1 -1.1; % Coef Local Min-e1 C
%         -0.6 -0.6 -0.6 -0.6 -1.1 -1.4 -1.8 -2.0 -2.0 -2.0; % Coef Local Min-e0 D
%         -1.2 -1.2 -1.2 -1.2 -1.5 -1.6 -1.7 -1.7 -1.6 -1.6]; % Coef Local Min-e0 D
                ];
end

[DatosCol, DatosFil] = meshgrid(thetaBar,epsBar);
% Global - Cpn max
m_Cpn(1) = interp1(thetaBar, CoefGlobMax(1,:), theta);
m_EtiqMatPresNet{1,1} = {'Global - Max'}; n_AcumEtiq = 2;
% Global - Cpn min
m_Cpn(2) = interp2(DatosCol, DatosFil, CoefGlobMinE(1:2,:), theta, epsReg);
m_EtiqMatPresNet{1,n_AcumEtiq} = {'Global - Min'}; n_AcumEtiq = n_AcumEtiq + 1;
% % Local A - Cpn max
% m_Cpn(3) = interp1(thetaBar, CoefGlobMax(2,:), theta);
% m_EtiqMatPresNet{1,n_AcumEtiq} = {'Local A - Max'}; n_AcumEtiq = n_AcumEtiq + 1;
% % Local A - Cpn min
% m_Cpn(4) = interp2(DatosCol, DatosFil, CoefGlobMinE(3:4,:), theta, epsReg);
% m_EtiqMatPresNet{1,n_AcumEtiq} = {'Local A - Min'}; n_AcumEtiq = n_AcumEtiq + 1;
% % Local B - Cpn max
% m_Cpn(5) = interp1(thetaBar, CoefGlobMax(3,:), theta);
% m_EtiqMatPresNet{1,n_AcumEtiq} = {'Local B - Max'}; n_AcumEtiq = n_AcumEtiq + 1;
% % Local B - Cpn min
% m_Cpn(6) = interp2(DatosCol, DatosFil, CoefGlobMinE(5:6,:), theta, epsReg);
% m_EtiqMatPresNet{1,n_AcumEtiq} = {'Local B - Min'}; n_AcumEtiq = n_AcumEtiq + 1;
% % Local C - Cpn max
% m_Cpn(7) = interp1(thetaBar, CoefGlobMax(4,:), theta);
% m_EtiqMatPresNet{1,n_AcumEtiq} = {'Local C - Max'}; n_AcumEtiq = n_AcumEtiq + 1;
% % Local C - Cpn min
% m_Cpn(8) = interp2(DatosCol, DatosFil, CoefGlobMinE(7:8,:), theta, epsReg);
% m_EtiqMatPresNet{1,n_AcumEtiq} = {'Local C - Min'}; n_AcumEtiq = n_AcumEtiq + 1;
% if any(ModeloCerch == [1,2,3]) % Pendiente doble
%     % Local C - Cpn max
%     m_Cpn(9) = interp1(thetaBar, CoefGlobMax(5,:), theta);
%     m_EtiqMatPresNet{1,n_AcumEtiq} = {'Local D - Max'}; n_AcumEtiq = n_AcumEtiq + 1;
%     % Local D - Cpn min
%     m_Cpn(10) = interp2(DatosCol, DatosFil, CoefGlobMinE(9:10,:), theta, epsReg);
%     m_EtiqMatPresNet{1,n_AcumEtiq} = {'Local D - Min'}; n_AcumEtiq = n_AcumEtiq + 1;
% else
%     m_Cpn(9) = 0;
%     m_EtiqMatPresNet{1,n_AcumEtiq} = {' '}; n_AcumEtiq = n_AcumEtiq + 1;
%     m_Cpn(10) = 0;
%     m_EtiqMatPresNet{1,n_AcumEtiq} = {' '}; n_AcumEtiq = n_AcumEtiq + 1;
% end
end