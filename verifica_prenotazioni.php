<?php
    function controlloPrenotazioni() {
    $utente = $_SESSION["ristoranti_scandura_utente"];
    $conn = mysqli_connect('localhost', 'root', '', 'gestione_ristoranti') or die(mysqli_error($conn));
    $query = "SELECT * FROM prenotazione p WHERE username='$utente'" ;
    $res = mysqli_query($conn, $query) or die(mysqli_error($conn));

    if (mysqli_num_rows($res) > 0)
        if(isset($_SESSION['ristoranti_scandura_utente'])) {
            return 1;
        } else 
            return 0;
    }
?>