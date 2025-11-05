from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import json
import uuid
from pathlib import Path

app = FastAPI(title="AutoLowParts API", version="1.0")

# --- CORS ---
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # можна обмежити, напр. ["http://localhost:5173"]
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Шлях до файлів ---
DATA_PATH = Path(__file__).parent / "data" / "parts.json"

# --- Моделі ---
class Part(BaseModel):
    id: str
    title: str
    brand: str
    price: int
    stock: int
    description: Optional[str] = ""
    image: Optional[str] = ""

class OrderItem(BaseModel):
    id: str
    title: str
    qty: int
    price: int

class Order(BaseModel):
    id: str
    name: str
    phone: str
    items: List[OrderItem]
    status: str = "received"
    createdAt: str


# --- Дані ---
def read_parts() -> List[Part]:
    with open(DATA_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)
    return [Part(**p) for p in data]


# --- Збереження замовлень у пам’яті ---
ORDERS: List[Order] = []


# --- API ---
@app.get("/api/parts", response_model=List[Part])
def get_parts(q: Optional[str] = Query(None), brand: Optional[str] = Query(None)):
    """Отримати список запчастин з опційним пошуком."""
    parts = read_parts()
    if q:
        q = q.lower()
        parts = [
            p for p in parts
            if q in p.title.lower() or q in (p.description or "").lower() or q in (p.brand or "").lower()
        ]
    if brand:
        brand = brand.lower()
        parts = [p for p in parts if p.brand.lower() == brand]
    return parts


@app.get("/api/parts/{part_id}", response_model=Part)
def get_part(part_id: str):
    """Отримати конкретну запчастину за ID."""
    parts = read_parts()
    for p in parts:
        if p.id == part_id:
            return p
    raise HTTPException(status_code=404, detail="Товар не знайдено")


class NewOrder(BaseModel):
    name: str
    phone: str
    items: List[OrderItem]


@app.post("/api/orders")
def create_order(order_data: NewOrder):
    """Створити замовлення."""
    if not order_data.name or not order_data.phone or not order_data.items:
        raise HTTPException(status_code=400, detail="Невірні дані замовлення")

    new_order = Order(
        id=str(uuid.uuid4()),
        name=order_data.name,
        phone=order_data.phone,
        items=order_data.items,
        status="received",
        createdAt=str(uuid.uuid1().time)
    )
    ORDERS.append(new_order)
    return {"message": "Замовлення отримано", "orderId": new_order.id}


@app.get("/api/orders", response_model=List[Order])
def get_orders():
    """Отримати всі замовлення (тимчасово з пам’яті)."""
    return ORDERS


@app.get("/")
def root():
    return {"status": "ok", "app": "AutoLowParts API"}
