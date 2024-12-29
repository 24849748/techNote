// https://squidfunk.github.io/mkdocs-material/reference/data-tables/
// 表格排序功能
document$.subscribe(function () {
  var tables = document.querySelectorAll("article table:not([class])");
  tables.forEach(function (table) {
    new Tablesort(table);
  });
});
