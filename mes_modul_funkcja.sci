// Metoda elementow skonczonych - (elementy pretowe)


function [fcelu, U, M, sigma, F, FX, FY, M_max, g1, g2]= mes_module(A,nw,ne,nc,mp,E,ro,FP,wb,sigmadop,kara,kara2,u_dop)

    //Obliczenie dlugosci oraz katow nachylenia poszczegolnych elementow w globalnym ukladzie wspolrzednych

    L=zeros([1:ne]); //wektor dlugosci elementow [L1, L2, ... , Lne]
    alfa=zeros([1:ne]); //wektor katow nachylenia elementow w globalnym ukladzie wspolrzednych [rad]
    
    for i=1:ne,            
            //dlugosc elementu
                //wspolrzedne wektora i-tego elementu [x,y]
                wspx=nc(mp(i,2),1)-nc(mp(i,1),1); //wspolrzedna x
                wspy=nc(mp(i,2),2)-nc(mp(i,1),2); //wspolrzedna y
            L(i)=sqrt((wspx^2)+(wspy^2)); //dlugosc i-tego elementu
            
            //kat nachylenia
            if wspy>=0 then
                alfa(i)=acos(wspx/L(i));
            else
                alfa(i)=2*%pi-acos(wspx/L(i));
            end
    end
    
    
    //macierze sztywnoosci elementu w globalnym ukladzie wspolrzednych
    
    KG=zeros(2*nw,2*nw);
    
    for i=1:ne,
        kat=alfa(i);
        
        K=[cos(kat)^2, cos(kat)*sin(kat), -(cos(kat)^2), -(cos(kat)*sin(kat));
        cos(kat)*sin(kat), sin(kat)^2, -(cos(kat)*sin(kat)), -(sin(kat)^2);
        -(cos(kat)^2), -(cos(kat)*sin(kat)), cos(kat)^2, cos(kat)*sin(kat);
        -(cos(kat)*sin(kat)), -(sin(kat)^2), cos(kat)*sin(kat), sin(kat)^2];
        
        KE=(E*A(i)/L(i))*K;
        
        //Zapisanie wartosci w globalnej macierzy sztywnosci ukladu
        
        d1=(mp(i,1)-1)*2; //przyrost dla wspolrzednych 1. wezla
        d2=(mp(i,2)-2)*2; //przyrost dla wspolrzednych 2. wezla
        
        KP=zeros(2*nw,2*nw); //pomocnicza macierz sztywnosci
        
        KP(1+d1,1+d1)=KE(1,1);
        KP(1+d1,2+d1)=KE(1,2);
        KP(1+d1,3+d2)=KE(1,3);
        KP(1+d1,4+d2)=KE(1,4);
        
        KP(2+d1,1+d1)=KE(2,1);
        KP(2+d1,2+d1)=KE(2,2);
        KP(2+d1,3+d2)=KE(2,3);
        KP(2+d1,4+d2)=KE(2,4);
        
        KP(3+d2,1+d1)=KE(3,1);
        KP(3+d2,2+d1)=KE(3,2);
        KP(3+d2,3+d2)=KE(3,3);
        KP(3+d2,4+d2)=KE(3,4);
        
        KP(4+d2,1+d1)=KE(4,1);
        KP(4+d2,2+d1)=KE(4,2);
        KP(4+d2,3+d2)=KE(4,3);
        KP(4+d2,4+d2)=KE(4,4);
        
        
        KG=KG+KP; //globalna macierz sztywnosci
        

    end
    
    

        U=zeros([1:2*nw])'; //wektor kolumnowy przemieszczen w poszczegolnych wezlach [u1x, u1y, u2x, u2y ...]'
        
        F=zeros([1:2*nw])'; //wektor kolumnowy sił w poszczególnych wezlach 
            
        [lw, lc]=size(FP); //lw - liczba wierszy, lc - liczba kolumn
        
        //wprowadzenie wartosci sil do wektora F
        for i=1:lw,
            F(FP(i,2))=FP(i,1);
        end
        
        
        //zdefiniowanie warunkow brzegowych
        [lw, lc]=size(wb); //lw - liczba wierszy, lc - liczba kolumn
        
        KP=KG; //pomocnicza maciez KP, zeby nie stracic danych przy usuwaniu wierszy z macierzy KG
        FP=F; //pomocniczy wektor FP, zeby nie stracic danych przy usuwaniu elementow z wektora F
        poz=(1:2*nw); //pomocniczy wektor - pozycje sil/przemieszczen - zeby bylo wiadomo w ktorych wezlach wyznaczono przemieszczenia (w pelnym ukladzie rownan)
        
        for i=1:lc,     //kasowanie wierszy i kolumn tam, gdzie przemieszczenia sa rowne "0"
            
            KP(wb(i),:)=[];     //usuwanie kolumn
            KP(:,wb(i))=[];     //usuwanie wierszy
            FP(wb(i),:)=[];
            poz(:,wb(i))=[];
            
        end
    
    //Rozwiazanie ukladu rownan
        
        UP=linsolve(KP,-FP);
    
        [lw, lc]=size(UP); //lw - liczba wierszy, lc - liczba kolumn
        
        for i=1:lw,
            U(poz(i),1)=UP(i);  //aktualizacja wektora przemieszczen
        end
    
    //Reakcje
        KP=KG; //pomocnicza maciez KP, zeby nie stracic danych przy usuwaniu wierszy z macierzy KG
        [lw, lc]=size(wb); //lw - liczba wierszy, lc - liczba kolumn
        
        for i=1:lc,     //kasowanie  kolumn tam, gdzie przemieszczenia sa rowne "0"
            
            KP(:,wb(i))=[];     //usuwanie kolumn
            
        end
        
        poz=gsort(poz); //sortowanie pozycji malejaco (zeby poprawnie dzialalo usuwanie wierszy)
        [lw, lc]=size(poz); //lw - liczba wierszy, lc - liczba kolumn
    
         for i=1:lc,        //kasowanie wierszy (wszystkie poza tymi, gdzie sa reakcje)
             
             KP(poz(i),:)=[];
         
         end
    
        //wektor reakcji
        R=KP*UP;
    
        //wstawienie obliczonych wartosci reakcji do wektora sil "F"
    
        wb=gsort(wb,'g','i'); //sortowanie pozycji rosnaco (zeby poprawnie wstawic wartosci reakcji do wektora F)
        [lw, lc]=size(wb); //lw - liczba wierszy, lc - liczba kolumn
            
            for i=1:lc,
                F(wb(i),1)=R(i);        //aktualizacja wektora sil (wartosci reakcji)
            end
        
        //Suma rzutow sil na osie OX i OY - sprawdzenie
            //Sily w kierunku X - nr pozycji nieparzysty w wektorze sil F
            //Sily w kierunku Y - nr pozycji parzysty w wektorze sil F
            [lw, lc]=size(U); //lw - liczba wierszy, lc - liczba kolumn
            
            FX=0;   //Suma rzutow sil na os OX
            FY=0;   //Suma rzutow sil na os OY
            
            for i=1:lw,
                
                if modulo(i,2)==0 then
                    FY=FY+F(i);
                else
                    FX=FX+F(i);
                end
                
            end
            
        
        //wyswietlenie obliczonych wartosci      //---dezaktywowane
        //disp("Maciez sztywnosci K: ")
        //disp(KG)
        //disp("***")
        
        //disp("Wektor przemieszczen U: ")
        //disp(U)
        //disp("***")
        
        //disp("Wektor sil F: ")
        //disp(F)
        //disp("***")
        
        //disp("Suma rzutow sil na os OX: ")
        //disp(FX)
        //disp("***")
        
        //disp("Suma rzutow sil na os OY: ")
        //disp(FY)
        //disp("***")
                


    //Naprezenia w poszczegolnych elementach
    
    for i=1:ne,
         US=[U(2*(mp(i,1))-1);      //wektor przemieszczen w wezlach poszczegolnego elementu
             U(2*(mp(i,1)));
             U(2*(mp(i,2))-1);
             U(2*(mp(i,2)))]
             
         sigma_e=(E/L(i))*[-cos(alfa(i)), -sin(alfa(i)), cos(alfa(i)), sin(alfa(i))]*US; //naprezenie w i-tym elemencie
         
         sigma(i)=sigma_e; //wektor zawierajacy wartosci naprezen w elementach
         
    end
    
    
        //disp("Naprezenia: ") //---dezaktywowane
        //disp(sigma)
        //disp("***")
    
    
    //Masa konstrukcji
    
    M=0; //masa calej konstrukcji
    for i=1:ne,
        me=L(i)*A(i)*ro;    //masa i-tego elementu
        M=M+me;
    end
    
        //disp("Masa konstrukcji: ") //---dezaktywowane
        //disp(M)
        //disp("***")
    
