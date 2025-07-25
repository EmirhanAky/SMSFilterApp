import SwiftUI

struct ContentView: View {
    @State private var lastSMS: String = "Henüz mesaj yok"

    var body: some View {
        VStack(spacing: 20) {
            Text("📩 Son Gelen Kod")
                .font(.headline)

            Text(lastSMS)
                .font(.title2)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)

            Button("Yenile") {
                let defaults = UserDefaults(suiteName: "group.emirhanaky.SMSFilterApp2301")
                lastSMS = defaults?.string(forKey: "lastSMS") ?? "Bulunamadı"
            }
        }
        .padding()
    }
}
