ALTER SESSION SET current_schema = CONSINCO;

/* Embalagem > 1 com mesmo preço do unitário */

SELECT E.COMPRADOR, C.SEQPRODUTO, MA.DESCCOMPLETA, QTDEMBALAGEM, PRECOBASENORMAL,
       PRECOGERNORMAL, PRECOBASENORMAL / QTDEMBALAGEM PR_UNI, STATUSVENDA
FROM MRL_PRODEMPSEG C LEFT JOIN MAP_PRODUTO MA ON C.SEQPRODUTO = MA.SEQPRODUTO
                      LEFT JOIN CONSINCO.MAP_FAMDIVISAO D    ON D.SEQFAMILIA = MA.SEQFAMILIA
                      LEFT JOIN CONSINCO.MAX_COMPRADOR E     ON E.SEQCOMPRADOR = D.SEQCOMPRADOR

WHERE C.NROEMPRESA = 54 AND C.NROSEGMENTO = 7 AND STATUSVENDA = 'A' AND PRECOBASENORMAL > 0 AND C.SEQPRODUTO IN (

SELECT SEQPRODUTO
  FROM MRL_PRODEMPSEG B WHERE B.NROEMPRESA = 54 AND B.NROSEGMENTO = 7 AND B.QTDEMBALAGEM = 1 AND B.STATUSVENDA = 'A'
   AND B.SEQPRODUTO IN (SELECT SEQPRODUTO FROM MRL_PRODEMPSEG A
 WHERE A.NROEMPRESA = 54 AND A.NROSEGMENTO = 7 AND A.SEQPRODUTO = B.SEQPRODUTO 
 AND A.QTDEMBALAGEM > 1 AND (A.PRECOBASENORMAL / A.QTDEMBALAGEM) = B.PRECOBASENORMAL AND A.STATUSVENDA = 'A'))

ORDER BY 2, 4;

/* Embalagem > 1 com preço maior que unitario */

SELECT E.COMPRADOR, C.SEQPRODUTO, MA.DESCCOMPLETA, QTDEMBALAGEM, PRECOBASENORMAL,
       PRECOGERNORMAL, C.PRECOVALIDNORMAL, PRECOBASENORMAL / QTDEMBALAGEM PR_UNI, STATUSVENDA
FROM MRL_PRODEMPSEG C LEFT JOIN MAP_PRODUTO MA ON C.SEQPRODUTO = MA.SEQPRODUTO
                      LEFT JOIN CONSINCO.MAP_FAMDIVISAO D    ON D.SEQFAMILIA = MA.SEQFAMILIA
                      LEFT JOIN CONSINCO.MAX_COMPRADOR E     ON E.SEQCOMPRADOR = D.SEQCOMPRADOR

WHERE C.NROEMPRESA = 54 AND C.NROSEGMENTO = 7 AND STATUSVENDA = 'A' AND PRECOBASENORMAL > 0 AND C.SEQPRODUTO IN (

SELECT SEQPRODUTO
  FROM MRL_PRODEMPSEG B WHERE B.NROEMPRESA = 54 AND B.NROSEGMENTO = 7 AND B.QTDEMBALAGEM = 1 AND B.STATUSVENDA = 'A'
   AND B.SEQPRODUTO IN (SELECT SEQPRODUTO FROM MRL_PRODEMPSEG A
 WHERE A.NROEMPRESA = 54 AND A.NROSEGMENTO = 7 AND A.SEQPRODUTO = B.SEQPRODUTO 
 AND A.QTDEMBALAGEM > 1 AND (A.PRECOBASENORMAL / A.QTDEMBALAGEM) > B.PRECOGERNORMAL AND A.STATUSVENDA = 'A'))

ORDER BY 2, 4; 

/* Embalagens > 1 alterados pela equiparação da loja 08 */

SELECT * FROM MRL_PRODEMPSEG H WHERE H.NROEMPRESA = 54 AND H.NROSEGMENTO = 7 AND H.STATUSVENDA = 'A' AND H.SEQPRODUTO IN (
SELECT SEQPRODUTO FROM MRL_PRODEMPSEG D WHERE D.NROEMPRESA = 54 AND D.NROSEGMENTO = 7 AND STATUSVENDA = 'A' AND D.QTDEMBALAGEM > 1 
             AND UPPER(MOTIVOPRECOBASE) LIKE '%EQUIP%' AND PRECOBASENORMAL != 0)

ORDER  BY 1;

/* Emb > 1 ativa com unitário inativo */ 

