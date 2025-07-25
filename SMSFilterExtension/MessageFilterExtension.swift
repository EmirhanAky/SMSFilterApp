import IdentityLookup
import os

let logger = Logger(subsystem: "emirhanaky.SMSFilterApp2301", category: "SMSFilter")

final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling {
    func handle(_ queryRequest: ILMessageFilterQueryRequest,
                context: ILMessageFilterExtensionContext,
                completion: @escaping (ILMessageFilterQueryResponse) -> Void) {

        let response = ILMessageFilterQueryResponse()

        if let messageBody = queryRequest.messageBody {
            logger.info("📩 Gelen SMS: \(messageBody)")

            // OTP ayıklama
            if let otp = extractOTP(from: messageBody) {
                logger.info("🔐 OTP bulundu: \(otp)")
                saveToSharedDefaults(otp)
            } else {
                logger.warning("❗ OTP bulunamadı, tüm mesaj gönderiliyor")
                saveToSharedDefaults(messageBody)
            }
        }

        response.action = .none
        completion(response)
    }

    private func extractOTP(from text: String) -> String? {
        let pattern = "\\b\\d{6}\\b"
        if let range = text.range(of: pattern, options: .regularExpression) {
            return String(text[range])
        }
        return nil
    }

    private func saveToSharedDefaults(_ text: String) {
        if let defaults = UserDefaults(suiteName: "group.emirhanaky.SMSFilterApp2301") {
            defaults.setValue(text, forKey: "lastSMS")
            defaults.synchronize()
            Logger().info("SharedDefaults’a yazıldı: \(text)")
        } else {
            Logger().error("SharedDefaults erişilemedi!")
        }
    }
}
