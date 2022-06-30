namespace Susep.SISRH.Application.Queries.RawPSql
{
    public static class UnidadeRawSqls
    {

        public static string ObterAtivas
        {
            get
            {
                return @"
					SELECT DISTINCT u.""unidadeId"" AS Id
	                                ,u.""undSiglaCompleta"" AS ""Descricao""   
                                    ,u.""unidadeId""
	                                ,u.""undSiglaCompleta"" ""siglaCompleta""
                                    ,u.""unidadeIdPai""     
                    FROM ""dbo"".""VW_UnidadeSiglaCompleta"" u
                    WHERE ""situacaoUnidadeId"" = @situacaoAtiva
                    ORDER BY u.""undSiglaCompleta""
                ";
            }
        }

        public static string ObterComPlanoTrabalho
        {
            get
            {
                return @"
					SELECT DISTINCT u.""unidadeId"" AS Id
	                                ,u.""undSiglaCompleta"" AS ""Descricao""   
                                    ,u.""unidadeId""
	                                ,u.""undSiglaCompleta"" ""siglaCompleta""
                                    ,u.""unidadeIdPai""   
                    FROM ""dbo"".""VW_UnidadeSiglaCompleta"" u
                        INNER JOIN ""ProgramaGestao"".""PlanoTrabalho"" p ON u.""unidadeId"" = p.""unidadeId""                    
                    ORDER BY u.""undSiglaCompleta""
                ";
            }
        }
        
        public static string ObterSemCatalogoCadastrado
        {
            get
            {
                return @"
					SELECT DISTINCT u.""unidadeId"" AS Id
	                                ,u.""undSiglaCompleta"" AS ""Descricao""   
                                    ,u.""unidadeId""
	                                ,u.""undSiglaCompleta"" ""siglaCompleta""
                                    ,u.""unidadeIdPai""         
                    FROM ""dbo"".""VW_UnidadeSiglaCompleta"" u
                        LEFT OUTER JOIN ""ProgramaGestao"".""Catalogo"" c ON u.""unidadeId"" = c.""unidadeId""  
                    WHERE c.""unidadeId"" IS NULL AND u.""situacaoUnidadeId"" = 1
                    ORDER BY u.""undSiglaCompleta""
                ";
            }
        }

        public static string ObterComCatalogoCadastrado
        {
            get
            {
                return @"
					SELECT DISTINCT u.""unidadeId"" AS Id
	                                ,u.""undSiglaCompleta"" AS ""Descricao""   
                                    ,u.""unidadeId""
	                                ,u.""undSiglaCompleta"" ""siglaCompleta""
                                    ,u.""unidadeIdPai""        
                    FROM ""dbo"".""VW_UnidadeSiglaCompleta"" u
                        LEFT OUTER JOIN ""ProgramaGestao"".""Catalogo"" c ON u.""unidadeId"" = c.""unidadeId""  
                    WHERE c.""unidadeId"" IS NOT NULL
                    ORDER BY u.""undSiglaCompleta""
                ";
            }
        }

        public static string ObterPorChave
        {
            get
            {
                return @"
                    SELECT  u.""unidadeId""
                            ,""undSigla""
                            ,""undDescricao"" ""nome""
                            ,""unidadeIdPai""
                            ,""tipoUnidadeId""
                            ,""situacaoUnidadeId""
                            ,""ufId""
                            ,""undNivel"" ""Nivel""
                            ,""tipoFuncaoUnidadeId""
                            ,""undSiglaCompleta"" ""siglaCompleta""
                            ,""Email""
                    FROM ""dbo"".""VW_UnidadeSiglaCompleta"" u  
                    WHERE u.""unidadeId"" = @unidadeId
                ";
            }
        }


        public static string ObterQuantidadeServidoresPorChave
        {
            get
            {
                return @"
                    SELECT  ""upg"".""unidadeId""
                        ,""undSigla""
                        ,""undDescricao"" ""nome""
                        ,""unidadeIdPai""
                        ,""tipoUnidadeId""
                        ,""situacaoUnidadeId""
                        ,""ufId""
                        ,""undNivel"" ""Nivel""
                        ,""tipoFuncaoUnidadeId""
                        ,""undSiglaCompleta"" ""siglaCompleta""
                        ,""Email""
                        ,""quantidadeServidores""
                    FROM ""dbo"".""VW_UnidadeSiglaCompleta"" ""vu""
                            INNER JOIN (
                                        SELECT ""up"".""unidadeId"", COUNT(1) ""quantidadeServidores""
                                        FROM (SELECT p.""pessoaId"", p.""unidadeId""
                                              FROM ""dbo"".""Pessoa"" p
                                              WHERE p.""situacaoPessoaId"" = 1

                                              UNION 

                                              SELECT p.""pessoaId"", ""pat"".""unidadeId""
                                              FROM""dbo"".""PessoaAlocacaoTemporaria"" ""pat""
                                                  INNER JOIN ""dbo"".""Pessoa"" p ON p.""pessoaId"" = ""pat"".""pessoaId""
                                              WHERE p.""situacaoPessoaId"" = 1 
                                                  AND (""pat"".""dataInicio"" <= LOCALTIMESTAMP) AND (""pat"".""dataFim"" IS NULL OR ""pat"".""dataFim"" <= LOCALTIMESTAMP)
                                        ) ""up"" 
                                        WHERE ""up"".""unidadeId"" IN (SELECT ""unidadeId""
                                                               FROM ""dbo"".""VW_UnidadeSiglaCompleta""
                                                               WHERE ""undSiglaCompleta"" LIKE (SELECT u.""undSiglaCompleta"" || '%'
                                                                                            FROM ""dbo"".""VW_UnidadeSiglaCompleta"" u
                                                                                             WHERE u.""unidadeId"" = @unidadeId))
                                        GROUP BY ""up"".""unidadeId"") ""upg"" ON ""vu"".""unidadeId"" = ""upg"".""unidadeId""
                ";
            }
        }

        public static string ObterFeriados
        {
            get
            {
                return @"
                    SELECT  MAKE_DATE( EXTRACT(YEAR FROM @dataInicio)::INT, EXTRACT(month FROM ""ferData"")::INT, EXTRACT(day FROM ""ferData"")::INT ) ""data""
		                    ,""ferFixo"" ""fixo""
		                    ,f.""ufId"" ""ufId"" 
                    FROM ""dbo"".""Feriado"" f
                    WHERE ((f.""ferFixo"" = 1
		                    AND MAKE_DATE( EXTRACT(YEAR FROM @dataInicio)::INT, EXTRACT(month FROM ""ferData"")::INT, EXTRACT(day FROM ""ferData"")::INT ) >= MAKE_DATE( EXTRACT(YEAR FROM @dataInicio)::INT, EXTRACT(month FROM @dataInicio)::INT, EXTRACT(day FROM @dataInicio)::INT ) 
		                    AND MAKE_DATE( EXTRACT(YEAR FROM @dataFim)::INT, EXTRACT(month FROM ""ferData"")::INT, EXTRACT(day FROM ""ferData"")::INT ) <= MAKE_DATE( EXTRACT(YEAR FROM @dataFim)::INT, EXTRACT(month FROM @dataFim)::INT, EXTRACT(day FROM @dataFim)::INT ))
	                       OR 
	                       (f.""ferFixo"" = 0 AND ""ferData"" >= @dataInicio AND ""ferData"" <= @dataFim))					  
	                    AND (f.""ufId"" IS NULL 
		                     OR f.""ufId"" = (SELECT ""ufId"" 
					                      FROM ""dbo"".""Unidade"" 
					                      WHERE ""unidadeId"" = @unidadeId))
                ";
            }
        }

        public static string ObterModalidadesExecucaoPorUnidade
        {
            get
            {
                return @"
                    SELECT ""catalogoDominioId"" AS ""id"", ""descricao""
                    FROM ""ProgramaGestao"".""UnidadeModalidadeExecucao"" ""ue""
                        INNER JOIN ""dbo"".""CatalogoDominio"" ""cd"" ON ""cd"".""catalogoDominioId"" = ""ue"".""modalidadeExecucaoId""
                    WHERE ""unidadeId"" = @unidadeId
                    ORDER BY ""descricao""
                ";
            }
        }

        public static string ObterPessoasDadosComboPorUnidade
        {
            get
            {
                return @"
                    SELECT p.""pessoaId"" AS ""id"", ""pesNome"" ""descricao""
                    FROM ""dbo"".""Pessoa"" p
			            LEFT OUTER JOIN ""dbo"".""PessoaAlocacaoTemporaria"" a ON a.""pessoaId"" = p.""pessoaId"" AND a.""dataFim"" IS NULL
	                    INNER JOIN ""dbo"".""VW_UnidadeSiglaCompleta"" u ON u.""unidadeId"" = COALESCE(a.""unidadeId"", p.""unidadeId"")
                    WHERE ((COALESCE(a.""unidadeId"", p.""unidadeId"") = @unidadeId) OR (u.""unidadeIdPai"" = @unidadeId AND p.""tipoFuncaoId"" IS NOT NULL))
                        AND p.""situacaoPessoaId"" = 1 AND p.""tipoVinculoId"" NOT IN (5,6)
                    ORDER BY ""pesNome""
                ";
            }
        }

        public static string ObterPessoasPorUnidade
        {
            get
            {
                return @"
                    SELECT *
                    FROM (SELECT p.""pessoaId"", ""pesNome"" ""nome"", ""pesEmail"" ""email"", ""tipoFuncaoId"", p.""unidadeId"", IIF(""u1"".""unidadeId"" IS NOT NULL, 1, 0) ""chefe""
                            FROM ""dbo"".""Pessoa"" p
                                LEFT OUTER JOIN ""dbo"".""Unidade"" ""u1"" ON ""u1"".""unidadeId"" = p.""unidadeId"" AND (""u1"".""pessoaIdChefe"" = p.""pessoaId"" OR ""u1"".""pessoaIdChefeSubstituto"" = p.""pessoaId"")
                            WHERE p.""situacaoPessoaId"" = 1

                            UNION 

                            SELECT p.""pessoaId"", ""pesNome"" ""nome"", ""pesEmail"" ""email"", ""tipoFuncaoId"", ""pat"".""unidadeId"", IIF(""u1"".""unidadeId"" IS NOT NULL, 1, 0) ""chefe""
                            FROM""dbo"".""PessoaAlocacaoTemporaria"" ""pat""
                                INNER JOIN ""dbo"".""Pessoa"" p ON p.""pessoaId"" = ""pat"".""pessoaId""
                                LEFT OUTER JOIN ""dbo"".""Unidade"" ""u1"" ON ""u1"".""unidadeId"" = p.""unidadeId"" AND (""u1"".""pessoaIdChefe"" = p.""pessoaId"" OR ""u1"".""pessoaIdChefeSubstituto"" = p.""pessoaId"")
                            WHERE p.""situacaoPessoaId"" = 1 
                                AND (""pat"".""dataInicio"" <= LOCALTIMESTAMP) AND (""pat"".""dataFim"" IS NULL OR ""pat"".""dataFim"" <= LOCALTIMESTAMP)
                    ) ""up"" 
                    WHERE ""up"".""unidadeId"" IN (SELECT ""unidadeId""
                                            FROM ""dbo"".""VW_UnidadeSiglaCompleta""
                                            WHERE ""undSiglaCompleta"" LIKE (SELECT u.""undSiglaCompleta"" || '%'
                                                                        FROM ""dbo"".""VW_UnidadeSiglaCompleta"" u
                                                                        WHERE u.""unidadeId"" = @unidadeId))
                    ORDER BY ""up"".""nome""
                ";
            }
        }
        public static string ObterChefesPorUnidade
        {
            get
            {
                return @"
                    SELECT ""pessoaId"" ""pessoaId"", ""pesNome"" ""nome"", ""pesEmail"" ""email""
                    FROM ""dbo"".""Pessoa"" p
	                    INNER JOIN ""dbo"".""VW_UnidadeSiglaCompleta"" u ON p.""unidadeId"" = u.""unidadeId""
                    WHERE p.""tipoFuncaoId"" IS NOT NULL
	                    AND u.""undSiglaCompleta"" IN @siglas
                ";
            }
        }

        public static string ObterSubordinadasPorUnidade
        {
            get
            {
                return @"
                    SELECT ""unidadeId"" ""id""
	                       ,""undSiglaCompleta"" ""descricao""
                    FROM ""dbo"".""VW_UnidadeSiglaCompleta"" u
                        WHERE ""undSiglaCompleta"" LIKE (SELECT ""undSiglaCompleta"" || '%' FROM ""dbo"".""VW_UnidadeSiglaCompleta"" ""us"" WHERE ""us"".""unidadeId"" = @unidadeId)
                    ORDER BY ""undSiglaCompleta""
                ";
            }
        }

    }
}
