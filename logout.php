<?php
    session_start();
    session_destroy();

    header('Location: mhw1.php');
?>