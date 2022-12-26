import PackagePlugin
import Foundation

@main struct GenerateWebGPUPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let generateTool = try context.tool(named: "generate-webgpu")
        let outputDir = context.pluginWorkDirectory.appending("Generated")
        
        let dawnJson: Path
        if let dawnJsonEnv = ProcessInfo.processInfo.environment["DAWN_JSON"] {
            dawnJson = Path(dawnJsonEnv)
        } else {
            dawnJson = context.package.directory.appending("dawn.json")
        }
        
        let outputFiles = [
            outputDir.appending("Enums.swift"),
            outputDir.appending("OptionSets.swift"),
            outputDir.appending("Structs.swift"),
            outputDir.appending("Classes.swift"),
            outputDir.appending("Functions.swift"),
            outputDir.appending("FunctionTypes.swift"),
            outputDir.appending("Callbacks.swift"),
        ]
        
        return [
            .buildCommand(
                displayName: "Generating WebGPU",
                executable: generateTool.path,
                arguments: ["--dawn-json", dawnJson, "--output-dir", outputDir],
                inputFiles: [dawnJson],
                outputFiles: outputFiles)]
        
    }
}
