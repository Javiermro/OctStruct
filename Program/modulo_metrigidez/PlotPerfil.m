function PlotPerfil(Perfil)

if Perfil=='U'
    PerfImg = imread('./Informe/perfil-u.png');
elseif Perfil=='G'
    PerfImg = imread('./Informe/perfil-u.png');
end

axis off, image(PerfImg)

end