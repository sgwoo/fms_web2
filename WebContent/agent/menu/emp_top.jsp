<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.off_anc.*" %>
<%@ include file="/agent/cookies.jsp" %> 
<%
	String acar_id = ck_acar_id;
	
	//로그아웃 처리를 위한------------------
	String login_time 	= Util.getLoginTime();		//로그인시간
	String ip 		= request.getRemoteAddr(); 	//로그인IP
	
	
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String m_st 	= request.getParameter("m_st")		==null?"22":request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")		==null?"01":request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")		==null?"01":request.getParameter("m_cd");	
	String url 	= request.getParameter("url")		==null?"":request.getParameter("url");
	
		
	UserMngDatabase umd = UserMngDatabase.getInstance();	
		
	//사용자정보	
	UsersBean user_bean = umd.getUsersBean(acar_id);
		
	//중메뉴
	Vector	 au_menu = umd.getAuthMaMeAll1(acar_id, m_st);//getAuthMaMeAllAgent
	int aumenu_size = au_menu.size();
	
	//전체 공지사항 조회
	String gubun 	= request.getParameter("gubun")==null?"agent":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")==null?"8":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	AncBean a_r [] = oad.getAncAll2( gubun,  gubun_nm,  gubun1,  ck_acar_id);
	
	//에이전트 견적만인 사용자중 공지사항 미공개
	String main_yn="Y";
	
	if(ck_acar_id.equals("000348")){
		main_yn="N";
	}	
%>

