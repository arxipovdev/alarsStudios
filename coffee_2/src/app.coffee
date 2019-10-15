init = () ->
  class User extends Backbone.Model
    defaults:
      name: ''
      phone: ''
    validate: (attrs, options) ->
      phoneRegex = /^[\+]?(\d-?){10}\d$/
      error = {}
      error.name = 'invalid name' if attrs.name.length == 0
      error.phone = 'invalid phone' unless phoneRegex.test attrs.phone
      if error.name || error.phone then error else undefined

  class UserCollection extends Backbone.Collection
    model: User

  item1 = new User {name: 'Andrey', phone: '7-923-230-23-45'}
  item2 = new User {name: 'Ivan', phone: '7-923-345-45-45'}
  item3 = new User {name: 'Elena', phone: '7-345-230-22-45'}
  item4 = new User {name: 'Maxim', phone: '7-322-555-22-45'}
  userCollection = new UserCollection [item1, item2, item3, item4]
#  userCollection = new UserCollection

  class UserView extends Backbone.View
    model: new User
    tagName: 'tr'
    initialize: ->
      @template = _.template document.querySelector('.userTemplate').innerHTML
    events:
      'click .userTemplate__edit':    'edit'
      'click .userTemplate__save':    'save'
      'click .userTemplate__cancel':  'cancel'
      'click .userTemplate__delete':  'delete'
    validationField: (user, name, phone) ->
      if user.validationError
        if user.validationError.name
          name.classList.add 'is-invalid'
          document.querySelector('.userTemplate__name__error').style.display = 'block'
        else
          name.classList.remove'is-invalid'
          document.querySelector('.userTemplate__name__error').style.display = 'none'
        if user.validationError.phone
          phone.classList.add 'is-invalid'
          document.querySelector('.userTemplate__phone__error').style.display = 'block'
        else
          phone.classList.remove 'is-invalid'
          document.querySelector('.userTemplate__phone__error').style.display = 'none'
    edit: ->
      hideElement = (element) -> element.hidden = true
      hideElement element for element in document.querySelectorAll '.userTemplate__edit'
      hideElement element for element in document.querySelectorAll '.userTemplate__delete'

      name = @$('.userTemplate__name').text()
      phone = @$('.userTemplate__phone').text()

      @$('.userTemplate__save').attr    'hidden', false
      @$('.userTemplate__cancel').attr  'hidden', false
      createInputHtml = (className, classError, value, errorMsg) ->
        "<input class='#{className} form-control form-control-sm' type='text' value='#{value}'>
        <div class='#{classError} invalid-feedback'>#{errorMsg}</div>"
      @$('.userTemplate__name').html createInputHtml('userTemplate__nameUpdated', 'userTemplate__name__error', name, 'Обязательное поле')
      @$('.userTemplate__phone').html createInputHtml('userTemplate__phoneUpdated', 'userTemplate__phone__error', phone, 'Введите корректный номер')
    save: ->
      name = document.querySelector '.userTemplate__nameUpdated'
      phone = document.querySelector '.userTemplate__phoneUpdated'

      @model.set
        name: name.value
        phone: phone.value
      , validate: true
      @validationField @model, name, phone
    cancel: ->
      userListView.render()
    delete: ->
      @model.destroy()
    render: ->
      @$el.html @template @model.toJSON()
      @

  class UserListView extends Backbone.View
    el: document.querySelector('.user')
    model: userCollection
    initialize: ->
      @model.on 'add', @render, @
      @model.on 'change', @changeCollection
      @model.on 'remove', @render, @
      @render()
    events: 'click .user__add': 'addUser'
    validationField: (user, name, phone) ->
      if user.validationError
        if user.validationError.name
          name.classList.add 'is-invalid'
          document.querySelector('.user__name__error').style.display = 'block'
        else
          name.classList.remove'is-invalid'
          document.querySelector('.user__name__error').style.display = 'none'
        if user.validationError.phone
          phone.classList.add 'is-invalid'
          document.querySelector('.user__phone__error').style.display = 'block'
        else
          phone.classList.remove 'is-invalid'
          document.querySelector('.user__phone__error').style.display = 'none'
      else
        @model.add user
        name.value = ''
        phone.value = ''
        name.classList.remove  'is-invalid'
        phone.classList.remove 'is-invalid'
        document.querySelector('.user__name__error').style.display = 'none'
        document.querySelector('.user__phone__error').style.display = 'none'
    addUser: ->
      name = document.querySelector '.user__name'
      phone = document.querySelector '.user__phone'
      user = new User
      user.set
        name: name.value
        phone: phone.value
      , validate: true
      @validationField user, name, phone
    changeCollection: () ->
      setTimeout ->
        userListView.render()
      ,10
    addToCollection: (item) ->
      userView = new UserView model: item
      list = document.querySelector '.user__list'
      list.append userView.render().el
    render: ->
      list = document.querySelector '.user__list'
      list.innerHTML = ''
      @model.each (user) =>
        list.append (new UserView({model: user})).render().el
      @

  userListView = new UserListView()

window.onload = init