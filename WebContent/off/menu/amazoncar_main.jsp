<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/off/cookies.jsp" %>

<%
	String acar_id = ck_acar_id;
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(acar_id);
	
	//최종 공지사항
	OffAncDatabase oad = OffAncDatabase.getInstance();
	
//	a_bean = oad.getAncLastOffBeanP();
	a_bean = oad.getAncLastBeanP();
	
	
	String content = a_bean.getContent();
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>
<html>
<head>
<title>무제 문서</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link href=/include/style.css rel=stylesheet type=text/css></link>
<script language='javascript'>
<!--
	function AncDisp(bbs_id,title,content){		
		var theForm = document.AncForm;
		var contentDiv = document.getElementById("content");
		
		theForm.bbs_id.value=bbs_id;		
		theForm.title.value=title;
		//theForm.content.value=content;
		
		if(content.indexOf("<p>") != -1){
			contentDiv.innerHTML = content;
		}else{
			contentDiv.innerHTML = content.replace(/(?:\r\n|\r|\n)/g, '<br />');	
		}
		
		change_anc();
	}
	//읽음처리
	function change_anc(){
		var theForm = document.AncForm;
		var targetFrm = document.getElementsByName("i_no");
		
		if( targetFrm != null && targetFrm.length > 0){
			theForm.target='i_no';
			theForm.action="amazoncar_nodisplay1.jsp";
			theForm.submit();
		}
		//theForm.reset();
	}

	

	//리플달기
	function Anc_Open(){
		var SUBWIN="/off/off_bbs/off_bbs_c.jsp?bbs_id="+document.AncForm.bbs_id.value;	
		window.open(SUBWIN, "AncDisp", "left=100, top=50, width=1024, height=800, scrollbars=yes");
	}	
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
		
//-->
</script>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function change(obj) { 
    sc1.style.display = "none"; 
    sc2.style.display = "none"; 
    sc3.style.display = "none"; 
    sc4.style.display = "none"; 
  
    obj.style.display = ""; 
} 

var left_lb_idx = 1;
function show_left_lb(idx) {
	left_lb_idx = idx;
	var left_lb = document.getElementById('left_lb');
	var data = document.getElementById('left_lb_' + left_lb_idx).innerHTML;
	left_lb.innerHTML = data;
}
function img_left_over(idx) {
	var img1 = document.getElementById('img_left_1');
	var img2 = document.getElementById('img_left_2');
	//var img3 = document.getElementById('img_left_3');
	img1.src = '/acar/images/notice_button_1.gif';
	img2.src = '/acar/images/sell_button_1.gif';
	//img3.src = '/acar/images/kjs_button_1.gif';
	switch(idx) {
	case 1:
		img1.src = '/acar/images/notice_button.gif';
		break;
	case 2:
		img2.src = '/acar/images/sell_button.gif';
		break;
//	case 3:
//		img3.src = '/acar/images/kjs_button.gif';
//		break;
	}
}

//-->
</script>


<style><!--
A:link { color:red; text-decoration:none;}
A:visited { color:blue; text-decoration:none;}
A:active { color:lime; text-decoration:none;}
-->
</style>
<style type=text/css>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #303030}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
-->
</style>

</head>
<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:self.focus();">
<div align="center">
<form name="AncForm" method="post">
  <input type='hidden' name='acar_id' value='<%=acar_id%>'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>				
  <input type='hidden' name='bbs_id' value='<%=a_bean.getBbs_id()%>'>	
  
<table width=100% border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td align=center valign=middle>
            <table width=940 border=0 cellspacing=0 cellpadding=0 valign=middle>
            	<tr>
            		<td height=100></td>
            	</tr>

                <tr>
                    <td height=361 width=940 colspan=3 valign=top background="/acar/images/main_img_1.gif">
                    <%if(!nm_db.getWorkAuthUser("외부_자동차사",acar_id)){%>
                        <table width=940 border=0 cellspacing=0 cellpadding=0>
                            
                            <tr>
                                <td colspan=3 height=24>&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=520 height=377>
                                    <table width=520 border=0 cellspacing=0 cellpadding=0 background="/acar/images/main_notice_bg1.gif">
                                        <tr>
                                            <td width=43><img src="/acar/images/main_notice_1.gif" width=43 height=30></td>
                                            <td width=388 align=center background="/acar/images/main_notice_bg.gif"><span class=style2><input type=text name=title size=60 value='<%=a_bean.getTitle()%>' class=ttext></span></td>
                                            <td width=43 background="/acar/images/main_notice_bg.gif"><a href="javascript:Anc_Open()" onfocus="this.blur()" ><img src="/acar/images/button_reply.gif" width=43 height=16 border="0"></td>
                                            <td width=46><img src="/acar/images/main_notice_2.gif" width=46 height=30 ></td>
                                        </tr>
                                        <tr>
                                            <td colspan=4 height=5></td>
                                        </tr>
                                        <tr align=center>
                                           <!--<td colspan=4><textarea name="content" cols='74' rows='20'><%=content%></textarea></td>-->
                                           <td colspan=4><div id="content" name="content" style="padding: 30px; width: 430px; height: 250px; text-align: left; overflow: auto; max-height: 250px;"></div></td>                                          
                                        </tr>
                                        <tr>
                                            <td colspan=4><img src="/acar/images/main_notice_3.gif" width=520 height=16></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=20>&nbsp;</td>
                                <td width=400 valign=top>
                                    <table width=400 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=290 border=0 cellspacing=0 cellpadding=0 background="/acar/images/notice_bg.gif">
                                                    <tr>
                                                        <td width=70><img id="img_left_1" src="/acar/images/notice_button.gif" onMouseOver="" style="cursor:hand;"></td>
                                                        <td width=2>&nbsp;</td>
                                                        <td width=70></td>
                                                        <td width=158 align=right><a href="/off/off_bbs/off_bbs_frame.jsp"><img src="/acar/images/notice_more.gif" border=0></a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>                                         
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td>
                                            <div id="left_lb_1" style="display:none;">
                                                <table width=367 border=0 cellspacing=0 cellpadding=0>
                                                    <tr><!--공지사항-->
                                                        <td><iframe src="amazoncar_main_in1.jsp?auth_rw=<%=auth_rw%>" name="inner" width="320"  height=200 cellpadding="0" cellspacing="0" border="0" frameborder="0" scrolling="no" ></iframe></td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div id="left_lb"></div>
                                            <script type="text/javascript">show_left_lb(1);</script>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            
                        </table>
                     <%} %>
                    </td>
                </tr>
                                <tr>
                    <td colspan=2 height=20></td>
                </tr>
            </table>
        </td>
    </tr>
</table>

</form> 
</div>
</body>
</html>
