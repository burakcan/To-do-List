class TodoItem
  constructor : (options = {}, parent) ->
    options.title         or= "My todo title"
    options.description   or= "Write a description here"
    options.status         ?= no
    @options                = options
    @parent                 = parent
    @uniqueId               = @getUniqueId()

    @createItem()

  getUniqueId : ->
    allItems = @parent.getAll()
    otherIds = []

    otherIds.push key for key of allItems
    possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    id = ""

    for i in [0...10]
      id += possible.charAt Math.floor(Math.random() * possible.length)

    return id

  createItem : ->
    {title, description} = @options

    @parent.storage.set @uniqueId, @options

    @HTMLElement           = document.createElement 'div'
    @HTMLElement.classList.add 'todo-item'
    @HTMLElement.innerHTML = "<h3>#{title}</h3><p>#{description}</p>"
    @HTMLElement.classList.add "checked" if @options.status

    @HTMLElement.appendChild @removeButton = document.createElement 'button'
    @HTMLElement.appendChild @checkButton  = document.createElement 'button'

    @removeButton.innerHTML = "x"
    @checkButton.innerHTML  = "&#10004;"

    @removeButton.classList.add 'remove-button'
    @checkButton.classList.add 'check-button'

    @bindEvents()
    @parent.invoke "itemCreated", this

  remove : ->
    @parent.storage.remove @uniqueId
    @parent.invoke "itemRemoved", this

    return @HTMLElement

  toggleStatus : ->
    console.log @
    @options.status = !@options.status

    if @options.status is true
    then @HTMLElement.classList.add "checked"
    else @HTMLElement.classList.remove "checked"

    @parent.storage.set @uniqueId, @options

  bindEvents : ->
    @removeButton.onclick = => @remove()
    @checkButton.onclick  = => @toggleStatus()