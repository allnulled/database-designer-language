{

    const tablesToObject = function(tables) {
        const obj = {};
        for(let index=0; index<tables.length; index++) {
          const table = tables[index];
          obj[table.table] = table.composition;
        }
        return obj;
    };

    const columnsToObject = function(columns) {
        const obj = {};
        for(let index=0; index<columns.length; index++) {
          const column = columns[index];
          obj[column.column] = column;
        }
        return obj;
    };

    const specificationsToObject = function(specifications) {
        const obj = {};
        for(let index=0; index<specifications.length; index++) {
          const specification = specifications[index];
          obj[specification.tipo] = specification.arg || true;
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

    const getOutputFrom = function(astList) {
        const ast = tablesToObject(astList);
        const creationOrder = getTableCreationOrder(ast);
        return { ast, creationOrder };
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
        { return { column, ...tipo } }

Column_type =
    token1:(_*)
    tipo:Sql_word
    multiplicador:Column_multiplier?
    especificaciones:Column_specifications?
        { return { tipo, multiplicador: multiplicador || undefined, especificaciones: Object.keys(especificaciones).length ? especificaciones : undefined } }
    
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

Column_clause_for_not_null = "not null" { return { tipo: "not null" } }
Column_clause_for_null = "null" { return { tipo: "null" } }
Column_clause_for_unique = "unique" { return { tipo: "unique" } }

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

Number_unit = [0-9]+ ("." [0-9]+)? { return text() }

Sql_word = [A-Za-z_] [A-Za-z_$]* { return text() }

_ = __ / ___
__ = "\t" / " "
___ = "\r\n" / "\r" / "\n"