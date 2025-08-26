//
//  PublicKeyConfig.swift
//  Pinning
//
//  Created by CidoX on 26/08/25.
//

import Foundation

// Configuração das chaves públicas que seu app confia
public struct PublicKeyConfig {
    // Lista de hashes das ch públicas que são confiáveis
    public let trustedKeyHashes: [String]
    
    // Se deve bloquear conexões não confiáveis
    public let enforcePinning: Bool
    
    // Se aplica a subdomínios também
    public let includeSubdomains: Bool
    
    public init(trustedKeyHashes: [String],
                enforcePinning: Bool = true,
                includeSubdomains: Bool = true) {
        self.trustedKeyHashes = trustedKeyHashes
        self.enforcePinning = enforcePinning
        self.includeSubdomains = includeSubdomains
    }
}
