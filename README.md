# database-designer-language

Lenguaje para diseñar bases de datos tipo SQL.

## Ejemplo

```
Persona {
  nombre = VARCHAR(255) { not null unique }
  edad = INTEGER { default 18 }
  nacimiento = DATETIME { null }
  domicilio = VARCHAR(255) { null }
  descripcion = VARCHAR(255) { default ""}
}
Cliente {
  persona = Persona * 1 {}
  perfiles_en_empresa = Perfil_en_empresa * N {}
}
Perfil_en_empresa {
  empresa = Empresa * 1 {}
}
Empresa {
  nombre = VARCHAR(255) {}
  fecha_de_inicio = DATETIME {}
  sector = VARCHAR(255) {}
  industria = VARCHAR(255) {}
}
Producto {
  modelo = VARCHAR(255) {}
  descripcion = VARCHAR(255) {}
  precio_unitario = Float {}
  moneda = VARCHAR(255) { default "Euro" options { "Euro" "Dólar" } }
}
Proveedor {
  empresa = Empresa * 1 {}
}
Factura {}
Pedido_de_compra {
  cliente = Cliente * 1 {}
  producto_de_pedido_de_compra = Unidad_de_pedido_de_compra * N {}
}
Unidad_de_pedido_de_compra {
  producto = Producto * 1 {}
  cantidad = INTEGER {}
}
Albaran {
  procesos_de_compra = Proceso_de_compra * N {}
}
Venta {
  procesos_de_venta = Proceso_de_venta * N {}
}
Compra {}
Proceso_de_venta {
  detalles = VARCHAR(255) {}
}
Proceso_de_compra {
  detalles = VARCHAR(255) { unique not null }
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
            "default": true
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
        }
      },
      "relations": {
        "active": {
          "Persona": "1",
          "Perfil_en_empresa": "N"
        },
        "passive": {
          "Pedido_de_compra": "1"
        }
      }
    },
    "Perfil_en_empresa": {
      "columns": {
        "empresa": {
          "name": "empresa",
          "type": "Empresa",
          "multiplier": "1"
        }
      },
      "relations": {
        "active": {
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
          "type": "VARCHAR(255)"
        },
        "fecha_de_inicio": {
          "name": "fecha_de_inicio",
          "type": "DATETIME"
        },
        "sector": {
          "name": "sector",
          "type": "VARCHAR(255)"
        },
        "industria": {
          "name": "industria",
          "type": "VARCHAR(255)"
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
          "type": "VARCHAR(255)"
        },
        "descripcion": {
          "name": "descripcion",
          "type": "VARCHAR(255)"
        },
        "precio_unitario": {
          "name": "precio_unitario",
          "type": "FLOAT"
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
        }
      },
      "relations": {
        "active": {},
        "passive": {
          "Unidad_de_pedido_de_compra": "1"
        }
      }
    },
    "Proveedor": {
      "columns": {
        "empresa": {
          "name": "empresa",
          "type": "Empresa",
          "multiplier": "1"
        }
      },
      "relations": {
        "active": {
          "Empresa": "1"
        },
        "passive": {}
      }
    },
    "Factura": {
      "columns": {},
      "relations": {
        "active": {},
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
        }
      },
      "relations": {
        "active": {
          "Cliente": "1",
          "Unidad_de_pedido_de_compra": "N"
        },
        "passive": {}
      }
    },
    "Unidad_de_pedido_de_compra": {
      "columns": {
        "producto": {
          "name": "producto",
          "type": "Producto",
          "multiplier": "1"
        },
        "cantidad": {
          "name": "cantidad",
          "type": "INTEGER"
        }
      },
      "relations": {
        "active": {
          "Producto": "1"
        },
        "passive": {
          "Pedido_de_compra": "N"
        }
      }
    },
    "Albaran": {
      "columns": {
        "procesos_de_compra": {
          "name": "procesos_de_compra",
          "type": "Proceso_de_compra",
          "multiplier": "N"
        }
      },
      "relations": {
        "active": {
          "Proceso_de_compra": "N"
        },
        "passive": {}
      }
    },
    "Venta": {
      "columns": {
        "procesos_de_venta": {
          "name": "procesos_de_venta",
          "type": "Proceso_de_venta",
          "multiplier": "N"
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
      "columns": {},
      "relations": {
        "active": {},
        "passive": {}
      }
    },
    "Proceso_de_venta": {
      "columns": {
        "detalles": {
          "name": "detalles",
          "type": "VARCHAR(255)"
        }
      },
      "relations": {
        "active": {},
        "passive": {
          "Venta": "N"
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
        }
      },
      "relations": {
        "active": {},
        "passive": {
          "Albaran": "N"
        }
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
    "Albaran",
    "Venta",
    "Compra",
    "Proceso_de_venta",
    "Proceso_de_compra"
  ],
  "sql": [
    "CREATE TABLE Persona (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  nombre VARCHAR(255),\n  edad INTEGER,\n  nacimiento DATETIME,\n  domicilio VARCHAR(255),\n  descripcion VARCHAR(255)\n);",
    "CREATE TABLE Cliente (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  persona INTEGER REFERENCES Persona (id)\n);",
    "CREATE TABLE Perfil_en_empresa (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  empresa INTEGER REFERENCES Empresa (id)\n);",
    "CREATE TABLE Empresa (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  nombre VARCHAR(255),\n  fecha_de_inicio DATETIME,\n  sector VARCHAR(255),\n  industria VARCHAR(255)\n);",
    "CREATE TABLE Producto (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  modelo VARCHAR(255),\n  descripcion VARCHAR(255),\n  precio_unitario FLOAT,\n  moneda VARCHAR(255)\n);",
    "CREATE TABLE Proveedor (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  empresa INTEGER REFERENCES Empresa (id)\n);",
    "CREATE TABLE Factura (\n  id INTEGER PRIMARY KEY AUTOINCREMENT\n);",
    "CREATE TABLE Pedido_de_compra (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  cliente INTEGER REFERENCES Cliente (id)\n);",
    "CREATE TABLE Unidad_de_pedido_de_compra (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  producto INTEGER REFERENCES Producto (id),\n  cantidad INTEGER\n);",
    "CREATE TABLE Albaran (\n  id INTEGER PRIMARY KEY AUTOINCREMENT\n);",
    "CREATE TABLE Venta (\n  id INTEGER PRIMARY KEY AUTOINCREMENT\n);",
    "CREATE TABLE Compra (\n  id INTEGER PRIMARY KEY AUTOINCREMENT\n);",
    "CREATE TABLE Proceso_de_venta (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  detalles VARCHAR(255)\n);",
    "CREATE TABLE Proceso_de_compra (\n  id INTEGER PRIMARY KEY AUTOINCREMENT,\n  detalles VARCHAR(255)\n);",
    "CREATE TABLE x_Cliente_x_Perfil_en_empresa (  id INTEGER PRIMARY KEY AUTOINCREMENT,  id_Cliente INTEGER REFERENCES Perfil_en_empresa (id),  id_Perfil_en_empresa INTEGER REFERENCES Perfil_en_empresa (id))",
    "CREATE TABLE x_Pedido_de_compra_x_Unidad_de_pedido_de_compra (  id INTEGER PRIMARY KEY AUTOINCREMENT,  id_Pedido_de_compra INTEGER REFERENCES Unidad_de_pedido_de_compra (id),  id_Unidad_de_pedido_de_compra INTEGER REFERENCES Unidad_de_pedido_de_compra (id))",
    "CREATE TABLE x_Albaran_x_Proceso_de_compra (  id INTEGER PRIMARY KEY AUTOINCREMENT,  id_Albaran INTEGER REFERENCES Proceso_de_compra (id),  id_Proceso_de_compra INTEGER REFERENCES Proceso_de_compra (id))",
    "CREATE TABLE x_Venta_x_Proceso_de_venta (  id INTEGER PRIMARY KEY AUTOINCREMENT,  id_Venta INTEGER REFERENCES Proceso_de_venta (id),  id_Proceso_de_venta INTEGER REFERENCES Proceso_de_venta (id))"
  ]
}
```