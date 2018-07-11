role :app, %w{deployer@92.53.66.125}
role :web, %w{deployer@92.53.66.125}
role :db, %w{deployer@92.53.66.125}

set :rails_env, :production

server "92.53.66.125", user: "deployer", roles: %w{web app db}, primary: true

set :ssh_options, {
    keys: %w(/Users/macbook/.ssh/id_rsa),
    forward_agent: true,
    auth_methods: %w(publickey password),
    port: 22
}