// Metoda elementow skonczonych - (elementy pretowe)

//Definicja parametrow konstrukcji

//-----Platforma-----



    //dane geometryczne konstrukcji
    nw=8;    //liczba wezlow
    ne=13;   //liczba elementow skonczonych
    
    //definiowanie wspolrzednych wezlow [mm]
    nc=[0,0;
        3500,2100;
        3500,4100;
        7000,2100;
        7000,4100;
        10500,2100;
        10500,4100;
        14000,0];      //macierz wspolrzednych poszczegolnych wezlow (nw x 2) [x1, y1; x2, y2; ...]
    
    //definicja polaczen wezlow - elementow skonczonych oraz ich parametrow
    mp=[1,2;
        1,3;
        2,3;
        2,4;
        3,4;
        3,5;
        4,5;
        5,7;
        4,7;
        4,6;
        6,7;
        7,8;
        6,8];      //macierz polaczen (wymiar - ne x 2)
    
    //dane dotyczace przekrojow [mm^2]
        //zmienne ciagle
        Amin=1;   //minimalna dopuszalna wartosc pola przekroju preta
        Amax=7000;   //maksymalna dopuszczalna wartosc pola przekroju preta
        
        //zmienne dyskretne
        katalogA=[Amin:Amax];    //dopuszczalne wartosci pol przekrojow preta
        
    //dane materialowe
    E=2.1*10^5;   //modul Younga [MPa] - stal
    ro=7850*10^-9;   //gestosc [kg/mm^3] - stal
    
    //definicja obciazenia - sily dzialajace w wezlach (poza reakcjami) [N]
    FP=[-40*10^3,6; -60*10^3,10; -110*10^3,14];   //pary liczb: 'wartosc sily - kierunek przemieszczenia , w ktorym dziala (numeracja przemieszczen jak w wektorze U)'
    
    //definicja warunkow brzegowych
    wb=[16,2,1];   //w wektorze zapisane sa nr przemieszczen, ktore przyjmuja wartosc "0" (numeracja musi byc zgodna z definicja wektora U),
                  //wazne zeby byly zapisane w kolejnosci malejacej

    //parametry wykorzystywane do obliczenia funkcji celu
    sigmadop=450;    //naprezenia dopuszczalne
    u_dop=10;    //dopuszczalne przemieszczenia
    kara=300;   //wspolczynnik kary (przekroczenie naprezen dopuszczalnych)
    kara2=1000;   //wspolczynnik kary (przekroczenie przemieszczen dopuszczalnych)
