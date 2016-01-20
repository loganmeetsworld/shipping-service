Rails.application.routes.draw do
  get 'rates' => 'shipments#rates'
  post 'audit_logs' => 'shipments#audit'
end
