(require-macros :macros)

; the following code looks sensible but doesn't actually
; go forward enough times if you click fast enough
; 
; while true do
;   os.pullEvent("mouse_click")
;   turtle.forward()
; end
; 
; that is because methods that yield also "eat" events.
; using this library you can instead do the same thing and have it work like so:
; 
; historian = require("historian")
; historian(function(pullEvent) begin
;   while true do
;     pullEvent("mouse_click")
;     turtle.forward()
;   end
; end)

(fn historian [callback]
  (local event-queue [])
  (var queue-size 0)
  (fn listen-loop []
    (while true
      (table.insert event-queue [(os.pullEvent)])
      (inc queue-size)
    )
  )
  (fn pullEvent [?name]
    (var event nil)
    (while (= nil event)
      (while (= 0 queue-size) (os.pullEvent))
      (set event (table.remove event-queue 1))
      (dec queue-size)
      (local matches-event? (case (type ?name)
        :nil true
        :string (= ?name (. event 1))
        :table (table.iany? #(= $1 (. event 1)) ?name)
        type (error (.. "Filters of type " type " are not supported") 2)
      ))
      (if (not matches-event?)
        (set event nil)
      )
    )
    (table.unpack event)
  )
  ; the order here is crucial
  (parallel.waitForAny listen-loop #(callback pullEvent))
)

historian
