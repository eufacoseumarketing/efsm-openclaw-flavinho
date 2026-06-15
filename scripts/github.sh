#!/bin/bash
# GitHub — operações reutilizáveis
# Conta: eufacoseumarketing
# Credenciais: ${SECRETS_DIR:-/home/node/.openclaw/workspace/workspace-ananias/.secrets}/github_pat
# Uso:
#   source scripts/github.sh
#   github_repos                # Lista todos os repositórios
#   github_repo "nome"          # Detalhes de um repositório
#   github_create_repo "nome"   # Cria novo repositório privado

GITHUB_TOKEN=$(cat ${SECRETS_DIR:-/home/node/.openclaw/workspace/workspace-ananias/.secrets}/github_pat)
GITHUB_USER="eufacoseumarketing"
GITHUB_API="https://api.github.com"

gh_api() {
  curl -s "${GITHUB_API}${1}" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Accept: application/json"
}

github_repos() {
  gh_api "/users/${GITHUB_USER}/repos?per_page=50&sort=updated&type=all" | jq '[.[] | {name: .name, private: .private, updated: .updated_at[:10], language: .language}]'
}

github_repo() {
  gh_api "/repos/${GITHUB_USER}/${1}" | jq '{name: .name, private: .private, default_branch: .default_branch, created: .created_at[:10], pushed: .pushed_at[:10], language: .language}'
}

github_create_repo() {
  local name="$1"
  local desc="${2:-EFSM Project}"
  curl -s -X POST "${GITHUB_API}/user/repos" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"${name}\",\"private\":true,\"description\":\"${desc}\"}" | jq '{name: .name, private: .private, clone_url: .ssh_url, html_url: .html_url}'
}

echo "✅ GitHub scripts carregados"
echo "   github_repos | github_repo <name> | github_create_repo <name> [desc]"
