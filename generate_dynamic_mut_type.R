generate_dynamic_mut_type <- function(dataset, input_id) {
  observeEvent(dataset, {
    choices <- sort(unique(dataset$mut_type))
    updateSelectizeInput(inputId = input_id, choices = choices) 
  })
}