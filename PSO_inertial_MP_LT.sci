//Algorytm PSO z waga inercji

    //mode(-1) //usuniecie echa
    
//jawne deklaracje wektorow i macierzy

clear
stacksize('max')

//wczytanie parametrow konstrukcji - potrzebne modulowi MES do obliczenia funkcji celu
//exec('mes_parametry_trojkat.sce');
//exec('mes_parametry_platforma.sce');
exec('mes_parametry_kratownica_mp.sce');

//wczytanie modulu MES
exec('mes_modul_funkcja.sci');


//-------------------------------
//Okreslenie trybu optymalizacji
//---do wyboru
//------zmienne ciagle (zmienne przyjmuja wartosc miedzy zadeklarowanym minimum i maksimum)
//------zmienne dyskretne (zmienne przyjmuja tylko wybrane wartosci zadeklarowane w wektorze - katalogu zmiennych)
    tryb=0; //zmienne ciagle
    //tryb=1; //zmienne dyskretne

//Rysunek konstrukcji przed obciazeniem
clf();
   
        for i=1:ne, 
            
            x=[nc(mp(i,1),1),nc(mp(i,2),1)];
            y=[nc(mp(i,1),2),nc(mp(i,2),2)];
            plot2d(x,y,style=3,axesflag=0, frameflag=1, rect=[-200,-200,max(nc)+200,max(nc)+200]);
            plot2d(x,y,style=-4, frameflag=1, rect=[-200,-200,max(nc)+200,max(nc)+200]);
            xtitle("Schemat konstrukcji:")
       
        end

 

lines(0)  // disables vertical paging

//parametry PSO
    wmax=0.9; // maksymalna (poczatkowa) wartość współczynnika wagi inercji
    wmin=0.4; // minimalna (koncowa) wartość współczynnika wagi inercji
    itmax=50; // maksymalna liczba iteracji
    c1=2; // ustalony mnoznik wagowy (przy czlonie z najlepszym dotychczas znalezionym polozeniem czastki)
    c2=2.1; // ustalony mnoznik wagowy (przy czlonie z najlepszym dotychczas znalezionym polozeniem lidera roju)
    N=50; // liczba czastek
    D=ne; // wymiar problemu D zdefinowany ponizej (musi byc zgodny z definicja optymalizowanej funkcji)
    x_sup=ones([1:D])
    x_inf=ones([1:D])
    x_sup=Amin*x_sup'; // minimalna wartosc polozenia (uzywana do generowania poczatkowej populacji czastek)
    x_inf=Amax*x_inf'; // maksymalna wartosc polozenia (uzywana do generowania poczatkowej populacji czastek)
    v_max=ones([1:D])
    v_max=15*v_max'; // maksymalna wartosc predkosci (uzywana do generowania poczatkowych predkosci czastek)
    v_min=-1*v_max; // minimalna wartosc predkosci (uzywana do generowania poczatkowych predkosci czastek)



//deklaracje jawne zmiennych
    W=zeros([1:itmax])  // wektor wspolczynnikow wag
    x0=zeros(N,D)   // pierwszy obliczony wektor pozycji
    v0=zeros(N,D)   // pierwszy obliczony wektor predkosci
    F0=zeros([1:N])   // pierwsze obliczone wartosci funkcji celu
    x1=zeros(N,D,itmax)   //  obliczone wektory pozycji (ostatni wymiar to nr iteracji)
    v1=zeros(N,D,itmax)   // obliczone wektory predkosci (ostatni wymiar to nr iteracji)
    F1=zeros(N,itmax)   // obliczone wartosci funkcji celu (ostatni wymiar to nr iteracji)

    gbest1=zeros(D,itmax)  // pomocnicza do wartosci x
    G1=zeros(N,D,itmax)   // najlepsze globalne (wartosci x)
    Fbest1=zeros([1:itmax])   // najlepsze globalne (wartosci funckji)
    pbest1=zeros(N,D,itmax)   // najlepsze rozwiazanie pojedynczego osobnika (wartosci x)
    Fb1=zeros([1:itmax])   // najlepsze rozwiazanie w danej iteracji (wartosc funkcji)




//  obliczenie wartosci wektora wspolczynnikow wagi inercji dla wszystkich iteracji (shi & eberhart 1998)

    for j=1:itmax
        W(j)=wmax-((wmax-wmin)/itmax)*j;
    end


