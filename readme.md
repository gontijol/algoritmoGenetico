**Projeto: Algoritmo Genético**
  
  Neste trabalho, iremos explorar a arquitetura e implementação de um sistema, que consiste em uma API Rest hospedada em um servidor EC2 na AWS. O sistema utiliza o Firebase para autenticação e comunicação entre diferentes front-ends (Web e Mobile). As tarefas são armazenadas no Firestore, um banco de dados NoSQL fornecido pelo Firebase. O front-end mobile é desenvolvido com Flutter e GetX, enquanto o front-end web é desenvolvido com Vue.js.
  
  Arquitetura Escolhida
  A arquitetura escolhida para este projeto é baseada em uma abordagem de desenvolvimento Full Stack, onde as diferentes partes do sistema são divididas em componentes independentes que se comunicam por meio de APIs e serviços em nuvem. A seguir, descrevemos os principais componentes do sistema e como eles interagem:
  
  
  API Rest hospedada em servidor EC2 na AWS:
  
  A API Rest é a camada principal que gerencia a lógica de negócios e a comunicação com os clientes (front-ends).
  Ela é hospedada em um servidor EC2 na AWS para garantir escalabilidade e disponibilidade.
  A API é responsável por autenticar os usuários por meio do Firebase Authentication, gerenciar as tarefas e se comunicar com o Firestore.
  
  Firebase Authentication e Token Handling:
  
  O sistema utiliza o Firebase Authentication para autenticar os usuários.
  Um sistema de token handling é implementado na API para gerenciar as sessões dos usuários autenticados.
  Isso permite que diferentes front-ends se autentiquem e se comuniquem com a API de maneira segura.
  
   Firestore (Banco de Dados):
  
  O Firestore é utilizado para armazenar e gerenciar os dados das tarefas.
  As tarefas são organizadas em coleções e documentos, permitindo uma estrutura flexível para armazenar informações relacionadas às tarefas.
  
  Front-end Mobile (Flutter com GetX):
  
  O front-end mobile é desenvolvido usando o framework Flutter, que permite criar interfaces nativas para iOS e Android a partir de um único código-base.
  O pacote GetX é utilizado para gerenciar o estado da aplicação, navegação e injeção de dependência.
  A autenticação é realizada por meio do Firebase Authentication, e os dados das tarefas são obtidos da API por meio de chamadas HTTP.
  
  Front-end Web (Vue.js):
  
  O front-end web é desenvolvido usando o framework Vue.js, que permite construir interfaces interativas e responsivas.
  
  O sistema de autenticação é semelhante ao do front-end mobile, usando Firebase Authentication.
  
  As chamadas à API são feitas por meio de requisições HTTP, permitindo a exibição e manipulação das tarefas.
  
  Implementação e Fluxo de Funcionamento
  O usuário acessa o front-end mobile ou web e inicia o processo de autenticação.
  A autenticação é realizada por meio do Firebase Authentication, gerando um token de autenticação válido.
  O token é enviado nas chamadas da API para autenticação e autorização.
  A API verifica o token e, se válido, permite o acesso às funcionalidades do sistema.
  Os dados das tarefas são armazenados e obtidos do Firestore por meio da API.
  No front-end, as tarefas são exibidas e o usuário pode realizar operações como adicionar, editar e excluir tarefas.
  Qualquer modificação nas tarefas é refletida no Firestore por meio da API.
  
  
  
  Conclusão
  
  Este projeto demonstra uma arquitetura Full Stack completa, que engloba desde a criação da API Rest até o desenvolvimento de front-ends mobile e web. A integração com serviços em nuvem, como o Firebase e o Firestore, proporciona uma base sólida para autenticação segura e armazenamento de dados. A combinação de Flutter com GetX e Vue.js oferece interfaces eficientes e interativas para os usuários. A escolha de hospedar a API em um servidor EC2 na AWS garante escalabilidade e disponibilidade do sistema. Em resumo, o projeto apresenta uma solução completa para o gerenciamento de tarefas, demonstrando uma abordagem moderna de desenvolvimento Full Stack.
  
