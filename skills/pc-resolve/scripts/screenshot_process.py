#!/usr/bin/env python3
"""screenshot_process.py — processa resposta base64 da API screenshot e chama Gemini."""
import json, sys, os, base64
from urllib.request import Request, urlopen
from urllib.error import URLError

def log(msg):
    print(f"[screenshot] {msg}", file=sys.stderr)

def main():
    ss_file = sys.argv[1]
    model = sys.argv[2]
    gemini_key = sys.argv[3]
    # native_w/h from env or defaults
    native_w = int(os.environ.get("NATIVE_W") or 0)
    native_h = int(os.environ.get("NATIVE_H") or 0)

    with open(ss_file) as f:
        ss = json.load(f)

    if not ss.get("ok"):
        err = ss.get("error", "unknown")
        log(f"❌ Screenshot falhou: {err}")
        print(json.dumps({"error": err, "method": "failed"}))
        return

    method = ss.get("method", "?")
    img_res = ss.get("image_resolution", {})
    img_w = img_res.get("width", 0)
    img_h = img_res.get("height", 0)
    nat_res = ss.get("native_resolution", {})
    if native_w == 0:
        native_w = nat_res.get("width", 1920)
    if native_h == 0:
        native_h = nat_res.get("height", 1080)
    b64 = ss.get("data", "")
    scale_x = native_w / img_w if img_w > 0 else 1.0
    scale_y = native_h / img_h if img_h > 0 else 1.0

    log(f"✅ Screenshot: {len(b64)} chars, {img_w}x{img_h} → {native_w}x{native_h}, method={method}")

    if not gemini_key:
        log("⚠️  GEMINI_API_KEY ausente — retornando raw")
        print(f"📸 Screenshot capturado ({method}, {native_w}x{native_h}, {len(b64)} chars base64).\n⚠️  Gemini não configurado — use a imagem diretamente.")
        return

    # === Chamar Gemini ===
    prompt = f"""Descreva esta tela de computador Windows em português do Brasil.
Retorne APENAS um JSON válido (sem markdown, sem ```json) com este formato:
{{
  "tela": "descrição textual concisa do que aparece na tela",
  "elementos": [
    {{"texto": "nome do elemento", "tipo": "icone|botao|aba|janela|menu|campo|link", "x": <coord_x>, "y": <coord_y>}}
  ]
}}
A imagem está em {img_w}x{img_h} pixels. Forneça as coordenadas na resolução DA IMAGEM ({img_w}x{img_h}).
Liste APENAS os 10 elementos mais importantes. Seja preciso nas coordenadas (centro do elemento)."""

    payload = {
        "contents": [{
            "parts": [
                {"text": prompt},
                {"inline_data": {"mime_type": "image/jpeg", "data": b64}}
            ]
        }],
        "generationConfig": {"temperature": 0.1, "maxOutputTokens": 8192}
    }

    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={gemini_key}"
    req = Request(url, data=json.dumps(payload).encode(), headers={"Content-Type": "application/json"})

    log(f"🤖 Descrevendo com {model}...")
    try:
        with urlopen(req, timeout=45) as resp:
            gemini = json.loads(resp.read())
    except URLError as e:
        log(f"❌ Gemini erro: {e}")
        print(f"📸 Screenshot capturado ({method}, {native_w}x{native_h}).\n❌ Erro ao chamar Gemini: {e}")
        return

    # Extrair texto
    candidates = gemini.get("candidates", [])
    if not candidates:
        finish = gemini.get("promptFeedback", {}).get("blockReason", "?")
        log(f"❌ Gemini: sem candidates (blockReason={finish})")
        print(f"📸 Screenshot capturado ({method}, {native_w}x{native_h}).\n⚠️  Gemini bloqueou: {finish}")
        return

    text = candidates[0].get("content", {}).get("parts", [{}])[0].get("text", "")
    if not text:
        fr = candidates[0].get("finishReason", "?")
        log(f"❌ Gemini: texto vazio (finishReason={fr})")
        print(f"📸 Screenshot capturado ({method}, {native_w}x{native_h}).\n⚠️  Gemini retornou vazio (finishReason={fr})")
        return

    # Parsear JSON da resposta
    raw = text.strip()
    if raw.startswith("```"):
        lines = raw.split("\n")
        lines = [l for l in lines if not l.startswith("```")]
        raw = "\n".join(lines).strip()

    try:
        parsed = json.loads(raw)
    except json.JSONDecodeError:
        # Tentar extrair só o JSON da resposta
        import re
        m = re.search(r'\{.*\}', raw, re.DOTALL)
        if m:
            try:
                parsed = json.loads(m.group())
            except json.JSONDecodeError:
                # Tentar recuperar JSON truncado (fechar chaves/colchetes)
                from json import JSONDecodeError
                # Contar abertura/fechamento
                open_braces = raw.count('{') - raw.count('}')
                open_brackets = raw.count('[') - raw.count(']')
                # Remover trailing truncation (última linha incompleta)
                lines = raw.split('\n')
                if lines and not lines[-1].strip().endswith(('}','"',']')):
                    lines = lines[:-1]
                    raw = '\n'.join(lines)
                # Fechar
                raw = raw.rstrip().rstrip(',')
                raw += ']' * open_brackets
                raw += '}' * open_braces
                try:
                    parsed = json.loads(raw)
                    log(f"⚠️  JSON truncado recuperado ({open_braces} chaves, {open_brackets} colchetes fechados)")
                except JSONDecodeError:
                    log(f"❌ JSON inválido na resposta Gemini (irrecuperável)")
                    print(f"📸 Screenshot: {method}, {native_w}x{native_h}\n⚠️  Gemini respondeu mas formato inválido:\n{raw[:500]}")
                    return
        else:
            log(f"❌ Sem JSON na resposta Gemini")
            print(f"📸 Screenshot: {method}, {native_w}x{native_h}\n⚠️  Gemini respondeu sem JSON:\n{raw[:500]}")
            return

    tela = parsed.get("tela", "")
    elementos = parsed.get("elementos", [])

    # Escalar coordenadas
    for e in elementos:
        e["x"] = int(float(e["x"]) * scale_x)
        e["y"] = int(float(e["y"]) * scale_y)

    # Output no formato que Flavinho espera
    print(f"TELA: {tela}")
    print(f"Resolução: {native_w}x{native_h} | Modelo: {model} | Método: {method} | Escala: {scale_x:.3f}")
    print(f"📍 COORDENADAS EXATAS ({len(elementos)} elementos):")
    for e in elementos:
        tipo = e.get("tipo", "?")
        texto = e.get("texto", "")
        print(f'x={e["x"]} y={e["y"]} - "{texto}" ({tipo})')

if __name__ == "__main__":
    main()
