<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*, acar.memo.*, acar.estimate_mng.*, acar.cus_reg.*" %>
<jsp:useBean id="memo_db" scope="page" class="acar.memo.Memo_Database"/>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String acar_id = ck_acar_id;
	
	
	//로그아웃 처리를 위한------------------
	String login_time 	= Util.getLoginTime();		//로그인시간
	String ip 			= request.getRemoteAddr(); 	//로그인IP
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String m_st 	= request.getParameter("m_st")==null?"13":request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")==null?"01":request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")==null?"01":request.getParameter("m_cd");
	String url 		= request.getParameter("url")==null?"":request.getParameter("url");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id 	= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String seq_no 	= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	
    	String cmd = "";
	int count = 0;
	int bbs_id = 0;
	
	//사용자정보
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean user_bean = umd.getUsersBean(acar_id);
	
	
	//중메뉴
	Vector	 au_menu = umd.getAuthMaMeAll1(acar_id, m_st);
	int aumenu_size = au_menu.size();
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	//바로가기메뉴리스트
	Vector qmenus = nm_db.getQLinkList(acar_id);
	int qmenu_size = qmenus.size();
	
	//미수신된 메모확인
	MemoBean[] bns = memo_db.getRece_n_List(acar_id);
	
	OffAncDatabase oad = OffAncDatabase.getInstance();

	//공지사항 한건 조회
	a_bean = oad.getAncLastBeanP();
%>

