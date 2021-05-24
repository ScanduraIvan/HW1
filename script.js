function rimuoviPreferitoVettore(id){
    for(let i=0; i < vettore_preferiti.length; i++)
      if(vettore_preferiti[i].id == id){
      vettore_preferiti.splice(i, 1);
      break;}
}



function RimuoviPreferito(event){
    const preferiti = document.querySelector('#preferiti');
    const preferito = event.currentTarget.parentNode.parentNode;
    preferiti.removeChild(preferito);

    fetch('http://localhost/Sito/rimuovi_preferiti.php?q='+ preferito.id);
    rimuoviPreferitoVettore(preferito.id);
    const scritta = document.querySelector('h1');
    if(preferiti.childElementCount === 0)
    {
        preferiti.classList.add('hidden');
        scritta.classList.add('hidden');
    }
}



function caricaPreferito(j, json){
    const contenuto = document.createElement('div');
    contenuto.id = json[j].codice_ristorante;

    const titolo_preferiti = document.createElement('div');
    const title = document.createElement('h1');
    title.textContent = json[j].nome_ristorante;

    const pre = document.createElement('img');
    pre.src = rimuovi;
    pre.addEventListener('click', RimuoviPreferito);

    titolo_preferiti.appendChild(title);
    titolo_preferiti.appendChild(pre);
    contenuto.appendChild(titolo_preferiti);

    const image = document.createElement('img');
    image.src = json[j].immagine;
    image.classList.add('immagine');
    contenuto.appendChild(image);

    const descr = document.createElement('p');
    descr.textContent = json[j].descrizione;
    descr.classList.add('descrizione');
    contenuto.appendChild(descr);
    return contenuto;
}


function onJson1(json){ 
    if(json !== 1)
    {
    const preferiti = document.querySelector('#preferiti');
    const scritta = document.querySelector('#pre');
    preferiti.classList.add('pref');

    if(json.length !== 0)
    {
        preferiti.classList.remove('hidden');
        scritta.classList.remove('hidden');
    }

    for (let i = 0; i < json.length; i++) { 
    const preferito = caricaPreferito(i, json);

    vettore_preferiti.push(preferito);
    preferiti.appendChild(preferito);
    numero_preferiti++;
    }
    }
}
function onResponse1(response){
    return response.json();
}
fetch("http://localhost/Sito/carica_preferiti.php").then(onResponse1).then(onJson1);


function creaPreferitoDinamico(preferitoDaAggiungere)
{
    const contenuto = document.createElement('div');
    contenuto.id = preferitoDaAggiungere.id;

    const titolo_preferiti = document.createElement('div');
    const title = document.createElement('h1');
    title.textContent = preferitoDaAggiungere.querySelector("h1").textContent;

    const pre = document.createElement('img');
    pre.src = rimuovi;
    pre.addEventListener('click', RimuoviPreferito);

    titolo_preferiti.appendChild(title);
    titolo_preferiti.appendChild(pre);
    contenuto.appendChild(titolo_preferiti);

    const image = document.createElement('img');
    image.src = preferitoDaAggiungere.querySelector(".immagine").src;
    image.classList.add('immagine');
    contenuto.appendChild(image);

    const descr = document.createElement('p');
    descr.textContent = preferitoDaAggiungere.querySelector(".descrizione").textContent;
    descr.classList.add('descrizione');
    contenuto.appendChild(descr);
    return contenuto;
}



function AggiungiPreferiti(event){
    const preferiti = document.querySelector('#preferiti');
    const preferito = event.currentTarget.parentNode.parentNode;
    for(let i = 0; i < vettore_preferiti.length; i++)
        if(vettore_preferiti[i].id === preferito.id)
            return;

    preferiti.classList.add('pref');
    const scritta = document.querySelector('#pre');
    scritta.classList.remove('hidden');
    if(preferiti.classList.contains('hidden'))
        preferiti.classList.remove('hidden');

    fetch("http://localhost/Sito/aggiungi_preferiti.php?q="+preferito.id);

    const preferito_aggiunto = creaPreferitoDinamico(preferito);
    preferito_aggiunto.id = preferito.id;
    vettore_preferiti.push(preferito_aggiunto);
    preferiti.appendChild(preferito_aggiunto);
    numero_preferiti++;
}



function MenoDettagli(event) {
    const tasto = event.currentTarget;
    tasto.textContent = piu_dettagli;
    tasto.classList.add('piu_dettagli');
    tasto.classList.remove('meno_dettagli');
    tasto.removeEventListener('click', MenoDettagli);
    tasto.addEventListener('click', MostraDettagli);
    const dettagli = tasto.parentNode.querySelector('.descrizione');
    dettagli.classList.add("hidden");
}


function MostraDettagli(event) {
    const tasto = event.currentTarget;
    tasto.textContent = meno_dettagli;
    tasto.classList.remove('piu_dettagli');
    tasto.classList.add('meno_dettagli');
    tasto.removeEventListener('click', MostraDettagli);
    tasto.addEventListener('click', MenoDettagli);
    const dettagli = tasto.parentNode.querySelector('.descrizione');
    dettagli.classList.remove("hidden");
}


function CreaContenuto(json) {
    let contenuti=document.querySelector("#contenuti");

    for(let i=0; i < json.length ;i++){
    const contenuto = document.createElement('div');
    contenuto.id = json[i].id_ristorante;

    const titolo_preferiti = document.createElement('div');
    const nome = document.createElement('h1');
    nome.textContent = json[i].nome_ristorante;
    const preferiti = document.createElement('img');
    preferiti.src = stella;
    preferiti.addEventListener('click', AggiungiPreferiti);
    titolo_preferiti.appendChild(nome);
    titolo_preferiti.appendChild(preferiti);
    contenuto.appendChild(titolo_preferiti);
    const image = document.createElement('img');
    image.src = json[i].immagine;
    image.classList.add('immagine');
    contenuto.appendChild(image);
    const descr = document.createElement('p');
    descr.textContent = json[i].descrizione;
    descr.classList.add('hidden');
    descr.classList.add('descrizione');
    contenuto.appendChild(descr);
    const piu_dett = document.createElement('p');
    piu_dett.textContent = piu_dettagli;
    piu_dett.classList.add('piu_dettagli');
    piu_dett.addEventListener('click', MostraDettagli);
    contenuto.appendChild(piu_dett);
    contenuti.appendChild(contenuto);
    }
}
function onResponse(response){
    return response.json();
}
fetch("http://localhost/Sito/carica_contenuti.php").then(onResponse).then(CreaContenuto);


function Ricerca(event){
    var i = 0;
    const barraDiRicerca = event.currentTarget;
    const cont = document.querySelector('#contenuti');
    const lista = cont.querySelectorAll('h1');
    for(elemento of lista)
    {
        if(elemento.textContent.toLowerCase().search(barraDiRicerca.value.toLowerCase()) === -1)
        {
            elemento.parentNode.parentNode.classList.add("hidden");
            i++;
        }
            else
                elemento.parentNode.parentNode.classList.remove("hidden");
    }
    if (i === 9)
        cont.classList.add("vuoto");
        else
            cont.classList.remove("vuoto");
    if (i === 7 || i === 5 || i === 3 || i === 1)
        cont.classList.add("content");
        else
            cont.classList.remove("content");
}


const barraDiRicerca = document.querySelector('input[type="text"]');
barraDiRicerca.addEventListener('keyup', Ricerca);

const contenuti = document.querySelector('#contenuti');

let numero_preferiti=0;
let vettore_preferiti=[];