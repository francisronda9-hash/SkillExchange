import Foundation
import FirebaseFirestore

@MainActor
struct ProfileService {
    private func document(_ uid: String) -> DocumentReference {
        Firestore.firestore().collection("users").document(uid)
    }

    func load(uid: String) async throws -> LocalProfile? {
        let snapshot = try await document(uid).getDocument(source: .server)
        guard let data = snapshot.data() else { return nil }
        return try JSONDecoder().decode(LocalProfile.self, from: JSONSerialization.data(withJSONObject: data))
    }

    func save(_ profile: LocalProfile, uid: String, expected: LocalProfile? = nil) async throws {
        let encoded = try JSONEncoder().encode(profile)
        guard let data = try JSONSerialization.jsonObject(with: encoded) as? [String: Any] else {
            throw ProfileError.message("Unable to prepare your profile.")
        }
        let reference = document(uid)
        let expectedData: [String: Any]?
        if let expected {
            expectedData = try JSONSerialization.jsonObject(with: JSONEncoder().encode(expected)) as? [String: Any]
        } else { expectedData = nil }
        _ = try await Firestore.firestore().runTransaction { transaction, errorPointer in
            do {
                let snapshot = try transaction.getDocument(reference)
                let matches: Bool
                if let expectedData, let existing = snapshot.data() {
                    matches = NSDictionary(dictionary: expectedData).isEqual(to: existing)
                } else { matches = expectedData == nil && !snapshot.exists }
                guard matches else {
                    errorPointer?.pointee = NSError(domain: "SkillExchange.Profile", code: 409,
                        userInfo: [NSLocalizedDescriptionKey: "Your profile changed on another device. Sign out and back in to load the latest version before editing."])
                    return nil
                }
                transaction.setData(data, forDocument: reference)
                return nil
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
        }
    }
}
