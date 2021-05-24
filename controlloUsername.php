<?php 

    if (!isset($_GET["q"])) {
        echo "Errore";
        exit;
    }

    header('Content-Type: application/json');
    $conn = mysqli_connect('localhost', 'root', '', 'gestione_ristoranti') or die(mysqli_error($conn));
    $username = mysqli_real_escape_string($conn, $_GET["q"]);
    $query = "SELECT username FROM utente WHERE username = '$username'";
    $res = mysqli_query($conn, $query) or die(mysqli_error($conn));

    echo json_encode(array('exists' => mysqli_num_rows($res) > 0 ? true : false));
    mysqli_close($conn);
?>