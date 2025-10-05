{

    const tablesToObject = function(tables) {
        const obj = {};
        for(let index=0; index<tables.length; index++) {
          const table = tables[index];
          obj[table.table] = {
            columns: table.composition
          };
        }
        return obj;
    };

    const columnsToObject = function(columns) {
        const obj = {};
        for(let index=0; index<columns.length; index++) {
          const column = columns[index];
          obj[column.name] = column;
        }
        return obj;
    };

    const specificationsToObject = function(specifications) {
        const obj = {};
        for(let index=0; index<specifications.length; index++) {
          const specification = specifications[index];
          obj[specification.tipo] = typeof specification.arg !== "undefined" ? specification.arg : true;
        }
        return obj;
    };

    const getTableCreationOrder = function(schema) {
        const graph = {};
        const indegree = {};
        for (const tableName in schema) {
            graph[tableName] = [];
            indegree[tableName] = 0;
        }
        for (const [tableName, columns] of Object.entries(schema)) {
            for (const [colName, colDef] of Object.entries(columns)) {
            const tipo = colDef.tipo;
            if (tipo in schema && tipo !== tableName) {
                graph[tableName].push(tipo);
                indegree[tipo] = (indegree[tipo] || 0) + 1;
            }
            }
        }
        const queue = [];
        const order = [];
        for (const node in indegree) {
            if (indegree[node] === 0) queue.push(node);
        }
        while (queue.length) {
            const current = queue.shift();
            order.push(current);
            for (const neighbor of graph[current]) {
                indegree[neighbor]--;
                if (indegree[neighbor] === 0) {
                    queue.push(neighbor);
                }
            }
        }
        if (order.length !== Object.keys(schema).length) {
            throw new Error("Hay dependencias cíclicas entre tablas");
        }
        return order;
    };

    const KNOWN_TYPES = [
        "VARCHAR",
        "INTEGER",
        "FLOAT",
        "DATETIME",
    ];

    const isKnownType = function(columnType) {
        for(let index=0; index<KNOWN_TYPES.length; index++) {
        const knownType = KNOWN_TYPES[index];
            if(columnType.startsWith(knownType)) {
                return true;
            }
        }
        return false;
    }

    const getSqlScript = function(ast, creationOrder) {
        const sqlSentences = [];
        const sqlIntermediateTablesSentences = [];
        for(let indexTable=0; indexTable<creationOrder.length; indexTable++) {
          const tableId = creationOrder[indexTable];
          const tableMetadata = ast.tables[tableId];
          let sql = "";
          sql += `CREATE TABLE ${tableId} (\n`;
          sql += `  id INTEGER PRIMARY KEY AUTOINCREMENT`;
          const columnIds = Object.keys(tableMetadata.columns);
          Iterating_columns:
          for(let indexColumn=0; indexColumn<columnIds.length; indexColumn++) {
            const columnId = columnIds[indexColumn];
            const columnMetadata = tableMetadata.columns[columnId];
            const columnType = columnMetadata.type;
            if(isKnownType(columnType)) {
                sql += `,\n  ${columnId} ${columnType}`;
                for(let prop in columnMetadata.spec) {
                    const val = columnMetadata.spec[prop];
                    if(prop === "null") {
                        sql += " NULL";
                    } else if(prop === "not null") {
                        sql += " NOT NULL";
                    } else if(prop === "unique") {
                        sql += " UNIQUE";
                    } else if(prop === "default") {
                        sql += " DEFAULT " + JSON.stringify(val);
                    }
                }
            } else if(columnMetadata.multiplier === "1") {
                sql += `,\n  ${columnId} INTEGER REFERENCES ${columnType} (id)`;
            } else if(columnMetadata.multiplier === "N") {
                let sqlIntermediate = `CREATE TABLE x_${tableId}_x_${columnType} (`;
                sqlIntermediate += `  id INTEGER PRIMARY KEY AUTOINCREMENT,`;
                sqlIntermediate += `  id_${tableId} INTEGER REFERENCES ${columnType} (id),`;
                sqlIntermediate += `  id_${columnType} INTEGER REFERENCES ${columnType} (id)`;
                sqlIntermediate += `)`;
                sqlIntermediateTablesSentences.push(sqlIntermediate);
            }
          }
          sql += `\n);`;
          sqlSentences.push(sql);
        }
        return sqlSentences.concat(sqlIntermediateTablesSentences);
    };

    const expandTablesData = function(ast) {
        const tableIds = Object.keys(ast.tables);
        for(let indexTable1=0; indexTable1<tableIds.length; indexTable1++) {
            const tableId1 = tableIds[indexTable1];
            ast.tables[tableId1].relations = {
                active: {},
                passive: {},
            };
            const columnIds1 = Object.keys(ast.tables[tableId1].columns);
            Iterating_columns_1:
            for(let indexColumns1=0; indexColumns1<columnIds1.length; indexColumns1++) {
                const columnId1 = columnIds1[indexColumns1];
                const columnMetadata = ast.tables[tableId1].columns[columnId1];
                const columnType = columnMetadata.type;
                if(isKnownType(columnType)) {
                    continue Iterating_columns_1;
                }
                ast.tables[tableId1].relations.active[columnType] = columnMetadata.multiplier;
            }
            for(let indexTable2=0; indexTable2<tableIds.length; indexTable2++) {
                const tableId2 = tableIds[indexTable2];
                const columnIds2 = Object.keys(ast.tables[tableId2].columns);
                for(let indexColumns2=0; indexColumns2<columnIds2.length; indexColumns2++) {
                    const columnId2 = columnIds2[indexColumns2];
                    const columnMetadata = ast.tables[tableId2].columns[columnId2];
                    const matchesTableRef = (columnMetadata.type === tableId1);
                    if(matchesTableRef) {
                        ast.tables[tableId1].relations.passive[tableId2] = columnMetadata.multiplier;
                    }
                }
            }
        }
    };

    const getOutputFrom = function(astList) {
        const tables = tablesToObject(astList);
        const creationOrder = getTableCreationOrder(tables);
        const ast = { tables, creationOrder };
        const sql = getSqlScript(ast, creationOrder);
        expandTablesData(ast);
        return { ...ast, sql };
    };

}