//obliczanie polozenia i predkosci wszystkich czastek
    //losowe wygenerowanie pozycji i predkosci wewnatrz zadanych granic
    // aktualny numer iteracji
        j=1;

    for i=1:D
        
        if tryb==0 then //dla zmiennych ciaglych
            
            //x0(1:N,i) =x_inf(i) +rand(N,1) * ( x_sup(i) - x_inf(i) ); // pierwszy wektor pozycji
            x1(1:N,i,j) =x_inf(i) +rand(N,1) * ( x_sup(i) - x_inf(i) ); // pierwszy wektor pozycji
            //v0(1:N,i)=v_min(i)+(v_max(i)-v_min(i))*rand(N,1); // pierwszy wektor predkosci
            v1(1:N,i,j)=v_min(i)+(v_max(i)-v_min(i))*rand(N,1); // pierwszy wektor predkosci
            
        else //dla zmiennych dyskretnych
            
            v0(1:N,i)=v_min(i)+(v_max(i)-v_min(i))*rand(N,1); // pierwszy wektor predkosci
            v1(1:N,i,j)=v_min(i)+(v_max(i)-v_min(i))*rand(N,1); // pierwszy wektor predkosci
            
            dimA=size(katalogA);
            dimA=dimA(1,2); //zapisanie wartosci o ilosci dostepnych przekrojow znajdujacysch sie w wektorze katalogA

            k=rand()*dimA;  //losowy wybor przekroju
            k=round(k);     //losowy wybor przekroju - zaokraglenie do liczny calkowitej (pozycja z katalogA)
                    
            //x0(1:N,i)=katalogA(1,k); // pierwszy wektor pozycji
            x1(1:N,i,j)=katalogA(1,k); // pierwszy wektor pozycji //zapisanie przekroju elementu w wektorze pol przekroju A z katalogu

        end
        
    end



//pierwsze obliczenie wartosci funkcji celu

    for i=1:N
        y1=x1(i,1:D,j)
        [fcelu, U, M, sigma, F, FX, FY]=mes_module(y1,nw,ne,nc,mp,E,ro,FP,wb,sigmadop,kara,kara2,u_dop);
        F0(i)=fcelu //F i-tej czastki
        F1(i,j)=fcelu //F i-tej czastki w j-tej iteracji
    end


//poszukiwanie minimum wsrod czastek roju

    [fmin, pos]=min(F1(1:N,j)) ; //  pos - pozycja, gdzie znaleziono minimum


//pierwsze minimum jest tez globalnym minimum ponieważ jest to pierwsza iteracja
    gbest1(1:D,j)=x1(pos,1:D,j)';  // moja wersja *
    
    for i=1:N
        G1(i,1:D,j)=gbest1(1:D,j); // macierz z wektorami rozwiazan (x)
    end


//pierwsze minimum jest najlepszym wynikiem poniewaz jest to pierwsza iteracja
    Fbest1(j)= fmin;    // najlepsze rozwiazanie globalne
    Fb1(j)=fmin; // najlepsze w iteracji nr j


//kazde rozwiazanie - pozycja czastki jest jej najlepszym rozwiazaniem poniewaz jest to pierwsza iteracja
    
    for i=1:N
        pbest1(i,1:D,j)=x1(i,1:D,j)   // personal best dla pierwszej iteracji (tj pierwsze x)
    end


//predkosci i polozenie dla nastepnych iteracji

        if tryb==0 then //dla zmiennych ciaglych
            v1(1:N,1:D,j+1)=W(j)*v1(1:N,1:D,j)+c1*rand()*(pbest1(1:N,1:D,j)-x1(1:N,1:D,j))+c2*rand()*(G1(1:N,1:D,j)-x1(1:N,1:D,j));   //nowa predkosc
            x1(1:N,1:D,j+1)=x1(1:N,1:D,j)+v1(1:N,1:D,j+1); //   nowe polozenie
            
            for q=1:N //uwzglednienie zdefiniowanego maksymalnego i minimalnego przekroju
                for r=1:D
                    if x1(q,r,j+1)>Amax then
                        x1(q,r,j+1)=Amax; //jesli obliczone x1 wieksze od Amax, to staje sie Amax
                
                    elseif x1(q,r,j+1)<Amin then
                        x1(q,r,j+1)=Amin; //jesli obliczone x1 mniejsze od Amin, to staje sie Amin
                
                    else //jesli nie spelnione poprzednie warunki to nic nie robimy
                    end
                end
            end
            
        else //dla zmiennych dyskretnych
       
            v1(1:N,1:D,j+1)=W(j)*v1(1:N,1:D,j)+c1*rand()*(pbest1(1:N,1:D,j)-x1(1:N,1:D,j))+c2*rand()*(G1(1:N,1:D,j)-x1(1:N,1:D,j));   //nowa predkosc
            x1(1:N,1:D,j+1)=x1(1:N,1:D,j)+v1(1:N,1:D,j+1); //   nowe polozenie
        
           dimA=size(katalogA);
           dimA=dimA(1,2);

            for q=1:N //dobor wartosci z katalogu
                for r=1:D
                              for t=1:dimA
                                  delta(t)=abs(x1(q,r,j+1)-katalogA(t));    //obliczenie roznic miedzy kazdym z elementow a aktualnym x
                              end
                    
                              [xmin imin]=min(delta); //znalezienie min wartosci i jej pozycji imin
                    
                    x1(q,r,j+1)=katalogA(imin); //podstawienie wartosci z katalogu
                    
                 end
             end
            end
        




