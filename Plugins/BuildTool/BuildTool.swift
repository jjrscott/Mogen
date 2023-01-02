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
//        Diagnostics.error(try context.tool(named: "cp").path.string)
        
        var arguments = [CustomStringConvertible]()
                
        var commands = [Command]()
        
        for inputFile in target.inputFiles {
            guard inputFile.type == .source && inputFile.path.extension == "xcdatamodeld" else {
                continue
            }
            
            let outputFile = context.pluginWorkDirectory.appending(subpath: inputFile.path.stem.appending(".swift"))
//            let outputFile2 = context.pluginWorkDirectory.appending(subpath: inputFile.path.lastComponent)

//            Diagnostics.warning(inputFile.path.string)
//            Diagnostics.warning(outputFile.string)
//            Diagnostics.warning(outputFile2.string)

            
            arguments.append("--input")
            arguments.append(inputFile.path.string)
            arguments.append("--output")
            arguments.append(outputFile.string)
            arguments.append("--temp")
            arguments.append(context.pluginWorkDirectory.string)
            arguments.append("--momc")
            arguments.append(try context.tool(named: "momc").path.string)
            
//            Diagnostics.warning(try context.tool(named: "cp").path.string + " " + ["-pr", inputFile.path.string, outputFile2.string].joined(separator: " "))
            commands.append(.buildCommand(displayName: "Generate model objects",
                                          executable: try context.tool(named: "Generator").path,
                                          arguments: arguments,
                                         inputFiles: [inputFile.path],
                                         outputFiles: [outputFile]))

        }
        
        return commands
    }
}
#endif
