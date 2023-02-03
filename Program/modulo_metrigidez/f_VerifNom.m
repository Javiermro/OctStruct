function f_VerifNom(texto1,texto2,mjeError)

   %Se verifica que el texto1 sea igual al texto2, sino se muestra el mensaje de error mjeError.
   if ~strcmpi(texto1,texto2)
      error(['Lectura de datos: ',mjeError])
   end

end