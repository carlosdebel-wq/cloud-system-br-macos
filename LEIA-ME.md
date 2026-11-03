# Cloud System BR — preparação para macOS

**Estado: fontes e receitas preparados. Não existe instalador macOS compilado nesta entrega.**
A preparação foi feita no Windows. Os scripts não foram executados em um Mac e podem precisar de ajustes durante a primeira compilação.

## Identidade preparada
- Base ownCloud Desktop 6.0.3, igual à personalização Windows, com GPL-2.0 e créditos preservados.
- Nome: Cloud System BR; ícone macOS .icns com a logo oficial, além dos recursos do assistente e bandeja já personalizados.
- Servidor sugerido: https://cloud.systembr.com.br/ — campo editável.
- Aplicativo empacotado: /Applications/Cloud System BR.app.
- Identificador do bundle: br.com.systembr.cloud.desktop.
- Arquiteturas previstas: Intel x86_64 e Apple Silicon arm64, compiladas separadamente em máquinas correspondentes. Não é um binário universal já disponível.
- Mínimo configurado no fonte: macOS 13.0; compatibilidade prática ainda precisa de teste.
- Atualizador automático original desativado para preservar a personalização.

## Requisitos para a próxima etapa
Um Mac ou um executor macOS, Xcode/Command Line Tools, Git, Python 3 com acesso HTTPS e PowerShell 7. O SDK de Qt e as bibliotecas são preparados pelo Craft usado pelo projeto original. Uma compilação pode baixar vários GB.

No PowerShell 7 do Mac, na pasta extraída:

```powershell
# Apple Silicon, em Mac Apple Silicon:
pwsh -File packaging/compilar-no-mac.ps1 -Architecture arm64
# OU Intel, em Mac Intel:
pwsh -File packaging/compilar-no-mac.ps1 -Architecture intel
```

O roteiro segue o fluxo Craft do próprio projeto. O final localiza o bundle e usa macdeployqt para reunir as bibliotecas; gera um candidato DMG em binaries/arquitetura. Não confundir esse roteiro com uma compilação já validada.

## Limites da primeira preparação
O modo previsto é sincronização local normal. A extensão Finder e a integração nativa de arquivos virtuais não estão habilitadas/homologadas nesta preparação. Os registros internos de configuração herdados não foram migrados; não executar junto do ownCloud original no primeiro teste.

O empacotamento faz apenas assinatura ad-hoc para teste local. Isso não comprova uma identidade perante a Apple e não substitui certificado Developer ID e notarização. Não foi usada a assinatura do ownCloud nem foi criada uma assinatura Apple System BR. A distribuição pública deve aguardar compilação e homologação no Mac e definição do processo de assinatura/notarização.

## Validação necessária no Mac
Compilar; conferir o bundle e o ícone no Finder/Dock; abrir o app; conferir a URL editável; fazer login; enviar e baixar arquivos; verificar acentos nos nomes, reinício e encerramento; testar instalação em outro Mac da arquitetura correspondente. Conferir todas as dependências e a aplicação após macdeployqt. Esses testes ainda não ocorreram.

## Verificações já realizadas no Windows
Sintaxe dos roteiros, plist, ICNS, referências de marca, sugestão do endereço, identidade de bundle, desativação do atualizador e preservação da licença. Nenhuma validação Windows substitui o teste macOS.

Fontes de referência: .github/workflows/main.yml e .craft.ini do cliente original. Referência pública: https://github.com/owncloud/client/tree/v6.0.3 .
