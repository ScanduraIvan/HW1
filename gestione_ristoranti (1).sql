-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Mag 24, 2021 alle 20:16
-- Versione del server: 10.4.14-MariaDB
-- Versione PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gestione_ristoranti`
--

DELIMITER $$
--
-- Procedure
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `OPERAZIONE1` (IN `nome_ristorante` VARCHAR(255))  BEGIN 
	DROP TEMPORARY TABLE IF EXISTS TMP;
    
    CREATE TEMPORARY TABLE TMP(
		codice INTEGER,
        cf CHAR(16),
        nome VARCHAR(255),
        cognome VARCHAR(255),
        data_nascita DATE,
        eta INTEGER,
        codice_ristorante INTEGER
	);
    
    INSERT INTO TMP
    SELECT C.*
	FROM CAMERIERE C JOIN RISTORANTE R ON C.ristorante = R.codice
	WHERE R.nome = nome_ristorante AND C.codice IN (SELECT cameriere
												FROM ORDINAZIONE
												WHERE somma_totale > 20);
	
    SELECT * FROM TMP;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `OPERAZIONE2` ()  BEGIN 
	DROP TEMPORARY TABLE IF EXISTS NUMERO_PRENOTAZIONI;
    
    CREATE TEMPORARY TABLE NUMERO_PRENOTAZIONI(
		codice_ristorante INTEGER PRIMARY KEY,
		nome_ristorante VARCHAR(255),
		numero_prenotazioni_attuali INTEGER,
		numero_prenotazioni_passate INTEGER
	);
    
    -- PRENOTAZIONI ATTUALI
	INSERT INTO NUMERO_PRENOTAZIONI (codice_ristorante, nome_ristorante, numero_prenotazioni_attuali)
	SELECT R.codice, R.nome, COUNT(*) 
	FROM (PRENOTAZIONE P JOIN TAVOLO T ON P.tavolo = T.numero AND P.ristorante = T.ristorante) JOIN RISTORANTE R ON R.codice = T.ristorante
	WHERE P.fine_occupazione IS NULL
	GROUP BY R.codice, R.nome;
    
    -- PRENOTAZIONI PASSATE
	SET @x = 1;
	WHILE @x <= (SELECT MAX(codice_ristorante) FROM NUMERO_PRENOTAZIONI) 
	DO 
	UPDATE NUMERO_PRENOTAZIONI 
	SET numero_prenotazioni_passate = ( SELECT count(*) as numero_prenotazioni_passate
										FROM (PRENOTAZIONE P JOIN TAVOLO T ON P.tavolo = T.numero AND P.ristorante = T.ristorante) 
										JOIN RISTORANTE R ON R.codice = T.ristorante
                                        WHERE R.codice =  @x AND P.fine_occupazione IS NOT NULL)
	WHERE codice_ristorante = @x;
	SET @x = @x + 1; 
	END WHILE;
    
    SELECT * FROM NUMERO_PRENOTAZIONI;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `OPERAZIONE3` (IN `codice_prenotazione` INTEGER, IN `codice_tavolo` INTEGER, IN `codice_ristorante` INTEGER, IN `nuova_data_prenotazione` DATE, IN `nuova_ora_prenotazione` TIME)  BEGIN 
	UPDATE PRENOTAZIONE 
    SET data = nuova_data_prenotazione
    WHERE codice = codice_prenotazione AND tavolo = codice_tavolo AND ristorante = codice_ristorante;
    
    UPDATE PRENOTAZIONE
    SET ora = 
    CASE 
		WHEN NOT EXISTS (SELECT * FROM PRENOTAZIONE WHERE tavolo = codice_tavolo AND ristorante = codice_ristorante AND 
						data = nuova_data_prenotazione AND ora = nuova_ora_prenotazione)
			THEN nuova_ora_prenotazione
		ELSE
			ADDTIME(nuova_ora_prenotazione, '01:30:00')
    END 
    WHERE codice = codice_prenotazione AND tavolo = codice_tavolo AND ristorante = codice_ristorante;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `OPERAZIONE4` (IN `numero_tavolo` INTEGER, IN `codice_ristorante` INTEGER)  BEGIN 
    
    DROP TEMPORARY TABLE IF EXISTS TMP;
    
	CREATE TEMPORARY TABLE TMP(
		codice_ordinazione INTEGER,
        codice_prenotazione INTEGER,
        numero_tavolo INTEGER,
        ristorante INTEGER,
        numero_bevande_ordinati INTEGER,
        numero_piatti_ordinati INTEGER
	);
    
    INSERT INTO TMP
    SELECT CB.codice_ordinazione, CB.codice_prenotazione, CB.numero_tavolo, CB.ristorante, sum(CB.quantita) as numero_bevande_ordinati, 
	MO.numero_piatti_ordinati
	FROM ORDINAZIONI_BEVANDE CB LEFT JOIN MANGIARE_ORDINAZIONI MO ON CB.codice_ordinazione = MO.codice_ordinazione AND 
	CB.codice_prenotazione = MO.codice_prenotazione AND CB.numero_tavolo = MO.numero_tavolo AND CB.ristorante = MO.ristorante
	WHERE CB.numero_tavolo = numero_tavolo AND CB.ristorante = codice_ristorante
	GROUP BY CB.codice_ordinazione, CB.codice_prenotazione, CB.numero_tavolo, CB.ristorante;
    
    SELECT * FROM TMP;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `bevanda`
--

CREATE TABLE `bevanda` (
  `codice` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `prezzo` float DEFAULT NULL,
  `tipologia` varchar(255) DEFAULT NULL,
  `volume` int(11) DEFAULT NULL,
  `anno_produzione` int(11) DEFAULT NULL,
  `gradazione` float DEFAULT NULL,
  `qualita` varchar(255) DEFAULT NULL,
  `scadenza` date DEFAULT NULL,
  `descrizione` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `bevanda`
--

INSERT INTO `bevanda` (`codice`, `nome`, `prezzo`, `tipologia`, `volume`, `anno_produzione`, `gradazione`, `qualita`, `scadenza`, `descrizione`) VALUES
(1, 'Coca Cola', 3, 'bevanda analcolica', 330, 2020, NULL, NULL, NULL, NULL),
(2, 'Fanta', 3, 'bevanda analcolica', 330, 2020, NULL, NULL, NULL, NULL),
(3, 'Acqua naturale', 2, 'bevanda analcolica', 1000, 2020, NULL, NULL, NULL, NULL),
(4, 'Acqua frizzante', 2, 'bevanda analcolica', 330, 2020, NULL, NULL, NULL, NULL),
(5, 'Birra Moretti', 3, 'birra', 330, 2020, 4.5, 'Bionda', '2023-07-12', NULL),
(6, 'Birra Peroni', 3, 'birra', 330, 2020, 5, 'Bionda', '2023-07-12', NULL),
(7, 'Birra Paul Bricius', 5, 'birra', 330, 2020, 6, 'Scura', '2023-07-12', NULL),
(8, 'Birra Paul Bricius', 9, 'birra', 750, 2020, 6, 'Scura', '2023-07-12', NULL),
(9, 'Maria Costanza', 25, 'Vino rosso', 750, 2015, 14, NULL, NULL, 'Merlot'),
(10, 'Maria Costanza', 19, 'Vino bianco', 750, 2019, 12, NULL, NULL, 'Inzolia');

-- --------------------------------------------------------

--
-- Struttura della tabella `cameriere`
--

CREATE TABLE `cameriere` (
  `codice` int(11) NOT NULL,
  `cf` char(16) DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `cognome` varchar(255) DEFAULT NULL,
  `data_nascita` date DEFAULT NULL,
  `eta` int(11) DEFAULT NULL,
  `ristorante` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `cameriere`
--

INSERT INTO `cameriere` (`codice`, `cf`, `nome`, `cognome`, `data_nascita`, `eta`, `ristorante`) VALUES
(1, 'FHDHHD32D43G643D', 'Maria', 'Franchi', '1992-04-21', 28, 1),
(2, 'DHFEWS56A08D343N', 'Barbara', 'Manuli', '1998-03-02', 22, 1),
(3, 'ADSNMM22A09D321S', 'Fabio', 'Leotta', '2000-03-21', 20, 2),
(4, 'MDMSJD21K99D232D', 'Mario', 'Rossi', '1990-01-19', 30, 2),
(5, 'BMFHDD22D66F398D', 'Paola', 'Grasso', '1996-02-12', 24, 3),
(6, 'MFHQUE32F87E882S', 'Kevin', 'Lo Giudice', '1992-05-12', 28, 3),
(7, 'DJWCNC97W13D324D', 'Leonardo', 'Savoca', '1980-02-16', 40, 4),
(8, 'MCNCDI32D43K948N', 'Alessio', 'Di Mauro', '1987-02-17', 33, 4),
(9, 'NCDJSJ21J45J332J', 'Luigi', 'Leotta', '2001-01-18', 19, 5),
(10, 'ACNEHE88D77D821D', 'Paolo', 'Giorgi', '1988-03-21', 32, 5);

--
-- Trigger `cameriere`
--
DELIMITER $$
CREATE TRIGGER `AGGIORNA_ETA_CAMERIERE` BEFORE INSERT ON `cameriere` FOR EACH ROW BEGIN 
	SET NEW.eta = TIMESTAMPDIFF(YEAR, NEW.data_nascita, CURRENT_DATE());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `contiene_bevanda`
--

CREATE TABLE `contiene_bevanda` (
  `bevanda` int(11) NOT NULL,
  `ordinazione` int(11) NOT NULL,
  `prenotazione` int(11) NOT NULL,
  `tavolo` int(11) NOT NULL,
  `ristorante` int(11) NOT NULL,
  `quantita` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `contiene_ingrediente`
--

CREATE TABLE `contiene_ingrediente` (
  `mangiare` int(11) NOT NULL,
  `ingrediente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `contiene_mangiare`
