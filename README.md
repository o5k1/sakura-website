# Progetto Sakura
## Collaboratori
Eduard Bicego, Davide Castello, Andrea Tombolato.

## Abstract
Il progetto è incentrato sulla creazione di un sito web adatto a rappresentare un ristorante di cucina orientale, per raggiungere il massimo bacino di utenza è stata implementata anche una **versione mobile** del sito.

## Accessibilità
Ogni pagina è stata realizzata pensato agli **standard di accessibilità** promossi dal W3C.
### Colore
L'accessibilità al sito è stata testata con successo rispetto alle seguenti patologie: deuteranopia, monochromacy,
partialMonochromacy, protanopia e tritanopia.

### Screen-reader
Per permettere una migliore accessibità agli utenti che utilizzano **screen-reader**: 
* ogni parola non italiana è stata dotata di attributo ```xml:lang``` con valore corrispondente alla lingua di appartenenza della parola;
* l'accessibilità al sito attraverso screen-reader è stata testata con successo tramite il browser testuale Lynx;
* sono stati posizionati dei link "fuori schermo" in corrispondenza dei vari menu, tali link sono rilevanti solo per chi utilizza screen-reader e permettono di saltare la lettura del menu a cui sono associati.

## Sezioni del sito
### Home
Contiene le informazioni che un utente che giunge sul sito: 
* orari d'apertura;
* breve presentazione del ristorante;
* presentazione del servizio *take away*.

### Menu
Contiene le informazioni relative a cibi e bevande proposte dal ristorante. Questa pagina si basa su scrpt CGI per recuperare le informazioni da un file XML opportunamente formattato.

### Chi Siamo
Presenta i membri dello staff del ristorante e la loro esperienza nell'ambito della ristorazione, per instaurare fiducia nel cliente.

### Dove Siamo
Presenta indicazioni per raggiungere il locale, supportate da un link a Google Maps.

### Curiosità
Presenta la storia e le curiosità sulla cucina orientale.

### Area amministratore
Sezione del sito a disposizione esclusiva del proprietario, in modo che possa autonomamente modificare piatti e bevande proposti nella sezione *Menu*.

## Ambito
Il progetto è associato all'insegnamento *Tecnologie web* proposto all'interno del CdL in Informatica dell'Università degli studi di Padova
