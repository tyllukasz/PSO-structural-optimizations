// Metoda elementow skonczonych - (elementy pretowe)

//Definicja parametrow konstrukcji

//-----Przyklad 1 - 'Trojkat'-----


    //dane geometryczne konstrukcji
    nw=3;    //liczba wezlow
    ne=3;   //liczba elementow skonczonych
    
    //definiowanie wspolrzednych wezlow
    nc=[0,0;1,0;0,1];   //macierz wspolrzednych poszczegolnych wezlow (nw x 2) [x1, y1; x2, y2; ...]
    
    //definicja polaczen wezlow - elementow skonczonych oraz ich parametrow
    mp=[1,2;2,3;1,3];   //macierz polaczen (wymiar - ne x 2)
    
    //dane materialowe
    E=10;   //modul Younga
    ro=7850*10^-9;   //gestosc
    
    //definicja obciazenia - sily dzialajace w wezlach (poza reakcjami)
    FP=[-0.707,5; -0.707,6];   //pary liczb: 'wartosc sily - kierunek przemieszczenia , w ktorym dziala (numeracja przemieszczen jak w wektorze U)'
    
    //definicja warunkow brzegowych
    wb=[4,2,1];   //w wektorze zapisane sa nr przemieszczen, ktore przyjmuja wartosc "0" (numeracja musi byc zgodna z definicja wektora U),
                  //wazne zeby byly zapisane w kolejnosci malejacej

    //parametry wykorzystywane do obliczenia funkcji celu
    sigmadop=50;    //naprezenia dopuszczalne
    kara=10;   //wspolczynnik kary (przekroczenie naprezen dopuszczalnych)
    kara2=-1000;   //wspolczynnik kary (eliminacja wartosci ujemnych)
