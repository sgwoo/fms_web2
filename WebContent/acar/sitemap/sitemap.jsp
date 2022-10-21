<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="sm_bean" class="acar.user_mng.AuthBean" scope="page"/>
<jsp:useBean id="lm_bean" class="acar.user_mng.MenuBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String m_st 	= request.getParameter("m_st")==null?"":request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")==null?"":request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")==null?"":request.getParameter("m_cd");
	String url 		= request.getParameter("url")==null?"":request.getParameter("url");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id 	= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String seq_no 	= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//대메뉴-------------------------------------------
	MenuBean lm_r [] = umd.getMaMenuAll("", "", "b");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<style type=text/css>
<!--
body, table, tr, td, select, textarea{ 
	font-family:'dotum';
	font-size: 12px;
	color: #666666;
}
.style1 {color: #ffffff; font-weight: bold;}
.style2 {color: #ef620c; font-weight: bold;}
.style3 {color: #726bbd; font-weight: bold;}

a:link, a:visited, a:active { text-decoration:none; font-size:12px; color:#666666;}
a:hover { color:red; font-size:12px; text-decoration:none;}
-->
</style>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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

<script language='javascript'>
<!--
	var s_width = screen.width;
	var s_height = screen.height;	
	
	function page_link(m_st, m_st2, m_cd, url, auth_rw){
		
		var fm = document.form1;
		
		var menu1 	= fm.m_st.value+''+fm.m_st2.value;
		var menu2 	= m_st+''+m_st2;	
		
		var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value+'&m_id='+fm.m_id.value+'&l_cd='+fm.l_cd.value+'&c_id='+fm.c_id.value+'&rent_mng_id='+fm.m_id.value+'&rent_l_cd='+fm.l_cd.value+'&car_mng_id='+fm.c_id.value+'&client_id='+fm.client_id.value+'&accid_id='+fm.accid_id.value+'&serv_id='+fm.serv_id.value+'&seq_no='+fm.seq_no.value;		
		var values2	= '&m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value+'&m_id='+fm.m_id.value+'&l_cd='+fm.l_cd.value+'&c_id='+fm.c_id.value+'&rent_mng_id='+fm.m_id.value+'&rent_l_cd='+fm.l_cd.value+'&car_mng_id='+fm.c_id.value+'&client_id='+fm.client_id.value+'&accid_id='+fm.accid_id.value+'&serv_id='+fm.serv_id.value+'&seq_no='+fm.seq_no.value;				
		
		if(menu1 != menu2){		
			parent.top_menu.location.href = '/acar/menu/emp_top.jsp'+values;
			location.href = '/acar/menu/emp_menu.jsp'+values;
		}	
		
		if(url != '' && url.substr(0,4)=='http'){
			window.open(url, "pop", "menubar=yes, toolbar=yes, location=yes, directories=yes, status=yes, scrollbars=yes, resizable=yes");
		}else if(url != '' && url.substr(1,3)!='http'){
			if(url.lastIndexOf('?')!=-1){
				parent.d_content.location.href = url+''+values2;				
			}else{
				parent.d_content.location.href = url+''+values;
			}
		}else{	
			parent.d_content.location.href = '../include/no_page.html';
		}			
	} 
	
//-->
</script>
</head>

<body leftmargin="15">
<form name="form1" method="post" action="">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name="m_st" value="<%=m_st%>">
<input type='hidden' name="m_st2" value="<%=m_st2%>">
<input type='hidden' name="m_cd" value="<%=m_cd%>">
<input type='hidden' name="url" value="<%=url%>">
<input type='hidden' name="s_width" value="<%=s_width%>">
<input type='hidden' name="s_height" value="<%=s_height%>">
<input type='hidden' name='m_id' value="<%=m_id%>">
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name="c_id" value="<%=c_id%>">
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name="accid_id" value="<%=accid_id%>">
<input type='hidden' name="serv_id" value="<%=serv_id%>">
<input type='hidden' name="seq_no" value="<%=seq_no%>">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td style="padding-top: 5px;" background=/acar/images/center/menu_bar_bg.gif name=top>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;사이트맵 > <span class=style2>sitemap</span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td height=40></td>
    </tr>
    <tr>
        <td align=center>
            <table width=80% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><a href="#menu1" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','images/menu_1_1.gif',1)"><img src="images/menu_1.gif" name="Image1" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu2" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','images/menu_2_1.gif',1)"><img src="images/menu_2.gif" name="Image2" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu3" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image3','','images/menu_3_1.gif',1)"><img src="images/menu_3.gif" name="Image3" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu4" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image4','','images/menu_4_1.gif',1)"><img src="images/menu_4.gif" name="Image4" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu5" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image5','','images/menu_5_1.gif',1)"><img src="images/menu_5.gif" name="Image5" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu6" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','images/menu_6_1.gif',1)"><img src="images/menu_6.gif" name="Image6" width="93" height="24" border="0"></a></td>
                </tr>
                <tr>
                    <td height=7></td>
                </tr>
                <tr>
                    <td><a href="#menu7" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','images/menu_7_1.gif',1)"><img src="images/menu_7.gif" name="Image7" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu8" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','images/menu_8_1.gif',1)"><img src="images/menu_8.gif" name="Image8" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu9" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image9','','images/menu_9_1.gif',1)"><img src="images/menu_9.gif" name="Image9" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu10" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','images/menu_10_1.gif',1)"><img src="images/menu_10.gif" name="Image10" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu11" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image11','','images/menu_11_1.gif',1)"><img src="images/menu_11.gif" name="Image11" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu12" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image12','','images/menu_12_1.gif',1)"><img src="images/menu_12.gif" name="Image12" width="93" height="24" border="0"></a></td>
                </tr>
                <tr>
                    <td height=7></td>
                </tr>
                <tr>
                    <td><a href="#menu13" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image13','','images/menu_13_1.gif',1)"><img src="images/menu_13.gif" name="Image13" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu14" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image14','','images/menu_14_1.gif',1)"><img src="images/menu_14.gif" name="Image14" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu15" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image15','','images/menu_15_1.gif',1)"><img src="images/menu_15.gif" name="Image15" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu16" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image16','','images/menu_16_1.gif',1)"><img src="images/menu_16.gif" name="Image16" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu17" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image17','','images/menu_17_1.gif',1)"><img src="images/menu_17.gif" name="Image17" width="93" height="24" border="0"></a></td>
                    <td><a href="#menu18" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image18','','images/menu_18_1.gif',1)"><img src="images/menu_18.gif" name="Image18" width="93" height="24" border="0"></a></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=40></td>
    </tr>
    <%	for(int k=0; k<lm_r.length; k++){
        	lm_bean = lm_r[k];
			if(lm_bean.getM_st().equals("99")) continue;

			Vector mm = umd.getAuthMaMeAll1(user_id, lm_bean.getM_st());
			int mm_size = mm.size();%>
 <!-- 영업지원 ~ -->
    <tr>
        <td align=center>
            <table width=95% border=0 cellspacing=0 cellpadding=0 background=/acar/sitemap/images/menu_bg.gif>
                <tr>
                    <td width=17><img src=/acar/sitemap/images/menu_l.gif name=menu<%=k+1%>></td>
                    <td style="padding-top: 4px;" align=left>&nbsp;&nbsp;<span class=style3><%=lm_bean.getM_nm()%></span></td>
                    <td align=right><a href=#top><img src=/acar/sitemap/images/top_img.gif border=0></a></td>
                    <td width=17 align=right><img src=/acar/sitemap/images/menu_r.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=5></td>
    </tr>
    <tr>
        <td align=center>
            <table width=93% border=0 cellspacing=0 cellpadding=0>
                <%	for (int i = 0 ; i < mm_size ; i++){
                 		Hashtable m_menu = (Hashtable)mm.elementAt(i);
						AuthBean sm_r [] = umd.getAuthMaMeAll(user_id, String.valueOf(m_menu.get("M_ST")), String.valueOf(m_menu.get("M_ST2")));
                %>
				<tr>
                    <td width=208 valign=top>
                        <table width=100% border=0 cellspacing=0 cellpadding=0 background=/acar/sitemap/images/submenu_bg.gif>
                            <tr>
                                <td width=15>&nbsp;</td>
                                <td style="padding-top: 4px;" height=25><span class=style1><%=String.valueOf(m_menu.get("M_NM"))%></span></td>
                            </tr>
                        </table>
                    <td width=15>&nbsp;</td>
                    <td align=left>
                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td style="padding-top: 4px;">
								<%	for(int j=0; j<sm_r.length; j++){
        				    			sm_bean = sm_r[j];%>
								<a href=javascript:page_link('<%=sm_bean.getM_st()%>','<%=sm_bean.getM_st2()%>','<%=sm_bean.getM_cd()%>','<%=sm_bean.getUrl()%>','<%=sm_bean.getAuth_rw()%>');><%=sm_bean.getM_nm()%></a>
                                <%		if(j+1 < sm_r.length){%><img src=/acar/sitemap/images/vline.gif align=absmiddle><%}%>
								<%	}%>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td height=1 bgcolor=e0dddd colspan=3></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
				<%	}%>
            </table>
        </td>
    </tr> 
    <tr>
        <td height=30></td>
    </tr>
 <!-- 영업지원 ~ -->
    <%	}%>
</table>
</form>
</body>
</html>