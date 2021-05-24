<?php include 'autorizzazione.php'; ?>
<?php include 'verifica_prenotazioni.php'; ?>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Ristoranti Scandura</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="menu.css">
    <script src = "mhw3.js" defer = "true"></script>
    <script src = "menu_mobile.js" defer = "true"></script>
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Unicase:wght@500&family=PT+Serif&family=Cormorant+Garamond:wght@600&family=Cormorant:wght@700&family=Spectral:ital,wght@1,300&family=Varela+Round&display=swap" rel="stylesheet">
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
          <a href="mhw2.php">Ristoranti</a>
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
    </header>
    <div id='selezione_ristorante'>
    <select name='ristorante' placeholder='Ristorante'>
                    <option value='selezione' disabled selected> Seleziona il ristorante </option>
                        <option value='Ristorante Baronessa'> Ristorante Baronessa </option>
                        <option value='Ristorante Granduca'> Ristorante Granduca </option>
                        <option value='Ristorante Villa Antonio'> Ristorante Villa Antonio </option>
                        <option value='Ristorante Mazzarò'> Ristorante Mazzaro' </option>
                        <option value='Ristorante Taormina'> Ristorante Taormina</option>
                        <option value='Ristorante Al Duomo'> Ristorante Al Duomo </option>
                        <option value='Ristorante Al Saraceno'> Ristorante Al Saraceno </option>
                        <option value='Ristorante Le Terrazze'> Ristorante Le Terrazze </option>
                        <option value='Ristorante Baia Taormina'> Ristorante Baia Taormina </option>
                    </select>
    </div>

    <article id="contenuti_menu">
    </article>

    <section id="modale" class="hidden">
  </section>

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