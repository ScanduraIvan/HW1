<?php include 'autorizzazione.php'; ?>
<?php include 'verifica_prenotazioni.php'; ?>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Ristoranti Scandura</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="mhw1.css">
    <script src = "mhw3.js" defer = "true"></script>
    <script src = "menu_mobile.js" defer = "true"></script>
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Julius+Sans+One&family=Cormorant+Unicase:wght@500&family=PT+Serif&family=Cormorant+Garamond:wght@600&family=Cormorant:wght@700&family=Spectral:ital,wght@1,300&family=Varela+Round&display=swap" rel="stylesheet">
  </head>

  <body>
    <header>
      <nav>
        <div id="logo">
          Ristoranti 
          <img id="rs-logo" src="Logo.png" />
          Scandura
        </div>
        <div class="links-button">
          <a href="mhw1.php">Home</a>
          <a href="mhw2.php ">Ristoranti</a>
          <a href="menu.php">Menù</a>
          <a href="mhw3.php">Taormina</a> 
          <a target="_blank" href="https://www.google.com/maps/@37.8539388,15.2834943,14z/data=!4m3!11m2!2sGJiul6j_DF62YyHwYkhLkZBjtH2p5Q!3e3">Mappa</a> 
          <?php
          if (controlloAutorizzazione() && controlloPrenotazioni())
              echo "<a href= prenotazioni_utente.php>Prenotazioni</a>";
          ?>
          <?php
          if (controlloAutorizzazione())
              echo "<a href= logout.php id=accesso>Esci</a>";
          else
              echo "<a href= accesso.php id= accesso>Accedi</a>";
          ?>
        </div>
        <div id="menu">
          <div></div>
          <div></div>
          <div></div>
        </div>
      </nav>
      <div id="links-menu" class="hidden">
          <a href="mhw1.php">Home</a>
          <a href="mhw2.php ">Ristoranti</a>
          <a href="menu.php">Menù</a>
          <a href="mhw3.php">Taormina</a> 
          <a target="_blank" href="https://www.google.com/maps/@37.8539388,15.2834943,14z/data=!4m3!11m2!2sGJiul6j_DF62YyHwYkhLkZBjtH2p5Q!3e3">Mappa</a> 
          <?php
          if (controlloAutorizzazione() && controlloPrenotazioni())
              echo "<a href= prenotazioni_utente.php>Prenotazioni</a>";
          ?>
          <?php
          if (controlloAutorizzazione())
              echo "<a href= logout.php id=accesso>Esci</a>";
          else
              echo "<a href= accesso.php id= accesso>Accedi</a>";
          ?>
      </div>

      <?php
          if (controlloAutorizzazione())
          {
              echo '<div id=benvenuto> welcome <br>';
              echo $_SESSION['ristoranti_scandura_utente'];
              echo '</div>';
          }
          ?>
      </div>
        <div id="descrizione-buttons">
          Situati nel cuore di Taormina, i nostri ristoranti<br/>
          offrono viste incantevoli da oltre 40 anni 
            <div class="buttons">
              <a href="menu.php">Visualizza i menù</a>
              <?php
              if (controlloAutorizzazione())
                echo "<a href=prenotazione.php>Prenota un tavolo</a>";
              ?>
            </div>
        </div>
    </header>

    <article>
      <section>
        <img class="Immagine" src="Immagine1.jpg" />
        <p>I saloni, le terrazze e i giardini, tutti con vista incantevole sul mare, sul Teatro Greco  o su altre meraviglie di Taormina.
          Ideale per Meetings e ricevimenti. Prestigiose cornici dove
          assaporare piatti tipici fortemente legati alla tradizione siciliana.
          La qualità del servizio, la magia e la bellezza del luogo, fanno dei nostri ristoranti una location esclusiva,
           dove il cibo è uno ma non l'unico, degli ingredienti che le nostre splendide strutture offrono.</p>
      </section>

      <section>
        <p>Prepariamo cibi gustosi già dagli anni '80.
          Specialità: pranzo e cena. Servizi: Adatto per gruppi, adatto per bambini, posti a sedere all'aperto,
          accettiamo prenotazioni, prenotazione non obbligatoria. Servizio impeccabile ai tavoli, Carta dei Vini "ampia scelta",
          Ristorante Italiano, Ristorante di pesce e carne. Le creazioni dei nostri Chef 
          sono servite in ambienti unici che evocano lo splendore delle case aristocratiche siciliane.
       </p>
       <img class="Immagine" src="Immagine2.jpg" />
      </section>
    </article>
  
    <footer>
      <div class = "flex">
        <p class = "font1">RISTORANTI SCANDURA</p>
        <p> Un must della ristorazione taorminese.<br/> 
            In un’atmosfera incantata<br/>
            che in molti prediligono per i grandi eventi<br/> <br/> 

          <strong>Mezzi di pagamento</strong><br/> 
          Bancomat, Carte di credito<br/> <br/>
        <strong>FREE WIFI</strong><br/> 
          Disponibile presso le nostre attività</p>
      </div>
      <div class = "flex">
      <p class = "font1"> CONTACT INFO</p>
      <p>Taormina ME<br/><br/>
          Tel +39 0942 625808<br/>
          Fax +39 0942 625808<br/>
          E-mail scanduraivan@gmail.com<br/><br/>
          Ivan Scandura 046001462<br/>
          P.IVA 8086250942
      </p>
    </div>
    <div class = "flex">
      <p class = "font1"> ORARI DI APERTURA</p>
      <p>Giorni Feriali<br/>   
         12:00 -15:00 / 19:00-24:00<br/> 
         Sabato <br/>
         12:00 -17:00 / 19:00-24:00 <br/>
         Domenica <br/>
         11:30 -17:00 / 19:00-24:00<br/>
         Giorno di Chiusura<br/>
         Martedì
      </p>
    </div>
    </footer>
    <marquee behavior="scroll" direction="left" scrolldelay="50" truespeed> 
      <section id="news"></section>
    </marquee> 
  </body>
</html>