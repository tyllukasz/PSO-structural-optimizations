//Test - zaokraglanie wartosci do elemntu z wektora dopuszczalnych wartosci

//kryterium - zaokraglenie bedzie nastepowalo do tego elementu, dla ktorego roznica miedzy obliczonym x a elementem jest najmniejsza
clear
x=144;

dop_x=[1,2,3,4,5,6,7,8,9,11,15,22,34,45,57,71,92,113,150,220];
dim_dop_x=size(dop_x);
dim_dop_x=dim_dop_x(1,2);

    for i=1:dim_dop_x
        
        delta(i)=abs(x-dop_x(i));
        
    end
    
    [xmin imin]=min(delta);
    
    x=dop_x(imin);
