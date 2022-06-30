using IdentityServer4.Models;
using IdentityServer4.Validation;
using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;
using System;
using System.Text.RegularExpressions;
using Susep.SISRH.Domain.AggregatesModel.PessoaAggregate;

namespace Susep.SISRH.Application.Auth
{
    public class ClientTokenValidator : IExtensionGrantValidator
    {
        private readonly IPessoaRepository PessoaRepository;
        private readonly IHttpContextAccessor ContextAccessor;
        private readonly String ClientCertHeader;

        public ClientTokenValidator(
            IPessoaRepository pessoaRepository,
            IHttpContextAccessor contextAccessor
        )
        {
            this.PessoaRepository = pessoaRepository;
            this.ContextAccessor = contextAccessor;
            string clientCertHeader = Environment.GetEnvironmentVariable("CLIENT_CERT_HEADER");
            if (!string.IsNullOrEmpty(clientCertHeader))
            {
                this.ClientCertHeader = clientCertHeader;
            }
            else
            {
                this.ClientCertHeader = "X-Forwarded-Tls-Client-Cert-Info";
            }
        }

        public async Task ValidateAsync(ExtensionGrantValidationContext context)
        {
            // Ler credenciais do token
            string cn = System.Web.HttpUtility.UrlDecode(this.ContextAccessor.HttpContext.Request.Headers[this.ClientCertHeader], System.Text.Encoding.UTF8).Replace("\"", "");
            
            if (string.IsNullOrEmpty(cn))
            {
                context.Result = new GrantValidationResult(TokenRequestErrors.InvalidRequest, "Erro ao ler credenciais do usuário", null);
                Console.WriteLine(cn);
                return;
            }
            
            string pattern = @"(?<=:)[\d|\.|-]+(?=,)";
            Regex rgx = new Regex(pattern);
            Match id = rgx.Match(cn);
            
            Pessoa pessoa = null;
            string cpf = "";

            if (id.Success)
            {
                cpf = Regex.Replace(id.Value, @"[^\d]", "", RegexOptions.None, Regex.InfiniteMatchTimeout);
                Console.WriteLine("Usuario token: " + cpf);
                try
                {
                    pessoa = await this.PessoaRepository.ObterPorCriteriosAsync(null, cpf);
                }
                catch (System.Exception e)
                {
                    Console.WriteLine(e.Message);
                    throw e;
                }
            }

            if (pessoa != null)
            {
                context.Result = new GrantValidationResult(pessoa.PessoaId.ToString(), "password", null, "local", null);
            }
            else
            {
                Console.WriteLine("CPF " + cpf + " não cadastrado no sistema");
                context.Result = new GrantValidationResult(TokenRequestErrors.InvalidRequest, "Usuário não cadastrado para acesso ao SGD", null);
            }
        }

        public string GrantType
        {
            get {
                return "client_token";
            }
            
        }
    }
}