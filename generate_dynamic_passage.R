generate_dynamic_passage <- function(dataset, input_id) {
  observeEvent(dataset, {
    choices <- sort(unique(dataset$passage))
    updateSelectizeInput(inputId = input_id, choices = choices) 
  })
}