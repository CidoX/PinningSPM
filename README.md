# 🔐 PublicKeyPinning
Um pacote Swift simples e eficaz para implementar Public Key Pinning em suas aplicações iOS, macOS, watchOS e tvOS. Proteja seu app contra ataques MITM (Man-in-the-Middle) de forma fácil e confiável.

# 📋 Pré-requisitos
iOS 13.0+ / macOS 10.15+ / watchOS 6.0+ / tvOS 13.0+

Xcode 12.0+

Swift 5.7+

# 📦 Instalação
Swift Package Manager
No Xcode, vá em File > Add Packages...

Cole a URL do repositório: https://github.com/CidoX/PinningSPM.git

Selecione a versão desejada

Adicione ao seu target

# Ou adicione manualmente ao Package.swift:
    dependencies: [
        .package(url: "https://github.com/CidoX/PinningSPM.git", from: "1.0.0")
    ]

# 🚀 Como Usar
# 1. Importe o pacote

import PublicKeyPinning

# 2. Opção A - Configure o Pinning no seu App
    class NetworkManager {
        
        // Configure com seus hashes reais
        private let pinningWorker = PinningWorker(
            trustedKeyHashes: [
                "h6M8d5N8Z3L7v2x1c9X0p5Q2w3E4r5T6y", // Hash principal
                "k9P2s5R8t1W0q3z6u7V4b5N6m7C8v9B0n"  // Hash de backup
            ]
        )
        
        private lazy var secureSession: URLSession = {
            URLSession(
                configuration: .default,
                delegate: pinningManager,
                delegateQueue: nil
            )
        }()
        
        func makeSecureRequest() {
            let url = URL(string: "https://api.seudominio.com/data")!
            let task = secureSession.dataTask(with: url) { data, response, error in
                // Sua lógica de tratamento de resposta
            }
            task.resume()
        }
    }

# 3. Opção B - Configuração com Configurações Customizadas:
    let config = PublicKeyConfig(
        trustedKeyHashes: [
            "h6M8d5N8Z3L7v2x1c9X0p5Q2w3E4r5T6y",
            "k9P2s5R8t1W0q3z6u7V4b5N6m7C8v9B0n"
        ],
        enforcePinning: true,     // Bloqueia conexões não confiáveis
        includeSubdomains: true   // Aplica a todos os subdomínios
    )
    
    let pinningWorker = PinningWorker(config: config)

# 5. Use com URLSession

    // Crie a session com o delegate de pinning
    let session = URLSession(
        configuration: .default,
        delegate: pinningManager,
        delegateQueue: nil
    )
    
    // Faça requisições normalmente
    session.dataTask(with: url) { data, response, error in
        if let error = error as? PinningError {
            print("Erro de pinning: \(error.description)")
        }
        // Trate a resposta
    }.resume()
