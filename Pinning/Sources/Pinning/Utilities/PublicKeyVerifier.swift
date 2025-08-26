//
//  PublicKeyVerifier.swift
//  Pinning
//
//  Created by CidoX on 26/08/25.
//

import Foundation
import Security
import Crypto

// Classe que verifica se a chave do servidor é confiável
public class PublicKeyVerifier {
    
    private let config: PublicKeyConfig
    
    public init(config: PublicKeyConfig) {
        self.config = config
        print("✅ Verificador de chaves públicas inicializado")
    }
    
    // Método principal que verifica a chave do servidor
    public func verifyServerTrust(_ serverTrust: SecTrust) -> Bool {
        do {
            // 1. Extrai a chave pública do servidor
            let serverPublicKey = try extractPublicKey(from: serverTrust)
            
            // 2. Pega os dados da chave
            let publicKeyData = try getPublicKeyData(serverPublicKey)
            
            // 3. Calcula o hash (identificador único) da chave
            let publicKeyHash = calculateSHA256Hash(publicKeyData)
            let publicKeyHashBase64 = publicKeyHash.base64EncodedString()
            
            print("🔑 Hash da chave do servidor: \(publicKeyHashBase64)")
            
            // 4. Verifica se o hash está na lista de confiança
            return config.trustedKeyHashes.contains(publicKeyHashBase64)
            
        } catch {
            print("❌ Erro na verificação: \(error)")
            return false
        }
    }
    
    // Extrai a chave pública do certificado do servidor
    private func extractPublicKey(from serverTrust: SecTrust) throws -> SecKey {
        var error: CFError?
        
        // Configura a política de SSL
        let policy = SecPolicyCreateSSL(true, nil)
        SecTrustSetPolicies(serverTrust, policy)
        
        // Avalia se o certificado é válido
        guard SecTrustEvaluateWithError(serverTrust, &error) else {
            throw PinningError.invalidServerTrust
        }
        
        // Pega a chave pública (forma moderna)
        if #available(iOS 14.0, *) {
            guard let publicKey = SecTrustCopyKey(serverTrust) else {
                throw PinningError.publicKeyNotFound
            }
            return publicKey
        }
        // Forma para versões mais antigas
        else {
            guard let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
                throw PinningError.publicKeyNotFound
            }
            guard let publicKey = SecCertificateCopyKey(certificate) else {
                throw PinningError.keyExtractionFailed
            }
            return publicKey
        }
    }
    
    // Converte a chave pública para dados binários
    private func getPublicKeyData(_ publicKey: SecKey) throws -> Data {
        var error: Unmanaged<CFError>?
        
        guard let keyData = SecKeyCopyExternalRepresentation(publicKey, &error) else {
            throw PinningError.keyExtractionFailed
        }
        
        return keyData as Data
    }
    
    // Calcula o hash SHA256 usando Swift Crypto
    private func calculateSHA256Hash(_ data: Data) -> Data {
        // Método moderno com Swift Crypto
        var hasher = Crypto.SHA256()
        hasher.update(data: data)
        let hash = hasher.finalize()
        return Data(hash)
    }
}
