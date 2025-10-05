# database-designer-language

Lenguaje para diseñar bases de datos tipo SQL.

## Ejemplo

```
Persona {
  nombre = VARCHAR(255) { not null unique }
  edad = INTEGER { default 18 }
  nacimiento = DATETIME { null }
  domicilio = VARCHAR(255) { null }
  descripcion = VARCHAR(255) { default "" }
  email = VARCHAR(255) { unique null {{ { "formtype": "email" } }}
  telefono = VARCHAR(20) { null extra {{ { "formtype": "telephone" } }} }
  genero = VARCHAR(20) { null options { "Masculino" "Femenino" "Otro" } }
}

Cliente {
  persona = Persona * 1 {}
  perfiles_en_empresa = Perfil_en_empresa * N {}
  fecha_registro = DATETIME { default CURRENT_TIMESTAMP }
  estado = VARCHAR(20) { default "Activo" options { "Activo" "Inactivo" "Suspendido" } }
}

Perfil_en_empresa {
  cliente = Cliente * 1 {}
  empresa = Empresa * 1 {}
  cargo = VARCHAR(255) { null }
  fecha_ingreso = DATETIME { null }
  activo = BOOLEAN { default true }
}

Empresa {
  nombre = VARCHAR(255) { not null unique }
  fecha_de_inicio = DATETIME { null }
  sector = VARCHAR(255) { null }
  industria = VARCHAR(255) { null }
  direccion_fiscal = VARCHAR(255) { null }
  pais = VARCHAR(100) { null }
  email_contacto = VARCHAR(255) { null }
}

Producto {
  modelo = VARCHAR(255) { not null unique }
  descripcion = VARCHAR(255) { null }
  precio_unitario = FLOAT { not null }
  moneda = VARCHAR(255) { default "Euro" options { "Euro" "Dólar" } }
  stock_actual = INTEGER { default 0 }
  sku = VARCHAR(100) { unique null }
}

Proveedor {
  empresa = Empresa * 1 {}
  imagen = VARCHAR(255) { null }
  descripcion = VARCHAR(255) { null }
  telefono_contacto = VARCHAR(20) { null }
  email_contacto = VARCHAR(255) { null }
}

Factura {
  numero = VARCHAR(50) { not null unique }
  cliente = Cliente * 1 {}
  fecha_emision = DATETIME { default CURRENT_TIMESTAMP }
  monto_total = FLOAT { not null }
  moneda = VARCHAR(20) { default "Euro" options { "Euro" "Dólar" } }
  estado = VARCHAR(20) { default "Pendiente" options { "Pendiente" "Pagada" "Cancelada" } }
}

Pedido_de_compra {
  cliente = Cliente * 1 {}
  producto_de_pedido_de_compra = Unidad_de_pedido_de_compra * N {}
  fecha_pedido = DATETIME { default CURRENT_TIMESTAMP }
  estado = VARCHAR(20) { default "Solicitado" options { "Solicitado" "Procesado" "Enviado" "Cancelado" } }
}

Unidad_de_pedido_de_compra {
  pedido = Pedido_de_compra * 1 {}
  producto = Producto * 1 {}
  cantidad = INTEGER { not null }
  precio_unitario = FLOAT { null }
}

Proceso_de_compra {
  detalles = VARCHAR(255) { unique not null }
  producto = Producto * 1 {}
  cantidad = INTEGER { not null }
  precio_unitario = FLOAT { not null }
}

Albaran {
  procesos_de_compra = Proceso_de_compra * N {}
  fecha_entrega = DATETIME { default CURRENT_TIMESTAMP }
  numero_albaran = VARCHAR(50) { not null unique }
  observaciones = VARCHAR(255) { null }
}

Proceso_de_venta {
  detalles = VARCHAR(255) { not null }
  producto = Producto * 1 {}
  cantidad = INTEGER { not null }
  precio_unitario = FLOAT { not null }
}

Venta {
  procesos_de_venta = Proceso_de_venta * N {}
  fecha_venta = DATETIME { default CURRENT_TIMESTAMP }
  total = FLOAT { not null }
  moneda = VARCHAR(20) { default "Euro" }
}

Compra {
  proveedor = Proveedor * 1 {}
  fecha_compra = DATETIME { default CURRENT_TIMESTAMP }
  total = FLOAT { not null }
  moneda = VARCHAR(20) { default "Euro" }
  estado = VARCHAR(20) { default "Pendiente" options { "Pendiente" "Completada" "Cancelada" } }
}
```

