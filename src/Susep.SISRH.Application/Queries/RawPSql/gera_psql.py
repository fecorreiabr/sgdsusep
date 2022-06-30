from os import listdir
from os.path import isfile, join, dirname, realpath
import re

cur_dir = dirname(realpath(__file__))
raw_sql_dir = join(cur_dir, '../RawSql')

def get_arquivos():    
    filenames = [f for f in listdir(raw_sql_dir) if isfile(join(raw_sql_dir, f))]
    return [ler_arquivo(f) for f in filenames]

def ler_arquivo(filename):
    f = open(join(raw_sql_dir, filename), 'r')
    return (filename, f.read())

def gravar_arquivo(filename: str, conteudo: str):
    f = open(join(cur_dir, filename), 'w')
    f.write(conteudo)
    f.close()

def remove_chaves(conteudo: str):
    return re.sub(r'\[|\]', '', conteudo)

def sanitizar(conteudo: str):
    #maiusculas
    ret = re.sub(
        r'\bselect\b|\bcount\b|\bcase\b|\bwhen\b|\bthen\b|\belse\b|\bend\b|\bas\b|\bfrom\b|\bleft\b|bright\b|\binner\b|\bouter\b|\bjoin\b|\bon\b|\bin\b|\bwhere\b|\band\b|\bor\b|\blike\b|\bis\b|\bnull\b|group by|\bhaving\b|\bunion\b|\bintersect\b|\bexcept\b|\ball\b|\bdistinct\b|order by|\basc\b|\bdesc\b|\busing\b|\blimit\b|\boffset\b|\bfetch\b|\bfirst\b|\bnext\b|\brow\b|\brows\b|\bonly\b|\bwith\b',
        maiusculas,
        conteudo)
    
    #ponto e virgula para fim de statement
    #nao funciona, estrutura muito complexa, necessario PLN
    # i = 0
    # selects = re.finditer('SELECT', ret)
    # for s in selects:
    #     str_antes = ret[s.start() - 100 - i: s.start() - i]
    #     if re.match(r'return|UNION|JOIN', str_antes) is not None:
    #         ret = ret[:s.start() - 100 - i] + ';' + ret[s.start() - 100 - i:]
    #         i +=1

    return ret

def maiusculas(match: re.Match):
    m = match.group()
    return m.upper()

def altera_ns(conteudo: str):
    return re.sub('Susep.SISRH.Application.Queries.RawSql', 'Susep.SISRH.Application.Queries.RawPSql', conteudo)

def nomes_campos(match: re.Match):
    m = match.group()
    return re.sub(r'([\s\.,\(])(([a-z]{1,}\w+)|([A-Z]{1}[a-z]{1,}\w+)|(VW_\w+))', r'\1""\2""', m)

def ajusta_excecoes(conteudo: str):
    #campo CPF maiusculo
    ret = re.sub(' CPF', ' ""CPF""', conteudo)
    
    #campo ASsuntoId escrito errado
    ret = re.sub('ASsuntoId', '""ASsuntoId""', ret)

    #campo pessoaid escrito errado
    ret = re.sub('""pessoaid""', '""pessoaId""', ret)

    #campo dataOperacao escrito de modo divergente
    ret = re.sub('""dataOperacao""', '""DataOperacao""', ret)

    #campo modalidadeExecucaoId
    ret = re.sub(',""modalidadeExecucaoId""', ',p.""modalidadeExecucaoId""', ret)

    #campo analisado virou boolean
    ret = re.sub('""analisado"" = 0', '""analisado"" = FALSE', ret)

    #dbo escrito errado
    ret = re.sub('JOINdbo', 'JOIN ""dbo""', ret)
    ret = re.sub('FROMdbo', 'FROM ""dbo""', ret)

    #tabela SituacaoPessoa escrita errada
    ret = re.sub('""dbo"".""situacaoPessoa""', '""dbo"".""SituacaoPessoa""', ret)

    #tabela Pessoa escrita errada
    ret = re.sub('""dbo"".""pessoa""', '""dbo"".""Pessoa""', ret)

    #tabela PessoaAlocacaoTemporaria sem o dbo
    ret = re.sub(' ""PessoaAlocacaoTemporaria""', '""dbo"".""PessoaAlocacaoTemporaria""', ret)

    #funcoes
    ret = re.sub(r'("")([a-z]+)(""\()', r'\2(', ret)
    ret = re.sub(r'getdate\(\)', 'LOCALTIMESTAMP', ret)
    ret = re.sub(r'isnull\(', 'COALESCE(', ret, flags=re.IGNORECASE)
    ret = re.sub(r'(year\()(.+?)(\))', r'EXTRACT(YEAR FROM \2\3::INT', ret, flags=re.IGNORECASE)
    ret = re.sub(r'(month\()(.+?)(\))', r'EXTRACT(month FROM \2\3::INT', ret, flags=re.IGNORECASE)
    ret = re.sub(r'(day\()(.+?)(\))', r'EXTRACT(day FROM \2\3::INT', ret, flags=re.IGNORECASE)
    ret = re.sub(r'datefromparts\s?\(', 'MAKE_DATE(', ret, flags=re.IGNORECASE)

    #operador '+' quando usado com string
    ret = re.sub(r'\+\s?\'', '|| \'', ret)
    ret = re.sub(r'\'\s?\+', '\' ||', ret)
    ret = re.sub(r'""titulo""\s?\+', '""titulo"" ||', ret)

    #bit to smallint
    ret = re.sub('AS BIT', 'AS SMALLINT', ret)

    #SELECT TOP nao tem no Postgres
    ret = re.sub(r'(SELECT TOP) (\d)(.+?)(ORDER BY.)((?:[\w\.\s,]|"")+)', r'SELECT \3\4\5 LIMIT \2', ret, flags=re.DOTALL)

    return ret

def main():
    arquivos = get_arquivos()
    i = 0
    for filename, conteudo in arquivos:
        novo_conteudo = remove_chaves(conteudo)
        novo_conteudo = sanitizar(novo_conteudo)
        novo_conteudo = altera_ns(novo_conteudo)
        novo_conteudo = re.sub(r'(return @".*?")', nomes_campos, novo_conteudo, flags=re.S)
        novo_conteudo = ajusta_excecoes(novo_conteudo)
        gravar_arquivo(filename, novo_conteudo)

if __name__ == '__main__':
    main()