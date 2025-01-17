--INTEGRANTES DO GRUPO
--RM:552486 - ENZO LUCIANO DUARTE
--RM:550198 - Murilo Santini Chequer
--RM:550283 - Jo�o Victor Oliveira Avellar
--RM:98865 - Ronaldo Kozan J�nior
--RM:99545 - Francisco Henrique Lima

-- SCRIPT PARA REMOVER TODAS AS TABELAS
--INICIO

DROP TABLE EMAIL_USUARIO CASCADE CONSTRAINTS;
DROP TABLE TELEFONE_USUARIO CASCADE CONSTRAINTS;
DROP TABLE ENDERECO_USUARIO CASCADE CONSTRAINTS;
DROP TABLE PRODUTO_PEDIDO CASCADE CONSTRAINTS;
DROP TABLE AVALIACAO_PRODUTO CASCADE CONSTRAINTS;
DROP TABLE PRODUTO CASCADE CONSTRAINTS;
DROP TABLE CATEGORIA_PRODUTO CASCADE CONSTRAINTS;
DROP TABLE CONSULTORA CASCADE CONSTRAINTS;
DROP TABLE DEVOLUCAO CASCADE CONSTRAINTS;
DROP TABLE CLIENTE CASCADE CONSTRAINTS;
DROP TABLE PEDIDO CASCADE CONSTRAINTS;
DROP TABLE USUARIO CASCADE CONSTRAINTS;
DROP TABLE CIDADE CASCADE CONSTRAINTS;
DROP TABLE ESTADO CASCADE CONSTRAINTS;
DROP TABLE REGIAO CASCADE CONSTRAINTS;

--FIM

CREATE TABLE REGIAO (
    ID_REGIAO INTEGER PRIMARY KEY NOT NULL,
    NOM_REGIAO VARCHAR2(15 CHAR) NOT NULL,
    CONSTRAINT REGIAO_NOM_REGIAO_UN UNIQUE (NOM_REGIAO)
);

CREATE TABLE ESTADO (
    ID_ESTADO INTEGER PRIMARY KEY NOT NULL,
    UF VARCHAR2(2 CHAR) NOT NULL,
    REGIAO_ID_REGIAO INTEGER NOT NULL,
    CONSTRAINT ESTADO_UF_UN UNIQUE (UF)
);

CREATE TABLE CIDADE (
    ID_CIDADE INTEGER PRIMARY KEY NOT NULL,
    NOM_CIDADE VARCHAR2(50 CHAR) NOT NULL,
    ESTADO_ID_ESTADO INTEGER NOT NULL
);

CREATE TABLE USUARIO (
    ID_USUARIO INTEGER PRIMARY KEY NOT NULL,
    NOM_USUARIO VARCHAR2(50 CHAR) NOT NULL,
    SENHA VARCHAR2(50 CHAR) NOT NULL,
    CIDADE_ID_CIDADE INTEGER NOT NULL
);

CREATE TABLE EMAIL_USUARIO (
    ID_EMAIL INTEGER NOT NULL,
    EMAIL VARCHAR2(50 CHAR) NOT NULL,
    USUARIO_ID_USUARIO INTEGER NOT NULL,
    PRIMARY KEY (ID_EMAIL, USUARIO_ID_USUARIO)
);

CREATE TABLE TELEFONE_USUARIO (
    ID_TELEFONE INTEGER NOT NULL,
    NUM_TELEFONE INTEGER NOT NULL,
    USUARIO_ID_USUARIO INTEGER NOT NULL,
    PRIMARY KEY (ID_TELEFONE, USUARIO_ID_USUARIO)
);

CREATE TABLE ENDERECO_USUARIO (
    ID_ENDERECO INTEGER NOT NULL,
    CEP INTEGER NOT NULL,
    BAIRRO VARCHAR2(50 CHAR) NOT NULL,
    RUA VARCHAR2(50 CHAR) NOT NULL,
    NUM_RESIDENCIA INTEGER NOT NULL,
    COMPLEMENTO VARCHAR2(100 CHAR) DEFAULT 'N/A',
    USUARIO_ID_USUARIO INTEGER NOT NULL,
    PRIMARY KEY (ID_ENDERECO, USUARIO_ID_USUARIO)
);

