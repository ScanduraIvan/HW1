<?php
    require_once 'autorizzazione.php';

    if (!empty($_POST["ristorante"]) && !empty($_POST["cognome"]) && !empty($_POST["numero_persone"]) && !empty($_POST["data"]) && 
        !empty($_POST["ora"]) && !empty($_POST["telefono"]))
    {
        $conn = mysqli_connect('localhost', 'root', '', 'gestione_ristoranti') or die(mysqli_error($conn));

        $ristorante = $_POST['ristorante'];

        $query = "SELECT codice FROM ristorante WHERE nome = '$ristorante'";
        $res = mysqli_query($conn, $query) or die(mysqli_error($conn));
        $entry = mysqli_fetch_assoc($res);
        $codice = $entry['codice'];

        $cognome = mysqli_real_escape_string($conn, $_POST['cognome']);
        $numero_persone = $_POST['numero_persone'];
        $data = $_POST['data'];
        $ora = $_POST['ora'];
        $telefono = mysqli_real_escape_string($conn, $_POST['telefono']);

        if(controlloAutorizzazione())
        {
            $utente = $_SESSION["ristoranti_scandura_utente"];
            $query = "INSERT INTO prenotazione(ristorante, cognome, numero_persone, data, ora, numero_telefono, username) VALUES('$codice', '$cognome', '$numero_persone', '$data', '$ora', '$telefono', '$utente')";
        }
           

        if (mysqli_query($conn, $query)) {
            mysqli_close($conn);
            header("Location: prenotazione_effettuata.html");
            exit;
        } else {
            $error = "Errore di connessione al Database";
            }
        mysqli_close($conn);
    }
    else if (isset($_POST["cognome"])) {
        $error = "Riempi tutti i campi correttamente";
    }
?>


<html>
    <head>
        <link rel='stylesheet' href='prenotazione.css'>

        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta charset="utf-8">

        <title>Ristoranti Scandura - Prenota un tavolo</title>
    </head>
    <body>
        <section class="iscrizione">
            <div id="logo">
                Ristoranti 
                <img id="rs-logo" src="Logo.png" />
                Scandura
            </div>
            <?php
                if (isset($error)) {
                    echo "<div class='error'><span>Riempi tutti i campi correttamente</span></div>";
                }
            ?>
            <form name='prenotazione' method='post' enctype="multipart/form-data" autocomplete="off">
                <div class="ristorante">
                    <select name='ristorante' placeholder='Ristorante'>
                    <option value='selezione' disabled <?php if(!isset($_POST["ristorante"])){echo 'selected';} ?>> Seleziona il ristorante </option>
                        <option value='Ristorante Baronessa' <?php if(isset($_POST["ristorante"])  && $_POST["ristorante"]== 'Ristorante Baronessa'){echo 'selected';} ?>> Ristorante Baronessa </option>
                        <option value='Ristorante Granduca' <?php if(isset($_POST["ristorante"]) && $_POST["ristorante"] == 'Ristorante Granduca'){echo 'selected';} ?>> Ristorante Granduca </option>
                        <option value='Ristorante Villa Antonio' <?php if(isset($_POST["ristorante"]) && $_POST["ristorante"]== 'Ristorante Villa Antonio'){echo 'selected';} ?>> Ristorante Villa Antonio </option>
                        <option value='Ristorante Mazzarò' <?php if(isset($_POST["ristorante"]) && $_POST["ristorante"]== 'Ristorante Mazzarò'){echo 'selected';} ?>> Ristorante Mazzaro' </option>
                        <option value='Ristorante Taormina' <?php if(isset($_POST["ristorante"]) && $_POST["ristorante"]== 'Ristorante Taormina'){echo 'selected';} ?>> Ristorante Taormina</option>
                        <option value='Ristorante Al Duomo' <?php if(isset($_POST["ristorante"]) && $_POST["ristorante"]== 'Ristorante Al Duomo'){echo 'selected';} ?>> Ristorante Al Duomo </option>
                        <option value='Ristorante Al Saraceno' <?php if(isset($_POST["ristorante"]) && $_POST["ristorante"]== 'Ristorante Al Saraceno'){echo 'selected';} ?>> Ristorante Al Saraceno </option>
                        <option value='Ristorante Le Terrazze' <?php if(isset($_POST["ristorante"]) && $_POST["ristorante"]== 'Ristorante Le Terrazze'){echo 'selected';} ?>> Ristorante Le Terrazze </option>
                        <option value='Ristorante Baia Taormina' <?php if(isset($_POST["ristorante"]) && $_POST["ristorante"]== 'Ristorante Baia Taormina'){echo 'selected';} ?>> Ristorante Baia Taormina </option>
                    </select>
                    <span></span>
                </div>
                <div class="cognome">
                    <input type='text' name='cognome' placeholder='Cognome'<?php if(isset($_POST["cognome"])){echo "value=".$_POST["cognome"];} if (controlloAutorizzazione()){echo "value=".$_SESSION["ristoranti_scandura_cognome"];} ?> >
                </div>
                <div class="persone">
                    <input type='number' name='numero_persone' min='1' placeholder='Numero di Persone'<?php if(isset($_POST["numero_persone"])){echo "value=".$_POST["numero_persone"];} ?>>
                </div>
                <div class="telefono">
                    <input type='text' name='telefono' placeholder='Numero di telefono'<?php if(isset($_POST["telefono"])){echo "value=".$_POST["telefono"];} ?> >
                </div>
                <div class="data-ora">
                    <input type='date' min="<?php echo date("Y-m-d");?>" max="2022-01-01" name='data' <?php if(isset($_POST["data"])){echo "value=".$_POST["data"];} ?>>
                    <input type='time' name='ora' <?php if(isset($_POST["ora"])){echo "value=".$_POST["ora"];} ?>>
                </div>
                <div class="bottone">
                    <input type='submit' value="Prenota il tavolo" id="submit">
                </div>
            </form>
            <div class="link2"><a href="mhw1.php">Homepage</a></div>
        </section>
    </body>
</html>