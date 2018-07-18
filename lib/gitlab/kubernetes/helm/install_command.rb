module Gitlab
  module Kubernetes
    module Helm
      class InstallCommand < BaseCommand
        attr_reader :name, :chart, :version, :repository, :values

        def generate_script
          super + [
            init_command,
            configure_certs_command,
            repository_command,
            script_command
          ].compact.join("\n")
        end

        def config_map?
          true
        end

        def config_map_resource
          Gitlab::Kubernetes::ConfigMap.new(name, values).generate
        end

        private

        def configure_certs_command
          return "" unless ca_cert.present?
          <<~CMD
          echo "$CA_CERT" > $(helm home)/ca.pem
          echo "$HELM_CERT" > $(helm home)/cert.pem
          echo "$HELM_KEY" > $(helm home)/key.pem
          CMD
        end

        def init_command
          'helm init --client-only >/dev/null'
        end

        def repository_command
          "helm repo add #{name} #{repository}" if repository
        end

        def script_command
          tls_flag = " --tls" if ca_cert.present?
          <<~HEREDOC
          helm install#{tls_flag} #{chart} --name #{name}#{optional_version_flag} --namespace #{Gitlab::Kubernetes::Helm::NAMESPACE} -f /data/helm/#{name}/config/values.yaml >/dev/null
          HEREDOC
        end

        def optional_version_flag
          " --version #{version}" if version
        end
      end
    end
  end
end
