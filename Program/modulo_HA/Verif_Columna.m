function [FlexVerif, CorteVerif, kh, ks_res, As_nec, tau, ZonaCorte, TensCorte, TensAsEstr] = Verif_Columna(Mmax, Qmax, LongC, TipoHA, TipoAcero, ac, bc, Diam_Asext,...
                      n_Asext, Recub, Diam_Estr, Sep_Estr, NumRam_Estr)
% Verificación de las armaduras de flexión y de corte de una columna de
% sección rectangular.
% global model  

%% Verificación de armadura de flexión
kh = (ac-Recub)/sqrt(Mmax/bc);
[kh_res,ks_res] = Table_khks(kh,TipoHA);
As_nec = ks_res*Mmax/(ac-Recub);
As_adop = (Diam_Asext/10)^2*pi()/4*n_Asext;

if As_nec > As_adop
    warning('*** La armadura de flexión adoptada NO VERIFICA. Se recomienda redimensionar.');
    FlexVerif = 0;
else
    FlexVerif = 1;
    fprintf('    La armadura de flexión adoptada verifica \n')
end

%% Verificación de la armadura de corte
tau = Qmax*1000/bc/0.85/(ac-Recub);

Tau_vec = Table_Tau(TipoHA);

if 0 < tau && tau <= Tau_vec(2)
    ZonaCorte = 1;
    TensCorte = 0.4*tau;
elseif Tau_vec(2) < tau && tau <= Tau_vec(3)
    ZonaCorte = 2;
    TensCorte = tau*tau/15;
elseif Tau_vec(3) < tau && tau <= Tau_vec(4)
    ZonaCorte = 3;
    TensCorte = tau;
elseif Tau_vec(4) < tau
    warning('*** La sección de columna adoptada NO VERIFICA al Corte. Se recomienda redimensionar.');
end
% Estribos
TensAsEstr = NumRam_Estr*(Diam_Estr/10)^2*pi()/4*(TipoAcero*10/1.75*2/bc/Sep_Estr);
if TensCorte > TensAsEstr
    warning('*** La armadura de corte adoptada NO VERIFICA. Se recomienda redimensionar.');
    CorteVerif = 0;
else
    CorteVerif = 1;
    fprintf('    La armadura de corte adoptada verifica \n')
end

end
