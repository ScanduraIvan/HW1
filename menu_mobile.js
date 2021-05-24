function chiudiMenu(event){
    const links = document.querySelector('#links-menu');
    links.classList.add('hidden');
    menu.removeEventListener('click', chiudiMenu);
    menu.addEventListener('click', apriMenu);
}


function apriMenu(event){
    const links = document.querySelector('#links-menu');
    links.classList.remove('hidden');
    menu.removeEventListener('click', apriMenu);
    menu.addEventListener('click', chiudiMenu);
}

const menu = document.querySelector('#menu');
menu.addEventListener('click', apriMenu);