<html>
<head>
<META HTTP-EQUIV="refresh" CONTENT="3600">
<title>:: FMS(Fleet Management System) ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/sub.css">
<script language='javascript'>
<!--
	function page_link(m_st, m_st2, m_cd, url, auth_rw){	
			
		var fm = document.form1;			
		
		var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value;
		
		var menu1 	= fm.m_st.value+''+fm.m_st2.value;
		var menu2 	= m_st+''+m_st2;	
		
		if(menu1 != menu2){			
			location.href 			= 'subcont_top.jsp'+values;
		}
		parent.d_menu.location.href = 'subcont_menu.jsp'+values;
	} 
		
	//바로가기 메뉴 선택시
	function page_link2(){	
	
		var fm = document.form1;

		var qlink = fm.qlink.options[fm.qlink.selectedIndex].value;
		
		if(qlink == ''){ return;}
		
		var qlinks = qlink.split(" ");
		
		var url     = "";
		var m_st 	= qlinks[0];
		var m_st2 	= qlinks[1];
		var m_cd 	= qlinks[2];
		var auth_rw	= qlinks[3];
		var url_l 	= qlinks[4];
		var url_s	= qlinks[5];	
		var folder 	= m_st+''+m_st2+''+m_cd;	

		if(fm.l_cd.value == '')		url = url_l;			
		else						url = url_s;
		
		var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value+'&m_id='+fm.m_id.value+'&l_cd='+fm.l_cd.value+'&c_id='+fm.c_id.value+'&rent_mng_id='+fm.m_id.value+'&rent_l_cd='+fm.l_cd.value+'&car_mng_id='+fm.c_id.value+'&client_id='+fm.client_id.value+'&accid_id='+fm.accid_id.value+'&serv_id='+fm.serv_id.value+'&seq_no='+fm.seq_no.value;
		
		if(folder == '040102' && fm.l_cd.value != '') values += '&s_st=3&s_kd=1&t_wd='+fm.l_cd.value;
		if(folder == '050301' && fm.l_cd.value != '') values += '&f_list=pay';
		if(folder == '050502' && fm.l_cd.value != '') values += '&f_list=scd';
		if(folder == '050701' && fm.l_cd.value != '') values += '&s_kd=2&t_wd1='+fm.l_cd.value;
		
		var menu1 	= fm.m_st.value+''+fm.m_st2.value;
		var menu2 	= m_st+''+m_st2;	
		
		if(menu1 != menu2){			
			location.href 			= 'subcont_top.jsp'+values;			
		}
		parent.d_menu.location.href = 'subcont_menu.jsp'+values;					
	}
	
	//로그아웃
	function Logout(){
		if(!confirm("로그아웃 하시겠습니까?")){ return; }
		i_no.location ='./del.jsp?login_time=<%=login_time%>&ip=<%=ip%>';
	}
	
	//연락망
	function tel(){
		var SUBWIN="/acar/user_mng/sostel_frame.jsp";	
		window.open(SUBWIN, "TelUp", "left=10, top=10, width=800, height=700, scrollbars=yes");
	}	

	//연락망
	function tel2(){
		var SUBWIN="/acar/user_mng/sawon2.jsp";	
		window.open(SUBWIN, "TelUp", "left=10, top=10, width=700, height=700, scrollbars=yes");
	}	
	
	//메모보기
	function Memo(arg, cmd){
		var SUBWIN="/acar/memo/memo_frame.jsp?user_id="+arg+"&cmd="+cmd;	
		window.open(SUBWIN, "MemoUp", "left=10, top=10, width=650, height=650, scrollbars=yes");
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
<script language="JavaScript">
<!-- 
<%if(!a_bean.getExp_dt().equals("")){%>
function notice_getCookie( name ){
	var nameOfCookie = name + "=";
	var x = 0;
	while ( x <= document.cookie.length )
	{
			var y = (x+nameOfCookie.length);
			if ( document.cookie.substring( x, y ) == nameOfCookie ) {
					if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
							endOfCookie = document.cookie.length;
					return unescape( document.cookie.substring( y, endOfCookie ) );
			}
			x = document.cookie.indexOf( " ", x ) + 1;
			if ( x == 0 )
					break;
	}
	return "";
}
if ( notice_getCookie( "Notice" ) != "done" )
{
        window.open('anc_p.jsp','','width=640,height=650'); // 팝업윈도우의 경로와 크기를 설정 하세요
}
<%}%>
// -->
</script>
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
<input type='hidden' name='m_id' value="<%=m_id%>">
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name="c_id" value="<%=c_id%>">
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name="accid_id" value="<%=accid_id%>">
<input type='hidden' name="serv_id" value="<%=serv_id%>">
<input type='hidden' name="seq_no" value="<%=seq_no%>">
<input type='hidden' name="s_width" value="<%=s_width%>">
<input type='hidden' name="s_height" value="<%=s_height%>">
<table width=100% border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td width=169 height=49 align=center background=/acar/images/top_bg.gif><a href="http://www.amazoncar.co.kr" target=_blank title='아마존카 홈페이지'><img src=/acar/images/logo.gif width=90 height=23></a></td>
        <td valign=top background=/acar/images/top_bg.gif>
	     &nbsp;
        </td>
    </tr>
    <tr>
        <td valign=top>
            <table width=169 border=0 cellpadding=0 cellspacing=0 background=/acar/images/p_img.gif>
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
                                            <td>&nbsp;<strong><span title='<%=user_bean.getUser_nm()%>'><%=Util.subData(user_bean.getUser_nm(), 5)%></span></strong></td>
        		                        </tr>
        		                    </table>
        		                </td>
                 <!--Logout  --><td width=49><a href="javascript:Logout();"><img src=/acar/images/button_logout.gif width=49 height=14 border=0></a></td>
                            </tr>
                        </table>
                    </td>
                    <td width=4 rowspan=2><img src=/acar/images/menu_left.gif width=4 height=75></td>
                </tr>
                <tr>
                    <td height=47 align=center valign=top>
                        <table width=144 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td width=38 height=23 align=center>&nbsp;
									<%if(nm_db.getWorkAuthUser("외부_콜센타",acar_id)){%>     
										<a href="javascript:tel();"><img src=/acar/images/button_tel.gif border=0 align=absmiddle></a>
									<%}else{%>
										<a href="javascript:tel2();"><img src=/acar/images/button_tel.gif border=0 align=absmiddle></a>									
									<%}%>
								</td>   
				 <td width=7 align=center><img src=/acar/images/pro_vline.gif width=1 height=10></td> 				  
                                 <td width=37 style="font-size:8pt">
									<%if(nm_db.getWorkAuthUser("외부_콜센타",acar_id)){%>     
										<%	if(bns.length>0){%>										
										<a href="javascript:Memo('<%=acar_id%>', 'new')" title="새 메세지가 도착했습니다."><img src=/acar/images/new.gif width=22 height=7 align=absmiddle>(<% out.print(bns.length); %>)</a>
										<%	}else{%>
										<a href="javascript:Memo('<%=acar_id%>', '')" title="메세지 보기"><img src=/acar/images/button_memo.gif width=17 height=10 border=0 align=absmiddle></a>
										<%	}%>
									<%}%>
								</td>  
				 <td>&nbsp;</td>				 				   								                           
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
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" background="/acar/images/menu_bg.gif">
                            <tr>
                              <td width="20" height=31>&nbsp;</td>
							  <%if(nm_db.getWorkAuthUser("외부_콜센타",acar_id)){%>
							   <td valign=middle><a href="javascript:page_link('16','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image13','','/acar/images/menu_13_1.gif',1)><img src="/acar/images/menu_13.gif" name=Image13 border="0"></a></td>
							  <%}else if(nm_db.getWorkAuthUser("외부_자동차사",acar_id)){%>
							  <td valign=middle>&nbsp;</td>
							  <%}else{%>
							  <td valign=middle><a href="javascript:page_link('17','04','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image11','','/acar/images/menu_11_1.gif',1)><img src="/acar/images/menu_11.gif" name=Image11 border="0"></a></td>
							  <%}%>
                    		  <td width="20">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign=top>
                        <!--2 depth menu  권한 시작 -->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" background="/acar/images/menu_bg_2depth.gif">
                            <tr> 
                                <td width=27 height=28>&nbsp;</td>
                        <%	int t_width = 0;
                        	for (int i = 0 ; i < aumenu_size ; i++){
                        		Hashtable aumenu = (Hashtable)au_menu.elementAt(i);
                        				
	                        		
                       			if(AddUtil.parseInt((aumenu.get("M_ST").toString().trim())) > 18 &&  AddUtil.parseInt((aumenu.get("M_ST").toString().trim())) < 35){
                       				continue;
                       			}
	                        		
	                        		                        					
                        		String str = aumenu.get("M_NM").toString();
                        		int char_len = str.length();
                        		int byte_len = str.getBytes().length;
                        		int width = byte_len*8;//한글자에8pix=width
                        		t_width += width;
                        %>
                        		<%if(i > 0){%>
                                <td width="1" background="/acar/images/menu_bg_2depth.gif"><img src="/acar/images/menu_2depth_vline.gif"></td>
                            	<%}%>
                            	<%if(m_st2.equals(aumenu.get("M_ST2"))){%>
                                <td width="<%=width%>" align="center" background="/acar/images/menu_bg_2depth.gif" height=28><b><a href="javascript:page_link('<%=aumenu.get("M_ST")%>','<%=aumenu.get("M_ST2")%>','<%//=aumenu.get("M_CD")%>','<%//=aumenu.get("URL")%>','<%//=aumenu.get("AUTH_RW")%>');"><%=aumenu.get("M_NM")%></a></b></td>
                            	<%}else{%>
                                <td width="<%=width%>" align="center" background="/acar/images/menu_bg_2depth.gif"  height=28><a href="javascript:page_link('<%=aumenu.get("M_ST")%>','<%=aumenu.get("M_ST2")%>','<%//=aumenu.get("M_CD")%>','<%//=aumenu.get("URL")%>','<%//=aumenu.get("AUTH_RW")%>');"><%=aumenu.get("M_NM")%></a></td>
                            	<%}%>
                        <%	}%>
                                <%if((AddUtil.parseInt(s_width)-165-30-t_width) >0){%>
								<td width="<%=(AddUtil.parseInt(s_width)-165-30-t_width)/AddUtil.parseInt(s_width)*100%>" background="../images/sub/sub_top_bg08.gif"></td>
								<%}else{%>
								<td width="1" background="../images/sub/sub_top_bg08.gif"></td>								
								<%}%>
                                <td background="/acar/images/menu_bg_2depth.gif" align="right">&nbsp;</td>
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