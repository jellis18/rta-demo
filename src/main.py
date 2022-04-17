import spacy
from fastapi import FastAPI, Form, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from spacy import displacy

nlp = spacy.load("en_core_web_sm")


def process_text(text: str) -> str:
    doc = nlp(text)
    rendered_html = displacy.render(doc, style="ent", minify=True)
    if "<script" in rendered_html:
        raise RuntimeError("May have malicious code, Aborting")
    return rendered_html


app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")

templates = Jinja2Templates(directory="templates")


@app.get("/", response_class=HTMLResponse)
async def root(request: Request):
    return templates.TemplateResponse("home.html", {"request": request})


@app.post("/extraction", response_class=HTMLResponse)
async def extract(request: Request, text: str = Form(...)):
    entities = process_text(text)
    return templates.TemplateResponse("extraction.html", {"request": request, "entities": entities})
