<?php
    include 'autorizzazione.php';
    if (controlloAutorizzazione())
    {
        $utente = $_SESSION["ristoranti_scandura_utente"];
        $ristorante = $_GET["q"];

        $conn = mysqli_connect('localhost', 'root', '', 'gestione_ristoranti') or die(mysqli_error($conn));
        $query = "SELECT nome, immagine, descrizione FROM ristorante where codice ='$ristorante'" ;
        $res1 = mysqli_query($conn, $query) or die(mysqli_error($conn));
        
        $query = "SELECT  count(*) from preferiti where utente ='$utente' and codice_ristorante='$ristorante'";
        $res2 = mysqli_query($conn, $query) or die(mysqli_error($conn));
        $entry2 = mysqli_fetch_assoc($res2);
        if (mysqli_num_rows($res1) > 0 && $entry2["count(*)"] == 0) {
            $entry1 = mysqli_fetch_assoc($res1);
            $nome_ristorante = $entry1["nome"];
            $immagine = $entry1["immagine"];
            $descrizione = $entry1["descrizione"];
            $query = "INSERT INTO preferiti values('$utente','$ristorante','$nome_ristorante',' $immagine', '$descrizione')";
            $res3 = mysqli_query($conn, $query) or die(mysqli_error($conn));
            mysqli_close($conn);
            exit;}
        else{
            mysqli_close($conn);
            exit;
        }
    }
?>