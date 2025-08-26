//
//  PinningWorker.swift
//  Pinning
//
//  Created by CidoX on 26/08/25.
//
import Foundation

// Classe principal que gerencia todo o pinning
public class PinningWorker: NSObject {
    
    private let verifier: PublicKeyVerifier
    
    // Inicializa com as chaves confiáveis
    public init(trustedKeyHashes: [String]) {
        let config = PublicKeyConfig(trustedKeyHashes: trustedKeyHashes)
        self.verifier = PublicKeyVerifier(config: config)
        super.init()
        
        print("🎯 Pinning configurado com \(trustedKeyHashes.count) chaves confiáveis")
    }
    
    // Método que verifica se a conexão é segura
    public func validateServerTrust(_ serverTrust: SecTrust) -> Bool {
        let isValid = verifier.verifyServerTrust(serverTrust)
        
        if isValid {
            print("✅ Conexão segura! Chave verificada com sucesso.")
        } else {
            print("❌ ALERTA: Conexão insegura! Chave não confiável.")
        }
        
        return isValid
    }
}
