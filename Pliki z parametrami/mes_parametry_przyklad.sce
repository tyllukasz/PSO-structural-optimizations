// Metoda elementow skonczonych - (elementy pretowe)

//Definicja parametrow konstrukcji

//-----Przyklad 3-----


    //dane geometryczne konstrukcji
    nw=12;    //liczba wezlow
    ne=21;   //liczba elementow skonczonych
    
    //definiowanie wspolrzednych wezlow
    nc=[0,0;
        300,200;
        500,200;
        700,200;
        900,200;
        1100,200;
        1400,0;
        1100,400;
        900,400;
        700,400;
        500,400;
        300,400];      //macierz wspolrzednych poszczegolnych wezlow (nw x 2) [x1, y1; x2, y2; ...]
    
    
    //definicja polaczen wezlow - elementow skonczonych oraz ich parametrow
    mp=[1,2;
        2,3;
        3,4;
        4,5;
        5,6;
        6,7;
        7,8;
        6,8;
        5,8;
        5,9;
        5,10;
        4,10;
        3,10;
        3,11;
        3,12;
        2,12;
        1,12;
        11,12;
        11,10;
        10,9;
        9,8];      //macierz polaczen (wymiar - ne x 2)
    
    
    
    //dane materialowe
    E=0.1*10^5;   //modul Younga [MPa]
    ro=7850*10^-9;   //gestosc [kg/mm^3]
    
    //definicja obciazenia - sily dzialajace w wezlach (poza reakcjami) [N]
    FP=[-10000,8;10000,15];   //pary liczb: 'wartosc sily - kierunek przemieszczenia , w ktorym dziala (numeracja przemieszczen jak w wektorze U)'
    
    //definicja warunkow brzegowych
    wb=[14,13,2,1];   //w wektorze zapisane sa nr przemieszczen, ktore przyjmuja wartosc "0" (numeracja musi byc zgodna z definicja wektora U),
                  //wazne zeby byly zapisane w kolejnosci malejacej

    //parametry wykorzystywane do obliczenia funkcji celu
    sigmadop=300;    //naprezenia dopuszczalne [MPa]
    kara=10;   //wspolczynnik kary (przekroczenie naprezen dopuszczalnych)
    kara2=-1000;   //wspolczynnik kary (eliminacja wartosci ujemnych)
