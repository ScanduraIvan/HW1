<?php
    require_once 'autorizzazione.php';

    if (controlloAutorizzazione()) {
        header("Location: mhw1.php");
        exit;
    }   

    if (!empty($_POST["username"]) && !empty($_POST["password"]) && !empty($_POST["email"]) && !empty($_POST["nome"]) && 
        !empty($_POST["cognome"]) && !empty($_POST["conferma_password"]))
    {
        $error = array();
        $conn = mysqli_connect('localhost', 'root', '', 'gestione_ristoranti') or die(mysqli_error($conn));

        
        if(!preg_match('/^[a-zA-Z0-9_]{1,15}$/', $_POST['username'])) {
            $error[] = "Username non valido";
        } else {
            $username = mysqli_real_escape_string($conn, $_POST['username']);

            $query = "SELECT username FROM utente WHERE username = '$username'";
            $res = mysqli_query($conn, $query);
            if (mysqli_num_rows($res) > 0) {
                $error[] = "Username già utilizzato";
            }
        }

        if (strlen($_POST["password"]) < 8) {
            $error[] = "Caratteri password insufficienti";
        } 

        if (strcmp($_POST["password"], $_POST["conferma_password"]) != 0) {
            $error[] = "Le password non coincidono";
        }

        if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
            $error[] = "Email non valida";
        } else {
            $email = mysqli_real_escape_string($conn, strtolower($_POST['email']));
            $res = mysqli_query($conn, "SELECT email FROM utente WHERE email = '$email'");
            if (mysqli_num_rows($res) > 0) {
                $error[] = "Email già utilizzata";
            }
        }

        if (count($error) == 0) {
            $nome = mysqli_real_escape_string($conn, $_POST['nome']);
            $cognome = mysqli_real_escape_string($conn, $_POST['cognome']);

            $password = mysqli_real_escape_string($conn, $_POST['password']);
            $password = password_hash($password, PASSWORD_BCRYPT);

            $query = "INSERT INTO utente(username, password, nome, cognome, email) VALUES('$username', '$password', '$nome', '$cognome', '$email')";
            
            if (mysqli_query($conn, $query)) {
                $_SESSION["ristoranti_scandura_utente"] = $_POST["username"];
                $_SESSION["ristoranti_scandura_cognome"] = $_POST['cognome'];
                mysqli_close($conn);
                header("Location: mhw1.php");
                exit;
            } else {
                $error[] = "Errore di connessione al Database";
            }
        }

        mysqli_close($conn);
    }
    else if (isset($_POST["username"])) {
        $error = "Riempi tutti i campi";
    }
?>


<html>
    <head>
        <link rel='stylesheet' href='iscrizione.css'>
        <script src='iscrizione.js' defer></script>

        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta charset="utf-8">

        <title>Ristoranti Scandura - Iscriviti</title>
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
            <form name='iscrizione' method='post' enctype="multipart/form-data" autocomplete="off">
                <div class="nome">
                    <input type='text' name='nome' placeholder='Nome'<?php if(isset($_POST["nome"])){echo "value=".$_POST["nome"];} ?> >
                </div>
                <div class="cognome">
                    <input type='text' name='cognome' placeholder='Cognome'<?php if(isset($_POST["cognome"])){echo "value=".$_POST["cognome"];} ?> >
                </div>
                <div class="username">
                    <input type='text' name='username' placeholder='Username'<?php if(isset($_POST["username"])){echo "value=".$_POST["username"];} ?>>
                     <span></span>
                </div>
                <div class="email">
                    <input type='text' name='email' placeholder='Email'<?php if(isset($_POST["email"])){echo "value=".$_POST["email"];} ?>>
                     <span></span>
                </div>
                <div class="password">
                    <input type='password' name='password' placeholder='Password'<?php if(isset($_POST["password"])){echo "value=".$_POST["password"];} ?>>
                    <span></span>
                </div>
                <div class="conferma_password">
                    <input type='password' name='conferma_password' placeholder='Conferma Password'<?php if(isset($_POST["conferma_password"])){echo "value=".$_POST["conferma_password"];} ?>>
                    <span></span>
                </div>
                <div class="bottone">
                    <input type='submit' value="Registrati" id="submit">
                </div>
            </form>
            <div class="link1">Hai un account? <a href="accesso.php">Accedi</a></div>
            <div class="link2"><a href="mhw1.php">Homepage</a></div>
        </section>
    </body>
</html>