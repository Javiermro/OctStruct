function F = f_FindFix(tipo)
% Variables: [ A  Bcs  Bci  Bdi  Ccs  Cci  Cdi  Tcs  Tci  Tdi  Tda]
 
Perfil=textscan(tipo,'%s','delimiter','-') ; 

F = [] ;
if Perfil{1}{2}=='*' 
    F = [F 999] ; 
elseif Perfil{1}{2}=='='
    F = [F 111] ; 
else  
    F = [F str2num(Perfil{1}{2})] ; 
end

if Perfil{1}{3}=='*' 
    F = [F 999] ; 
elseif Perfil{1}{3}=='='
    F = [F 111] ; 
else       
    F = [F str2num(Perfil{1}{3})] ; 
end

% rigidizador
if Perfil{1}{1}=='U'
    F = [F 0] ;
else
    if Perfil{1}{4}=='*' 
        F = [F 999] ; 
    elseif Perfil{1}{4}=='='
        F = [F 111] ; 
    else 
        F = [F str2num(Perfil{1}{4})] ; 
    end
end
    
if Perfil{1}{5}=='*' 
    F = [F 999] ; 
elseif Perfil{1}{5}=='='
    F = [F 111] ; 
else   
    F = [F str2num(Perfil{1}{5})] ; 
end
