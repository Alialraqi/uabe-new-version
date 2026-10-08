import SwiftUI
import UniformTypeIdentifiers

struct RawDumpActions: View {
    let item: ObjectItem
    @Binding var exportItem: ExportItem?
    var onImported: (() -> Void)? = nil
    @EnvironmentObject var vm: BundleViewModel

    var body: some View {
        Button {
            Task {
                if let url = await vm.exportData(item, method: "export_raw", ext: "dat") {
                    exportItem = ExportItem(url: url)
                }
            }
        } label: {
            Label("Export Raw (.dat)", systemImage: "doc.badge.arrow.up")
        }
        Button {
            Task {
                if let url = await vm.exportData(item, method: "export_dump", ext: "json") {
                    exportItem = ExportItem(url: url)
                }
            }
        } label: {
            Label("Export Dump (.json)", systemImage: "curlybraces")
        }
        Button {
            FilePicker.pick(types: [.item]) { url in
                guard let url else { return }
                Task {
                    await vm.importData(item, method: "import_raw", from: url)
                    onImported?()
                }
            }
        } label: {
            Label("Import Raw (.dat)…", systemImage: "doc.badge.arrow.down")
        }
        Button {
            FilePicker.pick(types: [.json, .plainText]) { url in
                guard let url else { return }
                Task {
                    await vm.importData(item, method: "import_dump", from: url)
                    onImported?()
                }
            }
        } label: {
            Label("Import Dump (.json)…", systemImage: "square.and.arrow.down")
        }
    }
}
