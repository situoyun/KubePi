<template>
  <el-container class="layout-container">
    <slot>
      <layout-sidebar />
      <layout-main>
        <layout-header>
          <slot name="header"></slot>
        </layout-header>
        <layout-view />
      </layout-main>
    </slot>
  </el-container>
</template>

<script>
import LayoutSidebar from "./LayoutSidebar"
import LayoutMain from "./LayoutMain"
import LayoutHeader from "./LayoutHeader"
import LayoutView from "./LayoutView"

export default {
  name: "Layout",
  components: { LayoutView, LayoutHeader, LayoutMain, LayoutSidebar },
}
</script>

<style lang="scss">
@import "~@/styles/common/variables";

.layout-container {
  min-width: 1024px;
  height: 100%;
  background-color: $layout-bg-color;
}

.main-container {
  position: relative;
}

.sidebar-container {
  position: relative;
  transition: width 0.28s;
  width: $sidebar-open-width;
  min-width: $sidebar-open-width;
  background-color: $sidebar-bg-color;
  background-image: $sidebar-bg-gradient;

  &.is-collapse {
    width: $sidebar-close-width;
    min-width: $sidebar-close-width;
  }
}

.header-container {
  display: none;
  height: $header-height;
  padding: 0 $header-padding;
}

.view-container {
  display: block;
  flex: auto;
  overflow: auto;
  box-sizing: border-box;
  padding:0 15px 15px;
}
</style>