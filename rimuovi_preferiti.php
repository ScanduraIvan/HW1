<?php
include 'autorizzazione.php';
if (controlloAutorizzazione())
{
    $utente = $_SESSION["ristoranti_scandura_utente"];
    $ristorante = $_GET["q"];

    $conn = mysqli_connect('localhost', 'root', '', 'gestione_ristoranti') or die(mysqli_error($conn));
    $query = "DELETE FROM preferiti where utente='$utente' and codice_ristorante ='$ristorante' limit 1" ;
    $res = mysqli_query($conn, $query) or die(mysqli_error($conn));
  
    mysqli_close($conn);
    exit;  
}
?>