//-------------------------------------------------------------
//-------------funkcja celu - minimalna masa
//-------------------------------------------------------------

//funkcja kary - przekroczenie naprezen dopuszczalnych
        g1=0;    //funkcja kary
        
        for i=1:ne,
            ge=max([0,(abs(sigma(i))-sigmadop)/sigmadop]); //funkcja kary dla i-tego elementu
            //ge=max([0,(abs(sigma(i))-sigmadop)]);
            g1=g1+ge;
        end


//funkcja kary - przekroczenie przemieszczen dopuszczalnych
        g2=0;    //funkcja kary
        
        for i=1:2*nw,
            //dU=sqrt((U(2*i-1))^2+(U(2*i))^2)
            //ge=max([0,(abs(dU)-u_dop)/u_dop]);
            ge=max([0,(abs(U(i))-u_dop)/u_dop]); //funkcja kary dla i-tego elementu
            //ge=max([0,(abs(U(i))-u_dop)]);

            g2=g2+ge;
        end
        
//maksymalna mozliwa masa konstrukcji
        M_max=0; //maksymalna masa
        
        for i=1:ne,
            M_max_p=L(i)*Amax*ro;
            M_max=M_max+M_max_p; //maksymalna masa i-tego elementu
        end
        
//funkcja celu

        fcelu=(M/M_max)+(kara*g1)+(kara2*g2);
        //fcelu=(M)+(kara*g1)+(kara2*g2);
        
    endfunction
