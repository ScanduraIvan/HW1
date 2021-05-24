<?php
    session_start();
    
    function controlloAutorizzazione() {
        if(isset($_SESSION['ristoranti_scandura_utente'])) {
            return $_SESSION['ristoranti_scandura_utente'];
        } else 
            return 0;
    }
?>