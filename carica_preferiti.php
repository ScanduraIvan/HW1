<?php    
include 'autorizzazione.php';
if (controlloAutorizzazione())
{
    $utente = $_SESSION["ristoranti_scandura_utente"];

    $conn = mysqli_connect('localhost', 'root', '', 'gestione_ristoranti') or die(mysqli_error($conn));
    $query = "SELECT utente, codice_ristorante, nome_ristorante, immagine, descrizione FROM preferiti where utente='$utente'" ;
    $res = mysqli_query($conn, $query) or die(mysqli_error($conn));

    if (mysqli_num_rows($res) > 0) {
        while($entry = mysqli_fetch_assoc($res)) {
            $preferiti[] = array("utente" => $entry["utente"], 
                                "codice_ristorante" => $entry["codice_ristorante"], 
                                "nome_ristorante" => $entry["nome_ristorante"], 
                                "immagine" => $entry["immagine"],
                                "descrizione" => $entry["descrizione"]);
        }
    }
    mysqli_close($conn);
    if(mysqli_num_rows($res) > 0)
    {
        echo json_encode($preferiti);
        exit;
    }
}
echo json_encode(1);
?>