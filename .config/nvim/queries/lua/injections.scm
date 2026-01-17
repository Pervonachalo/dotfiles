; extends

; Ищем конструкцию conky.text = [[ ... ]]
((assignment_statement
    (variable_list
      (dot_index_expression
        field: (identifier) @_field_name))
    (expression_list
      (string
        content: (string_content) @injection.content)))
  (#eq? @_field_name "text")
  ; (#set! injection.language "bash"))
  (#set! injection.language "perl"))

; Ищем конструкцию text = [[ ... ]] (если внутри таблицы)
((field
    name: (identifier) @_field_name
    value: (string
      content: (string_content) @injection.content))
  (#eq? @_field_name "text")
  ; (#set! injection.language "bash"))
  (#set! injection.language "perl"))
