# database-designer-language

Lenguaje para diseñar bases de datos tipo SQL.

## Ejemplo

```
Persona {
  nombre = String { not null unique }
  edad = Integer { default 18 }
  nacimiento = Date { null }
  domicilio = String { null }
  descripcion = String { default ""}
}
Cliente {
  persona = Persona * 1 {}
  perfiles_en_empresa = Perfil_en_empresa * N {}
}
Perfil_en_empresa {
  empresa = Empresa * 1 {}
}
Empresa {
  nombre = String {}
  fecha_de_inicio = Date {}
  sector = String {}
  industria = String {}
}
Producto {
  modelo = String {}
  descripcion = String {}
  precio_unitario = Float {}
  moneda = String { default "Euro" options { "Euro" "Dólar" } }
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
  cantidad = Integer {}
}
Albaran {
  procesos_de_compra = Proceso_de_compra * N {}
}
Venta {
  procesos_de_venta = Proceso_de_venta * N {}
}
Compra {}
Proceso_de_venta {
  detalles = String {}
}
Proceso_de_compra {
  detalles = String { unique not null }
}
```

Devuelve:

```json
{
  "ast": {
    "Persona": {
      "nombre": {
        "column": "nombre",
        "tipo": "String",
        "especificaciones": {
          "not null": true,
          "unique": true
        }
      },
      "edad": {
        "column": "edad",
        "tipo": "Integer",
        "especificaciones": {
          "default": "18"
        }
      },
      "nacimiento": {
        "column": "nacimiento",
        "tipo": "Date",
        "especificaciones": {
          "null": true
        }
      },
      "domicilio": {
        "column": "domicilio",
        "tipo": "String",
        "especificaciones": {
          "null": true
        }
      },
      "descripcion": {
        "column": "descripcion",
        "tipo": "String",
        "especificaciones": {
          "default": true
        }
      }
    },
    "Cliente": {
      "persona": {
        "column": "persona",
        "tipo": "Persona",
        "multiplicador": "1"
      },
      "perfiles_en_empresa": {
        "column": "perfiles_en_empresa",
        "tipo": "Perfil_en_empresa",
        "multiplicador": "N"
      }
    },
    "Perfil_en_empresa": {
      "empresa": {
        "column": "empresa",
        "tipo": "Empresa",
        "multiplicador": "1"
      }
    },
    "Empresa": {
      "nombre": {
        "column": "nombre",
        "tipo": "String"
      },
      "fecha_de_inicio": {
        "column": "fecha_de_inicio",
        "tipo": "Date"
      },
      "sector": {
        "column": "sector",
        "tipo": "String"
      },
      "industria": {
        "column": "industria",
        "tipo": "String"
      }
    },
    "Producto": {
      "modelo": {
        "column": "modelo",
        "tipo": "String"
      },
      "descripcion": {
        "column": "descripcion",
        "tipo": "String"
      },
      "precio_unitario": {
        "column": "precio_unitario",
        "tipo": "Float"
      },
      "moneda": {
        "column": "moneda",
        "tipo": "String",
        "especificaciones": {
          "default": "Euro",
          "options": [
            "Euro",
            "Dólar"
          ]
        }
      }
    },
    "Proveedor": {
      "empresa": {
        "column": "empresa",
        "tipo": "Empresa",
        "multiplicador": "1"
      }
    },
    "Factura": {},
    "Pedido_de_compra": {
      "cliente": {
        "column": "cliente",
        "tipo": "Cliente",
        "multiplicador": "1"
      },
      "producto_de_pedido_de_compra": {
        "column": "producto_de_pedido_de_compra",
        "tipo": "Unidad_de_pedido_de_compra",
        "multiplicador": "N"
      }
    },
    "Unidad_de_pedido_de_compra": {
      "producto": {
        "column": "producto",
        "tipo": "Producto",
        "multiplicador": "1"
      },
      "cantidad": {
        "column": "cantidad",
        "tipo": "Integer"
      }
    },
    "Albaran": {
      "procesos_de_compra": {
        "column": "procesos_de_compra",
        "tipo": "Proceso_de_compra",
        "multiplicador": "N"
      }
    },
    "Venta": {
      "procesos_de_venta": {
        "column": "procesos_de_venta",
        "tipo": "Proceso_de_venta",
        "multiplicador": "N"
      }
    },
    "Compra": {},
    "Proceso_de_venta": {
      "detalles": {
        "column": "detalles",
        "tipo": "String"
      }
    },
    "Proceso_de_compra": {
      "detalles": {
        "column": "detalles",
        "tipo": "String",
        "especificaciones": {
          "unique": true,
          "not null": true
        }
      }
    }
  },
  "creationOrder": [
    "Proveedor",
    "Factura",
    "Pedido_de_compra",
    "Albaran",
    "Venta",
    "Compra",
    "Cliente",
    "Unidad_de_pedido_de_compra",
    "Proceso_de_compra",
    "Proceso_de_venta",
    "Persona",
    "Perfil_en_empresa",
    "Producto",
    "Empresa"
  ]
}
```