//---------------------------------------------------
//Rozpoczecie petli optymalizacyjnej
//---------------------------------------------------
    while (j<itmax-1)
        j=j+1

        //Obliczenie funkcji celu
            for i=1:N
                y1=x1(i,1:D,j);
                [fcelu, U, M, sigma, F, FX, FY]=mes_module(y1,nw,ne,nc,mp,E,ro,FP,wb,sigmadop,kara,kara2,u_dop);
                F1(i,j)=fcelu //F i-tej czastki w j-tej iteracji
            end

        //Poszukiwanie minimum wsrod roju czastek
            [fmin, pos]=min(F1(1:N,j)) ; //  pos - to pozycja gdzie minimum znalezione
        

        //Poszukiwanie globalnego minimum

        //zakladamy ze mamy lepszy wynik i go zapisujemy *
            gbest1(1:D,j)=x1(pos,1:D,j)'; // w pomocniczej global best (wartosci x) *
            Fb1(j)=F1(pos,j); // albo =fmin looking for the iteration best result *
            Fbest1(j)=Fb1(j); // Fbest1 to najlepszy znany  * 
        
        
        //poprawiane zmienne jesli zalozenie nieprawdziwe

            if Fbest1(j)<Fbest1(j-1) //zalozenie spelnione - nic nie zmianiamy
            else  // w przeciwnym wypadku
                gbest1(1:D,j)=gbest1(1:D,j-1); // if not then replacing with the good gbest
                Fbest1(j)=Fbest1(j-1); // A new Fbest has not be found this time
            end
            
        //MP moja wersja *
            for i=1:N
                G1(i,1:D,j)=gbest1(1:D,j); //macierz z wektorami rozwiazan x
            end
        

        //Obliczanie najlepszego rozwiazania dla danej czastki (personal best)
            for i=1:N
                [fmin, pos]=min(F1(i,1:j)) ; //pos - to pozycja gdzie znaleziono minimum   
            
                if F1(i,j)<fmin
                    pbest1(i,1:D,j)=x1(i,1:D,j-1);   //personal best dla pierwszej iteracji (tj  pierwsze x)
                else
                    pbest1(i,1:D,j)=x1(i,1:D,j);
                end
        
            end
        

        //Ponowne obliczenie Fbest1 (wartosc funkcji celu w global best)
            y1=gbest1(1:D,j);
            [fcelu, U, M, sigma, F, FX, FY]=mes_module(y1,nw,ne,nc,mp,E,ro,FP,wb,sigmadop,kara,kara2,u_dop);
            Fbest1(j)=fcelu //funkcja celu i-tej czastki w j-tej iteracji
        

        //Obliczenie predkosci i polozenia dla nastepnych iteracji

            if tryb==0 then //dla zmiennych ciaglych
                  v1(1:N,1:D,j+1)=W(j)*v1(1:N,1:D,j)+c1*rand()*(pbest1(1:N,1:D,j)-x1(1:N,1:D,j))+c2*rand()*(G1(1:N,1:D,j)-x1(1:N,1:D,j)); //nowa predkosc
                  x1(1:N,1:D,j+1)=x1(1:N,1:D,j)+v1(1:N,1:D,j+1); //nowe polozenie
                  
                        for q=1:N //uwzglednienie zdefiniowanego maksymalnego i minimalnego przekroju
                            for r=1:D
                                if x1(q,r,j+1)>Amax then
                                    x1(q,r,j+1)=Amax; //jesli obliczone x1 wieksze od Amax, to staje sie Amax
                            
                                elseif x1(q,r,j+1)<Amin then
                                    x1(q,r,j+1)=Amin; //jesli obliczone x1 mniejsze od Amin, to staje sie Amin
                            
                                else //jesli nie spelnione poprzednie warunki to nic nie robimy
                                end
                            end
                        end
                  
            else //dla zmiennych dyskretnych
                
            v1(1:N,1:D,j+1)=W(j)*v1(1:N,1:D,j)+c1*rand()*(pbest1(1:N,1:D,j)-x1(1:N,1:D,j))+c2*rand()*(G1(1:N,1:D,j)-x1(1:N,1:D,j));   //nowa predkosc
            x1(1:N,1:D,j+1)=x1(1:N,1:D,j)+v1(1:N,1:D,j+1); //   nowe polozenie
        
           dimA=size(katalogA);
           dimA=dimA(1,2);

            for q=1:N //dobor wartosci z katalogu
                for r=1:D
                              for t=1:dimA
                                  delta(t)=abs(x1(q,r,j+1)-katalogA(t));    //obliczenie roznic miedzy kazdym z elementow a aktualnym x
                              end
                    
                              [xmin imin]=min(delta); //znalezienie min wartosci i jej pozycji imin
                    
                    x1(q,r,j+1)=katalogA(imin); //podstawienie wartosci z katalogu
                    
                   end
               end

            end
        
    //wyswietlanie numeru iteracji
    disp('Iteracja numer    :  ' + string(j))
    disp('***')
    
    
    end   //Koniec pentli optymalizacji



