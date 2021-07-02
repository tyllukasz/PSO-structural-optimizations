//Skrypt uruchamiajacy wielokrotnie procedure optymalizaci

//zapis wynikow do macierzy

//w kolumnach zestawione wyniki z poszczegolnych uruchomien
//w wierszach: ostatni wiersz to masa, wczesniejsze - przekroje elementow

clear

//liczba iteracji
imax=10;

for qq=1:imax

    exec('PSO_inertial_MP_LT.sci')
    masa(qq)=M;
    przekroje(:,qq)=gbest1(:,j);
end

zestawienie=przekroje;
zestawienie(ne,:)=masa';

    disp('*******************************')
    disp('Wyniki:   ')
    disp(zestawienie)