<html>
<head>
<title>FMS(110)</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/sub.css">

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style>
@font-face {
    font-family: 'icomoon';
    src:    url('/fms2/lib/fonts/icomoon.eot?rtmp4o');
    src:    url('/fms2/lib/fonts/icomoon.eot?rtmp4o#iefix') format('embedded-opentype'),
        url('/fms2/lib/fonts/icomoon.ttf?rtmp4o') format('truetype'),
        url('/fms2/lib/fonts/icomoon.woff?rtmp4o') format('woff'),
        url('/fms2/lib/fonts/icomoon.svg?rtmp4o#icomoon') format('svg');
    font-weight: normal;
    font-style: normal;
}
@font-face {
  font-family: 'Nanum Square';
  font-style: normal;
  font-weight: 400;
  src: url(/fms2/menu/font/NanumSquareR.eot);
  src: local('Nanum Square Regular'),
       local('NanumSquareR'),
       url(/fms2/menu/font/NanumSquareR.eot?#iefix) format('embedded-opentype'),
       url(/fms2/menu/font/NanumSquareR.woff2) format('woff2'),
       url(/fms2/menu/font/NanumSquareR.woff) format('woff'),
       url(/fms2/menu/font/NanumSquareR.ttf) format('truetype');
}

@font-face {
  font-family: 'Nanum Square';
  font-style: bold;
  font-weight: 700;
  src: url(/fms2/menu/font/NanumSquareB.eot);
  src: local('Nanum Square Bold'),
       local('NanumSquareB'),
       url(/fms2/menu/font/NanumSquareB.eot?#iefix) format('embedded-opentype'),
       url(/fms2/menu/font/NanumSquareB.woff2) format('woff2'),
       url(/fms2/menu/font/NanumSquareB.woff) format('woff'),
       url(/fms2/menu/font/NanumSquareB.ttf) format('truetype');
}
[class^="icon-"], [class*=" icon-"] {
    /* use !important to prevent issues with browser extensions that change fonts */
    font-family: 'icomoon' !important;
    speak: none;
    font-style: normal;
    font-weight: normal;
    font-variant: normal;
    text-transform: none;
    line-height: 1;

    /* Better Font Rendering =========== */
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}
.icon-user:before {
    content: "\e971";
}
.open{
	background-color:#f6f6f6;
}

.open b{
	color:#349BD5 !important;
}
.topmenu b{
	color:#fff;
	font-family:'Nanum Square';
	font-size:14px;
}
.qlink{
	width:120px;
	border:1px solid #349BD4;
	background-position:100px;
	background-color:#fff;
	background-image:url('/fms2/menu/images/qlink_arrow.png');
  	-webkit-appearance: none; 
  	-moz-appearance: none;
	appearance: none;
	background-repeat:no-repeat;
}
select::-ms-expand {
    display: none;
}
</style>
	
<script language='javascript'>
	 var m_st_t = null;
<!--
	//로그아웃
	function Logout(){
		if(!confirm("로그아웃 하시겠습니까?")){ return; }
		parent.location.href ='./del.jsp?login_time=<%=login_time%>&ip=<%=ip%>';
	}

	//사용자정보 팝업
	function UserUpdate(){				
		var SUBWIN="/fms2/menu/info_u.jsp?user_id=<%=ck_acar_id%>";
		window.open(SUBWIN, "InfoUp", "left=10, top=10, width=900, height=500, scrollbars=yes");
	}		
	
	//연락망
	function tel2(){
		var SUBWIN="./sawon2.jsp";	
		window.open(SUBWIN, "TelUp", "left=10, top=10, width=700, height=700, scrollbars=yes");
	}
	
	//연락망
	function tel3(){
		var SUBWIN="./sawon3_work.jsp";	
		window.open(SUBWIN, "TelUp2", "left=10, top=10, width=900, height=700, scrollbars=yes");
	}
	
	//사이트링크
	function site_link(){
		var SUBWIN="./site_link.jsp";
		window.open(SUBWIN, "SiteUp", "left=10, top=10, width=1024, height=650, scrollbars=yes");
	}
	
	//홈으로
	function Home(){
		$('.topmenu').removeClass("open");
		$('.menu',parent.frames['sub_menu'].document).css("display","none");
		var menuDiv = $("#"+m_st_t,parent.frames['sub_menu'].document);

		if(menuDiv.hasClass("open")){
			parent.document.getElementsByTagName( 'frameset' )[ 0 ].rows = '90,0,*'
			menuDiv.removeClass("open");
		}
		
		var fm = document.form1;
		fm.target= 'd_content';
		fm.action = '/agent/menu/emp_content.jsp';// menu2 추 후 변경할 것
		fm.submit();
	}
	
	//메뉴보기
	function showMenuDepth(m_st){
		if(m_st==1){m_st = "01";
		}else if(m_st==2){m_st = "02";
		}else if(m_st==3){m_st = "03";
		}else if(m_st==4){m_st = "04";
		}else if(m_st==5){m_st = "05";
		}else if(m_st==6){m_st = "06";
		}else if(m_st==7){m_st = "07";
		}else if(m_st==8){m_st = "08";
		}else if(m_st==9){m_st = "09";
		}else if(m_st==10){m_st = "10";
		}else if(m_st==11){m_st = "11";
		}else if(m_st==12){m_st = "12";
		}else if(m_st==13){m_st = "13";
		}else if(m_st==14){m_st = "14";}
		m_st_t = m_st;
		$('.topmenu').removeClass("open");
		
		
		$('.menu',parent.frames['sub_menu'].document).css("display","none");
		var menuDiv = $("#"+m_st,parent.frames['sub_menu'].document);
		var menuHeight = menuDiv.css("height")+20;

		parent.document.getElementsByTagName( 'frameset' )[ 0 ].rows = '90,'+menuHeight+',*'
		
		if(menuDiv.hasClass("open")){
			parent.document.getElementsByTagName( 'frameset' )[ 0 ].rows = '90,0,*'
			menuDiv.removeClass("open");
		}else{
			$('.menu',parent.frames['sub_menu'].document).removeClass("open");
			menuDiv.slideDown();
			menuDiv.addClass("open");
			
			var id = "#" + m_st;
			$(id).addClass("open");
			
		}
	}
 
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" ondragstart="return false" style="min-width:1245px; ">

<form name="form1" method="post" action="">
<input type='hidden' name="url" value="">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='m_id' value="">
<input type='hidden' name='l_cd' value="">
<input type='hidden' name="user_id" value="<%=ck_acar_id%>">
<input type='hidden' name='br_id' value="<%=user_bean.getBr_id()%>">
<input type='hidden' name="c_id" value="">
<input type='hidden' name='client_id' value="">
<input type='hidden' name="accid_id" value="">
<input type='hidden' name="serv_id" value="">
<input type='hidden' name="seq_no" value="">
<table width=100% border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td width=169 height=49 align=center><a href="http://www.amazoncar.co.kr" target=_blank title='아마존카 홈페이지'><img src="/acar/images/logo_1.png" style="margin-left: 30px;"></a></td>
        <td style="margin:auto;text-align:right;" >
            <table width=100%  border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td align='right'>
                        		<!--정보수정 -->
                        		<span class="icon-user" style="margin-right:-10px;"></span>
                                &nbsp;&nbsp;<a href=javascript:UserUpdate() title="개인정보수정"><strong><%=session_user_nm%></strong></a>
                                <!--Logout  -->
        		                &nbsp;&nbsp;<a href="javascript:Logout();" title="Logout">로그아웃</a>
                   				&nbsp;|&nbsp;
                                <!--메인  화면-->
                                <a href="javascript:Home();" title="HOME">HOME</a>
                                &nbsp;|&nbsp;
								<!-- 연락망 -->
								<a href=javascript:tel2(); title='연락망'>연락망</a>
								&nbsp;|&nbsp;
								<!-- 업무연락망 -->
								<a href=javascript:tel3(); title='업무연락망'>업무연락망</a>
								&nbsp;|&nbsp;
								<!-- 사이트링크 -->
								<a href="javascript:site_link();" title='사이트링크'>사이트링크</a>
                    </td>
                    <td width="100">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan='2' valign=top>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td valign=top>
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#349BD5;">
                        	<tr>
                        		<td width="85" height=40>&nbsp;</td>
                        <%
                        for (int i = 0 ; i < aumenu_size ; i++){
                    		Hashtable aumenu = (Hashtable)au_menu.elementAt(i);
                    					
                    		String str = aumenu.get("M_NM").toString();
                        %>	
								<%if(str.equals("계약관리")){%>
								<td align='center' valign='middle' width=100 id="01" class="topmenu"><a href="javascript:showMenuDepth('01');" title='계약관리'><b>계약관리</b></a></td>
								<%}else if(str.equals("계출관리")){%>                    		      
								<td align='center' valign='middle' width=100 id="02" class="topmenu"><a href="javascript:showMenuDepth('02');" title='계출관리'><b>계출관리</b></a></td>
								<%}else if(str.equals("해지관리")){%>
								<td align='center' valign='middle' width=100 id="03" class="topmenu"><a href="javascript:showMenuDepth('03');" title='해지관리'><b>해지관리</b></a></td>
								<%}else if(str.equals("탁송관리")){%>
								<td align='center' valign='middle' width=100 id="04" class="topmenu"><a href="javascript:showMenuDepth('04');" title='탁송관리'><b>탁송관리</b></a></td>
								<%}else if(str.equals("NEW용품관리")){%>
								<td align='center' valign='middle' width=120 id="12" class="topmenu"><a href="javascript:showMenuDepth('12');" title='NEW용품관리'><b>NEW용품관리</b></a></td>
								<%}else if(str.equals("견적시스템")){%>
								<td align='center' valign='middle' width=110 id="05" class="topmenu"><a href="javascript:showMenuDepth('05');" title='견적시스템'><b>견적시스템</b></a></td>
								<%}else if(str.equals("고객관리")){%>
								<td align='center' valign='middle' width=100 id="06" class="topmenu"><a href="javascript:showMenuDepth('06');" title='고객관리'><b>고객관리</b></a></td>
								<%}else if(str.equals("수당관리")){%>
								<td align='center' valign='middle' width=100 id="08" class="topmenu"><a href="javascript:showMenuDepth('08');" title='수당관리'><b>수당관리</b></a></td>
								<%}else if(str.equals("캠페인관리")){%>
								<td align='center' valign='middle' width=110 id="10" class="topmenu"><a href="javascript:showMenuDepth('10');" title='캠페인관리'><b>캠페인관리</b></a></td>
								<%}else if(str.equals("견적사후관리")){%>
								<td align='center' valign='middle' width=120 id="11" class="topmenu"><a href="javascript:showMenuDepth('11');" title='견적사후관리'><b>견적사후관리</b></a></td>
								<%}else if(str.equals("공지사항")){%>
								<%	if(main_yn.equals("Y")){ %>
								<td align='center' valign='middle' width=100 id="09" class="topmenu"><a href="javascript:showMenuDepth('09');" title='공지사항'><b>공지사항</b></a></td>
								<%	}%>
								<%}else if(str.equals("자료실")){%>
								<%	if(main_yn.equals("Y")){ %>
								<td align='center' valign='middle' width=90 id="13" class="topmenu"><a href="javascript:showMenuDepth('13');" title='자료실'><b>자료실</b></a></td>
								<%	}%>
								<%}else{}%>
                    		<%}%>
                    			<td>&nbsp;</td>
                            </tr>
                            <tr>
                            	
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

<script>
	
</script>

</body>
</html>