<?php
    $ristorante = $_GET["q"];

    $conn = mysqli_connect('localhost', 'root', '', 'gestione_ristoranti') or die(mysqli_error($conn));
    $query = "SELECT codice FROM ristorante where nome ='$ristorante'" ;
    $res = mysqli_query($conn, $query) or die(mysqli_error($conn));
    $entry = mysqli_fetch_assoc($res);
    $codice = $entry['codice'];
    $query2 = "SELECT immagine FROM menu where ristorante ='$codice'" ;
    $res2 = mysqli_query($conn, $query2) or die(mysqli_error($conn));
    $entry2 = mysqli_fetch_assoc($res2);
    $immagine = $entry2['immagine'];
    mysqli_close($conn);
    echo json_encode($immagine);
    exit;

?>