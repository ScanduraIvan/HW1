<?php
$conn = mysqli_connect('localhost', 'root', '', 'gestione_ristoranti') or die(mysqli_error($conn));
$query = "SELECT codice, nome, immagine, descrizione FROM ristorante" ;

$res = mysqli_query($conn, $query) or die(mysqli_error($conn));
if (mysqli_num_rows($res) > 0) {

    while($entry = mysqli_fetch_assoc($res)) {
        $ristoranti[] = array( "id_ristorante" => $entry["codice"],
                            "nome_ristorante" => $entry["nome"], 
                            "immagine" => $entry["immagine"], 
                            "descrizione" => $entry["descrizione"]);
    }

mysqli_close($conn);
echo json_encode($ristoranti);
exit;
}
?>