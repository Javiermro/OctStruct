function [KGcon,FGcon,ifixe] = CondBorde(KGlob,FGlob,fixed) 
global model nelem nnodo npoin nfixe ndofs nload

ifixe=zeros(ndofs*npoin,1);  
fix = sort(reshape((fixed(:)-1)*ndofs+[1:ndofs],size(fixed,2)*3,1) ) ; 
ifixe(fix) = 1 ;

%%
% warning('Solo para 15xGalva_entrepiso.dat')
% ifixe([(fixed(1)-1)*3+[1 3]  (fixed(2)-1)*3+3  (fixed(3)-1)*3+[1 3]]')=0 ;
%%

nfix = find(ifixe(:,1)==0) ;

FGcon = FGlob(nfix) ;
KGcon = KGlob(nfix,nfix) ;
