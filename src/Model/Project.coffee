_ = require "underscore"
Model = require "./Model"
Dataflow = require "../Dataflow/Dataflow"


module.exports = class Project
  constructor: ->
    initialElement = @createNewElement()

    # Testing
    initialElement.addChild(Model.Rectangle.createVariant())
    initialElement.addChild(Model.Circle.createVariant())

    @editingElement = initialElement
    @selectedParticularElement = null

    @createPanelElements = [
      Model.Rectangle
      Model.Circle
      Model.Text
      initialElement
    ]

    propsToMemoize = [
      "controlledAttributes"
      "implicitlyControlledAttributes"
      "controllableAttributes"
    ]
    for prop in propsToMemoize
      this[prop] = Dataflow.memoize(this[prop].bind(this))


  # ===========================================================================
  # Selection
  # ===========================================================================

  setEditing: (element) ->
    @editingElement = element
    @selectedParticularElement = null

  select: (particularElement) ->
    if !particularElement
      @selectedParticularElement = null
      return
    @selectedParticularElement = particularElement
    @_expandToElement(particularElement.element)

  _expandToElement: (element) ->
    while element = element.parent()
      element.expanded = true


  # ===========================================================================
  # Actions
  # ===========================================================================

  createNewElement: ->
    element = Model.Group.createVariant()
    element.expanded = true
    return element

  removeSelectedElement: ->
    return unless @selectedParticularElement
    selectedElement = @selectedParticularElement.element
    parent = selectedElement.parent()
    return unless parent
    parent.removeChild(selectedElement)
    @select(null)


  # ===========================================================================
  # Memoized attribute sets
  # ===========================================================================

  controlledAttributes: ->
    return @selectedParticularElement?.element.controlledAttributes() ? []

  implicitlyControlledAttributes: ->
    return @selectedParticularElement?.element.implicitlyControlledAttributes() ? []

  controllableAttributes: ->
    return @selectedParticularElement?.element.controllableAttributes() ? []
