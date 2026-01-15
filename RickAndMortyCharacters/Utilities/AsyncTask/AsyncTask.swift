protocol AsyncTasking {
    func execute(_ code: @escaping () async -> Void)
}

final class AsyncTask {}

extension AsyncTask: AsyncTasking {
    func execute(_ code: @escaping () async -> Void) {
        Task {
            await code()
        }
    }
}
