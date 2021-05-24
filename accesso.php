<?php
         include 'autorizzazione.php';
         if (controlloAutorizzazione()) {
             header('Location: mhw1.php');
             exit;
         }
    
        if (!empty($_POST["username"]) && !empty($_POST["password"]) )
        {
            $conn = mysqli_connect('localhost', 'root', '', 'gestione_ristoranti') or die(mysqli_error($conn));

            $username = mysqli_real_escape_string($conn, $_POST['username']);
            $password = mysqli_real_escape_string($conn, $_POST['password']);

            $searchField = filter_var($username, FILTER_VALIDATE_EMAIL) ? "email" : "username";
            $query = "SELECT username, password, cognome FROM utente WHERE $searchField = '$username'";

            $res = mysqli_query($conn, $query) or die(mysqli_error($conn));
            if (mysqli_num_rows($res) > 0) {

                $entry = mysqli_fetch_assoc($res);
                if (password_verify($_POST['password'], $entry['password'])) {
                    $_SESSION["ristoranti_scandura_utente"] = $entry['username'];
                    $_SESSION["ristoranti_scandura_cognome"] = $entry['cognome'];
                    header("Location: mhw1.php");
                    mysqli_free_result($res);
                    mysqli_close($conn);
                    exit;
                }
            }
            $error = "Username e/o password errati";
        }
        else if (isset($_POST["username"]) || isset($_POST["password"])) {
            $error = "Inserisci username e password";
        }
?>

<html>
    <head>
        <link rel='stylesheet' href='accesso.css'>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Unicase:wght@500&family=PT+Serif&family=Cormorant+Garamond:wght@600&family=Cormorant:wght@700&family=Spectral:ital,wght@1,300&family=Varela+Round&display=swap" rel="stylesheet">
        <title>Ristoranti Scandura - Accedi</title>
    </head>
    <body>
        <section class="accesso">
        <div id="logo">
          Ristoranti 
          <img id="rs-logo" src="Logo.png" />
          Scandura
        </div>
            <?php
                if (isset($error)) {
                    echo "<div id='errore'><span class='error'>$error</span></div>";
                }
            ?>
            <form name='login' method='post'>
                <div class="username">
                    <div><input type='text' name='username' placeholder='Username o Email'<?php if(isset($_POST["username"])){echo "value=".$_POST["username"];} ?>></div>
                </div>
                <div class="password">
                    <div><input type='password' name='password' placeholder = 'Password'<?php if(isset($_POST["password"])){echo "value=".$_POST["password"];} ?>></div>
                </div>
                <div class="bottone">
                    <input type='submit' value="Accedi">
                </div>
            </form>
            <div class="link1">Non hai un account? <a href="iscrizione.php">Iscriviti</a></div>
            <div class="link2"><a href="mhw1.php">Homepage</a></div>
        </section>
    </body>
</html>