function eval_flexionch
%
% Test01: Se propone un Perfil y un vector de longitudes de pandeo. Se
% determina el Púlt para cada combinación.

clear all, close all, clc
addpath(genpath('./../'))
PerfPred = 'C-200-80-25-2.5';'U-80-40-00-1.6-1.6';
% Se genera un vector para las distintas luces a ser analizadas
%  'C-160-60-20-2-2';'C-170-70-25-3.-3.';% % 'C-200-70-25-2'; %'C-160-60-20-2.5';
Lx = 600;100:10:600;%[290 300];%

for i=1:length(Lx)
     [Pn,Efectiv(i)] = Flex_MainProgram(PerfPred,Lx(i));
    %[Md_1,Md_R0,Vd,Pd_ap,Pd_tr,Efectiv(i)] = Flex_MainProgram(PerfPred,Lx(i));
end

plt_Efect =[(Efectiv<1)', zeros(length(Efectiv),1), (Efectiv==1)'];
figure(1),hold on
plot(Lx,Pn,'-','Color','b'), title(PerfPred), ylabel('Pu[tn]'), xlabel('Sk[cm]')
for i=1:length(Lx)
    plot(Lx(i),Pn(i),'*','Color',plt_Efect(i,:))
end
hold off
end