--

CREATE TABLE `contiene_mangiare` (
  `mangiare` int(11) NOT NULL,
  `ordinazione` int(11) NOT NULL,
  `prenotazione` int(11) NOT NULL,
  `tavolo` int(11) NOT NULL,
  `ristorante` int(11) NOT NULL,
  `quantita` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura della tabella `cuoco`
--

CREATE TABLE `cuoco` (
  `codice` int(11) NOT NULL,
  `cf` char(16) DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `cognome` varchar(255) DEFAULT NULL,
  `data_nascita` date DEFAULT NULL,
  `eta` int(11) DEFAULT NULL,
  `ristorante` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `cuoco`
--

INSERT INTO `cuoco` (`codice`, `cf`, `nome`, `cognome`, `data_nascita`, `eta`, `ristorante`) VALUES
(1, 'SDFERT64R12C345M', 'Dario', 'Sapienza', '1998-05-23', 22, 1),
(2, 'AFDHFG43V32S167N', 'Enrica', 'Spataro', '1999-03-31', 21, 1),
(3, 'RTFNDH35C63S678G', 'Elio', 'Vinciguerra', '2000-01-26', 20, 2),
(4, 'DFNCGD64R78C232D', 'Luigi', 'Scalzo', '1990-03-21', 30, 2),
(5, 'FDGKSL33S78A233P', 'Andrea', 'Bambara', '1996-07-10', 24, 3),
(6, 'DGSNVU43C56S224D', 'Francesco', 'Longo', '1992-09-12', 28, 3),
(7, 'CDLERT34D65C789C', 'Leonardo', 'Curcuruto', '1980-02-21', 40, 4),
(8, 'GFHDCC34S54V543N', 'Alessio', 'Rossi', '1987-03-31', 33, 4),
(9, 'DSFVGR32D45H432C', 'Eleonora', 'Spataro', '2001-03-15', 19, 5),
(10, 'RERFDD33S34F322D', 'Paolo', 'Cullurà', '1964-04-23', 56, 5);

--
-- Trigger `cuoco`
--
DELIMITER $$
CREATE TRIGGER `AGGIORNA_ETA_CUOCO` BEFORE INSERT ON `cuoco` FOR EACH ROW BEGIN 
	SET NEW.eta = TIMESTAMPDIFF(YEAR, NEW.data_nascita, CURRENT_DATE());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `ingrediente`
--

CREATE TABLE `ingrediente` (
  `codice` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `ingrediente`
--

INSERT INTO `ingrediente` (`codice`, `nome`) VALUES
(1, 'Aglio'),
(2, 'Olio'),
(3, 'Cipolla'),
(4, 'Pomodoro ciliegino'),
(5, 'Spinaci'),
(6, 'Carota'),
(7, 'Merluzzo'),
(8, 'Pesce spada'),
(9, 'Patata'),
(10, 'Peperoncino'),
(11, 'Melanzana'),
(12, 'Zucchina'),
(13, 'Salsiccia'),
(14, 'Macinato di vitello'),
(15, 'Sedano'),
(16, 'Salsa di pomodoro ciliegino'),
(17, 'Fagioli rossi'),
(18, 'Piselli'),
(19, 'Farro'),
(20, 'Pesto di basilico'),
(21, 'Uova'),
(22, 'Pecorino romano'),
(23, 'Guanciale'),
(24, 'Pepe nero'),
(25, 'Salsa'),
(26, 'Basilico'),
(27, 'Limone'),
(28, 'Latte');

-- --------------------------------------------------------

--
-- Struttura della tabella `mangiare`
--

CREATE TABLE `mangiare` (
  `codice` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `prezzo` float DEFAULT NULL,
  `portata` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `mangiare`
--

INSERT INTO `mangiare` (`codice`, `nome`, `prezzo`, `portata`) VALUES
(1, 'Spaghetti alla Carbonara', 14, 'Primo'),
(2, 'Rigatoni alla Norma', 14, 'Primo'),
(3, 'Trancio di pesce spada', 20, 'Secondo'),
(4, 'Spaghetti alla salsa', 10, 'Primo'),
(5, 'Polpette di vitello', 18, 'Secondo'),
(6, 'Purea di patate', 6, 'Contorno'),
(7, 'Parmigiana di melanzane', 8, 'Antipasto'),
(8, 'Sorbetto al limone', 4, 'Dolce');

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `mangiare_ordinazioni`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `mangiare_ordinazioni` (
`codice_ordinazione` int(11)
,`codice_prenotazione` int(11)
,`numero_tavolo` int(11)
,`ristorante` int(11)
,`numero_piatti_ordinati` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Struttura della tabella `menu`
--

CREATE TABLE `menu` (
  `ristorante` int(11) NOT NULL,
  `immagine` varchar(1023) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `menu`
--

INSERT INTO `menu` (`ristorante`, `immagine`) VALUES
(1, 'baronessa.jpg'),
(2, 'granduca.jpg'),
(3, 'villa_antonio.jpg'),
(4, 'mazzaro.jpg'),
(5, 'taormina.jpg'),
(6, 'duomo.jpg'),
(7, 'saraceno.jpg'),
(8, 'terrazze.jpg'),
(9, 'baia_taormina.jpg');

-- --------------------------------------------------------

--
-- Struttura della tabella `news_cliccate`
--

CREATE TABLE `news_cliccate` (
  `utente` varchar(255) NOT NULL,
  `link` varchar(511) NOT NULL,
  `titolo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `news_cliccate`
--

INSERT INTO `news_cliccate` (`utente`, `link`, `titolo`) VALUES
('Carlotta', 'https://abruzzoweb.it/covid-dai-ristoranti-alle-palestre-il-cronoprogramma-delle-riaperture/', 'COVID, DAI RISTORANTI ALLE PALESTRE: IL CRONOPROGRAMMA DELLE RIAPERTURE'),
('IvanScandura', 'https://abruzzoweb.it/covid-dai-ristoranti-alle-palestre-il-cronoprogramma-delle-riaperture/', 'COVID, DAI RISTORANTI ALLE PALESTRE: IL CRONOPROGRAMMA DELLE RIAPERTURE'),
('IvanScandura', 'https://abruzzoweb.it/covid-dai-ristoranti-alle-piscine-prima-mappa-delle-riaperture/', 'COVID, DAI RISTORANTI ALLE PISCINE: PRIMA MAPPA DELLE RIAPERTURE'),
('LucioScandura', 'https://abruzzoweb.it/covid-dai-ristoranti-alle-palestre-il-cronoprogramma-delle-riaperture/', 'COVID, DAI RISTORANTI ALLE PALESTRE: IL CRONOPROGRAMMA DELLE RIAPERTURE'),
('LucioScandura', 'https://www.zazoom.it/2021-04-16/covid-riaperture-dei-ristoranti-a-partire-dalla-fine-del-mese/8512661/', 'Covid, riaperture dei ristoranti a partire dalla fine del mese');

-- --------------------------------------------------------

--
-- Struttura della tabella `ordinazione`
--

CREATE TABLE `ordinazione` (
  `codice` int(11) NOT NULL,
  `prenotazione` int(11) DEFAULT NULL,
  `tavolo` int(11) DEFAULT NULL,
  `ristorante` int(11) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `ora` time DEFAULT NULL,
  `somma_totale` float DEFAULT 0,
  `cameriere` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `ordinazione_totale`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `ordinazione_totale` (
`codice_ordinazione` int(11)
,`codice_prenotazione` int(11)
,`numero_tavolo` int(11)
,`ristorante` int(11)
,`data_ordinazione` date
,`ora_ordinazione` time
,`somma_totale_ordinazione` float
,`codice_cameriere` int(11)
,`quantita` int(11)
,`codice_bevanda` int(11)
,`bevanda` varchar(255)
,`prezzo_bevanda` float
,`codice_piatto` int(11)
,`piatto` varchar(255)
,`prezzo_mangiare` float
);

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `ordinazioni_bevande`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `ordinazioni_bevande` (
`codice_ordinazione` int(11)
,`codice_prenotazione` int(11)
,`numero_tavolo` int(11)
,`ristorante` int(11)
,`data_ordinazione` date
,`ora_ordinazione` time
,`somma_totale_ordinazione` float
,`codice_cameriere` int(11)
,`quantita` int(11)
,`codice_bevanda` int(11)
,`bevanda` varchar(255)
,`prezzo_bevanda` float
);

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `ordinazioni_mangiare`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `ordinazioni_mangiare` (
`codice_ordinazione` int(11)
,`codice_prenotazione` int(11)
,`numero_tavolo` int(11)
,`ristorante` int(11)
,`data_ordinazione` date
,`ora_ordinazione` time
,`somma_totale_ordinazione` float
,`codice_cameriere` int(11)
,`quantita` int(11)
,`codice_piatto` int(11)
,`piatto` varchar(255)
,`prezzo_mangiare` float
);

-- --------------------------------------------------------

--
-- Struttura della tabella `preferiti`
--

CREATE TABLE `preferiti` (
  `utente` varchar(255) NOT NULL,
  `codice_ristorante` int(11) NOT NULL,
  `nome_ristorante` varchar(255) DEFAULT NULL,
  `immagine` varchar(255) DEFAULT NULL,
  `descrizione` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `preferiti`
--

INSERT INTO `preferiti` (`utente`, `codice_ristorante`, `nome_ristorante`, `immagine`, `descrizione`) VALUES
('adp10', 1, 'Ristorante Baronessa', ' Ristorante1.jpg', 'Numero telefonico: 0942 620163, Via Corso Umberto, 148, 98039, Taormina, ME'),
('Carlotta', 5, 'Ristorante Taormina', ' Ristorante5.jpg', 'Numero telefonico: 0942 856435, Viale San Pancrazio, 46, 98039, Taormina, ME'),
('IvanScandura', 1, 'Ristorante Baronessa', ' Ristorante1.jpg', 'Numero telefonico: 0942 620163, Via Corso Umberto, 148, 98039, Taormina, ME'),
('IvanScandura', 3, 'Ristorante Villa Antonio', ' Ristorante3.jpg', 'Numero telefonico: 0942 34345, Via Luigi Pirandello, 88, 98039, Taormina, ME'),
('LucioScandura', 1, 'Ristorante Baronessa', ' Ristorante1.jpg', 'Numero telefonico: 0942 620163, Via Corso Umberto, 148, 98039, Taormina, ME'),
('LucioScandura', 6, 'Ristorante Al Duomo', ' Ristorante6.jpg', 'Numero telefonico: 0942 625656, Via degli Ebrei, 1, 98039, Taormina, ME'),
('LucioScandura', 7, 'Ristorante Al Saraceno', ' Ristorante7.jpg', 'Numero telefonico: 0942 62342, Via Madonna della Rocca, 16, 98039, Taormina, ME');

-- --------------------------------------------------------

--
-- Struttura della tabella `prenotazione`
--

CREATE TABLE `prenotazione` (
  `codice` int(11) NOT NULL,
  `tavolo` int(11) DEFAULT NULL,
  `ristorante` int(11) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `ora` time DEFAULT NULL,
  `numero_persone` int(11) DEFAULT NULL,
  `fine_occupazione` time DEFAULT NULL,
  `cognome` varchar(255) NOT NULL,
  `numero_telefono` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `prenotazione`
--

INSERT INTO `prenotazione` (`codice`, `tavolo`, `ristorante`, `data`, `ora`, `numero_persone`, `fine_occupazione`, `cognome`, `numero_telefono`, `username`) VALUES
(1, NULL, 2, '2021-05-31', '21:40:00', 2, NULL, 'Spataro', '34567890976', 'enri_spat'),
(2, NULL, 2, '2021-05-31', '21:05:00', 3, NULL, 'Spataro', '678959806', 'EleonoraSpataro'),
(3, NULL, 2, '2021-06-15', '21:00:00', 5, NULL, 'Scandura', '48321472391', 'IvanScandura'),
(4, NULL, 5, '2021-06-20', '22:00:00', 2, NULL, 'Scandura', '213843874732', 'IvanScandura'),
(5, NULL, 1, '2021-06-10', '21:10:00', 10, NULL, 'Del Piero', '34299412819', 'adp10');

-- --------------------------------------------------------

--
-- Struttura della tabella `ristorante`
--

CREATE TABLE `ristorante` (
  `codice` int(11) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `citta` varchar(255) DEFAULT NULL,
  `indirizzo` varchar(255) DEFAULT NULL,
  `telefono` varchar(255) DEFAULT NULL,
  `immagine` varchar(1023) DEFAULT NULL,
  `descrizione` varchar(1023) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `ristorante`
--

INSERT INTO `ristorante` (`codice`, `nome`, `citta`, `indirizzo`, `telefono`, `immagine`, `descrizione`) VALUES
(1, 'Ristorante Baronessa', 'Taormina', 'Via Corso Umberto, 148', '0942 620163', 'Ristorante1.jpg', 'Numero telefonico: 0942 620163, Via Corso Umberto, 148, 98039, Taormina, ME'),
(2, 'Ristorante Granduca', 'Taormina', 'Via Corso Umberto, 172', '0942 24983', 'Ristorante2.jpg', 'Numero telefonico: 0942 24983, Via Corso Umberto, 172, 98039, Taormina, ME'),
(3, 'Ristorante Villa Antonio', 'Taormina', 'Via Luigi Pirandello, 88', '0942 34345', 'Ristorante3.jpg', 'Numero telefonico: 0942 34345, Via Luigi Pirandello, 88, 98039, Taormina, ME'),
(4, 'Ristorante Mazzarò', 'Taormina', 'Via Mazzarò, 11', '0942 12352', 'Ristorante4.jpg', 'Numero telefonico: 0942 12352, Via Mazzarò, 11, 98039, Taormina, ME'),
(5, 'Ristorante Taormina', 'Taormina', 'Viale San Pancrazio, 46', '0942 856435', 'Ristorante5.jpg', 'Numero telefonico: 0942 856435, Viale San Pancrazio, 46, 98039, Taormina, ME'),
(6, 'Ristorante Al Duomo', 'Taormina', 'Via degli Ebrei, 1', '0942 625656', 'Ristorante6.jpg', 'Numero telefonico: 0942 625656, Via degli Ebrei, 1, 98039, Taormina, ME'),
(7, 'Ristorante Al Saraceno', 'Taormina', 'Via Madonna della Rocca, 16', '0942 62342', 'Ristorante7.jpg', 'Numero telefonico: 0942 62342, Via Madonna della Rocca, 16, 98039, Taormina, ME'),
(8, 'Ristorante Le Terrazze', 'Taormina', 'Via Teatro Greco, 11', '0942 34198', 'Ristorante8.jpg', 'Numero telefonico: 0942 34198, Via Teatro Greco, 11, 98039, Taormina, ME'),
(9, 'Ristorante Baia Taormina', 'Taormina', 'Via Mazzarò, 7', '0942 34288', 'Ristorante9.jpg', 'Numero telefonico: 0942 34288, Via Mazzarò, 7, 98039, Taormina, ME');

-- --------------------------------------------------------

--
-- Struttura della tabella `tavolo`
--

CREATE TABLE `tavolo` (
  `numero` int(11) NOT NULL,
  `ristorante` int(11) NOT NULL,
  `posti` int(11) DEFAULT NULL,
  `descrizione` varchar(255) DEFAULT NULL,
  `tipo` varchar(255) DEFAULT NULL,
  `copertura` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `tavolo`
--

INSERT INTO `tavolo` (`numero`, `ristorante`, `posti`, `descrizione`, `tipo`, `copertura`) VALUES
(1, 1, 6, 'vista mare', 'interno', NULL),
(1, 2, 6, 'vista mare', 'interno', NULL),
(1, 3, 6, 'vista mare', 'interno', NULL),
(1, 4, 6, 'vista mare', 'interno', NULL),
(1, 5, 6, 'vista mare', 'interno', NULL),
(2, 1, 10, 'centrale', 'interno', NULL),
(2, 2, 10, 'centrale', 'interno', NULL),
(2, 3, 10, 'centrale', 'interno', NULL),
(2, 4, 10, 'centrale', 'interno', NULL),
(2, 5, 10, 'centrale', 'interno', NULL),
(3, 1, 10, 'vista mare', 'esterno', 1),
(3, 2, 10, 'vista mare', 'esterno', 1),
(3, 3, 10, 'vista mare', 'esterno', 1),
(3, 4, 10, 'vista mare', 'esterno', 1),
(3, 5, 10, 'vista mare', 'esterno', 1),
(4, 1, 2, 'centrale', 'esterno', 1),
(4, 2, 2, 'centrale', 'esterno', 1),
(4, 3, 2, 'centrale', 'esterno', 1),
(4, 4, 2, 'centrale', 'esterno', 1),
(4, 5, 2, 'centrale', 'esterno', 1),
(5, 1, 8, 'laterale', 'interno', NULL),
(5, 2, 8, 'laterale', 'interno', NULL),
(5, 3, 8, 'laterale', 'interno', NULL),
(5, 4, 8, 'laterale', 'interno', NULL),
(5, 5, 8, 'laterale', 'interno', NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `utente`
--

CREATE TABLE `utente` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `cognome` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dump dei dati per la tabella `utente`
--

INSERT INTO `utente` (`username`, `password`, `nome`, `cognome`, `email`) VALUES
('adp10', '$2y$10$EsXQsLK31IfTfvTaJwcH9uTiARekLAsR4FfG/XdAj5YXAiYxPs0lW', 'Alessandro', 'Del Piero', 'adp10@gmail.com'),
('Bebo', '$2y$10$pw/NbBpAUDbtNa0LaFCwqem1wX0eR/4ei1UIOWkvdssHjWWZCzw4G', 'Luigi', 'Scalzo', 'scalzolu99@gmail.com'),
('Carlotta', '$2y$10$gp6lLaZAROxKicdUrFkyFOzifjuBHjbCrJl398qtHlbRW0woQqKAy', 'Carlotta', 'Malfitana', 'carlotta@gmail.com'),
('DarioGrasso', '$2y$10$lmsLu8hHSgExaC.pNtUTJeDxJbyMIq/cDjF5KNZDbHeZqtEOPJS0y', 'Dario', 'Grasso', 'dariograsso@gmail.com'),
('DariSapi', '$2y$10$UhWPaSTwuva0Dnrb.lSgd.ZlmCzrUjdZCl/BPhQUoUG4YXSjRX7gC', 'Dario', 'Sapienza', 'dariosapienza@gmail.com'),
('EleonoraSpataro', '$2y$10$.85cR2LdsUf1EQV0eEIDIOyYR6SotOJQyY6o5hdi6HLxp4qt9bf0y', 'Eleonora', 'Spataro', 'spataroeleonora29@gmail.com'),
('enri_spat', '$2y$10$y2wHvmR9X4Y/U4FaAEIUO.GDzQpmtNl07CXeuqaSXDPwMKKIV9.lK', 'Enrica', 'Spataro', 'enrica@gmail.com'),
('IvanScandura', '$2y$10$.Vh2Zky9zhTxo8S.5kHIZOsJUJbwYS6Pt2E.bFDn7SJh2.biYktxy', 'Ivan', 'Scandura', 'scanduraivan@gmail.com'),
('LucioScandura', '$2y$10$88G4nhKOkwYj8EsoLo9cvOLgFVkpORBc7X5d2x4tVGyzVu0nYkJJ2', 'Lucio', 'Scandura', 'scanduralucio47@gmail.com'),
('NadiaScandura', '$2y$10$QhkknAIz5.6tEDbRTuKiqeznuh9KnXUObXoH9KEEwz.EItS6JaJTm', 'Nadia', 'Scandura', 'nadiascandura@gmail.com'),
('OrianaAprile', '$2y$10$Kyq29Vcq9zGl42vk7qLo..pOBmCs6wMb6cD5.UVUymobGkNWL7YU2', 'Oriana', 'Aprile', 'orianaprile@gmail.com');

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `v1`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `v1` (
`ristorante` int(11)
,`ora` time
,`numero_prenotazioni` bigint(21)
);

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `v2`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `v2` (
`nome` varchar(255)
,`conteggio` bigint(21)
);

-- --------------------------------------------------------

--
-- Struttura per vista `mangiare_ordinazioni`
--
DROP TABLE IF EXISTS `mangiare_ordinazioni`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mangiare_ordinazioni`  AS SELECT `ordinazioni_mangiare`.`codice_ordinazione` AS `codice_ordinazione`, `ordinazioni_mangiare`.`codice_prenotazione` AS `codice_prenotazione`, `ordinazioni_mangiare`.`numero_tavolo` AS `numero_tavolo`, `ordinazioni_mangiare`.`ristorante` AS `ristorante`, sum(`ordinazioni_mangiare`.`quantita`) AS `numero_piatti_ordinati` FROM `ordinazioni_mangiare` GROUP BY `ordinazioni_mangiare`.`codice_ordinazione`, `ordinazioni_mangiare`.`codice_prenotazione`, `ordinazioni_mangiare`.`numero_tavolo`, `ordinazioni_mangiare`.`ristorante` ;

-- --------------------------------------------------------

--
-- Struttura per vista `ordinazione_totale`
--
DROP TABLE IF EXISTS `ordinazione_totale`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ordinazione_totale`  AS SELECT `o`.`codice` AS `codice_ordinazione`, `o`.`prenotazione` AS `codice_prenotazione`, `o`.`tavolo` AS `numero_tavolo`, `o`.`ristorante` AS `ristorante`, `o`.`data` AS `data_ordinazione`, `o`.`ora` AS `ora_ordinazione`, `o`.`somma_totale` AS `somma_totale_ordinazione`, `o`.`cameriere` AS `codice_cameriere`, `cb`.`quantita` AS `quantita`, `b`.`codice` AS `codice_bevanda`, `b`.`nome` AS `bevanda`, `b`.`prezzo` AS `prezzo_bevanda`, `m`.`codice` AS `codice_piatto`, `m`.`nome` AS `piatto`, `m`.`prezzo` AS `prezzo_mangiare` FROM ((((`ordinazione` `o` join `contiene_bevanda` `cb` on(`o`.`codice` = `cb`.`ordinazione` and `o`.`prenotazione` = `cb`.`prenotazione` and `o`.`tavolo` = `cb`.`tavolo` and `o`.`ristorante` = `cb`.`ristorante`)) join `bevanda` `b` on(`cb`.`bevanda` = `b`.`codice`)) join `contiene_mangiare` `cm` on(`o`.`codice` = `cm`.`ordinazione` and `o`.`prenotazione` = `cm`.`prenotazione` and `o`.`tavolo` = `cm`.`tavolo` and `o`.`ristorante` = `cm`.`ristorante`)) join `mangiare` `m` on(`cm`.`mangiare` = `m`.`codice`)) ;

-- --------------------------------------------------------

--
-- Struttura per vista `ordinazioni_bevande`
--
DROP TABLE IF EXISTS `ordinazioni_bevande`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ordinazioni_bevande`  AS SELECT `o`.`codice` AS `codice_ordinazione`, `o`.`prenotazione` AS `codice_prenotazione`, `o`.`tavolo` AS `numero_tavolo`, `o`.`ristorante` AS `ristorante`, `o`.`data` AS `data_ordinazione`, `o`.`ora` AS `ora_ordinazione`, `o`.`somma_totale` AS `somma_totale_ordinazione`, `o`.`cameriere` AS `codice_cameriere`, `cb`.`quantita` AS `quantita`, `b`.`codice` AS `codice_bevanda`, `b`.`nome` AS `bevanda`, `b`.`prezzo` AS `prezzo_bevanda` FROM ((`ordinazione` `o` join `contiene_bevanda` `cb` on(`o`.`codice` = `cb`.`ordinazione` and `o`.`prenotazione` = `cb`.`prenotazione` and `o`.`tavolo` = `cb`.`tavolo` and `o`.`ristorante` = `cb`.`ristorante`)) join `bevanda` `b` on(`cb`.`bevanda` = `b`.`codice`)) ;

-- --------------------------------------------------------

--
-- Struttura per vista `ordinazioni_mangiare`
--
DROP TABLE IF EXISTS `ordinazioni_mangiare`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ordinazioni_mangiare`  AS SELECT `o`.`codice` AS `codice_ordinazione`, `o`.`prenotazione` AS `codice_prenotazione`, `o`.`tavolo` AS `numero_tavolo`, `o`.`ristorante` AS `ristorante`, `o`.`data` AS `data_ordinazione`, `o`.`ora` AS `ora_ordinazione`, `o`.`somma_totale` AS `somma_totale_ordinazione`, `o`.`cameriere` AS `codice_cameriere`, `cm`.`quantita` AS `quantita`, `m`.`codice` AS `codice_piatto`, `m`.`nome` AS `piatto`, `m`.`prezzo` AS `prezzo_mangiare` FROM ((`ordinazione` `o` join `contiene_mangiare` `cm` on(`o`.`codice` = `cm`.`ordinazione` and `o`.`prenotazione` = `cm`.`prenotazione` and `o`.`tavolo` = `cm`.`tavolo` and `o`.`ristorante` = `cm`.`ristorante`)) join `mangiare` `m` on(`cm`.`mangiare` = `m`.`codice`)) ;

-- --------------------------------------------------------

--
-- Struttura per vista `v1`
--
DROP TABLE IF EXISTS `v1`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v1`  AS SELECT `p`.`ristorante` AS `ristorante`, `p`.`ora` AS `ora`, count(`p`.`ora`) AS `numero_prenotazioni` FROM `prenotazione` AS `p` GROUP BY `p`.`ristorante`, `p`.`ora` ;

-- --------------------------------------------------------

--
-- Struttura per vista `v2`
--
DROP TABLE IF EXISTS `v2`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v2`  AS SELECT `b`.`nome` AS `nome`, count(0) AS `conteggio` FROM (`bevanda` `b` join `contiene_bevanda` `cb` on(`b`.`codice` = `cb`.`bevanda`)) GROUP BY `b`.`nome` ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `bevanda`
--
ALTER TABLE `bevanda`
  ADD PRIMARY KEY (`codice`);

--
-- Indici per le tabelle `cameriere`
--
ALTER TABLE `cameriere`
  ADD PRIMARY KEY (`codice`),
  ADD KEY `idx4_ristorante` (`ristorante`);

--
-- Indici per le tabelle `contiene_bevanda`
--
ALTER TABLE `contiene_bevanda`
  ADD PRIMARY KEY (`bevanda`,`ordinazione`,`prenotazione`,`tavolo`,`ristorante`),
  ADD KEY `idx1_bevanda` (`bevanda`),
  ADD KEY `idx1_ordinazione` (`ordinazione`),
  ADD KEY `idx2_prenotazione` (`prenotazione`),
  ADD KEY `idx3_tavolo` (`tavolo`),
  ADD KEY `idx6_ristorante` (`ristorante`);

--
-- Indici per le tabelle `contiene_ingrediente`
--
ALTER TABLE `contiene_ingrediente`
  ADD PRIMARY KEY (`mangiare`,`ingrediente`),
  ADD KEY `idx2_mangiare` (`mangiare`),
  ADD KEY `idx1_ingrediente` (`ingrediente`);

--
-- Indici per le tabelle `contiene_mangiare`
--
ALTER TABLE `contiene_mangiare`
  ADD PRIMARY KEY (`mangiare`,`ordinazione`,`prenotazione`,`tavolo`,`ristorante`),
  ADD KEY `idx1_mangiare` (`mangiare`),
  ADD KEY `idx2_ordinazione` (`ordinazione`),
  ADD KEY `idx3_prenotazione` (`prenotazione`),
  ADD KEY `idx4_tavolo` (`tavolo`),
  ADD KEY `idx7_ristorante` (`ristorante`);

--
-- Indici per le tabelle `cuoco`
--
ALTER TABLE `cuoco`
  ADD PRIMARY KEY (`codice`),
  ADD KEY `idx3_ristorante` (`ristorante`);

--
-- Indici per le tabelle `ingrediente`
--
ALTER TABLE `ingrediente`
  ADD PRIMARY KEY (`codice`);

--
-- Indici per le tabelle `mangiare`
--
ALTER TABLE `mangiare`
  ADD PRIMARY KEY (`codice`);

--
-- Indici per le tabelle `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`ristorante`),
  ADD KEY `indice_ristorante` (`ristorante`);

--
-- Indici per le tabelle `news_cliccate`
--
ALTER TABLE `news_cliccate`
  ADD PRIMARY KEY (`utente`,`link`),
  ADD KEY `idx2_utente` (`utente`);

--
-- Indici per le tabelle `ordinazione`
--
ALTER TABLE `ordinazione`
  ADD PRIMARY KEY (`codice`),
  ADD KEY `idx1_prenotazione` (`prenotazione`),
  ADD KEY `idx2_tavolo` (`tavolo`),
  ADD KEY `idx5_ristorante` (`ristorante`),
  ADD KEY `idx1_cameriere` (`cameriere`);

--
-- Indici per le tabelle `preferiti`
--
ALTER TABLE `preferiti`
  ADD PRIMARY KEY (`utente`,`codice_ristorante`),
  ADD KEY `idx1_utente` (`utente`),
  ADD KEY `idx1_ristorante` (`codice_ristorante`);

--
-- Indici per le tabelle `prenotazione`
--
ALTER TABLE `prenotazione`
  ADD PRIMARY KEY (`codice`),
  ADD KEY `idx2_ristorante` (`ristorante`);

--
-- Indici per le tabelle `ristorante`
--
ALTER TABLE `ristorante`
  ADD PRIMARY KEY (`codice`);

--
-- Indici per le tabelle `tavolo`
--
ALTER TABLE `tavolo`
  ADD PRIMARY KEY (`numero`,`ristorante`),
  ADD KEY `idx1_ristorante` (`ristorante`);

--
-- Indici per le tabelle `utente`
--
ALTER TABLE `utente`
  ADD PRIMARY KEY (`username`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `bevanda`
--
ALTER TABLE `bevanda`
  MODIFY `codice` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT per la tabella `cameriere`
--
ALTER TABLE `cameriere`
  MODIFY `codice` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT per la tabella `cuoco`
--
ALTER TABLE `cuoco`
  MODIFY `codice` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT per la tabella `ingrediente`
--
ALTER TABLE `ingrediente`
  MODIFY `codice` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT per la tabella `mangiare`
--
ALTER TABLE `mangiare`
  MODIFY `codice` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT per la tabella `ordinazione`
--
ALTER TABLE `ordinazione`
  MODIFY `codice` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `prenotazione`
--
ALTER TABLE `prenotazione`
  MODIFY `codice` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT per la tabella `ristorante`
--
ALTER TABLE `ristorante`
  MODIFY `codice` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `cameriere`
--
ALTER TABLE `cameriere`
  ADD CONSTRAINT `cameriere_ibfk_1` FOREIGN KEY (`ristorante`) REFERENCES `ristorante` (`codice`);

--
-- Limiti per la tabella `contiene_bevanda`
--
ALTER TABLE `contiene_bevanda`
  ADD CONSTRAINT `contiene_bevanda_ibfk_1` FOREIGN KEY (`bevanda`) REFERENCES `bevanda` (`codice`),
  ADD CONSTRAINT `contiene_bevanda_ibfk_2` FOREIGN KEY (`ordinazione`) REFERENCES `ordinazione` (`codice`);

--
-- Limiti per la tabella `contiene_ingrediente`
--
ALTER TABLE `contiene_ingrediente`
  ADD CONSTRAINT `contiene_ingrediente_ibfk_1` FOREIGN KEY (`mangiare`) REFERENCES `mangiare` (`codice`),
  ADD CONSTRAINT `contiene_ingrediente_ibfk_2` FOREIGN KEY (`ingrediente`) REFERENCES `ingrediente` (`codice`);

--
-- Limiti per la tabella `contiene_mangiare`
--
ALTER TABLE `contiene_mangiare`
  ADD CONSTRAINT `contiene_mangiare_ibfk_1` FOREIGN KEY (`mangiare`) REFERENCES `mangiare` (`codice`),
  ADD CONSTRAINT `contiene_mangiare_ibfk_2` FOREIGN KEY (`ordinazione`) REFERENCES `ordinazione` (`codice`);

--
-- Limiti per la tabella `cuoco`
--
ALTER TABLE `cuoco`
  ADD CONSTRAINT `cuoco_ibfk_1` FOREIGN KEY (`ristorante`) REFERENCES `ristorante` (`codice`);

--
-- Limiti per la tabella `menu`
--
ALTER TABLE `menu`
  ADD CONSTRAINT `menu_ibfk_1` FOREIGN KEY (`ristorante`) REFERENCES `ristorante` (`codice`);

--
-- Limiti per la tabella `news_cliccate`
--
ALTER TABLE `news_cliccate`
  ADD CONSTRAINT `news_cliccate_ibfk_1` FOREIGN KEY (`utente`) REFERENCES `utente` (`username`);

--
-- Limiti per la tabella `ordinazione`
--
ALTER TABLE `ordinazione`
  ADD CONSTRAINT `ordinazione_ibfk_1` FOREIGN KEY (`prenotazione`) REFERENCES `prenotazione` (`codice`),
  ADD CONSTRAINT `ordinazione_ibfk_2` FOREIGN KEY (`cameriere`) REFERENCES `cameriere` (`codice`);

--
-- Limiti per la tabella `preferiti`
--
ALTER TABLE `preferiti`
  ADD CONSTRAINT `preferiti_ibfk_1` FOREIGN KEY (`codice_ristorante`) REFERENCES `ristorante` (`codice`),
  ADD CONSTRAINT `preferiti_ibfk_2` FOREIGN KEY (`utente`) REFERENCES `utente` (`username`);

--
-- Limiti per la tabella `prenotazione`
--
ALTER TABLE `prenotazione`
  ADD CONSTRAINT `prenotazione_ibfk_1` FOREIGN KEY (`ristorante`) REFERENCES `ristorante` (`codice`);

--
-- Limiti per la tabella `tavolo`
--
ALTER TABLE `tavolo`
  ADD CONSTRAINT `tavolo_ibfk_1` FOREIGN KEY (`ristorante`) REFERENCES `ristorante` (`codice`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
