<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<%@ include file="/acct/cookies.jsp" %> 

<%
	String acar_id = ck_acar_id;
	
	//로그아웃 처리를 위한------------------
	String login_time 	= Util.getLoginTime();		//로그인시간
	String ip 		= request.getRemoteAddr(); 	//로그인IP
	
	String m_st 	= request.getParameter("m_st")	==null?"19":request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")	==null?"01":request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")	==null?"01":request.getParameter("m_cd");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String url 	= request.getParameter("url")	==null?"":request.getParameter("url");
	
    	String cmd = "";
	int count = 0;
	int bbs_id = 0;
	
	
	//사용자정보
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean user_bean = umd.getUsersBean(acar_id);
	
	
	//중메뉴
	Vector au_menu = umd.getAuthMaMeAll2(acar_id, m_st);
	int aumenu_size = au_menu.size();
	
	
	
%>

<html>
<head>
<META HTTP-EQUIV="refresh" CONTENT="3600">
<title>:: FMS(Fleet Management System) ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acct/include/sub.css">
<script language='javascript'>
<!--
	function page_link(m_st, m_st2, m_cd, url, auth_rw){	
			
		var fm = document.form1;			
		
		var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value;
		
		var menu1 	= fm.m_st.value+''+fm.m_st2.value;
		var menu2 	= m_st+''+m_st2;	
		
		if(menu1 != menu2){			
			location.href 		= 'emp_top.jsp'+values;
		}
		parent.d_menu.location.href 	= 'emp_menu.jsp'+values;
	} 
		
	//로그아웃
	function Logout(){
		if(!confirm("로그아웃 하시겠습니까?")){ return; }
		parent.location.href ='./del.jsp?login_time=<%=login_time%>&ip=<%=ip%>';
	//	i_no.location ='./del.jsp?login_time=<%=login_time%>&ip=<%=ip%>';
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
//-->
</script>
<style>


#so_oTickerContainer {
    width:300px;
    margin:auto;
    font:verdana,arial;
    background-color:;
    border-top:;
    border-bottom:;
}

#so_oTickerContainer h1 {
    font:bold verdana,arial;
    margin:0;
    padding:0;
}
    
.so_tickerContainer {
    position:relative;
    margin:auto;
    width:300px;
    background-color:;
    border-top:;
    border-bottom:;
}

#so_tickerAnchor, #so_oTickerContainer a {
    text-decoration:none;
    color:black;
    font:bold arial,verdana;
    border-right:;
    padding-right:;
}

#so_oTickerContainer a {
    border-style:none;
}

#so_oTickerContainer ul {
    margin-top:5px;
}

#so_tickerDiv {
    display:inline;
    margin-left:5px;
}

#so_tickerH1 {
    font:bold 1.0em arial,verdana;
    display:inline;
}

.so tickerP1 {
 	color:red;
    font:bold 1.0em arial,verdana;
}   
    
#so_tickerH1 a {
    text-decoration:none;
    color:none;
    padding-right:none;
}

#so_tickerH1 a img {
    border-style:none;
}
<!--
.style2 {color: #ff00ff;
         font-size: 11px;}
