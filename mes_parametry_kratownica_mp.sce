// Metoda elementow skonczonych - (elementy pretowe)

//Definicja parametrow konstrukcji

//-----Przyklad z pozycji ALGORYTMY EWOLUCYJNE (M. Pyrz)-----



    //dane geometryczne konstrukcji
    nw=6;    //liczba wezlow
    ne=10;   //liczba elementow skonczonych
    
    //definiowanie wspolrzednych wezlow [in]
    nc=[720,360;
        720,0;
        360,360;
        360,0;
        0,360;
        0,0];      //macierz wspolrzednych poszczegolnych wezlow (nw x 2) [x1, y1; x2, y2; ...]
    
    //definicja polaczen wezlow - elementow skonczonych oraz ich parametrow
    mp=[5,3;
        3,1;
        6,4;
        4,2;
        4,3;
        2,1;
        5,4;
        6,3;
        3,2;
        4,1];      //macierz polaczen (wymiar - ne x 2)
    
    //dane dotyczace przekrojow [in^2]
        //zmienne ciagle
        Amin=0.1;   //minimalna dopuszalna wartosc pola przekroju preta
        Amax=36;   //maksymalna dopuszczalna wartosc pola przekroju preta
        
        //zmienne dyskretne
        katalogA=[0.1,1,2,3,4,5,6,7,8,9,10,12,14,16,18,20,22,24,26,28,30,32,34,36];    //dopuszczalne wartosci pol przekrojow preta
        
    //dane materialowe
    E=10^7;   //modul Younga [lb/in^2]
    ro=0.1*10^-3;   //gestosc [lb/in^3]
    
    //definicja obciazenia - sily dzialajace w wezlach (poza reakcjami) [N]
    FP=[-10^5,4; -10^5,8];   //pary liczb: 'wartosc sily - kierunek przemieszczenia , w ktorym dziala (numeracja przemieszczen jak w wektorze U)'
    
    //definicja warunkow brzegowych
    wb=[12,11,10,9];   //w wektorze zapisane sa nr przemieszczen, ktore przyjmuja wartosc "0" (numeracja musi byc zgodna z definicja wektora U),
                  //wazne zeby byly zapisane w kolejnosci malejacej

    //parametry wykorzystywane do obliczenia funkcji celu
    sigmadop=25000;    //naprezenia dopuszczalne
    u_dop=2;    //dopuszczalne przemieszczenia
    kara=100;   //wspolczynnik kary (przekroczenie naprezen dopuszczalnych)
    kara2=100;   //wspolczynnik kary (przekroczenie przemieszczen dopuszczalnych)
