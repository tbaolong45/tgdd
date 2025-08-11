import os
from typing import Literal
from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
# from .routes import MenuItemsRoute
from database import Base, engine
from routes import (
    UsersRoute,
    BrandsRoute,
    CategoriesRoute,
    OrderItemsRoute,
    OrdersRoute,
    PaymentsRoute,
    ProductsRoute,
    ReviewsRoute
)
import logging
from contextlib import asynccontextmanager

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="FastAPI with SQLite",
    description="This is a very fancy project, with auto docs for the API",
    version="0.1.0",
)


# Create the tables
async def init_db():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


# Lifespan event handler
@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_db()
    yield
    # Add any cleanup code here if needed


app = FastAPI(lifespan=lifespan)


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
    allow_credentials=True,
)


class FilterParams(BaseModel):
    limit: int = Field(100, gt=0, le=100)
    offset: int = Field(0, ge=0)
    order_by: Literal["created_at", "updated_at"] = "created_at"
    tags: list[str] = []


app.include_router(UsersRoute.router, prefix="/api/v1", tags=["Users"])
app.include_router(PaymentsRoute.router, prefix="/api/v1", tags=["Payments"])
app.include_router(CategoriesRoute.router, prefix="/api/v1", tags=["Categories"])
app.include_router(OrderItemsRoute.router, prefix="/api/v1", tags=["Order Items"])
app.include_router(OrdersRoute.router, prefix="/api/v1", tags=["Orders"])
app.include_router(ReviewsRoute.router, prefix="/api/v1", tags=["Reviews"])
app.include_router(BrandsRoute.router, prefix="/api/v1", tags=["Brands"])
app.include_router(ProductsRoute.router, prefix="/api/v1", tags=["Products"])