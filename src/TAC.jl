module TAC
    const log_cond = Ref{Any}()

    function f()
      	Threads.@spawn for n in 1:10
    		sleep(1)
    		ccall(:uv_async_send, Cint, (Ptr{Cvoid},), log_cond[])
  	    end
	end

    export f

	function __init__()
        @info "init"
        log_cond[] = Base.AsyncCondition() do cond 
	      @debug "cond"
	      println("la")

        f()
    end
end # module TAC
