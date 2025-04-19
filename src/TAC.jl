module TAC
    import Logging

    const log_cond = Ref{Any}()

    function f()
        Threads.@spawn for n in 1:10
            sleep(1)
            ccall(:uv_async_send, Cint, (Ptr{Cvoid},), log_cond[])
        end
    end

    function g()
        for n in 1:10
            sleep(1)
            ccall(:uv_async_send, Cint, (Ptr{Cvoid},), log_cond[])
        end
    end

    export f
    export g

    function __init__()
        println(Logging.current_logger())
        @info "init"
        log_cond[] = Base.AsyncCondition() do cond 
            @debug "cond-debug"
            @info "cond-info"
            println("cond-print")
        end
        f()
    end
end # module TAC
