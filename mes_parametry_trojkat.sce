// Metoda elementow skonczonych - (elementy pretowe)

//Definicja parametrow konstrukcji

//-----Przyklad 1 - 'Trojkat'-----


    //dane geometryczne konstrukcji
    nw=3;    //liczba wezlow
    ne=3;   //liczba elementow skonczonych
    
    //definiowanie wspolrzednych wezlow
    nc=[0,0;1000,0;0,1000];   //macierz wspolrzednych poszczegolnych wezlow (nw x 2) [x1, y1; x2, y2; ...]
    
    //definicja polaczen wezlow - elementow skonczonych oraz ich parametrow
    mp=[1,2;2,3;1,3];   //macierz polaczen (wymiar - ne x 2)
    
    //dane dotyczace przekrojow
        //zmienne ciagle
        Amin=0.1;   //minimalna dopuszalna wartosc pola przekroju preta
        Amax=500;   //maksymalna dopuszczalna wartosc pola przekroju preta
        
        //zmienne dyskretne
        katalogA=[1,2,3,4,5,6,7,8,9,11,15,22,34,45,57,71,92,113,150,220];    //dopuszczalne wartosci pol przekrojow preta
        
    //dane materialowe
    E=0.1*10^5;   //modul Younga
    ro=7850*10^-9;   //gestosc
    
    //definicja obciazenia - sily dzialajace w wezlach (poza reakcjami)
    FP=[-7070,5; -7070,6];   //pary liczb: 'wartosc sily - kierunek przemieszczenia , w ktorym dziala (numeracja przemieszczen jak w wektorze U)'
    
    //definicja warunkow brzegowych
    wb=[4,2,1];   //w wektorze zapisane sa nr przemieszczen, ktore przyjmuja wartosc "0" (numeracja musi byc zgodna z definicja wektora U),
                  //wazne zeby byly zapisane w kolejnosci malejacej

    //parametry wykorzystywane do obliczenia funkcji celu
    sigmadop=500;    //naprezenia dopuszczalne
    u_dop=50;    //dopuszczalne przemieszczenia
    kara=10;   //wspolczynnik kary (przekroczenie naprezen dopuszczalnych)
    kara2=10;   //wspolczynnik kary (przekroczenie przemieszczen dopuszczalnych)
