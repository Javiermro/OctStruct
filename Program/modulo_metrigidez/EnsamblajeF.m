function FGlob = EnsamblajeF(loads)
global ndofs npoin nload

FGlob = zeros(npoin*ndofs,1) ; 

npos = 0 ;
for ifix=1:nload
    for inodo=1:npoin
        npos=(inodo-1)*ndofs+1;
        if inodo==loads(ifix,1)    
            FGlob(npos,1)=loads(ifix,2) ;
            npos=npos+1;
            FGlob(npos,1)=loads(ifix,3) ;
            npos=npos+1;
            FGlob(npos,1)=loads(ifix,4) ;
        end     
    end
end