SELECT * FROM MRL_PRODEMPSEG G WHERE G.NROEMPRESA = 54 AND G.NROSEGMENTO = 7 AND SEQPRODUTO IN (
SELECT SEQPRODUTO FROM MRL_PRODEMPSEG F WHERE F.NROEMPRESA = 54 AND F.NROSEGMENTO = 7 AND F.STATUSVENDA = 'I' AND F.QTDEMBALAGEM = 1 AND SEQPRODUTO IN (
SELECT SEQPRODUTO FROM MRL_PRODEMPSEG D WHERE D.NROEMPRESA = 54 AND D.NROSEGMENTO = 7 AND D.STATUSVENDA = 'A' AND SEQPRODUTO IN (  
       SELECT SEQPRODUTO FROM MRL_PRODEMPSEG E WHERE E.NROEMPRESA = 54 AND E.NROSEGMENTO = 7 AND E.STATUSVENDA = 'A' AND D.QTDEMBALAGEM > 1)))

ORDER BY 1;

/* Produtos com mais de uma embalagem atacado ativa */

SELECT E.COMPRADOR, L.SEQPRODUTO, MA.DESCCOMPLETA, QTDEMBALAGEM, PRECOBASENORMAL, PRECOBASENORMAL / QTDEMBALAGEM PR_UNI, STATUSVENDA
FROM MRL_PRODEMPSEG L LEFT JOIN MAP_PRODUTO MA ON L.SEQPRODUTO = MA.SEQPRODUTO
                      LEFT JOIN CONSINCO.MAP_FAMDIVISAO D    ON D.SEQFAMILIA = MA.SEQFAMILIA
                      LEFT JOIN CONSINCO.MAX_COMPRADOR E     ON E.SEQCOMPRADOR = D.SEQCOMPRADOR
           WHERE L.NROEMPRESA  = 54 AND L.NROSEGMENTO = 7 AND L.SEQPRODUTO IN (
       SELECT DISTINCT SEQPRODUTO FROM (
       SELECT ROW_NUMBER () OVER (PARTITION BY I.SEQPRODUTO ORDER  BY I.SEQPRODUTO) CO, I.SEQPRODUTO FROM MRL_PRODEMPSEG I
           WHERE I.NROEMPRESA = 54 AND STATUSVENDA = 'A' AND I.NROSEGMENTO = 7 AND  PRECOBASENORMAL != 0 AND I.SEQPRODUTO IN (
       SELECT J.SEQPRODUTO FROM MRL_PRODEMPSEG J WHERE J.NROEMPRESA = 54 AND J.NROSEGMENTO = 7 AND STATUSVENDA = 'A' AND J.QTDEMBALAGEM > 1))
           WHERE CO > 2)
ORDER BY 2,3;
        
/* Todos com ebmalagem > 1 */

SELECT K.DESCCOMPLETA, I.* FROM MRL_PRODEMPSEG I LEFT JOIN MAP_PRODUTO K ON I.SEQPRODUTO = K.SEQPRODUTO
 WHERE I.NROEMPRESA = 54 
   AND STATUSVENDA = 'A'  
   AND I.NROSEGMENTO = 7  
   AND PRECOBASENORMAL != 00
   AND I.SEQPRODUTO IN (
SELECT J.SEQPRODUTO FROM MRL_PRODEMPSEG J WHERE J.NROEMPRESA = 54 AND J.NROSEGMENTO = 7 AND STATUSVENDA = 'A' AND J.QTDEMBALAGEM > 1
)
ORDER BY 1

/*  Produtos com embalagem de atacado ativa + comprador */

SELECT I.NROEMPRESA EMPRESA, I.SEQPRODUTO PLU, K.DESCCOMPLETA DESCRICAO, I.QTDEMBALAGEM, DECODE(I.NROSEGMENTO, '4','Mixter','8','E-commerce') SEGMENTO, 
       Q.COMPRADOR_CADASTRO COMPRADOR, Q.CATEGORIA_NIVEL_1 CATEGORIA
  FROM MRL_PRODEMPSEG I LEFT JOIN MAP_PRODUTO K   ON I.SEQPRODUTO = K.SEQPRODUTO
                        LEFT JOIN QLV_CATEGORIA@CONSINCODW Q ON Q.SEQFAMILIA = K.SEQFAMILIA
 WHERE I.NROEMPRESA = 31
   AND STATUSVENDA = 'A'  
   AND I.NROSEGMENTO IN  (4,8) 
   AND I.SEQPRODUTO IN (
SELECT J.SEQPRODUTO FROM MRL_PRODEMPSEG J WHERE J.NROEMPRESA = 31 AND STATUSVENDA = 'A' AND J.QTDEMBALAGEM > 1
)
ORDER BY 2, 4,5 ASC
