<?php
    $queryString = http_build_query([
        'access_key' => '717fb1d91d0cced93c2b96eee3785c7d',
        'keywords' => 'covid-ristoranti-riaperture',
        'languages' => 'it',
        'limit' => '50',
      ]);
      
      $curl = curl_init(sprintf('%s?%s', 'http://api.mediastack.com/v1/news', $queryString));
      curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
      
      $json = curl_exec($curl);
      curl_close($curl);
      echo($json);
?>