CREATE TABLE CONSULTORA (
    LINK_PAGINA_CONSULTORA VARCHAR2(255 CHAR) NOT NULL,
    APELIDO VARCHAR2(50 CHAR),
    USUARIO_ID_USUARIO INTEGER PRIMARY KEY NOT NULL,
    CONSTRAINT CONSULTORA_LINK_PAGINA_CONSULTORA_UN UNIQUE (LINK_PAGINA_CONSULTORA)
);

CREATE TABLE CLIENTE (
    LINK_PAGINA_CLIENTE INTEGER NOT NULL,
    PREF_CONTATO VARCHAR2(15 CHAR) DEFAULT 'EMAIL' NOT NULL,
    USUARIO_ID_USUARIO INTEGER PRIMARY KEY NOT NULL,
    CONSTRAINT CLIENTE_LINK_PAGINA_CLIENTE_UN UNIQUE (LINK_PAGINA_CLIENTE)
);

CREATE TABLE CATEGORIA_PRODUTO (
    ID_CATEGORIA_PRODUTO INTEGER PRIMARY KEY NOT NULL,
    NOM_CATEGORIA VARCHAR2(50 CHAR) NOT NULL,
    CONSTRAINT CATEGORIA_PRODUTO_NOME_CATEGORIA_UN UNIQUE (NOM_CATEGORIA)
);

CREATE TABLE PRODUTO (
    ID_PRODUTO INTEGER PRIMARY KEY NOT NULL,
    NOM_PRODUTO VARCHAR2(50 CHAR) NOT NULL,
    DESCRICAO VARCHAR2(50 CHAR),
    VAL_UNIDADE NUMBER(6,2) NOT NULL,
    QTD_ESTOQUE INTEGER CHECK (QTD_ESTOQUE >= 0) NOT NULL,
    DAT_FABRICACAO DATE NOT NULL,
    CONSULTORA_USUARIO_ID_USUARIO INTEGER NOT NULL,
    CATEG_PROD_ID_CATEG_PROD INTEGER NOT NULL
);

CREATE TABLE AVALIACAO_PRODUTO (
    ID_AVALIACAO INTEGER PRIMARY KEY NOT NULL,
    NOTA INTEGER CHECK (NOTA BETWEEN 1 AND 5) NOT NULL,
    COMENTARIO VARCHAR2(255 CHAR),
    PRODUTO_ID_PRODUTO INTEGER NOT NULL
);

CREATE TABLE DEVOLUCAO (
    ID_DEVOLUCAO INTEGER PRIMARY KEY NOT NULL,
    DAT_DEVOLUCAO DATE,
    STATUS VARCHAR2(25 CHAR) DEFAULT 'EM ANALISE' NOT NULL,
    CLIENTE_USUARIO_ID_USUARIO INTEGER NOT NULL
);

CREATE TABLE PEDIDO (
    ID_PEDIDO INTEGER PRIMARY KEY NOT NULL,
    DAT_PEDIDO DATE NOT NULL,
    STATUS VARCHAR2(20 CHAR) DEFAULT 'EM ANALISE' NOT NULL,
    PCT_DESCONTO INTEGER CHECK (PCT_DESCONTO BETWEEN 0 AND 100) NOT NULL,
    USUARIO_ID_USUARIO INTEGER NOT NULL
);

CREATE TABLE PRODUTO_PEDIDO (
    QTD_PRODUTO INTEGER CHECK (QTD_PRODUTO >= 1) NOT NULL,
    PRECO_PRODUTO NUMBER(6,2) CHECK (PRECO_PRODUTO > 0) NOT NULL,
    DEVOLUCAO_ID_DEVOLUCAO INTEGER NOT NULL,
    PEDIDO_ID_PEDIDO INTEGER NOT NULL,
    PRODUTO_ID_PRODUTO INTEGER NOT NULL,
    PRIMARY KEY (PEDIDO_ID_PEDIDO, PRODUTO_ID_PRODUTO)
);

ALTER TABLE ESTADO
ADD CONSTRAINT REGIAO_ESTADO_FK FOREIGN KEY (REGIAO_ID_REGIAO) REFERENCES REGIAO(ID_REGIAO) ON DELETE CASCADE;

