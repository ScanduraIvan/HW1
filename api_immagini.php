<?php
    $queryString = http_build_query([
        'key' => '21214246-ac09f479e5828615df7f0c53e',
        'q' => 'Taormina',
        'per_page' => '50',
      ]);
      
      $curl = curl_init(sprintf('%s?%s', 'https://pixabay.com/api/', $queryString));
      curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
      
      $json = curl_exec($curl);
      curl_close($curl);
      echo($json);
?>