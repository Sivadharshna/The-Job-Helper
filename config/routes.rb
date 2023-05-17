Rails.application.routes.draw do


      namespace :api ,default: {format: :json} do
        resources :users , only: [:create] 
        namespace :v1 do

              #individual applications
        post '/jobs/:job_id/individual_applications' , to: 'individual_applications#create'
        get '/individuals/:individual_id/individual_applications', to: 'individual_applications#index'
        get '/companies/:company_id/jobs/:job_id/individual_applications', to: 'individual_applications#index'
        put '/individual_applications/:id', to: 'individual_applications#update'
        delete '/individual_applications/:id', to: 'individual_applications#destroy'
        
        #accepted_offers
        get '/companies/:company_id/jobs/:job_id/:approval_type/:approval_id/accepted_offers/new' , to: 'accepted_offers#new'
        post '/companies/:company_id/jobs/:job_id/:approval_type/:approval_id/accepted_offers/new' , to: 'accepted_offers#create'
        get '/companies/:company_id/:approval_type/:approval_id/accepted_offers/new' , to: 'accepted_offers#new'
        post '/companies/:company_id/:approval_type/:approval_id/accepted_offers/new' , to: 'accepted_offers#create'
         

        #get '/companies/:company_id/:application_type/:application_id/accepted_offers/new' , to: 'accepted_offers#new'
        #post '/companies/:company_id/:application_type/:application_id/accepted_offers' , to: 'accepted_offers#create'
        get 'companies/:company_id/accepted_offers/:id' ,to: 'accepted_offers#index'
        get 'colleges/:college_id/accepted_offers/:id' ,to: 'accepted_offers#index'
        get 'individuals/:individual_id/accepted_offers/:id' , to: 'accepted_offers#index'
        get '/accepted_offers/calendar', to: 'accepted_offers#calendar'

        #college applications
        post '/companies/:company_id/college_applications/new' , to: 'college_applications#create'
        get '/colleges/:college_id/college_applications', to: 'college_applications#index'
        get '/companies/:company_id/college_applications', to: 'college_applications#index'
        put '/college_applications/:id', to: 'college_applications#update'
        delete '/college_applications/:id', to: 'college_applications#destroy'


        #company see students
        get '/college_applications/:college_application_id/companies/:company_id/students/view', to: 'students#index'
        get '/college_applications/:college_application_id/students' , to: 'students#select'
        post '/college_applications/:college_application_id/students/:student_id/select_students', to: 'colleges#select_students'


        #companies controller and jobs controller
        resources :companies, except: [:destroy] do
          resources :jobs
        end
        get '/jobs/', to: 'jobs#index'
        get '/jobs/specific', to: 'jobs#specific'


        #colleges controller and courses controller
        resources :colleges, except: [:index, :destroy] do
          resources :courses, except: [:show]
        end

        #individuals controller
        resources :individuals, except: [:index, :destroy]

        resources :courses, except: [:index, :show] do
          resources :students , except: [:index, :show]
        end

        get '/colleges/:college_id/students', to: 'students#index'

        get '/individuals/:individual_id/jobs/', to: 'jobs#index'
        get '/individuals/:individual_id/jobs/specific', to: 'jobs#specific'

         #job details
         get '/individuals/:individual_id/job_details', to: 'job_details#index'
         post '/accepted_offers/:accepted_offer_id/job_details' , to: 'job_details#create'

        #company appoints students
        post '/college_applications/:college_application_id/students/:student_id/appoint', to: 'students#appoint'
        get '/college_applications/:college_application_id/appoint', to: 'students#appointed'
        
        end
      end

      scope :api do
        scope :v1 do
          use_doorkeeper do
              skip_controllers :applications, :authorizations, :authorized_applications
          end
        end
      end

  
      

      devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }
  
      root to: 'home#index'

      devise_for :admin_users, ActiveAdmin::Devise.config
      ActiveAdmin.routes(self)
        
      use_doorkeeper do
        skip_controllers :authorizations, :authorized_applications
      end

             
        #individual applications
        post '/jobs/:job_id/individual_applications' , to: 'individual_applications#create'
        get '/individual/:individual_id/individual_applications', to: 'individual_applications#index'
        get '/companies/:company_id/jobs/:job_id/individual_applications', to: 'individual_applications#index'
        put '/individual_applications/:id', to: 'individual_applications#update'
        delete '/individual_applications/:id', to: 'individual_applications#destroy'
        
        #accepted_offers
        get '/companies/:company_id/jobs/:job_id/:approval_type/:approval_id/accepted_offers/new' , to: 'accepted_offers#new'
        post '/companies/:company_id/jobs/:job_id/:approval_type/:approval_id/accepted_offers/new' , to: 'accepted_offers#create'
        get '/companies/:company_id/:approval_type/:approval_id/accepted_offers/new' , to: 'accepted_offers#new'
        post '/companies/:company_id/:approval_type/:approval_id/accepted_offers/new' , to: 'accepted_offers#create'
        

        #get '/companies/:company_id/:application_type/:application_id/accepted_offers/new' , to: 'accepted_offers#new'
        #post '/companies/:company_id/:application_type/:application_id/accepted_offers' , to: 'accepted_offers#create'
        get 'companies/:company_id/accepted_offers/:id' ,to: 'accepted_offers#index'
        get 'colleges/:college_id/accepted_offers/:id' ,to: 'accepted_offers#index'
        get 'individuals/:individual_id/accepted_offers/:id' , to: 'accepted_offers#index'
        get '/accepted_offers/calendar', to: 'accepted_offers#calendar'

        #college applications
        post '/companies/:company_id/college_applications/new' , to: 'college_applications#create'
        get '/colleges/:college_id/college_applications', to: 'college_applications#index'
        get '/companies/:company_id/college_applications', to: 'college_applications#index'
        put '/college_applications/:id', to: 'college_applications#update'
        delete '/college_applications/:id', to: 'college_applications#destroy'


        #company see students
        get '/college_applications/:college_application_id/companies/:company_id/students/view', to: 'students#index'
        get '/college_applications/:college_application_id/students' , to: 'students#select'
        post '/college_applications/:college_application_id/students/:student_id/select_students', to: 'colleges#select_students'


        #company appoints students
        post '/college_applications/:college_application_id/students/:student_id/appoint', to: 'students#appoint'
        get '/college_applications/:college_application_id/appoint', to: 'students#appointed'

        #companies controller and jobs controller
        resources :companies, except: [:destroy] do
          resources :jobs
        end
        get '/jobs/', to: 'jobs#index'
        get '/jobs/specific', to: 'jobs#specific'


        #colleges controller and courses controller
        resources :colleges, except: [:index, :destroy] do
          resources :courses, except: [:show]
        end

        #individuals controller
        resources :individuals, except: [:index, :destroy]

        resources :courses, except: [:index, :show] do
          resources :students, except: [:show]
        end

        get '/colleges/:college_id/students', to: 'students#index'

        get '/individuals/:individual_id/jobs/', to: 'jobs#index'
        get '/individuals/:individual_id/jobs/specific', to: 'jobs#specific'

         #job details
         get '/individuals/:individual_id/job_details', to: 'job_details#index'
         post '/accepted_offers/:accepted_offer_id/job_details' , to: 'job_details#create'
        
        
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    end
