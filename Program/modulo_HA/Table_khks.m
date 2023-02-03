function [kh_res,ks_res] = Table_khks(kh,TipoHA)

kh_tab = [20 11.8 8.8 7.3 6.5 6.0 5.6 5.3 5.1 5.0 4.9 4.7 300;
          23.0 13.5 10.1 8.4 7.4 6.9 6.4 6.1 5.9 5.7 5.5 5.4 210];
ks_tab = [0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54];
kh_vec = kh_tab(kh_tab(:,end)==TipoHA,1:end-1);

if isempty(kh_vec)
    warning('*** El tipo de Hormigón adoptado no se encuentra en la base de datos. Adoptar BCN = 210 ó 300; ó completar la tabla "kh_tab".')
    fprintf('    Se procede al cálculo con Tipo de Hormigón BCN = 210')
    TipoHA = 210;
    kh_vec = kh_tab(kh_tab(:,end)==TipoHA,1:end-1);
end

if kh > max(kh_vec) 
    kh = max(kh_vec);
elseif kh < min(kh_vec)
    error('*** Valores de Kh fuera de rango de tabla. Redimensionar sección de columna.')
end

col_kh = interp1(kh_vec,1:length(kh_vec),kh,'nearest');

if kh < kh_vec(col_kh)
    kh_res = kh_vec(col_kh+1);
    ks_res = ks_tab(col_kh+1);
else
    kh_res = kh_vec(col_kh+1);
    ks_res = ks_tab(col_kh);
end

end
