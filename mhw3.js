let results;
var i = 0;


function CaricaImmagine()
{
	return results[0].largeImageURL;
}


function VaiAvanti(event){
	if(i !== 34)
	{
	const immagine = event.currentTarget.parentNode.querySelector('.immagine');
	i++;
	if(results[i].id === 4787545)
		i++;
	if(results[i].id === 142556)
		i++;
	if(results[i].id === 142568)
		i++;
	if(results[i].id === 1723479)
		i++;
	if(results[i].id === 2070828)
		i++;
	if(results[i].id === 5058956)
		i++;
	if(results[i].id === 3287147)
		i++;
	immagine.src = results[i].largeImageURL;
	}
}


function VaiIndietro(event){
	if(i !== 0)
	{
	const immagine = event.currentTarget.parentNode.querySelector('.immagine');
	i--;
	if(results[i].id === 4787545)
		i--;
	if(results[i].id === 2070828)
		i--;
	if(results[i].id === 142556)
		i--;
	if(results[i].id === 142568)
		i--;
	if(results[i].id === 1723479)
		i--;
	if(results[i].id === 5058956)
		i++;
	if(results[i].id === 3287147)
		i--;
	immagine.src = results[i].largeImageURL;
	}
}


function onJson_img(json) {
	const contenuti = document.querySelector('#contenuto');
	contenuti.innerHTML = '';
	results = json.hits;
	const img = document.createElement('img');
	img.classList.add('immagine');
	const immagine = CaricaImmagine();
	img.src = immagine;
	const avanti = document.createElement('div');
	avanti.classList.add('avanti_indietro');
	const img_destra = document.createElement('img');
	img_destra.classList.add("Frecce");
	img_destra.src = "Freccia_Destra.png";
	avanti.appendChild(img_destra);
	avanti.addEventListener('click', VaiAvanti);
	const indietro = document.createElement('div');
	indietro.classList.add('avanti_indietro');
	const img_sinistra = document.createElement('img');
	img_sinistra.classList.add("Frecce")
	img_sinistra.src = "Freccia_Sinistra.png";
	indietro.appendChild(img_sinistra);
	indietro.addEventListener('click', VaiIndietro);
	const contenuto = document.createElement('div');

	contenuto.appendChild(indietro);
	contenuto.appendChild(img);
	contenuto.appendChild(avanti);
	contenuti.appendChild(contenuto);
}


function onResponse(response) {
	return response.json();
}
if(document.querySelector('#contenuto'))
	fetch('http://localhost/Sito/api_immagini.php').then(onResponse).then(onJson_img);


function FermaNotizie(event)
{
	const sezione = event.currentTarget.parentNode;
	sezione.stop();
}


function AttivaNotizie(event)
{
	const sezione = event.currentTarget.parentNode;
	sezione.start();
}


function onJsonNews(json)
{ 
  let notizie = document.querySelector('#news');
  for (let i = 0; i < 50; i++)
  {       
      const notizia = document.createElement('div');

      let tit = document.createElement('h1');
	  tit.textContent = json.data[i].title + ':';

      let link= document.createElement('a');
      
      link.textContent = 'Leggi la notizia';
	  link.setAttribute('target','_blank');
      link.addEventListener('click', function(){
      link.href=json.data[i].url;
	  fetch("http://localhost/Sito/aggiungi_link.php?link="+json.data[i].url+"&titolo="+json.data[i].title);
	  });

      notizia.classList.add('notizia');
        
      notizia.appendChild(tit);
	  notizia.appendChild(link);
      notizie.appendChild(notizia);
	  notizie.addEventListener('mouseover', FermaNotizie);
	  notizie.addEventListener('mouseout', AttivaNotizie);
	}
}


function onResponseNews(response){
	return response.json();
}
fetch('http://localhost/Sito/api_news.php').then(onResponseNews).then(onJsonNews);


function onJsonMenu(json)
{
	const contenuti_menu = document.querySelector('#contenuti_menu');
	contenuti_menu.innerHTML = '';
	const img = document.createElement('img');
	img.classList.add('immagine');
	img.src = json;
	img.addEventListener('click', apriModale);
	const contenuto = document.createElement('div');

	contenuto.appendChild(img);
	contenuti_menu.appendChild(contenuto);
}

function onResponseMenu(response){
	return response.json();
}
function caricaMenu(event)
{
	fetch("http://localhost/Sito/carica_menu.php?q="+event.currentTarget.value).then(onResponseMenu).then(onJsonMenu);
}


if(document.querySelector('#contenuti_menu'))
{
	const selezione = document.querySelector('select');
	selezione.addEventListener('change', caricaMenu);
}


function chiudiModale(event) {
		modale.classList.add('hidden');
		img = modale.querySelector('img');
		img.remove();
	    document.body.classList.remove('no-scroll');
}
if(document.querySelector('#contenuti_menu'))
	window.addEventListener('keydown', chiudiModale);
	   
 function apriModale(event) {
	const image = document.createElement('img');
	image.src = event.currentTarget.src;
	const modale = document.querySelector('#modale');
	modale.addEventListener('click', chiudiModale);
	modale.appendChild(image);
	modale.classList.remove('hidden');
	document.body.classList.add('no-scroll');
}
	   




