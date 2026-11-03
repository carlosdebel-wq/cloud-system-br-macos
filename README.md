# Cloud System BR para macOS

Cliente personalizado a partir do ownCloud Desktop 6.0.3, usando os fontes e logos do projeto SystemBR-Cloud-Desktop. Servidor sugerido e editavel: https://cloud.systembr.com.br/.

## Compilacao
Em Actions, execute Cloud System BR - macOS e escolha arm64, intel ou both. O workflow e manual e somente executa em repositorio publico, usando runners padrao gratuitos do GitHub. Os instaladores verificados sao publicados em Releases como versoes de teste, sem armazenamento de artifacts do Actions.

## Limites
O pacote usa assinatura ad-hoc, sem Developer ID ou notarizacao Apple. Login e sincronizacao precisam de teste em um Mac real. A integracao Finder e o provedor nativo de arquivos virtuais nao estao incluidos. A verificacao automatica confere identidade, icone, assinatura ad-hoc, integridade do DMG e execucao de --version.

As licencas GPL e os creditos originais foram preservados. Os fontes nao incluem chaves de assinatura nem dados do ERP. Consulte LEIA-ME.md e ORIGEM-DOS-ARQUIVOS.md.
