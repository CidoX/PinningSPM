//
//  URLSession+PinningWorker.swift
//  Pinning
//
//  Created by CidoX on 26/08/25.
//

import Foundation

// Extensão para facilitar o uso com URLSession
//extension PinningWorker: URLSessionDelegate {
extension PinningWorker {
    
    // Método que o URLSession chama para verificar segurança
    public func urlSession(_ session: URLSession,
                         didReceive challenge: URLAuthenticationChallenge,
                         completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        // Verifica se é um desafio de confiança de servidor
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            // Se não for, usa o comportamento padrão
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        // Verifica se a chave do servidor é confiável
        if validateServerTrust(serverTrust) {
            // Se for confiável, permite a conexão
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            // Se não for confiável, bloqueia a conexão
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    // Mostra alerta de segurança (opcional)
    private func showSecurityAlert() {
        #if os(iOS)
        // Em uma app real, você mostraria um alerta para o usuário
        print("⚠️ AVISO: Possível ataque de segurança detectado!")
        #endif
    }
}
