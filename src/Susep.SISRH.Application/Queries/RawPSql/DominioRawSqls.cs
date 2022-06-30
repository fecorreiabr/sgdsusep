namespace Susep.SISRH.Application.Queries.RawPSql
{
    public static class DominioRawSqls
    {

        public static string ObterDominios
        {
            get
            {
                return @"
                    SELECT ""catalogoDominioId"" AS ""id"", ""descricao""
                    FROM ""dbo"".""CatalogoDominio""
                    WHERE ""classificacao"" = @classificacao 
                        AND ""ativo"" = 1
                    ORDER BY ""descricao""
                    ";
            }
        }

        public static string ObterPorChave
        {
            get
            {
                return @"
                    SELECT ""catalogoDominioId"" AS ""id"", ""descricao""
                    FROM ""dbo"".""CatalogoDominio""
                    WHERE ""catalogoDominioId"" = @id                        
                    ORDER BY ""descricao""
                    ";
            }
        }
    }
}
