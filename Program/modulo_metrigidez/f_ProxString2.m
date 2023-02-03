function string = f_ProxString2(fId)

   %Encuentra la prOxima secciOn (busca el prOximo string ignorando comentarios y los signo : y =).
   string = '';
   while isempty(string)
      string = textscan(fId,'%s',1,'Delimiter',':','MultipleDelimsAsOne',1,'CommentStyle','$');
      string = string{1}{1};
   end

end