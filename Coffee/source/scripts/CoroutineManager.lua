import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"

function UpdateCoroutine(coroutineVar)
        if coroutineVar then
            coroutine.resume(coroutineVar)
        end
end