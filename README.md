Esse é o Sistema da Superintendência de Seguros Privados (Susep) para a gestão do Programa de Gestão de Desempenho (PGD) em conformidade com a IN65/2020.
<br><br>
Para a correta instalação, consulte o manual de instalação e utilize os arquivos disponibilizados na pasta install/<br><br>
Para acesso ao código fonte, utilize os arquivos disponibilizados na pasta src/<br><br>
Para entender os conceitos e principais funcionalidades, assista à apresentação disponível no seguinte link: https://youtu.be/VU_1TTAMg2Y

## Testando
```
docker run -it --rm -v $(pwd)/src/:/src mcr.microsoft.com/dotnet/sdk:3.1 /bin/bash
cd /src
apt-get update
apt-get install -y nodejs npm --no-install-recommends
npm i npm@latest -g
dotnet build --configuration Release

# Limpar
sudo rm -r src/Susep.*/bin
sudo rm -r src/Susep.*/obj

# Build da imagem
docker build -f docker/Dockerfile -t pgd .
# Subir container
docker-compose -f docker/docker-compose.yml up
```

* http://localhost:8081/gateway/dominio/ModalidadeExecucao
* http://localhost:8082/api/v1/dominio/ModalidadeExecucao