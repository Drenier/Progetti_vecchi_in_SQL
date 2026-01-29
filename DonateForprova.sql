CREATE DATABASE donateforprova;
USE donateforprova;

CREATE TABLE Onlus (
    CodOnlus CHAR(4) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    citta VARCHAR(50) NOT NULL,
    cod_fisc CHAR(16) NOT NULL,
    IBAN CHAR(27) NOT NULL,
    CAP VARCHAR(30),
    Numtel CHAR(10) NOT NULL,
    email VARCHAR(100) NOT NULL
);

CREATE TABLE Ricompense (
    IDricompensa CHAR(4) PRIMARY KEY,
    descrizione VARCHAR(100)
);

CREATE TABLE Obiettivi (
    IDobiettivo CHAR(4) PRIMARY KEY,
    descrizione VARCHAR(100)
);

CREATE TABLE Ambiti (
    IDambito CHAR(4) PRIMARY KEY,
    descrizione VARCHAR(100)
);

CREATE TABLE Progetti (
    CodProgetto CHAR(4) PRIMARY KEY,
    titolo VARCHAR(50) NOT NULL,
    video VARCHAR(75) NOT NULL,
    scadenza DATE NOT NULL,
    FKCodOnlus CHAR(4),
    FOREIGN KEY (FKCodOnlus) REFERENCES Onlus(CodOnlus),
    FKIDricompensa CHAR(4),
    FOREIGN KEY (FKIDricompensa) REFERENCES Ricompense(IDricompensa)
);

CREATE TABLE Attenere (
    FKCodProgetto CHAR(4),
    FOREIGN KEY (FKCodProgetto) REFERENCES Progetti(CodProgetto),
    FKIDambito CHAR(4),
    FOREIGN KEY (FKIDambito) REFERENCES Ambiti(IDambito),
    PRIMARY KEY (FKCodProgetto, FKIDambito)
);

CREATE TABLE Mirare (
    FKCodProgetto CHAR(4),
    FOREIGN KEY (FKCodProgetto) REFERENCES Progetti(CodProgetto),
    FKIDobiettivo CHAR(4),
    FOREIGN KEY (FKIDobiettivo) REFERENCES Obiettivi(IDobiettivo),
    PRIMARY KEY (FKCodProgetto, FKIDobiettivo)
);

CREATE TABLE Donatori (
    CodDonatore CHAR(4) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    datanascita DATE,
    indirizzo VARCHAR(100) NOT NULL,
    citta VARCHAR(50),
    CAP VARCHAR(30),
    Cod_fisc CHAR(16) NOT NULL,
    email VARCHAR(100) NOT NULL
);

CREATE TABLE Donazioni (
    CodDonazione CHAR(4) PRIMARY KEY,
    importo DECIMAL(10, 2) NOT NULL,
    data_donaz DATE NOT NULL,
    FKCodProgetto CHAR(4),
    FOREIGN KEY (FKCodProgetto) REFERENCES Progetti(CodProgetto),
    FKCodDonatore CHAR(4),
    FOREIGN KEY (FKCodDonatore) REFERENCES Donatori(CodDonatore)
);

CREATE TABLE Modalita (
    CodModalita CHAR(4) PRIMARY KEY,
    tipologia VARCHAR(50) NOT NULL,
    FKCodDonazione CHAR(4),
    FOREIGN KEY (FKCodDonazione) REFERENCES Donazioni(CodDonazione)
);

-- Elenco delle donazioni fatte ad un certo progetto
SELECT P.titolo, D.CodDonazione, D.importo, D.data_donaz
FROM Donazioni D
JOIN Progetti P ON D.FKCodProgetto = P.CodProgetto
WHERE P.CodProgetto = FKCodProgetto;

-- Somma delle donazioni per ogni progetto alla data odierna
SELECT P.titolo, SUM(D.importo) AS Totale_Donazioni
FROM Donazioni D
JOIN Progetti P ON D.FKCodProgetto = P.CodProgetto
WHERE D.data_donaz = CURRENT_DATE();
GROUP BY P.CodProgetto;
