generate_dynamic_mut_category <- function(dataset, input_id) {
  observeEvent(dataset, {
    choices <- sort(unique(dataset$mut_category))
    updateSelectizeInput(inputId = input_id, choices = choices) 
  })
}