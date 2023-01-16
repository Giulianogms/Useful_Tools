SELECT MODULO, H.DESCRICAO DESC_APLICACAO, I.DESCRICAO DESC_CAMPO, GE.CODUSUARIO, GE.NOME FROM CONSINCO.GE_USUARIOPERM G LEFT JOIN CONSINCO.GE_APLICACAO H ON G.CODAPLICACAO = H.CODAPLICACAO
                                                          LEFT JOIN CONSINCO.GE_CHAVEPERMISSAO I ON G.CHAVEAPLICACAO = I.CHAVEAPLICACAO
                                                          LEFT JOIN CONSINCO.GE_USUARIO GE ON GE.SEQUSUARIO = G.SEQUSUARIO
  WHERE G.SEQUSUARIO IN (SELECT X.SEQUSUARIO FROM CONSINCO.GE_USUARIO X WHERE X.CODUSUARIO IN ('KFARIA', 'TSANTANA'))
