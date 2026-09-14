import SwiftUI
import Combine

@MainActor
final class UserController: ObservableObject {
    @Published private(set) var localProfile = LocalProfile()
    @Published private(set) var isReady = false
    @Published private(set) var isSaving = false
    @Published var loadError: String?
    private let uid: String?
    private let service = ProfileService()

    init(uid: String? = nil) { self.uid = uid }

    func load() async {
        guard let uid, !isReady else { return }
        loadError = nil
        do {
            let savedProfile = try await service.load(uid: uid)
            if let saved = savedProfile {
                localProfile = saved
            } else {
                let profile = LocalProfile()
                try await service.save(profile, uid: uid)
                localProfile = profile
            }
            isReady = true
        } catch { loadError = error.localizedDescription }
    }

    var currentUser: User { User(
        name: localProfile.name,
        initials: localProfile.name.split(separator: " ").prefix(2).compactMap { $0.first.map(String.init) }.joined(),
        wantsToLearn: localProfile.learning.map(\.name).joined(separator: ", "),
        canTeach: localProfile.teaching.map(\.name).joined(separator: ", "),
        rating: 4.8,
        isOnline: localProfile.openToExchanges,
        about: localProfile.about
    ) }

    var firstName: String {
        localProfile.name.split(separator: " ").first.map(String.init) ?? "there"
    }

    func saveSkill(id: UUID? = nil, name: String, icon: String, level: String, in list: SkillList) async throws {
        let cleanName = name.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }.joined(separator: " ")
        guard (2...50).contains(cleanName.count) else {
            throw ProfileError.message("Use a skill name between 2 and 50 characters.")
        }
        var skills = localProfile.skills(in: list)
        guard !skills.contains(where: {
            $0.id != id && $0.name.compare(cleanName, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        }) else {
            throw ProfileError.message("That skill is already in this list.")
        }
        guard list.levels.contains(level) else {
            throw ProfileError.message("Choose a valid skill level.")
        }
        let updated = Skill(id: id ?? UUID(), name: cleanName, icon: icon, level: level)
        if let id {
            guard let index = skills.firstIndex(where: { $0.id == id }) else {
                throw ProfileError.message("This skill was removed. Close the editor and try again.")
            }
            skills[index] = updated
        } else {
            guard skills.count < 50 else { throw ProfileError.message("You can add up to 50 skills per list.") }
            skills.append(updated)
        }
        var next = localProfile
        if list == .teaching { next.teaching = skills } else { next.learning = skills }
        try await commit(next)
    }

    func deleteSkill(_ id: UUID, from list: SkillList) async throws {
        var next = localProfile
        if list == .teaching { next.teaching.removeAll { $0.id == id } }
        else { next.learning.removeAll { $0.id == id } }
        try await commit(next)
    }

    func updateProfile(name: String, about: String) async throws {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard (2...60).contains(cleanName.count) else {
            throw ProfileError.message("Enter a name between 2 and 60 characters.")
        }
        guard about.count <= 500 else {
            throw ProfileError.message("Keep your introduction within 500 characters.")
        }
        var next = localProfile
        next.name = cleanName
        next.about = about.trimmingCharacters(in: .whitespacesAndNewlines)
        try await commit(next)
    }

    func setOpenToExchanges(_ value: Bool) async throws {
        var next = localProfile
        next.openToExchanges = value
        try await commit(next)
    }

    private func commit(_ profile: LocalProfile) async throws {
        guard let uid, isReady else { throw ProfileError.message("Load your profile before editing.") }
        guard !isSaving else { throw ProfileError.message("Please wait for the previous save.") }
        isSaving = true
        defer { isSaving = false }
        try await service.save(profile, uid: uid, expected: localProfile)
        localProfile = profile
    }

    let users = [
        User(name: "Tyrone S.", initials: "TS", wantsToLearn: "Python", canTeach: "Front End Dev", rating: 4.6, isOnline: false, about: "Front-end developer and student mentor."),
        User(name: "Franck N.", initials: "FN", wantsToLearn: "Designing", canTeach: "UI Design", rating: 4.7, isOnline: true, about: "Passionate about UI/UX design and web development."),
        User(name: "Lance S.", initials: "LS", wantsToLearn: "Research", canTeach: "Database", rating: 4.5, isOnline: true, about: "Database learner who enjoys academic research."),
        User(name: "Jay D.", initials: "JD", wantsToLearn: "Editing", canTeach: "React", rating: 4.4, isOnline: true, about: "Video editor and React developer."),
        User(name: "Carlo C.", initials: "CC", wantsToLearn: "Python", canTeach: "UI Design", rating: 4.3, isOnline: false, about: "Student designer focused on mobile interfaces.")
    ]

    func filteredUsers(searchText: String) -> [User] {
        guard !searchText.isEmpty else { return users }
        return users.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.canTeach.localizedCaseInsensitiveContains(searchText) ||
            $0.wantsToLearn.localizedCaseInsensitiveContains(searchText)
        }
    }
}