ALTER TABLE CIDADE
ADD CONSTRAINT ESTADO_CIDADE_FK FOREIGN KEY (ESTADO_ID_ESTADO) REFERENCES ESTADO(ID_ESTADO) ON DELETE CASCADE;

ALTER TABLE USUARIO
ADD CONSTRAINT CIDADE_USUARIO_FK FOREIGN KEY (CIDADE_ID_CIDADE) REFERENCES CIDADE(ID_CIDADE) ON DELETE CASCADE;

ALTER TABLE EMAIL_USUARIO
ADD CONSTRAINT USUARIO_EMAIL_USUARIO_FK FOREIGN KEY (USUARIO_ID_USUARIO) REFERENCES USUARIO(ID_USUARIO) ON DELETE CASCADE;

ALTER TABLE TELEFONE_USUARIO
ADD CONSTRAINT USUARIO_TELEFONE_USUARIO_FK FOREIGN KEY (USUARIO_ID_USUARIO) REFERENCES USUARIO(ID_USUARIO) ON DELETE CASCADE;

ALTER TABLE ENDERECO_USUARIO
ADD CONSTRAINT USUARIO_ENDERECO_USUARIO_FK FOREIGN KEY (USUARIO_ID_USUARIO) REFERENCES USUARIO(ID_USUARIO) ON DELETE CASCADE;

ALTER TABLE CONSULTORA
ADD CONSTRAINT USUARIO_CONSULTORA_FK FOREIGN KEY (USUARIO_ID_USUARIO) REFERENCES USUARIO(ID_USUARIO) ON DELETE CASCADE;

ALTER TABLE CLIENTE
ADD CONSTRAINT USUARIO_CLIENTE_FK FOREIGN KEY (USUARIO_ID_USUARIO) REFERENCES USUARIO(ID_USUARIO) ON DELETE CASCADE;

ALTER TABLE PRODUTO
ADD CONSTRAINT CONSULTORA_PRODUTO_FK FOREIGN KEY (CONSULTORA_USUARIO_ID_USUARIO) REFERENCES CONSULTORA(USUARIO_ID_USUARIO) ON DELETE CASCADE;

ALTER TABLE PRODUTO
ADD CONSTRAINT CATEGORIA_PRODUTO_PRODUTO_FK FOREIGN KEY (CATEG_PROD_ID_CATEG_PROD) REFERENCES CATEGORIA_PRODUTO(ID_CATEGORIA_PRODUTO) ON DELETE CASCADE;

ALTER TABLE AVALIACAO_PRODUTO
ADD CONSTRAINT PRODUTO_AVALIACAO_PRODUTO_FK FOREIGN KEY (PRODUTO_ID_PRODUTO) REFERENCES PRODUTO(ID_PRODUTO) ON DELETE CASCADE;

ALTER TABLE DEVOLUCAO
ADD CONSTRAINT CLIENTE_DEVOLUCAO_FK FOREIGN KEY (CLIENTE_USUARIO_ID_USUARIO) REFERENCES CLIENTE(USUARIO_ID_USUARIO) ON DELETE CASCADE;

ALTER TABLE PEDIDO
ADD CONSTRAINT USUARIO_PEDIDO_FK FOREIGN KEY (USUARIO_ID_USUARIO) REFERENCES USUARIO(ID_USUARIO) ON DELETE CASCADE;

ALTER TABLE PRODUTO_PEDIDO
ADD CONSTRAINT DEVOLUCAO_PRODUTO_PEDIDO_FK FOREIGN KEY (DEVOLUCAO_ID_DEVOLUCAO) REFERENCES DEVOLUCAO(ID_DEVOLUCAO) ON DELETE CASCADE;

ALTER TABLE PRODUTO_PEDIDO
ADD CONSTRAINT PEDIDO_PRODUTO_PEDIDO_FK FOREIGN KEY (PEDIDO_ID_PEDIDO) REFERENCES PEDIDO(ID_PEDIDO) ON DELETE CASCADE;

ALTER TABLE PRODUTO_PEDIDO
ADD CONSTRAINT PRODUTO_PRODUTO_PEDIDO_FK FOREIGN KEY (PRODUTO_ID_PRODUTO) REFERENCES PRODUTO(ID_PRODUTO) ON DELETE CASCADE;