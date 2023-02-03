function Tau_vec = Table_Tau(TipoHA)


%         T011  To12  To2  To3  Br BCN
Tau_tab = [2.7  4.0   9.0 15.0  70 110;
           3.5  5.0  12.0 20.0 105 130;
           4.5  6.5  15.0 25.0 140 170;
           5.0  7.5  18.0 30.0 175 210;
           6.0 10.0  24.0 40.0 230 300;
           7.0 11.0  27.0 45.0 270 380;
           8.0 12.5  30.0 50.0 300 470];
Tau_vec = Tau_tab(Tau_tab(:,end)==TipoHA,1:end-2);


end
