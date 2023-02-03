function [Prob_sect,flag] = Read_section(path_file,Predim,Fix,file)

flag = 0 ;

%% Read CS sections
file_open = fullfile(path_file,file);
fid = fopen(file_open,'r');
 
matrix = textscan(fid,'%s %f %f %f %f','delimiter','-'); 

tipo = Predim(1) ;

if tipo=='*'
    ics = [1:size(matrix{2},1)]' ;
else
    ics = find(cell2mat(matrix{1})==tipo) ; 
end 
if Fix(1)~=999 ; ics=ics(find(matrix{2}(ics,:)==Fix(1))) ;end
if Fix(2)~=999 ; ics=ics(find(matrix{3}(ics,:)==Fix(2))) ;end
if Fix(3)~=999 ; ics=ics(find(matrix{4}(ics,:)==Fix(3))) ;end
if Fix(4)~=999 ; ics=ics(find(matrix{5}(ics,:)==Fix(4))) ;end 

if(find(Fix(1:4)==111)) ; error(['ERROR: Datos de PREDIMENISIONAMIENTO, CS']) ; end 

if isempty(ics)  
    flag = 1;    
    Prob_sect{1} = Predim; %[] ;
end

for i=1:size(ics,1)
    Prob_sect{i}=[matrix{1}{ics(i)} ...
        '-' num2str(matrix{2}(ics(i),1)) ...
        '-' num2str(matrix{3}(ics(i),1)) ...
        '-' num2str(matrix{4}(ics(i),1)) ...
        '-' num2str(matrix{5}(ics(i),1)) ];
end

fclose(fid) ;
