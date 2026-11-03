# Cloud System BR — macOS

Cliente personalizado a partir do ownCloud Desktop 6.0.3. Nome e logo Cloud System BR, com https://cloud.systembr.com.br/ sugerido e editável. Licença original GPL-2.0 e créditos preservados nos fontes.

## Estado
Workflow preparado para compilar no GitHub Actions. Ainda não há compilação macOS homologada neste repositório. Um DMG só existirá depois de uma execução bem-sucedida. O pacote usa assinatura ad-hoc para homologação, sem Developer ID ou notarização Apple; login e sincronização precisam de teste em um Mac real.

## Repositório privado e controle de uso
Não existe execução por push, pull request ou horário. Publicar os arquivos não inicia uma compilação.

O workflow só permite trabalho quando a opção `free_quota_confirmed` for marcada. Ela é uma confirmação do operador, NÃO uma verificação automática de saldo nem um limite financeiro. Antes de usá-la, confira a franquia disponível e o bloqueio de gastos nos ajustes de cobrança do GitHub. Não execute se não puder garantir que o uso ficará na franquia gratuita. Nada neste código altera a cobrança ou os limites globais da conta.

Na preparação inicial, nenhuma execução foi iniciada. A retenção do arquivo gerado é de um dia, e há no máximo uma arquitetura compilando por vez. Esses limites reduzem consumo, mas não garantem custo zero por si só.

## Executar quando a franquia estiver conferida
1. Abra **Actions → Cloud System BR - macOS → Run workflow**.
2. Escolha `arm64` (Apple Silicon) ou `intel`; use `both` apenas se precisar e tiver franquia para as duas compilações.
3. Marque a confirmação de franquia somente depois de conferir o GitHub.
4. Ao finalizar, baixe o arquivo em **Artifacts** da execução. Ele contém DMG, SHA-256 e o relatório de verificação.

Não são criadas publicações públicas nem releases automaticamente. Os únicos Actions utilizados são oficiais do GitHub, fixados por commit. Os fontes não incluem chaves de assinatura, credenciais, bancos ou arquivos do ERP.

## Verificações
O preflight confere marca, ícone, configuração e política manual do workflow. No macOS, o empacotamento verifica assinatura ad-hoc e integridade do DMG; o teste de `--version` confere o carregamento do executável. Isso não equivale a teste completo de login e sincronização.

Mais detalhes de compilação local e limitações em [LEIA-ME.md](LEIA-ME.md).
