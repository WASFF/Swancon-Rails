# For more information see: http://emberjs.com/guides/routing/

Admin.Router.map ()->
  @route('check_details')
  @route('front_desk')
  @resource 'member_tickets', {path: '/member/:member_id/tickets'}
  @resource 'store', {path: '/member/:member_id/store'}

