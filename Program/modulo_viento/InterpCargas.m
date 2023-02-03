function CargaPuntualNod = InterpCargas(CotaPtos,AreaInfl,CotaCargas,CargasDistr)
%
Cont_CotaCargasAux = 1;
Cont_CotaCargasAuxMax = length(CargasDistr);
SepPtos = CotaPtos(2)-CotaPtos(1);
for iPunt = 1:length(CotaPtos)-1
    if CotaPtos(iPunt)+SepPtos/2 <= CotaCargas(Cont_CotaCargasAux)
        CargaPuntualNod(iPunt) = CargasDistr(Cont_CotaCargasAux)*AreaInfl(iPunt);
    elseif CotaPtos(iPunt)+SepPtos/2 <= CotaCargas(Cont_CotaCargasAux+1) % Caso con un solo salto en el tramo
        Cont_CotaCargasAux = Cont_CotaCargasAux + 1;
        Integ01 = CargasDistr(Cont_CotaCargasAux-1) *...
            (CotaCargas(Cont_CotaCargasAux-1) - (CotaPtos(iPunt)-SepPtos/2));
        Integ02 = CargasDistr(Cont_CotaCargasAux) *...
            (SepPtos-(CotaCargas(Cont_CotaCargasAux-1) - (CotaPtos(iPunt)-SepPtos/2)));
        CargaPuntualNod(iPunt) = Integ01 + Integ02;
    elseif CotaPtos(iPunt)+SepPtos/2 > CotaCargas(Cont_CotaCargasAux+1) % Caso con dos saltos en el tramo
        Cont_CotaCargasAux = Cont_CotaCargasAux + 2;
        Integ01 = CargasDistr(Cont_CotaCargasAux-2) *...
            (CotaCargas(Cont_CotaCargasAux-2) - (CotaPtos(iPunt)-SepPtos/2));
        Integ02 = CargasDistr(Cont_CotaCargasAux-1) *...
            ((CotaCargas(Cont_CotaCargasAux-1) - CotaCargas(Cont_CotaCargasAux-2)));
        Integ03 = CargasDistr(Cont_CotaCargasAux) *...
            ((CotaPtos(iPunt)+SepPtos/2) - CotaCargas(Cont_CotaCargasAux-1));
        CargaPuntualNod(iPunt) = Integ01 + Integ02 + Integ03 ;
    end
end

CargaPuntualNod(length(CotaPtos)) = CargasDistr(end)*AreaInfl(end);

end
