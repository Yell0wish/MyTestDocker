<template>
  <el-table
    :data="tableData"
    style="width: 100%">
    <el-table-column
      prop="date"
      label="发布日期"
      width="180">
    </el-table-column>
    <el-table-column
      prop="title"
      label="标题">
    </el-table-column>
    <el-table-column
      prop="name"
      label="发布人">
    </el-table-column>
  </el-table>
</template>

<script>
export default {
  data() {
    return {
      tableData: [{
        date: '2016-05-02',
        name: '王小虎',
        title: '上海市普陀区金沙江路 1518 弄'
      }, {
        date: '2016-05-04',
        name: '王小虎',
        title: '上海市普陀区金沙江路 1517 弄'
      }, {
        date: '2016-05-01',
        name: '王小虎',
        title: '上海市普陀区金沙江路 1519 弄'
      }, {
        date: '2016-05-03',
        name: '王小虎',
        title: '上海市普陀区金沙江路 1516 弄'
      }]
    }
  }
}
</script>

<style scoped lang="scss">

</style>
