//
//  PinningError.swift
//  Pinning
//
//  Created by CidoX on 26/08/25.
//

import Foundation

// Erros que podem acontecer durante o pinning
public enum PinningError: Error {
    case publicKeyNotFound
    case invalidServerTrust
    case hashMismatch
    case keyExtractionFailed
    
    // Descrição em português para facilitar
    public var description: String {
        switch self {
        case .publicKeyNotFound:
            return "Chave pública não encontrada no servidor"
        case .invalidServerTrust:
            return "Configuração de segurança inválida"
        case .hashMismatch:
            return "A chave do servidor não confere com as chaves salvas"
        case .keyExtractionFailed:
            return "Não foi possível extrair a chave do certificado"
        }
    }
}
