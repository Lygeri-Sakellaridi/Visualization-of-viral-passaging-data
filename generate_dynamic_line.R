generate_dynamic_line <- function(dataset, input_id) {
  observeEvent(dataset, {
  choices <- sort(unique(dataset$line))
  updateSelectizeInput(inputId = input_id, choices = choices) 
})
}

