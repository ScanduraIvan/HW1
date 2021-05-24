function jsonControlloUsername(json) {
    if (formStatus.username = !json.exists) {
        document.querySelector('.username').classList.remove('error');
    } else {
        document.querySelector('.username span').textContent = "Nome utente già utilizzato";
        document.querySelector('.username').classList.add('error');
    }
    checkForm();
}

function jsonControlloEmail(json) {
    if (formStatus.email = !json.exists) {
        document.querySelector('.email').classList.remove('error');
    } else {
        document.querySelector('.email span').textContent = "Email già utilizzata";
        document.querySelector('.email').classList.add('error');
    }
    checkForm();
}

function fetchResponse(response) {
    if (!response.ok) return null;
    return response.json();
}

function controlloUsername(event) {
    const input = document.querySelector('.username input');

    if(!/^[a-zA-Z0-9_]{1,15}$/.test(input.value)) {
        input.parentNode.querySelector('span').textContent = "Username non valido: Max 15 caratteri";
        input.parentNode.classList.add('error');
        formStatus.username = false;
        checkForm();
    } else {
        fetch("controlloUsername.php?q="+encodeURIComponent(input.value)).then(fetchResponse).then(jsonControlloUsername);
        input.parentNode.querySelector('span').textContent = "";
    }    
}

function controlloEmail(event) {
    const emailInput = document.querySelector('.email input');
    if(!/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(String(emailInput.value).toLowerCase())) {
        document.querySelector('.email span').textContent = "Email non valida";
        document.querySelector('.email').classList.add('error');
        formStatus.email = false;
        checkForm();
    } else {
        fetch("controlloEmail.php?q="+encodeURIComponent(String(emailInput.value).toLowerCase())).then(fetchResponse).then(jsonControlloEmail);
        document.querySelector('.email span').textContent = "";
    }
}

function controlloPassword(event) {
    const passwordInput = document.querySelector('.password input');
    if (formStatus.password = passwordInput.value.length >= 8) {
        document.querySelector('.password').classList.remove('error');
        document.querySelector('.password span').textContent = "";
    } else {
        document.querySelector('.password').classList.add('error');
        document.querySelector('.password span').textContent = "Password non valida: Min 8 caratteri";
    }
    checkForm();
}

function controlloConfermaPassword(event) {
    const confermaPasswordInput = document.querySelector('.conferma_password input');
    if (formStatus.confermaPassord = confermaPasswordInput.value === document.querySelector('.password input').value) {
        document.querySelector('.conferma_password').classList.remove('error');
        document.querySelector('.conferma_password span').textContent = "";
    } else {
        document.querySelector('.conferma_password').classList.add('error');
        document.querySelector('.conferma_password span').textContent = "Le password non coincidono";
    }
    checkForm();
}


function checkForm() {
    Object.keys(formStatus).length !== 6 || 
    Object.values(formStatus).includes(false);
}

const formStatus = {'upload': true};
document.querySelector('.username input').addEventListener('blur', controlloUsername);
document.querySelector('.email input').addEventListener('blur', controlloEmail);
document.querySelector('.password input').addEventListener('blur', controlloPassword);
document.querySelector('.conferma_password input').addEventListener('blur', controlloConfermaPassword);

if (document.querySelector('.error') !== null) {
    controlloUsername(); controlloPassword(); controlloConfermaPassword(); controlloEmail();
}