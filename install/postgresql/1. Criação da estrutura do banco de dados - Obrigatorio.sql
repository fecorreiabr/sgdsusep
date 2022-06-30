CREATE SCHEMA "ProgramaGestao";

CREATE SCHEMA dbo;
GRANT ALL ON SCHEMA dbo TO postgres;
SET search_path TO dbo;
ALTER DATABASE postgres SET search_path TO dbo;

DROP SCHEMA public;

CREATE TABLE dbo."CatalogoDominio"(
	"catalogoDominioId" int NOT NULL,
	"classificacao" varchar(50) NOT NULL,
	"descricao" varchar(100) NOT NULL,
	"ativo" smallint NOT NULL,
CONSTRAINT "PK_CatalogoDominio" PRIMARY KEY 
(
	"catalogoDominioId"
)
);

CREATE TABLE dbo."Feriado"(
	"feriadoId" bigserial NOT NULL,
	"ferData" timestamptz NOT NULL,
	"ferFixo" smallint NOT NULL,
	"ferDescricao" varchar(50) NOT NULL,
	"ufId" varchar(2) NULL,
 CONSTRAINT "PK_Feriado" PRIMARY KEY 
(
	"feriadoId"
)
);

CREATE TABLE dbo."Pessoa"(
	"pessoaId" bigserial NOT NULL,
	"pesNome" varchar(150) NOT NULL,
	"pesCPF" varchar(15) NOT NULL,
	"pesDataNascimento" timestamptz NOT NULL,
	"pesMatriculaSiape" varchar(12) NULL,
	"pesEmail" varchar(150) NULL,
	"unidadeId" bigint NOT NULL,
	"tipoFuncaoId" bigint NULL,
	"CargaHoraria" int NULL,
 CONSTRAINT "PK_Pessoa" PRIMARY KEY 
(
	"pessoaId"
)
);

CREATE TABLE dbo."TipoFuncao"(
	"tipoFuncaoId" bigint NOT NULL,
	"tfnDescricao" varchar(150) NOT NULL,
	"tfnCodigoFuncao" varchar(5) NULL,
	"tfnIndicadorChefia" smallint NULL,
 CONSTRAINT "PK_TipoFuncao" PRIMARY KEY 
(
	"tipoFuncaoId"
),
 CONSTRAINT "UQ_TipoFuncao_tfnDescricao" UNIQUE 
(
	"tfnDescricao"
)
);

CREATE TABLE dbo."UF"(
	"ufId" varchar(2) NOT NULL,
	"ufDescricao" varchar(50) NOT NULL,
 CONSTRAINT "PK_UnidadeFederativa" PRIMARY KEY 
(
	"ufId"
),
 CONSTRAINT "UQ_UnidadeFederativa_ufDescricao" UNIQUE 
(
	"ufDescricao"
)
);

CREATE TABLE dbo."Unidade"(
	"unidadeId" bigserial NOT NULL,
	"undSigla" varchar(50) NOT NULL,
	"undDescricao" varchar(150) NOT NULL,
	"unidadeIdPai" bigint NULL,
	"tipoUnidadeId" bigint NOT NULL,
	"situacaoUnidadeId" bigint NOT NULL,
	"ufId" varchar(2) NOT NULL,
	"undNivel" smallint NULL,
	"tipoFuncaoUnidadeId" bigint NULL,
	"Email" varchar(150) NULL,
	"undCodigoSIORG" int NULL,
 CONSTRAINT "PK_Unidade" PRIMARY KEY 
(
	"unidadeId"
)
);

CREATE TABLE "ProgramaGestao"."Assunto"(
	"assuntoId" uuid NOT NULL,
	"chave" varchar(10) NOT NULL,
	"valor" varchar(100) NOT NULL,
	"assuntoPaiId" uuid NULL,
	"ativo" smallint NOT NULL,
 CONSTRAINT "PK_Assunto" PRIMARY KEY 
(
	"assuntoId"
),
 CONSTRAINT "UQ_Chave" UNIQUE 
(
	"chave"
)
);

CREATE TABLE "ProgramaGestao"."Catalogo"(
	"catalogoId" uuid NOT NULL,
	"unidadeId" bigint NOT NULL,
PRIMARY KEY
(
	"catalogoId"
)
);

CREATE TABLE "ProgramaGestao"."CatalogoItemCatalogo"(
	"catalogoItemCatalogoId" uuid NOT NULL,
	"catalogoId" uuid NOT NULL,
	"itemCatalogoId" uuid NOT NULL,
PRIMARY KEY
(
	"catalogoItemCatalogoId"
)
);

CREATE TABLE "ProgramaGestao"."ItemCatalogo"(
	"itemCatalogoId" uuid NOT NULL,
	"titulo" varchar(250) NOT NULL,
	"calculoTempoId" int NOT NULL,
	"permiteRemoto" boolean NOT NULL,
	"tempoPresencial" numeric(4, 1) NULL,
	"tempoRemoto" numeric(4, 1) NULL,
	"descricao" varchar(2000) NULL,
	"complexidade" varchar(20) NULL,
	"definicaoComplexidade" varchar(200) NULL,
	"entregasEsperadas" varchar(200) NULL,
PRIMARY KEY
(
	"itemCatalogoId"
)
);