Devuelve:

```json
{
  "tables": {
    "Persona": {
      "columns": {
        "nombre": {
          "name": "nombre",
          "type": "VARCHAR(255)",
          "spec": {
            "not null": true,
            "unique": true
          }
        },
        "edad": {
          "name": "edad",
          "type": "INTEGER",
          "spec": {
            "default": "18"
          }
        },
        "nacimiento": {
          "name": "nacimiento",
          "type": "DATETIME",
          "spec": {
            "null": true
          }
        },
        "domicilio": {
          "name": "domicilio",
          "type": "VARCHAR(255)",
          "spec": {
            "null": true
          }
        },
        "descripcion": {
          "name": "descripcion",
          "type": "VARCHAR(255)",
          "spec": {
            "default": ""
          }
        },
        "email": {
          "name": "email",
          "type": "VARCHAR(255)",
          "spec": {
            "unique": true,
            "null": true
          }
        },
        "telefono": {
          "name": "telefono",
          "type": "VARCHAR(20)",
          "spec": {
            "null": true,
            "extra": {
              "formtype": "telephone"
            }
          }
        },
        "genero": {
          "name": "genero",
          "type": "VARCHAR(20)",
          "spec": {
            "null": true,
            "options": [
              "Masculino",
              "Femenino",
              "Otro"
            ]
          }
        }
      },
      "relations": {
        "active": {},
        "passive": {
          "Cliente": "1"
        }
      }
    },
    "Cliente": {
      "columns": {
        "persona": {
          "name": "persona",
          "type": "Persona",
          "multiplier": "1"
        },
        "perfiles_en_empresa": {
          "name": "perfiles_en_empresa",
          "type": "Perfil_en_empresa",
          "multiplier": "N"
        },
        "fecha_registro": {
          "name": "fecha_registro",
          "type": "DATETIME",
          "spec": {
            "default": "CURRENT_TIMESTAMP"
          }
        },
        "estado": {
          "name": "estado",
          "type": "VARCHAR(20)",
          "spec": {
            "default": "Activo",
            "options": [
              "Activo",
              "Inactivo",
              "Suspendido"
            ]
          }
        }
      },
      "relations": {
        "active": {
          "Persona": "1",
          "Perfil_en_empresa": "N"
        },
        "passive": {
          "Perfil_en_empresa": "1",
          "Factura": "1",
          "Pedido_de_compra": "1"
        }
      }
    },
    "Perfil_en_empresa": {
      "columns": {
        "cliente": {
          "name": "cliente",
          "type": "Cliente",
          "multiplier": "1"
        },
        "empresa": {
          "name": "empresa",
          "type": "Empresa",
          "multiplier": "1"
        },
        "cargo": {
          "name": "cargo",
          "type": "VARCHAR(255)",
          "spec": {
            "null": true
          }
        },
        "fecha_ingreso": {
          "name": "fecha_ingreso",
          "type": "DATETIME",
          "spec": {
            "null": true
          }
        },
        "activo": {
          "name": "activo",
          "type": "BOOLEAN",
          "spec": {
            "default": "true"
          }
        }
      },
      "relations": {
        "active": {
          "Cliente": "1",
          "Empresa": "1"
        },
        "passive": {
          "Cliente": "N"
        }
      }
    },
    "Empresa": {
      "columns": {
        "nombre": {
          "name": "nombre",
          "type": "VARCHAR(255)",
          "spec": {
            "not null": true,
            "unique": true
          }
        },
        "fecha_de_inicio": {
          "name": "fecha_de_inicio",
          "type": "DATETIME",
          "spec": {
            "null": true
          }
        },
        "sector": {
          "name": "sector",
          "type": "VARCHAR(255)",
          "spec": {
            "null": true
          }
        },
        "industria": {
          "name": "industria",
          "type": "VARCHAR(255)",
          "spec": {
            "null": true
          }
        },
        "direccion_fiscal": {
          "name": "direccion_fiscal",
          "type": "VARCHAR(255)",
          "spec": {
            "null": true
          }
        },
        "pais": {
          "name": "pais",
          "type": "VARCHAR(100)",
          "spec": {
            "null": true
          }
        },
        "email_contacto": {
          "name": "email_contacto",
          "type": "VARCHAR(255)",
          "spec": {
            "null": true
          }
        }
      },
      "relations": {
        "active": {},
        "passive": {
          "Perfil_en_empresa": "1",
          "Proveedor": "1"
        }
      }
    },
    "Producto": {
      "columns": {
        "modelo": {
          "name": "modelo",
          "type": "VARCHAR(255)",
          "spec": {
            "not null": true,
            "unique": true
          }
        },
        "descripcion": {
          "name": "descripcion",
          "type": "VARCHAR(255)",
          "spec": {
            "null": true
          }
        },
        "precio_unitario": {
          "name": "precio_unitario",
          "type": "FLOAT",
          "spec": {
            "not null": true
          }
        },
        "moneda": {
          "name": "moneda",
          "type": "VARCHAR(255)",
          "spec": {
            "default": "Euro",
            "options": [
              "Euro",
              "Dólar"
            ]
          }
        },
        "stock_actual": {
          "name": "stock_actual",
          "type": "INTEGER",
          "spec": {
            "default": "0"
          }
        },
        "sku": {
          "name": "sku",
          "type": "VARCHAR(100)",
          "spec": {
            "unique": true,
            "null": true
          }
        }
      },
      "relations": {
        "active": {},
        "passive": {
          "Unidad_de_pedido_de_compra": "1",
          "Proceso_de_compra": "1",
          "Proceso_de_venta": "1"
        }
      }
    },
    "Proveedor": {
      "columns": {
        "empresa": {
          "name": "empresa",
          "type": "Empresa",
          "multiplier": "1"
        },
        "imagen": {
          "name": "imagen",
          "type": "VARCHAR(255)",
          "spec": {
            "null": true
          }
        },
        "descripcion": {
          "name": "descripcion",
          "type": "VARCHAR(255)",
          "spec": {
            "null": true
          }
        },
        "telefono_contacto": {
          "name": "telefono_contacto",
          "type": "VARCHAR(20)",
          "spec": {
            "null": true
          }
        },
        "email_contacto": {
          "name": "email_contacto",
          "type": "VARCHAR(255)",
          "spec": {
            "null": true
          }
        }
      },
      "relations": {
        "active": {
          "Empresa": "1"
        },
        "passive": {
          "Compra": "1"
        }
      }
    },
    "Factura": {
      "columns": {
        "numero": {
          "name": "numero",
          "type": "VARCHAR(50)",
          "spec": {
            "not null": true,
            "unique": true
          }
        },
        "cliente": {
          "name": "cliente",
          "type": "Cliente",
          "multiplier": "1"
        },
        "fecha_emision": {
          "name": "fecha_emision",
          "type": "DATETIME",
          "spec": {
            "default": "CURRENT_TIMESTAMP"
          }
        },
        "monto_total": {
          "name": "monto_total",
          "type": "FLOAT",
          "spec": {
            "not null": true
          }
        },
        "moneda": {
          "name": "moneda",
          "type": "VARCHAR(20)",
          "spec": {
            "default": "Euro",
            "options": [
              "Euro",
              "Dólar"
            ]
          }
        },
        "estado": {
          "name": "estado",
          "type": "VARCHAR(20)",
          "spec": {
            "default": "Pendiente",
            "options": [
              "Pendiente",
              "Pagada",
              "Cancelada"
            ]
          }
        }
      },
      "relations": {
        "active": {
          "Cliente": "1"
        },
        "passive": {}
      }
    },
    "Pedido_de_compra": {
      "columns": {
        "cliente": {
          "name": "cliente",
          "type": "Cliente",
          "multiplier": "1"
        },
        "producto_de_pedido_de_compra": {
          "name": "producto_de_pedido_de_compra",
          "type": "Unidad_de_pedido_de_compra",
          "multiplier": "N"
        },
        "fecha_pedido": {
          "name": "fecha_pedido",
          "type": "DATETIME",
          "spec": {
            "default": "CURRENT_TIMESTAMP"
          }
        },
        "estado": {
          "name": "estado",
          "type": "VARCHAR(20)",
          "spec": {
            "default": "Solicitado",
            "options": [
              "Solicitado",
              "Procesado",
              "Enviado",
              "Cancelado"
            ]
          }
        }
      },
      "relations": {
        "active": {
          "Cliente": "1",
          "Unidad_de_pedido_de_compra": "N"
        },
        "passive": {
          "Unidad_de_pedido_de_compra": "1"
        }
      }
    },
    "Unidad_de_pedido_de_compra": {
      "columns": {
        "pedido": {
          "name": "pedido",
          "type": "Pedido_de_compra",
          "multiplier": "1"
        },
        "producto": {
          "name": "producto",
          "type": "Producto",
          "multiplier": "1"
        },
        "cantidad": {
          "name": "cantidad",
          "type": "INTEGER",
          "spec": {
            "not null": true
          }
        },
        "precio_unitario": {
          "name": "precio_unitario",
          "type": "FLOAT",
          "spec": {
            "null": true
          }
        }
      },
      "relations": {
        "active": {
          "Pedido_de_compra": "1",
          "Producto": "1"
        },
        "passive": {
          "Pedido_de_compra": "N"
        }
      }
    },
    "Proceso_de_compra": {
      "columns": {
        "detalles": {
          "name": "detalles",
          "type": "VARCHAR(255)",
          "spec": {
            "unique": true,
            "not null": true
          }
        },
        "producto": {
          "name": "producto",
          "type": "Producto",
          "multiplier": "1"
        },
        "cantidad": {
          "name": "cantidad",
          "type": "INTEGER",
          "spec": {
            "not null": true
          }
        },
        "precio_unitario": {
          "name": "precio_unitario",
          "type": "FLOAT",
          "spec": {
            "not null": true
          }
        }
      },
      "relations": {
        "active": {
          "Producto": "1"
        },
        "passive": {
          "Albaran": "N"
        }
      }
    },
    "Albaran": {
      "columns": {
        "procesos_de_compra": {
          "name": "procesos_de_compra",
          "type": "Proceso_de_compra",
          "multiplier": "N"
        },
        "fecha_entrega": {
          "name": "fecha_entrega",
          "type": "DATETIME",
          "spec": {
            "default": "CURRENT_TIMESTAMP"
          }
        },
        "numero_albaran": {
          "name": "numero_albaran",
          "type": "VARCHAR(50)",
          "spec": {
            "not null": true,
            "unique": true
          }
        },
        "observaciones": {
          "name": "observaciones",
          "type": "VARCHAR(255)",
          "spec": {
            "null": true
          }
        }
      },
      "relations": {
        "active": {
          "Proceso_de_compra": "N"
        },
        "passive": {}
      }
    },
    "Proceso_de_venta": {
      "columns": {
        "detalles": {
          "name": "detalles",
          "type": "VARCHAR(255)",
          "spec": {
            "not null": true
          }
        },
        "producto": {
          "name": "producto",
          "type": "Producto",
          "multiplier": "1"
        },
        "cantidad": {
          "name": "cantidad",
          "type": "INTEGER",
          "spec": {
            "not null": true
          }
        },
        "precio_unitario": {
          "name": "precio_unitario",
          "type": "FLOAT",
          "spec": {
            "not null": true
          }
        }
      },
      "relations": {
        "active": {
          "Producto": "1"
        },
        "passive": {
          "Venta": "N"
        }
      }
    },
    "Venta": {
      "columns": {
        "procesos_de_venta": {
          "name": "procesos_de_venta",
          "type": "Proceso_de_venta",
          "multiplier": "N"
        },
        "fecha_venta": {
          "name": "fecha_venta",
          "type": "DATETIME",
          "spec": {
            "default": "CURRENT_TIMESTAMP"
          }
        },
        "total": {
          "name": "total",
          "type": "FLOAT",
          "spec": {
            "not null": true
          }
        },
        "moneda": {
          "name": "moneda",
          "type": "VARCHAR(20)",
          "spec": {
            "default": "Euro"
          }
        }
      },
      "relations": {
        "active": {
          "Proceso_de_venta": "N"
        },
        "passive": {}
      }
    },
    "Compra": {
      "columns": {
        "proveedor": {
          "name": "proveedor",
          "type": "Proveedor",
          "multiplier": "1"
        },
        "fecha_compra": {
          "name": "fecha_compra",
          "type": "DATETIME",
          "spec": {
            "default": "CURRENT_TIMESTAMP"
          }
        },
        "total": {
          "name": "total",
          "type": "FLOAT",
          "spec": {
            "not null": true
          }
        },
        "moneda": {
          "name": "moneda",
          "type": "VARCHAR(20)",
          "spec": {
            "default": "Euro"
          }
        },
        "estado": {
          "name": "estado",
          "type": "VARCHAR(20)",
          "spec": {
            "default": "Pendiente",
            "options": [
              "Pendiente",
              "Completada",
              "Cancelada"
            ]
          }
        }
      },
      "relations": {
        "active": {
          "Proveedor": "1"
        },
        "passive": {}
      }
    }
  },
  "creationOrder": [
    "Persona",
    "Cliente",
    "Perfil_en_empresa",
    "Empresa",
    "Producto",
    "Proveedor",
    "Factura",
    "Pedido_de_compra",
    "Unidad_de_pedido_de_compra",
    "Proceso_de_compra",
    "Albaran",
    "Proceso_de_venta",
    "Venta",
    "Compra"
  ],
  "sql": [
    "CREATE TABLE Persona (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  nombre VARCHAR(255) NOT NULL UNIQUE,\n  edad INTEGER DEFAULT \"18\",\n  nacimiento DATETIME NULL,\n  domicilio VARCHAR(255) NULL,\n  descripcion VARCHAR(255) DEFAULT \"\",\n  email VARCHAR(255) UNIQUE NULL,\n  telefono VARCHAR(20) NULL,\n  genero VARCHAR(20) NULL\n);",
    "CREATE TABLE Cliente (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  persona INTEGER REFERENCES Persona (id),\n  fecha_registro DATETIME DEFAULT \"CURRENT_TIMESTAMP\",\n  estado VARCHAR(20) DEFAULT \"Activo\"\n);",
    "CREATE TABLE Perfil_en_empresa (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  cliente INTEGER REFERENCES Cliente (id),\n  empresa INTEGER REFERENCES Empresa (id),\n  cargo VARCHAR(255) NULL,\n  fecha_ingreso DATETIME NULL\n);",
    "CREATE TABLE Empresa (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  nombre VARCHAR(255) NOT NULL UNIQUE,\n  fecha_de_inicio DATETIME NULL,\n  sector VARCHAR(255) NULL,\n  industria VARCHAR(255) NULL,\n  direccion_fiscal VARCHAR(255) NULL,\n  pais VARCHAR(100) NULL,\n  email_contacto VARCHAR(255) NULL\n);",
    "CREATE TABLE Producto (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  modelo VARCHAR(255) NOT NULL UNIQUE,\n  descripcion VARCHAR(255) NULL,\n  precio_unitario FLOAT NOT NULL,\n  moneda VARCHAR(255) DEFAULT \"Euro\",\n  stock_actual INTEGER DEFAULT \"0\",\n  sku VARCHAR(100) UNIQUE NULL\n);",
    "CREATE TABLE Proveedor (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  empresa INTEGER REFERENCES Empresa (id),\n  imagen VARCHAR(255) NULL,\n  descripcion VARCHAR(255) NULL,\n  telefono_contacto VARCHAR(20) NULL,\n  email_contacto VARCHAR(255) NULL\n);",
    "CREATE TABLE Factura (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  numero VARCHAR(50) NOT NULL UNIQUE,\n  cliente INTEGER REFERENCES Cliente (id),\n  fecha_emision DATETIME DEFAULT \"CURRENT_TIMESTAMP\",\n  monto_total FLOAT NOT NULL,\n  moneda VARCHAR(20) DEFAULT \"Euro\",\n  estado VARCHAR(20) DEFAULT \"Pendiente\"\n);",
    "CREATE TABLE Pedido_de_compra (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  cliente INTEGER REFERENCES Cliente (id),\n  fecha_pedido DATETIME DEFAULT \"CURRENT_TIMESTAMP\",\n  estado VARCHAR(20) DEFAULT \"Solicitado\"\n);",
    "CREATE TABLE Unidad_de_pedido_de_compra (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  pedido INTEGER REFERENCES Pedido_de_compra (id),\n  producto INTEGER REFERENCES Producto (id),\n  cantidad INTEGER NOT NULL,\n  precio_unitario FLOAT NULL\n);",
    "CREATE TABLE Proceso_de_compra (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  detalles VARCHAR(255) UNIQUE NOT NULL,\n  producto INTEGER REFERENCES Producto (id),\n  cantidad INTEGER NOT NULL,\n  precio_unitario FLOAT NOT NULL\n);",
    "CREATE TABLE Albaran (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  fecha_entrega DATETIME DEFAULT \"CURRENT_TIMESTAMP\",\n  numero_albaran VARCHAR(50) NOT NULL UNIQUE,\n  observaciones VARCHAR(255) NULL\n);",
    "CREATE TABLE Proceso_de_venta (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  detalles VARCHAR(255) NOT NULL,\n  producto INTEGER REFERENCES Producto (id),\n  cantidad INTEGER NOT NULL,\n  precio_unitario FLOAT NOT NULL\n);",
    "CREATE TABLE Venta (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  fecha_venta DATETIME DEFAULT \"CURRENT_TIMESTAMP\",\n  total FLOAT NOT NULL,\n  moneda VARCHAR(20) DEFAULT \"Euro\"\n);",
    "CREATE TABLE Compra (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  proveedor INTEGER REFERENCES Proveedor (id),\n  fecha_compra DATETIME DEFAULT \"CURRENT_TIMESTAMP\",\n  total FLOAT NOT NULL,\n  moneda VARCHAR(20) DEFAULT \"Euro\",\n  estado VARCHAR(20) DEFAULT \"Pendiente\"\n);",
    "CREATE TABLE x_Cliente_x_Perfil_en_empresa (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  id_Cliente INTEGER REFERENCES Perfil_en_empresa (id),\n  id_Perfil_en_empresa INTEGER REFERENCES Perfil_en_empresa (id)\n);",
    "CREATE TABLE x_Pedido_de_compra_x_Unidad_de_pedido_de_compra (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  id_Pedido_de_compra INTEGER REFERENCES Unidad_de_pedido_de_compra (id),\n  id_Unidad_de_pedido_de_compra INTEGER REFERENCES Unidad_de_pedido_de_compra (id)\n);",
    "CREATE TABLE x_Albaran_x_Proceso_de_compra (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  id_Albaran INTEGER REFERENCES Proceso_de_compra (id),\n  id_Proceso_de_compra INTEGER REFERENCES Proceso_de_compra (id)\n);",
    "CREATE TABLE x_Venta_x_Proceso_de_venta (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  id_Venta INTEGER REFERENCES Proceso_de_venta (id),\n  id_Proceso_de_venta INTEGER REFERENCES Proceso_de_venta (id)\n);"
  ]
}
```