.style3 {color: #FF0000}
-->
</style>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<form name="form1" method="post" action="">
<input type='hidden' name="m_st" value="<%=m_st%>">
<input type='hidden' name="m_st2" value="<%=m_st2%>">
<input type='hidden' name="m_cd" value="<%=m_cd%>">
<input type='hidden' name="url" value="<%=url%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="user_id" value="<%=acar_id%>">
<input type='hidden' name='br_id' value="<%=user_bean.getBr_id()%>">
<input type='hidden' name="s_width" value="<%=s_width%>">
<input type='hidden' name="s_height" value="<%=s_height%>">
<table width=100% border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td width=169 height=49 align=center background=/acct/images/top_bg.gif><a href="http://www.amazoncar.co.kr" target=_blank title='아마존카 홈페이지'><img src=/acar/images/logo_1.png ></a></td>
        <td valign=top background=/acct/images/top_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td valign=top>
            <table width=169 border=0 cellpadding=0 cellspacing=0 background=/acct/images/p_img.gif>
                <tr>
                    <td height=28 align=center>
                        <table width=144 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td width=95>
                                    <table width=95 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;<strong><%=user_bean.getUser_nm()%></strong></td>
        		                        </tr>
        		                    </table>
        		                </td>
        		                <!--Logout  -->
                 			<td width=49><a href="javascript:Logout();"><img src=/acct/images/button_logout.gif width=49 height=14 border=0></a></td>
                            </tr>
                        </table>
                    </td>
                    <td width=4 rowspan=2><img src=/acct/images/menu_left.gif width=4 height=75></td>
                </tr>
                <tr>
                    <td height=47 align=center valign=top>
                        <table width=144 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td width=100% height=23 align=right>&nbsp;</td>                                
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td valign=top>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=6></td>
                </tr>
                <tr>
                    <td valign=top>
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" background="/acct/images/menu_bg.gif">
                            <tr>
                              <td width="20" height=31>&nbsp;</td>
                              <td width="30" valign=middle><a href="javascript:page_link('19','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image1','','/acct/images/menu_01_1.gif',1)><img src=/acct/images/menu_01.gif name=Image1 border=0></a></td>
                              <td width="30" valign=middle><a href="javascript:page_link('20','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image2','','/acct/images/menu_02_1.gif',1)><img src=/acct/images/menu_02.gif name=Image2 border=0></a></td>
                              <td width="30" valign=middle><a href="javascript:page_link('21','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image3','','/acct/images/menu_03_1.gif',1)><img src=/acct/images/menu_03.gif name=Image3 border=0></a></td>
                              <td valign=middle>&nbsp;</td>
                              <td valign=middle>&nbsp;</td>
                              <td valign=middle>&nbsp;</td>
                              <td valign=middle>&nbsp;</td>
                              <td valign=middle>&nbsp;</td>
                              <td valign=middle>&nbsp;</td>
                              <td valign=middle>&nbsp;</td>
                              <td valign=middle>&nbsp;</td>
                              <td valign=middle>&nbsp;</td>
                              <td valign=middle>&nbsp;</td>
                    	      <td width="20">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign=top>
                        <!--2 depth menu  권한 시작 -->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" background="/acct/images/menu_bg_2depth.gif">
                            <tr> 
                                <td width=27 height=28>&nbsp;</td>
                        <%	int t_width = 0;
                        	for (int i = 0 ; i < aumenu_size ; i++){
                        		Hashtable aumenu = (Hashtable)au_menu.elementAt(i);
                        					
                        		String str = aumenu.get("M_NM").toString();
                        		int char_len = str.length();
                        		int byte_len = str.getBytes().length;
                        		int width = byte_len*8;//한글자에8pix=width
                        		t_width += width;
                        %>
                        		<%if(i > 0){%>
                                <td width="1" background="/acct/images/menu_bg_2depth.gif"><img src="/acct/images/menu_2depth_vline.gif"></td>
                            	<%}%>
                            	<%if(m_st2.equals(aumenu.get("M_ST2"))){%>
                                <td width="<%=width%>" align="center" background="/acct/images/menu_bg_2depth.gif" height=28><b><a href="javascript:page_link('<%=aumenu.get("M_ST")%>','<%=aumenu.get("M_ST2")%>','<%//=aumenu.get("M_CD")%>','<%//=aumenu.get("URL")%>','<%//=aumenu.get("AUTH_RW")%>');"><%=aumenu.get("M_NM")%></a></b></td>
                            	<%}else{%>
                                <td width="<%=width%>" align="center" background="/acct/images/menu_bg_2depth.gif"  height=28><a href="javascript:page_link('<%=aumenu.get("M_ST")%>','<%=aumenu.get("M_ST2")%>','<%//=aumenu.get("M_CD")%>','<%//=aumenu.get("URL")%>','<%//=aumenu.get("AUTH_RW")%>');"><%=aumenu.get("M_NM")%></a></td>
                            	<%}%>
                        <%	}%>
                                <%if((AddUtil.parseInt(s_width)-165-30-t_width) >0){%>
								<td width="<%=(AddUtil.parseInt(s_width)-165-30-t_width)/AddUtil.parseInt(s_width)*100%>" background="../images/sub/sub_top_bg08.gif"></td>
								<%}else{%>
								<td width="1" background="../images/sub/sub_top_bg08.gif"></td>								
								<%}%>
                                <td background="/acct/images/menu_bg_2depth.gif" align="right">&nbsp;</td>
                            </tr>
                        </table>
                        <!--2 depth menu  권한 끝 -->
                    </td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<form name="form2">
<input type='hidden' name='m_id' value="">
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name="c_id" value="">
<input type='hidden' name="auth_rw" value="">
</form>
</body>
</html>