CREATE TABLE "ProgramaGestao"."ItemCatalogoAssunto"(
	"itemCatalogoAssuntoId" uuid NOT NULL,
	"assuntoId" uuid NOT NULL,
	"itemCatalogoId" uuid NOT NULL,
 CONSTRAINT "PK_Item_Catalogo_Assunto" PRIMARY KEY
(
	"itemCatalogoAssuntoId"
),
 CONSTRAINT "UK_ItemCatalogoAssunto_Assunto_ItemCatalogo" UNIQUE 
(
	"assuntoId",
	"itemCatalogoId"
)
);

CREATE TABLE "ProgramaGestao"."Objeto"(
	"objetoId" uuid NOT NULL,
	"descricao" varchar(100) NOT NULL,
	"tipo" int NOT NULL,
	"chave" varchar(20) NOT NULL,
	"ativo" smallint NOT NULL,
 CONSTRAINT "PK_Objeto" PRIMARY KEY 
(
	"objetoId"
),
 CONSTRAINT "UQ_Objeto_Chave" UNIQUE 
(
	"chave"
)
);

CREATE TABLE "ProgramaGestao"."PactoAtividadePlanoObjeto"(
	"pactoAtividadePlanoObjetoId" uuid NOT NULL,
	"planoTrabalhoObjetoId" uuid NOT NULL,
	"pactoTrabalhoAtividadeId" uuid NOT NULL,
 CONSTRAINT "PK_PactoAtividadePlanoObjeto" PRIMARY KEY 
(
	"pactoAtividadePlanoObjetoId"
),
 CONSTRAINT "UQ_PlanoObjeto_PactoAtividade" UNIQUE 
(
	"planoTrabalhoObjetoId",
	"pactoTrabalhoAtividadeId"
)
);

CREATE TABLE "ProgramaGestao"."PactoTrabalho"(
	"pactoTrabalhoId" uuid NOT NULL,
	"planoTrabalhoId" uuid NOT NULL,
	"unidadeId" bigint NOT NULL,
	"pessoaId" bigint NOT NULL,
	"dataInicio" date NOT NULL,
	"dataFim" date NOT NULL,
	"formaExecucaoId" int NOT NULL,
	"situacaoId" int NOT NULL,
	"tempoComparecimento" int NULL,
	"cargaHorariaDiaria" int NOT NULL,
	"percentualExecucao" numeric(10, 2) NULL,
	"relacaoPrevistoRealizado" numeric(10, 2) NULL,
	"avaliacaoId" uuid NULL,
	"tempoTotalDisponivel" int NOT NULL,
	"termoAceite" text NULL,
PRIMARY KEY
(
	"pactoTrabalhoId"
)
);

CREATE TABLE "ProgramaGestao"."PactoTrabalhoAtividade"(
	"pactoTrabalhoAtividadeId" uuid NOT NULL,
	"pactoTrabalhoId" uuid NOT NULL,
	"itemCatalogoId" uuid NOT NULL,
	"quantidade" int NOT NULL,
	"tempoPrevistoPorItem" numeric(4, 1) NOT NULL,
	"tempoPrevistoTotal" numeric(4, 1) NOT NULL,
	"dataInicio" timestamptz NULL,
	"dataFim" timestamptz NULL,
	"tempoRealizado" numeric(4, 1) NULL,
	"situacaoId" int NOT NULL,
	"descricao" varchar(2000) NULL,
	"tempoHomologado" numeric(4, 1) NULL,
	"nota" numeric(4, 2) NULL,
	"justificativa" varchar(200) NULL,
	"consideracoesConclusao" varchar(2000) NULL,
PRIMARY KEY
(
	"pactoTrabalhoAtividadeId"
)
);

CREATE TABLE "ProgramaGestao"."PactoTrabalhoAtividadeAssunto"(
	"pactoTrabalhoAtividadeAssuntoId" uuid NOT NULL,
	"pactoTrabalhoAtividadeId" uuid NOT NULL,
	"assuntoId" uuid NOT NULL,
 CONSTRAINT "PK_PactoTrabalhoAtividadeAssunto" PRIMARY KEY 
(
	"pactoTrabalhoAtividadeAssuntoId"
),
 CONSTRAINT "UK_PactoTrabalhoAtividadeAssunto_Assunto_PactoTrabalhoAtividade" UNIQUE 
(
	"assuntoId",
	"pactoTrabalhoAtividadeId"
)
);

CREATE TABLE "ProgramaGestao"."PactoTrabalhoHistorico"(
	"pactoTrabalhoHistoricoId" uuid NOT NULL,
	"pactoTrabalhoId" uuid NOT NULL,
	"situacaoId" int NOT NULL,
	"observacoes" varchar(2000) NULL,
	"responsavelOperacao" varchar(50) NOT NULL,
	"DataOperacao" timestamptz NOT NULL,
PRIMARY KEY 
(
	"pactoTrabalhoHistoricoId"
)
);

CREATE TABLE "ProgramaGestao"."PactoTrabalhoSolicitacao"(
	"pactoTrabalhoSolicitacaoId" uuid NOT NULL,
	"pactoTrabalhoId" uuid NOT NULL,
	"tipoSolicitacaoId" int NOT NULL,
	"dataSolicitacao" timestamptz NOT NULL,
	"solicitante" varchar(50) NOT NULL,
	"dadosSolicitacao" varchar(2000) NOT NULL,
	"observacoesSolicitante" varchar(2000) NULL,
	"analisado" boolean NOT NULL,
	"dataAnalise" timestamptz NULL,
	"analista" varchar(50) NULL,
	"aprovado" boolean NULL,
	"observacoesAnalista" varchar(2000) NULL,
PRIMARY KEY
(
	"pactoTrabalhoSolicitacaoId"
)
);

