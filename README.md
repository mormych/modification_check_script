# modification_check_script
Zastosowanie: Skrypt służy do sprawdzania czy pliki konkretnym katalogu zostały zaktualizowane w podanym przedziale czasowym. Sprawdzanie polega na przekształceniu obecnej daty i daty modyfikacji pliku na minuty a następnie po wykonaniu odejmowania sprawdzamy czy wynik jest mniejszy niż maksymalny limit ustawiony w programie. Jeżeli jest większy to skrypt wysyła wiadomość, że plik nie był modyfikowany.

 

Obsługa: Skrypt operuje na zmiennych:

    $CurrentDate - zmienna przechowująca obecny czas w momencie uruchomienia skryptu

    [Int32]$NoModifyTimeAllowed - zmienna przechowuje liczbę całkowitą maksymalnej ilości minut która może upłynąć bez modyfikacji pliku

    $DirToCheck - zmienna przechowuje katalog w którym skrypt będzie sprawdzał czy pliki uległy modyfikacji

    [string[]]$AllowedExtension - Tablica dozwolonych rozszerzeń. Pliki o innych rozszerzeniach nie będą brane pod uwagę

 

Uruchamianie: Skrypt uruchamiamy a następnie w trybie automatycznym wykonuje sprawdzenie wszystkich plików w katalogu o dozwolonych rozszerzeniach, gdy czas modyfikacji przekroczy limit - wysyła powiadomienie

 

Błędy: Program nie obsługuje następujących błędów

    Ustawiony katalog nie istnieje

    -

    -
