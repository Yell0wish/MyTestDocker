<template>
  <div class="createPost-container">
    <el-col>
      <el-card shadow="hover" style="width: 100%;">
        <div slot="header" class="clearfix">
          <span>贴子内容：</span>
          <div v-html="this.postDetail" ></div>
        </div>
        <div>
          <div v-for="(item, index) in commentList" :key="index">
            <div v-html="item.time"></div>
            <div v-html="item.name"></div>
            <div v-html="item.information"></div>
          </div>
        </div>
      </el-card>
    </el-col>

  <el-card>
    <el-form ref="postForm" :model="postForm" :rules="rules" class="form-container">
      <!--      <sticky :z-index="10" :class-name="'sub-navbar '+postForm.status">-->
      <!--        <CommentDropdown v-model="postForm.comment_disabled" />-->
      <!--        <PlatformDropdown v-model="postForm.platforms" />-->
      <!--        <SourceUrlDropdown v-model="postForm.source_uri" />-->
      <!--        <el-button v-loading="loading" style="margin-left: 10px;" type="success" @click="submitForm">-->
      <!--          发布-->
      <!--        </el-button>-->
      <!--      </sticky>-->

      <div class="createPost-main-container">
        <el-row>
          <!--          <Warning />-->

          <el-col :span="24">
            <!--            <el-form-item style="margin-bottom: 40px;" prop="title">-->
            <!--              <MDinput v-model="postForm.title" :maxlength="100" name="name" required>-->
            <!--                标题-->
            <!--              </MDinput>-->
            <!--            </el-form-item>-->
          </el-col>
        </el-row>

        <!--        <el-form-item style="margin-bottom: 40px;" label-width="70px" label="作业描述">-->
        <!--          <el-input v-model="postForm.content_short" :rows="1" type="textarea" class="article-textarea" autosize placeholder="输入作业描述" />-->
        <!--          <span v-show="contentShortLength" class="word-counter">{{ contentShortLength }}words</span>-->
        <!--        </el-form-item>-->

        <el-form-item prop="content" style="margin-bottom: 30px;">
          <Tinymce ref="editor" v-model="postForm.content" :height="400" />
          <el-button v-loading="loading"  type="success" @click="submitForm">
            发布
          </el-button>
        </el-form-item>

        <!--        <el-form-item prop="image_uri" style="margin-bottom: 30px;">-->
        <!--          <Upload v-model="postForm.image_uri" />-->
        <!--        </el-form-item>-->
      </div>
    </el-form>
  </el-card>
  </div>
</template>

<script>
import Tinymce from '@/components/Tinymce'
import Upload from '@/components/Upload/SingleImage3'
import MDinput from '@/components/MDinput'
import Sticky from '@/components/Sticky' // 粘性header组件
import { validURL } from '@/utils/validate'
import { fetchArticle } from '@/api/article'
import { searchUser } from '@/api/remote-search'
import Warning from './Warning'
import { CommentDropdown, PlatformDropdown, SourceUrlDropdown } from './Dropdown'
import {lo} from "pinyin/data/dict-zi-web";

const defaultForm = {
  status: 'draft',
  title: '', // 文章题目
  content: '', // 文章内容
  content_short: '', // 文章摘要
  source_uri: '', // 文章外链
  image_uri: '', // 文章图片
  display_time: undefined, // 前台展示时间
  id: undefined,
  platforms: ['a-platform'],
  comment_disabled: false,
  importance: 0,
  classid: 0,
  postid: 0,
}