CREATE TABLE "ProgramaGestao"."PessoaModalidadeExecucao"(
	"pessoaModalidadeExecucaoId" uuid NOT NULL,
	"pessoaId" bigint NOT NULL,
	"modalidadeExecucaoId" int NOT NULL,
PRIMARY KEY
(
	"pessoaModalidadeExecucaoId"
)
);

CREATE TABLE "ProgramaGestao"."PlanoTrabalho"(
	"planoTrabalhoId" uuid NOT NULL,
	"unidadeId" bigint NOT NULL,
	"dataInicio" date NOT NULL,
	"dataFim" date NOT NULL,
	"situacaoId" int NOT NULL,
	"avaliacaoId" uuid NULL,
	"tempoComparecimento" int NULL,
	"totalServidoresSetor" int NULL,
	"tempoFaseHabilitacao" int NULL,
	"termoAceite" text NULL,
PRIMARY KEY
(
	"planoTrabalhoId"
)
);

CREATE TABLE "ProgramaGestao"."PlanoTrabalhoAtividade"(
	"planoTrabalhoAtividadeId" uuid NOT NULL,
	"planoTrabalhoId" uuid NOT NULL,
	"modalidadeExecucaoId" int NOT NULL,
	"quantidadeColaboradores" int NOT NULL,
	"descricao" varchar(2000) NULL,
PRIMARY KEY
(
	"planoTrabalhoAtividadeId"
)
);

CREATE TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeAssunto"(
	"planoTrabalhoAtividadeAssuntoId" uuid NOT NULL,
	"assuntoId" uuid NOT NULL,
	"planoTrabalhoAtividadeId" uuid NOT NULL,
 CONSTRAINT "PK_PlanoTrabalhoAtividadeAssunto" PRIMARY KEY 
(
	"planoTrabalhoAtividadeAssuntoId"
),
 CONSTRAINT "UK_PlanoTrabalhoAtividadeAssunto_Assunto_PlanoTrabalhoAtividade" UNIQUE 
(
	"assuntoId",
	"planoTrabalhoAtividadeId"
)
);

CREATE TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeCandidato"(
	"planoTrabalhoAtividadeCandidatoId" uuid NOT NULL,
	"planoTrabalhoAtividadeId" uuid NOT NULL,
	"pessoaId" bigint NOT NULL,
	"situacaoId" int NOT NULL,
	"termoAceite" text NULL,
PRIMARY KEY
(
	"planoTrabalhoAtividadeCandidatoId"
)
);

CREATE TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeCandidatoHistorico"(
	"planoTrabalhoAtividadeCandidatoHistoricoId" uuid NOT NULL,
	"planoTrabalhoAtividadeCandidatoId" uuid NOT NULL,
	"situacaoId" int NOT NULL,
	"data" timestamptz NOT NULL,
	"descricao" varchar(2000) NULL,
	"responsavelOperacao" varchar(25) NOT NULL,
PRIMARY KEY
(
	"planoTrabalhoAtividadeCandidatoHistoricoId"
)
);

CREATE TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeCriterio"(
	"planoTrabalhoAtividadeCriterioId" uuid NOT NULL,
	"planoTrabalhoAtividadeId" uuid NOT NULL,
	"criterioId" int NOT NULL,
PRIMARY KEY 
(
	"planoTrabalhoAtividadeCriterioId"
)
);

CREATE TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeItem"(
	"planoTrabalhoAtividadeItemId" uuid NOT NULL,
	"planoTrabalhoAtividadeId" uuid NOT NULL,
	"itemCatalogoId" uuid NOT NULL,
PRIMARY KEY
(
	"planoTrabalhoAtividadeItemId"
)
);

CREATE TABLE "ProgramaGestao"."PlanoTrabalhoCusto"(
	"planoTrabalhoCustoId" uuid NOT NULL,
	"planoTrabalhoId" uuid NOT NULL,
	"valor" numeric(9, 2) NOT NULL,
	"descricao" varchar(100) NOT NULL,
	"planoTrabalhoObjetoId" uuid NULL,
 CONSTRAINT "PK_PlanoTrabalhoCusto" PRIMARY KEY 
(
	"planoTrabalhoCustoId"
)
);

CREATE TABLE "ProgramaGestao"."PlanoTrabalhoHistorico"(
	"planoTrabalhoHistoricoId" uuid NOT NULL,
	"planoTrabalhoId" uuid NOT NULL,
	"situacaoId" int NOT NULL,
	"observacoes" varchar(2000) NULL,
	"responsavelOperacao" varchar(50) NOT NULL,
	"DataOperacao" timestamptz NOT NULL,
PRIMARY KEY
(
	"planoTrabalhoHistoricoId"
)
);

CREATE TABLE "ProgramaGestao"."PlanoTrabalhoMeta"(
	"planoTrabalhoMetaId" uuid NOT NULL,
	"planoTrabalhoId" uuid NOT NULL,
	"meta" varchar(250) NOT NULL,
	"indicador" varchar(250) NOT NULL,
	"descricao" varchar(2000) NULL,
PRIMARY KEY
(
	"planoTrabalhoMetaId"
)
);

CREATE TABLE "ProgramaGestao"."PlanoTrabalhoObjeto"(
	"planoTrabalhoObjetoId" uuid NOT NULL,
	"planoTrabalhoId" uuid NOT NULL,
	"objetoId" uuid NOT NULL,
 CONSTRAINT "PK_PlanoTrabalhoObjeto" PRIMARY KEY 
(
	"planoTrabalhoObjetoId"
),
 CONSTRAINT "UQ_PlanoTrabalho_Objeto" UNIQUE 
(
	"planoTrabalhoId",
	"objetoId"
)
);

