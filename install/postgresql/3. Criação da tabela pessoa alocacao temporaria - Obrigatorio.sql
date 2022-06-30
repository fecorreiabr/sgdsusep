
CREATE TABLE dbo."PessoaAlocacaoTemporaria"(
	"pessoaAlocacaoTemporariaId" uuid NOT NULL,
	"pessoaId" bigint NOT NULL,
	"unidadeId" bigint NOT NULL,
	"dataInicio" date NOT NULL,
	"dataFim" date NULL,
 CONSTRAINT "PK_PessoaAlocacaoTemporaria" PRIMARY KEY 
(
	"pessoaAlocacaoTemporariaId"
)
);

ALTER TABLE dbo."PessoaAlocacaoTemporaria" ADD  CONSTRAINT "FK_PessoaAlocacaoTemporaria_Pessoa" FOREIGN KEY("pessoaId")
REFERENCES dbo."Pessoa" ("pessoaId");

ALTER TABLE dbo."PessoaAlocacaoTemporaria" ADD  CONSTRAINT "FK_PessoaAlocacaoTemporaria_Unidade" FOREIGN KEY("unidadeId")
REFERENCES dbo."Unidade" ("unidadeId");


/*EXEC sys.sp_addextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PessoaAlocacaoTemporaria', @level2type=N'COLUMN',
@level2name=N'pessoaAlocacaoTemporariaId', @value=N'Chave da tabela de alocação temporária'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PessoaAlocacaoTemporaria', @level2type=N'COLUMN',
@level2name=N'pessoaId', @value=N'Pessoa que foi alocada temporariamente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PessoaAlocacaoTemporaria', @level2type=N'COLUMN',
@level2name=N'unidadeId', @value=N'Unidade da alocação temporária'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PessoaAlocacaoTemporaria', @level2type=N'COLUMN',
@level2name=N'dataInicio', @value=N'Data em que se iniciou a alocação temporária'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PessoaAlocacaoTemporaria', @level2type=N'COLUMN',
@level2name=N'dataFim', @value=N'Data em que se encerrou a alocação temporária'
GO
*/