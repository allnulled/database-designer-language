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
  "tables": {
    "Persona": {
      "columns": {
        "nombre": {
          "name": "nombre",
          "type": "String",
          "spec": {
            "not null": true,
            "unique": true
          }
        },
        "edad": {
          "name": "edad",
          "type": "Integer",
          "spec": {
            "default": "18"
          }
        },
        "nacimiento": {
          "name": "nacimiento",
          "type": "Date",
          "spec": {
            "null": true
          }
        },
        "domicilio": {
          "name": "domicilio",
          "type": "String",
          "spec": {
            "null": true
          }
        },
        "descripcion": {
          "name": "descripcion",
          "type": "String",
          "spec": {
            "default": true
          }
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
      }
    },
    "Perfil_en_empresa": {
      "columns": {
        "empresa": {
          "name": "empresa",
          "type": "Empresa",
          "multiplier": "1"
        }
      }
    },
    "Empresa": {
      "columns": {
        "nombre": {
          "name": "nombre",
          "type": "String"
        },
        "fecha_de_inicio": {
          "name": "fecha_de_inicio",
          "type": "Date"
        },
        "sector": {
          "name": "sector",
          "type": "String"
        },
        "industria": {
          "name": "industria",
          "type": "String"
        }
      }
    },
    "Producto": {
      "columns": {
        "modelo": {
          "name": "modelo",
          "type": "String"
        },
        "descripcion": {
          "name": "descripcion",
          "type": "String"
        },
        "precio_unitario": {
          "name": "precio_unitario",
          "type": "Float"
        },
        "moneda": {
          "name": "moneda",
          "type": "String",
          "spec": {
            "default": "Euro",
            "options": [
              "Euro",
              "Dólar"
            ]
          }
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
      }
    },
    "Factura": {
      "columns": {}
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
          "type": "Integer"
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
      }
    },
    "Venta": {
      "columns": {
        "procesos_de_venta": {
          "name": "procesos_de_venta",
          "type": "Proceso_de_venta",
          "multiplier": "N"
        }
      }
    },
    "Compra": {
      "columns": {}
    },
    "Proceso_de_venta": {
      "columns": {
        "detalles": {
          "name": "detalles",
          "type": "String"
        }
      }
    },
    "Proceso_de_compra": {
      "columns": {
        "detalles": {
          "name": "detalles",
          "type": "String",
          "spec": {
            "unique": true,
            "not null": true
          }
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
  ]
}
```