Language =
    token1:(_*)
    tables:Table_definition*
    token2:(_*)
        { return getOutputFrom(tables); }

Table_definition =
    token1:(_*)
    table:Table_name
    composition:Table_composition
        { return { table, composition } }

Table_name = Sql_word

Table_composition = _* "{" _* col:Column_definition* _* "}" { return columnsToObject(col) }

Column_definition =
    token1:(_*)
    column:Sql_word
    token2:(_* "=" _*)
    tipo:Column_type
        { return { name: column.trim(), ...tipo } }

Column_type =
    token1:(_*)
    tipo:Sql_word_for_column_type
    multiplicador:Column_multiplier?
    especificaciones:Column_specifications?
        { return { type: tipo, multiplier: multiplicador || undefined, spec: Object.keys(especificaciones).length ? especificaciones : undefined } }
    
Sql_word_for_column_type = 
    word:Sql_word
    token1:(_*)
    parenthesys:Sql_type_length?
        { return text().trim() }

Sql_type_length = "(" (!(")"/EOL) .)+ ")" { return text() }

Column_multiplier = 
    token1:(_* "*" _*)
    multiplicador:("1" / "N")
        { return multiplicador }

Column_specifications = 
    token1:(_* "{" _* )
    especificables:Column_specification*
    token2:(_* "}" )
        { return specificationsToObject(especificables) }

Column_specification = 
    token1:(_*)
    specification:(
        Column_clause_for_not_null /
        Column_clause_for_null /
        Column_clause_for_unique /
        Column_clause_for_default /
        Column_clause_for_options
    )
        { return specification }

Column_clause_for_not_null = "not null" { return { tipo: "not null", arg: true } }
Column_clause_for_null = "null" { return { tipo: "null", arg: true } }
Column_clause_for_unique = "unique" { return { tipo: "unique", arg: true } }

Column_clause_for_default = 
    token1:("default" _+)
    val:(Text_unit / Number_unit)
        { return { tipo: "default", arg: val } }

Column_clause_for_options = 
    token1:("options" _* "{" _*)
    options:Column_clause_for_option*
    token2:(_* "}")
        { return { tipo: "options", arg: options } }

Column_clause_for_option = _* t:Text_unit { return t }

Text_unit = '"' (!('"') .)* '"' { return JSON.parse(text()) }

Number_unit = [0-9]+ ("." [0-9]+)? { return text().trim() }

Sql_word = [A-Za-z_] [A-Za-z_$]* { return text().trim() }

EOL = ___

_ = __ / ___
__ = "\t" / " "
___ = "\r\n" / "\r" / "\n"