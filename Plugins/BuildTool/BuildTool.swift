//
//  BuildTool.swift
//  
//
//  Created by John Scott on 24/12/2022.
//

import PackagePlugin
import UniformTypeIdentifiers

@main
struct BuildTool: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        fatalError()
//        return [
//            .prebuildCommand(displayName: "Transpile JavaScript",
//                             executable: try context.tool(named: "JavaScriptTranspiler").path,
//                             arguments: [context.pluginWorkDirectory],
//                             outputFilesDirectory: context.pluginWorkDirectory)
//        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension BuildTool: XcodeBuildToolPlugin {
//    static func main() throws {
//        Diagnostics.error("Fuck")
//        exit(-1)
//    }
    
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        var commands = [Command]()
        
        for inputFile in target.inputFiles {
            guard inputFile.type == .source && inputFile.path.extension == "xcdatamodeld" else {
                continue
            }
            
            let momFile = context.pluginWorkDirectory.appending(subpath: inputFile.path.stem.appending(".momd"))
            
            let process = try Process.run(URL(fileURLWithPath: try context.tool(named: "momc").path.string), arguments: ["--no-warnings", inputFile.path.string, momFile.string])
            process.waitUntilExit()
                    
            guard process.terminationReason == .exit && process.terminationStatus == 0 else {
                fatalError()
            }
            
            Diagnostics.warning(context.pluginWorkDirectory.string)
            
            let swiftFile = context.pluginWorkDirectory.appending(subpath: inputFile.path.stem.appending(".swift"))
            
            commands.append(.buildCommand(displayName: "Generate model objects",
                                          executable: try context.tool(named: "Generator").path,
                                          arguments: ["--input", momFile.string, "--output", swiftFile.string],
                                         inputFiles: [momFile],
                                         outputFiles: [swiftFile]))
        }
        
        return commands
    }
}
#endif