CREATE TABLE "ProgramaGestao"."PlanoTrabalhoObjetoAssunto"(
	"planoTrabalhoObjetoAssuntoId" uuid NOT NULL,
	"planoTrabalhoObjetoId" uuid NOT NULL,
	"assuntoId" uuid NOT NULL,
 CONSTRAINT "PK_PlanoTrabalhoObjetoAssunto" PRIMARY KEY 
(
	"planoTrabalhoObjetoAssuntoId"
),
 CONSTRAINT "UQ_PlanoTrabalhoObjeto_Assunto" UNIQUE 
(
	"planoTrabalhoObjetoId",
	"assuntoId"
)
);

CREATE TABLE "ProgramaGestao"."PlanoTrabalhoReuniao"(
	"planoTrabalhoReuniaoId" uuid NOT NULL,
	"planoTrabalhoId" uuid NOT NULL,
	"data" timestamptz NOT NULL,
	"titulo" varchar(250) NOT NULL,
	"descricao" varchar(250) NULL,
	"planoTrabalhoObjetoId" uuid NULL,
PRIMARY KEY
(
	"planoTrabalhoReuniaoId"
)
);

CREATE TABLE "ProgramaGestao"."UnidadeModalidadeExecucao"(
	"unidadeModalidadeExecucaoId" uuid NOT NULL,
	"unidadeId" bigint NOT NULL,
	"modalidadeExecucaoId" int NOT NULL,
PRIMARY KEY
(
	"unidadeModalidadeExecucaoId"
)
);

CREATE VIEW dbo."VW_UnidadeSiglaCompleta"
as
with recursive cte
AS
(
	SELECT	u."unidadeId", u."undNivel", u."undSigla" as "undSiglaCompleta", u."undSigla", u."Email", u."undCodigoSIORG"
	FROM	dbo."Unidade" as u
	WHERE	u."unidadeIdPai" is null and u."situacaoUnidadeId" = 1
	UNION ALL
	SELECT	u."unidadeId", u."undNivel", cast(cte."undSiglaCompleta" || '/' || u."undSigla" as varchar(50)), u."undSigla", u."Email", u."undCodigoSIORG"
	FROM	dbo."Unidade" as u
	INNER JOIN cte ON u."unidadeIdPai" = cte."unidadeId"
)
SELECT und."unidadeId", und."undSigla", und."undDescricao", und."unidadeIdPai", und."tipoUnidadeId",
und."situacaoUnidadeId", und."ufId", und."undNivel", und."tipoFuncaoUnidadeId", cte."undSiglaCompleta", und."Email", und."undCodigoSIORG"
FROM cte 
INNER JOIN dbo."Unidade" und on cte."unidadeId" = und."unidadeId";

-- Remover campo chave da view VW_AssuntoChaveCompleta
CREATE VIEW "ProgramaGestao"."VW_AssuntoChaveCompleta"
AS
	with recursive "cte_assunto" AS (

		SELECT 
			"assuntoId", 
			"valor", 
			"assuntoPaiId", 
			"ativo", 
			CAST(valor AS varchar(200)) AS "hierarquia", 
			1 as "nivel"
		FROM "ProgramaGestao"."Assunto"
		WHERE "assuntoPaiId" IS  NULL

		UNION ALL

		SELECT 
			filho."assuntoId", 
			filho."valor", 
			filho."assuntoPaiId", 
			filho."ativo", 
			CAST(CONCAT(pai."hierarquia", '/', filho."valor") AS VARCHAR(200)) AS "hierarquia", 
			pai."nivel" + 1 AS "nivel"
		FROM "ProgramaGestao"."Assunto" filho
		JOIN "cte_assunto" pai ON filho."assuntoPaiId" = pai."assuntoId"

	)
	SELECT *
	FROM "cte_assunto";

ALTER TABLE dbo."TipoFuncao" ALTER COLUMN "tfnIndicadorChefia" SET DEFAULT 0;

ALTER TABLE dbo."Feriado" ADD  CONSTRAINT "FK_Feriado_UF" FOREIGN KEY("ufId")
REFERENCES dbo."UF" ("ufId");

ALTER TABLE dbo."Pessoa" ADD  CONSTRAINT "FK_Pessoa_TipoFuncao" FOREIGN KEY("tipoFuncaoId")
REFERENCES dbo."TipoFuncao" ("tipoFuncaoId");

ALTER TABLE dbo."Pessoa" ADD  CONSTRAINT "FK_Pessoa_Unidade" FOREIGN KEY("unidadeId")
REFERENCES dbo."Unidade" ("unidadeId");

ALTER TABLE dbo."Unidade" ADD  CONSTRAINT "FK_Unidade_UF" FOREIGN KEY("ufId")
REFERENCES dbo."UF" ("ufId");

ALTER TABLE dbo."Unidade" ADD  CONSTRAINT "FK_Unidade_UnidadePai" FOREIGN KEY("unidadeIdPai")
REFERENCES dbo."Unidade" ("unidadeId");

ALTER TABLE "ProgramaGestao"."Assunto" ADD  CONSTRAINT "FK_Assunto_AssuntoPai" FOREIGN KEY("assuntoPaiId")
REFERENCES "ProgramaGestao"."Assunto" ("assuntoId");

