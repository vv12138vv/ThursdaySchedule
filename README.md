
# ThursdaySechdule


## Structure
- AppScope
    - app.json5：app 的全局配置文件
- entry/src
    - ets:代码目录
        - constants：一些常量的定义
        - entryaAbility：app 入口
        - models：数据抽象类
        - pages：页面
        - utils：工具类
        - viemodels：存放 viewmodel ，参考 mvvm 模型
        - views：页面中的小组件
    - resources:静态资源目录
        - base
            - element
                - string.json：app 中字符串的英文版
                - color.json：一些颜色定义
            - media：存放图标，视频，音乐等资源
            - profile：存放自定义配置
                - main_pages.json：存放页面
        - en_US/element
            - string.json: app中字符串的英文版
        - zh_CN/element
            - string.json: app 中字符串的中文版

## CodeStyle
- 类(class/struct)名以及类所在文件名：大驼峰。eg:`class Constants` ,`Constant.ets`。
- 变量名以及函数名：小驼峰。eg: `userName:string` `searchUserName()`,变量最好标注出类型。
- 配置文件内部命名采用下划线+小写。eg:`login_input_line_height`。g
- 非`struct`中的语句最好填写分号，避免不必要的错误。
## tutorial
1. clone 代码
`git clone https://github.com/vv12138vv/ThursdaySchedule.git`
2. 拉取最新代码
`git pull`
3. 确保位于main 分支 
`git switch main`
4. 创建本地分支并切换
`git checkout -b <branch_name>`
<branch_name>以 `feature/需求`命名
eg：`git checkout -b feature/new_page`