//Rysynek konstrukcji po odkszztalceniu
        ncp=nc; //macierz wspolrzednych wezlow po obciazeniu konstrukcji
        UX=U; //wektor przemieszczen w kierunku X
        UY=U; //wektor przemieszczen w kierunku Y
        [lw, lc]=size(U); //lw - liczba wierszy, lc - liczba kolumn
        
        for i=lw:-1:1,
                
                if modulo(i,2)==0 then
                    
                    UX(i)=[];
                else
                    
                    UY(i)=[];
                end
                
            end
        
        ncp=nc+[UX,UY]; //aktualizacja wspolrzednych
        
        for i=1:ne, 
            
            x=[ncp(mp(i,1),1),ncp(mp(i,2),1)];
            y=[ncp(mp(i,1),2),ncp(mp(i,2),2)];
            plot2d(x,y,style=26,axesflag=0, frameflag=1, rect=[-200,-200,max(nc)+200,max(nc)+200]);
            plot2d(x,y,style=-3, frameflag=1, rect=[-200,-200,max(nc)+200,max(nc)+200]);
            xtitle("Schemat konstrukcji:")
       
        end

disp('*******************************')
disp('Fbest1   :  ' + string(Fbest1(:,j)))
disp('Gbest1  :  ' + string(gbest1(:,j)))
disp('*******************************')

//---wyswietlenie ostatecznych wynikow

    [fcelu, U, M, sigma, F, FX, FY, M_max, g1, g2]=mes_module(gbest1,nw,ne,nc,mp,E,ro,FP,wb,sigmadop,kara,kara2,u_dop);

    disp('*******************************')
    disp('Masa konstrukcji    :  ')
    disp(M)
    disp('Przemieszczenia w wezlach    :  ')
    disp(U)
    disp('Naprezenia w elementach    :  ')
    disp(sigma)
    disp('Sily w wezlach    :  ')
    disp(F)
    disp('Suma rzutow sil w kierunku X    :  ')
    disp(FX)
    disp('Suma rzutow sil w kierunku Y    :  ')
    disp(FY)
    disp('Funkcja celu    :  ')
    disp(fcelu)
    disp('*******************************')


//--------------------------
//informacja o przekroczonych naprezeniach dopuszczalnych
    for i=1:ne
        if abs(sigma(i))>sigmadop then
            h1(i)=1;
        else
            h1(i)=0;
        end
    end
    
    if max(h1)==1 then
        disp('*******************************')
        disp('Uwaga! Naprezenia dopuszczalne przekroczone!')
        disp('*******************************')
        else
    end

//--------------------------
//informacja o przekroczonych przemieszczeniach dopuszczalnych
    for i=1:2*nw
        if abs(U(i))>u_dop then
            h2(i)=1;
        else
            h2(i)=0;
        end
    end
    
    if max(h2)==1 then
        disp('*******************************')
        disp('Uwaga! Przemieszczenia dopuszczalne przekroczone!')
        disp('*******************************')
        else
    end


