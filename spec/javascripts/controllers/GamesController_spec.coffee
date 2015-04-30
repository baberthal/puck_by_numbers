describe "GamesController", ->
  scope       = null
  ctrl        = null
  location    = null
  routeParams = null
  resource    = null
  httpBackend = null

  setupController = (q,results)->
    inject(($location, $routeParams, $rootScope, $resource, $httpBackend, $controller) ->
      scope         = $rootScope.$new()
      location      = $location
      resource      = $resource
      routeParams   = $routeParams
      routeParams.q = q
      httpBackend   = $httpBackend

      if results
        request = new RegExp("\/games.*q=#{q}")
        httpBackend.expectGET(request).respond(results)

      ctrl          = $controller('GamesController',
                                  $scope: scope
                                  $location: location)
    )

  beforeEach(module("puckbynumbers"))
  beforeEach(setupController())

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  it 'defaults to all games', ->
    expect(scope.games).not.toBe(null)

  describe 'controller initilization', ->
    describe 'when no query present', ->
      beforeEach(setupController())

      it 'defaults to all games', ->
        expect(scope.games).not.toBe(null)

  describe 'with query', ->
    q = 'Flyers'
    games = [
      {
        id: [20142015,20001]
        season_years: 20142015
        gcode: 20001
        date: '2014-10-08'
      },
      {
        id: [20142015,20002]
        season_years: 20142015
        gcode: 20002
        date: '2014-10-08'
      },
    ]
    beforeEach ->
      setupController(q,games)
      httpBackend.flush()

    it 'calls the backend', ->
      expect(scope.games).toEqualData(games)

    describe 'search()', ->
      beforeEach ->
        setupController()

    it 'redirects to itself with a query param', ->
      q = "foo"
      scope.search(q)
      expect(location.path()).toBe('/')
      expect(location.search()).toEqualData({q: q})


#  vim: set ts=8 sw=2 tw=0 et :
