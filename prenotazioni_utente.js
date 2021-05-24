function caricaPrenotazione(j, json){
    const prenotazione = document.createElement('div');
    prenotazione.classList.add('prenotazione')

    const nome_ristorante = document.createElement('h1');
    nome_ristorante.textContent = json[j].ristorante;

    const data_ora = document.createElement('div');
    const data = document.createElement('p');
    data.textContent = json[j].data;
    const ora = document.createElement('p');
    ora.textContent = json[j].ora;

    data_ora.appendChild(data);
    data_ora.appendChild(ora);

    prenotazione.appendChild(nome_ristorante);
    prenotazione.appendChild(data_ora);

    const numero_persone = document.createElement('p');
    numero_persone.textContent = "Numero Persone: " +json[j].numero_persone;
    prenotazione.appendChild(numero_persone);
    return prenotazione;
}


function onJson(json){ 
    for (let i = 0; i < json.length; i++) { 
        const prenotazione = caricaPrenotazione(i, json);
        prenotazioni.appendChild(prenotazione);
}
}
function onResponse(response){
    return response.json();
}
fetch("http://localhost/Sito/carica_prenotazioni.php").then(onResponse).then(onJson);
const prenotazioni = document.querySelector('#prenotazioni');