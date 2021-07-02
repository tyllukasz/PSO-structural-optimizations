// Metoda elementow skonczonych - (elementy pretowe)

//Definicja parametrow konstrukcji

//-----Dach-----


    //dane geometryczne konstrukcji
    nw=12;    //liczba wezlow
    ne=21;   //liczba elementow skonczonych
    
    //definiowanie wspolrzednych wezlow
    nc=[0,0;
        400,0;
        900,0;
        1300,0;
        1700,0;
        2200,0;
        2600,0;
        400,200;
        900,400;
        1300,900;
        1700,400;
        2200,200];      //macierz wspolrzednych poszczegolnych wezlow (nw x 2) [x1, y1; x2, y2; ...]
    
    
    //definicja polaczen wezlow - elementow skonczonych oraz ich parametrow
    mp=[1,2;
        2,3;
        3,4;
        4,5;
        5,6;
        6,7;
        1,8;
        2,8;
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
    E=0.1*10^5;   //modul Younga [MPa]
    ro=7850*10^-9;   //gestosc [kg/mm^3]
    
    //definicja obciazenia - sily dzialajace w wezlach (poza reakcjami) [N]
    FP=[-1000,6; -1000,10;1000,19];   //pary liczb: 'wartosc sily - kierunek przemieszczenia , w ktorym dziala (numeracja przemieszczen jak w wektorze U)'
    
    //definicja warunkow brzegowych
    wb=[14,13,20,19,2,1];   //w wektorze zapisane sa nr przemieszczen, ktore przyjmuja wartosc "0" (numeracja musi byc zgodna z definicja wektora U),
                  //wazne zeby byly zapisane w kolejnosci malejacej

    //parametry wykorzystywane do obliczenia funkcji celu
    sigmadop=500;    //naprezenia dopuszczalne [MPa]
    kara=10;   //wspolczynnik kary (przekroczenie naprezen dopuszczalnych)
    kara2=-1000;   //wspolczynnik kary (eliminacja wartosci ujemnych)
