<?php
include 'autorizzazione.php';
if (controlloAutorizzazione())
{
    $utente = $_SESSION["ristoranti_scandura_utente"];

    $conn = mysqli_connect('localhost', 'root', '', 'gestione_ristoranti') or die(mysqli_error($conn));
    $query = "SELECT r.nome as nome, p.data as data, p.ora as ora, p.numero_persone as numero_persone FROM ((prenotazione p join ristorante r on p.ristorante = r.codice)) where p.username='$utente'" ;
    $res = mysqli_query($conn, $query) or die(mysqli_error($conn));

    if (mysqli_num_rows($res) > 0) {
        while($entry = mysqli_fetch_assoc($res)) {
            $prenotazioni[] = array("ristorante" => $entry["nome"], 
                                "data" => $entry["data"], 
                                "ora" => $entry["ora"], 
                                "numero_persone" => $entry["numero_persone"]);
        }
        
    mysqli_close($conn);
        echo json_encode($prenotazioni);
        exit;
    }
  
}
echo json_encode(1);
?>