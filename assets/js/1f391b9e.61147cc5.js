(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[85],{4083:function(e,t,n){"use strict";n.r(t),n.d(t,{default:function(){return G}});var r=n(67294),o=n(86010),l=n(97890),a=n(3905),s=n(87462),c=n(63366),i=n(12859),p=n(39960),u={plain:{backgroundColor:"#2a2734",color:"#9a86fd"},styles:[{types:["comment","prolog","doctype","cdata","punctuation"],style:{color:"#6c6783"}},{types:["namespace"],style:{opacity:.7}},{types:["tag","operator","number"],style:{color:"#e09142"}},{types:["property","function"],style:{color:"#9a86fd"}},{types:["tag-id","selector","atrule-id"],style:{color:"#eeebff"}},{types:["attr-name"],style:{color:"#c4b9fe"}},{types:["boolean","string","entity","url","attr-value","keyword","control","directive","unit","statement","regex","at-rule","placeholder","variable"],style:{color:"#ffcc99"}},{types:["deleted"],style:{textDecorationLine:"line-through"}},{types:["inserted"],style:{textDecorationLine:"underline"}},{types:["italic"],style:{fontStyle:"italic"}},{types:["important","bold"],style:{fontWeight:"bold"}},{types:["important"],style:{color:"#c4b9fe"}}]},d={Prism:n(87410).default,theme:u};function y(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function m(){return m=Object.assign||function(e){for(var t=1;t<arguments.length;t++){var n=arguments[t];for(var r in n)Object.prototype.hasOwnProperty.call(n,r)&&(e[r]=n[r])}return e},m.apply(this,arguments)}var h=/\r\n|\r|\n/,g=function(e){0===e.length?e.push({types:["plain"],content:"\n",empty:!0}):1===e.length&&""===e[0].content&&(e[0].content="\n",e[0].empty=!0)},f=function(e,t){var n=e.length;return n>0&&e[n-1]===t?e:e.concat(t)},v=function(e,t){var n=e.plain,r=Object.create(null),o=e.styles.reduce((function(e,n){var r=n.languages,o=n.style;return r&&!r.includes(t)||n.types.forEach((function(t){var n=m({},e[t],o);e[t]=n})),e}),r);return o.root=n,o.plain=m({},n,{backgroundColor:null}),o};function b(e,t){var n={};for(var r in e)Object.prototype.hasOwnProperty.call(e,r)&&-1===t.indexOf(r)&&(n[r]=e[r]);return n}var k=function(e){function t(){for(var t=this,n=[],r=arguments.length;r--;)n[r]=arguments[r];e.apply(this,n),y(this,"getThemeDict",(function(e){if(void 0!==t.themeDict&&e.theme===t.prevTheme&&e.language===t.prevLanguage)return t.themeDict;t.prevTheme=e.theme,t.prevLanguage=e.language;var n=e.theme?v(e.theme,e.language):void 0;return t.themeDict=n})),y(this,"getLineProps",(function(e){var n=e.key,r=e.className,o=e.style,l=m({},b(e,["key","className","style","line"]),{className:"token-line",style:void 0,key:void 0}),a=t.getThemeDict(t.props);return void 0!==a&&(l.style=a.plain),void 0!==o&&(l.style=void 0!==l.style?m({},l.style,o):o),void 0!==n&&(l.key=n),r&&(l.className+=" "+r),l})),y(this,"getStyleForToken",(function(e){var n=e.types,r=e.empty,o=n.length,l=t.getThemeDict(t.props);if(void 0!==l){if(1===o&&"plain"===n[0])return r?{display:"inline-block"}:void 0;if(1===o&&!r)return l[n[0]];var a=r?{display:"inline-block"}:{},s=n.map((function(e){return l[e]}));return Object.assign.apply(Object,[a].concat(s))}})),y(this,"getTokenProps",(function(e){var n=e.key,r=e.className,o=e.style,l=e.token,a=m({},b(e,["key","className","style","token"]),{className:"token "+l.types.join(" "),children:l.content,style:t.getStyleForToken(l),key:void 0});return void 0!==o&&(a.style=void 0!==a.style?m({},a.style,o):o),void 0!==n&&(a.key=n),r&&(a.className+=" "+r),a})),y(this,"tokenize",(function(e,t,n,r){var o={code:t,grammar:n,language:r,tokens:[]};e.hooks.run("before-tokenize",o);var l=o.tokens=e.tokenize(o.code,o.grammar,o.language);return e.hooks.run("after-tokenize",o),l}))}return e&&(t.__proto__=e),t.prototype=Object.create(e&&e.prototype),t.prototype.constructor=t,t.prototype.render=function(){var e=this.props,t=e.Prism,n=e.language,r=e.code,o=e.children,l=this.getThemeDict(this.props),a=t.languages[n];return o({tokens:function(e){for(var t=[[]],n=[e],r=[0],o=[e.length],l=0,a=0,s=[],c=[s];a>-1;){for(;(l=r[a]++)<o[a];){var i=void 0,p=t[a],u=n[a][l];if("string"==typeof u?(p=a>0?p:["plain"],i=u):(p=f(p,u.type),u.alias&&(p=f(p,u.alias)),i=u.content),"string"==typeof i){var d=i.split(h),y=d.length;s.push({types:p,content:d[0]});for(var m=1;m<y;m++)g(s),c.push(s=[]),s.push({types:p,content:d[m]})}else a++,t.push(p),n.push(i),r.push(0),o.push(i.length)}a--,t.pop(),n.pop(),r.pop(),o.pop()}return g(s),c}(void 0!==a?this.tokenize(t,r,a,n):[r]),className:"prism-code language-"+n,style:void 0!==l?l.root:{},getLineProps:this.getLineProps,getTokenProps:this.getTokenProps})},t}(r.Component),E=k;var j=n(87594),x=n.n(j),N={plain:{color:"#bfc7d5",backgroundColor:"#292d3e"},styles:[{types:["comment"],style:{color:"rgb(105, 112, 152)",fontStyle:"italic"}},{types:["string","inserted"],style:{color:"rgb(195, 232, 141)"}},{types:["number"],style:{color:"rgb(247, 140, 108)"}},{types:["builtin","char","constant","function"],style:{color:"rgb(130, 170, 255)"}},{types:["punctuation","selector"],style:{color:"rgb(199, 146, 234)"}},{types:["variable"],style:{color:"rgb(191, 199, 213)"}},{types:["class-name","attr-name"],style:{color:"rgb(255, 203, 107)"}},{types:["tag","deleted"],style:{color:"rgb(255, 85, 114)"}},{types:["operator"],style:{color:"rgb(137, 221, 255)"}},{types:["boolean"],style:{color:"rgb(255, 88, 116)"}},{types:["keyword"],style:{fontStyle:"italic"}},{types:["doctype"],style:{color:"rgb(199, 146, 234)",fontStyle:"italic"}},{types:["namespace"],style:{color:"rgb(178, 204, 214)"}},{types:["url"],style:{color:"rgb(221, 221, 221)"}}]},T=n(85350),Z=n(32822),C=function(){var e=(0,Z.LU)().prism,t=(0,T.Z)().isDarkTheme,n=e.theme||N,r=e.darkTheme||n;return t?r:n},_=n(95999),P="codeBlockContainer_K1bP",L="codeBlockContent_hGly",B="codeBlockTitle_eoMF",w="codeBlock_23N8",O="copyButton_Ue-o",D="codeBlockLines_39YC",S=/{([\d,-]+)}/,A=["js","jsBlock","jsx","python","html"],z={js:{start:"\\/\\/",end:""},jsBlock:{start:"\\/\\*",end:"\\*\\/"},jsx:{start:"\\{\\s*\\/\\*",end:"\\*\\/\\s*\\}"},python:{start:"#",end:""},html:{start:"\x3c!--",end:"--\x3e"}},I=["highlight-next-line","highlight-start","highlight-end"],R=function(e){void 0===e&&(e=A);var t=e.map((function(e){var t=z[e],n=t.start,r=t.end;return"(?:"+n+"\\s*("+I.join("|")+")\\s*"+r+")"})).join("|");return new RegExp("^\\s*(?:"+t+")\\s*$")};function F(e){var t=e.children,n=e.className,l=e.metastring,a=e.title,c=(0,Z.LU)().prism,i=(0,r.useState)(!1),p=i[0],u=i[1],y=(0,r.useState)(!1),m=y[0],h=y[1];(0,r.useEffect)((function(){h(!0)}),[]);var g=(0,Z.bc)(l)||a,f=(0,r.useRef)(null),v=[],b=C(),k=Array.isArray(t)?t.join(""):t;if(l&&S.test(l)){var j=l.match(S)[1];v=x()(j).filter((function(e){return e>0}))}var N=null==n?void 0:n.split(" ").find((function(e){return e.startsWith("language-")})),T=null==N?void 0:N.replace(/language-/,"");!T&&c.defaultLanguage&&(T=c.defaultLanguage);var A=k.replace(/\n$/,"");if(0===v.length&&void 0!==T){for(var z,I="",F=function(e){switch(e){case"js":case"javascript":case"ts":case"typescript":return R(["js","jsBlock"]);case"jsx":case"tsx":return R(["js","jsBlock","jsx"]);case"html":return R(["js","jsBlock","html"]);case"python":case"py":return R(["python"]);default:return R()}}(T),V=k.replace(/\n$/,"").split("\n"),$=0;$<V.length;){var M=$+1,U=V[$].match(F);if(null!==U){switch(U.slice(1).reduce((function(e,t){return e||t}),void 0)){case"highlight-next-line":I+=M+",";break;case"highlight-start":z=M;break;case"highlight-end":I+=z+"-"+(M-1)+","}V.splice($,1)}else $+=1}v=x()(I),A=V.join("\n")}var W=function(){!function(e,{target:t=document.body}={}){const n=document.createElement("textarea"),r=document.activeElement;n.value=e,n.setAttribute("readonly",""),n.style.contain="strict",n.style.position="absolute",n.style.left="-9999px",n.style.fontSize="12pt";const o=document.getSelection();let l=!1;o.rangeCount>0&&(l=o.getRangeAt(0)),t.append(n),n.select(),n.selectionStart=0,n.selectionEnd=e.length;let a=!1;try{a=document.execCommand("copy")}catch{}n.remove(),l&&(o.removeAllRanges(),o.addRange(l)),r&&r.focus()}(A),u(!0),setTimeout((function(){return u(!1)}),2e3)};return r.createElement(E,(0,s.Z)({},d,{key:String(m),theme:b,code:A,language:T}),(function(e){var t=e.className,l=e.style,a=e.tokens,c=e.getLineProps,i=e.getTokenProps;return r.createElement("div",{className:(0,o.Z)(P,null==n?void 0:n.replace(/language-[^ ]+/,""))},g&&r.createElement("div",{style:l,className:B},g),r.createElement("div",{className:(0,o.Z)(L,T)},r.createElement("pre",{tabIndex:0,className:(0,o.Z)(t,w,"thin-scrollbar"),style:l},r.createElement("code",{className:D},a.map((function(e,t){1===e.length&&"\n"===e[0].content&&(e[0].content="");var n=c({line:e,key:t});return v.includes(t+1)&&(n.className+=" docusaurus-highlight-code-line"),r.createElement("span",(0,s.Z)({key:t},n),e.map((function(e,t){return r.createElement("span",(0,s.Z)({key:t},i({token:e,key:t})))})),r.createElement("br",null))})))),r.createElement("button",{ref:f,type:"button","aria-label":(0,_.I)({id:"theme.CodeBlock.copyButtonAriaLabel",message:"Copy code to clipboard",description:"The ARIA label for copy code blocks button"}),className:(0,o.Z)(O,"clean-btn"),onClick:W},p?r.createElement(_.Z,{id:"theme.CodeBlock.copied",description:"The copied button label on code blocks"},"Copied"):r.createElement(_.Z,{id:"theme.CodeBlock.copy",description:"The copy button label on code blocks"},"Copy"))))}))}var V=n(39649),$="details_1VDD";function M(e){var t=Object.assign({},e);return r.createElement(Z.PO,(0,s.Z)({},t,{className:(0,o.Z)("alert alert--info",$,t.className)}))}var U=["mdxType","originalType"];var W={head:function(e){var t=r.Children.map(e.children,(function(e){return function(e){var t,n;if(null!=e&&null!=(t=e.props)&&t.mdxType&&null!=e&&null!=(n=e.props)&&n.originalType){var o=e.props,l=(o.mdxType,o.originalType,(0,c.Z)(o,U));return r.createElement(e.props.originalType,l)}return e}(e)}));return r.createElement(i.Z,e,t)},code:function(e){var t=e.children;return(0,r.isValidElement)(t)?t:t.includes("\n")?r.createElement(F,e):r.createElement("code",e)},a:function(e){return r.createElement(p.Z,e)},pre:function(e){var t,n=e.children;return(0,r.isValidElement)(n)&&(0,r.isValidElement)(null==n||null==(t=n.props)?void 0:t.children)?n.props.children:r.createElement(F,(0,r.isValidElement)(n)?null==n?void 0:n.props:Object.assign({},e))},details:function(e){var t=r.Children.toArray(e.children),n=t.find((function(e){var t;return"summary"===(null==e||null==(t=e.props)?void 0:t.mdxType)})),o=r.createElement(r.Fragment,null,t.filter((function(e){return e!==n})));return r.createElement(M,(0,s.Z)({},e,{summary:n}),o)},h1:(0,V.Z)("h1"),h2:(0,V.Z)("h2"),h3:(0,V.Z)("h3"),h4:(0,V.Z)("h4"),h5:(0,V.Z)("h5"),h6:(0,V.Z)("h6")},H=n(51575),q="mdxPageWrapper_3qD3";var G=function(e){var t=e.content,n=t.frontMatter,s=t.metadata,c=n.title,i=n.description,p=n.wrapperClassName,u=n.hide_table_of_contents,d=s.permalink;return r.createElement(l.Z,{title:c,description:i,permalink:d,wrapperClassName:null!=p?p:Z.kM.wrapper.mdxPages,pageClassName:Z.kM.page.mdxPage},r.createElement("main",{className:"container container--fluid margin-vert--lg"},r.createElement("div",{className:(0,o.Z)("row",q)},r.createElement("div",{className:(0,o.Z)("col",!u&&"col--8")},r.createElement(a.Zo,{components:W},r.createElement(t,null))),!u&&t.toc&&r.createElement("div",{className:"col col--2"},r.createElement(H.Z,{toc:t.toc,minHeadingLevel:n.toc_min_heading_level,maxHeadingLevel:n.toc_max_heading_level})))))}},87594:function(e,t){function n(e){let t,n=[];for(let r of e.split(",").map((e=>e.trim())))if(/^-?\d+$/.test(r))n.push(parseInt(r,10));else if(t=r.match(/^(-?\d+)(-|\.\.\.?|\u2025|\u2026|\u22EF)(-?\d+)$/)){let[e,r,o,l]=t;if(r&&l){r=parseInt(r),l=parseInt(l);const e=r<l?1:-1;"-"!==o&&".."!==o&&"\u2025"!==o||(l+=e);for(let t=r;t!==l;t+=e)n.push(t)}}return n}t.default=n,e.exports=n}}]);