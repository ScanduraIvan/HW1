<?php
    include 'autorizzazione.php';
    if (controlloAutorizzazione())
    {
        $utente = $_SESSION["ristoranti_scandura_utente"];
        $link = $_GET["link"];
        $titolo = $_GET["titolo"];

        $conn = mysqli_connect('localhost', 'root', '', 'gestione_ristoranti') or die(mysqli_error($conn));

        $query = "SELECT  count(*) from news_cliccate where utente ='$utente' and link='$link'";
        $res = mysqli_query($conn, $query) or die(mysqli_error($conn));
        $entry = mysqli_fetch_assoc($res);

        if ($entry["count(*)"] == 0) {
        $query1 = "INSERT INTO news_cliccate values('$utente','$link','$titolo')";
        $res1 = mysqli_query($conn, $query1) or die(mysqli_error($conn));
        }
        mysqli_close($conn);
    }
?>