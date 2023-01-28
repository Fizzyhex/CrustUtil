"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[84],{9730:e=>{e.exports=JSON.parse('{"functions":[{"name":"RequireModuleScripts","desc":"Requires all module scripts inside of the table. Any instances that are not ModuleScripts will be ignored.\\n\\n\\n```lua\\nlocal Baseline = require(somewhere.Baseline)\\n\\nlocal components = Baseline.RequireModuleScripts(\\n\\tReplicatedStorage.Components,\\n\\t\\"Loading component %s\\"\\n)\\n```","params":[{"name":"modules","desc":"Dictionary/table of modules","lua_type":"{ModuleScript}"},{"name":"requireMessageOrLogger","desc":"Optional message to print before calling the method","lua_type":"(ModuleScript) -> () | string? | {[\\"__call\\"]: (ModuleScript) -> ()}"}],"returns":[{"desc":"Returns a dictionary of ModuleScripts and their returned values","lua_type":"table"}],"function_type":"static","source":{"line":87,"path":"src/Baseline/init.lua"}},{"name":"CallAll","desc":"Calls a specific method on all of the modules.","params":[{"name":"modules","desc":"Dictionary/table of modules","lua_type":"{any: any}"},{"name":"method","desc":"Method to call","lua_type":"string"},{"name":"callMessage","desc":"Optional message to print before calling the method","lua_type":"string?"}],"returns":[],"function_type":"static","source":{"line":122,"path":"src/Baseline/init.lua"}},{"name":"SpawnAll","desc":"Similar to `CallAll`, but the method calls will be wrapped in `task.spawn`.","params":[{"name":"modules","desc":"Dictionary/table of modules","lua_type":"{any: any}"},{"name":"method","desc":"Method to call","lua_type":"string"}],"returns":[],"function_type":"static","source":{"line":150,"path":"src/Baseline/init.lua"}}],"properties":[],"types":[],"name":"Baseline","desc":"A powerfully simple module loading library.\\n\\n```lua\\n--- Require baseline!\\nlocal Baseline = require(somewhere.Baseline)\\n\\nlocal function ControllerFilter(moduleScript: ModuleScript)\\n\\treturn moduleScript.Name:match(\\"Controller$\\") ~= nil\\nend\\n\\n-- Find all ModuleScripts inside of the \'Modules\' folder.\\n-- Then, we\'ll filter through them to only get ModuleScripts that have names\\n-- ending with \'Controller\'.\\nlocal controllers = Baseline.FilterForModuleScripts(\\n\\tReplicatedStorage.Modules:GetDescendants(),\\n\\tControllerFilter\\n)\\n\\n-- Require the controllers.\\ncontrollers = Baseline.RequireModuleScripts(\\n\\tcontrollers,\\n\\t\\"Requiring controller %s\\"\\n)\\n\\n-- For every controller module, we\'ll call module:OnInit() if it\'s present.\\nBaseline.CallAll(controllers, \\"OnInit\\", \\"Calling {moduleName}.{method}\\")\\n-- Similar to CallAll, but this time we\'ll wrap the call in a spawn so that it\\n-- doesn\'t yield.\\nBaseline.SpawnAll(controllers, \\"OnStart\\")\\n\\nprint(\\"All controllers initalized/started!\\", controllers)\\n```","source":{"line":41,"path":"src/Baseline/init.lua"}}')}}]);