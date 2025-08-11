apiVersion: v1
preferences: {}
kind: Config

clusters:
- cluster:
    server: ${endpoint}
    certificate-authority-data: ${clusterca}
  name: ${cluster_name}

contexts:
- context:
    cluster: ${cluster_name}
    user: ${user_name}
  name: ${cluster_name}

current-context: ${cluster_name}

users:
- name: ${user_name}
  user:
    token: ${token}
