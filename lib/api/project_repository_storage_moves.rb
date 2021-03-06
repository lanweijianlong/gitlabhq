# frozen_string_literal: true

module API
  class ProjectRepositoryStorageMoves < Grape::API
    include PaginationParams

    before { authenticated_as_admin! }

    resource :project_repository_storage_moves do
      desc 'Get a list of all project repository storage moves' do
        detail 'This feature was introduced in GitLab 13.0.'
        success Entities::ProjectRepositoryStorageMove
      end
      params do
        use :pagination
      end
      get do
        storage_moves = ProjectRepositoryStorageMove.with_projects.order_created_at_desc

        present paginate(storage_moves), with: Entities::ProjectRepositoryStorageMove, current_user: current_user
      end

      desc 'Get a project repository storage move' do
        detail 'This feature was introduced in GitLab 13.0.'
        success Entities::ProjectRepositoryStorageMove
      end
      params do
        requires :repository_storage_move_id, type: Integer, desc: 'The ID of a project repository storage move'
      end
      get ':repository_storage_move_id' do
        storage_move = ProjectRepositoryStorageMove.find(params[:repository_storage_move_id])

        present storage_move, with: Entities::ProjectRepositoryStorageMove, current_user: current_user
      end
    end

    params do
      requires :id, type: String, desc: 'The ID of a project'
    end
    resource :projects, requirements: API::NAMESPACE_OR_PROJECT_REQUIREMENTS do
      desc 'Get a list of all project repository storage moves' do
        detail 'This feature was introduced in GitLab 13.1.'
        success Entities::ProjectRepositoryStorageMove
      end
      params do
        use :pagination
      end
      get ':id/repository_storage_moves' do
        storage_moves = user_project.repository_storage_moves.with_projects.order_created_at_desc

        present paginate(storage_moves), with: Entities::ProjectRepositoryStorageMove, current_user: current_user
      end

      desc 'Get a project repository storage move' do
        detail 'This feature was introduced in GitLab 13.1.'
        success Entities::ProjectRepositoryStorageMove
      end
      params do
        requires :repository_storage_move_id, type: Integer, desc: 'The ID of a project repository storage move'
      end
      get ':id/repository_storage_moves/:repository_storage_move_id' do
        storage_move = user_project.repository_storage_moves.find(params[:repository_storage_move_id])

        present storage_move, with: Entities::ProjectRepositoryStorageMove, current_user: current_user
      end
    end
  end
end