ALTER TABLE "ProgramaGestao"."Catalogo" ADD  CONSTRAINT "FK_Catalogo_Unidade" FOREIGN KEY("unidadeId")
REFERENCES dbo."Unidade" ("unidadeId");

ALTER TABLE "ProgramaGestao"."CatalogoItemCatalogo" ADD  CONSTRAINT "FK_CatalogoItemCatalogo_Catalogo" FOREIGN KEY("catalogoId")
REFERENCES "ProgramaGestao"."Catalogo" ("catalogoId");

ALTER TABLE "ProgramaGestao"."CatalogoItemCatalogo" ADD  CONSTRAINT "FK_CatalogoItemCatalogo_ItemCatalogo" FOREIGN KEY("itemCatalogoId")
REFERENCES "ProgramaGestao"."ItemCatalogo" ("itemCatalogoId");

ALTER TABLE "ProgramaGestao"."ItemCatalogo" ADD  CONSTRAINT "FK_ItemCatalogo_CalculoTempo" FOREIGN KEY("calculoTempoId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."ItemCatalogoAssunto" ADD  CONSTRAINT "FK_ItemCatalogoAssunto_Assunto" FOREIGN KEY("assuntoId")
REFERENCES "ProgramaGestao"."Assunto" ("assuntoId");

ALTER TABLE "ProgramaGestao"."ItemCatalogoAssunto" ADD  CONSTRAINT "FK_ItemCatalogoAssunto_ItemCatalogo" FOREIGN KEY("itemCatalogoId")
REFERENCES "ProgramaGestao"."ItemCatalogo" ("itemCatalogoId");

ALTER TABLE "ProgramaGestao"."PactoAtividadePlanoObjeto" ADD  CONSTRAINT "FK_PactoAtividadePlanoObjeto_PactoTrabalhoAtividade" FOREIGN KEY("pactoTrabalhoAtividadeId")
REFERENCES "ProgramaGestao"."PactoTrabalhoAtividade" ("pactoTrabalhoAtividadeId");

ALTER TABLE "ProgramaGestao"."PactoAtividadePlanoObjeto" ADD  CONSTRAINT "FK_PactoAtividadePlanoObjeto_PlanoTrabalhoObjeto" FOREIGN KEY("planoTrabalhoObjetoId")
REFERENCES "ProgramaGestao"."PlanoTrabalhoObjeto" ("planoTrabalhoObjetoId");

ALTER TABLE "ProgramaGestao"."PactoTrabalho" ADD  CONSTRAINT "FK_PactoTrabalho_FormaExecucao" FOREIGN KEY("formaExecucaoId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."PactoTrabalho" ADD  CONSTRAINT "FK_PactoTrabalho_Pessoa" FOREIGN KEY("pessoaId")
REFERENCES dbo."Pessoa" ("pessoaId");

ALTER TABLE "ProgramaGestao"."PactoTrabalho" ADD  CONSTRAINT "FK_PactoTrabalho_PlanoTrabalho" FOREIGN KEY("planoTrabalhoId")
REFERENCES "ProgramaGestao"."PlanoTrabalho" ("planoTrabalhoId");

ALTER TABLE "ProgramaGestao"."PactoTrabalho" ADD  CONSTRAINT "FK_PactoTrabalho_Situacao" FOREIGN KEY("situacaoId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."PactoTrabalho" ADD  CONSTRAINT "FK_PactoTrabalho_Unidade" FOREIGN KEY("unidadeId")
REFERENCES dbo."Unidade" ("unidadeId");

ALTER TABLE "ProgramaGestao"."PactoTrabalhoAtividade" ADD  CONSTRAINT "FK_PactoTrabalhoAtividade_ItemCatalogo" FOREIGN KEY("itemCatalogoId")
REFERENCES "ProgramaGestao"."ItemCatalogo" ("itemCatalogoId");

ALTER TABLE "ProgramaGestao"."PactoTrabalhoAtividade" ADD  CONSTRAINT "FK_PactoTrabalhoAtividade_PactoTrabalho" FOREIGN KEY("pactoTrabalhoId")
REFERENCES "ProgramaGestao"."PactoTrabalho" ("pactoTrabalhoId");

ALTER TABLE "ProgramaGestao"."PactoTrabalhoAtividade" ADD  CONSTRAINT "FK_PactoTrabalhoAtividade_Situacao" FOREIGN KEY("situacaoId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."PactoTrabalhoAtividadeAssunto" ADD  CONSTRAINT "FK_PactoTrabalhoAtividadeAssunto_Assunto" FOREIGN KEY("assuntoId")
REFERENCES "ProgramaGestao"."Assunto" ("assuntoId");

ALTER TABLE "ProgramaGestao"."PactoTrabalhoAtividadeAssunto" ADD  CONSTRAINT "FK_PactoTrabalhoAtividadeAssunto_PactoTrabalhoAtividade" FOREIGN KEY("pactoTrabalhoAtividadeId")
REFERENCES "ProgramaGestao"."PactoTrabalhoAtividade" ("pactoTrabalhoAtividadeId");

ALTER TABLE "ProgramaGestao"."PactoTrabalhoHistorico" ADD  CONSTRAINT "FK_PactoTrabalhoHistorico_PactoTrabalho" FOREIGN KEY("pactoTrabalhoId")
REFERENCES "ProgramaGestao"."PactoTrabalho" ("pactoTrabalhoId");

ALTER TABLE "ProgramaGestao"."PactoTrabalhoHistorico" ADD  CONSTRAINT "FK_PactoTrabalhoHistorico_Situacao" FOREIGN KEY("situacaoId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."PactoTrabalhoSolicitacao" ADD  CONSTRAINT "FK_PactoTrabalhoSolicitacao_PactoTrabalho" FOREIGN KEY("pactoTrabalhoId")
REFERENCES "ProgramaGestao"."PactoTrabalho" ("pactoTrabalhoId");

ALTER TABLE "ProgramaGestao"."PactoTrabalhoSolicitacao" ADD  CONSTRAINT "FK_PactoTrabalhoSolicitacao_TipoSolicitacao" FOREIGN KEY("tipoSolicitacaoId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."PessoaModalidadeExecucao" ADD  CONSTRAINT "FK_PessoaModalidadeExecucao_ModalidadeExecucao" FOREIGN KEY("modalidadeExecucaoId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."PessoaModalidadeExecucao" ADD  CONSTRAINT "FK_PessoaModalidadeExecucao_Pessoa" FOREIGN KEY("pessoaId")
REFERENCES dbo."Pessoa" ("pessoaId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalho" ADD  CONSTRAINT "FK_PlanoTrabalho_Unidade" FOREIGN KEY("unidadeId")
REFERENCES dbo."Unidade" ("unidadeId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalho" ADD  CONSTRAINT "FK_PlatoTrabalho_Situacao" FOREIGN KEY("situacaoId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoAtividade" ADD  CONSTRAINT "FK_PlanoTrabalhoAtividade_ModalidadeExecucao" FOREIGN KEY("modalidadeExecucaoId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoAtividade" ADD  CONSTRAINT "FK_PlanoTrabalhoAtividade_PlanoTrabalho" FOREIGN KEY("planoTrabalhoId")
REFERENCES "ProgramaGestao"."PlanoTrabalho" ("planoTrabalhoId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeAssunto" ADD  CONSTRAINT "FK_PlanoTrabalhoAtividadeAssunto_Assunto" FOREIGN KEY("assuntoId")
REFERENCES "ProgramaGestao"."Assunto" ("assuntoId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeAssunto" ADD  CONSTRAINT "FK_PlanoTrabalhoAtividadeAssunto_PlanoTrabalhoAtividade" FOREIGN KEY("planoTrabalhoAtividadeId")
REFERENCES "ProgramaGestao"."PlanoTrabalhoAtividade" ("planoTrabalhoAtividadeId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeCandidato" ADD  CONSTRAINT "FK_PlanoTrabalhoAtividadeCandidato_Pessoa" FOREIGN KEY("pessoaId")
REFERENCES dbo."Pessoa" ("pessoaId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeCandidato" ADD  CONSTRAINT "FK_PlanoTrabalhoAtividadeCandidato_PlanoTrabalhoAtividade" FOREIGN KEY("planoTrabalhoAtividadeId")
REFERENCES "ProgramaGestao"."PlanoTrabalhoAtividade" ("planoTrabalhoAtividadeId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeCandidato" ADD  CONSTRAINT "FK_PlanoTrabalhoAtividadeCandidato_Situacao" FOREIGN KEY("situacaoId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeCandidatoHistorico" ADD  CONSTRAINT "FK_PlanoTrabalhoAtividadeCandidatoHistorico_PlanoTrabalhoAtividadeCandidato" FOREIGN KEY("planoTrabalhoAtividadeCandidatoId")
REFERENCES "ProgramaGestao"."PlanoTrabalhoAtividadeCandidato" ("planoTrabalhoAtividadeCandidatoId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeCandidatoHistorico" ADD  CONSTRAINT "FK_PlanoTrabalhoAtividadeCandidatoHistorico_Situacao" FOREIGN KEY("situacaoId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeCriterio" ADD  CONSTRAINT "FK_PlanoTrabalhoCriterioAtividade_Criterio" FOREIGN KEY("criterioId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeCriterio" ADD  CONSTRAINT "FK_PlanoTrabalhoCriterioAtividade_PlanoTrabalhoAtividade" FOREIGN KEY("planoTrabalhoAtividadeId")
REFERENCES "ProgramaGestao"."PlanoTrabalhoAtividade" ("planoTrabalhoAtividadeId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeItem" ADD  CONSTRAINT "FK_PlanoTrabalhoItemAtividade_ItemCatalogo" FOREIGN KEY("itemCatalogoId")
REFERENCES "ProgramaGestao"."ItemCatalogo" ("itemCatalogoId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoAtividadeItem" ADD  CONSTRAINT "FK_PlanoTrabalhoItemAtividade_PlanoTrabalhoAtividade" FOREIGN KEY("planoTrabalhoAtividadeId")
REFERENCES "ProgramaGestao"."PlanoTrabalhoAtividade" ("planoTrabalhoAtividadeId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoCusto" ADD  CONSTRAINT "FK_PlanoTrabalhoCusto_PlanoTrabalho" FOREIGN KEY("planoTrabalhoId")
REFERENCES "ProgramaGestao"."PlanoTrabalho" ("planoTrabalhoId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoCusto" ADD  CONSTRAINT "FK_PlanoTrabalhoCusto_PlanoTrabalhoObjeto" FOREIGN KEY("planoTrabalhoObjetoId")
REFERENCES "ProgramaGestao"."PlanoTrabalhoObjeto" ("planoTrabalhoObjetoId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoHistorico" ADD  CONSTRAINT "FK_PlanoTrabalhoHistorico_PlanoTrabalho" FOREIGN KEY("planoTrabalhoId")
REFERENCES "ProgramaGestao"."PlanoTrabalho" ("planoTrabalhoId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoHistorico" ADD  CONSTRAINT "FK_PlanoTrabalhoHistorico_Situacao" FOREIGN KEY("situacaoId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoMeta" ADD  CONSTRAINT "FK_PlanoTrabalhoMeta_PlanoTrabalho" FOREIGN KEY("planoTrabalhoId")
REFERENCES "ProgramaGestao"."PlanoTrabalho" ("planoTrabalhoId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoObjeto" ADD  CONSTRAINT "FK_PlanoTrabalhoObjeto_Objeto" FOREIGN KEY("objetoId")
REFERENCES "ProgramaGestao"."Objeto" ("objetoId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoObjeto" ADD  CONSTRAINT "FK_PlanoTrabalhoObjeto_PlanoTrabalho" FOREIGN KEY("planoTrabalhoId")
REFERENCES "ProgramaGestao"."PlanoTrabalho" ("planoTrabalhoId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoObjetoAssunto" ADD  CONSTRAINT "FK_PlanoTrabalhoObjetoAssunto_Assunto" FOREIGN KEY("assuntoId")
REFERENCES "ProgramaGestao"."Assunto" ("assuntoId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoObjetoAssunto" ADD  CONSTRAINT "FK_PlanoTrabalhoObjetoAssunto_PlanoTrabalhoObjeto" FOREIGN KEY("planoTrabalhoObjetoId")
REFERENCES "ProgramaGestao"."PlanoTrabalhoObjeto" ("planoTrabalhoObjetoId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoReuniao" ADD  CONSTRAINT "FK_PlanoTrabalhoReuniao_PlanoTrabalho" FOREIGN KEY("planoTrabalhoId")
REFERENCES "ProgramaGestao"."PlanoTrabalho" ("planoTrabalhoId");

ALTER TABLE "ProgramaGestao"."PlanoTrabalhoReuniao" ADD  CONSTRAINT "FK_PlanoTrabalhoReuniao_PlanoTrabalhoObjeto" FOREIGN KEY("planoTrabalhoObjetoId")
REFERENCES "ProgramaGestao"."PlanoTrabalhoObjeto" ("planoTrabalhoObjetoId");

ALTER TABLE "ProgramaGestao"."UnidadeModalidadeExecucao" ADD  CONSTRAINT "FK_UnidadeModalidadeExecucao_ModalidadeExecucao" FOREIGN KEY("modalidadeExecucaoId")
REFERENCES dbo."CatalogoDominio" ("catalogoDominioId");

ALTER TABLE "ProgramaGestao"."UnidadeModalidadeExecucao" ADD  CONSTRAINT "FK_UnidadeModalidadeExecucao_Unidade" FOREIGN KEY("unidadeId")
REFERENCES dbo."Unidade" ("unidadeId");


CREATE INDEX "IX_Unidade_unidadeIdPai"  
    ON dbo."Unidade" ("unidadeIdPai");   

CREATE or replace FUNCTION iIF(
    condition boolean,       -- IF condition
    true_result anyelement,  -- THEN
    false_result anyelement  -- ELSE
) RETURNS anyelement AS $f$
  SELECT CASE WHEN condition THEN true_result ELSE false_result END
$f$  LANGUAGE SQL IMMUTABLE;

/*EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Código da unidade no SIORG' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Unidade', @level2type=N'COLUMN',@level2name=N'undCodigoSIORG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Campo chave' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'Assunto', @level2type=N'COLUMN',@level2name=N'chave'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Campo valor' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'Assunto', @level2type=N'COLUMN',@level2name=N'valor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Assunto pai' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'Assunto', @level2type=N'COLUMN',@level2name=N'assuntoPaiId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indica se o assunto encontra-se ativo' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'Assunto', @level2type=N'COLUMN',@level2name=N'ativo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Armazena os assuntos.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'Assunto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Título da complexidade do item de catálogo' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'ItemCatalogo', @level2type=N'COLUMN',@level2name=N'complexidade'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Definição de como a atividade deve ser avaliada para ser enquadrada na complexidade' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'ItemCatalogo', @level2type=N'COLUMN',@level2name=N'definicaoComplexidade'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entregas esperadas pela atividade' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'ItemCatalogo', @level2type=N'COLUMN',@level2name=N'entregasEsperadas'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave primária da tabela ItemCatalogoAssunto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'ItemCatalogoAssunto', @level2type=N'COLUMN',@level2name=N'itemCatalogoAssuntoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela Assunto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'ItemCatalogoAssunto', @level2type=N'COLUMN',@level2name=N'assuntoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela ItemCatalogo.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'ItemCatalogoAssunto', @level2type=N'COLUMN',@level2name=N'itemCatalogoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tabela de associação entre ItemCatalogo e Assunto' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'ItemCatalogoAssunto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Campo descrição' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'Objeto', @level2type=N'COLUMN',@level2name=N'descricao'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Campo tipo' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'Objeto', @level2type=N'COLUMN',@level2name=N'tipo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Campo chave' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'Objeto', @level2type=N'COLUMN',@level2name=N'chave'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indica se o objeto encontra-se ativo' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'Objeto', @level2type=N'COLUMN',@level2name=N'ativo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Armazena os objetos.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'Objeto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave primária da tabela PactoAtividadePlanoObjeto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PactoAtividadePlanoObjeto', @level2type=N'COLUMN',@level2name=N'pactoAtividadePlanoObjetoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela PlanoTrabalhoObjeto' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PactoAtividadePlanoObjeto', @level2type=N'COLUMN',@level2name=N'planoTrabalhoObjetoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela PactoTrabalhoAtividade' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PactoAtividadePlanoObjeto', @level2type=N'COLUMN',@level2name=N'pactoTrabalhoAtividadeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tabela de relacionamento entre PlanoTrabalhoObjeto e PactoTrabalhoAtividade.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PactoAtividadePlanoObjeto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Termo de aceite assinado pelo servidor ao aceitar plano de trabalho' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PactoTrabalho', @level2type=N'COLUMN',@level2name=N'termoAceite'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tempo homologado para a realização da atividade.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PactoTrabalhoAtividade', @level2type=N'COLUMN',@level2name=N'tempoHomologado'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nota da avaliação após a conclusão da atividade.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PactoTrabalhoAtividade', @level2type=N'COLUMN',@level2name=N'nota'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Justificativa para a nota de avaliação baixa.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PactoTrabalhoAtividade', @level2type=N'COLUMN',@level2name=N'justificativa'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detalhes que o servidor fornece sobre a atividade ao concluir sua execução.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PactoTrabalhoAtividade', @level2type=N'COLUMN',@level2name=N'consideracoesConclusao'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave primária da tabela PactoTrabalhoAtividadeAssunto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PactoTrabalhoAtividadeAssunto', @level2type=N'COLUMN',@level2name=N'pactoTrabalhoAtividadeAssuntoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela PactoTrabalhoAtividade.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PactoTrabalhoAtividadeAssunto', @level2type=N'COLUMN',@level2name=N'pactoTrabalhoAtividadeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela Assunto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PactoTrabalhoAtividadeAssunto', @level2type=N'COLUMN',@level2name=N'assuntoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tabela de assuntos associados às atividades do PactoTrabalho' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PactoTrabalhoAtividadeAssunto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Termo de aceite a ser assinado pelos servidores nesse programa de gestão' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalho', @level2type=N'COLUMN',@level2name=N'termoAceite'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave primária da tabela PlanoTrabalhoAtividadeAssunto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoAtividadeAssunto', @level2type=N'COLUMN',@level2name=N'planoTrabalhoAtividadeAssuntoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela Assunto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoAtividadeAssunto', @level2type=N'COLUMN',@level2name=N'assuntoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela PlanoTrabalhoAtividade.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoAtividadeAssunto', @level2type=N'COLUMN',@level2name=N'planoTrabalhoAtividadeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tabela de associação entre PlanoTrabalhoAtividade e Assunto' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoAtividadeAssunto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Termo de aceite assinado pelo servidor ao se candidatar a vaga' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoAtividadeCandidato', @level2type=N'COLUMN',@level2name=N'termoAceite'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave primária da tabela PlanoTrabalhoCusto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoCusto', @level2type=N'COLUMN',@level2name=N'planoTrabalhoCustoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela PlanoTrabalho.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoCusto', @level2type=N'COLUMN',@level2name=N'planoTrabalhoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor do custo.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoCusto', @level2type=N'COLUMN',@level2name=N'valor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descrição do custo.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoCusto', @level2type=N'COLUMN',@level2name=N'descricao'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela Objeto' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoCusto', @level2type=N'COLUMN',@level2name=N'planoTrabalhoObjetoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tabela de custos associados ao PlanoTrabalho' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoCusto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave primária da tabela PlanoTrabalhoObjeto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoObjeto', @level2type=N'COLUMN',@level2name=N'planoTrabalhoObjetoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela PlanoTrabalho' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoObjeto', @level2type=N'COLUMN',@level2name=N'planoTrabalhoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela Objeto' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoObjeto', @level2type=N'COLUMN',@level2name=N'objetoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tabela de relacionamento entre PlanoTrabalho e Objeto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoObjeto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave primária da tabela PlanoTrabalhoObjetoAssunto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoObjetoAssunto', @level2type=N'COLUMN',@level2name=N'planoTrabalhoObjetoAssuntoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela PlanoTrabalhoObjeto' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoObjetoAssunto', @level2type=N'COLUMN',@level2name=N'planoTrabalhoObjetoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela Assunto' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoObjetoAssunto', @level2type=N'COLUMN',@level2name=N'assuntoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tabela de relacionamento entre PlanoTrabalhoObjeto e Assunto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoObjetoAssunto'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Chave estrangeira para a tabela Objeto' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'TABLE',@level1name=N'PlanoTrabalhoReuniao', @level2type=N'COLUMN',@level2name=N'planoTrabalhoObjetoId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Campo valor' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'VIEW',@level1name=N'VW_AssuntoChaveCompleta', @level2type=N'COLUMN',@level2name=N'valor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Assunto pai' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'VIEW',@level1name=N'VW_AssuntoChaveCompleta', @level2type=N'COLUMN',@level2name=N'assuntoPaiId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indica se o assunto encontra-se ativo' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'VIEW',@level1name=N'VW_AssuntoChaveCompleta', @level2type=N'COLUMN',@level2name=N'ativo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Exibe as chaves de forma hierarquica.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'VIEW',@level1name=N'VW_AssuntoChaveCompleta', @level2type=N'COLUMN',@level2name=N'hierarquia'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Exibe o nível hierarquico do assunto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'VIEW',@level1name=N'VW_AssuntoChaveCompleta', @level2type=N'COLUMN',@level2name=N'nivel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'View para exibir dados hierarquicos da tabela Assunto.' , @level0type=N'SCHEMA',@level0name=N'ProgramaGestao', @level1type=N'VIEW',@level1name=N'VW_AssuntoChaveCompleta'
GO
*/