ALTER SESSION SET current_schema = CONSINCO;

-- Consulta se existem códigos de acesso repetidos para produtos diferentes

SELECT DISTINCT SEQPRODUTO, CODACESSO FROM MAP_PRODCODIGO X WHERE CODACESSO IN (
SELECT CODACESSO FROM (
SELECT DISTINCT SEQPRODUTO, CODACESSO,
       ROW_NUMBER() OVER(PARTITION BY CODACESSO ORDER BY A.CODACESSO) ODR
  FROM MAP_PRODCODIGO A WHERE A.TIPCODIGO = 'F' 
  
  ORDER BY 2)
  
  WHERE ODR > 1) AND TIPCODIGO = 'F'
  
  ORDER BY 2
