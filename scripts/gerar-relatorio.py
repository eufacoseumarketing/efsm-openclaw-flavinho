#!/usr/bin/env python3
"""
Gerador de Relatórios HTML - Chocotô
Recebe JSON com dados do relatório e gera HTML formatado.
Uso: echo '{"titulo":"...", "dados":[...]}' | python3 gerar-relatorio.py > /tmp/openclaw/relatorio.html
"""

import json
import sys
from datetime import datetime

TEMPLATE = '''<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{titulo}</title>
    <style>
        * {{ margin: 0; padding: 0; box-sizing: border-box; }}
        body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #0f0f23; color: #e0e0e0; padding: 2rem; }}
        .container {{ max-width: 1200px; margin: 0 auto; }}
        h1 {{ color: #7c3aed; font-size: 2rem; margin-bottom: 0.5rem; }}
        .subtitle {{ color: #888; margin-bottom: 2rem; }}
        .cards {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-bottom: 2rem; }}
        .card {{ background: #1a1a2e; border-radius: 12px; padding: 1.5rem; border: 1px solid #2d2d44; }}
        .card .label {{ color: #888; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; }}
        .card .value {{ color: #fff; font-size: 2rem; font-weight: 700; margin-top: 0.25rem; }}
        .card .change {{ font-size: 0.85rem; margin-top: 0.25rem; }}
        .card .change.up {{ color: #4ade80; }}
        .card .change.down {{ color: #f87171; }}
        table {{ width: 100%; border-collapse: collapse; margin-bottom: 2rem; }}
        th {{ background: #1a1a2e; color: #7c3aed; padding: 0.75rem 1rem; text-align: left; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #2d2d44; }}
        td {{ padding: 0.75rem 1rem; border-bottom: 1px solid #1a1a2e; }}
        tr:hover td {{ background: #1a1a2e; }}
        .section {{ margin-bottom: 2rem; }}
        .section h2 {{ color: #a78bfa; font-size: 1.25rem; margin-bottom: 1rem; padding-bottom: 0.5rem; border-bottom: 1px solid #2d2d44; }}
        .footer {{ text-align: center; color: #555; font-size: 0.8rem; margin-top: 3rem; padding-top: 1rem; border-top: 1px solid #2d2d44; }}
        .badge {{ display: inline-block; padding: 0.25rem 0.75rem; border-radius: 999px; font-size: 0.75rem; font-weight: 600; }}
        .badge-success {{ background: #065f46; color: #4ade80; }}
        .badge-warning {{ background: #78350f; color: #fbbf24; }}
        .badge-danger {{ background: #7f1d1d; color: #f87171; }}
    </style>
</head>
<body>
    <div class="container">
        <h1>{titulo}</h1>
        <p class="subtitle">Gerado em {data_geracao}</p>
        {cards_html}
        {tabelas_html}
        {secoes_html}
        <div class="footer">
            Relatório gerado automaticamente pela Chocotô · EFSM · {data_geracao}
        </div>
    </div>
</body>
</html>'''

def format_number(n):
    if n is None:
        return '-'
    if isinstance(n, float):
        return f'{n:,.1f}'
    if isinstance(n, int) and abs(n) >= 1000000:
        return f'{n/1000000:.1f}M'
    if isinstance(n, int) and abs(n) >= 1000:
        return f'{n/1000:.1f}K'
    return f'{n:,}'

def generate_cards(metrics):
    if not metrics:
        return ''
    cards = '<div class="cards">'
    for m in metrics:
        change_class = ''
        change_html = ''
        if m.get('variacao') is not None:
            var = m['variacao']
            change_class = 'up' if var >= 0 else 'down'
            arrow = '↑' if var >= 0 else '↓'
            change_html = f'<div class="change {change_class}">{arrow} {abs(var):.1f}%</div>'
        cards += f'''
        <div class="card">
            <div class="label">{m['label']}</div>
            <div class="value">{format_number(m['valor'])}</div>
            {change_html}
        </div>'''
    cards += '</div>'
    return cards

def generate_table(table_data):
    if not table_data or not table_data.get('rows'):
        return ''
    cols = table_data.get('colunas', [])
    rows = table_data.get('rows', [])
    html = '<div class="section">'
    if table_data.get('titulo'):
        html += f'<h2>{table_data["titulo"]}</h2>'
    html += '<table><thead><tr>'
    for col in cols:
        html += f'<th>{col}</th>'
    html += '</tr></thead><tbody>'
    for row in rows:
        html += '<tr>'
        for cell in row:
            if isinstance(cell, (int, float)):
                html += f'<td>{format_number(cell)}</td>'
            else:
                html += f'<td>{cell}</td>'
        html += '</tr>'
    html += '</tbody></table></div>'
    return html

def generate_sections(secoes):
    if not secoes:
        return ''
    html = ''
    for sec in secoes:
        html += f'<div class="section"><h2>{sec["titulo"]}</h2>'
        if sec.get('paragrafos'):
            for p in sec['paragrafos']:
                html += f'<p style="margin-bottom:0.75rem;line-height:1.6;">{p}</p>'
        if sec.get('metricas'):
            html += generate_cards(sec['metricas'])
        if sec.get('tabela'):
            html += generate_table(sec['tabela'])
        html += '</div>'
    return html

def main():
    data = json.load(sys.stdin)
    
    titulo = data.get('titulo', 'Relatório')
    metricas = data.get('metricas', [])
    tabelas = data.get('tabelas', [])
    secoes = data.get('secoes', [])
    
    cards_html = generate_cards(metricas)
    tabelas_html = ''.join(generate_table(t) for t in tabelas)
    secoes_html = generate_sections(secoes)
    
    html = TEMPLATE.format(
        titulo=titulo,
        data_geracao=datetime.now().strftime('%d/%m/%Y %H:%M'),
        cards_html=cards_html,
        tabelas_html=tabelas_html,
        secoes_html=secoes_html
    )
    
    print(html)

if __name__ == '__main__':
    main()
