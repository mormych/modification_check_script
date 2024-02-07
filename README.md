# modification_check_script
Zastosowanie: Skrypt służy do sprawdzania czy pliki konkretnym katalogu zostały zaktualizowane w podanym przedziale czasowym. Sprawdzanie polega na przekształceniu obecnej daty i daty modyfikacji pliku na minuty a następnie po wykonaniu odejmowania sprawdzamy czy wynik jest mniejszy niż maksymalny limit ustawiony w programie. Jeżeli jest większy to skrypt wysyła wiadomość, że plik nie był modyfikowany.

 

Obsługa: Skrypt operuje na zmiennych:

    $daysToCheck= Dni w których skrypt będzie sprawdzał datę modyfikacji pliku (1 - poniedziałek...7-niedziela)

    $dirsToCheck= Katalogi rozdzielone przecinkiem, w których skrypt będzie sprawdzał pliki

    $noModifyTime= Maksymalny dopuszczany czas w którym plik nie musi być modifikowany

    $excludedFormats= Plik będzie wykluczał następujące wskazane rozszerzenia plików.
    
    $port= Port dla serwera smtp.
    
    $smtp= Serwer, z którego będziemy wysyłali powiadomienia e-mail

    $user= Adres mailowy z którego będziemy wysyłali powiadomienia

    $pass= Hasło użytkownika z ktorego będziemy wysyłać maile.

    $destination= Docelowi adresaci rozdzieleni przecinkiem do których będziemy wysyłać maile.
 

Uruchamianie: Skrypt uruchamiamy a następnie w trybie automatycznym wykonuje sprawdzenie wszystkich plików w katalogu o dozwolonych rozszerzeniach, gdy czas modyfikacji przekroczy limit - wysyła powiadomienie

 

Błędy: Program nie obsługuje następujących błędów

    Ustawiony katalog nie istnieje

    Plik konfiguracji nie pasuje do uruchomionego skryptu

    -


![Bez nazwy](https://github.com/mormych/modification_check_script/assets/71809600/4b55455f-6a0f-4d4a-b943-e308e8888773)

![obraz](https://github.com/mormych/modification_check_script/assets/71809600/5a86d74e-3691-4cc9-8e7d-fa2b3c04ad57)

