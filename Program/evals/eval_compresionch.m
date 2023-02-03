function eval_compresionch
%
% Test01: Se propone un Perfil y un vector de longitudes de pandeo. Se
% determina el Púlt para cada combinación.

% clear all, close all, clc
% Se genera un vector para las distintas luces a ser analizadas
PerfPred = 'U-80-40-00-1.6';
% 'C-170-70-25-3.-3.'; 'C-160-60-20-2-2';'C-170-70-25-3.-3.';% % 'C-200-70-25-2'; %'C-160-60-20-2.5';
Lx = 50:10:400;% [cm]

for i=1:length(Lx)
    [Pu(i),Efectiv(i)] = Comp_MainProgram(PerfPred,Lx(i));
end

plt_Efect =[(Efectiv<1)', zeros(length(Efectiv),1), (Efectiv==1)'];
figure(1),hold on
plot(Lx,Pu,'-','Color','b'), title(PerfPred), ylabel('Pu[tn]'), xlabel('Sk[cm]')
for i=1:length(Lx)
    plot(Lx(i),Pu(i),'*','Color',plt_Efect(i,:))
end
hold off
end
