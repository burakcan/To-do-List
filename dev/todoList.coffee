class TodoList
  constructor : (options = {}) ->
    options.name          or= "defaultList"
    options.initialData   or= {}
    options.storage       or= new StorageHelper name : options.name
    options.parent        or= document.body
    @options                = options
    @storage                = options.storage
    @items                  = []

    @_init()

  _init : ->
    @HTMLElement            = document.createElement 'div'
    @HTMLElement.classList.add 'todo-list'

    allItems                = @storage.getAll()
    @storage.removeAll()

    @addItem data for id, data of allItems

    @_createForm()

    @invoke 'ready'

  _createForm : ->
    @addNewForm                                 = document.createElement 'form'
    @addNewForm.appendChild @addNewTitle        = document.createElement 'input'
    @addNewForm.appendChild @addNewDescription  = document.createElement 'textarea'
    @addNewForm.appendChild @addNewSubmit       = document.createElement 'button'
    @addNewTitle.type                           = "text"
    @addNewTitle.placeholder                    = "Title"
    @addNewDescription.placeholder              = "Description..."
    @addNewSubmit.type                          = "submit"
    @addNewSubmit.innerHTML                     = "Add item"

    @HTMLElement.appendChild @addNewForm

    @addNewForm.onsubmit = (event) =>
      event.preventDefault()

      title       = @addNewTitle.value
      description = @addNewDescription.value

      @addItem
        title       : title
        description : description

      @addNewTitle.value       = ""
      @addNewDescription.value = ""

  addItem : (itemOptions) -> @items.push new TodoItem itemOptions , @

  getAll : -> @items

  itemCreated : (item) ->
    if @addNewForm
    then @HTMLElement.insertBefore item.HTMLElement, @addNewForm
    else @HTMLElement.appendChild item.HTMLElement

  itemRemoved : (item) ->
    index = @items.indexOf item
    @items.splice index, 1
    @HTMLElement.removeChild item.HTMLElement

  invoke : (message, item) -> @[message]? item

  appendTo : (parent) -> parent.appendChild @HTMLElement

  ready : -> @appendTo @options.parent