export default {
  name: 'ArticleDetail',
  components: { Tinymce, MDinput, Upload, Sticky, Warning, CommentDropdown, PlatformDropdown, SourceUrlDropdown },
  props: {
    isEdit: {
      type: Boolean,
      default: false
    },
  },
  data() {
    const validateRequire = (rule, value, callback) => {
      if (value === '') {
        this.$message({
          message: rule.field + '为必传项',
          type: 'error'
        })
        callback(new Error(rule.field + '为必传项'))
      } else {
        callback()
      }
    }
    const validateSourceUri = (rule, value, callback) => {
      if (value) {
        if (validURL(value)) {
          callback()
        } else {
          this.$message({
            message: '外链url填写不正确',
            type: 'error'
          })
          callback(new Error('外链url填写不正确'))
        }
      } else {
        callback()
      }
    }
    return {
      postForm: Object.assign({}, defaultForm),
      loading: false,
      userListOptions: [],
      rules: {
        image_uri: [{ validator: validateRequire }],
        title: [{ validator: validateRequire }],
        content: [{ validator: validateRequire }],
        source_uri: [{ validator: validateSourceUri, trigger: 'blur' }]
      },
      tempRoute: {},
      postDetail: '',
      commentList: [],
    }
  },
  computed: {
    contentShortLength() {
      return this.postForm.content_short.length
    },
    lang() {
      return this.$store.getters.language
    },
    displayTime: {
      // set and get is useful when the data
      // returned by the back end api is different from the front end
      // back end return => "2013-06-25 06:59:25"
      // front end need timestamp => 1372114765000
      get() {
        return (+new Date(this.postForm.display_time))
      },
      set(val) {
        this.postForm.display_time = new Date(val)
      }
    }
  },
  created() {
    if (this.isEdit) {
      const id = this.$route.params && this.$route.params.id
      this.fetchData(id)
    }

    // Why need to make a copy of this.$route here?
    // Because if you enter this page and quickly switch tag, may be in the execution of the setTagsViewTitle function, this.$route is no longer pointing to the current page
    // https://github.com/PanJiaChen/vue-element-admin/issues/1221
    this.tempRoute = Object.assign({}, this.$route)


    this.$store.dispatch('user/getPostListAndComments', {classid: this.$route.params.classid, postid: this.$route.params.postid})
        .then((data) => {
          this.postDetail = data.postDetails[0].content
          this.commentList = data.postComments.map(item => ({
            time: item.time,
            information: item.information,
            name: item.name,
          }));
        })
  },
  methods: {
    fetchData(id) {
      fetchArticle(id).then(response => {
        this.postForm = response.data

        // just for test
        this.postForm.title += `   Article Id:${this.postForm.id}`
        this.postForm.content_short += `   Article Id:${this.postForm.id}`

        // set tagsview title
        this.setTagsViewTitle()

        // set page title
        this.setPageTitle()
      }).catch(err => {
        console.log(err)
      })
    },
    setTagsViewTitle() {
      const title = this.lang === 'zh' ? '编辑文章' : 'Edit Article'
      const route = Object.assign({}, this.tempRoute, { title: `${title}-${this.postForm.id}` })
      this.$store.dispatch('tagsView/updateVisitedView', route)
    },
    setPageTitle() {
      const title = 'Edit Article'
      document.title = `${title} - ${this.postForm.id}`
    },
    submitForm() {
      this.postForm.classid = this.$route.params.classid
      this.postForm.postid = this.$route.params.postid
      this.$refs.postForm.validate(valid => {
        if (valid) {
          this.loading = true
          this.$store.dispatch("user/publishComment", this.postForm)
          setTimeout(() => {
            tinymce.activeEditor.setContent("")
          }, 10);
          this.postForm.status = 'published'
          this.loading = false
          location.reload()
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    draftForm() {
      if (this.postForm.content.length === 0 || this.postForm.title.length === 0) {
        this.$message({
          message: '请填写必要的标题和内容',
          type: 'warning'
        })
        return
      }
      this.$message({
        message: '保存成功',
        type: 'success',
        showClose: true,
        duration: 1000
      })
      this.postForm.status = 'draft'
    },
    getRemoteUserList(query) {
      searchUser(query).then(response => {
        if (!response.data.items) return
        this.userListOptions = response.data.items.map(v => v.name)
      })
    }
  }
}
</script>

<style lang="scss" scoped>
@import "~@/styles/mixin.scss";

.createPost-container {
  position: relative;

  .createPost-main-container {
    padding: 40px 45px 20px 50px;

    .postInfo-container {
      position: relative;
      @include clearfix;
      margin-bottom: 10px;

      .postInfo-container-item {
        float: left;
      }
    }
  }

  .word-counter {
    width: 40px;
    position: absolute;
    right: 10px;
    top: 0px;
  }
}

.article-textarea ::v-deep {
  textarea {
    padding-right: 40px;
    resize: none;
    border: none;
    border-radius: 0px;
    border-bottom: 1px solid #bfcbd9;
  }
}
</style>
