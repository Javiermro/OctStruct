function [KGlob,FGlob] = EnsamblajeK(conec,Elem_data,FGlob)
global nelem nnodo ndime ndofs npoin nfixe nload

KGlob = zeros(ndofs*npoin,ndofs*npoin);

for ielem=1:nelem
    kelem = Elem_data(ielem).KGele ;
    for inodo=1:nnodo
        nodoi=conec(ielem,inodo);
        for igl=1:ndofs
            filag=(nodoi-1)*ndofs+igl;
            filae=(inodo-1)*ndofs+igl;
            for jnodo=1:nnodo
                nodoj=conec(ielem,jnodo);
                for jgl=1:ndofs
                    colug=(nodoj-1)*ndofs+jgl;
                    colue=(jnodo-1)*ndofs+jgl;
                    KGlob(filag,colug)=KGlob(filag,colug)+kelem(filae,colue);
                end
            end
            FGlob(filag) = FGlob(filag) - Elem_data(ielem).AGbar(filae) ;
        end
    end
end

return
