Rails.application.routes.draw do


      namespace :api ,default: {format: :json} do
        resources :users , only: [:create] 
        namespace :v1 do

              #individual applications
              post '/jobs/:job_id/individual_applications' , to: 'individual_applications#create'
              get '/individuals/:individual_id/individual_applications', to: 'individual_applications#index'
              get '/companies/:company_id/jobs/:job_id/individual_applications', to: 'individual_applications#index'
              
              #accepted_offers
                  #get '/companies/:company_id/jobs/:job_id/:application_type/:application_id/accepted_offers/new' , to: 'accepted_offers#new'
                  #post '/companies/:company_id/jobs/:job_id/individual_applications/:individual_application_id/accepted_offers/new' , to: 'accepted_offers#create'
              get '/companies/:company_id/:application_type/:application_id/accepted_offers/new' , to: 'accepted_offers#new'
              post '/companies/:company_id/:application_type/:application_id/accepted_offers' , to: 'accepted_offers#create'
              get '/companies/:company_id/accepted_offers' ,to: 'accepted_offers#index'
              get '/colleges/:college_id/accepted_offers' ,to: 'accepted_offers#index'
              get '/individuals/:individual_id/accepted_offers' , to: 'accepted_offers#index'
              
              #college applications
              post '/companies/:company_id/college_applications' , to: 'college_applications#create'
              get '/colleges/:college_id/college_applications', to: 'college_applications#index'
              get '/companies/:company_id/college_applications', to: 'college_applications#index'

              get '/jobs/', to: 'jobs#index'

              #selection details of students
              get '/colleges/:college_id/selection_details', to: 'selection_details#index'
              post '/students/:student_id/companies/:company_id/selection_details' , to: 'selection_details#create'


              #job details
              get 'individuals/individual_id/job_details', to: 'job_details#index'
              post '/accepted_offers/:accepted_offer_id/job_details' , to: 'job_details#create'
              
              
              resources :companies do
                resources :jobs 
              end

              resources :colleges do
                resources :courses
              end

              resources :courses, only: [] do
                resources :students
              end

              #company see students
        get '/colleges/:college_id/students' , to: 'students#index'
        post '/companies/:company_id/students/:student_id/select_students', to: 'companies#select_students'

              
        
        end
      end

      scope :api do
        scope :v1 do
          use_doorkeeper do
              skip_controllers :applications, :authorizations, :authorized_applications
          end
        end
      end

  
      devise_for :admin_users, ActiveAdmin::Devise.config
      ActiveAdmin.routes(self)
        root to: 'home#index'

      devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }
  

        #individual applications
        post '/jobs/:job_id/individual_applications' , to: 'individual_applications#create'
        get '/individual/:individual_id/individual_applications', to: 'individual_applications#index'
        get '/companies/:company_id/jobs/:job_id/individual_applications', to: 'individual_applications#index'
        
        #accepted_offers
        get '/companies/:company_id/jobs/:job_id/:application_type/:application_id/accepted_offers/new' , to: 'accepted_offers#new'
        post '/companies/:company_id/jobs/:job_id/individual_applications/:individual_application_id/accepted_offers' , to: 'accepted_offers#create'
        get '/companies/:company_id/:application_type/:application_id/accepted_offers/new' , to: 'accepted_offers#new'
        post '/companies/:company_id/:application_type/:application_id/accepted_offers' , to: 'accepted_offers#create'
        get 'companies/:company_id/accepted_offers' ,to: 'accepted_offers#index'
        get 'colleges/:college_id/accepted_offers' ,to: 'accepted_offers#index'
        get 'individuals/:individual_id/accepted_offers' , to: 'accepted_offers#index'
        
        #college applications
        post '/companies/:company_id/college_applications/new' , to: 'college_applications#create'
        get '/colleges/:college_id/college_applications', to: 'college_applications#index'
        get '/companies/:company_id/college_applications', to: 'college_applications#index'



        #company see students
        get '/colleges/:college_id/students' , to: 'students#index'
        post '/companies/:company_id/students/:student_id/select_students', to: 'companies#select_students'

        resources :companies do
          resources :jobs
        end

        resources :colleges do
          resources :courses
        end

        resources :courses do
          resources :students
        end

        resources :individuals do
          resources :jobs
        end

         #job details
         get 'individuals/individual_id/job_details', to: 'job_details#index'
         post '/accepted_offers/:accepted_offer_id/job_details' , to: 'job_details#create'
        
        resources :companies
        resources :individuals
        resources :colleges
        
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    end
