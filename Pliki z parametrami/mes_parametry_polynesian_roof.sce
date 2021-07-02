// Metoda elementow skonczonych - (elementy pretowe)

//Definicja parametrow konstrukcji

//-----Przyklad 1 - 'Trojkat'-----


    //dane geometryczne konstrukcji
    nw=12;    //liczba wezlow
    ne=21;   //liczba elementow skonczonych
    
    //definiowanie wspolrzednych wezlow
    nc=[0,0;
        4,0;
        9,0;
        13,0;
        17,0;
        22,0;
        26,0;
        4,2;
        9,4;
        13,9;
        17,4;
        22,2];      //macierz wspolrzednych poszczegolnych wezlow (nw x 2) [x1, y1; x2, y2; ...]
    
    
    //definicja polaczen wezlow - elementow skonczonych oraz ich parametrow
    mp=[1,2;
        2,3;
        3,4;
        4,5;
        5,6;
        6,7;
        1,8;
        2,4;
        8,3;
        8,9;
        3,9;
        4,9;
        9,10;
        4,10;
        4,11;
        10,11;
        5,11;
        5,12;
        11,12;
        6,12;
        7,12];      //macierz polaczen (wymiar - ne x 2)
    
    
    
    //dane materialowe
    E=10;   //modul Younga
    ro=7850*10^-9;   //gestosc
    
    //definicja obciazenia - sily dzialajace w wezlach (poza reakcjami)
    FP=[-1,6; -1,10;1,19];   //pary liczb: 'wartosc sily - kierunek przemieszczenia , w ktorym dziala (numeracja przemieszczen jak w wektorze U)'
    
    //definicja warunkow brzegowych
    wb=[14,2,1];   //w wektorze zapisane sa nr przemieszczen, ktore przyjmuja wartosc "0" (numeracja musi byc zgodna z definicja wektora U),
                  //wazne zeby byly zapisane w kolejnosci malejacej

    //parametry wykorzystywane do obliczenia funkcji celu
    sigmadop=50;    //naprezenia dopuszczalne
    kara=10;   //wspolczynnik kary (przekroczenie naprezen dopuszczalnych)
    kara2=-1000;   //wspolczynnik kary (eliminacja wartosci ujemnych)
